//modified by vinod added by vinod -9-22-2020--to cover apex code.   
//Modified by Krishna for Production Release 

@isTest
public class FSL_CL_SiteCreateUpdate_Test {
    
    private static void dataSetup() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='qt943@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,ERP__c='MOVEX',
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt943@cummins.com.test1run',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        insert u;
        System.runas(u){
            User user = new User(Alias = 'standt', Email='qt943@cummins.com', 
                                 EmailEncodingKey='UTF-8', LastName='Test_LastName', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,ERP__c='BMS',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='qt943@cummins.com.testrun',
                                 FSL_Primary_Service_Territory_Code__c = '12345');
            
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
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.Email = 'er234@its.jnj.com';
            con.AccountId=acc.id;
            con.FSL_Contact_Id__c= '12';
            insert con;
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            ServiceTerritory sT = new ServiceTerritory(); 
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            st.IsActive = true;
            sT.Location_Code__c = '05340-05351';
            sT.FSL_Service_Territory_Code__c = '05351';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            Asset asst = new Asset();
            asst.Name = '79704393';
            asst.Type_PSN__c = 'Engines-79704393';
            asst.Type__c = 'Engines';
            insert asst;
            
            CSS_CountryStateValues__c countryState = new CSS_CountryStateValues__c();
            countryState.Name = 'US IN';
            countryState.CountryCode__c = 'US';
            countryState.CountryName__c = 'United States';
            countryState.StateCode__c = 'IN';
            countryState.StateName__c = 'Indiana';
            insert countryState;
            
            
            Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
            
            Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'Indiana';
            addr.Country = 'United States';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '500-0093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
            addr.Account__c = acc.Id;
            insert addr;
            WorkOrder wo    = new WorkOrder();
            wo.AssetId      = asst.Id;
            wo.AccountId    = acc.Id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Status       = 'closed';
            wo.Category1__c = 'Leak';
            wo.Process_Step__c = 'Intake';
            wo.ContactId = con.Id;
            wo.Shop_Work_Order__c = 'test123uikjkj';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.createdDate=system.now().addDays(-29);
            wo.Repair_Location__c = 'Mobile';
            wo.Repair_Site_Address__c = addr.Id; //CT2-416
            insert wo;
            system.debug('inserted wo###'+wo);
            FSL_ERP_Country_Translation__mdt fect=new FSL_ERP_Country_Translation__mdt();
            fect.Country__c='Ireland';
            fect.MasterLabel='Eire';
            //FSL_CL_SiteCreateUpdate.checkSiteId(wo.id,wo.Account.FSL_ERP_Customer_Code__c,wo.Contact.FSL_Contact_Id__c);
        }
    }
    
    @isTest static void testCallout() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        test.stopTest();
    }
    
    @isTest static void testCalloutForSiteCreate() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User userName = new User(Alias = 'standt', Email='qt943@cummins.com', 
                                 EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,ERP__c='BMS',
                                 TimeZoneSidKey='America/Los_Angeles', UserName='qt943@cummins.com.test212run',
                                 FSL_Primary_Service_Territory_Code__c = '12345');
        insert userName;
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User userName1 = new User(Alias = 'standt', Email='qt943@cummins.com', 
                                  EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                                  LocaleSidKey='en_US', ProfileId = p1.Id,ERP__c='MOVEX',
                                  TimeZoneSidKey='America/Los_Angeles', UserName='qt943@cummins.com.test323run',
                                  FSL_Primary_Service_Territory_Code__c = '12345');
        insert userName1;
        System.runAs(userName){
            dataSetup();
            
            //User u = [Select id,FSL_Primary_Service_Territory_Code__c FROM User Limit 1];
            //Contact con = [Select id, FSL_Contact_Id__c FROM Contact Limit 1];
            //Account acc = [Select id, FSL_ERP_Customer_Code__c FROM Account Limit 1];
            //Asset asst = [Select id FROM Asset Limit 1];
            //ServiceTerritory sT = [Select id,Location_Code__c FROM ServiceTerritory Limit 1];
            test.startTest();
            
            //CT2-416
            /*IAM_CDH_Cross_references__c objsite = [SELECT Id,Name,IAM_Account__c,FSL_MoveX_Contact_Id__c,FSL_MoveX_Site_Id__c,FSL_Address_Line_1__c,
FSL_Country__c,FSL_State__c,FSL_City__c,FSL_Tax_District__c,CreatedById FROM IAM_CDH_Cross_references__c WHERE Name = 'Test cross ref'];
*/
            Schema.Address addressObj =[SELECT Id, Name FROM Address WHERE Street = '345 Dr'];
            
            WorkOrder wo = [Select id,WorkOrderNumber,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c, Repair_Location__c, ServiceTerritoryId, ContactId, Repair_Site_Name__r.Name 
                            FROM WorkOrder WHERE Shop_Work_Order__c ='test123uikjkj' Limit 1];
            
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            FSL_CL_SiteCreateUpdate.checkSiteId(wo.id,wo.Account.FSL_ERP_Customer_Code__c,wo.Contact.FSL_Contact_Id__c);
            //FSL_CL_SiteCreateUpdate.strCntry = 'US';
            //FSL_CL_SiteCreateUpdate.strCntryState = 'IN';
            //FSL_Utility.getCountryCode(cs.CountryName__c);
            //FSL_Utility.getStateCode(cs.CountryName__c, cs.StateName__c);
            //  FSL_CL_SiteCreateUpdate.updateSiteId('{"Header":{"Sender":{"ServiceName":"CreateUpdateSite","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"05340-05351"}},"DataArea":{"DistributorCode":"05340", "BranchCode":"05351","SiteName":"Test A","SiteID":"","CustomerCode":"1310102","Longitude":"","Latitude":"","Address1":"1 Phillip Ct","Address2":"","Address3":"","City":"Port Melbourne","State":"South Australia","PostalCode":"3207","Country":"Australia","ContactID":"","RepairLocation":"Mobile","CSSJobID":"0002345","TaxDistrict":"","CreateUser":"","ChangeUser":""}}','09Stk!AR4AQF1zO2i3.KhsoAasxRgviPsRW3uGmJf2rg.dFQSWthcy2TRvVU8uw1Q');
            test.stopTest();
            
        }
        // Added by Shirisha to increase code coverage
        System.runAs(userName1){
            Schema.Address addressObj =[SELECT Id, Name FROM Address WHERE Street = '345 Dr'];
            
            WorkOrder wo = [Select id,WorkOrderNumber,Account.FSL_ERP_Customer_Code__c,Contact.FSL_Contact_Id__c, Repair_Location__c, ServiceTerritoryId, ContactId, Repair_Site_Name__r.Name 
                            FROM WorkOrder WHERE Shop_Work_Order__c ='test123uikjkj' Limit 1];
            
            FSL_CL_SiteCreateUpdate.checkSiteId(wo.id,wo.Account.FSL_ERP_Customer_Code__c,wo.Contact.FSL_Contact_Id__c);
            
        }
        
    }
}