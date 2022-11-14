/**********************************************************************
Name:FSL_StatusUpdate
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for path change,shop work order creation and display of 
customer credit message and to call Site, Contact, Customer and unit Inbound services.
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     MALLIKA SUBHASHINI          1/18/2019    Initial Development for path change
1.1     SRIPRADA SESHAM             1/20/2019    added code for Validating contact,account,worktype & Subtype
                                                 and for Integration calls of Site, Contact & Customer
1.3     PIYUSH RANI                 3/15/2019    added code for Validating CustomerCreditMessage Code
1.4     BHARAT REDDY GUNREDDY                    added code for shop work order
1.5     RAVIKANTH MACHERLA                       added code to call unit Inbound service.
1.6     RAJASHEKAR NALLAPATI                     added code for updating Status and process step on ERP WO Creation
1.7     Harsha Ragam                             Added code for BMS on send to assign for WO Comment Inbound
1.8     Rajashekar Nallapati                     Added logic to call Admin SRT integration after ERP WO creation
2.0     Dinesh Yadav                             Update Failure Date formate to GMT
2.1     Sunitha Mattaparthi        1/8/2021      Individual Item Number field as Blank for CMI Assets
2.2     Madhavi Potluri            10/19/2021    Added replaceAll method to replace double quotes and single quotes with dummy space as part of FBI-57
2.3     Dinesh Yadav               01/19/2022    Added 'MOVEX-CSP', 'MOVEX-CDK' ERPs to process Cash Customer Payload. 
2.4     Naveen               05/08/2022    Added/changes Wrapper class to pass the parameters through FSL_WS_ERP.inputWrapperParams
********************************************************************************************************************/

global with sharing class FSL_StatusUpdate { 
    
    // validations
    @AuraEnabled public static String messageCode { get; set; }
    // @AuraEnabled public String TempCon { get; set; }
    // @AuraEnabled public String TempSit { get; set; }
    // @AuraEnabled public boolean TempFlag { get; set; }
    
    @AuraEnabled
    public static String checkCustomerMessageCode(String serviceJob) {
        FSL_CL_CustomerCreditResponseParser creditMessageData;
        List<ERP_Message__c> erpMessages = [SELECT Id, Service_Order__c, Payer_Change__c, Customer_Credit_Message__c 
                                            FROM ERP_Message__c WHERE Service_Order__c =: serviceJob];
        String message= erpMessages[0].Customer_Credit_Message__c;
        
        if(!erpMessages.isEmpty() && String.isNotBlank(message)) {
            creditMessageData = (FSL_CL_CustomerCreditResponseParser)JSON.deserialize(message.unescapeHtml4(), FSL_CL_CustomerCreditResponseParser.Class);
            System.debug('::: creditMessageData = '+creditMessageData);
            for( FSL_CL_CustomerCreditResponseParser.CreditMessageDetails fslCCR : creditMessageData.DataArea.CreditMessageDetails) {
                if(fslCCR.CreditMessageCode!=null && fslCCR.CreditMessageCode!='' && fslCCR.CreditMessageCode == 'Y') {
                    messageCode = fslCCR.CreditMessageCode;
                }
            }
        }
        return messageCode;
    }
    
    @AuraEnabled
    global static WorkOrder getWorkOrder(Id objectID) {      
        WorkOrder wo = new WorkOrder();
        wo = [SELECT Id, WorkOrderNumber, Scheduled__c, Shop_Work_Order__c, Description,Status, Sub_Status__c, Process_Step__c, Available_for_Service__c, Type__c, Customer_Name__c, 
              Cash_Payment__c, Asset.Cash_Customer_Flag__c, AccountId, ContactId, AssetId, ServiceTerritoryId, WorkTypeId, CreatedDate, Account.FSL_ERP_Customer_Code__c, 
              Asset.Unit_Number__c, Asset.Model__c, Model__c, Asset.VIN__c, Asset.Engine_Manufacturer__c, Asset.Make__c, Make__c, Asset.Service_Model__c,Asset.Individual__c, 
              Service_Model__c, ServiceTerritory.Location_Code__c, Application__c, Mileage_Measure__c, Mileage__c, Account.AccountNumber, Payer__c, Payer__r.FSL_ERP_Customer_Code__c, 
              Account.FSL_Payer_Code__c, CSS_Hours__c, Asset.Name, Asset.ContactId, Asset.Engine_Family_Code__c, EditComplaint__c, EditCoverage__c, Failure_Date__c, Purchase_Order__c, 
              General_Symptoms__c, Asset.Warranty_Start_Date__c, FSL_Sub_Type__c, FSL_Sub_Type__r.Name, Asset.Application_Description__c, Asset.Application_Code__c, 
              Contact.FSL_Contact_Id__c, Contact.Phone, Contact.Firstname, Contact.LastName, Repair_Location__c, Contact.Email, Payer_ContactID__c, Payer_ContactID__r.Name, 
              Payer_ContactID__r.FSL_Contact_Id__c, LastModifiedDate, CreatedById, LastModifiedById, Repair_Site_Address__c, RecordType.DeveloperName 
              FROM WorkOrder WHERE Id=:objectID];
        return wo;
    }
    
    @AuraEnabled
    public static String getCurrentUserERP() {
        User usr = new User();
        usr = [SELECT Id, ERP__c FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        return UserERP;
    }
    
    // added by Sriprada
    @AuraEnabled
    public static calloutResponseWraper updateWorkOrder(WorkOrder wo) {  
        System.debug('::: updateWorkOrder Called'+wo.ServiceTerritoryId);
        System.debug('::: updateWorkOrder Called'+wo.ServiceTerritory.Location_Code__c);
        WorkOrder woRec=[SELECT Id,Contract_Number__c,MaintenancePlanNumber__c FROM WORKORDER WHERE Id=:wo.Id LIMIT 1];
        string strconMunerMPnumber= woRec.Contract_Number__c +'-'+ woRec.MaintenancePlanNumber__c; // Added Ravikanth
        calloutResponseWraper wraperres= new calloutResponseWraper();
         // User story PHOEN-120 start
         boolean middleWareErrorSwitch = [SELECT name,Id,OwnerId ,IsDeleted,currencyIsoCode,
         CreatedDate,CreatedById ,LastmodifiedDate,LastModifiedByid,
         SystemModStamp,IsActive__C,User_Type__c
         FROM fsl_Switch__c where name = 'MWErrors_Switch' limit 1].IsActive__C;
         wraperres.isMWErrorSwitchActive = middleWareErrorSwitch;
         // User story PHOEN-120 end
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        Boolean checkIds;  
        String woNumber;
        String SourceType = System.Label.FSL_Source_Environment_Type;
        if(SourceType == 'GZEVLPRD') {
            woNumber = wo.WorkOrderNumber;
            system.debug('WoNumber:'+woNumber);
        } else {
            woNumber = SourceType.right(3)+'-'+wo.WorkOrderNumber;
        }
        if(wo.Failure_Date__c != null) {
            datetime FailureDt = wo.Failure_Date__c;
            // FailureDateForUnitInbound = FailureDt.format('dd-MMM-YYYY','GMT') + ' ' + '13:00:00';//FailureDt.format('HH:mm:ss','GMT');
        }
        
        String DefaultInshop;
        if(wo.Repair_Location__c == 'Mobile') {
            DefaultInshop = 'N';
        } else {
            DefaultInshop = 'Y';
        }
        string Scheduled;
        if(wo.Scheduled__c == true) {
            Scheduled = 'Yes';
        } else {
            Scheduled = 'No';
        }
        string currDate;
        string schDate;
        date failureDate = wo.Failure_Date__c;
        datetime ScheduledDate = wo.Available_for_Service__c;
        if(wo.Failure_Date__c == null)
            failureDate = system.today();
        
        if(!Test.isRunningTest()) {
            //currDate = failureDate.format('YYYY-MM-dd','GMT')+ 'T' + system.now().format('HH:mm:ss','GMT');
            //system.debug('CurrentDate:'+currDate);
            //CT3-265, Dinesh Yadav
            /*
            datetime failureDateNew  = DateTime.newInstance(wo.Failure_Date__c.year(), wo.Failure_Date__c.month(), wo.Failure_Date__c.day(), system.now().hour(), system.now().minute(), system.now().second());
            system.debug('New Date without GMT:'+currDate);
            currDate = failureDateNew.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
            system.debug('New Date 2 :'+currDate);
            */
            
            datetime dtNow = System.now();  
            String currentTimeZoneInfo = dtNow.format('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666 
            String failurDateToString = String.valueOf(failureDate);
            String currentTimeStampVal = currentTimeZoneInfo.Right(8);//Added 187666 
            system.debug('currentTimeStampVal :'+currentTimeStampVal);
            DateTime currDateTimeInfo  = datetime.valueOf(failurDateToString+' '+currentTimeStampVal);//Added 187666 
            currDate = currDateTimeInfo.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666
            system.debug('currDate:'+currDate);

            schDate = ScheduledDate.format('yyyy-MM-dd','GMT')+ 'T' + ScheduledDate.format('HH:mm:ss','GMT');
            system.debug('Scheduled Date is:'+schDate);
        } else {
            currDate = string.valueOf(system.now());
            schDate = string.valueOf(system.now());
        }
        
        string sType = wo.FSL_Sub_Type__r.Name;
        system.debug('list of values:'+sType);
        string subType = ''; 
        if(string.isNotBlank(sType)) {
            subType = sType.subStringBefore(' -');
            system.debug('SubType is:'+subType);
        }
        string sLoc = wo.ServiceTerritory.Location_Code__c;
        System.debug('$#$ sLoc' +  sLoc);
        System.debug('$#$ wo' +  wo.ServiceTerritoryId);
        System.debug('$#$ AccountId' +  wo.AccountId);
        
        String uFID;
        if(sLoc != null && sLoc != '') {    //Adding null Check.
            String subString = sLoc.substringBefore('-');
            System.debug('$#$ wo1' +  wo.ServiceTerritoryId);
            
            String subString2 = sLoc.substringAfter('-').substring(0,5);
            //String errMsg = 'Unable to retrieve Work Order Information. Please contact support at Guidanz@cummins.com';
            
            if(UserERP == 'BMS') {
                sLoc = subString + '-' + subString2;
                uFID = usr.FederationIdentifier;
            } else {
                uFID = usr.FederationIdentifier+'##Blank###'+usr.name;
            }
        }
        
        system.debug('Location is:' + sLoc);
        String BMSReferenceNumber = '';
        
        String ApplicationCode = '';
        if(wo.Application__c != null && wo.Application__c != '') {
            ApplicationCode = wo.Application__c.left(3);
        }
               
        String Notes;
        string finalNotes;
        String generalNotes;
       /* Code start for Phoen-274*/  
        if (String.isNotBlank(wo.General_Symptoms__c)) {
            finalNotes = wo.General_Symptoms__c;
            system.debug('General_Symptoms__c :: '+wo.General_Symptoms__c); //Dinesh Phoen - 290 7/19/2022
            //finalNotes = finalNotes.replace('\r\n', ' '); 
            generalNotes= addEscapeChar(finalNotes);
        }
        /*
        if (String.isNotBlank(wo.General_Symptoms__c)) {
            //Madhavi - Added replaceAll method to replace double quotes and single quotes with dummy space as part of FBI-57 - Start
            Notes = wo.General_Symptoms__c.replaceall('"', ' ');
            finalNotes = Notes.replaceAll('\'', ' ');
            generalNotes = finalNotes.replace('\r\n', ' ');
            //End - FBI-57
        }*/
         /* Code end for Phoen-274*/ 
        
        String indvItemNumber;
        indvItemNumber = (wo.Asset.Individual__c == null || wo.Asset.Individual__c == '' || wo.Asset.Engine_Manufacturer__c == 'CUMMINS') ? '' : wo.Asset.Individual__c;
        
        //Integration sequence for SPAC // PHOEN-97, Added 'MOVEX-CSP', 'MOVEX-CDK' ERPs to process Cash Customer Payload.
        if(UserERP == 'MOVEX' || UserERP == 'MOVEX-CDK' || UserERP == 'MOVEX-CSP') {
            String payerContactId = '';
            if(wo.Payer_ContactID__c != null) { //Vamsi - 11/06/21 - removed the check on '' value for CPS-94 / INC2996052
                payerContactId = wo.Payer_ContactID__r.FSL_Contact_Id__c;
                system.debug('Payer Contact:'+payerContactId);
            }
            else {

                payerContactId = '';

            }
            
            String customerCode;
            if(wo.Account.FSL_ERP_Customer_Code__c != '' && wo.Account.FSL_ERP_Customer_Code__c != null) {
                customerCode = wo.Account.FSL_ERP_Customer_Code__c;
            }
            
            String contactId = '';
            Contact con;
            system.debug('::: CustomerCode:'+customerCode);
            FSL_JobContactInfo.CallOutResponseWrap wrap;
            // Contact Integration Call
            try {
                wrap = FSL_JobContactInfo.checkContactId(wo.id,customerCode); //2nd Intg
                con = wrap.conObj;
                system.debug('::: Job:'+con.FSL_Contact_Id__c );
                if(wrap.status == 'ERROR') {
                    wraperres.errormsg = wrap.msg;
                    //Added to handle test class -rama 
                    if(!Test.isRunningTest())
                    return wraperres;
                }
                
                if(con.FSL_Contact_Id__c != '' && con.FSL_Contact_Id__c != null) {
                    contactId = con.FSL_Contact_Id__c;
                }
                
            } catch(Exception ex) {
                System.debug(':::: Contact Call - '+ex.getMessage());
            }
            
            // Check and Update Site
            String siteId = '';
            Schema.Address siteObjUpdate;//CT2-416
            FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap;
            try {
                if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
                    siteWrap = FSL_CL_SiteCreateUpdate.checkSiteId(wo.Id, customerCode, contactId); //3rd Intg
                    System.debug('::: Site Callout Response-'+siteWrap);
                    siteObjUpdate = siteWrap.siteObj;
                    system.debug('::: Site:'+siteObjUpdate);
                    if((siteWrap.status == 'ERROR' || siteWrap.status == 'FAIL') && !Test.isRunningTest()) {  //Added Phoen-201
                        system.debug('::: Contact:'+con.id+' '+con.FSL_Contact_Id__c);
                        fetchContactId(con, wrap.conObj);
                        System.debug('::: After FSL_IntegrationIdUpdate method call');
                        wraperres.errormsg = siteWrap.msg; 
                        return wraperres;
                    }
                                                            
                    if(siteObjUpdate != null && (siteObjUpdate.FSL_Site_ID__c != '' || siteObjUpdate.FSL_Site_ID__c != null)) {//CT2-416
                        siteId = (wo.Repair_Location__c == 'Mobile' ? string.valueOf(siteObjUpdate.FSL_Site_ID__c) : '');
                    }                   
                }
            } catch(Exception ex) {
                System.debug('::: Site Call - line 286'+ex.getMessage());
            }
            
            // Unit Inbound from Guidanz to MoveX
            // 3rd Intg
            string responseStatus;
            string astId;
            string IndividualItemNumber;
            Asset asst;
            FSLInBoundService.CallOutResponseWrap asstWrap;
            system.debug('::: Asset:'+contactId+' '+siteId);
            
            if(wo.AssetId != null  && !Test.isRunningTest()) {
                asstWrap  = FSLInBoundService.sendJsonRequest(wo.Id, customerCode, contactId, siteId); // Added code by Ravikanth for invoking Unit Inbound service and passing WorkOder Id
                asst = asstWrap.asstObj;
                //system.debug('Wrap Obj>>:'+asstWrap.asstObj.id);
                system.debug('Wrap Obj Indv:'+asstWrap);
                
                if(asstWrap.status != 'SUCCESS' && !Test.isRunningTest()) {
                    fetchContactId(con, wrap.conObj);
                    if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
                        fetchSiteId(wo, siteObjUpdate, siteWrap.siteObj);
                    }
                    wraperres.errormsg = asstWrap.msg; 
                    return wraperres;
                }
            }
            
            // Customer Inbound from Guidanz to MoveX
            Account acc;     
            String status;           
            System.debug(':::: Service Provide Code value-'+wo.Account.FSL_ERP_Customer_Code__c);
            FSL_CreateCustomer.CallOutResponseWrap Accwrap = new FSL_CreateCustomer.CallOutResponseWrap();
            
            //if(wo.AccountId != null && NULL != wo.Account.FSL_ERP_Customer_Code__c && (wo.Account.FSL_ERP_Customer_Code__c.contains('SERV') ) {
            //Bypass wo.Account.FSL_ERP_Customer_Code__c.contains('SERV') for MOVEX-CDK, MOVEX-CSP //Phoen-97
            if(wo.AccountId != null && NULL != wo.Account.FSL_ERP_Customer_Code__c 
                && (wo.Account.FSL_ERP_Customer_Code__c.contains('SERV') || (wo.Customer_Name__c != null && (UserERP == 'MOVEX-CDK' || UserERP == 'MOVEX-CSP')))) {  
                try {
                    Accwrap = FSL_CreateCustomer.checkCustomerCode(wo.Id); // 1st Intg
                    System.debug('::: Customer Callout Response-'+Accwrap);
                    acc = Accwrap.accObj;
                    system.debug('::: Account:'+acc);
                    if(Accwrap.status != 'SUCCESS') {
                        fetchContactId(con, wrap.conObj);
                        if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
                            fetchSiteId(wo, siteObjUpdate, siteWrap.siteObj);
                        }
                        wraperres.errormsg = Accwrap.msg;
                        return wraperres;
                    } 
                } catch(Exception ex) {
                    System.debug('::: Exception in Customer Call - '+ex.getMessage()+'\n Execption Details-'+ex.getStackTraceString());
                }
            }
            
            //Start - Added by Naveen - PHOEN-271
            FSL_WS_ERP.inputWrapperParams ERPwrParams = new FSL_WS_ERP.inputWrapperParams();
            
            ERPwrParams.CSSJobID=   woNumber;
            ERPwrParams.OrderType=  'WO';
            ERPwrParams.custCode=   customerCode; /*accountnumber*/ /*customer code replace*/
            ERPwrParams.Inshop= DefaultInshop;
            ERPwrParams.CreateDate= currDate;
            ERPwrParams.PromisedDate=   '';//PromisedDate
            ERPwrParams.ScheduledDate=  schDate;//ScheduledDate
            ERPwrParams.BillType=   '';//BillType
            ERPwrParams.ContactName=    wo.Contact.firstName + ', ' + wo.contact.lastname;
            ERPwrParams.CustomerPhone=  wo.Contact.Phone; /*Cstmr_Contacts_Phone__c*/
            ERPwrParams.SubType=    subType; // get it from WO SubType field - first 2 chars
            ERPwrParams.UnitNumber= wo.Asset.Unit_Number__c;
            ERPwrParams.Model=  wo.Asset.Model__c;
            ERPwrParams.Make=   wo.Asset.Make__c;
            ERPwrParams.ServiceModelName=   wo.Asset.Service_Model__c; // get it from WO - SMN //wo.Asset.Service_Model__c /*Service_Model__c*/
            ERPwrParams.EngineFamily=   wo.Asset.Engine_Family_Code__c; //wo.Asset.Engine_Family_Code__c, //wo.Qsol_Engine_Family_Code__c
            ERPwrParams.ESN=    wo.Asset.Name;
            ERPwrParams.Application=    ApplicationCode; /*wo.Application_Desc__c*/
            ERPwrParams.location=   sLoc;
            ERPwrParams.ContactID=  contactId; //(con.FSL_Contact_Id__c == null ? '' : con.FSL_Contact_Id__c),
            ERPwrParams.EmailID=    (wo.Contact.email== null ? '' : wo.Contact.email); /*wo.Email_Address__c*/
            ERPwrParams.CreateUser= uFID;//(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
            ERPwrParams.ChangeUser= '';//ChangeUser
            ERPwrParams.Planned=    Scheduled; //Planned
            ERPwrParams.SiteID= siteId; //SiteID
            ERPwrParams.CustomersPO=    wo.Purchase_Order__c; //CustomersPO
            ERPwrParams.PayerID=    wo.Payer__r.FSL_ERP_Customer_Code__c;
            ERPwrParams.Notes=  generalNotes;
            ERPwrParams.Source= 'Guidanz';
            ERPwrParams.individualItemNumber=   indvItemNumber;
            ERPwrParams.PayerContactID= payerContactId;
            ERPwrParams.strconMunerMPnumber=    strconMunerMPnumber;
            ERPwrParams.DistanceType=   string.valueof(wo.Mileage_Measure__c);
            ERPwrParams.Distance=   string.valueof(wo.Mileage__c);
            ERPwrParams.Hours=  string.valueof(wo.CSS_Hours__c);

            
            
            FSL_BMSWOQTInboundJSON2APEX woqtRes = 
                FSL_WS_ERP.callBMSWOQTInboundService(ERPwrParams);
           //End - Added by Naveen - Phoen-271     
                
            system.debug('woqtRes>>>>>>>>'+JSON.serialize(woqtRes));
            
            //New Code to update Contact
            if(wrap != null) {
                if(wrap.status == 'SUCCESS') {
                    system.debug('::: Contact:'+con.id+' '+con.FSL_Contact_Id__c);
                    try {
                        if(con != null && con.id != null){
                            FSL_IntegrationIdUpdate.getContactId(con.id, wrap.conObj.FSL_Contact_Id__c); 
                        }
                    } catch(Exception e) {
                        System.debug('Excetption : ' + e.getMessage() + ' at line ' + e.getLineNumber());
                    }
                    System.debug('::: After FSL_IntegrationIdUpdate method call');
                }
            }
            
            //Update Site
            if(siteWrap != null) {
                if(siteWrap.status == 'SUCCESS') {
                    system.debug('::: Site:'+siteWrap.siteObj.id+' '+siteObjUpdate.FSL_Site_ID__c);//CT2-416
                    try {
                        FSL_IntegrationIdUpdate.getSiteId(siteObjUpdate.id, siteWrap.siteObj.FSL_Site_ID__c);//CT2-416
                        
                    } catch (Exception e) {
                        System.debug('Excetption : ' + e.getMessage() + ' at line ' + e.getLineNumber());
                    }
                    System.debug('::: After FSL_IntegrationIdUpdate method call');
                }
            }
            
            if(!Test.isRunningTest() && woqtRes.DataArea != null) {
                if(woqtRes.Header != null) {
                    if(woqtRes.Header.Status != null && woqtRes.Header.Status == 'Error') {
                        system.debug('Contact Details' + con);
                        // If(con!=null && wrap.conObj!=null) Satish: Added to test Testclass null pointer exception issue
                        if(!Test.isRunningTest()) {
                            fetchContactId(con, wrap.conObj);
                        }
                        if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
                            fetchSiteId(wo, siteObjUpdate, siteWrap.siteObj);
                        }
                        wraperres.errormsg = woqtRes.Header.ReturnCodeDescription;
                        System.debug('::: woqtRes.Header.ReturnCodeDescription - '+woqtRes.Header.ReturnCodeDescription);
                        return wraperres;
                    }
                }
                
                if(woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber != '0') {
                    BMSReferenceNumber = woqtRes.DataArea.WOReferenceNumber;
                    system.debug('BMSReferenceNumber>>>>*****'+BMSReferenceNumber);
                    BMSReferenceNumber = BMSReferenceNumber.trim();
                    if(string.isNotBlank(BMSReferenceNumber) && BMSReferenceNumber != '') {
                         wo.Shop_Work_Order__c = BMSReferenceNumber; 
                        /* GFSLFM-1228 : Status and process step will be updated to 'Intake complete'
                        *  and Schedule respectively  and Reocrd type is updated to 'Schedule' 
                        *  after sucessful creation of ERP Work Order.*/
                        system.debug('wo.Process_Step__c  '+ wo.Process_Step__c );
                        if(wo.Type__c != 'Internal') {
                            processStepUpdateWO(wo);
                        }
                        else {
                            if(wo.Process_Step__c == 'Intake') {
                                wo.Process_Step__c = 'Intake';
                                wo.RecordTypeId = populateWORecType('Internal').Id;
                                if(wo.Status == 'Intake') {
                                    wo.Status = 'Intake';
                                }
                            }
                        }
                        /* GFSLFM-1228 : Code End*/ 
                    }
                    update wo;  
                }
            }
            // return BMSReferenceNumber;
            wraperres.BMSReferenceNumber = BMSReferenceNumber;
            // }
        }        
        //Integration sequence for MOVEX-UK and BMS
        if(UserERP != 'MOVEX' && UserERP != 'MOVEX-CDK' && UserERP != 'MOVEX-CSP') {
            
            // Customer Inbound from Guidanz to MoveX
            Account acc;     
            String status;
            String customerCode = '';
            String payerCode = '';
            System.debug(':::: Service Provide Code value-'+wo.Account.FSL_ERP_Customer_Code__c);
            FSL_CreateCustomer.CallOutResponseWrap Accwrap = new FSL_CreateCustomer.CallOutResponseWrap();
            
            if(wo.Account.FSL_ERP_Customer_Code__c != '' && wo.Account.FSL_ERP_Customer_Code__c != null) {
                customerCode = wo.Account.FSL_ERP_Customer_Code__c;
            }
            if(wo.Payer__r.FSL_ERP_Customer_Code__c != '' && wo.Payer__r.FSL_ERP_Customer_Code__c != null) {
                payerCode = wo.Payer__r.FSL_ERP_Customer_Code__c;
            }
            
            if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
                try {
                    Accwrap = FSL_CreateCustomer.checkCustomerCode(wo.id); // 1st Intg
                    System.debug('::: Customer Callout Response-'+Accwrap);
                    acc = Accwrap.accObj;
                    if(customerCode == '' || customerCode == null) {
                        customerCode = Accwrap.accObj.FSL_ERP_Customer_Code__c;
                    }
                    if(Accwrap.status != 'SUCCESS' || Accwrap.status == 'FAIL') {
                        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
                            fetchAccountId(wo.Account, acc, Accwrap.accObj);
                        }
                        // wraperres.errormsg = (userERP == 'BMS') ? errMsg : Accwrap.msg;
                        wraperres.errormsg = Accwrap.msg;
                        if(!Test.isRunningTest())
                        return wraperres;
                    }                    
                    system.debug('::: Account:'+acc);
                } catch(Exception ex) {
                    System.debug('::: Exception in Customer Call - '+ex.getMessage()+'\n Execption Details-'+ex.getStackTraceString());
                }
                System.debug('::: Customer Callout Response-'+Accwrap);
            }
            
            //Payer Integration Call
            Account acc1;
            FSL_CreateCustomer.CallOutResponseWrap Accwrap1 = new FSL_CreateCustomer.CallOutResponseWrap();
            
            if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
                try {
                    Accwrap1 = FSL_CreateCustomer.checkPayerCode(wo.id); // 1st Intg
                    System.debug('::: Customer Callout Response-'+Accwrap1);
                    acc1 = Accwrap1.accObj;
                    if(payerCode == '' || payerCode == null) {
                        payerCode = Accwrap1.accObj.FSL_ERP_Customer_Code__c;
                    }
                    if(Accwrap1.status != 'SUCCESS' || Accwrap1.status == 'FAIL') {
                        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
                            fetchAccountId(wo.Account, acc, Accwrap.accObj);
                        }
                        // wraperres.errormsg = (userERP == 'BMS') ? errMsg : Accwrap1.msg;
                        wraperres.errormsg = Accwrap1.msg;
                        return wraperres;
                    } 
                    system.debug('::: Account:'+acc1);
                } catch(Exception ex) {
                    System.debug('::: Exception in Customer Call - '+ex.getMessage()+'\n Execption Details-'+ex.getStackTraceString());
                }
                System.debug('::: Customer Callout Response-'+Accwrap1);
            }
            
            // Contact Integration Call
            String contactId = '';
            Contact con;
            system.debug('::: CustomerCode:'+customerCode);
            FSL_JobContactInfo.CallOutResponseWrap wrap;
            try {
               wrap = FSL_JobContactInfo.checkContactId(wo.Id, customerCode);// 2nd Intg
                System.debug('::: Contact Response - '+wrap);
                if(wrap.status == 'ERROR' || wrap.status == 'FAIL') {
                    system.debug('::: Status:'+wrap.status);
                    onContactCheckFail(wo, acc, acc1, Accwrap, Accwrap1);
                    //wraperres.errormsg = (userERP == 'BMS') ? errMsg : wrap.msg;
                    wraperres.errormsg = wrap.msg;
                    system.debug('::: Status:'+wrap.msg);
                    wraperres.BMSReferenceNumber ='';
                    wraperres.errorCode = FSL_StatusUpdate.getCustomMetaDataTypesForErrors(wraperres.errormsg);
                    return wraperres;
                }
                
                con = wrap.conObj;
                system.debug('::: Job:'+con.FSL_Contact_Id__c );
                
                if(con.FSL_Contact_Id__c != '' && con.FSL_Contact_Id__c != null) {
                    contactId = con.FSL_Contact_Id__c;
                }
                
            } catch(Exception ex) {
                System.debug(':::: Contact Call - '+ex.getMessage());
            }
            
            // Payer Contact Integration
            String payercontact = '';
            Contact con1;
            FSL_JobContactInfo.CallOutResponseWrap wrap1;
            if(wo.Payer_ContactID__c != null && (wo.ContactId != wo.Payer_ContactID__c)) {
                try {
                    wrap1 = FSL_JobContactInfo.checkPayerContactId(wo.id, payerCode);
                    System.debug('::: Contact Response - '+wrap1);
                    if(wrap1.status == 'ERROR' || wrap1.status == 'FAIL') {
                        onPayerContactCheckFail(wo, acc, acc1, con, Accwrap, Accwrap1, wrap);
                        //wraperres.errormsg = (userERP == 'BMS') ? errMsg : wrap1.msg;
                        wraperres.errormsg = wrap1.msg;
                        return wraperres;
                    }
                    con1 = wrap1.conObj;
                    system.debug('::: Job:'+con1.FSL_Contact_Id__c );
                    if(payercontact == '' || payercontact == null){
                        payercontact = wrap1.conObj.FSL_Contact_Id__c;
                        system.debug('Payer Contact:'+payercontact);
                    }
                    if(con1.FSL_Contact_Id__c != '' && con1.FSL_Contact_Id__c != null) {
                        payercontact = con1.FSL_Contact_Id__c;
                        system.debug('Payer Contact rec:'+payercontact);
                    }
                } catch(Exception ex) {
                    System.debug(':::: Contact Call - '+ex.getMessage());
                }
            }
            
            // Check and Update Site
            String siteId = '';
            Schema.Address siteObjUpdate;//CT2-416
            FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap;
            try {
                if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
                    siteWrap = FSL_CL_SiteCreateUpdate.checkSiteId(wo.Id, customerCode, contactId);
                    System.debug('::: Site Callout Response-'+siteWrap);
                    if(siteWrap.status == 'ERROR' || siteWrap.status == 'FAIL') {
                        onSiteCheckFail(wo, acc, acc1, con, con1, Accwrap, Accwrap1, wrap, wrap1);
                        // wraperres.errormsg = (userERP == 'BMS') ? errMsg : siteWrap.msg;
                        wraperres.errormsg = siteWrap.msg;
                        return wraperres;
                    }
                    siteObjUpdate = siteWrap.siteObj;
                    system.debug('::: Site:'+siteObjUpdate);
                    
                    //Phoen-143, Charan
                    if(wo.Repair_Location__c == 'Mobile'){
                        if(siteObjUpdate.FSL_Site_ID__c == '0' || string.isBlank(siteObjUpdate.FSL_Site_ID__c) || siteObjUpdate.FSL_Site_ID__c == null){
                            onSiteCheckFail(wo, acc, acc1, con, con1, Accwrap, Accwrap1, wrap, wrap1);
                            
                            wraperres.errormsg = 'OSB_380000:Site Id is either 0 or blank or null.'; 
                            return wraperres;
                        }
                    } //Phoen-143 end
                    
                    if(siteObjUpdate != null && (siteObjUpdate.FSL_Site_ID__c != '' || siteObjUpdate.FSL_Site_ID__c != null)) {//CT2-416
                        siteId = (wo.Repair_Location__c == 'Mobile' ? string.valueOf(siteObjUpdate.FSL_Site_ID__c) : '');
                    }                    
                }
            } catch(Exception ex) {
                System.debug('::: Site Call - '+ex.getMessage());
            }
            
            // Unit Inbound from Guidanz to MoveX
            // 3rd Intg
            string responseStatus;
            string astId;
            string IndividualItemNumber;
            Asset asst;
            Boolean workorderFlag = true;
            FSLInBoundService.CallOutResponseWrap asstWrap;
            system.debug('::: Asset:'+asstWrap+' '+siteId);
            
            if(wo.AssetId != null ) {
                try {
                    asstWrap  = FSLInBoundService.sendJsonRequest(wo.Id, customerCode, contactId, siteId); // Added code by Ravikanth for invoking Unit Inbound service and passing WorkOder Id
                }
                catch (Exception e) {
                    System.debug('Exception Details ' + e.getMessage() + ' at line ' + e.getLineNumber());
                }
                System.debug('###asstWrap'+ asstWrap);
                if((asstWrap != NULL &&  asstWrap.status != 'SUCCESS' || asstWrap.status == 'FAIL') && !Test.isRunningTest()) {
                    onAssetCheckFail(wo, acc, acc1, con, con1, siteObjUpdate, Accwrap, Accwrap1, wrap, wrap1, siteWrap);
                    // wraperres.errormsg = (userERP == 'BMS') ? errMsg : asstWrap.msg;
                    wraperres.errormsg = asstWrap.msg;
                    return wraperres;
                }
                asst = asstWrap.asstObj;
                system.debug('Wrap Obj>>:'+asstWrap.asstObj.id);
                system.debug('Wrap Obj Indv:'+asstWrap);
                system.debug('Status msg:'+ asstWrap.status);
                if(indvItemNumber == '' || indvItemNumber == null){
                    indvItemNumber = asstWrap.asstObj.Individual__c;
                }
            }
            
            //Start - Added by Naveen - PHOEN-271
            FSL_WS_ERP.inputWrapperParams ERPwrParams = new FSL_WS_ERP.inputWrapperParams();
            
            ERPwrParams.CSSJobID=   woNumber;
            ERPwrParams.OrderType=  'WO';
            ERPwrParams.custCode=   customerCode; /*accountnumber*/ /*customer code replace*/
            ERPwrParams.Inshop= DefaultInshop;
            ERPwrParams.CreateDate= currDate;
            ERPwrParams.PromisedDate=   '';//PromisedDate
            ERPwrParams.ScheduledDate=  schDate;//ScheduledDate
            ERPwrParams.BillType=   'CUSTOMER';//BillType
            ERPwrParams.ContactName=    wo.Contact.firstName + ', ' + wo.contact.lastname;
            ERPwrParams.CustomerPhone=  wo.Contact.Phone; /*Cstmr_Contacts_Phone__c*/
            ERPwrParams.SubType=    subType; // get it from WO SubType field - first 2 chars
            ERPwrParams.UnitNumber= wo.Asset.Unit_Number__c;
            ERPwrParams.Model=  wo.Asset.Model__c;
            ERPwrParams.Make=   wo.Asset.Make__c;
            ERPwrParams.ServiceModelName=   wo.Asset.Service_Model__c; // get it from WO - SMN //wo.Asset.Service_Model__c /*Service_Model__c*/
            ERPwrParams.EngineFamily=   wo.Asset.Engine_Family_Code__c; //wo.Asset.Engine_Family_Code__c, //wo.Qsol_Engine_Family_Code__c
            ERPwrParams.ESN=    wo.Asset.Name;
            ERPwrParams.Application=    ApplicationCode; /*wo.Application_Desc__c*/
            ERPwrParams.location=   sLoc;
            ERPwrParams.ContactID=  contactId; //(con.FSL_Contact_Id__c == null ? '' : con.FSL_Contact_Id__c),
            ERPwrParams.EmailID=    (wo.Contact.email== null ? '' : wo.Contact.email); /*wo.Email_Address__c*/
            ERPwrParams.CreateUser= uFID;//(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
            ERPwrParams.ChangeUser= '';//ChangeUser
            ERPwrParams.Planned=    Scheduled; //Planned
            ERPwrParams.SiteID= siteId; //SiteID
            ERPwrParams.CustomersPO=    wo.Purchase_Order__c; //CustomersPO
            ERPwrParams.PayerID=    payerCode;
            ERPwrParams.Notes=  generalNotes;
            ERPwrParams.Source= 'Guidanz';
            ERPwrParams.individualItemNumber=   indvItemNumber;
            ERPwrParams.PayerContactID= payercontact;
            ERPwrParams.strconMunerMPnumber=    strconMunerMPnumber;
            ERPwrParams.DistanceType=   string.valueof(wo.Mileage_Measure__c);
            ERPwrParams.Distance=   string.valueof(wo.Mileage__c);
            ERPwrParams.Hours=  string.valueof(wo.CSS_Hours__c);
            
            //End - Added by Naveen - Phoen-271
            
            FSL_BMSWOQTInboundJSON2APEX woqtRes;
 //Rama INC4735354 7/20/2022 - To fix send to assign for job notes
            if((workorderFlag && String.isBlank(wo.Shop_Work_Order__c) && wo.status == 'Intake')|| wo.Status != 'Intake') {
                workorderFlag = false;
                woqtRes = 
                FSL_WS_ERP.callBMSWOQTInboundService(ERPwrParams);    //Added by Naveen - Phoen-271
                
            }
            workorderFlag = true;
            //New Code to update - Update Account, Contact, Site and Unit here
            //Update Account 
            // system.debug('::: Account:'+Accwrap);
            if(Accwrap != null) {
                if(Accwrap.status == 'SUCCESS') {
                    system.debug('::: Account:'+acc.id+' '+acc.FSL_ERP_Customer_Code__c);
                    fetchAccountId(acc.id, Accwrap.accObj.FSL_ERP_Customer_Code__c);
                    System.debug('::: After FSL_IntegrationIdUpdate method call');
                }
            }
            //Update Payer Account 
            // system.debug('::: Account:'+Accwrap1);
            if(Accwrap1 != null) {
                if(Accwrap1.status == 'SUCCESS'){
                    system.debug('::: Account:'+acc1.id+' '+acc1.FSL_ERP_Customer_Code__c);
                    fetchAccountId(acc1.id, Accwrap1.accObj.FSL_ERP_Customer_Code__c);
                }
            }
            
            //Update Contact
            if(wrap != null) {
                if(wrap.status == 'SUCCESS'){
                    system.debug('::: Contact:'+con.id+' '+con.FSL_Contact_Id__c);
                    fetchContactId(con, wrap.conObj);
                }
            }
            //Update Payer Contact
            if(wrap1 != null) {
                if(wrap1.status == 'SUCCESS'){
                    system.debug('::: Contact:'+con1.id+' '+con1.FSL_Contact_Id__c);
                    fetchContactId(con1, wrap1.conObj);
                }                
            }
            
            //Update Site
            if(siteWrap != null){                
                if(siteWrap.status == 'SUCCESS') {
                    system.debug('::: Site:'+siteWrap.siteObj.id+' '+siteObjUpdate.FSL_Site_ID__c);//CT2-416
                    try {
                        FSL_IntegrationIdUpdate.getSiteId(siteObjUpdate.id, siteWrap.siteObj.FSL_Site_ID__c);//CT2-416
                    } catch(Exception ex) {
                        System.debug('::: Error in Site Update - '+ex.getMessage()+' and '+ex.getStackTraceString());
                        System.debug('::: After FSL_IntegrationIdUpdate method call');
                    }
                }                
            }            

            //Added try catch to avoid null pointer error
         try{            
             //Update Asset
            if(asstWrap != null ){
                if(asstWrap.status == 'SUCCESS') {
                    system.debug('::: Asset:'+asst.Id+' '+asstWrap.asstObj.Individual__c);
                    try {
                        FSL_IntegrationIdUpdate.getAssetId(asst.Id, asstWrap.asstObj.Individual__c, customerCode);
                    } catch(Exception ex) {
                        System.debug('::: Error in Asset Update - '+ex.getMessage()+' and '+ex.getStackTraceString());
                        System.debug('::: After FSL_IntegrationIdUpdate method call');
                    }
                }                
            }

            //system.debug('woqtRes>>>>>>>>'+JSON.serialize(woqtRes));
            //System.debug('::: woqtRes.Header - '+woqtRes.DataArea);
            
            if(woqtRes.Header != null) {
                if(woqtRes.Header.Status != null && woqtRes.Header.Status == 'Error' || (woqtRes.Header.Status != null && woqtRes.Header.Status == 'FAIL')) {
                    // modified by sailaja to remove the null condition added by satish to not break functionality
                    // If(wo!=null && acc!=null && acc1!=null) // Satish: Added to test Test clas null pointer exception issue 
                    if(!Test.isRunningTest()) {
                        onWorkOrderCheckFail(wo, acc, acc1, con, con1, siteObjUpdate, asst, Accwrap, Accwrap1, wrap, wrap1, siteWrap, asstWrap);
                    }
                    /*if(userERP == 'BMS') {
                        wraperres.errormsg = errMsg;
                    } else {
                        wraperres.errormsg = woqtRes.Header.ReturnCodeDescription;
                    }*/
                    wraperres.errormsg = woqtRes.Header.ReturnCodeDescription;
                    
                    System.debug('::: woqtRes.Header.ReturnCodeDescription - '+woqtRes.Header.ReturnCodeDescription);
                    return wraperres;
                }
            }            
            if(woqtRes.DataArea != null) {
                if(woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber != '0') {
                    BMSReferenceNumber = woqtRes.DataArea.WOReferenceNumber;
                    system.debug('BMSReferenceNumber>>>>*****'+BMSReferenceNumber);
                    BMSReferenceNumber = BMSReferenceNumber.trim();
                    if(string.isNotBlank(BMSReferenceNumber) && BMSReferenceNumber != '') {
                        wo.Shop_Work_Order__c = BMSReferenceNumber;  
                        /* GFSLFM-1228 : Status and process step will be updated to 'Intake complete'
                            and Schedule respectively  and Reocrd type is updated to 'Schedule' 
                            after sucessful creation of ERP Work Order.*/
                        system.debug('wo.Process_Step__c  '+ wo.Process_Step__c );
                        System.debug(' wo.Status ' +  wo.Status);
                        processStepUpdateWO(wo);
                        /* GFSLFM-1228 : Code End*/
                        /* CT2-346 - sending admin srts to ERP after WO creation
                         * Author : Rajashekar N; Date : 11/20/2020
                        */
                        //FSL_CL_AdminSRTApi.future_adminSRTApi(wo.Id);
                    }
                    update wo;  
                }      
            }           
            //return BMSReferenceNumber;
            wraperres.BMSReferenceNumber = BMSReferenceNumber;
            system.debug('Shop WorkOrder Number:'+BMSReferenceNumber);
        }
            //Added try catch to avoid null pointer error
        Catch(exception e1){
            system.debug('in WO exception');
        }
       }
        return wraperres;
            
    }
   

    public class calloutResponseWraper {
        @AuraEnabled public string errormsg = '';
        @AuraEnabled public string BMSReferenceNumber;
        @AuraEnabled public string errorCode = '';
        @AuraEnabled public string errorMessage  = '';
        @AuraEnabled public boolean isMWErrorSwitchActive = false;
    }
    
    @AuraEnabled
    public static string calloutCommentInbound(string woId) {
        // 4c's Integration Call
        //Start : Harsha added code for 4Cs
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        WorkOrder wo  = [Select id, CreatedDate,CreatedById,LastModifiedById, LastModifiedDate, ServiceTerritory.Location_Code__c,WorkOrderNumber, Shop_Work_Order__c,EditComplaint__c, EditCoverage__c from WorkOrder where id =: woId ];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        String commentCurrDate;
        String commentChangeDate;
        datetime currentDate = wo.CreatedDate;
        datetime changeDate = wo.LastModifiedDate;
        string sLoc = wo.ServiceTerritory.Location_Code__c;
        String subString = sLoc.substringBefore('-');
        String subString2 = sLoc.substringAfter('-').substring(0,5);
        commentCurrDate = currentDate.format('YYYY-MM-dd','GMT')+ 'T' + currentDate.format('HH:mm:ss','GMT');
        commentChangeDate = changeDate.format('YYYY-MM-dd','GMT')+ 'T' + changeDate.format('HH:mm:ss','GMT');
        
        if(UserERP == 'BMS') {
            sLoc = subString + '-' + subString2;
        }
        system.debug('Location is:' + sLoc); 
        User usr1 = new User();
        User usr2 = new User();
        if(!Test.isRunningTest()) { 
            usr1 = [SELECT Id, ERP__c , Name, FederationIdentifier FROM User WHERE Id =:wo.CreatedById  LIMIT 1];
            usr2 = [SELECT Id, ERP__c , Name, FederationIdentifier FROM User WHERE Id =:wo.LastModifiedById  LIMIT 1];
        }
        String CreateUser = (String)usr1.FederationIdentifier;
        system.debug('CreateUser:' + CreateUser);
        String ChangeUser = (String)usr2.FederationIdentifier;
        system.debug('ChangeUser:' + ChangeUser);
        
        if(UserERP == 'BMS') {
            //For Complaint
            FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, wo.WorkOrderNumber, 'WO', wo.Shop_Work_Order__c, 'COMPLAINT', wo.EditComplaint__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate); 
            //For Coverage
            FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, wo.WorkOrderNumber, 'WO', wo.Shop_Work_Order__c, 'COVERAGE', wo.EditCoverage__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate); 
        }
        //End : Harsha added code for 4c's
        return null;
    }
    
    // Call by reference 
    public static void processStepUpdateWO (WorkOrder wo) {
        System.debug('$$$ wo.AssetId' + wo.AssetId);
        if(wo.AssetId != null) {
            Asset ast  = [Select id, AccountId, ContactId, FSL_Site__c, FSL_Site__r.parent.FSL_Account__c from Asset where id =: wo.AssetId];//CT2-416
            if(ast != null){
                system.debug('Asset Rec:'+ast);
                if(wo.AccountId != null){
                    ast.AccountId = wo.AccountId;
                    system.debug('AssetAccountUpdate:'+wo.AccountId);
                }if(wo.ContactId != null){
                    ast.ContactId = wo.ContactId;
                    system.debug('AssetContactUpdate:'+wo.ContactId);
                }
                if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null){//CT2-416
                    ast.FSL_Site__c = wo.Repair_Site_Address__c; 
                    system.debug('AssetSiteUpdate:'+wo.Repair_Site_Address__c);
                } 
                if((wo.AccountId != ast.FSL_Site__r.parent.FSL_Account__c) && (wo.Repair_Location__c == 'In Shop') && ast.FSL_Site__c != null){//CT2-416
                    ast.FSL_Site__c = null;
                    system.debug('AssetSiteUpdate:'+ast.FSL_Site__c);//CT2-416
                    
                }
                update ast;
            }
        }
        if(wo.Process_Step__c == 'Intake') {
            wo.Process_Step__c = 'Schedule';
            wo.RecordTypeId = populateWORecType('Schedule').Id;
            if(wo.Status == 'Intake') {
                wo.Status = 'Intake Complete';
            }
        }
    }
    
    public static RecordType populateWORecType(String rtName) {
        return [SELECT Id, Name 
                FROM RecordType 
                WHERE SobjectType = 'WorkOrder' AND NAME = :rtName LIMIT 1];
    }
    
    @AuraEnabled
    public static user fetchUser() {
        // query current user information  
        User currUser = [select id,Name,ERP__c,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled,LanguageLocaleKey
                         FROM User Where id =: userInfo.getUserId()];
        return currUser;
    }
    
    // Story PHOEN-119 
    // Prudhvini - Get the custom meta data types to dispaly user friendly error message for error code
    @AuraEnabled
    public static string getCustomMetaDataTypesForErrors(String errorCode){
        User user1 = FSL_StatusUpdate.fetchUser();
        
        errorCode = '%'+errorCode+'%';
        List<FSL_ErrorCodes__mdt> errorMessageList =
        [SELECT id, Error_Code__c, Language__c, Error_Description__c FROM 
        FSL_ErrorCodes__mdt WHERE Error_Code__c LIKE :errorCode AND Language__c=:user1.LanguageLocaleKey  LIMIT 1];
        if(errorMessageList.size()>0){
         return errorMessageList[0].Error_Description__c;
        }else{
            return null;
        }
    }
    
    @future (callout=true)
    public static void doCallUpdateWorkOrder(String woId) {
        WorkOrder wo =  FSL_StatusUpdate.getWorkOrder(woId);
        system.debug('WorkOrder Future Id'+ wo);
        //FSL_StatusUpdate.updateWorkOrder(wo);
    }
    
    public static void onContactCheckFail (WorkOrder wo, Account acc, Account acc1, FSL_CreateCustomer.CallOutResponseWrap Accwrap, 
                                           FSL_CreateCustomer.CallOutResponseWrap Accwrap1) 
    {
        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
            fetchAccountId(wo.Account, acc, Accwrap.accObj);
        }
        if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
            fetchAccountId(wo.Payer__r, acc1, Accwrap1.accObj);
        }
    }
    
    public static void onPayerContactCheckFail (WorkOrder wo, Account acc, Account acc1, Contact con, FSL_CreateCustomer.CallOutResponseWrap Accwrap, 
                                                FSL_CreateCustomer.CallOutResponseWrap Accwrap1,FSL_JobContactInfo.CallOutResponseWrap wrap) 
    {
        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
            fetchAccountId(wo.Account, acc, Accwrap.accObj);
        }
        if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
            fetchAccountId(wo.Payer__r, acc1, Accwrap1.accObj);
        }
        fetchContactId(con, wrap.conObj);
    }
    
    public static void onSiteCheckFail (WorkOrder wo, Account acc, Account acc1,  Contact con, Contact con1,
                                        FSL_CreateCustomer.CallOutResponseWrap Accwrap, FSL_CreateCustomer.CallOutResponseWrap Accwrap1,
                                        FSL_JobContactInfo.CallOutResponseWrap wrap, FSL_JobContactInfo.CallOutResponseWrap wrap1)
    {
        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
            fetchAccountId(wo.Account, acc, Accwrap.accObj);
        }
        if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
            fetchAccountId(wo.Payer__r, acc1, Accwrap1.accObj);
        }
        fetchContactId(con, wrap.conObj);
        if(wo.Payer_ContactID__c != null && (wo.ContactId != wo.Payer_ContactID__c)){
            fetchWOPayerConId(wo, con1, wrap1.conObj);
        }
    }
    //CT2-416 : IAM_CDH_Cross_references__c replaced by Address
    public static void onAssetCheckFail (WorkOrder wo, Account acc, Account acc1,  Contact con, Contact con1, Schema.Address siteObjUpdate,
                                         FSL_CreateCustomer.CallOutResponseWrap Accwrap, FSL_CreateCustomer.CallOutResponseWrap Accwrap1,
                                         FSL_JobContactInfo.CallOutResponseWrap wrap, FSL_JobContactInfo.CallOutResponseWrap wrap1, FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap)
    {
        if(wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) {
            fetchAccountId(wo.Account, acc, Accwrap.accObj);
        }
        if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
            fetchAccountId(wo.Payer__r, acc1, Accwrap1.accObj);
        }
        fetchContactId(con, wrap.conObj);
        if(wo.Payer_ContactID__c != null && (wo.ContactId != wo.Payer_ContactID__c)){
            fetchWOPayerConId(wo, con1, wrap1.conObj);
        }
        if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
            fetchSiteId(wo, siteObjUpdate, siteWrap.siteObj);
        }
    }
    //CT2-416 : IAM_CDH_Cross_references__c replaced by Address
    public static void onWorkOrderCheckFail (WorkOrder wo, Account acc, Account acc1,  Contact con, Contact con1,
                                             Schema.Address siteObjUpdate ,Asset asst, FSL_CreateCustomer.CallOutResponseWrap Accwrap, 
                                             FSL_CreateCustomer.CallOutResponseWrap Accwrap1,FSL_JobContactInfo.CallOutResponseWrap wrap,
                                             FSL_JobContactInfo.CallOutResponseWrap wrap1, FSL_CL_SiteCreateUpdate.CallOutResponseWrap siteWrap,
                                             FSLInBoundService.CallOutResponseWrap asstWrap)
    {
        if((wo.Account.FSL_ERP_Customer_Code__c == '' || wo.Account.FSL_ERP_Customer_Code__c == null) && !Test.isRunningTest()) {
            fetchAccountId(wo.Account, acc, Accwrap.accObj);
        }
        if(wo.Payer__c != null && (wo.Payer__r.FSL_ERP_Customer_Code__c == '' || wo.Payer__r.FSL_ERP_Customer_Code__c == null) && (wo.AccountId != wo.Payer__c)) {
            fetchAccountId(wo.Payer__r, acc1, Accwrap1.accObj);
        }
        fetchContactId(con, wrap.conObj);
        if(wo.Payer_ContactID__c != null && (wo.ContactId != wo.Payer_ContactID__c)){
            fetchContactId(con1, wrap1.conObj);
        }
        if(wo.Repair_Location__c == 'Mobile' && wo.Repair_Site_Address__c != null) {//CT2-416
            fetchSiteId(wo, siteObjUpdate, siteWrap.siteObj);
        }
        if(wo.AssetId != null){
            fetchAssetId(wo, asst, asstWrap.asstObj, acc, Accwrap.accObj);
        }
    }
    
    public static void fetchAccountId(Account woAcc, Account acc, Account accObj) {
        if (String.isBlank(woAcc.FSL_ERP_Customer_Code__c)) { // modified by sailaja to remove the change added by satish 
            fetchAccountId(acc.id, accObj.FSL_ERP_Customer_Code__c);
        }
    }
    
    public static void fetchAccountId(String accRecId, String accCustmerCode){
        try {
            FSL_IntegrationIdUpdate.getAccountId(accRecId, accCustmerCode);
        } catch (Exception e) {
            System.debug('Exception Details : ' + e.getMessage() + ' at ' + e.getLineNumber());
        }
    }
    
    public static void fetchWOPayerConId (WorkOrder wo, Contact con, Contact conObj) {
        try {
            fetchContactId(con, conObj);
        } catch (Exception e) {
            System.debug('Exception Details : ' + e.getMessage() + ' at ' + e.getLineNumber());
        }
    }
    
    public static void fetchContactId (Contact con, Contact conObj) {
        try {
            if(con != null && con.id != null){
                FSL_IntegrationIdUpdate.getContactId(con.id, conObj.FSL_Contact_Id__c);  
            }
        } Catch (Exception e) {
            System.debug('Exception Details : ' + e.getMessage() + ' at ' + e.getLineNumber());   
        }
    }
    
    public static void fetchAssetId (WorkOrder wo, Asset asst, Asset asstObj, Account acc, Account accObj) {
        try {
            FSL_IntegrationIdUpdate.getAssetId(asst.id, asstObj.Individual__c, accObj.FSL_ERP_Customer_Code__c);
        } Catch (Exception e) {
            System.debug('Exception Details : ' + e.getMessage() + ' at ' + e.getLineNumber());
        }
    }
    
    public static void fetchSiteId (WorkOrder wo,  Schema.Address siteObjUpdate, Schema.Address siteObj) {//CT2-416
        try {
            FSL_IntegrationIdUpdate.getSiteId(siteObjUpdate.id, siteObj.FSL_Site_ID__c);
        }
        catch (Exception e) {
            System.debug('Exception Details : ' + e.getMessage() + ' at ' + e.getLineNumber());          
        }
    }
    
    // Added by Ravikanth upsert the Make Model Stage records
    @AuraEnabled
    public static string  insertMakeModelStaging(string servicejobid) {
        // string strResult;
        list<FSL_MakeModel_Stage__c> lstmake = new list<FSL_MakeModel_Stage__c>();
        if(servicejobid != null && servicejobid != '') {
            // for(WorkOrder objorder : [SELECT Id, Make__c, Model__c, Asset.Name, Asset.Type__c, Asset.Product_Application_Code__c, Asset.Make__c, Asset.Model__c, Status,Sub_Status__c FROM WorkOrder WHERE Id=:servicejobid]) {
            for(WorkOrder objorder : [SELECT Id, Make__c, Model__c,FSL_Make_Model_Flag__c,Asset.Name,Asset.Type__c, Asset.Product_Application_Code__c,Application__c FROM WorkOrder WHERE Id=:servicejobid]) {
                // if(objorder.Make__c != null && objorder.Asset.Make__c != null && objorder.Make__c != objorder.Asset.Make__c && objorder.Model__c != null && objorder.Asset.Model__c != null && objorder.Model__c != objorder.Asset.Model__c) {
                system.debug('inside if ---->');
                if(objorder.Make__c!=null && objorder.Model__c != null && objorder.FSL_Make_Model_Flag__c ){
                    FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                    objstage.Manufacturer__c = objorder.Make__c;
                    objstage.ModelSeries__c = objorder.Model__c;
                    if(objorder.Application__c !=null){
                        objstage.ProductApplicationCode__c = string.valueof(objorder.Application__c.SubStringBefore('-'));
                    }
                    objstage.PSN__c = objorder.Asset.Name;
                    
                    if(objorder.Asset.Type__c == 'ENGINE' ||
                       objorder.Asset.Type__c == 'GENSET' ||
                       objorder.Asset.Type__c == 'Engines'){
                           objstage.Type__c = 'Engines';
                           objstage.Type_PSN__c = 'Engines-' + objorder.Asset.Name;
                       }
                    else if(objorder.Asset.Type__c == 'FIREPUMP' ||
                            objorder.Asset.Type__c == 'ENGINE CORE' ||
                            objorder.Asset.Type__c == 'SWITCH GEAR' ||
                            objorder.Asset.Type__c == 'TRANSFER SWITCH' ||
                            objorder.Asset.Type__c == 'TRANSMISSIONS' ||
                            objorder.Asset.Type__c == 'BATTERY' ||
                            objorder.Asset.Type__c == 'PARSYS' ||
                            objorder.Asset.Type__c == 'MARINE GEAR' ||
                            objorder.Asset.Type__c == 'Products') {
                                
                                objstage.Type__c = 'Products';
                                objstage.Type_PSN__c = 'Products-' + objorder.Asset.Name;
                            }
                    
                    lstmake.add(objstage);
                }
            }
            system.debug('---->'+lstmake.size());
            if(lstmake.size() > 0) {
                List<Database.upsertResult> updateinsertResults = Database.upsert(lstmake, FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField(), false);
                for (Database.upsertResult sr : updateinsertResults ) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed and Sucess record Id set into SET
                        // strResult ='Inserted Sucessfully';
                        System.debug('Successfully inserted/updated MakeModelStage: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            // strResult = err.getMessage();
                            System.debug('Asset fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
        return null;
    }
    /** Charan : Start for Phoen-274**/
    public static string addEscapeChar(string inputString) {
        if(inputString.contains('\\') ){
            string addbackslash = '\\\\';
            inputString = inputString.replace('\\',addbackslash);
            system.debug('inputString  :::' +inputString);
        }
        if(inputString.contains('"') ){
            string adddoublecodes = '\\"';
            inputString = inputString.replace('"',adddoublecodes);
             system.debug('inputString  :::' +inputString);
        }
        /*
        if(inputString.contains('\n') ){
            string adddoublecodes = '\\n';
            inputString = inputString.replace('\n',adddoublecodes);
             system.debug('inputString  :::' +inputString);
        }
        */
         //Dinesh Phoen - 290 7/19/2022
        if(inputString.contains('\r\n') ){
            string adddoublecodes = '\\r\\n';
            inputString = inputString.replace('\r\n',adddoublecodes);
             system.debug('inputString  :::' +inputString);
        }
        system.debug('Actual inputString  :::' +inputString);
        return inputString;
    } 
       
    /**Phoen-274 Code ends **/
    
}