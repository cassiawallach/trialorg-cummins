//Kommented updates
@isTest
public class dbu_SaveForLaterWrapper_Test {

    @isTest public static void testemhod(){
        
        Test.startTest();
        dbu_SaveForLaterWrapper sflWrap = new dbu_SaveForLaterWrapper();
        
        sflWrap.ProductID 				= '0411mcdmeeeeeeee0';
        sflWrap.ProductName 			= 'Dummyproducte';
        sflWrap.ProductPrice 			=  213;
        sflWrap.ProductQuantity 		=  4;
        sflWrap.IsCrateProductCheck		=  true;
        sflwrap.IsCoreProductcheck 		= false;
        sflwrap.ProductURL				= 'https://odeboyz.files.wordpress.com/2018/09/operation-barbarossa.jpg';
		sflwrap.inventoryQuantity		= 5;	
    	sflwrap.stockstatus				= true;
        sflwrap.parentProductID			= '0411mcdmeeeeeeee0';
        sflwrap.deliveryMethod 			= true;   
            
        list<dbu_SaveForLaterWrapper> sflwraplist = new list<dbu_SaveForLaterWrapper>();
        sflwraplist.add(sflWrap);
        
        system.assertEquals(1, sflwraplist.size());
        
        Test.stopTest();
        
        
    }
    
}