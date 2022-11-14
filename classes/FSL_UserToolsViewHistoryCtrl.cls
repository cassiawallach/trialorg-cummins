/*****************************************************
Name:FSL_UserToolsViewHistoryCtrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for view history in User Tools
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                DATE                DETAIL                                 
1.0 -   Karthik Gorantla       1-/07/2020        INITIAL DEVELOPMENT 
***********************************************************************/
global class FSL_UserToolsViewHistoryCtrl {
    global string assetName {get;set;}
    global DateTime createdDate {get;set;}
    global String jobId {get;set;}
    global String sLocation {get;set;}
    global List<String> sLocationTerritory {get;set;} //added by Naveen, PHOEN-209
    global String sLocationCode {get;set;}
    global WorkOrder workOrderRecord;
    public Id workOrderId;
    global FSL_UserToolsViewHistoryCtrl() {
        system.debug('kkkkk');
         try{
             sLocationTerritory = new List<String>();
             List<FSL__User_Territory__c> UT = new List<FSL__User_Territory__c>();
        assetName = ApexPages.currentPage().getParameters().get('Id');
        //createdDate = System.today();
        createdDate = DateTime.now();//added by sai as part of CT1-420
            system.debug('karthikassetName>>>'+assetName);
          //assetName =  '79950304';
       
        User u = [select Id, username,User_Location__c,ERP__c,IAM_Distributorbranchcode__c,IAM_Distributorcode__c,FSL_Primary_Service_Territory_Code__c from User where Id = :UserInfo.getUserId()];
        sLocationCode = u.User_Location__c;
        system.debug('karthikUserinfo>>>>'+sLocationCode);
// Start - code changes done by Naveen, PHOEN-209 ----------------------------
             if(u.ERP__c != null){
                  UT =[SELECT id,FSL__ServiceTerritory__c,FSL__User__c FROM FSL__User_Territory__c WHERE FSL__User__c =:u.id];
                  system.debug('UT==>'+UT);
                 if(UT.size() > 0 || Test.isRunningTest()){
                     set<string> STids = new set<string>();
                     for(FSL__User_Territory__c utr : UT){
                         if(utr.FSL__ServiceTerritory__c != null || Test.isRunningTest()){
                             STids.add(utr.FSL__ServiceTerritory__c);
                         }
                     }
						List<ServiceTerritory> STname =new List<ServiceTerritory>( [SELECT id,name,FSL_Service_Territory_Code__c ,Location_Code__c,ParentTerritoryId FROM ServiceTerritory WHERE (Id IN :STids OR  ParentTerritoryId IN :STids OR ParentTerritory.ParentTerritoryId IN :STids) AND Type__c = 'DISTRIBUTOR-BRANCH']);
                		system.debug('STname==>'+STname);  
                     if(STname.size() > 0 || Test.isRunningTest()){
                         set<string> setofST = new set<string>();
                         for(ServiceTerritory st : STname){
                             setofST.add(st.name);
                         sLocationTerritory.add(st.name);
                     	}
                     }
                 }else{   
                     
                 }
                 
             }else{
                  	Account acc = [Select Id, Name,Location__c from Account where Location__c =: sLocationCode LIMIT 1];
        			system.debug('acc.Location__c>>>>'+acc.Location__c);
        			sLocation = acc.Name; 
                    
                 	system.debug('karthikacc.Name>>>>'+acc.Name);
             }
// END - code changes done by Naveen, PHOEN-209 ----------------------------------------
        system.debug('karthikUSerinfo>>>>'+sLocationCode);
        system.debug('karthikUSerinfocreatedDate>>>>'+createdDate);
       //system.debug('karthikUSerinfoaccName>>>>'+accName);
        }catch(Exception e) { 
            system.debug('exception '+e.getMessage());
        }
      /*   workOrderId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('workOrderId . :: '+workOrderId);
        workOrderRecord = new WorkOrder();
        workOrderRecord = [SELECT Id, Asset.Name, ServiceTerritory.Name, ServiceTerritory.Location_Code__c, CreatedDate 
                           FROM WorkOrder WHERE Id = :workOrderId]; //AssetId
        if(workOrderRecord!=null) {
            assetName = workOrderRecord.Asset.Name;
            createdDate = workOrderRecord.CreatedDate;
            jobId = workOrderRecord.id;
            sLocation = workOrderRecord.ServiceTerritory.Name;
            sLocationCode = workOrderRecord.ServiceTerritory.Location_Code__c;
        }
        system.debug('check debug'+workOrderRecord); */
    }
}