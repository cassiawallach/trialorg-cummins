public with sharing class FSL_CSSP_Asset_Controller
{

    @AuraEnabled
    public static string getAssetId(Id recordId){ 
        string AssetId = '';

        system.debug('record Id: '+recordId);

        list<workorder> wo=[select id,Type__c,AssetId From workorder Where id=:recordId];

        system.debug('record wo: '+wo);
        if(wo.size()>0) { 
            AssetId = wo[0].AssetId;
        }

        system.debug('record Id: '+AssetId);
 
        return AssetId;
    } 

    @AuraEnabled
    public static List <FSL_Coverage_Details__c> fetchCoverages(string woid) {
        //Qyery 10 FSL_Coverage_Details__c
        List<FSL_Coverage_Details__c> coverageDtlList = [select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Coverage_Miles_Km_Hr_Mw_Hr__c, Coverage_Type__c, Deductible__c, Definition_Type__c, FSL_Service_Order__c, Status__c, Warranty_End_Date_Formula__c, Warranty_Manual_URL__c, Warranty_Start_Date__c, StatusColor__c From FSL_Coverage_Details__c where FSL_Service_Order__c = : woid ];
        //return list of FSL_Coverage_Details__c
        return coverageDtlList;  
    }
	   
	
	@AuraEnabled
    public static List <Fsl_Certificate_Details__c> fetchCertificates(string woid) {
        //Qyery 10 Fsl_Certificate_Details__c
        List<Fsl_Certificate_Details__c> fetchCertificateList = [ select Id, OwnerId, IsDeleted, Name, CurrencyIsoCode, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Begin_Mi_Km_Hr__c, Certificate__c, CoverageType__c, Deductible__c, End_Mi_Km_Hr__c, Expiry_Date_Formula__c, Procedure_Number__c, Start_Date_Formula__c, Status__c, Warranty_Admin_Manual_URL__c, Status_Colour__c  From Fsl_Certificate_Details__c  where service_order__c = : woid ];
        //return list of Fsl_Certificate_Details__c
        return fetchCertificateList;
    }
     
    /*
    @AuraEnabled
    public static WorkOrder getAssestandWarrantyInformation(Id recordId){
        workorder wo=[select id,Type__c,AssetId,Asset.Engine_Manufacturer__c,Asset.VIN__c,Make__c,Model__c,Service_Model__c,Application__c,
         Unit_Number_Formula__c,Equipment_Id__c,Mileage__c,Mileage_Measure__c,CSS_Hours__c,
              
          (select Definition_Type__c,Coverage_Type__c,	Coverage_Miles_Km_Hr_Mw_Hr__c,Status__c,Warranty_End_Date__c,Warranty_Start_Date__c,Warranty_Manual_URL__c,Deductible__c from Coverage_Details__r),
            (select CoverageType__c,Certificate__c,Status__c,Start_Date__c,Expiry_Date_Formula__c,Begin_Mi_Km_Hr__c,End_Mi_Km_Hr__c,Deductible__c,Warranty_Admin_Manual_URL__c from Certificate_Details__r) 
            from WorkOrder where id =: recordId limit 1];
        return wo;
    }*/



}