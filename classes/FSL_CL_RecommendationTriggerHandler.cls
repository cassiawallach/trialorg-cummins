/******************************************************************************************************************
Name: FSL_CL_RecommendationTriggerHandler 
Description: Recommendation Trigger Handler class.

Version                 Date                    Author                      Summary Of Change
-----------------------------------------------------------------------------------------------------
1.0                                             Cummins                       Class created  
1.1               10/20/2020             Ravikanth Macherla               Created for US-CT2-265  
********************************************************************************************************************/
//Coded Added By Ravi for US-CT2-265
public class FSL_CL_RecommendationTriggerHandler {
    public static Boolean isFirstTime = true;
    static String UserERP1 {
        get {
            if (string.isBlank(UserERP1)){
                User usr = new User();
                usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
                       FROM User 
                       WHERE Id =: UserInfo.getUserId() LIMIT 1];    
                return (String)usr.ERP__c;     
            } else{
                return UserERP1;
            }
        }
    }
    
    FSL_CL_RecommendationTriggerHandler(){
        /*
        if (string.isBlank(UserERP1)){
    User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];    
        UserERP1 = (String)usr.ERP__c;     
        }}
        */
    }
    
    public static void createServiceOrder(list<FSL_Recommendation__c> lstRecommendation,map<id,FSL_Recommendation__c> oldRecMap) {
        set<id> setParentWO = new set<id>();
        Map<Id,WorkOrder> Recommendation2workOrderMap = new Map<Id,WorkOrder>();
        map<id,FSL_Recommendation__c > mapWORecomid = new map<id,FSL_Recommendation__c >();
        for(FSL_Recommendation__c objRec : lstRecommendation){
            if(objRec.Status__c != oldRecMap.get(objRec.id).Status__c && objRec.Status__c == 'Accept'){
                setParentWO.add(objRec.Service_Order__c);
                mapWORecomid.put(objRec.Service_Order__c,objRec);
            }
        }
        
        if(setParentWO != Null && setParentWO.size() > 0){
            
            for(Workorder objWO : [SELECT Id, AccountId, ContactId, AssetId, WorkTypeId, Application__c, Available_for_Service__c, Fuel_Burn__c, Failure_Date__c, Before_In_Service__c,
                                   Warranty_Start_Date__c, FSL_SMN__c, General_Symptoms__c, Make__c, Model__c, Payer__c, Purchase_Order__c, 
                                   Repair_Location__c, Repair_Site_Address__c, Category1__c, Complaint_Type1__c, ServiceTerritoryId, IAS_Number__c,
                                   CaseId, Shop_Work_Order__c, Status, Scheduled__c,
                                   Create_Tech_Bay_Service_Appointments__c, Expedited__c, Duration, DurationType, Recommendation__c, Branch_Code__c, Payer_ContactID__c, Type_of_Repair__c FROM WorkOrder where id in :setParentWO]){
                                       
                                       Workorder objWorkOrder = new Workorder();
                                       objWorkOrder.AccountId = objWO.AccountId;
                                       objWorkOrder.Payer__c = objWO.Payer__c;
                                       objWorkOrder.Purchase_Order__c = objWO.Purchase_Order__c;
                                       objWorkOrder.Payer_ContactID__c = objWO.Payer_ContactID__c;
                                       objWorkOrder.AssetId = objWO.AssetId;
                                       objWorkOrder.ContactId = objWO.ContactId;
                                       
                                       objWorkOrder.Repair_Location__c = objWO.Repair_Location__c;
                                       objWorkOrder.Repair_Site_Address__c = objWO.Repair_Site_Address__c;
                                       objWorkOrder.WorkTypeId = objWO.WorkTypeId;
                                       objWorkOrder.Application__c = objWO.Application__c;
                                       //objWorkOrder.Available_for_Service__c = objWO.Available_for_Service__c;
                                       objWorkOrder.Available_for_Service__c = System.now().addhours(1);
                                       objWorkOrder.Fuel_Burn__c = objWO.Fuel_Burn__c;
                                       objWorkOrder.Failure_Date__c = objWO.Failure_Date__c;
                                       objWorkOrder.Before_In_Service__c = objWO.Before_In_Service__c;
                                       objWorkOrder.Warranty_Start_Date__c = objWO.Warranty_Start_Date__c;
                                       objWorkOrder.FSL_SMN__c = objWO.FSL_SMN__c;
                                       objWorkOrder.Make__c = objWO.Make__c;
                                       objWorkOrder.Model__c = objWO.Model__c;
                                       objWorkOrder.Category1__c = objWO.Category1__c;
                                       objWorkOrder.Complaint_Type1__c = objWO.Complaint_Type1__c;
                                       objWorkOrder.ServiceTerritoryId = objWO.ServiceTerritoryId;
                                       objWorkOrder.IAS_Number__c = objWO.IAS_Number__c;
                                      // objWorkOrder.CaseId = objWO.CaseId;
                                       //objWorkOrder.Shop_Work_Order__c = objWO.Shop_Work_Order__c;
                                       objWorkOrder.Status = objWO.Status;
                                       objWorkOrder.Scheduled__c = objWO.Scheduled__c;
                                       objWorkOrder.Create_Tech_Bay_Service_Appointments__c = objWO.Create_Tech_Bay_Service_Appointments__c;
                                       objWorkOrder.Expedited__c = objWO.Expedited__c;
                                       objWorkOrder.Duration = objWO.Duration;
                                       objWorkOrder.DurationType = objWO.DurationType;
                                       objWorkOrder.Recommendation__c = objWO.Recommendation__c;
                                       objWorkOrder.Branch_Code__c = objWO.Branch_Code__c;
                                       //objWorkOrder.General_Symptoms__c = objWO.General_Symptoms__c;
                                       objWorkOrder.General_Symptoms__c = mapWORecomid.get(objWO.id).Type_of_Repair__c;
                                       objWorkOrder.CreatedFromRecommendation__c = true;
                                       
                                       if(mapWORecomid != Null && mapWORecomid.containskey(objWO.id)){
                                           objWorkOrder.Recommendation__c = mapWORecomid.get(objWO.id).id;
                                           objWorkOrder.Type_of_Repair__c  = mapWORecomid.get(objWO.id).Type_of_Repair__c;
                                           
                                       }
                                       if(!Recommendation2workOrderMap.containsKey(mapWORecomid.get(objWO.id).id))
                                           Recommendation2workOrderMap.put(mapWORecomid.get(objWO.id).id, objWorkOrder);                                       
                                   }
            if(Recommendation2workOrderMap.size() > 0 && !Test.isRunningTest()) {
                insert Recommendation2workOrderMap.values();
            }
			updateNewWorkOrderOnRecommendation(Recommendation2workOrderMap);
        }
    }//Coded end Ravi For CT2-265
	
	public static void updateNewWorkOrderOnRecommendation(Map<Id,WorkOrder> Recommendation2workOrderMap) { 
		if(Recommendation2workOrderMap != null && Recommendation2workOrderMap.size() > 0){
			List<FSL_Recommendation__c> Recommendation2UpdateList = new List<FSL_Recommendation__c>();
			for(Id recommendationId : Recommendation2workOrderMap.keySet()){
				FSL_Recommendation__c Recommendation = new FSL_Recommendation__c();
				Recommendation.Id = recommendationId;
				Recommendation.New_Service_Order_Number__c = Recommendation2workOrderMap.get(recommendationId).Id;	
				Recommendation2UpdateList.add(Recommendation);				
			}
			if(!Recommendation2UpdateList.isEmpty())
				update Recommendation2UpdateList;
		}
	}
    
    public static void postToChatterOnServiceOrder(list<FSL_Recommendation__c> newlstRecommendation,map<id,FSL_Recommendation__c> oldRecMap) { 
        if(isFirstTime){
            isFirstTime = false;
            Set<id> setwoid = new set<id>();
            map<id,Workorder> mapWoOwner = new map<id,workorder>();
            
            for(FSL_Recommendation__c recommendation : newlstRecommendation){
                if( recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && recommendation.Status__c  == 'Ready for Quote'){ 
                    setwoid.add(recommendation.Service_Order__c);
                }
            }
            for(Workorder objWO : [Select id,ownerid from workorder where id in :setwoid]){
                mapWoOwner.put(objWO.id,objWO);
            }
            
            for(FSL_Recommendation__c recommendation : newlstRecommendation){
                if( recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && recommendation.Status__c  == 'Ready for Quote'){
                    ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                    //ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput2 = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
                    
                    textSegmentInput.text = recommendation.Name +' - Status Changed to Ready for quote';
                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
                    
                    //messageBodyInput.messageSegments.add(mentionSegmentInput);
                    messageBodyInput.messageSegments.add(textSegmentInput);
                    
                    if(mapWoOwner.containsKey(recommendation.Service_Order__c)) 
                    {
                        mentionSegmentInput2.id = mapWoOwner.get(recommendation.Service_Order__c).OwnerId ;
                    }
                    messageBodyInput.messageSegments.add(mentionSegmentInput2);
                    
                    feedItemInput.body = messageBodyInput;
                    feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
                    feedItemInput.subjectId = recommendation.Service_Order__c;
                    if(!Test.isRunningTest()){
                        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);        
                    }
                }
            }
        }
    }
    //added by Piyush for CT2-262
    public static void updateRecommendationRecord(List<FSL_Recommendation__c> newList) {
        Id RecordTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('In Progress Recommendation').getRecordTypeId();
        //Id MOVEXRecTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('MOVEX In Progress').getRecordTypeId();
        // Id BMSRecTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('Non Editable').getRecordTypeId();
        
        Set<Id> serviceOrdIds = new Set<Id>();
        List<FSL_Recommendation__c> updateRecommendation = new List<FSL_Recommendation__c>();
        
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        
        for(FSL_Recommendation__c rec : newList) {
            if(rec.Service_Order__c != null) {
                serviceOrdIds.add(rec.Service_Order__c);
            }
        }
        
        Map<Id, WorkOrder> ServiceOrdMap = new Map<Id, WorkOrder>(
            [Select Id, AssetId FROM WorkOrder where Id IN: serviceOrdIds]
        );
        
        for(FSL_Recommendation__c rec : newList) {
            if(ServiceOrdMap.containsKey(rec.Service_Order__c)) {
                FSL_Recommendation__c newRec = new FSL_Recommendation__c(Id = rec.Id);
                newRec.Asset__c = ServiceOrdMap.get(rec.Service_Order__c).AssetId;
                newRec.RecordTypeId = RecordTypeId;
                updateRecommendation.add(newRec);
            }
        }
        System.debug('::: updateRecommendation = '+updateRecommendation);
        if(!updateRecommendation.isEmpty()) {
            update updateRecommendation;
        }
    }    
    public static void updateRecordType(List<FSL_Recommendation__c> newList,map<id,FSL_Recommendation__c> oldRecMap) {
        Set<String> moveExReadonlyStatus = new Set<String>{'Accept','Complete'};
        Id MOVEXRecTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('MOVEX In Progress').getRecordTypeId();
        Id BMSRecTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('Non Editable').getRecordTypeId();
        Id AdvTypeId = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByName().get('AdvancedUser').getRecordTypeId();

        Boolean isFirstTime = true;
        Set<Id> serviceOrdIds = new Set<Id>();
        List<FSL_Recommendation__c> updateRecommendation = new List<FSL_Recommendation__c>();
        
        User usr = new User();
        usr = [SELECT Id, ERP__c,UserRole.Name, Name, FederationIdentifier 
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String UserERP;
        UserERP = (String)usr.ERP__c;
        system.debug('User ERP:::'+UserERP);
        
        // if(isFirstTime){
        // isFirstTime = false;
        for(FSL_Recommendation__c recommendation : newList) {
            if(recommendation.Service_Order__c != null) {
                serviceOrdIds.add(recommendation.Service_Order__c);
                system.debug('newRecOrder:::'+serviceOrdIds);
                
            }
        }
        Map<Id, WorkOrder> ServiceOrdMap = new Map<Id, WorkOrder>(
            [Select Id, AssetId FROM WorkOrder where Id IN: serviceOrdIds]
        );
        for(FSL_Recommendation__c recommendation : newList){
            system.debug('newRec:::'+newList);
            
            if( ServiceOrdMap.containsKey(recommendation.Service_Order__c) && UserERP != 'BMS' && recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && recommendation.Status__c  == 'Ready for Quote'){ 
                FSL_Recommendation__c newRec = new FSL_Recommendation__c(Id = recommendation.Id);
                system.debug('newRec:::'+newRec);
                
                newRec.RecordTypeId = MOVEXRecTypeId;
                newRec.Status__c = 'Request for Quote Sent';
                updateRecommendation.add(newRec);
            }
            else if( ServiceOrdMap.containsKey(recommendation.Service_Order__c) && UserERP != 'BMS' && recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && recommendation.Status__c  == 'Request for Quote Sent'){
                FSL_Recommendation__c newRec = new FSL_Recommendation__c(Id = recommendation.Id);
                newRec.RecordTypeId = AdvTypeId;
                updateRecommendation.add(newRec);
            }
            else if( ServiceOrdMap.containsKey(recommendation.Service_Order__c) && UserERP != 'BMS' && recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && moveExReadonlyStatus.contains(recommendation.Status__c)){
                FSL_Recommendation__c newRec = new FSL_Recommendation__c(Id = recommendation.Id);
                newRec.RecordTypeId = BMSRecTypeId;
                updateRecommendation.add(newRec);
         
                
             } else if(UserERP == 'BMS' && ServiceOrdMap.containsKey(recommendation.Service_Order__c) && recommendation.Status__c != oldRecMap.get(recommendation.id).Status__c  && recommendation.Status__c  == 'Ready for Quote') {
                FSL_Recommendation__c newRec = new FSL_Recommendation__c(Id = recommendation.Id);
                system.debug('newRec:::'+newRec);
                
                system.debug('User ERP:::'+UserERP);
                 newRec.RecordTypeId = BMSRecTypeId;
                updateRecommendation.add(newRec);
            }
        }
        // }
        if(!updateRecommendation.isEmpty()) {
            update updateRecommendation;
        }
        system.debug('rec Update:::'+updateRecommendation);
    }

  //Not bulkified since the service accepts only one recommendation at a time.
    public static void sendDatatoBMS(List<FSL_Recommendation__c> newList, Map<Id,FSL_Recommendation__c> oldMap){
        Set<Id> IdsToSend = new Set<Id>();
        FSL_Recommendation__c rec = newList[0];
       // if(oldMap == null && rec.status__c == 'Ready for Quote' && UserERP1 == 'BMS'){
       //     FSL_CL_PMRecommendationsService.sendRecommendations(rec.Id);}
       //     Changed as part of bug CT2-973-974 by Raghav Bansal
        
        if(oldMap != null && oldMap.get(rec.Id).status__c != rec.status__c && rec.status__c == 'Ready for Quote' && UserERP1 == 'BMS'){
            FSL_CL_PMRecommendationsService.sendRecommendations(rec.Id);
        }
        
    }
}