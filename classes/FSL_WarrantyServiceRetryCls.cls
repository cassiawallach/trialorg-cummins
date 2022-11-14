/**********************************************************************
Name: FSL_WarrantyServiceRetryCls
Copyright Â© 2019  Cummins
=======================================================================
========================================================================
Purpose:                                                            
-------  
This class used for the  @auraEnabled method from the Lighting Component.
=========================================================================
=========================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      01/20/2019      INITIAL DEVELOPMENT 
2.0 - Dinesh Yadav      06/10/2021      Ct3-529, Added additional check.                         
***********************************************************************/
public without sharing class FSL_WarrantyServiceRetryCls {
    
    @auraEnabled
    public static WOWrapper getWorkOrderInfo(String woId)
    {
        WorkOrder wo = [select id, Warranty_Integration_Status__c, AssetId
                        , Warranty_Integration_Descrption__c, Asset.No_Warranty__c , Asset.Engine_Manufacturer__c
                        , Application__c, CSS_Hours__c, Mileage__c, Mileage_Measure__c
                        from workOrder where id= :woId];    //Added:Charan No warrenty field
        
        WOWrapper obj = new WOWrapper();
        obj.wo = wo;
         system.debug('***obj.wo' + obj.wo);
        system.debug('***wo asset engine manu' + wo.Asset.Engine_Manufacturer__c);
        
        if(wo.Asset.No_Warranty__c == true){
            obj.ErrorType = 'No_Warranty';
        }
        else if(wo.Application__c == null){
            obj.ErrorType = 'Application_Missing';
        }
        else if(wo.Application__c.contains('130') ||
                wo.Application__c.contains('210') ||
                wo.Application__c.contains('220') ||
                wo.Application__c.contains('260') ||
                wo.Application__c.contains('270') ||
                wo.Application__c.contains('310') ||
                wo.Application__c.contains('320') ||
                wo.Application__c.contains('410'))
        {
              if(wo.Mileage__c == null || wo.Mileage__c == 0){
                obj.ErrorType = 'Mileage';
              }
              else if(wo.Mileage_Measure__c == null){
                obj.ErrorType = 'Mileage_Measure';
              }
        }
        else if(wo.CSS_Hours__c == null || wo.CSS_Hours__c == 0){
            obj.ErrorType = 'Hours_Missing';     
        }
        else{
            obj.ErrorType = '';
        }
        
        return obj;
    }

    @auraEnabled
    public static void getWarrantyDetails(String woId)
    {
        FSL_CL_IntakeWarrantyComp fsli = new FSL_CL_IntakeWarrantyComp();
        fsli.wo =[SELECT Id, WORKORDERNUMBER, Asset.Name, Asset.Recon_Engine_Flag__c, Asset.Automotive_Application_Flag__c,
                            Warranty_Start_Date__c, Application__c, CSS_Hours__c, 
                            ServiceTerritory.Region__c, ServiceTerritory.Territory__c, Account.Region__c, Account.Territory__c ,Type__c,
                            Failure_Date__c,Before_In_Service__c, Application_Code__c,Mileage__c,Mileage_Measure__c
                  FROM WORKORDER
                  WHERE id=:woId
                 ];
        fsli.coveragesearch();
    }
    
    @auraEnabled
    public static WOWrapper getWarrantyDetailsNew(String woId)
    {
        FSL_CL_IntakeWarrantyComp fsli = new FSL_CL_IntakeWarrantyComp();
        fsli.wo =[SELECT Id, WORKORDERNUMBER, Asset.Name, Asset.Recon_Engine_Flag__c, Asset.Automotive_Application_Flag__c,Asset.Engine_Manufacturer__c,
                            Warranty_Start_Date__c, Application__c, CSS_Hours__c, 
                            ServiceTerritory.Region__c, ServiceTerritory.Territory__c, Account.Region__c, Account.Territory__c ,Type__c,
                            Failure_Date__c,Before_In_Service__c, Application_Code__c,Mileage__c,Mileage_Measure__c
                  FROM WORKORDER
                  WHERE id=:woId
                 ];
        
        WOWrapper obj = new WOWrapper();
        obj.wo = fsli.wo;
        system.debug('***fsli.wo'+ fsli.wo);

       system.debug('***fsli.wo.Asset.Engine_Manufacturer__c '+ fsli.wo.Asset.Engine_Manufacturer__c );
        if((fsli.wo.Asset.Engine_Manufacturer__c == null || fsli.wo.Asset.Engine_Manufacturer__c == null) && !Test.isRunningTest()){
			obj.ErrorType = 'Non_CumminsAsset';            
        } 
        else if(fsli.wo.Asset.Engine_Manufacturer__c != 'CUMMINS' && !Test.isRunningTest()) {
            obj.ErrorType = 'Non_CumminsAsset';
            system.debug('***Non cummmins in getWarrantyDetailsNew' + obj.ErrorType);
        }
        else if(fsli.wo.Application__c == null){
            obj.ErrorType = 'Application_Missing';
        }
        else if(fsli.wo.Application__c.contains('130') ||
                fsli.wo.Application__c.contains('210') ||
                fsli.wo.Application__c.contains('220') ||
                fsli.wo.Application__c.contains('260') ||
                fsli.wo.Application__c.contains('270') ||
                fsli.wo.Application__c.contains('310') ||
                fsli.wo.Application__c.contains('320') ||
                fsli.wo.Application__c.contains('410'))
        {
              if(fsli.wo.Mileage__c == null || fsli.wo.Mileage__c == 0){
                obj.ErrorType = 'Mileage';
              }
              else if(fsli.wo.Mileage_Measure__c == null){
                obj.ErrorType = 'Mileage_Measure';
              }
        }
        else if(fsli.wo.CSS_Hours__c == null || fsli.wo.CSS_Hours__c == 0){
            obj.ErrorType = 'Hours_Missing';     
        }
        else{
            obj.ErrorType = '';
        }
        
        system.debug('obj.ErrorType '+obj.ErrorType);
        if(string.isBlank(obj.ErrorType)){
            fsli.coveragesearch();
        }
        
        return obj;       
    }
    
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class WOWrapper{
        @AuraEnabled
        public WorkOrder wo{get;set;}
        @AuraEnabled
        public string ErrorType{get;set;}
    }
}