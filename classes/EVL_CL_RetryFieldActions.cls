/********************************************************************************************
Name: EVL_CL_RetryFieldActions
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class used for the  @auraEnabled method from the Lighting Component.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  		AUTHOR            		DATE            	    DETAIL                                 
1.0 -      		KRISHNAMOORTHI N	 	10/09/2020		    	INITIAL DEVELOPMENT                    
***********************************************************************************************/
public class EVL_CL_RetryFieldActions {
	
    @auraEnabled
    public static WorkOrder getWorkOrderInfo(String woId) {

        return [select id, Warranty_Integration_Status__c, AssetId, Warranty_Integration_Descrption__c from workOrder where id= :woId];
    
    }
    
    @auraEnabled
    public static void getFADetails(String woId)
    {
        /*
        Id WorkOrderId = Id.valueOf(woId);
        
        //Fetch Old Field action Records. 
        
        set<Id> fielactionID = new set<Id>();
        set<ID> cssid = new set<ID>();
        
        List<CSS_Solution_Component__c> deletecss = new list<CSS_Solution_Component__c>();
        
        for(CSS_Solution_Component__c objcss : [SELECT Id FROM CSS_Solution_Component__c WHERE FSL_Service_Order__c = : WorkOrderId ]) {
            deletecss.add(objcss);
            cssid.add(objcss.id);
        }
        
        //Fetch Old Field action Records. 
        
        //Call Siebel Service and fetch the Field Action records.
        FSL_GETCampaignServices.executeFieldActionService(WorkOrderId);
        


        
        //Delete Old Field action and related SRT Records. 
        if(cssid.size() > 0) {
            delete([select id from FSL_SRT__c where  Component_Id__c IN:cssid]);
        }
        if(deletecss.size() > 0) {
            Database.delete(deletecss, false); // deleting existing css solution comp
        }
        //Delete Old Field action and related SRT Records. 
        */
        
    }
}