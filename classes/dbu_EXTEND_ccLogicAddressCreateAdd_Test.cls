@isTest
private class dbu_EXTEND_ccLogicAddressCreateAdd_Test {

    @isTest private static void testMethod1(){
        
        string FIRSTNAME                =   'Test1';
        string LASTNAME                 =   'Customers';
        
        Id AccountRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();
        Id ContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        
        //Get Profile Id - IAM User
        Id profileId = [Select Id From Profile Where Name='IAM User'].id;
        
        //Get Permission Sets
        List<PermissionSet> PermSetList = [SELECT id FROM PermissionSet where Name = 'B2BCommerceGuestCloneDefaultOwner' OR Name = 'eCommerce' LIMIT 2];
        
        //Setup Account for Logged In user
        Account acc                             =   dbu_FactoryDataTest.createIAMAccount('Identity Individual Users12yTest', AccountRecordType);
        insert acc;
        
        //Setup Contact for Logged In user - without Wishlist
                    
        //Contact con                             =   dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
        //insert con;        
        
            //Setup Contact for Logged In user - without Wishlist
            //Contact con                =  dbu_FactoryDataTest.createIAMContact(FIRSTNAME, LASTNAME, acc.id, ContactRecordTypeId);
          //con.Username__c              =  UserInfo.getUserName();
          
          String orgId = UserInfo.getOrganizationId();  
            String dateString =   
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
            String uniqueName = orgId + dateString + randomInt;
          //con.Username__c              =  uniqueName + '@test' + orgId + '.org';
            
          Contact con = new Contact(LastName = LASTNAME, FirstName = FIRSTNAME ,AccountId = acc.id);  
            con.Username__c = uniqueName + '@test' + orgId + '.org'; 
            insert con;        
        
//############### ShipTo Address ##################################################
Map<string, object> addressmapShipto = new Map<string, object>{
                'addressFirstline'      => 'Willy Wonka Chocolate Factory',
                'addressSecondline'     => 'LoompaLand',
                'addressThirdline'      => 'earth',
                'addrReadOnly'          => false,
                'city'                  => 'London',
                'companyName'           => 'Burton entertainment',
                'country'               => 'Great Britain',
                'countryISOCode'        => 'USD',
                'daytimePhone'          => '653994092492',
                'email'                 => 'willyWonka@chocolates.com',
                'firstName'             => 'Willy',
                'homePhone'             => '1-898-4092388934',
                'lastName'              => 'Wonka',
                'middleName'            => 'Wilbur',
                'postalCode'            => '468493',
                'shippingComments'      => '5 wonka bar has an each golden ticket inside and 5 lucky children will have a chance to visit my factory.', 
                'state'                 => 'Sussex',                     
                'dbuContact'            =>  con.Id                               
  };            
system.debug(addressmapShipto);

//############### BillTo Address ##################################################
Map<string, object> addressmapBillTo = new Map<string, object>{
                'addressFirstline'      => 'Willy Wonka Chocolate Factory',
                'addressSecondline'     => 'LoompaLand',
                'addressThirdline'      => 'earth',
                'addrReadOnly'          => false,
                'city'                  => 'London',
                'companyName'           => 'Burton entertainment',
                'country'               => 'Great Britain',
                'countryISOCode'        => 'USD',
                'daytimePhone'          => '6539294092492',
                'email'                 => 'charliebucket@charlieandthechocolatefactory.com',
                'firstName'             => 'Charlie',
                'homePhone'             => '1-898-40392388934',
                'lastName'              => 'Bucket',
                'middleName'            => 'Charlies father',
                'postalCode'            => '4684393',
                'shippingComments'      => 'He was the luckiest child in the whole world, just he didnt knew this yet.',
                'state'                 => 'Sussex',                     
                'dbuContact'            =>  con.Id                              
  };            
system.debug(addressmapBillto);        
        
        
        ccrz__E_ContactAddr__c addr1 = new ccrz__E_ContactAddr__c();
            addr1.dbu_Contact__c                    =   con.Id;
            addr1.ccrz__FirstName__c                =   'Willy';
            addr1.ccrz__LastName__c                 =   'Wonka';
            addr1.ccrz__MiddleName__c               =   'Wilbur';    
            addr1.ccrz__AddressFirstline__c         =   'Willy Wonka Chocolate Factory';
            addr1.ccrz__AddressSecondline__c        =   'LoompaLand';
            addr1.ccrz__AddressThirdline__c         =   'earth';
            addr1.ccrz__City__c                     =   'London';
            addr1.ccrz__AddrReadOnly__c             =   false;
            addr1.ccrz__Country__c                  =   'Great Britain';
            addr1.ccrz__CountryISOCode__c           =   'USD';
            addr1.ccrz__DaytimePhone__c             =   '7653994092492';
            addr1.ccrz__Email__c                    =   'willyWonka@chocolates.com';
            addr1.ccrz__HomePhone__c                =   '1-898-4092388934';
            addr1.ccrz__PostalCode__c               =   '468493';
            addr1.ccrz__ShippingComments__c         =   '5 wonka bar has an each golden ticket inside and 5 lucky children will have a chance to visit my factory.';
            addr1.ccrz__State__c                    =   'Sussex';
            insert addr1;
        
        
        ccrz__E_ContactAddr__c addr2 = new ccrz__E_ContactAddr__c();
            addr2.dbu_Contact__c                    =   con.Id;
            addr2.ccrz__FirstName__c                =   'Charlie';
            addr2.ccrz__LastName__c                 =   'Bucket';
            addr2.ccrz__MiddleName__c               =   'cherry';    
            addr2.ccrz__AddressFirstline__c         =   'Willy Wonka Chocolate Factory';
            addr2.ccrz__AddressSecondline__c        =   'LoompaLand';
            addr2.ccrz__AddressThirdline__c         =   'earth';
            addr2.ccrz__City__c                     =   'London';
            addr2.ccrz__AddrReadOnly__c             =   false;
            addr2.ccrz__Country__c                  =   'Great Britain';
            addr2.ccrz__CountryISOCode__c           =   'USD';
            addr2.ccrz__DaytimePhone__c             =   '76539092492';
            addr2.ccrz__Email__c                    =   'charliebucket@charlieandthechocolatefactory.com';
            addr2.ccrz__HomePhone__c                =   '1-898-40w92388934';
            addr2.ccrz__PostalCode__c               =   '4684493';
            addr2.ccrz__ShippingComments__c         =   'He was the luckiest child in the whole world, just he didnt knew this yet.';
            addr2.ccrz__State__c                    =   'Sussex';           
            insert addr2;
        
        list<Map<string,object>> ctrlist = new list<Map<string,object>>();
        ctrlist.add(addressmapShipto);
        ctrlist.add(addressmapBillto);
                                
        list<string> ctraddrlist = new list<string>();
        ctraddrlist.add((string)addr1.id);
        ctraddrlist.add((string)addr2.id);
        
        system.debug('ctraddrlist > ' + ctraddrlist);
        
        Map<string,object> InputData = new Map<string,object>{
            'originalInputData' => new Map<string,object>{
                'addressList' => ctrlist
            },
            'addressIdList' => ctraddrlist    
        };
        
        Test.startTest();     
        dbu_EXTEND_ccLogicAddressCreateAddress callExtendCreateAddressMethod = new dbu_EXTEND_ccLogicAddressCreateAddress();
        callExtendCreateAddressMethod.createAddress(InputData);
        Test.stoptest();   
          
    }
    
}