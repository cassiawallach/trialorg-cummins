@isTest
public class OSM_SW_TestDataHelper_Ctrl_Test 
{
    static testMethod void testCreateNewCartAndCreateSubProdTermAndCreateNewCartitem()
    {
        // Query Profile Id
        List<Profile> listObjProfile = [Select id, name from profile where name = 'CloudBurst Customer Community Profile'];
        
        // Create User
        User objUser;
        
        if(listObjProfile.size() > 0){
            objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true);  
        }else{
            listObjProfile = [Select id, name from profile where name = 'Customer Community Plus User'];
            if(listObjProfile.size() > 0){
                objUser = TestingUtils.createUser('TestUserDA', listObjProfile[0].Id, true); 
            }
        } 
        
        ccrz__E_Product__c product = TestingUtils.createCompositeProduct('productName' + '-1','SKU-1' + '-1','DA','Product',true);
        
        ccrz__E_Cart__c cart = OSM_SW_TestDataHelper_Ctrl.createNewCart('SoftwareStore','Open',objUser.ID,true,'Success');
        ccrz__E_SubProdTerm__c subProdTerm = OSM_SW_TestDataHelper_Ctrl.createSubProdTerm('TestSubProdTerm',System.today(),System.today().addMonths(12),product.ID,'*');
       
        ccrz__E_CartItem__c cartItem = OSM_SW_TestDataHelper_Ctrl.createNewCartitem(String.valueOf(cart.ID),'Open', 1,product.ID,subProdTerm.ID,10.00);
    }
    
    static testMethod void testCreateNewContact()
    {
        Contact con = OSM_SW_TestDataHelper_Ctrl.createNewContact('firstName','lastName','abc@gmail.com');
    }

    static testMethod void testCreateNewProduct()
    {
        ccrz__E_Product__c product = OSM_SW_TestDataHelper_Ctrl.createNewProduct('productName' + '-1','Released',1,'SKU-1',System.today(),System.today().addMonths(12),'DA');  
    }
}