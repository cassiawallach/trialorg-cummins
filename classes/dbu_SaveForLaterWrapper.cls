public class dbu_SaveForLaterWrapper {
    public dbu_SaveForLaterWrapper(){ 
    }
    @AuraEnabled public string ProductID;
    @AuraEnabled public string ProductName;
    @AuraEnabled public string ProductURL;
    @AuraEnabled public double ProductPrice;
    @AuraEnabled Public integer ProductQuantity;
    @AuraEnabled Public boolean IsCrateProductCheck;
    @AuraEnabled public boolean IsCoreProductcheck;
    @AuraEnabled public double inventoryQuantity;
    @AuraEnabled public boolean stockstatus;
    @AuraEnabled public string parentProductID;
    @AuraEnabled public boolean deliveryMethod;
    @AuraEnabled public string ProductSKU; // Added CECI-992
    @AuraEnabled public String Brandname;//Added-CECI-958
    @AuraEnabled public String Categoryname;//Added-CECI-958

    //add inventory quantity
    @AuraEnabled public string promotionTag; // Added by devaraj for CECi-957
    @AuraEnabled public double originalPrice;// Added by devaraj for CECi-960
    @AuraEnabled public integer discountPercentage;// Added by devaraj for CECi-960

}