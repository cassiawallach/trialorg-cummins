@istest
private class CG_CL_PSNTriggerHandler_Test 
{
    static testmethod void Testingfunction()
    {
        test.startTest();
        //Creating claims object because to create psn object claims is a required field
        /*CSS_Claims__c cl=new CSS_Claims__c();
        insert cl;
        
        //Create a psn record
        css_psn__c psnobj=new css_psn__c();
        psnobj.CoverageFlag__c=false;
        psnobj.PSN__c='79464646';
        psnobj.CSS_Claims__c=cl.id;
        insert psnobj;*/
         Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
             User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US',  ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = 'location');
            insert u;
                  
    system.runas(u){  
        CSS_TestData.createAccountLanguage(true);
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
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
     		insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec;
        
        CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
        testpsnNewRec1.psn__c = '79464646';
        testpsnNewRec1.Primary__C = true;
        testpsnNewRec1.failure_Date__c = date.today() - 21;
        testpsnNewRec1.css_claims__C = testclaimsRec.id;
        insert testpsnNewRec1;
        
        List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
        lstNewPsn.add(testpsnNewRec1);
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.css_claims__c = testclaimsRec.id;
            solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
            solcomp.Multiple_Times__c=true;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
            solComptrp.Component_Id__c ='F0051000';
            solComptrp.css_claims__c = testclaimsRec.id;
        solComptrp.Type__c = 'TRP';
        solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        solComptrp.CampaignPartsPercentage__c = '10';
        solcomptrp.Performed_Review__c = True;
        solcomptrp.Status__c='Approved';
        solcomptrp.Complete_Indicator__c=true; 
            solcomptrp.Multiple_Times__c=true;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
            solCompatc.Component_Id__c ='F0051000';
            solCompatc.css_claims__c = testclaimsRec.id;
        solCompatc.Type__c = 'ATC';
        solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        solCompatc.CampaignPartsPercentage__c = '10';
        solcompatc.Performed_Review__c = True;
        solcompatc.Status__c='Approved';
        solcompatc.Complete_Indicator__c=true; 
            solcompatc.Multiple_Times__c=true;
        insert solCompatc;
        system.debug('Solution Component:'+solCompatc);
        
        CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
        ctt.Type__c = 'ATC';
        ctt.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt.Doc_Num__c = 'ATCF0051000';
            ctt.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt.Performed__c = false;
            ctt.Performed_Review__c = true;
        ctt.Reviewed__c = false;
        ctt.css_claims__c = testclaimsRec.id;
            ctt.ESN__c = '79464646';
        ctt.cu_language__C = 'fr';
        insert ctt;
        
        /*User u3 = css_utility.getUserAttributes(userinfo.getUserId()); 
        CSS_accountLanguage__c aLan = css_utility.getLanguage(u3.LanguageLocaleKey);*/
        CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
                    // jobEventRef.Attribute1__c ='AccountCodes';
                         jobEventRef.Attribute2__c='TestAtt1';
                         jobEventRef.Attribute3__c='English';
                         jobEventRef.Key__c='79464646';
                         jobEventRef.Name='QSOL';
                     insert  jobEventRef;
        
         CSS_JobEventTemporary__c  jobEventRef1 = CSS_TestData.createJobEventTempObj(false);
                    // jobEventRef.Attribute1__c ='AccountCodes';
                         jobEventRef1.Attribute2__c='TestAtt1';
                         jobEventRef1.Attribute3__c='65';
                         jobEventRef1.Key__c='AccountCodes';
                         jobEventRef1.Reason__c='[{"PAYCODEDESCRIPTION":"Info Only","PAYCODE":"A"},{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
                     insert  jobEventRef1;
    
        
        list<css_psn__c>oldpsnlist =[select CoverageFlag__c,PSN__c from css_psn__c];
        system.debug('CFL--------------->Before trigger firing:'+oldpsnlist[0].CoverageFlag__c);//This will return false
        
        //Change the PSN number and update the record
        testpsnNewRec.PSN__c='79454545';
        update testpsnNewRec;//Note Trigger will fire here.
       
        list<css_psn__c>newpsnlist =[select CoverageFlag__c,PSN__c from css_psn__c];
        system.debug('CFL--------------->After trigger firing:'+newpsnlist[0].CoverageFlag__c);//This should return true as we have updated psn number
       
        //Asserting
        //system.assertEquals(newpsnlist[0].CoverageFlag__c, true);
        //cg_cl_psntriggerhandler psnhandler = new cg_cl_psntriggerhandler();
        Map<id,CSS_PSN__c> oldMap = new Map<id,CSS_PSN__c>();
        oldMap.put(testpsnNewRec.id,testpsnNewRec);
        oldMap.put(testpsnNewRec1.id,testpsnNewRec);
        cg_cl_psntriggerhandler.AfterInsert(lstNewPsn);
        cg_cl_psntriggerhandler.AfterUpdate(lstNewPsn,oldMap);
    }
        test.stopTest();        
    }
}