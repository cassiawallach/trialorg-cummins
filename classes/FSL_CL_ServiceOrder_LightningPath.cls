/**********************************************************************
Name: FSL_CL_ServiceOrder_LightningPath
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used to control all stage path functionality.
======================================================
History                                                            
-------                                                             
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0 -    Rajashekar Nallapati   07/18/2019      INITIAL DEVELOPMENT    
2.0 -    Shailender             18/08/2022      Code optimization                
***********************************************************************/
public class FSL_CL_ServiceOrder_LightningPath {
    public static boolean isTechDispatched;
    @AuraEnabled
    public static String getChevronData(String recId){ 
        String fieldName = 'Process_Step__c,Status,Type__c,Authorized_Work_Started__c,Service_Work_Completed__c';
        system.debug('fieldName '+fieldName);
        System.debug('recId '+recId);
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        Map<String,String> objectMap = new Map<String,String>();
        for(Schema.SObjectType f : gd)
        {
            objectMap.put(f.getDescribe().getKeyPrefix(), f.getDescribe().getName());
        }
        String prefix =  recId.left(3); 
        String objectName = objectMap.get(prefix);
        //Added below line as part of FBI - 383
        String query = 'SELECT '+String.escapeSingleQuotes(fieldName)+' FROM '+String.escapeSingleQuotes(objectName)+' WHERE Id =: recId';        
        List<SOBject> lstObj = Database.query(query);        
        // String selVal =  String.valueOf(lstObj[0].get(fieldName)) ;  
        String selVal =  String.valueOf(lstObj[0].get('Process_Step__c')) ; // Added Ravikanth
        String status =  String.valueOf(lstObj[0].get('Status')) ; // Added Ravikanth
        String Type =  String.valueOf(lstObj[0].get('Type__c')) ; // Added Ravikanth
        
        system.debug('status-->'+status);
        Schema.SObjectField sobjField = Schema.getGlobalDescribe().get(objectName).getDescribe().Fields.getMap().get('Process_Step__c') ;
        Schema.DescribeFieldResult fieldResult = sobjField.getDescribe() ;
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        Boolean curValMatched = false;
        Integer widthPerItem = 100/ple.size() ;
        List<chevronData> lstRet = new List<chevronData>();  
        
        String profileName = GetLoggedInUserProfileName();
        System.debug('profileName '+ profileName);
        //  CSS_Service_Advanced
        //  CSS_Service_Technician
        // Added Ravikanth
        List<String> stageList = new List<String>();
        if(status !=null && Type != 'External' && (status =='Intake' || status=='Job Plan' || status=='Closed')){
            stageList = FSL_CumminsUtilities.getStageValuesforRecordtype(profileName,status,Type); 
        }
        else{
            stageList = FSL_CumminsUtilities.getStageValues(profileName); 
        }
        System.debug('stageList '+stageList);
        for( Schema.PicklistEntry f : ple)
        {
            System.debug('picklistvalues '+ f);
            chevronData obj = new chevronData();
            //Added by Harish -TW-204
            if(Type != 'Internal' &&  profileName == 'CSS_Service_Technician' && f.getValue() == 'Intake'){
                obj.isActive = false;
                obj.disablePointer='auto';
                obj.cssClass = 'Inactive'; 
                obj.val = f.getLabel();
                obj.value = f.getValue(); 
                obj.width = widthPerItem+'%';
                lstRet.add(obj);
                continue;
            }
            if(stageList.contains(f.getValue())){//pickListVal.getValue()getLabel() //Added by Harsha for path color Higlight on 08/26/2020
                
                obj.isActive = true; 
                
            }else{
                obj.isActive = false;
                
            } 
            System.debug('f.getLabel() '+ f.getLabel());
            obj.val = f.getLabel();
            obj.value = f.getValue(); //Added by Harsha for path color Higlight on 08/26/2020
            obj.width = widthPerItem+'%';    
            if(selVal == 'Close')
            {
                if(f.getLabel() != 'Close')
                    obj.disablePointer = 'none';
                else
                    obj.disablePointer='auto';
            }
            else if(stageList.contains(profileName) && f.getLabel() == 'Close')// Added by vinod for the disable of the Close job Techinician
                obj.disablePointer='auto';
            else
                obj.disablePointer='auto';
            System.debug('selVal '+selVal);
            
            //obj.val == selVal == True ==> Current stage value
            if(f.getValue() == selVal){ //Added by Harsha for path color Higlight on 08/26/2020
                obj.cssClass = 'active';
                curValMatched = true;
            }
            else if(!stageList.contains(f.getValue())){//getLabel() //Added by Harsha for path color Higlight on 08/26/2020
                obj.cssClass = 'Inactive'; 
            }
            else{
                obj.cssClass = 'visited'; 
            } 
            system.debug(obj);
            lstRet.add(obj);
        } 
        system.debug('lstRet--'+lstRet);
        return JSON.serialize(lstRet);
    }  
    
    @AuraEnabled
    public static string GetLoggedInUserProfileName(){
        String profileId = UserInfo.getProfileId();
        List<Profile> profileName = [Select Name from Profile where Id =:profileId];
        System.debug('******************Profile Name' +profileName[0].Name);
        return profileName[0].Name;
    }
    
    @AuraEnabled
    
    public static List<String> isStageActiveFor(String loggedInProfileName){
        return FSL_CumminsUtilities.getStageValues(loggedInProfileName); 
    }
    
    @AuraEnabled
    public static void updateStageAndRecordType(String strWorkOrderId,String stageName){
        system.debug('stageName>>'+stageName);
        String query= 'Select Id,Type__c,Authorized_Work_Started__c,Process_Step__c,RecordTypeId FROM WorkOrder WHERE Id=:strWorkOrderId LIMIT 1';
        WorkOrder objWorkOrder = Database.query(query);
        RecordType rt = new RecordType();
        
        switch on stageName {
            when 'Intake' {
                System.debug('Intake');
                objWorkOrder.Process_Step__c = stageName;
                If(objWorkOrder.Type__c == 'Internal'){
                    rt=  [SELECT Id,Name 
                          FROM RecordType
                          WHERE SobjectType='WorkOrder' AND NAME='Internal' LIMIT 1];
                }
                else{
                    rt=  [SELECT Id,Name 
                          FROM RecordType
                          WHERE SobjectType='WorkOrder' AND NAME='Intake' LIMIT 1];
                }
                objWorkOrder.RecordTypeId = rt.Id;
                // objWorkOrder.status=''
            }
            when 'Schedule' {
                System.debug('Schedule');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='Schedule' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
                // objWorkOrder.status=''
            }
            when 'Triage & Diagnosis' {
                System.debug('Triage & Diagnosis');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='T&D' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
                // objWorkOrder.status=''
            }
            when 'Job Plan' {
                System.debug('Job Plan');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='Job Plan' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
            }
            when 'Repair' {
                System.debug('Repair');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='Repair' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
            }
            when 'Warranty Claims' {
                System.debug('Warranty Claims');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='T&D' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
            }
            when 'Invoice' {
                System.debug('Invoice');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='T&D' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
            }
            when 'Close' {
                System.debug('Close');
                objWorkOrder.Process_Step__c = stageName;
                rt=  [SELECT Id,Name 
                      FROM RecordType
                      WHERE SobjectType='WorkOrder' AND NAME='Close' LIMIT 1];
                objWorkOrder.RecordTypeId = rt.Id;
            }
            
            
        }
        update objWorkOrder;
    }
    
    //Added by vinod for stage flow.7/23
    @auraEnabled
    public static String getProcessStatus(String woId)
    {
        String processStatus;
        WorkOrder wo=[SELECT Process_Step__c FROM WorkOrder WHERE id=:woID Limit 1];
        processStatus = wo.Process_Step__c;            
        return processStatus;
    }
    
    //Added by harish - TW-204
    @auraEnabled
    public static String getServiceOrderType(String woId)
    {
        return [SELECT Type__c FROM WorkOrder WHERE id=:woID Limit 1].Type__c;
    }
    
    /* @auraEnabled
public static String getstateStatus(String woId)
{
String stateStatus ;
// WorkOrder wo=[SELECT Sub_Status__c,Status FROM WorkOrder WHERE Status='Repair' AND (Sub_Status__c='Work in Progress' OR Sub_Status__c='Repair Complete') AND id=:woID Limit 1];
WorkOrder wo=[SELECT Sub_Status__c,Status FROM WorkOrder WHERE  (Sub_Status__c='Work in Progress' OR Sub_Status__c='Repair Complete') AND id=:woID Limit 1];
stateStatus = wo.Sub_Status__c;
//stateStatus= wo.Is_Comm_Sent__c ;            
return stateStatus;
} */
    @auraEnabled
    public static Boolean getstateStatus(String woId)
    {
        Boolean stateStatus ;
        // WorkOrder wo=[SELECT Sub_Status__c,Status FROM WorkOrder WHERE Status='Repair' AND (Sub_Status__c='Work in Progress' OR Sub_Status__c='Repair Complete') AND id=:woID Limit 1];
        WorkOrder wo=[SELECT Authorized_Work_Started__c,Service_Work_Completed__c,Sub_Status__c,Fault_Code_Communication_Trigger__c  FROM WorkOrder WHERE  id=:woID Limit 1];
        //if((wo.Authorized_Work_Started__c==false) && (wo.Service_Work_Completed__c ==false)){
        // stateStatus = true ; 
        // } 
        if((wo.Authorized_Work_Started__c==true) || (wo.Service_Work_Completed__c ==true) || (wo.Fault_Code_Communication_Trigger__c==true)){
            stateStatus = true ; 
        }            
        return stateStatus;
    }
    @auraEnabled
    public static Boolean getstateStatus1(String woId)
    {
        Boolean stateStatus1 ;
        LIst<WorkOrder>  wo = new list<WorkOrder>([SELECT Authorized_Work_Started__c,Service_Work_Completed__c FROM WorkOrder WHERE (Sub_Status__c='Work in Progress' OR Sub_Status__c='Repair Complete') AND id=:woID Limit 1]);
        //stateStatus1 = wo.Is_Comm_Sent__c ;
        //stateStatus1 = wo.Authorized_Work_Started__c ;  
        //stateStatus1 = wo.Service_Work_Completed__c ;
        //if((wo.Sub_Status__c=='Work in Progress') || (wo.Sub_Status__c=='Repair Complete')){
        if(wo.size() > 0){
            if((wo[0].Authorized_Work_Started__c=false) && (wo[0].Service_Work_Completed__c ==false)){
                stateStatus1 = true ; 
            } 
            if((wo[0].Authorized_Work_Started__c=true) && (wo[0].Service_Work_Completed__c ==false)){
                stateStatus1 = true ; 
            }     
        }
        
        return stateStatus1;
    }
    
    
    
    
    
    @auraEnabled
    public Static Boolean checkForMostLikely(String woId)
    {
        return FSLJobClosureFlowCls.checkForMostLikely(woId);
    }
    
    @auraEnabled
    public Static Boolean checkForRepairSelection(String woId)
    {
        return FSLJobClosureFlowCls.checkForRepairSelection(woId);
    }
    
    // Added by Ravikanth
    //Description : Make Model record upserting from T& D 
    
    @AuraEnabled
    public static string  insertMakeModelStaging(string servicejobid) {
        // added by harsha
        // Naga Anusha Devi Malepati started 7/21/22 added for capturing Integration errors of Send 4Cs to ERP NIN-444
        List<FSL_WOCommentInboundJson2Apex> commentInboundDetails = new List<FSL_WOCommentInboundJson2Apex>();
        String calloutMessage='';
        // Naga Anusha Devi Malepati Ends 7/21/22 added for capturing Integration errors of Send 4Cs to ERP NIN-444
        
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        
        System.debug('UserERP' + UserERP);
        // ended by harsha
        
        string strResult ;
        list<FSL_MakeModel_Stage__c> lstmake = new list<FSL_MakeModel_Stage__c>();
        if(Limits.getQueries()<Limits.getLimitQueries()) 
        {
            if(servicejobid !=null && servicejobid!=''){
                //added As a part of FBI-393
                List<Id> userIdsToQuery = new List<Id>();
                List<WorkOrder> workOrderList = [select id,Authorized_Work_Started__c,ServiceTerritory.Location_Code__c,CreatedDate,WorkOrderNumber,LastModifiedDate,Shop_Work_Order__c,Failure_Date__c,
                                                 Available_for_Service__c,Make__c,Model__c, CreatedById, LastModifiedById, Asset.Name,Asset.Type__c,Asset.Product_Application_Code__c ,
                                                 Asset.Make__c ,Asset.Model__c,Status,Sub_Status__c,Editcause__c,EditCORRECTION__c,EditCOMPLAINT__c,EditCOVERAGE__c,Correction_Notes__c,Field_Actions__c from workorder where id=:servicejobid ];
                
                for(WorkOrder objorder :workOrderList) {
                    userIdsToQuery.add(objorder.CreatedById);
                    userIdsToQuery.add(objorder.LastModifiedById);
                }
                Map<Id, User> userMap = new Map<Id, User>([SELECT Id, ERP__c ,Name, FederationIdentifier FROM User WHERE Id = :userIdsToQuery]);
                // added as part of FBI-414: Moved  the query out of loop
                fsl_Switch__c switchRecord = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Send_4Cs' ORDER BY CreatedDate Desc limit 1];
                
                for(WorkOrder objorder :workOrderList)
                {
                    // added by harsha
                    user usr1;
                    user usr2;
                    String CreateUser ='';
                    String ChangeUser='';
                    if(!Test.isRunningTest()){
                        usr1 = userMap.get(objorder.CreatedById);
                        usr2 = userMap.get(objorder.LastModifiedById);
                        //usr1 = [SELECT Id, ERP__c ,Name, FederationIdentifier FROM User WHERE Id =:objorder.CreatedById  LIMIT 1];
                        //usr2 = [SELECT Id, ERP__c ,Name, FederationIdentifier FROM User WHERE Id =:objorder.LastModifiedById  LIMIT 1];
                        
                        CreateUser = (String)usr1.FederationIdentifier;
                        ChangeUser = (String)usr2.FederationIdentifier;
                    }
                    string sLoc = objorder.ServiceTerritory.Location_Code__c;
                    //Start - Trupthi 7/18/2022, NIN-409. call utility class to derive the value for sloc and send to ERPS
                    sLoc = FSL_ERP_LocationCode_Util.getLocationCode(sLoc);
                    // if(sLoc.split('-').size()>0)
                    // sLoc = sLoc.split('-')[0]+'-'+sLoc.split('-')[1];
                    system.debug('Location Code:' + sLoc);
                    // END - Trupthi 7/18/2022, NIN-409 call utility class to derive the value for sloc and send to ERPS
                    
                    String commentCurrDate;
                    String commentChangeDate;
                    datetime currentDate = objorder.CreatedDate;
                    datetime changeDate = objorder.LastModifiedDate;
                    
                    datetime ScheduledDate = objorder.Available_for_Service__c;
                    //Below 2 lines are Commented by RAJESH on 6th of Jan 2021 as per CHF-1514 (Sravanthi )
                    //commentCurrDate = currentDate.format('YYYY-MM-dd','GMT') ;
                    //commentChangeDate = changeDate.format('YYYY-MM-dd','GMT');
                    commentCurrDate = currentDate.format('yyyy-MM-dd','GMT') ;
                    commentChangeDate = changeDate.format('yyyy-MM-dd','GMT');
                    commentCurrDate = commentCurrDate+'T' + currentDate.format('HH:mm:ss','GMT');
                    commentChangeDate = commentChangeDate + + 'T' + changeDate.format('HH:mm:ss','GMT');
                    // ended by harsha 
                    
                    system.debug('hellow--'+objorder.Status);
                    system.debug('hellowk--'+objorder.Sub_Status__c);
                    
                    if(objorder.Status!=null && objorder.Status == 'Triage & Diagnosis' && objorder.Sub_Status__c!=null && objorder.Sub_Status__c =='Troubleshooting Complete' && objorder.Make__c!=null && objorder.Asset.Make__c!=null && objorder.Make__c !=objorder.Asset.Make__c && objorder.Model__c !=null && objorder.Asset.Model__c !=null && objorder.Model__c !=objorder.Asset.Model__c ){
                        FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                        objstage.Manufacturer__c = objorder.Make__c ;
                        objstage.ModelSeries__c =objorder.Model__c ;
                        objstage.ProductApplicationCode__c = objorder.Asset.Product_Application_Code__c ;
                        objstage.PSN__c = objorder.Asset.Name ;
                        lstmake.add(objstage);
                    }
                    // 4c's Integration Call
                    //Start : Harsha added code for 4Cs
                    
                    //For Triage & Diagnosis Cause
                    
                    String str ='';
                    if(objorder.Correction_Notes__c != null)
                    {
                        str = str + objorder.Correction_Notes__c;
                    }
                    
                    if(objorder.Field_Actions__c != null)
                    {
                        str = str + objorder.Field_Actions__c;
                    }
                    
                    Integer maxSize = 5000;
                    if(str.length() > maxSize ){
                        str = str.substring(0, maxSize);
                    }
                    
                    //Trupthi started 07/07/22,NIN-409.enabling WO comment inbound for MoveX users, if switch is ON"
                    //fsl_Switch__c switchRecord = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Send_4Cs' ORDER BY CreatedDate Desc limit 1]; // added as part of FBI-414: Moved  the query out of loop
                    
                    System.debug('switch Record ****** '+switchRecord.ERP__c);
                    
                    if(objorder.Status == 'Triage & Diagnosis' && objorder.Sub_Status__c =='Troubleshooting Complete') {
                        //if(UserERP == 'BMS')   FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CAUSE', objorder.Editcause__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                        if(switchRecord!=null && UserERP!=null){
                            if (switchRecord.ERP__c.contains(UserERP))  {
                                FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CAUSE', objorder.Editcause__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate); 
                            }
                        }
                    }
                    //For Job plan
                    if(objorder.Status == 'Job Plan' && objorder.Sub_Status__c =='Send 4Cs to ERP')  {
                        //Harsha started 07/09/20 added for 4cs correction notes 
                        // if(UserERP == 'BMS'){}
                        // Naga Anusha Devi Malepati added try and catch block,7/28/22,NIN-444 for capturing Integration errors of Send 4Cs to ERP
                        try
                        {
                            System.debug('switch Record ****** '+switchRecord.ERP__c);
                            System.debug('UserERP ****** '+UserERP);
                            if(switchRecord!=null && UserERP!=null){
                                if (switchRecord.ERP__c.contains(UserERP))  {               
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'COMPLAINT', objorder.EditCOMPLAINT__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CAUSE', objorder.Editcause__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'COVERAGE', objorder.EditCOVERAGE__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION', objorder.EditCORRECTION__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION',str, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    // Naga Anusha Devi Malepati started 7/21/22,NIN-444 added for capturing Integration errors of Send 4Cs to ERP 
                                    
                                    FSL_WOCommentInboundJson2Apex commentInboundDetailsComplaint = FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'COMPLAINT', objorder.EditCOMPLAINT__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    FSL_WOCommentInboundJson2Apex commentInboundDetailsCause = FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CAUSE', objorder.Editcause__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    FSL_WOCommentInboundJson2Apex commentInboundDetailsCoverage = FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'COVERAGE', objorder.EditCOVERAGE__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    //FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION', objorder.EditCORRECTION__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    FSL_WOCommentInboundJson2Apex commentInboundDetailsCorrection = FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION',str, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                                    system.debug('Wo Comment:');
                                    commentInboundDetails.add(commentInboundDetailsComplaint);
                                    commentInboundDetails.add(commentInboundDetailsCause);
                                    commentInboundDetails.add(commentInboundDetailsCoverage);
                                    commentInboundDetails.add(commentInboundDetailsCorrection);
                                    Integer count = 0; 
                                    for(FSL_WOCommentInboundJson2Apex eachComment : commentInboundDetails){
                                        if(eachComment == null){
                                            count = 1;
                                            calloutMessage = System.Label.FSL_Send_4Cs_to_ERP; 
                                            break;
                                        }
                                        else if(eachComment != null && eachComment.Header!= null && eachComment.Header.Status=='ERROR'){
                                            count = 1;
                                            calloutMessage = System.Label.FSL_Send_4Cs_to_ERP + '<br>' + eachComment.Header.ReturnCodeDescription;
                                            break;
                                        }
                                        
                                    }
                                    if(count != 0){ 
                                        return calloutMessage;
                                    }  
                                }
                            }
                        }catch(Exception ex)
                        {
                            System.debug(ex.getMessage());
                        }
                        // Naga Anusha Devi Malepati Ended 7/21/22,NIN-444 added for capturing Integration errors of Send 4Cs to ERP 
                        
                    }
                    if(objorder.Status == 'Repair' && objorder.Sub_Status__c =='Repair Complete'){
                        //if(UserERP == 'BMS') FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION', objorder.EditCORRECTION__c, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                        //if(UserERP == 'BMS') FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION', str, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                        if(switchRecord!=null && UserERP!=null){
                            if (switchRecord.ERP__c.contains(UserERP))  {  
                                FSL_WO_Comment_Inbound.callWOCommentInboundService(sLoc, objorder.WorkOrderNumber, 'WO', objorder.Shop_Work_Order__c, 'CORRECTION', str, CreateUser, ChangeUser,commentCurrDate,commentChangeDate);
                            }
                        }
                    }
                    //Trupthi end 07/07/22,NIN-409.enabling WO comment inbound for MoveX users, if switch is ON"
                    
                    //End : Harsha added code for 4c's 
                    
                }
                if(lstmake.size()>0){
                    List<Database.upsertResult> updateinsertResults = Database.upsert(lstmake,FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField() , false);
                    for (Database.upsertResult sr : updateinsertResults ) {
                        if (sr.isSuccess()) { 
                            // Operation was successful, so get the ID of the record that was processed and Sucess record Id set into SET
                            strResult ='Inserted Sucessfully';
                            System.debug('Successfully inserted/updated  MakeModelStage: ' + sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                strResult = err.getMessage() ;
                                System.debug('ASset fields that affected this error: ' + err.getFields());
                            }
                        }
                    }
                } 
            }  
        }       
        return strResult ; 
    }
    
    
    @AuraEnabled
    public static Boolean isWorkOrderCreated(String workOrderId){
        try{
            WorkOrder wo=[SELECT Shop_Work_Order__c 
                          FROM WorkOrder 
                          WHERE id=:workOrderId Limit 1];
            if(wo.Shop_Work_Order__c!=null){return true;}
            else{return false;}
        }catch(Exception ex){
            return false;
        }
    }
    @AuraEnabled
    public static Boolean isTechDispatched(String workOrderId){
        try{
            WorkOrder wo=[SELECT Is_Tech_Dispatched__c 
                          FROM WorkOrder 
                          WHERE id=:workOrderId Limit 1];
            if(wo.Is_Tech_Dispatched__c){return true;}
            else{return false;}
        }catch(Exception ex){
            return false;
        }
        
        
    }
    
    /*  Added by Piyush for CT2-199-Start */
    @AuraEnabled
    public static erpTimesheetWrapper checkOpenTimeSheet(String workOrderId) {
        erpTimesheetWrapper erpWrapper = new erpTimesheetWrapper();//added by mallika for CT2-166
        erpWrapper.isTimeSheetOpen = false;
        //Added by DivyaSri Srirangam as part of TW-111
        String submittedTimeSheetRecTypeId = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByName().get('Submitted Timesheet').getRecordTypeId();
        String openTimeSheetRecTypeId = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByName().get('Open Timesheet').getRecordTypeId();
        String newTimeSheetRecTypeId = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByName().get('New Timesheet').getRecordTypeId();
        try {
            List<FSL_Timesheet__c> timeSheetList = [SELECT Id, Status__c,RecordTypeId,RecordType.Name, Service_Order__c,EndTime__c  FROM FSL_Timesheet__c where Service_Order__c =: workOrderId];
            for(FSL_Timesheet__c ts : timeSheetList) {
                //Added by Krishna  as part of TW-111
                if(ts.status__c!='Invalid'){
                    if((ts.recordTypeId==openTimeSheetRecTypeId  || ts.recordTypeId==newTimeSheetRecTypeId )
                       ||(ts.endtime__c==Null) || ts.recordTypeId!=submittedTimeSheetRecTypeId){
                           erpWrapper.isTimeSheetOpen = true;
                       }
                }
            }
            
            User usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier FROM User 
                        WHERE Id =: UserInfo.getUserId() LIMIT 1];
            WorkOrder objWorkOrder = [SELECT Id,Process_Step__c,status,RecordTypeId,Type__c 
                                      FROM WorkOrder 
                                      WHERE Id=:workOrderId LIMIT 1];
            /*added by mallika for CT2-166  */
            erpWrapper.userERP = (String)usr.ERP__c;
            erpWrapper.woType = objWorkOrder.Type__c;    
            
        } catch(Exception ex) {
            ex.getStackTraceString();
        }
        system.debug('erpWrapper'+erpWrapper);
        return erpWrapper;
    }
    /*  Added by Piyush for CT2-199-End */
    /*  
@AuraEnabled
public static Boolean checkcommunicationfailed(String workOrderId) {
Boolean iscommunicationfail = false;
try {
List<WorkOrder> WorkOrderList = [SELECT Id, Is_Comm_Sent__c FROM WorkOrder where id =: workOrderId];
for(WorkOrder wo : WorkOrderList) {
if(wo.Is_Comm_Sent__c==true) {
iscommunicationfail = true;
}
}

} catch(Exception ex) {
ex.getStackTraceString();
}
return iscommunicationfail;
}
*/ 
    @AuraEnabled
    public static void handleCloseModal(String workOrderId){
        try{
            WorkOrder objWorkOrder = [SELECT Id,Process_Step__c,status,RecordTypeId 
                                      FROM WorkOrder 
                                      WHERE Id=:workOrderId LIMIT 1];
            
            RecordType rt = new RecordType();
            objWorkOrder.Process_Step__c = 'Close';
            objWorkOrder.status = 'Closed';
            objWorkOrder.sub_status__c = 'Close';
            /*  if(!isWorkOrderCreated(workOrderId)){
objWorkOrder.status = 'Canceled';
objWorkOrder.sub_status__c = 'Cancel';
} */
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND NAME='Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
            /* CT2-346 - sending admin srts to ERP before work order close
			 * Author : Rajashekar N; Date : 11/20/2020

			FSL_CL_AdminSRTApi.future_adminSRTApi(workOrderId);*/
            update objWorkOrder; //Removing this as part of CT2-720: Karthik Pedditi 06/04/2021
            
        }catch(DmlException ex){
            //ex.getStackTraceString();
            throw new AuraHandledException(ex.getDmlMessage(0));
        }
        
        
    }
    @AuraEnabled
    public static String handleTAndDRepairJobPlanClose(String workOrderId){
        List<CSS_Solutions__c> cssSols = new List<CSS_Solutions__c>();
        List<cssSolutionWrapper> solutionWrp = new List<cssSolutionWrapper>();
        try{
            cssSols = [SELECT Id,Solution_Title__c,Name,Repair_Response__c 
                       FROM CSS_Solutions__c
                       WHERE FSL_Service_Job__c=:workOrderId
                       AND Diagnostic_Response__c='Most likely the solution. Repair recommended.'
                       AND Repair_Response__c =null];
            System.debug('*** cssSols*** '+cssSols);
            
            if(cssSols.size()>0){
                for(CSS_Solutions__c css : cssSols  ){
                    solutionWrp.add(new cssSolutionWrapper(css.Id,css.Solution_Title__c, css.Name,css.Repair_Response__c));
                }
            }
            System.debug('*** cssSolutionWrapper*** '+solutionWrp);
            return JSON.serialize(solutionWrp);
        }catch(Exception ex){
            return JSON.serialize(solutionWrp);
        }
    }
    @auraEnabled
    public static List<String> getRepairRespLOVs()
    {
        List<String> options = new List<String>();        
        Schema.DescribeFieldResult fieldResult = CSS_Solutions__c.Repair_Response__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for(Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        system.debug('repair resp options>>'+options);
        return options;
    }
    
    @AuraEnabled
    public static FSL_StatusUpdate.calloutResponseWraper callBMSWebServices(String workOrderId ){
        
        WorkOrder workOrder = FSL_StatusUpdate.getWorkOrder(workOrderId);
        FSL_StatusUpdate.calloutResponseWraper response = FSL_StatusUpdate.updateWorkOrder(workOrder);
        system.debug('Response****:'+response);
        
        return response;
    }
    
    public class cssSolutionWrapper{
        @AuraEnabled public String solutionName;
        @AuraEnabled public String solutionTitle;
        @AuraEnabled public String Id;
        @AuraEnabled public String repairResponse;
        public cssSolutionWrapper(String Id,String solutionTitle, String solutionName,String repairResponse)
        {
            this.Id = Id;
            this.solutionTitle=solutionTitle;
            this.solutionName=solutionName;
            this.repairResponse=repairResponse;
        }
        public cssSolutionWrapper(){}
    }
    public class chevronData{
        public String val{get;set;}
        public String value{get;set;} //Added by Harsha for path color Higlight on 08/26/2020
        public String cssClass{get;set;}
        public String width {get;set;}
        public Boolean isActive{get;set;}
        public String disablePointer{get;set;}//added by vinod 8/21
        
    }
    /*added by mallika for CT2-166  */
    public class erpTimesheetWrapper{
        @AuraEnabled public Boolean isTimeSheetOpen;
        @AuraEnabled public String userERP;
        @AuraEnabled public String woType;
    }
    
}