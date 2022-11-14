/*******************************************************************************************************************
Name:FSL_CL_CreatePMWorkorder
Copyright Â© 2020  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This is class written for User story CT2-352 to receive PM service order from BMS. 
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     Ravikanth Macherla        11/30/2020    Initial Development 
2.0     Ravikanth Macherla        01/13/2020     US-CT2-374
3.0     Ravikanth Macherla        01/18/2020     US-CT2-399
4.0     Ravikanth Macherla        05/12/2021     PM Integration Issue
5.0     Karthik Pedditi           07/19/2021     Scheduled date field to populate CT2-787
6.0     Madhavi/Jesse             05/02/2022     FBI-304 to populated Service Territory
7.0      Gnyana                   05/03/2022     FBI-303
8.0		Shailender				  30/06/2022	 FBI-339
********************************************************************************************************************/
public class FSL_CL_CreatePMWorkorder {
    
    private static Id recordTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Schedule').getRecordTypeId();
    private static string strlocationCode ;
    private static ServiceTerritory objST ;
    
    public String createPMWorkorder(FSL_CL_SOWrapper objRequestWrapper) {
        String jsonData;
        list<WorkOrder> lstWO = new list<WorkOrder>();
        list<FSL_Custom_Part__c> lstParts = new list<FSL_Custom_Part__c>();
        list<FSL_SRT__c> lstSRT = new list<FSL_SRT__c>();
        set<string> accId = new set<string>();
        set<string> typePSN = new set<string>();
        set<string> siteId = new set<string>();
        set<String> CustomerSiteId = new Set<String>();
        set<string> conId = new set<string>();
        set<String> setERPWorkOrder = new set<String>();
        list<String> lstERPNumberNotCreated = new list<String>();
        set<string> strSubType = new set<string>();
        map<string,Account> accMap = new map<string,Account>();
        map<string,Schema.Address> mapsite = new map<string,Schema.Address>();
        //map<string,Schema.Address> mapsiteCon = new map<string,Schema.Address>();
        map<string,Contact> mapCon = new map<string,Contact>();
        Set<String> siteConIdSet = new Set<String>();
        map<string,Asset> astId = new map<string,Asset>();
        map<String,String> MapErpWorkOrdrNumber = new map<String,String>();
        map<string,FSL_SubType__c> stMap = new map<string,FSL_SubType__c>();
        Map<Id,Account> accIdMap = new Map<Id,Account>(); //added by mallika as part of cps-102:10/29
        strlocationCode = objRequestWrapper.header.locationCode ;
        List<CSS_Integration_Error__c> lstCSSIntegration = new List<CSS_Integration_Error__c>();
        Savepoint sp = Database.setSavepoint(); //FBI-339
        try{
            //FBI-339 : replaced variable with List to avoid 'No rows assigned' SOQL exception.
            List<ServiceTerritory> serviceTerritories;
            if(strlocationCode!=null){
                system.debug('strlocationCode--'+strlocationCode);
                string updatedLocationCode = strlocationCode+'%';
                if(String.isNotBlank(objRequestWrapper.DataArea[0].TransactionType) && objRequestWrapper.DataArea[0].TransactionType == 'PM'){ //FBI-304
                    serviceTerritories =[select id, Work_Type__c from ServiceTerritory where Location_Code__c LIKE :updatedLocationCode AND Work_Type__c INCLUDES ('FPG')];
                }
                //Added by Madhavi as part of FBI-304. This populates the ST based on the transaction type and location from the request and the ST work type value of the child territories.
                if (String.isNotBlank(objRequestWrapper.DataArea[0].TransactionType) && objRequestWrapper.DataArea[0].TransactionType != 'PM'  && String.isNotBlank(objRequestWrapper.DataArea[0].TransactionType)  && objRequestWrapper.DataArea[0].SiteLocation == 'Mobile') {
                    serviceTerritories =[select id, Work_Type__c from ServiceTerritory where Location_Code__c LIKE :updatedLocationCode AND Work_Type__c INCLUDES ('Mobile')];           
                }
                if (String.isNotBlank(objRequestWrapper.DataArea[0].TransactionType) && objRequestWrapper.DataArea[0].TransactionType != 'PM' && String.isNotBlank(objRequestWrapper.DataArea[0].TransactionType) &&  objRequestWrapper.DataArea[0].SiteLocation == 'In Shop') {
                    serviceTerritories =[select id, Work_Type__c from ServiceTerritory where Location_Code__c LIKE :updatedLocationCode AND Work_Type__c INCLUDES ('In Shop')];           
                }
            }
            //end of FBI-304
            //FBI-339 : If Service Territory match not found, do not process.
            if (serviceTerritories != null && !serviceTerritories.isEmpty()) { 
                objST = serviceTerritories[0];
                for(FSL_CL_SOWrapper.DataArea  objDataarea : objRequestWrapper.DataArea ){
                    accId.add(objDataarea.CustomerCode);
                    if('99'.equalsIgnoreCase(objDataarea.EngineFamily) || 'NON CUMMINS'.equalsIgnoreCase(objDataarea.ServiceModelName)){
                        typePSN.add(objDataarea.Type + '-' + objDataarea.CustomerCode + '-' + objDataarea.UnitNumber);
                    } else{
                        if('ENGINE'.equalsIgnoreCase(objDataarea.Type) || 'GENSET'.equalsIgnoreCase(objDataarea.Type)){
                            typePSN.add('Engines'+'-'+objDataarea.PSN);
                        } else{
                            typePSN.add('Products'+'-'+objDataarea.PSN);
                        }
                    }
                    setERPWorkOrder.add(objDataarea.ERPWorkOrder);
                    siteId.add(objDataarea.SiteId);
                    CustomerSiteId.add(objDataarea.SiteContactId);
                    strSubType.add(objDataarea.SubType);
                    siteConIdSet.add(objDataarea.SiteContactId);
                }
                
                //get existing workorders
                Map<String,WorkOrder> existingWorkOrderErpNos = new Map<String,WorkOrder>();
                for(WorkOrder objWO : [select id,Shop_Work_Order__c,WorkOrderNumber from WorkOrder where Shop_Work_Order__c in :setERPWorkOrder]){
                    existingWorkOrderErpNos.put(objWO.Shop_Work_Order__c.toLowerCase(),objWO); 
                }
                
                // Add US_CT2_374
                if(strSubType !=null && strSubType.size()>0){
                    for(FSL_SubType__c objst :[select id,Name,Code_Value__c from FSL_SubType__c where Code_Value__c IN : strSubType AND Location_Code__c = :strlocationCode]){
                        stMap.put(objst.Code_Value__c.toLowercase(), objst);
                    }
                }
                
                if(accId !=null && accId.size()>0 ){
                    for(Account objacc :[select id,FSL_ERP_Customer_Code__c from Account where FSL_ERP_Customer_Code__c IN :accId]){
                        accMap.put(objacc.FSL_ERP_Customer_Code__c,objacc);
                        accIdMap.put(objacc.Id,objacc);//added by mallika as part of cps-102:10/29
                    }
                }
                
                if(typePSN != Null && typePSN.size()>0){
                    for(Asset objAsset : [select id,Type_PSN__c  from Asset where Type_PSN__c IN :typePSN]){
                        astId.put(objAsset.Type_PSN__c.toLowercase(),objAsset );
                    }
                }
                system.debug('astId-->'+astId);
                
                if( !siteId.isEmpty() ){//Added part of FBI-311 to check Site Ids are not null
                    for(Schema.Address objSite :[select id,Parent.FSL_Account__r.FSL_ERP_Customer_Code__c from Address where Parent.FSL_Account__r.FSL_ERP_Customer_Code__c IN :accId and FSL_Site_ID__c IN :siteId ]){
                        mapsite.put(objSite.Parent.FSL_Account__r.FSL_ERP_Customer_Code__c,objSite);
                    }	
                }
                
                /*
for(Schema.Address objSiteCon :[select id,Parent.FSL_Contact_ID__c,Parent.FSL_Contact__r.ERP_Customer_Code__c,Parent.FSL_Contact__r.Id from Address where Parent.FSL_Contact__r.ERP_Customer_Code__c IN :accId and FSL_Site_ID__c IN :siteId ]){
mapsiteCon.put(objSiteCon.Parent.FSL_Contact__r.ERP_Customer_Code__c,objSiteCon);
}
system.debug('mapsiteCon--'+mapsiteCon.keyset());
*/
                if(siteConIdSet != null && siteConIdSet.size()>0){
                    //added by mallika as part of cps-102 to include filter criteria based on account:10/29 
                    for(Contact con: [SELECT id,ERP_Customer_Code__c FROM Contact WHERE FSL_Contact_Id__c IN :siteConIdSet AND AccountId =: accIdMap.keySet()]){
                        mapCon.put(con.ERP_Customer_Code__c,con);
                    }
                }
                
                
                Map<Integer,List<ServiceAppointment>> saMap = new Map<Integer,List<ServiceAppointment>>();
                Integer index = 0;         
                List<String> workTypeNamesList = new List<String>();
                workTypeNamesList.add('PM');
                workTypeNamesList.add('MINOR');
                Map<String,WorkType> WrkTypeNameVsWrkType = new Map<String, WorkType>();
                
                for(WorkType wrkType : [Select Id, Name From WorkType Where Name IN:workTypeNamesList]) {
                    WrkTypeNameVsWrkType.put(wrkType.Name.toUpperCase(), wrkType);
                }
                for(FSL_CL_SOWrapper.DataArea  objDataarea : objRequestWrapper.DataArea ){
                    system.debug('check req'+objDataarea);
                    //if existing then skip 
                    if(existingWorkOrderErpNos.containsKey(objDataarea.ERPWorkOrder.toLowerCase())){
                        continue;
                    }
                    
                    WorkOrder objWO = new WorkOrder();
                    objWO.Shop_Work_Order__c= objDataarea.ERPWorkOrder;
                    objWO.RecordTypeId = recordTypeId;
                    if(!WrkTypeNameVsWrkType.isEmpty()) {
                        if(String.isNotBlank( objDataarea.TransactionType) 
                           && objDataarea.TransactionType.toUpperCase() == 'PM'
                           && WrkTypeNameVsWrkType.containsKey('PM')
                          ) {
                              objWO.workTypeId = WrkTypeNameVsWrkType.get('PM').Id;
                          } else if(WrkTypeNameVsWrkType.containsKey('MINOR')) {
                              objWO.workTypeId = WrkTypeNameVsWrkType.get('MINOR').Id;// part of FBI_303
                          }
                    }
                    
                    String typePsnStr;
                    if('99'.equalsIgnoreCase(objDataarea.EngineFamily) || 'NON CUMMINS'.equalsIgnoreCase(objDataarea.ServiceModelName)){
                        typePsnStr = objDataarea.Type + '-' + objDataarea.CustomerCode + '-' + objDataarea.UnitNumber;
                    } else{
                        if('ENGINE'.equalsIgnoreCase(objDataarea.Type) || 'GENSET'.equalsIgnoreCase(objDataarea.Type)){
                            typePsnStr = 'Engines'+'-'+objDataarea.PSN;
                        } else{
                            typePsnStr = 'Products'+'-'+objDataarea.PSN;
                        }
                    }
                    
                    if(astId!=null && astId.containsKey(typePsnStr.toLowerCase())){
                        system.debug('inside');
                        objWO.AssetId = astId.get(typePsnStr.toLowerCase()).Id;
                    }
                    if(accMap!=null && accMap.containskey(objDataarea.CustomerCode)){
                        objWO.AccountId = accMap.get(objDataarea.CustomerCode).Id; 
                    }
                    if(mapsite!= Null && mapsite.containskey(objDataarea.CustomerCode)){
                        system.debug('Test-->'+mapsite.get(objDataarea.CustomerCode).id);
                        if( objRequestWrapper.DataArea[0].SiteLocation != 'In Shop' )//Added as part of FBI-311 to check Site location Not a "In Shop"
                            objWO.Repair_Site_Address__c =  mapsite.get(objDataarea.CustomerCode).id;
                    }
                    system.debug('SiteContactIdo--'+objDataarea.CustomerCode);
                    if(mapCon != Null && mapCon.containskey(objDataarea.CustomerCode)){
                        system.debug('SiteContactId--'+objDataarea.SiteContactId);
                        //system.debug('mapsiteCon--'+mapsiteCon.get(objDataarea.CustomerCode).Parent.FSL_Contact__r.Id);
                        //objWO.ContactId =  mapsiteCon.get(objDataarea.CustomerCode).Parent.FSL_Contact__r.Id;
                        objWO.ContactId =  mapCon.get(objDataarea.CustomerCode).Id; 
                    }
                    
                    if(stMap!=null && stMap.containskey(objDataarea.SubType.toLowercase())){
                        objWO.FSL_Sub_Type__c =  stMap.get(objDataarea.SubType.toLowercase()).Id;
                    }
                    
                    if(objST !=null){
                        objWO.ServiceTerritoryId = objST.Id;
                    }
                    //CT2-787 - Karthik Pedditi
                    if(objDataarea.ScheduledDate!=null && objDataarea.ScheduledDate!=''){
                        objWO.Schedule_Date__c =Date.valueof(objDataarea.ScheduledDate);
                        if(objDataarea.ScheduledDate<=String.valueOf(System.today())){
                            objWO.Available_for_Service__c=datetime.now().AddMinutes(+30); //Earliest Start Permitted will be current date and Time +30 min, If ScheduleDate less than or equal to Current date
                        }
                        if(objDataarea.ScheduledDate>String.valueOf(System.today())){
                            datetime sc=date.valueOf(objDataarea.ScheduledDate);
                            objWO.Available_for_Service__c=sc.addHours(12); //ScheduleDate greater than Current date ,then Earliest Start Permitted should be ScheduleDate
                        }
                    } //CT2-787
                    
                    system.debug('BeforeWO--'+lstWO);
                    objWO.Is_PMBMS__c = True;
                    //objWO.Type__c = objDataarea.Type;
                    objWO.Status = 'Intake Complete';
                    objWO.Process_Step__c = 'Schedule';
                    objWO.Shop_Work_Order__c = objDataarea.ERPWorkOrder;
                    objWO.EditComplaint__c = objDataarea.Complaint ;
                    objWO.EditCause__c = objDataarea.Cause;
                    objWO.EditCorrection__c = objDataarea.Correction ;
                    objWO.Labor_Multiplier__c = objDataarea.LaborMultiplier;
                    objWO.CreatedFromRecommendation__c = true;
                    objWO.Supervisor_First_Name__c = objDataarea.SupervisorFirstName;
                    objWO.Supervisor_Last_Name__c = objDataarea.SupervisorLastName;
                    objWO.Repair_Location__c = objDataarea.SiteLocation;
                    objWO.Sales_Segment__c = objDataarea.SalesSegment;
                    system.debug('=============='+strlocationCode);
                    if((objDataarea.SupervisorFirstName !=null || objDataarea.SupervisorLastName !=null) && strlocationCode !=null){
                        String territoryCode = '%'+ strlocationCode.split('-')[1] +'%';
                        List<User> userList = [Select id,FSL_Primary_Service_Territory_Code__c  from user where 
                                               FirstName =:objDataarea.SupervisorFirstName AND LastName =:objDataarea.SupervisorLastName];
                        List<FSL__User_Territory__c> userTerritory = [Select id,FSL__User__c,FSL__ServiceTerritory__c,
                                                                      FSL__ServiceTerritory__r.Location_Code__c  from FSL__User_Territory__c
                                                                      where FSL__User__c IN:userList AND FSL__ServiceTerritory__r.Location_Code__c like: territoryCode];
                        
                        if(userTerritory !=null && userTerritory.size() ==1){
                            objWO.Service_Team_Contact__c =  userTerritory[0].FSL__User__c;
                        }else{
                            objWO.Service_Team_Contact__c =  null; 
                        }
                    }                
                    // Add US_CT2_374  added By Ravi
                    
                    if(objDataarea.Complaint!=null){
                        objWO.General_Symptoms__c = objDataarea.Complaint;
                    }
                    if(objDataarea.PromisedDate!=null && objDataarea.PromisedDate!=''){
                        objWO.Promised_Date__c = date.valueof(objDataarea.PromisedDate);
                    }
                    objWO.Transaction_Type__c = objDataarea.TransactionType;
                    objWO.Service_Type__c = objDataarea.ServiceType;
                    objWO.Number_of_Technicians__c = integer.valueof(objDataarea.NumberOfTechnicians);
                    objWO.Status_Notes__c = objDataarea.StatusNotes;
                    if(objDataarea.ERPContractNumber!=null && objDataarea.ERPContractNumber!=''){
                        objWO.ERP_Contract_Number__c = string.valueOf(objDataarea.ERPContractNumber);
                    }
                    objWO.FSL_Project_Number__c = objDataarea.ProjectNumber;
                    objWO.Preferred_Technician__c = objDataarea.PreferredTechnician;
                    objWO.Work_Order_Notes__c = objDataarea.WorkOrderNotes;
                    objWO.Payment_Type__c = objDataarea.PaymentType;
                    objWO.Prepaid__c = objDataarea.Prepaid;
                    if(objDataarea.InvoiceDate!=null && objDataarea.InvoiceDate!=''){
                        objWO.Invoice_Date__c = date.valueof(objDataarea.InvoiceDate);
                    }
                    objWO.Task_Group__c = objDataarea.TaskGroup;
                    lstWO.add(objWO);
                    
                    //CT2-447
                    if(objWO.Number_of_Technicians__c != null){
                        Integer saCount = 0;
                        while(saCount < objWO.Number_of_Technicians__c){
                            ServiceAppointment sa = new ServiceAppointment();
                            sa.ServiceTerritoryId = objWO.ServiceTerritoryId;
                            sa.contactId = objWO.contactId;
                            sa.EarliestStartTime = objWO.Available_for_Service__c;
                            if(!String.isEmpty(objDataarea.TotalDuration)){
                                sa.Duration = Decimal.valueOf(objDataarea.TotalDuration); 
                            }
                            sa.DurationType = 'Hours';
                            
                            if(!saMap.containsKey(index)){
                                saMap.put(index,new List<ServiceAppointment>());
                            } 
                            saMap.get(index).add(sa);
                            saCount++;
                        }
                    }
                    index++;
                    
                    system.debug('lstWO--'+lstWO);
                    
                }
                // try{
                if(lstWO!=null && lstWO.size()>0)
                    insert lstWO;
                
                //CT2-447 starts
                List<ServiceAppointment> saInsertList = new List<ServiceAppointment>();
                index = 0;
                for(WorkOrder wo:lstWO){
                    if(saMap.containsKey(index)){
                        for(ServiceAppointment sa:saMap.get(index)){
                            sa.parentRecordId = wo.id;
                            sa.Service_Order__c = wo.id;
                            saInsertList.add(sa);
                        }
                    }
                    index++;
                }
                insert saInsertList;
                //CT2-447 ends
                // }
                //  catch(exception e){
                // system.debug('EX--'+e);
                // }
                // Database.SaveResult[] srList = Database.insert(lstWO, false);
                
                for(WorkOrder objWO : [select id,Shop_Work_Order__c  from WorkOrder where Shop_Work_Order__c in :setERPWorkOrder]){
                    MapErpWorkOrdrNumber.put(objWO.Shop_Work_Order__c,objWO.id); 
                    
                }
                system.debug('lstWO2'+lstWO);
                list<Note> lstnote = new list<Note>();
                for(FSL_CL_SOWrapper.DataArea  objDataarea : objRequestWrapper.DataArea ){ 
                    if(!MapErpWorkOrdrNumber.containskey(objDataarea.ERPWorkOrder)){
                        lstERPNumberNotCreated.add(objDataarea.ERPWorkOrder);
                    }
                    system.debug('objDataarea.ERPWorkOrder--'+objDataarea.ERPWorkOrder);
                    if(MapErpWorkOrdrNumber.containskey(objDataarea.ERPWorkOrder)){
                        system.debug('inside.ERPWorkOrder--'+objDataarea.ERPWorkOrder);
                        Note objnote = new Note();
                        objnote.ParentId= MapErpWorkOrdrNumber.get(objDataarea.ERPWorkOrder);
                        objnote.Body =objDataarea.WorkOrderNotes;
                        objnote.Title ='TECHNICIANNOTES';
                        lstnote.add(objnote);
                    } 
                }
                system.debug('lstnote--'+lstnote);
                if(lstnote !=null && lstnote.size()>0){
                    insert lstnote;
                }
                system.debug('lstnotein--'+lstnote);
                for(FSL_CL_SOWrapper.DataArea  objDataarea : objRequestWrapper.DataArea ){ 
                    if(MapErpWorkOrdrNumber != Null && MapErpWorkOrdrNumber.containskey(objDataarea.ERPWorkOrder)){
                        for(FSL_CL_SOWrapper.Parts objParts : objDataarea.Parts){
                            
                            FSL_Custom_Part__c objPartsCreate = new FSL_Custom_Part__c();
                            objPartsCreate.Service_Order__c =  MapErpWorkOrdrNumber.get(objDataarea.ERPWorkOrder);
                            objPartsCreate.Part_Number__c = objParts.PartNumber ;
                            objPartsCreate.Product_Code__c = objParts.ProductCode ;
                            objPartsCreate.Quantity_Ordered__c = string.isNotEmpty(objParts.PartQuantityOrdered)? integer.valueof(objParts.PartQuantityOrdered): Null;
                            objPartsCreate.Quantity_Used__c = string.isNotEmpty(objParts.PartQuantityUsed)? integer.valueof(objParts.PartQuantityUsed): Null ;
                            objPartsCreate.EPR_Flag__c = objParts.EPRFlag ;
                            objPartsCreate.Sub_Location__c = objParts.PartLocation ;
                            objPartsCreate.Part_Line_Type__c = objParts.PartLineType ; 
                            objPartsCreate.Part_Line_Number__c = objParts.PartLineNumber;
                            
                            lstParts.add(objPartsCreate);
                        }
                    }
                }
                
                for(FSL_CL_SOWrapper.DataArea  objDataarea : objRequestWrapper.DataArea){ 
                    if(MapErpWorkOrdrNumber != Null && MapErpWorkOrdrNumber.containskey(objDataarea.ERPWorkOrder)){      
                        for(FSL_CL_SOWrapper.SRTS objSRT : objDataarea.SRTS){
                            FSL_SRT__c objFSLSrt = new FSL_SRT__c ();
                            objFSLSrt.Service_Order__c = MapErpWorkOrdrNumber.get(objDataarea.ERPWorkOrder);
                            if(objSRT.TotalDuration !=null && objSRT.TotalDuration!=''){
                                objFSLSrt.Total_Actual_Hours__c = Decimal.valueof(objSRT.TotalDuration);
                            }
                            objFSLSrt.SRT_Title__c = objSRT.SRTDescription;
                            if(objSRT.SRTTime!=null && objSRT.SRTTime!=''){
                                objFSLSrt.SRT_Time__c = Decimal.valueof(objSRT.SRTTime); 
                            }
                            if(objSRT.SRTQuantity!=null && objSRT.SRTQuantity!=''){
                                objFSLSrt.SRT_Quantity__c = integer.valueof(objSRT.SRTQuantity); 
                            }
                            objFSLSrt.SRT_Procedure__c = objSRT.SRTProcedure ;
                            objFSLSrt.SRT_Group__c = objSRT.SRTGroup ;
                            objFSLSrt.Type__c = 'Repair Access';
                            objFSLSrt.Name = objSRT.SRTGroup +'-'+ objSRT.SRTProcedure;
                            lstSRT.add(objFSLSrt);
                        }
                    }
                }
                insert lstParts;
                insert lstSRT;
                
                system.debug('lstParts--'+lstParts);
                system.debug('lstSRT--'+lstSRT);
                
                FSL_CL_PMOrderwraperResult objPMResult = new FSL_CL_PMOrderwraperResult();
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();   
                gen.writeFieldName('Header');
                gen.writeStartObject(); 
                gen.writeStringField('LocationCode',strlocationCode);
                gen.writeStringField('ReturnCodeDescription','Records Processed');
                gen.writeStringField('Status','SUCCESS');
                gen.writeEndObject();
                gen.writeFieldName('DataArea');
                gen.writeStartArray();
                
                for(WorkOrder objWO : [select id,Shop_Work_Order__c,WorkOrderNumber  from WorkOrder where Shop_Work_Order__c in :setERPWorkOrder]){
                    if(!existingWorkOrderErpNos.containsKey(objWO.Shop_Work_Order__c.toLowerCase())){
                        //Adding for Jira_FBI_323
                        String woNumber;
                        String SourceType= System.Label.FSL_Source_Environment_Type;
                        if(SourceType == 'GZEVLPRD') {
                            woNumber = objWO.WorkOrderNumber;
                            system.debug('WoNumber:'+woNumber);
                        } else {
                            woNumber = SourceType.right(3)+'-'+objWO.WorkOrderNumber;
                            system.debug('WoNumber:'+woNumber);
                        }
                        gen.writeStartObject();
                        gen.writeStringField('ERPWorkOrder',objWO.Shop_Work_Order__c);
                        gen.writeStringField('GuidanzServiceOrder',woNumber);
                        gen.writeStringField('ReturnCodeDescription','Record Processed Successfully');
                        gen.writeStringField('Status','SUCCESS');
                        gen.writeEndObject();
                    }
                }
                
                if(lstERPNumberNotCreated  != Null && lstERPNumberNotCreated.size() > 0){
                    for(String objErpNumber : lstERPNumberNotCreated ){
                        gen.writeStartObject();
                        gen.writeStringField('ERPWorkOrder',objErpNumber);
                        gen.writeStringField('GuidanzServiceOrder','');
                        gen.writeStringField('ReturnCodeDescription','Record not created successfully');
                        gen.writeStringField('Status','Error');
                        gen.writeEndObject();
                        CSS_Integration_Error__c CSSIError = new CSS_Integration_Error__c();
                        CSSIError.Error_Description__c = 'Record not created successfully';
                        CSSIError.Source__c = 'Guidanz';
                        CSSIError.Service_Job_Number__c = objErpNumber;
                        CSSIError.Service_Name__c = 'FSL_CL_CreatePMWorkorder';
                        lstCSSIntegration.add(CSSIError);
                    }
                }
                
                if(!existingWorkOrderErpNos.isEmpty()){
                    for(String objErpNumber : existingWorkOrderErpNos.KeySet()){
                        // Adding for Jira_FBI_323
                        String woNumber;
                        String SourceType= System.Label.FSL_Source_Environment_Type;
                        if(SourceType == 'GZEVLPRD') {
                            woNumber = existingWorkOrderErpNos.get(objErpNumber).WorkOrderNumber;
                            
                        } else {
                            woNumber = SourceType.right(3)+'-'+existingWorkOrderErpNos.get(objErpNumber).WorkOrderNumber;
                        }
                        gen.writeStartObject();
                        gen.writeStringField('ERPWorkOrder',existingWorkOrderErpNos.get(objErpNumber).Shop_Work_Order__c);
                        gen.writeStringField('GuidanzServiceOrder',woNumber);
                        gen.writeStringField('ReturnCodeDescription','ERP Work Order already exists');
                        gen.writeStringField('Status','Error');
                        gen.writeEndObject();
                        CSS_Integration_Error__c CSSIError = new CSS_Integration_Error__c();
                        CSSIError.Error_Description__c = 'ERP Work Order already exists';
                        CSSIError.Source__c = 'Guidanz';
                        CSSIError.Service_Job_Number__c = existingWorkOrderErpNos.get(objErpNumber).Shop_Work_Order__c;
                        CSSIError.Service_Name__c = 'FSL_CL_CreatePMWorkorder';
                        lstCSSIntegration.add(CSSIError);
                    }
                }
                gen.writeEndArray();
                gen.writeEndObject();
                jsonData = gen.getAsString();
                System.debug('jsonData-' + jsonData);
            }
            else {
                //FBI-339 : If Service Territory match not found, return Error.
                JSONGenerator gen = JSON.createGenerator(true);
                gen.writeStartObject();
                gen.writeStringField('ReturnCodeDescription','No matching Service Territory found');
                gen.writeStringField('Status','Error');
                gen.writeEndObject();
                jsonData = gen.getAsString();
            }
            
        }catch(exception e){
            Database.rollback(sp); // FBI-339
            system.debug('Entered into catch block of callODMHeaderValidationClaimsService>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString());
            CSS_Integration_Error__c CSSIError = new CSS_Integration_Error__c();
            CSSIError.Error_Description__c = 'Entered into catch block of FSL_CL_CreatePMWorkorder'+e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString();
            CSSIError.Source__c = 'Guidanz';
            CSSIError.Service_Name__c = 'FSL_CL_CreatePMWorkorder';
            lstCSSIntegration.add(CSSIError); 
            
            //START - FBI-339
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('Exception Message: ',e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString()+';;  ');
            gen.writeStringField('Status','Error');
            gen.writeEndObject();
            jsonData = gen.getAsString();
            System.debug('jsonData-' + jsonData);
            //END - FBI-339
        } 
        if(lstCSSIntegration.size()>0){
            insert lstCSSIntegration;
        }
        return jsonData ;
    }
}