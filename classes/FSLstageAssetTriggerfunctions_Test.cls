/*Sending test class along with main class
    Rajashekar  07/12/2020 
*/
//Comment added for deployment - Jan 22 Release
//Comment added for deployment - Feb 6th 22 Release Murali Seelam  
@isTest
public class FSLstageAssetTriggerfunctions_Test {
    
    public static testMethod void insertAssetTest() {
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
			acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.FSL_Contact_Id__c = '12456';
        con.AccountId = acc.Id;
        insert con;
        
       
        //CT2-416 : IAM_CDH_Cross_references__c replaced by Address
        /*
        
        IAM_CDH_Cross_references__c objIAM = new IAM_CDH_Cross_references__c();
        objIAM.Name='Test1';
        objIAM.IAM_Account__c = acc.Id;
        objIAM.FSL_MoveX_Site_Id__c = '1234564';
        insert objIAM; 
        */
        Id mmaRecId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        CSS_Make_Model_Access__c objmake = new CSS_Make_Model_Access__c();
        objmake.EquipmentId__c = '78789';
        objmake.EngineFamilyCode__c='10';
        objmake.Make__c= '20';
        objmake.Model__c='30';
        objmake.RecordTypeId = mmaRecId;
        insert objmake;
        
        FSL_Stage_Asset__c objstage = new FSL_Stage_Asset__c();
        objstage.Name = 'Test345';
        objstage.Type_PSN__c = 'Engines';
        objstage.Type__c = 'Engines';
        objstage.Individual__c = '0450090578';
        objstage.Source__c = 'MoveX';
        //objstage.Make__c = '';
        objstage.VIN__c = '';
        objstage.Model__c = '';
        objstage.Address_Line1__c ='check';
        objstage.Automotive_Application_Flag__c = 'a';
        objstage.Build_Date__c  = system.today();
        objstage.City__c = 'test';
        objstage.Critical_Part_List_Number__c = 'test';
        objstage.Customer_Code__c = '130SERV';
        objstage.Customer_Name__c = 'test';
        objstage.Design_Phase_Code__c = 'test';
        objstage.Engine_Application_Code__c = 'test';
        objstage.Engine_Application_Description__c = 'test';
        objstage.Engine_Bill_To_Code__c = 'test';
        objstage.Engine_Family_Code__c = 'test';
        objstage.Engine_Family_Name__c = 'test';
        objstage.Equipment_Configuration__c = 'test';
        objstage.ETO_Conversion_Date__c  = system.today();
        objstage.ETO_Old_PSN__c = 'test';
        objstage.Marine_Application_Flag__c = 'Y';
        objstage.No_Warranty__c  = true;
        objstage.OEM_SP_Code__c = 'test';
        objstage.Owner_Name__c = 'test';
        objstage.MoveX_Contact_ID__c = '12456';
        objstage.MoveX_Site_ID__c = '1234564';
        objstage.Equipment_Id__c= '78789';
        //  objstage.Processing_Status__c = 'test';
        objstage.Product_Application_Code__c = 'te';
        objstage.Paccar_Flag__c = true;
        objstage.Recon_Engine_Flag__c=true;
        objstage.Cash_Customer_Flag__c='Y';
        objstage.Cash_Customer_Flag__c='N';
        //objstage.Type__c = 'Engines';
        objstage.Service_Model_Name__c  = '';
        objstage.Manufacturer__c = '';
        objstage.Unit_Type__c = 'EQ8349';
       // objstage.Family_Code_Make_Model__c = '';
        insert objstage;
        
        List<FSL_Stage_Asset__c> lststgast = new List<FSL_Stage_Asset__c>();
        lststgast.add(objstage);
        
        FSLstageAssetTriggerfunctions.clonestagetoAsset(lststgast);
        
        set<String> setTypePSN = new set<String>();
        setTypePSN.add(objstage.Type_PSN__c);
        
        Asset objasa = new Asset();
        objasa.Name = 'Test347';
        objasa.Type_PSN__c = 'Engines';
        objasa.Type__c = 'Engines';
        insert objasa;
        
        map<String,Asset> mapAssets = new map<String,Asset>();
        mapAssets.put(objasa.Type_PSN__c, objasa);
        
    /*   Asset objAsset;
        if(objstage.Type_PSN__c != null && objstage.Type_PSN__c != '' && mapAssets.containsKey(objstage.Type_PSN__c)) {
            objAsset = mapAssets.get(objstage.Type_PSN__c);
        }  */
        
        /* Asset objas = new Asset();
objas.Name = objstage.Name ;
objas.Type_PSN__c = objstage.Type_PSN__c;
insert objas; */
        
        Account objAcc = new Account(Name='testabc',BillingStreet=null,BillingCity=null,billingcountry='India',CMI_CId__c='1234',FSL_ERP_Customer_Code__c='test',FSL_Source_ERP__c='BMS');
        insert objAcc;
        
        /*  Contact con = new Contact(FirstName = null,LastName='jas',Email='',Phone='8951633648',MailingStreet='',MailingCity='',MailingPostalCode='52302',mailingcountry='',mailingstate='' ,
District_ABO__c='',Customer_Name__c='',FSL_Contact_Id__c ='test',accountid = objAcc.id);
insert con;*/
        
        test.stopTest();
    }
    
    public static testMethod void insertSiebelTest() {
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
			acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.FSL_Contact_Id__c ='12456';
        con.AccountId = acc.Id;
        insert con;
        
        
        //CT2-416 : IAM_CDH_Cross_references__c replaced by Address
        /*
        IAM_CDH_Cross_references__c objIAM = new IAM_CDH_Cross_references__c();
        objIAM.Name='Test';
        objIAM.IAM_Account__c = acc.Id;
        insert objIAM;
        */
        Id mmaRecId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        CSS_Make_Model_Access__c objmake = new CSS_Make_Model_Access__c();
        objmake.EquipmentId__c = '78789';
        objmake.EngineFamilyCode__c='10';
        objmake.Make__c= '20';
        objmake.Model__c='30';
        objmake.RecordTypeId = mmaRecId;
        insert objmake;
        
        FSL_Stage_Asset__c objstage = new FSL_Stage_Asset__c();
        objstage.Name ='Test346';
        objstage.Type_PSN__c ='Engines';  
        objstage.Source__c = 'Siebel'; 
        //objstage.Make__c = '';
        objstage.VIN__c = '';
        objstage.Model__c = '';
        objstage.Address_Line1__c ='check';
        objstage.Automotive_Application_Flag__c = 'a';
        objstage.Build_Date__c  = system.today();
        objstage.City__c = 'test';
        objstage.Critical_Part_List_Number__c = 'test';
        objstage.Customer_Code__c = '130SERV';
        objstage.Customer_Name__c = 'test';
        objstage.Design_Phase_Code__c = 'test';
        objstage.Engine_Application_Code__c = 'test';
        objstage.Engine_Application_Description__c = 'test';
        objstage.Engine_Bill_To_Code__c = 'test';
        objstage.Engine_Family_Code__c = 'test';
        objstage.Engine_Family_Name__c = 'test';
        objstage.Equipment_Configuration__c = 'test';
        objstage.ETO_Conversion_Date__c  = system.today();
        objstage.ETO_Old_PSN__c = 'test';
        objstage.Marine_Application_Flag__c = 'b';
        objstage.No_Warranty__c  = true;
        objstage.OEM_SP_Code__c = 'test';
        objstage.Owner_Name__c = 'test';
        objstage.MoveX_Contact_ID__c = '12456';
        objstage.MoveX_Site_ID__c = '1234564';
        objstage.Equipment_Id__c= '78789';
        // objstage.Processing_Status__c = 'test';
        objstage.Product_Application_Code__c = 'te';
        objstage.Paccar_Flag__c =true ;
        objstage.Recon_Engine_Flag__c=true;
        objstage.Cash_Customer_Flag__c='Y';
        //objstage.Cash_Customer_Flag__c='N';
        objstage.Access_Code__c='007';
        objstage.BIS_Flag__c = true;
        objstage.Warranty_Start_Date__c =system.today();
        objstage.Product_Application_Description__c='test';
        objstage.Ship_Date__c= system.Today();
        objstage.Manufacturer__c = '';
        // try{
        insert objstage;
        
        objstage.Access_Code__c = '008';
        update objstage;
        
        
        List<FSL_Stage_Asset__c> lststgast = new List<FSL_Stage_Asset__c>();
        lststgast.add(objstage);
        
        FSLstageAssetTriggerfunctions.clonestagetoAsset(lststgast);
        
        Asset objasa = new Asset();
        objasa.Name = 'Test346' ;
        objasa.Type_PSN__c  = 'Engines' ;
        objasa.Type__c = 'Engines';
        insert objasa;
        
        map<String,Asset> mapAssets = new map<String,Asset>();
        mapAssets.put(objasa.Type_PSN__c, objasa);
        
        Asset objAsset;
        if(objstage.Type_PSN__c != null && objstage.Type_PSN__c != '' && mapAssets.containsKey(objstage.Type_PSN__c)) {
            objAsset = mapAssets.get(objstage.Type_PSN__c);
        }
        
        set<String> setTypePSN = new set<String>();
        setTypePSN.add(objstage.Type_PSN__c);
    }
    
    public static testMethod void updateSiebelTest() {
       
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
			acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.FSL_Contact_Id__c ='12456';
        con.AccountId = acc.Id;
        insert con;
        
       
        //CT2-416 : IAM_CDH_Cross_references__c replaced by Address
        /*
        IAM_CDH_Cross_references__c objIAM = new IAM_CDH_Cross_references__c();
        objIAM.Name='Test';
        objIAM.IAM_Account__c = acc.Id;
        insert objIAM;
        */
        Id mmaRecId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        CSS_Make_Model_Access__c objmake = new CSS_Make_Model_Access__c();
        objmake.EquipmentId__c = '78789';
        objmake.EngineFamilyCode__c='10';
        objmake.Make__c= '20';
        objmake.Model__c='30';
        objmake.RecordTypeId = mmaRecId;
        insert objmake;
        
         Asset objasa = new Asset();
        objasa.Name = 'Test346' ;
        objasa.Type_PSN__c  = 'Engines-79064718';
        objasa.Type__c = 'Engines';
        insert objasa;
        
        FSL_Stage_Asset__c objstage = new FSL_Stage_Asset__c();
        objstage.Name ='79064718';
        objstage.Type_PSN__c ='Engines';  
        objstage.Source__c = 'Siebel'; 
        //objstage.Make__c = '';
        objstage.VIN__c = '';
        objstage.Model__c = '';
        objstage.Address_Line1__c ='check';
        objstage.Automotive_Application_Flag__c = 'a';
        objstage.Build_Date__c  = system.today();
        objstage.City__c = 'test';
        objstage.Critical_Part_List_Number__c = 'test';
        objstage.Customer_Code__c = '130SERV';
        objstage.Customer_Name__c = 'test';
        objstage.Design_Phase_Code__c = 'test';
        objstage.Engine_Application_Code__c = 'test';
        objstage.Engine_Application_Description__c = 'test';
        objstage.Engine_Bill_To_Code__c = 'test';
        objstage.Engine_Family_Code__c = 'test';
        objstage.Engine_Family_Name__c = 't';
        objstage.Equipment_Configuration__c = 'test';
        objstage.ETO_Conversion_Date__c  = system.today();
        objstage.ETO_Old_PSN__c = 'test';
        objstage.Marine_Application_Flag__c = 'b';
        objstage.No_Warranty__c  = true;
        objstage.OEM_SP_Code__c = 'test';
        objstage.Owner_Name__c = 'test';
        objstage.MoveX_Contact_ID__c = '12456';
        objstage.MoveX_Site_ID__c = '1234564';
        objstage.Equipment_Id__c= '';
        // objstage.Processing_Status__c = 'test';
        objstage.Product_Application_Code__c = 'te';
        objstage.Paccar_Flag__c =true ;
        objstage.Recon_Engine_Flag__c=true;
        objstage.Cash_Customer_Flag__c='Y';
        //objstage.Cash_Customer_Flag__c='N';
        objstage.Access_Code__c='007';
        objstage.BIS_Flag__c = true;
        objstage.Warranty_Start_Date__c =system.today();
        objstage.Product_Application_Description__c='test';
        objstage.Ship_Date__c= system.Today();
        objstage.Manufacturer__c = '';
        objstage.Engine_Manufacturer__c = 'AJAX';
        objstage.Type__c = 'ENGINE';
        // try{
        insert objstage;
        
        
     FSL_Stage_Asset__c objstAsst = [SELECT Id,Type__c,Name,Type_PSN_IIN__c FROM FSL_Stage_Asset__c WHERE id=:objstage.id ];
        
        system.debug('check val'+objstAsst.Type_PSN_IIN__c);
        List<FSL_Stage_Asset__c> lststgast = new List<FSL_Stage_Asset__c>();
        lststgast.add(objstage);
  
   Test.startTest();
        
        
        system.debug('check field value'+objasa.Type_PSN__c);
        FSLstageAssetTriggerfunctions.clonestagetoAsset(lststgast);
        
        
     test.stoptest();
        
        map<String,Asset> mapAssets = new map<String,Asset>();
        mapAssets.put(objasa.Type_PSN__c, objasa);
        
        Asset objAsset;
        if(objstage.Type_PSN__c != null && objstage.Type_PSN__c != '' && mapAssets.containsKey(objstage.Type_PSN__c)) {
            objAsset = mapAssets.get(objstage.Type_PSN__c);
        }
        
        set<String> setTypePSN = new set<String>();
        setTypePSN.add(objstage.Type_PSN__c);
    }
}