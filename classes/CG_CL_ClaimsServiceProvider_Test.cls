@isTest
public class CG_CL_ClaimsServiceProvider_Test
{
    static testMethod void CG_CL_ClaimsServiceProvider_Test(){
        Test.startTest();  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '56270-56270',isActive = true);
        insert(u);
        System.runAs(u) {
             
             CSS_Claims__c testclaimsRec = new CSS_Claims__c();
                //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
                testclaimsRec.Customer_Name__c='TestCustomer';
                //testclaimsRec.css_job__c = JO.id;
                testclaimsRec.Customer_Code__c = '1234';
                testclaimsRec.Contact_Last_Name__c = 'T';
             testclaimsRec.Contact_First_Name__c = 'T';
                testclaimsRec.Address__c = 'T';
                testclaimsRec.Customer_Contact_Phone__c = null;
                testclaimsRec.Email_Address__c = 'rp@sct.com';
                testclaimsRec.Status__c = 'Draft';
            //testclaimsRec.warrantyAuthFlag='test';
                testclaimsRec.TSR1__c = '1234';
                testclaimsRec.TSR2__c = '1234';
                testclaimsRec.TSR3__c = '1234';
                testclaimsRec.TSR4__c = '1234';
                testclaimsRec.TSR5__c = '1234';
                testclaimsRec.TSR6__c = '1234';
                testclaimsRec.TSR7__c = '1234';
                testclaimsRec.TSR8__c = '1234';
                testclaimsRec.TSR9__c = '1234';
                testclaimsRec.TSR10__c = '1234';
                testclaimsRec.Country__c = '1234';
                testclaimsRec.State__c = '1234';
                testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.location_code__c = '02850-02991';
            testclaimsRec.Service_Model__c = 'ISBE CM800';
                insert testclaimsRec;
                String grpName = 'CQ'+'-'+'12345-12345';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            
             system.runas(new User(Id=UserInfo.getUserId()))
            { 
            
                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;
       //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        css_job_order__c joorder = css_testdata.createJobOrder(true);
        //testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            }
            
           
            
        //apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
            Cache.Session.put('ManualClaimsSelectedLocation', '03520-048921111111');
            PageReference pageRef = Page.TIMBASURVEYS__SurveyCollectDataJs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',testclaimsRec.Id);
            Account a = new Account();
            a.Name = '03520-04892';
           // a.Location__c = '56270-56270';
            a.CSS_DistributorCode__c ='02850';
            a.IAM_Service_Provider_Code__c = '02991';
            //a.IAM_Service_Provider_Code__c = '03520';
             a.Type='Dealer Account';
              a.Region__c = 'US and Canada';
             a.CMI_Account_Status__c = 'Active';
           // a.IAM_Service_Provider_Code__c = '562551';
            
            insert a;
             Account a1 = [select id, Location__c from account ];
            system.debug('a11 '+a1);
             CSS_UserLocation__c userloc = new CSS_UserLocation__c();
            userloc.name= '03520-04892';
            //userloc.location_name__c = '03520-04892';
            userloc.Location_code__c = '03520-04892';
            userloc.isActive__c = true;
            userloc.UserId__c = UserInfo.getUserId();//u.id;
            userloc.AccountId__c = a.id;
            insert userloc;
            CSS_Accreditation__c acc = new CSS_Accreditation__c();
            acc.Service_Model_Name__c = 'ISBE CM800';
            acc.Account__c = a.id;
            insert acc;
            List<CSS_AccredUser__c> lacc =new List<CSS_AccredUser__c>();
            CSS_AccredUser__c accUser = new CSS_AccredUser__c();
            
            
            accUser.User_Login_ID__c = 'nt861';
            accUser.User__c = u.id;
            //accUser.Service_Model_Name__c = 'ISBE CM800';
            accUser.Accreditation__c = acc.id;
            //accUser.Location__c = '03520-04892';
            insert accUser;
            CSS_AccredUser__c ca =[select id, Service_Model_Name__c ,Location__c, User__r.IsActive from CSS_AccredUser__c ];
            system.debug('ca1 '+ca);
            lacc.add(accUser);
            CG_CL_ClaimsIntake CI = new CG_CL_ClaimsIntake();
            
            CG_CL_ClaimsServiceProvider obj = new  CG_CL_ClaimsServiceProvider();
            //CSS_Add_Technician addTech = new CSS_Add_Technician();
            obj.cid = testclaimsRec.Id;
            obj.warrantyAuthFlag='test';
            obj.locCertification=true;
            obj.mainContr = CI;
            obj.claimsRec = testclaimsRec;
            obj.struAssId = 'test';
            obj.SubStatusPrevValue = 'test';
            obj.SelectedSubStatus = 'test';
            obj.getstrUsers1();
            //addTech.getSubStatus();
            obj.setstrUsers1(testclaimsRec.id);
            obj.certifiedSelected = true;
            obj.getItems1();
            obj.certifiedSelected = false;
            obj.getItems1();
            obj.certifiedSelected1 = true;
            obj.getItems2();
            obj.certifiedSelected1 = false;
            obj.getItems2();
            obj.certifiedSelected2 = true;
            obj.getItems3();
            obj.certifiedSelected2 = false;
            obj.getItems3();
            obj.certifiedSelected3 = true;
            obj.getItems4();
            obj.certifiedSelected3 = false;
            obj.getItems4();
            obj.certifiedSelected4 = true;
            obj.getItems5();
            obj.certifiedSelected4 = false;
            obj.getItems5();
            obj.certifiedSelected5 = true;
            obj.getItems6();
            obj.certifiedSelected5 = false;
            obj.getItems6();
            obj.certifiedSelected6 = true;
            obj.getItems7();
            obj.certifiedSelected6 = false;
            obj.getItems7();
            obj.certifiedSelected7 = true;
            obj.getItems8();
            obj.certifiedSelected7 = false;
            obj.getItems8();
            obj.certifiedSelected8 = true;
            obj.getItems9();
            obj.certifiedSelected8 = false;
            obj.getItems9();
            obj.certifiedSelected9 = true;
            obj.getItems10();
            obj.certifiedSelected9 = false;
            obj.getItems10();
            
          //  obj.getLocCode();
            obj.getFirstPicklistValues();
            obj.getSecondPicklistValues();
            obj.getThirdPicklistValues();
            obj.getfourthPicklistValues();
            obj.getfifthPicklistValues();
            obj.getsixthPicklistValues();
            obj.getseventhPicklistValues();
            obj.geteigthPicklistValues();
            obj.getninenthPicklistValues();
            obj.getnitenthPicklistValues();
             //obj.setSelectedSubStatus('kkkk');

           // obj.redirectPopup();
            obj.getstrUsers2();
            obj.setstrUsers2(u.id);
            obj.getstrUsers3();
            obj.setstrUsers3(u.id);
            obj.getstrUsers4();
            obj.setstrUsers4(u.id);
            obj.getstrUsers5();
            obj.setstrUsers5(u.id);
            obj.getstrUsers6();
            obj.setstrUsers6(u.id);
            obj.getstrUsers7();
            obj.setstrUsers7(u.id);
            obj.getstrUsers8();
            obj.setstrUsers8(u.id);
            obj.getstrUsers9();
            obj.setstrUsers9(u.id);
            obj.getstrUsers10();
            obj.setstrUsers10(u.id);  
           // obj.setSelectedSubStatus('kkk');
            obj.getDropDownValueThird();
            obj.getDropDownValueSec();
            obj.getDropDownValue();
            obj.getDropDownValueFour();
            obj.getDropDownValueFifth();
            obj.getDropDownValueSixth();
            obj.getDropDownValueSeventh();
            obj.getDropDownValueEigth();
            obj.getDropDownValueNineth();
            obj.getDropDownValueTenth();
            obj.certUserLIst('ISBE CM800','03520-04892');
            //addTech.getLocCode();
            //accUser.Service_Model_Name__c = 'ISBE CM800';
         /* List<CSS_AccredUser__c> certifiedUserList=  [select User_Login_ID__c,User__r.id,User__r.Name from CSS_AccredUser__c where Service_Model_Name__c =:jo.Service_Model__c and 
Location__c= :u.user_Location__c and User__r.IsActive=: True];*/
            //system.debug('**-->certifiedUserList<--**'+certifiedUserList);
        }
        Test.stopTest();
    }
    
   static testMethod void testMethod1(){
        Test.startTest();  
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '56270-56270',isActive = true);
        insert(u);
        System.runAs(u) {
             Account a = new Account();
            a.Name = '03520-04892';
           // a.Location__c = '56270-56270';
            a.CSS_DistributorCode__c ='03520';
           // a.IAM_Service_Provider_Code__c = '04892';
           // a.IAM_Service_Provider_Code__c = '03520';
             a.Type='Dealer Account';
             a.Region__c = 'US and Canada';
             a.CMI_Account_Status__c = 'Active';
             a.IAM_Service_Provider_Code__c = '04892';
            insert a;
            Account a1 = [select id, Location__c from account ];
            system.debug('a1 '+a1);
             CSS_UserLocation__c userloc = new CSS_UserLocation__c();
            userloc.name= '03520-04892';
            //userloc.location_name__c = '03520-04892';
            userloc.Location_code__c = '03520-04892';
            userloc.isActive__c = true;
            userloc.UserId__c = u.id;
            userloc.AccountId__c = a.id;
            insert userloc;
            CSS_Accreditation__c acc = new CSS_Accreditation__c();
            acc.Service_Model_Name__c = 'ISBE CM800';
            acc.Account__c = a.id;
            insert acc;
            CSS_AccredUser__c accUser = new CSS_AccredUser__c();
            accUser.User_Login_ID__c = 'nt861';
            accUser.User__c = u.id;
            //accUser.Service_Model_Name__c = 'ISBE CM800';
            accUser.Accreditation__c = acc.id;
            //accUser.Location__c = '03520-04892';
            insert accUser;
            CSS_AccredUser__c ca =[select id, Service_Model_Name__c ,Location__c, User__r.IsActive from CSS_AccredUser__c ];
            system.debug('ca '+ca); 
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
                //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
                testclaimsRec.Customer_Name__c='TestCustomer';
                //testclaimsRec.css_job__c = JO.id;
                testclaimsRec.Customer_Code__c = '1234';
                testclaimsRec.Contact_Last_Name__c = 'T';
                testclaimsRec.Address__c = 'T';
                testclaimsRec.Customer_Contact_Phone__c = null;
                testclaimsRec.Email_Address__c = 'rp@sct.com';
                testclaimsRec.Status__c = 'Draft';
                testclaimsRec.TSR1__c = '1234';
                testclaimsRec.TSR2__c = '1234';
                testclaimsRec.TSR3__c = '1234';
                testclaimsRec.TSR4__c = '1234';
                testclaimsRec.TSR5__c = '1234';
                testclaimsRec.TSR6__c = '1234';
                testclaimsRec.TSR7__c = '1234';
                testclaimsRec.TSR8__c = '1234';
                testclaimsRec.TSR9__c = '1234';
                testclaimsRec.TSR10__c = '1234';
                testclaimsRec.Country__c = '1234';
                testclaimsRec.State__c = '1234';
                testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.location_code__c = '03520-04892';
            testclaimsRec.Service_Model__c = 'ISBE CM800';
            testclaimsRec.Assigned_To__c = u.id;
                testclaimsRec.Additional_Tech1__c = u.id;
                testclaimsRec.Additional_Tech2__c = u.id;
                testclaimsRec.Additional_Tech3__c = u.id;
                testclaimsRec.Additional_Tech4__c = u.id;
                testclaimsRec.Additional_Tech5__c = u.id;
                testclaimsRec.Additional_Tech6__c = u.id;
                testclaimsRec.Additional_Tech7__c = u.id;
                testclaimsRec.Additional_Tech8__c = u.id;
                testclaimsRec.Additional_Tech9__c = u.id;
                insert testclaimsRec;
                String grpName = 'CQ'+'-'+'12345-12345';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            
             system.runas(new User(Id=UserInfo.getUserId()))
            { 
            
                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;
       //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        css_job_order__c joorder = css_testdata.createJobOrder(true);
       // testclaimsRec = CSS_TestData.createclaims(true,joorder.Id); 
            //insert testclaimsRec;
            }
            
           
            
        //apexpages.currentPage().getparameters().put('id',testclaimsRec.id);
            Cache.Session.put('ManualClaimsSelectedLocation', '03520-048921111111');
            PageReference pageRef = Page.TIMBASURVEYS__SurveyCollectDataJs;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id',testclaimsRec.Id);
            
            CG_CL_ClaimsServiceProvider obj = new  CG_CL_ClaimsServiceProvider();
            //CSS_Add_Technician addTech = new CSS_Add_Technician();
            obj.getstrUsers1();
            //addTech.getSubStatus();
            obj.setstrUsers1(testclaimsRec.id);
            obj.certifiedSelected = true;
            obj.getItems1();
            obj.certifiedSelected = false;
            //obj.getItems1();
            obj.certifiedSelected1 = true;
            obj.getItems2();
            obj.certifiedSelected1 = false;
            obj.getItems2();
            obj.certifiedSelected2 = true;
            obj.getItems3();
            obj.certifiedSelected2 = false;
            obj.getItems3();
            obj.certifiedSelected3 = true;
            obj.getItems4();
            obj.certifiedSelected3 = false;
            obj.getItems4();
            obj.certifiedSelected4 = true;
            obj.getItems5();
            obj.certifiedSelected4 = false;
            obj.getItems5();
            obj.certifiedSelected5 = true;
            obj.getItems6();
            obj.certifiedSelected5 = false;
            obj.getItems6();
            obj.certifiedSelected6 = true;
            obj.getItems7();
            obj.certifiedSelected6 = false;
            obj.getItems7();
            obj.certifiedSelected7 = true;
            obj.getItems8();
            obj.certifiedSelected7 = false;
            obj.getItems8();
            obj.certifiedSelected8 = true;
            obj.getItems9();
            obj.certifiedSelected8 = false;
            obj.getItems9();
            obj.certifiedSelected9 = true;
            obj.getItems10();
            obj.certifiedSelected9 = false;
            obj.getItems10();
          //  obj.getLocCode();
            obj.getFirstPicklistValues();
            obj.getSecondPicklistValues();
            obj.getThirdPicklistValues();
            obj.getfourthPicklistValues();
            obj.getfifthPicklistValues();
            obj.getsixthPicklistValues();
            obj.getseventhPicklistValues();
            obj.geteigthPicklistValues();
            obj.getninenthPicklistValues();
            obj.getnitenthPicklistValues();
             //obj.setSelectedSubStatus('kkkk');

           // obj.redirectPopup();
            obj.getstrUsers2();
            obj.setstrUsers2(u.id);
            obj.getstrUsers3();
            obj.setstrUsers3(u.id);
            obj.getstrUsers4();
            obj.setstrUsers4(u.id);
            obj.getstrUsers5();
            obj.setstrUsers5(u.id);
            obj.getstrUsers6();
            obj.setstrUsers6(u.id);
            obj.getstrUsers7();
            obj.setstrUsers7(u.id);
            obj.getstrUsers8();
            obj.setstrUsers8(u.id);
            obj.getstrUsers9();
            obj.setstrUsers9(u.id);
            obj.getstrUsers10();
            obj.setstrUsers10(u.id);  
           // obj.setSelectedSubStatus('kkk');
            obj.getDropDownValueThird();
            obj.getDropDownValueSec();
            obj.getDropDownValue();
            obj.getDropDownValueFour();
            obj.getDropDownValueFifth();
            obj.getDropDownValueSixth();
            obj.getDropDownValueSeventh();
            obj.getDropDownValueEigth();
            obj.getDropDownValueNineth();
            obj.getDropDownValueTenth();
            obj.certUserLIst('ISBE CM800','03520-04892');
            //addTech.getLocCode();
            //accUser.Service_Model_Name__c = 'ISBE CM800';
         /* List<CSS_AccredUser__c> certifiedUserList=  [select User_Login_ID__c,User__r.id,User__r.Name from CSS_AccredUser__c where Service_Model_Name__c =:jo.Service_Model__c and 
Location__c= :u.user_Location__c and User__r.IsActive=: True];*/
            //system.debug('**-->certifiedUserList<--**'+certifiedUserList);
        }
        Test.stopTest();
    }
}