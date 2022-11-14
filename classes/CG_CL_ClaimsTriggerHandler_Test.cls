@istest
public class CG_CL_ClaimsTriggerHandler_Test 
{
    static testmethod void Testingfunction()
    {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];   
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        System.debug('<--Profile-->'+p);
        
        User u = new User(Alias = 'desh', Email='deshpande@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testinnng111', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='deshpandecummins@cummins.com',User_Location__c='03520-04892',isActive=true);
        insert u;
        
        
        User u1 = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testinnnng', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US',  ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '03520-04892',isActive=true);
        insert u1;
        System.debug('<--User-->'+u1);
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
         String grpName1 = 'CQ'+'-'+'12845-12345';
        Group testQue1 = new Group(Name=grpName1, type='Queue');
        insert testQue1;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;  
            QueuesObject q1 = new QueueSObject(QueueID = testQue1.id, SobjectType = 'CSS_Claims__c');
            insert q1;
            list<CSS_Claims__c> listclaims = new list<CSS_Claims__c>();
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.ZipCode__c = '12345-1234';
          //  testclaimsRec.Location_Code__c = 'Test';
            testclaimsRec.OwnerId = u.id;
            listclaims.add(testclaimsRec);
            try{
                 insert listclaims;
            }catch(Exception e){
                system.debug('error '+e.getLineNumber()+''+e.getMessage());
            }
           
            //list<CSS_Claims__c> listclaims = new list<CSS_Claims__c>();
            CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.Location_Code__c='12845-12345';
            testclaimsRec1.ZipCode__c = '12345-1234';
            //testclaimsRec1.Location_Code__c = 'Test';
            testclaimsRec1.OwnerId = u.id;
            try{
                 insert testclaimsRec1;
            }catch(Exception e){
                system.debug('error '+e.getLineNumber()+''+e.getMessage());
            }
            
            CSS_TestData.createAccountLanguage(true);
            list<CSS_Claims__c> oldclaimlist =[select Location_Code__c from CSS_Claims__c];
            system.debug('CFL--------------->Before trigger firing:'+testclaimsRec.Location_Code__c);//This will return false
            
            //testclaimsRec.Location_Code__c='03520-04892';
            //update listclaims;
            
            list<CSS_Claims__c> newclaimlist =[select Location_Code__c from CSS_Claims__c];
            system.debug('CFL--------------->Before trigger firing:'+testclaimsRec.Location_Code__c);//This will return false
            
            
            List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();	
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Primary__C = true;
            testpsnNewRec.failure_Date__c = date.today() - 20;
            testpsnNewRec.CSS_Claims__c = listclaims[0].id;
            lstNewPsn.add(testpsnNewRec);
            
            try{
                 insert lstNewPsn;
            }catch(Exception e){
                system.debug('error '+e.getLineNumber()+''+e.getMessage());
            }
            /*CSS_PSN__c testpsnNewRec1 = new CSS_PSN__c();
testpsnNewRec1.psn__c = '79464646';
testpsnNewRec1.Primary__C = true;
testpsnNewRec1.failure_Date__c = date.today() - 21;
testpsnNewRec1.CSS_Claims__c = testclaimsRec.id;
insert testpsnNewRec1;


lstNewPsn.add(testpsnNewRec1);*/
            
            //list<css_psn__c>oldpsnlist =[select CoverageFlag__c,PSN__c from css_psn__c];
            //system.debug('CFL--------------->Before trigger firing:'+oldpsnlist[0].CoverageFlag__c);//This will return false
            
            //Change the PSN number and update the record
            //testpsnNewRec.PSN__c='79454545';
            //update testpsnNewRec;//Note Trigger will fire here.
            
            //list<css_psn__c>newpsnlist =[select CoverageFlag__c,PSN__c from css_psn__c];
            //system.debug('CFL--------------->After trigger firing:'+newpsnlist[0].CoverageFlag__c);//This should return true as we have updated psn number
            
            Map<id,CSS_Claims__c> oldMap = new Map<id,CSS_Claims__c>();
            oldMap.put(testclaimsRec.id,testclaimsRec1);
            //CG_CL_ClaimsTriggerHandler.changeOwnerInfo(listclaims);
            CG_CL_ClaimsTriggerHandler.onAfterUpdate(listclaims,oldMap);
            CG_CL_ClaimsTriggerHandler.updateEPRFlag('','','',testpsnNewRec.CSS_Claims__c);
            //CG_CL_ClaimsTriggerHandler.deletingJobHistoryRecord(listclaims);
        }
        //Test.startTest();
        System.runAs(u1)
        {
            
            /*  Group Que1 = new Group();
Que1.Type = 'Queue';
//Que.OwnerId=objUser1.id;
Que1.Name = 'CQ'+'-'+'03520-04892';
insert Que1;
QueueSObject q1 = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=Que1.Id);
insert q1;*/
            
            try{
                CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
                testclaimsRec.Location_Code__c='12345-1234';
                testclaimsRec.OwnerId = u1.id;
                //insert testclaimsRec;
            }
            catch(Exception ex)
            {
                String expectedExceptionThrown =  ex.getMessage();
                //System.AssertEquals(expectedExceptionThrown, true)
            } 
            
        }
        Test.stopTest();
        //}
        
        
    }
    public static testMethod void CG_CL_ClaimsOverview_Testmethod1()
    {
        
        //Create a job
        CSS_Job_Order__c cjo=new CSS_Job_Order__c();
        insert cjo;
        
        //Create a claim with a location and a job
        CSS_Claims__c  testclaimsRec;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;         
            testclaimsRec= new CSS_Claims__c();
            testclaimsRec.location_code__c = 'Test';
            testclaimsRec.CSS_Job__c=cjo.id;
            testclaimsRec.Location_Code__c = 'Test';        
            testclaimsRec.OwnerId = UserInfo.getUserId();
            //insert testclaimsRec;
            list<css_claims__c> iclmlist=[select createddate,Location_Code__c,css_job__r.createddate,LastModifiedDate from CSS_Claims__c];
            
            List<CSS_PSN__c> lstNewPsn = new List<CSS_PSN__c>();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();	
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Primary__C = true;
            testpsnNewRec.failure_Date__c = date.today() - 20;
            testpsnNewRec.CSS_Claims__c = testclaimsRec.id;
            lstNewPsn.add(testpsnNewRec);
            //insert lstNewPsn;
            
            //CreatedDate of the Test Claim
            //system.debug('Claim: Created Date of the claim is: '+iclmlist[0].createddate);
            
            //Claim Created Date to String
            //String cscdt = iclmlist[0].createddate.format();
            //system.debug('Claim: The Claim created date in string is:'+cscdt);
            
            //Call the utility class to get the created date
            string cucdt=css_utility.getFormattedDate(testclaimsRec.CreatedDate); 
            //system.debug('Claim: The Claim created date by utility:'+cscdt);
            
            //Call the utility class to get the formatted date        
            string cumdt=css_utility.getFormattedDate(testclaimsRec.LastModifiedDate); 
            //system.debug('Claim: The Claim modified date by utility:'+cscdt);
            
            //Instantiate the controller class
            CG_CL_ClaimsOverview cow=new CG_CL_ClaimsOverview(); 
            CG_CL_ClaimsIntake clintk = new CG_CL_ClaimsIntake(); 
            cow.mainContr=clintk;//Main Controller Refrence
            
            //GET and SET the claim 
            //cow.claimsRec=iclmlist[0];
            //cow.createdDT=cscdt; 
            cow.modifyDT=cumdt;
            testclaimsRec.Location_Code__c='03742';
            //update testclaimsRec;
            iclmlist=[select createddate,Location_Code__c,css_job__r.createddate,LastModifiedDate from CSS_Claims__c];
            //cow.claimsRec=iclmlist[0];
            system.debug('location code set by component:'+cow.LocationCode);
            //system.debug('location code Fetched:'+iclmlist[0].Location_Code__c);
            //Assert if the claim supplied location is same as the location coming from the component
            //System.assertequals(cow.LocationCode,iclmlist[0].Location_Code__c);
            
        }
    }
    public static testMethod void deletingJobHistoryRecordMethod(){
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];   
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        System.debug('<--Profile-->'+p);
        
        User u = new User(Alias = 'ameya', Email='ameya@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testinnng111', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ameyacummins@testorg.com',User_Location__c='03520-04892',isActive=true);
        insert u;
        
        
        User u1 = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testinnnng', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US',  ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '03520-04892',isActive=true);
        insert u1;
        System.debug('<--User-->'+u1);
        css_job_order__c jo =new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='123';
        jo.ESN__c='58764-58764';
        jo.Territory_Class_Name__c=null;
        insert jo;
        List<CSS_Claims__c> clmslst = new List<CSS_Claims__c>();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
        testclaimsRec.CSS_Job__c = jo.id;
        testclaimsRec.Dealer_Service_Job__c = jo.id;
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
        testclaimsRec.Location_Code__c='12345-1234';
        testclaimsRec.OwnerId = u1.id;
        //insert testclaimsRec;
        
        clmslst.add(testclaimsRec);
        
        CSS_Claims__c testclaims = new CSS_Claims__c();
        testclaims.CSS_Job__c = jo.id;
        testclaims.Dealer_Service_Job__c = jo.id;
        testclaims.Customer_Name__c='TestCustomer';
        testclaims.Customer_Code__c = '1234';
        testclaims.Contact_Last_Name__c = 'T';
        testclaims.Address__c = 'T';
        testclaims.Customer_Contact_Phone__c = null;
        testclaims.Email_Address__c = 'rp@sct.com';
        testclaims.Status__c = 'Draft';
        testclaims.TSR1__c = '1234';
        testclaims.TSR2__c = '1234';
        testclaims.TSR3__c = '1234';
        testclaims.TSR4__c = '1234';
        testclaims.TSR5__c = '1234';
        testclaims.TSR6__c = '1234';
        testclaims.TSR7__c = '1234';
        testclaims.TSR8__c = '1234';
        testclaims.TSR9__c = '1234';
        testclaims.TSR10__c = '1234';
        testclaims.Country__c = '1234';
        testclaims.State__c = '1234';
        testclaims.ZipCode__c = '12345-1234';
        testclaims.Location_Code__c='12345-1234';
        testclaims.OwnerId = u1.id;
        //insert testclaims;
        clmslst.add(testclaims);
        //CG_CL_ClaimsTriggerHandler.changeOwnerInfo(clmslst);
        CG_CL_ClaimsTriggerHandler.deletingJobHistoryRecord(clmslst);
         CG_CL_ClaimsTriggerHandler.creatingJobHistoryRecord(clmslst);
        test.stopTest();
    }
}