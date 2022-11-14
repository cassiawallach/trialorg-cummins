/****************************************************************************************************************************
Name: EVL_CL_ServiceOrder_LightningPath
Copyright Â© 2019  Cummins
=============================================================================================================================

=============================================================================================================================
Purpose:                                                            
-------  
This class is used to control all stage path functionality.
=============================================================================================================================
History                                                            
-------                                                            
VERSION       AUTHOR             DATE                DETAIL                                 
1.0 -    Anirudh Pesari       05/05/2020      INITIAL DEVELOPMENT     
2.0      Ronnie Mishra        08-09-2022      Implemented greying and disabling Triage & Diagnosis chevron as part of SG-92       
*****************************************************************************************************************************/
public class EVL_CL_ServiceOrder_LightningPath {
    
    @AuraEnabled
    public static String getChevronData(String recId){ 
        String fieldName = 'EVL_Stage__c';
        //SG-92, Ronnie Mishra 08-08-2022 - CODE STARTS
        String fieldsToQuery = 'EVL_Stage__c, Case.FSL_ABRFlag__c';
        //SG-92, Ronnie Mishra 08-08-2022 - CODE ENDS
        List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();
        Map<String,String> objectMap = new Map<String,String>();
        for(Schema.SObjectType f : gd)
        {
            objectMap.put(f.getDescribe().getKeyPrefix(), f.getDescribe().getName());
        }
        String prefix =  recId.left(3); 
        String objectName = objectMap.get(prefix);
        //SG-92, Modified query to include fieldsToQuery instead offieldName; Ronnie Mishra 08-08-2022 - CODE STARTS
        String query = 'SELECT ' + fieldsToQuery + ' FROM '+objectName+' WHERE Id =: recId'; 
        //SG-92, Ronnie Mishra 08-08-2022 - CODE ENDS       
        List<SOBject> lstObj = Database.query(query); 
        //SG-92
        Workorder workOrderObj =  (WorkOrder)lstObj[0];  
        Boolean abrFlag = workOrderObj.Case.FSL_ABRFlag__c;  
        //SG-92       
        String selVal =  String.valueOf(lstObj[0].get(fieldName));  
        Schema.SObjectField sobjField = Schema.getGlobalDescribe().get(objectName).getDescribe().Fields.getMap().get(fieldName) ;
        Schema.DescribeFieldResult fieldResult = sobjField.getDescribe() ;
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        Boolean curValMatched = false;        
        List<chevronData> lstRet = new List<chevronData>();          
        String profileName = GetLoggedInUserProfileName();
        List<String> stageList = EVL_Utility.getStageValues(profileName);
        Integer widthPerItem = 100/stageList.size() ;
        for( Schema.PicklistEntry fSchema : ple)
        {            
            chevronData obj = new chevronData();// !OBJECT 
            if(stageList.contains(fSchema.getLabel())){
                obj.isActive = true;
            }else{
                continue;
            } 
            obj.val = fSchema.getLabel();
            obj.width = widthPerItem+'%';    
            if(selVal == 'Close')
            {
                if(fSchema.getLabel() != 'Close')
                    obj.disablePointer = 'none';
                else
                    obj.disablePointer='auto'; 
            }
            else if(stageList.contains(profileName) && fSchema.getLabel() == 'Close')// Added by vinod for the disable of the Close job Techinician
                obj.disablePointer='auto';
            else
                obj.disablePointer='auto';
            //Added By Devon Sumbry
            switch on selval{
                when 'Intake'{  
                    if(obj.val == 'Intake')
                        obj.cssClass = 'active';
                }   
                when 'Triage & Diagnosis'{
                    if(obj.val == 'Intake')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Triage & Diagnosis')
                        obj.cssClass = 'active';
                }
                when 'Job Plan'{
                    if(obj.val == 'Intake')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Triage & Diagnosis' && abrFlag) {
                        obj.cssClass = 'Notactive';
                        obj.disablePointer = 'none';
                    }
                    else {
                        obj.cssClass = 'Inactive';
                    }
                    if(obj.val == 'Job Plan')
                        obj.cssClass = 'active';
                }
                when 'Repair'{
                    if(obj.val == 'Intake')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Triage & Diagnosis' && abrFlag) {
                            obj.cssClass = 'Notactive';
                            obj.disablePointer = 'none';
                    }
                    else
                        obj.cssClass = 'Inactive';
                    
                    if(obj.val == 'Job Plan')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Repair')
                        obj.cssClass = 'active';
                }
                when 'Closed'{  
                    if(obj.val == 'Intake')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Triage & Diagnosis' && abrFlag) {
                        obj.cssClass = 'Notactive';
                        obj.disablePointer = 'none';
                    }
                    else
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Job Plan')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Repair')
                        obj.cssClass = 'Inactive';
                    if(obj.val == 'Closed')
                        obj.cssClass = 'active';
                }
            }
            lstRet.add(obj);
        } 
        
        return JSON.serialize(lstRet);
    }  
    
    @AuraEnabled
    public static string GetLoggedInUserProfileName(){
        String profileId = UserInfo.getProfileId();
        List<Profile> profileName = [Select Name from Profile where Id =:profileId];
        return profileName[0].Name;
    }
    
    //By Priyanka 2/3/2019  for fetching both role and profile instead of using two different methods VGRS2-323
      @AuraEnabled
    public static User GetLoggedInUserDetail(){      
         Id userId = userinfo.getUserId();
         User userInfo =[SELECT Id, Name, Email, Profile.Name, UserRole.Name FROM User where Id=:userId ];     
        return userInfo;
    }
    
    @AuraEnabled
    public static List<String> isStageActiveFor(String loggedInProfileName){
        return EVL_Utility.getStageValues(loggedInProfileName);
    }
    
    @AuraEnabled
    public static void updateStageAndRecordType(String strWorkOrderId,String stageName){
        String query= 'Select Id,EVL_Stage__c,RecordTypeId,Status FROM WorkOrder WHERE Id=:strWorkOrderId LIMIT 1';
        WorkOrder objWorkOrder = Database.query(query);
        objWorkOrder.EVL_Stage__c = stageName;
        objWorkOrder.Status = stageName;
        update objWorkOrder;
    }
    
    
    @AuraEnabled
    public static Boolean recordStatus(string recId, String btnLabel){
        boolean showRecord = false;        
        workorder wo = [select id, status, EVL_Stage__c,
                            (SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                            FROM Service_Order_Extension__r)
                        FROM workorder where id =: recId];
        if(wo.Status != 'Closed' && wo.EVL_Stage__c != 'Closed' ){
            showRecord = true;
        }
        if(wo.Service_Order_Extension__r != null && wo.Service_Order_Extension__r.size() > 0  
            && wo.Service_Order_Extension__r[0].FSL_ABRFlag__c == true
            && btnLabel == Label.EVL_Add_Diagnostic_SRTs) {
                showRecord = false;
        }
        return showRecord;
    }
       
    //Added by vinod for stage flow.7/23
    @auraEnabled
    public static String getProcessStatus(String woId)
    {
        String processStatus;
        WorkOrder wo=[SELECT EVL_Stage__c, PSN__c FROM WorkOrder WHERE id=:woID Limit 1];
        processStatus = wo.EVL_Stage__c;   
        //start: updated by Trupthi, NIN-47 Date:2/21/2022 - Assign PSN value to Session Variable
        Cache.Session.put('local.CSSPartition.SessionSoPSN', wo.PSN__c);
        //updated by Trupthi, NIN-47 Date:2/21/2022 -END
        return processStatus;   
    }
      
    @auraEnabled
    public static Boolean getRepairmsg(String woId)
    {
        boolean repairres = false;
        CSS_Solutions__c cs=[SELECT Repair_Response__c FROM CSS_Solutions__c WHERE FSL_Service_Job__c=:woID 
                             and FSL_Service_Job__r.Type__c = 'Dealer'  AND Diagnostic_Response__c='Most likely the solution. Repair recommended.'
                            and Repair_Response__c in ('Repair Successful.',
                                                      'Repair Successful with additional parts/procedures.') Limit 1];
        
        if(cs.Repair_Response__c.length()>0){
            repairres = true;
        }
        return repairres;
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
        string strResult ;
        list<FSL_MakeModel_Stage__c> lstmake = new list<FSL_MakeModel_Stage__c>();
        if(servicejobid !=null && servicejobid!=''){
            for(WorkOrder objorder :[select id,Make__c,Model__c,Asset.Name,Asset.Type__c,Asset.Product_Application_Code__c , Asset.Make__c ,Asset.Model__c,Status,Sub_Status__c from workorder where id=:servicejobid]){
                if(objorder.Status!=null && objorder.Status == 'Triage & Diagnosis' && objorder.Sub_Status__c!=null && objorder.Sub_Status__c =='Troubleshooting Complete' && objorder.Make__c!=null && objorder.Asset.Make__c!=null && objorder.Make__c !=objorder.Asset.Make__c && objorder.Model__c !=null && objorder.Asset.Model__c !=null && objorder.Model__c !=objorder.Asset.Model__c ){
                    FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                    objstage.Manufacturer__c = objorder.Make__c ;
                    objstage.ModelSeries__c =objorder.Model__c ;
                    objstage.ProductApplicationCode__c = objorder.Asset.Product_Application_Code__c ;
                    objstage.PSN__c = objorder.Asset.Name ;
                    objstage.Type_PSN__c = objorder.AssetId;
                    lstmake.add(objstage);
                }
            }
            if(lstmake.size()>0){
                List<Database.upsertResult> updateinsertResults = Database.upsert(lstmake,FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField() , false);
                for (Database.upsertResult sr : updateinsertResults ) {
                    if (sr.isSuccess()) { 
                        // Operation was successful, so get the ID of the record that was processed and Sucess record Id set into SET
                        strResult ='Inserted Sucessfully';
                    }
                    else {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            strResult = err.getMessage() ;
                        }
                    }
                }
            } 
        }     
        return strResult ; 
    }
    
    
    
    @AuraEnabled
    public static void handleCloseModal(String workOrderId, String resolution){
        try{
            WorkOrder objWorkOrder = [SELECT Id,EVL_Stage__c,status,FSL_Resolution__c,RecordTypeId 
                                      FROM WorkOrder 
                                      WHERE Id=:workOrderId LIMIT 1];
           
            
            RecordType rt = new RecordType();
            objWorkOrder.EVL_Stage__c = 'Closed';
            objWorkOrder.status = 'Closed';
            objWorkOrder.sub_status__c = 'Close';
            objWorkOrder.FSL_Resolution__c = resolution; //Sruthi Changes - To include Resolution
            
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND NAME='EVL Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
            
            update objWorkOrder;
            
        }catch(Exception ex){
            ex.getStackTraceString();
        }
        
        
    }
    
     @AuraEnabled
    public static void handleCloseRep(String workOrderId){
        try{
            WorkOrder objWorkOrder = [SELECT Id,EVL_Stage__c,status,RecordTypeId 
                                      FROM WorkOrder 
                                      WHERE Type__c = 'Dealer' and Id=:workOrderId LIMIT 1];
            
            RecordType rt = new RecordType();
            objWorkOrder.EVL_Stage__c = 'Closed';
            objWorkOrder.status = 'Closed';
            objWorkOrder.sub_status__c = 'Close';
            
            rt=  [SELECT Id,Name 
                  FROM RecordType
                  WHERE SobjectType='WorkOrder' AND NAME='EVL Close' LIMIT 1];
            objWorkOrder.RecordTypeId = rt.Id;
            
            update objWorkOrder;
            
        }catch(Exception ex){
            ex.getStackTraceString();
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
                       AND Diagnostic_Response__c='Most likely the solution. Repair recommended.'];            
            if(cssSols.size()>0){
                for(CSS_Solutions__c css : cssSols  ){
                    solutionWrp.add(new cssSolutionWrapper(css.Id,css.Solution_Title__c, css.Name,css.Repair_Response__c));
                }
            }
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
        for( Schema.PicklistEntry f : ple)
        {
            options.add(f.getValue());
        }
        return options;
    }
    //end Ravikanth   
    
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
        public String cssClass{get;set;}
        public String width {get;set;}
        public Boolean isActive{get;set;}
        public String disablePointer{get;set;}//added by vinod 8/21
        
    }
    
     
    
}