/*
*****************************************************************************
HISTORY
*****************************************************************************
******************************************************************************
Version        Author        Date        Details
1.0  Vignesh  Shanmugakani              Intial Developement
1.1  Rajesh Narra           10-24-2017  Added BeforeInService to the Webservice
2.0  Gyana Pany             02-13-2018  Updated Service to align with API version 2.0
2.1  Gopal Raj              04-06-2018  Updated with story# 137902 & 137903
3.0  Vamshi Krishna         04-28-2018  Updated with story# 137905 & 141195
4.o  Rajesh Narra           05-16-2019  Updated css_dealerCode__c with IAM_Service_Provider_Code__c
****************************************************************************
*/
@RestResource(UrlMapping='/CGDE/V01/SendJobInfo/*')
global  class CSS_SendJobInfo{
    //with sharing
    public static CSS_Job_Order__c cssJob = new CSS_Job_Order__c();
    public static CSS_DataExchange_Parent__c dataExchange = new CSS_DataExchange_Parent__c();
    public static CSS_DataExchange_Child__c dataExchangeChild = new CSS_DataExchange_Child__c();
    //public static id usrid;
    @HttpPost
    global static CSS_SendJobInfoResWrapper sendJobInformation(){
        CSS_SendJobInfoResWrapper resJSON = null;
        WrapperInput wrapperObj = new WrapperInput();
        RestRequest req = RestContext.request;
        
        String jSONRequestBody=req.requestBody.toString().trim();
        CSS_SendJobInfoReqWrapper reqJSON;
        
        wrapperObj.ServiceName  = 'DataXSOCreateUpdate';
        wrapperObj.ServiceVersion = '1.0';
        wrapperObj.Status='ERROR';
        
        //BEGIN - VALIDATION CHECKS
        //This (try ,catch) block of code is used to catch any kind of JSON format validations in the request Strict
        try{
            reqJSON = (CSS_SendJobInfoReqWrapper)JSON.deserializeStrict(jSONRequestBody,CSS_SendJobInfoReqWrapper.class);
        }catch(Exception ex){
            System.debug('**'+ex.getMessage());
            wrapperObj.ReturnCode='CSS10';
            wrapperObj.ReturnCodeDescription='Invalid JSON Format';
            return prepareResponseWrapper(wrapperObj,null);
        }
        
        system.debug('SERVICEHIST'+reqJSON.DataArea.SERVICEHIST); 
        system.debug('reqJSON Body'+reqJSON);
        
        CSS_SendJobInfoReqWrapper.SERVICEHIST reqJSONServ = null;
        if(reqJSON != null){
            //Mapping the input request fields to the wrapper class
            
            // //This block of code verify whether the service name is not null or not equal to SendJobInfo
            if(reqJSON.Header.ServiceName==null || reqJSON.Header.ServiceName!='DataXSOCreateUpdate'){
                wrapperObj.ReturnCode='CSS02';
                wrapperObj.ReturnCodeDescription='Service Name is invalid/missing';
                return prepareResponseWrapper(wrapperObj,null);
            }
            wrapperObj.ServiceName = reqJSON.Header.ServiceName;
            wrapperObj.ServiceVersion = reqJSON.Header.ServiceVersion;
            
            //This block of code verify whether the tool id is not null or empty
            if(reqJSON.Header.ToolID==null || reqJSON.Header.ToolID==''){
                wrapperObj.ReturnCode='CSS03';
                wrapperObj.ReturnCodeDescription='ToolID is invalid';
                return prepareResponseWrapper(wrapperObj,null);
            }
            
            wrapperObj.ToolID = reqJSON.Header.ToolID;
            
            //This block of code is used to verify whether the SPCode is inactive or invalid
            if(reqJSON.Header.SPCode==null || reqJSON.Header.SPCode==''){
                wrapperObj.ReturnCode='CSS06';
                wrapperObj.ReturnCodeDescription='SPCode is inactive/invalid';
                return prepareResponseWrapper(wrapperObj,null);
            }
           
            wrapperObj.SPCode = reqJSON.Header.SPCode;
            wrapperObj.SenderID = reqJSON.Header.SenderID;
            wrapperObj.TargetID = reqJSON.Header.TargetID;
           // id usrid ;
           // if(usrid == null){
              Id  usrid = userinfo.getUserId();
            system.debug('** User Id  '+usrid);

            //}
           // if(!Test.isRunningTest()){
             //  usrid = userinfo.getuserid(); //Logic added by Gopal 
            //}else{
             //  Id profId = [Select Id, Name from Profile where Name Like '%Data_ExChange_Admin%' limit 1].Id; 
              // usrid = [SELECT Id, Username, LastName FROM User WHERE ProfileId =: profId limit 1].Id;
            //}
            
            Account acc = new Account();
            id owner_Id ;
            if (usrid == null)
            {
                  wrapperObj.Status='ERROR';
                  wrapperObj.ReturnCode='CSS07';
                  wrapperObj.ReturnCodeDescription='Problem with DataExchange Setup: Invalid API User';
                  return prepareResponseWrapper(wrapperObj, null);
            }
            else {
                system.debug('** User Id  '+usrid);
                system.debug('** User Name'+userinfo.getUserName() + userinfo.getUserId() + usrid);
                
                /*** Commented by Sriprada for Dealer DX changes to make it unique
                 
               ID accd1 = [select id, accountid from user where id=:usrid Limit 1].accountid;

                System.debug('****'+accd1);
                if (accd1 == null)
                {
                    wrapperObj.Status='ERROR';
                    wrapperObj.ReturnCode='CSS08';
                    wrapperObj.ReturnCodeDescription='Problem with DataExchange Setup: API User Location unavailable';
                    return prepareResponseWrapper(wrapperObj, null);
                }
                else 
                {          Ends here ----- Sriprada       */ 
                   list<account> act = [select id ,Name,css_de_parent__c, Data_Exchange_Enabled__c,
                                         Customer_Data_Send_to_CSS__c, Vehicle_Unit_Data_Send_to_CSS__c,
                                         ESN_Service_History_Send_to_CSS__c, Location__c,IAM_Service_Provider_Code__c
                                         from account where IAM_Service_Provider_Code__c=:wrapperObj.SPCode];
                    System.debug('Value of Account: ' + act);
                    BOOLEAN Dealercodestatus = true;
                          for(account acc1:act)
                            {
                                System.debug('Value of DealerCode & SP CODE: ' + acc1.IAM_Service_Provider_Code__c+ ':' + wrapperObj.SPCode);
                                if(acc1.IAM_Service_Provider_Code__c==wrapperObj.SPCode) {
                                    Dealercodestatus=true;
                                    acc = acc1;
                                } 
                            } 
                    System.debug('Value of DealerCode Status:' + Dealercodestatus);
                
                /*** Commented by Sriprada for Dealer DX changes to make it unique
                 
                     if(Dealercodestatus)
                    {
                        System.debug('Value of DealerCode Status in IF Condition:' + Dealercodestatus);
                        list<contact> con = [select id from contact where accountid=:acc.id];
                        system.debug('con--->'+con);
                        set<id> id2 = new set<id>();
                        if(con.size()>0){
                            for (contact con1:con)
                            {
                                id2.add(con1.id);
                            }
                            system.debug('Testid2'+id2);
                            //owner_Id = [select id from user where contactid in:id2 limit 1].id;
                          if(!test.isRunningTest())    
                                owner_Id = [select id from user where Profile.Name LIKE '%Advanced%' AND contactid in:id2 limit 1].id;
                            else
                                 owner_Id = userinfo.getuserid();
                             
                                System.debug('Owner ID : ' + owner_Id);
                        } else{
                            owner_Id =null;
                        }
                        
                        if(owner_Id == NULL)
                        {
                            wrapperObj.Status='ERROR';
                            wrapperObj.ReturnCode='CSS06';
                            wrapperObj.ReturnCodeDescription='SPCode is inactive/invalid: SP does not have a Advisor';
                            
                            return prepareResponseWrapper(wrapperObj, null);
                        }
                    }
                    else
                    {
                        wrapperObj.Status='ERROR';
                        wrapperObj.ReturnCode='CSS05';
                        wrapperObj.ReturnCodeDescription='Problem with DataExchange Setup: SP Code not part of API user';
                        return prepareResponseWrapper(wrapperObj, null);
                    }
                    
                
                } Ends here -------- Sriprada */
            } 
            //END - VALIDATION CHECKS
            //DataArea
            System.debug('Test laxmi'+reqJSON.DataArea);
            System.debug('Test laxmi'+reqJSON.DataArea.CUST_DATA);
            
            wrapperObj.CustomerName = reqJSON.DataArea.CUST_DATA.CustomerName;
            wrapperObj.DateAvailService = reqJSON.DataArea.CUST_DATA.AvailableForService;
            wrapperObj.ShopWO = reqJSON.DataArea.CUST_DATA.ShopWO;
            
            wrapperObj.PSN = reqJSON.DataArea.UNIT_DATA.PSN;
            wrapperObj.UnitNumber = reqJSON.DataArea.UNIT_DATA.UnitNumber;
            wrapperObj.Application = reqJSON.DataArea.UNIT_DATA.Application;
            wrapperObj.ServiceModelNM = reqJSON.DataArea.UNIT_DATA.ServiceModel;
            wrapperObj.Make = reqJSON.DataArea.UNIT_DATA.Make;
            wrapperObj.Model = reqJSON.DataArea.UNIT_DATA.Model;
            wrapperObj.VIN = reqJSON.DataArea.UNIT_DATA.VIN;
            wrapperObj.WarrStartDate = reqJSON.DataArea.UNIT_DATA.WarrStartDate;
            wrapperObj.BeforeInService = reqJSON.DataArea.UNIT_DATA.BeforeInService;
            wrapperObj.FailureDate = reqJSON.DataArea.UNIT_DATA.FailureDate;
            wrapperObj.MileageOrKms = reqJSON.DataArea.UNIT_DATA.ProductMileage;
            wrapperObj.MileageMeasure = reqJSON.DataArea.UNIT_DATA.MileageMeasure;
            wrapperObj.Hours = reqJSON.DataArea.UNIT_DATA.ProductHours; 
            
            //This logic is for Complaint data area
            if(reqJSON.DataArea.CUST_DATA!=null)
            {
            wrapperObj.ComplaintText = reqJSON.DataArea.CUST_DATA.CustomerComplaint;  // Dunkirk Story
            //wrapperObj.ComplaintCategory = reqJSON.DataArea.COMPLAINT_DATA.ComplaintCategory;
            //wrapperObj.ComplaintType = reqJSON.DataArea.COMPLAINT_DATA.ComplaintType; 
          //  wrapperObj.Code = reqJSON.DataArea.CUST_DATA.Code; 
            } // logic ends 
        
            system.debug('After Account'+acc);
            if(acc !=null && acc.Data_Exchange_Enabled__c == true){
                String appCode = wrapperObj.Application;
                String applicationVal = appCode.substringAfter('-');
                dataExchange.Customer_Name__c = wrapperObj.CustomerName;
                dataExchange.Date_In__c = Date.valueOf(wrapperObj.DateAvailService);
                
                String workorderone = (wrapperObj.ShopWO).trim();
                
                String trimworkone = workorderone.replaceAll('(\\s+)', '');
                system.debug('trimworkone'+trimworkone);
                dataExchange.Shop_Work_Order__c = trimworkone.right(30);  //karthi G added as per GSSC-707
                
               // dataExchange.Shop_Work_Order__c = wrapperObj.ShopWO;
                
                dataExchange.ESN__c = wrapperObj.PSN;
                if(wrapperObj.UnitNumber!=null)
                    dataExchange.Unit_Number__c = wrapperObj.UnitNumber;
                dataExchange.Application__c = applicationVal;
                if(wrapperObj.ServiceModelNM!=null)
                    dataExchange.SERVICEMODELNAME__c = wrapperObj.ServiceModelNM;
                if(wrapperObj.Make!=null)
                    dataExchange.MAKE__c = wrapperObj.Make;
                if(wrapperObj.Model!=null)
                    dataExchange.MODEL__c = wrapperObj.Model;
                if(wrapperObj.VIN!=null)
                    dataExchange.VIN__c = wrapperObj.VIN;
                if(wrapperObj.WarrStartDate!=null && wrapperObj.WarrStartDate!='')
                    dataExchange.Warranty_Start_Date__c = Date.valueof(wrapperObj.WarrStartDate);
                if(wrapperObj.BeforeInService!=null)
                    dataExchange.Before_In_Service__c = Boolean.valueOf(wrapperObj.BeforeInService);
                if(wrapperObj.FailureDate!=null && wrapperObj.FailureDate!= '')
                    dataExchange.Failure_Date__c = Date.valueOf(wrapperObj.FailureDate);
                dataExchange.Mileage_Hours__c = Decimal.valueOf(wrapperObj.MileageOrKms);  
                dataExchange.Mileage_Measure__c = wrapperObj.MileageMeasure;
                if(wrapperObj.Hours!=null && wrapperObj.Hours!= '')
                    dataExchange.Hours__c = Decimal.valueOf(wrapperObj.Hours);
         
            /*    //This logic is for Complaint data area
                if(wrapperObj.Code!=null)  //Story Dunkirk
                {
                    dataExchange.Complaint_Code__c = wrapperObj.Code;
                    if(wrapperObj.ComplaintText!=null)
                        dataExchange.Complaint_Text__c = wrapperObj.ComplaintText;                
                    
                    //List<CSS_List_Of_Values__c> complaintdata = CSS_List_Of_Values__c.getall().values();   // Story Dunkirk
                    List<CSS_Complaint_Data__c> complaintdata = CSS_Complaint_Data__c.getall().values();
                    for(Integer i = 0; i < complaintdata.size() ; i++){
                        if(complaintdata[i].Code__c == wrapperObj.Code){
                            dataExchange.Complaint_Category__c = complaintdata[i].Picklist_Values_1__c;
                            dataExchange.Complaint_Type__c = complaintdata[i].Picklist_Values_3__c;  
                            dataExchange.Complaint_Code__c = complaintdata[i].Code__c;
                        } 
                    }

                }  // logic ends  */
                
                
               // S-249
               if(wrapperObj.ComplaintText!=null)
               dataExchange.Complaint_Text__c = wrapperObj.ComplaintText; 
               
               if(dataExchange.Complaint_Text__c!=null){
                  dataExchange.Complaint_Type__c ='OTHER - SEE TEXT FOR DESCRIPTION';  
                  dataExchange.Complaint_Category__c = 'Other'; 
               }
 
                dataExchange.SP_Code__c = wrapperObj.SPCode;
                //dataExchange.CSS_Job_Number__c = wrapperObj.CSSJOBID;
                system.debug('shop work order'+wrapperObj.SHOPWO);
                Id rTypeId_inbox = [SELECT Id FROM RecordType WHERE Name = 'DE-Inbox'].Id;
                dataExchange.RecordTypeId  = rTypeId_inbox;
                dataExchange.DataExchange_Status__c = 'UnProcessed';
                dataExchange.SenderID__c = wrapperObj.SenderID;
                insert dataExchange;
                                
                List<CSS_DataExchange_Child__c> lstDEChild = new List<CSS_DataExchange_Child__c>();
                if(reqJSON.DataArea.SERVICEHIST!=null && reqJSON.DataArea.SERVICEHIST.size()>0){
                    for(CSS_SendJobInfoReqWrapper.SERVICEHIST a : reqJSON.DataArea.SERVICEHIST){
                        dataExchangeChild = new CSS_DataExchange_Child__c();
                        //dataExchangeChild.Source__c = a.Source; - Not available yet
                        dataExchangeChild.ESN__c = wrapperObj.PSN;
                        //dataExchangeChild.Job_Date__c = a.JobDate; - Not available yet
                        //dataExchangeChild.Customer_Name__c = a.CustomerName; - Not available yet
                        //dataExchangeChild.ShopWO__c = a.ShopWO; - Not available yet   
                        dataExchangeChild.Service_Model_Name__c = a.ServiceModelNM;
                        //dataExchangeChild.ServiceLocation__c = a.ServiceLocation; - Not available yet
                        //dataExchangeChild.WorkSummary__c = a.WorkSummary; - Not available yet
                        dataExchangeChild.Solution_Symptom__c = a.FaultCodeSymptom;
                        //dataExchangeChild.Mileage__c = Decimal.valueOf(a.Mileage); - Not available yet
                        //dataExchangeChild.Mileage_Measure__c = a.MileageMeasure; - Not available yet
                        dataExchangeChild.CSS_DataExchange_Parent__c = dataExchange.Id;
                        dataExchangeChild.DataExchangeChild_Status__c = 'UnProcessed';
                        dataExchangeChild.DataExchangeChildType__c = 'ServiceHistory';
                        lstDEChild.add(dataExchangeChild);
                    }
                }
                if(lstDEChild.size() > 0){
                    system.debug('List size in If is'+lstDEChild.size());
                    insert lstDEChild;
                }
                
                system.debug('Inside If');
                if(acc.Customer_Data_Send_to_CSS__c == true){
                    system.debug('Inside Customer Data If');
                    cssJob.Customer_Name__c = wrapperObj.CustomerName;
                    //Story # 398
                    cssJob.Date_in_Shop__c = Date.valueOf(wrapperObj.DateAvailService);
                    
                    String workorder = (wrapperObj.ShopWO).trim();
                    
                    String trimwork = workorder.replaceAll('(\\s+)', '');
                    system.debug('trimwork'+trimwork);
                    cssJob.Shop_Work_Order__c = trimwork.right(30);  //karthi G added as per GSSC-707
                    
                    //cssJob.Shop_Work_Order__c = wrapperObj.ShopWO;
                }
                if(acc.Vehicle_Unit_Data_Send_to_CSS__c == true){
                    system.debug('Inside Vehicle Data If');
                    //Commented ESN__c and replaced ESN__c with ESN_IA__c cssJob.ESN__c = wrapperObj.PSN;
                    cssJob.ESN_IA__c = wrapperObj.PSN;
                    cssJob.Unit_Number__c = wrapperObj.UnitNumber;
                    System.debug('unit number **'+cssJob.Unit_Number__c);
                    cssJob.Application__c = applicationVal;
                    cssJob.Application_Desc__c = (wrapperObj.Application).toUpperCase();
                    if(wrapperObj.ServiceModelNM!=null)
                        cssJob.Service_Model__c = wrapperObj.ServiceModelNM;
                    if(wrapperObj.Make!=null)
                        cssJob.MAKE__c = wrapperObj.Make;
                    if(wrapperObj.Model!=null)
                        cssJob.MODEL__c = wrapperObj.Model;
                    if(wrapperObj.VIN!=null)
                        cssJob.VIN__c = wrapperObj.VIN;                   
                    if(wrapperObj.WarrStartDate!=null && wrapperObj.WarrStartDate!='')
                        cssJob.Warranty_Start_Date__c = Date.valueOf(wrapperObj.WarrStartDate);                   
                    if(wrapperObj.BeforeInService!=null)
                        cssJob.Before_In_Service__c = Boolean.valueOf(wrapperObj.BeforeInService);
                    if(wrapperObj.FailureDate!=null && wrapperObj.FailureDate!= '')
                        cssJob.Failure_Date__c = Date.valueOf(wrapperObj.FailureDate);                       
                    if(wrapperObj.MileageOrKms!=null)
                        cssJob.Mileage__c  = Decimal.valueOf(wrapperObj.MileageOrKms);
                    if(wrapperObj.MileageMeasure!=null)
                        cssJob.Mileage_Measure__c = String.valueOf(wrapperObj.MileageMeasure);
                        if(wrapperObj.Hours!=null && wrapperObj.Hours!= '')
                        cssJob.CSS_Hours__c = Decimal.valueOf(wrapperObj.Hours);
                } 
                
               // Story # 249
                if(wrapperObj.ComplaintText!=null)
                {
                    cssJob.General_Symptoms__c = wrapperObj.ComplaintText;
                    cssJob.Complaint_Type_Desc__c = 'OTHER - SEE TEXT FOR DESCRIPTION'; 
                    cssJob.Category_Desc__c = 'Other'; 
                }
                
                
                // Added below code for defect #180747
                cssJob.JobLocation__c = acc.Name;
                cssJob.Account__c = acc.id;
                cssJob.Data_Exchange_Enabled__c = true;
                cssJob.CSS_Job_Location_Code__c = acc.Location__c;
                cssJob.Status__c = 'Intake';
                system.debug('vignesh owner id-->'+owner_Id);
                String JobName = null;
                try {
                    insert cssJob;
                    // Below code Added by Krishna - GSSC-260
                    CSS_Job_Order__c new_cssJob = [select Id, Name from CSS_Job_Order__c where id = :cssJob.Id LIMIT 1];
                    system.debug('** Job Info'+new_cssJob);
                    JobName = new_cssJob.Name;
                    // Above code Added by Krishna - GSSC-260
                    
                    //The below code commendted by Krishna on GSSC-260
                    /*
                    CSS_Job_Order__c new_cssJob = [select Id, Name from CSS_Job_Order__c where id = :cssJob.Id LIMIT 1];
                    system.debug('** Job Info'+new_cssJob);
                    JobName = new_cssJob.Name;
                    System.debug('Job Name is : ' + JobName);
                    if(owner_Id!=null){   //
                        cssJob.OwnerId = owner_Id;
                        System.debug('Job owner id : ' + cssJob.OwnerId);
                    }                      
                    update cssJob;
                    
                  // Sharing logic for account users                        
                    List<CSS_Job_Order__share> srvJobShareList = new List<CSS_Job_Order__share>(); 
                    List<User> recOwnerUser = [Select Id,contactID,AccountId, userName, profile.name, User_Location__c from user where id=:cssJob.OwnerId ];                                                                                                
                    system.debug('Record Owners-->'+recOwnerUser);
                    List<Contact> accContacts = [SELECT Id,Name FROM Contact where Account.Id =:recOwnerUser[0].AccountId];                   
                    // system.debug('Record Owners-->'+accContacts);
                    Set<String> contactId = new Set<String>();
                    for(Contact con:accContacts){ 
                       if(recOwnerUser[0].contactID!= con.Id) 
                       {
                        contactId.add(con.Id);
                       }
                    }                    
                    system.debug('Locations-->'+contactId);                    
                    List<User> sameLocAccntUsers = [select Id,userName,AccountId from User where isActive=true and Profile.name='CSS_Dealer_Advanced' and Contact.Id IN: contactId];                                      
                    system.debug('Same account users'+sameLocAccntUsers);                    
                    String ServiceJobId =  new_cssJob.Id;
                    for(User accusr:sameLocAccntUsers){  
                        CSS_Job_Order__share jobstoShare = grantShareServJobs(accusr.Id,ServiceJobId,Schema.CSS_Job_Order__share.RowCause.Account_Hierarchy__c);                        
                        system.debug('Share jobs'+jobstoShare);                            
                        srvJobShareList.add(jobstoShare);
                    } 
                    upsert srvJobShareList;
                    // End of logic for the sharing of account users
                    */
                    //The above code commendted by Krishna on GSSC-260
                    
                } catch(Exception ex) {
                    wrapperObj.Status='ERROR';
                    wrapperObj.ReturnCode='CSS11';
                    wrapperObj.ReturnCodeDescription='Guidanz Internal Error-CSSJOB. Please contact Guidanz Support.';
                    return prepareResponseWrapper(wrapperObj, null);
                }
            system.debug('Acc info'+acc.ESN_Service_History_Send_to_CSS__c + 'acc '+acc);
              if(acc.ESN_Service_History_Send_to_CSS__c == true){
                    system.debug('ServiceHistory'+reqJSON.DataArea.SERVICEHIST);
                    
                    List<CSS_JobEventTemporary__c> lstJobEventTemp = new List<CSS_JobEventTemporary__c>();
                    
                    for(CSS_SendJobInfoReqWrapper.SERVICEHIST a : reqJSON.DataArea.SERVICEHIST){
                         if(a.CustomerName !='OEM_SAMPLE')
                        {
                        CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
                        jobEventTemp.ESN__c = wrapperObj.PSN;
                        jobEventTemp.Service_Model_Name__c = a.ServiceModelNM;
                        jobEventTemp.Make__c = wrapperObj.Make;
                        jobEventTemp.Model__c = wrapperObj.Model;
                        jobEventTemp.VIN__c = wrapperObj.VIN;                        
                        lstJobEventTemp.add(jobEventTemp);                        
                        system.debug('ServiceHistory1'+a.ServiceModelNM);
                        }
                    }
                    
                    if(lstJobEventTemp.size() > 0){
                        system.debug('List size in If is'+lstJobEventTemp.size());
                        try {
                            insert lstJobEventTemp;
                        } catch(Exception ex) {
                            wrapperObj.Status='ERROR';
                            wrapperObj.ReturnCode='CSS11';
                            wrapperObj.ReturnCodeDescription='Guidanz Internal Error-CSSSHIST. Please contact Guidanz Support.';
                            return prepareResponseWrapper(wrapperObj, null);
                        }
                    }
                }                       
                
                // Update Data Exchange Record to PROCESSED.
                dataExchange.CSS_Job_Number__c = JobName;
                dataExchange.DataExchange_Status__c = 'Processed';
                try {
                    update dataExchange;
                } catch(Exception ex) {
                    wrapperObj.Status='ERROR';
                    wrapperObj.ReturnCode='CSS11';
                    wrapperObj.ReturnCodeDescription='Guidanz Internal Error-DEPARENT. Please contact Guidanz Support.';
                    return prepareResponseWrapper(wrapperObj, null);
                }
                List<CSS_DataExchange_Child__c> dataExchangeChild_new = new List<CSS_DataExchange_Child__c>();
                
                for(CSS_DataExchange_Child__c deChild : [Select id, DataExchangeChild_Status__c from CSS_DataExchange_Child__c 
                                                         where CSS_DataExchange_Parent__c =: dataExchange.Id]) 
                {
                    deChild.DataExchangeChild_Status__c = 'Processed';
                    dataExchangeChild_new.add(deChild);
                }
                if(dataExchangeChild_new.size()>0)
                {
                    try {
                        update dataExchangeChild_new;
                    } catch(Exception ex) {
                        wrapperObj.Status='ERROR';
                        wrapperObj.ReturnCode='CSS11';
                        wrapperObj.ReturnCodeDescription='Guidanz Internal Error-DECHILD. Please contact Guidanz Support.';
                        return prepareResponseWrapper(wrapperObj, null);
                    }
                }
                    
                wrapperObj.Status='Success';
                wrapperObj.ReturnCode='CSS00';
                wrapperObj.ReturnCodeDescription='';
                System.debug('Everything Succeeded: ' + cssJob);
                return prepareResponseWrapper(wrapperObj, JobName);
            }
            else{
                system.debug('Else is printing');
                wrapperObj.Status='ERROR';
                wrapperObj.ReturnCode='CSS01';
                wrapperObj.ReturnCodeDescription='Data Exchange is not Enabled for SP';
                return prepareResponseWrapper(wrapperObj, null);
            }
        }
        
        return resJSON;
    }

// This method is used for the sharing settigns
  public static CSS_Job_Order__share grantShareServJobs(String usersToShare,String ServiceJobId,String rowCause){
         CSS_Job_Order__share cjo;
      System.debug('**'+usersToShare);
      if(usersToShare!=null && usersToShare!='' ){
           cjo = new CSS_Job_Order__share(); 
            cjo.AccessLevel ='EDIT';
            cjo.ParentId = ServiceJobId;
            cjo.UserOrGroupId = usersToShare;
            cjo.RowCause = rowCause;
      }           
      System.debug('Sharing servicejobs list :' + cjo);
        return cjo;
    }  
   
    public static CSS_SendJobInfoResWrapper prepareResponseWrapper(WrapperInput wrapperObj, String JobName){
        //CSS_SendJobInfoResWrapper resJSON = null;   
        //CSS_SendJobInfoResWrapper.Header resHeader = null;
        CSS_SendJobInfoResWrapper resJSON = new CSS_SendJobInfoResWrapper();
        CSS_SendJobInfoResWrapper.Header resHeader = new CSS_SendJobInfoResWrapper.Header();
        CSS_SendJobInfoResWrapper.DataArea resJSONDA = new CSS_SendJobInfoResWrapper.DataArea();
        
        List<CSS_Job_Order__c> lstCSSJob =new List<CSS_Job_Order__c>();
        DEWrapper wrapDE;
        string Response;
        try{
            //resHeader = new CSS_SendJobInfoResWrapper.Header();
            resHeader.ServiceName = wrapperObj.ServiceName;
            resHeader.ServiceVersion = wrapperObj.ServiceVersion;
            resHeader.Status=wrapperObj.Status;
            resHeader.ReturnCode=wrapperObj.ReturnCode;
            resHeader.ReturnCodeDescription=wrapperObj.ReturnCodeDescription;

            if(JobName != null){
                resJSONDA.CSSJobID = JobName;
            }
            else{
                resJSONDA.CSSJobID = null;
            }
           
            //resJSON = new CSS_SendJobInfoResWrapper();
            resJSON.DataArea = resJSONDA;
            resJSON.Header = resHeader;
            system.debug('resJSON'+resJSON);
        }
        catch(Exception ex){
            system.debug('Error:' + ex.getLineNumber()+ ex.getMessage());
            resHeader.ServiceName = wrapperObj.ServiceName;
            resHeader.ServiceVersion = wrapperObj.ServiceVersion;
            resHeader.Status='ERROR';
            resHeader.ReturnCode='CSS11';
            resHeader.ReturnCodeDescription='Guidanz Internal Error-PREP. Please contact Guidanz Support.';
            resJSONDA.CSSJobID = null;
            resJSON.Header = resHeader;
            resJSON.DataArea = resJSONDA;
        }
        return resJSON;
    }   
    
    public class WrapperInput {
        public String ServiceName;
        public String ServiceVersion;
        public String ToolID;
        public String SPCode;
        public String SenderID;
        public String TargetID;

        //                         Customer information
        public string CustomerName;
        public String DateAvailService;
        public string ShopWO;
        //                         Unit Information
        public string PSN;
        public string UnitNumber;
        public String Application;
        public String ServiceModelNM;
        public String Make;
        public String Model;
        public String VIN;
        public String WarrStartDate;
        public String BeforeInService;
        public String FailureDate;
        public String MileageOrKms;
        public String MileageMeasure;
        public String Hours;
        
        public string ComplaintText;   // Story Dunkirk
        public String Code; 
        
        //        public String FailurePoint;
        
        public String CSSJOBID;
        public String Status;
        public String ReturnCode;
        public String ReturnCodeDescription;
        //public List<SERVICEHIST> SERVICEHIST;
        
    }
    
    global Class DEWrapper{
        String response;
    }
    
}