@isTest
public class dbu_EXTEND_ccLogicCartCreate_Test {
 
    @isTest static void testmethod1(){
        
        UserRole userRole_1 = [SELECT Id FROM UserRole WHERE DeveloperName = 'CEO' LIMIT 1];
        Profile profile_1 = [SELECT Id FROM Profile WHERE name = 'IAM User' LIMIT 1];
        User admin = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
        admin.UserRoleId = userRole_1.Id;
        update admin;
                //system.debug('kirov');
                //system.debug('Miguelito');
        System.runAs(admin) {

        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
            
        //Setup Account for Logged In user
        Account acc 							=	dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc;    

		  List<ccrz__E_Cart__c> crt = new List<ccrz__E_Cart__c>();
		  List<ccrz__E_Cart__c> crt2 = new List<ccrz__E_Cart__c>();          
            
            ccrz__E_Cart__c	cartItem						=	new ccrz__E_Cart__c();
            cartItem.ccrz__Name__c							=	'OperationBagration';
            cartItem.ccrz__CartType__c						=	'Cart';
            cartItem.ccrz__CurrencyISOCode__c				=	'USD';
            cartItem.ccrz__ActiveCart__c					=	true;
            cartItem.ccrz__Storefront__c					=	'CSSNAStore';
            cartItem.ccrz__CartStatus__c					=	'Open';                                             
            crt.add(cartItem);		

            ccrz__E_Cart__c	cartItem2						=	new ccrz__E_Cart__c();
            cartItem2.ccrz__Name__c							=	'OperationBarbarossa';
            cartItem2.ccrz__CartType__c						=	'Cart';
            cartItem2.ccrz__CurrencyISOCode__c				=	'USD';
            cartItem2.ccrz__ActiveCart__c					=	true;
            cartItem2.ccrz__Storefront__c					=	'CSSNAStore';
            cartItem2.ccrz__CartStatus__c					=	'Open';      
            cartItem2.dbu_Cart_StoreCountry__c				=	'US';
			insert cartItem2;
            
            crt2 = [select id, 
                    ccrz__Name__c, 
                    ccrz__CartType__c, 
                    ccrz__CurrencyISOCode__c, 
                    ccrz__ActiveCart__c, 
                    ccrz__Storefront__c,
                    ccrz__CartStatus__c, 
                    dbu_Cart_StoreCountry__c,
                    ccrz__EncryptedId__c
                    from ccrz__E_Cart__c 
                    where ccrz__Name__c = 'OperationBarbarossa' ];
            
        Map<String, Object> cartToCreate = new Map<String, Object> {
            'cartType' => 'Cart',
            'activeCart' => true,
            'name' => 'keirningsberg',
            'storefront' => 'CSSNAStore',
            'account' => acc.id
        };              
            

        Map<String, Object> inputdata = new Map<String, Object>{
            'transformIndex' => new Map<string,object>{'dbuCartStoreCountry' => 'dbu_Cart_StoreCountry__c'},
            'cartList' =>  new list<Map<string, object>>{cartToCreate},
                'baseFieldsMap' => new Map<string,object>{'tif' => 'iuo'},
                    'originalInputData' => cartToCreate,
                    'sizing' => new Map<string,object>{'sz_refetch'=> true},
            		'version' => 45
        };
          
        Map<String, Object> inputdata2 = new Map<String, Object>{
            'transformIndex' => new Map<string,object>{'dbuCartStoreCountry' => 'dbu_Cart_StoreCountry__c'},
            'cartList' =>  crt,
                'baseFieldsMap' => new Map<string,object>{'tif' => 'iuo'},
                    'originalInputData' => cartToCreate,
                    'sizing' => new Map<string,object>{'sz_refetch'=> true},
            		'version' => 45
        };
         
        Map<String, Object> inputdata3 = new Map<String, Object>{
            'transformIndex' => new Map<string,object>{'dbuCartStoreCountry' => 'dbu_Cart_StoreCountry__c'},
            'cartList' =>  crt2,
                'baseFieldsMap' => new Map<string,object>{'tif' => 'iuo'},
                    'originalInputData' => cartToCreate,
                    'sizing' => new Map<string,object>{'sz_refetch'=> true},
            		'version' => 45
        };            
        Test.startTest();
      
         dbu_EXTEND_ccLogicCartCreate logicCartCreate = new dbu_EXTEND_ccLogicCartCreate();
         logicCartCreate.createCarts(inputdata);   
         logicCartCreate.insertCarts(inputdata2);
         logicCartCreate.refetch(inputdata3);   
        Test.stopTest();
            
            
        }        
        

        
    }
}