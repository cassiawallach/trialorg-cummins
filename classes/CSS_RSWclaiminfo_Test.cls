@isTest(seealldata = False)
public class CSS_RSWclaiminfo_Test {
    static TestMethod void testCallout() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        //Test.setMock(HttpCalloutMock.class,new CSS_MockHttpResponseGenerator_Test());
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.  
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        
        User u = new User(Alias = 'standt1', Email='standarduser31@testorg.com', FirstName = 'testuser1',
                          EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,FederationIdentifier='standarduser3@testorg.com',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser3123@testorg.com', User_Location__c = 'bangalore');
        
        insert u;
        
        id UserId = u.id;
        string  ServiceProviderContact = userinfo.getName(); 
        system.debug('ServiceProviderContact>>>>'+ServiceProviderContact);
        system.debug('UserId>>>>>>:' +UserId);
        system.runas(u){
            CSS_Job_Order__c SerRec =  new CSS_Job_Order__c();
            Date d = Date.Today();
            SerRec.DSID__c='12345';
            
            SerRec.DSID_Status__c='open';
            //SerRec.Creator_Location__c = 'Bangalore';
            SerRec.Shop_Work_Order__c = 'M234';
            SerRec.Category__c = 'Component / Part Specific Issue';
            SerRec.Complaint_Type__c = 'BELT PROBLEM';
            SerRec.ESN__c ='79464647';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d+10;
            SerRec.Failure_Point__c=2.2;
            SerRec.Unit_Number__c='1234';
            SerRec.Service_Model__c='ESN';
            SerRec.Make__c='VOLVO ';
            SerRec.Model__c='VNL SERIES';
            SerRec.VIN__c='1XKAD49X6CJ305490';
            SerRec.Customer_Name__c='Sam Torq';
            SerRec.Warranty_Start_Date__c=d; 
            serRec.Failure_Point_Measure__c = 'Miles';
            serRec.Failure_Point_Measure__c = 'Kilometers';
            SerRec.Application__c='Automative';
            SerRec.OwnerId = UserId;
            SerRec.Mileage__c=10;
            SerRec.Mileage_Measure__c='Miles';
           
            Insert SerRec;
            
            
            
            //SerRec = [select id , name,Failure_Point__c,Mileage,Mileage_Measure__c,Complaint_Type__c,Category__c,Shop_Work_Order__c,ESN__c,Failure_Date__c,Unit_Number__c,Creator_Location__c,DSID__c,OwnerId,Application__c,Failure_Point_Measure__c,Warranty_Start_Date__c,Customer_Name__c,VIN__c,Model__c,Make__c,Service_Model__c from CSS_Job_Order__c];/* where id =:SerRec.Id].Creator_Location__c;*/
            //system.debug('jo>>>>'+jo);
            system.debug('SerRec.Creator_Location__c>>>>>>>'+SerRec.Creator_Location__c);
            String nameId =[select id,name,Creator_Location__c from CSS_Job_Order__c where id=:SerRec.Id].name;
            system.debug('nameId>>>>'+nameId);
            //String JobId= nameId;
            
            CSS_List_Of_Values__c css = new CSS_List_Of_Values__c();
            css.Name='test'+math.random();
            css.Picklist_Values_1__c= 'Automotive';
            css.Picklist_Values_2__c= 'AUTOMOTIVE';
            //css.Picklist_Values_3__c= 'dfg';
            css.Type__c='Application Code';
            css.Code__c='130';
            Insert css; 
            system.assertNotEquals('x1yz', css.Name);
            system.debug('===CSS=='+css);
            CSS_List_Of_Values__c css1 = new CSS_List_Of_Values__c();
            css1.Name='test'+math.random();
            css1.Picklist_Values_1__c= 'Component / Part Specific Issue';
            css1.Picklist_Values_2__c= 'Alternator';
            css1.Picklist_Values_3__c= 'ALTERNATOR MALFUNCTIONING';
            css1.Type__c='Complaint Codes';
            css1.Code__c='507';
            Insert css1;   
            system.debug('==CSS1=='+css1);
            
            //string scode1=css_utility.getCodes(null,'Leak','SMOKE - Blue',null);
            //string scode2=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator','ALTERNATOR MALFUNCTIONING');
            string scode3=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator',null);
            string scode4=css_utility.getCodes('Application Code','Automotive',null,null);
            //string scode5=css_utility.getCodes('Application Code',null,null,null);
            system.debug('scode3>>>>'+scode3);
            system.debug('scode4>>>>'+scode4);
            System.runAs(u) {
                // The following code runs as user 'u' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
            
             /*CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
             cid.name = 'RSWClaim';
             cid.ApplicationName__c = 'RSWClaim';
             cid.End_Point__c = 'https://services-test.cummins.com/css/claiminformation	';
             cid.logging__c = 'BOTH';
             cid.AuthEnv__c = 'OAGOAuthTest';
             cid.Method_Type__c = 'POST';
             cid.Timeout__c = 120000;
             insert cid;*/
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name='RSWClaim';
            conDetails.IsActive__c=true;
            conDetails.ApplicationName__c='RSWClaim';
            conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/information';
            conDetails.Method_Type__c='POST';
            conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
            conDetails.Passcode__c='xfgYI9ubUYW1DHPjNJc1D46rhF7KFaYTDXTKB7IHweTwtHB2a3pOLEzY9fzjEWfVtHba+M8T7lk6BE5CvumgPA==';
            conDetails.Username__c='4AX7rk2oT4dNFvlO4NkqAhab+2T05ZVujysERwTX+I8ZCVZW5YStPHB8DyYk8G07M8aHo6uYsZeBYRX73F4ciQ==';
            conDetails.AuthEnv__c='MuleAuth';
            conDetails.Timeout__c=120000;
            conDetails.Logging__c='BOTH';        
            insert conDetails;
            
            
            css_utility.getFederationId(UserId);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_RSWClaimInfo_Mock());
            system.debug('SerRec>>>>> '+SerRec);
            CSS_RSWClaimInfo.sendClaimInfoToRSW(SerRec);
            Test.stopTest();
        }
    }
    
    static void testMethod1() {
        //CSS_getConnnectionDetails conndet = new CSS_getConnnectionDetails();
        CSS_getConnnectionDetails.getConnection('OAGOAuth');
    }
    static TestMethod void testCallout1() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        //Test.setMock(HttpCalloutMock.class,new CSS_MockHttpResponseGenerator_Test());
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.  
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        
        User u = new User(Alias = 'standt1', Email='standarduser31@testorg.com', FirstName = 'testuser1',
                          EmailEncodingKey='UTF-8', LastName='Testing11', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id,FederationIdentifier='standarduser3@testorg.com',
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser3123@testorg.com', User_Location__c = 'bangalore');
        
        insert u;
        
        id UserId = u.id;
        string  ServiceProviderContact = userinfo.getName(); 
        system.debug('ServiceProviderContact>>>>'+ServiceProviderContact);
        system.debug('UserId>>>>>>:' +UserId);
        system.runas(u){
            CSS_Job_Order__c SerRec1 =  new CSS_Job_Order__c();
            Date d = Date.Today();
            SerRec1.DSID__c='12345';
            
            SerRec1.DSID_Status__c='open';
            //SerRec.Creator_Location__c = 'Bangalore';
            SerRec1.Shop_Work_Order__c = 'M234';
            SerRec1.Category__c = 'Component / Part Specific Issue';
            SerRec1.Complaint_Type__c = 'BELT PROBLEM';
            SerRec1.ESN__c ='79464647';
            SerRec1.Customer_Name__c='ABC';
            SerRec1.Failure_Date__c =null;
            SerRec1.Failure_Point__c=2.2;
            SerRec1.Unit_Number__c='1234';
            SerRec1.Service_Model__c='ESN';
            SerRec1.Make__c='VOLVO ';
            SerRec1.Model__c='VNL SERIES';
            SerRec1.VIN__c=null;
            SerRec1.Customer_Name__c='Sam Torq';
            SerRec1.Warranty_Start_Date__c=null; 
            serRec1.Failure_Point_Measure__c = 'Miles';
            serRec1.Failure_Point_Measure__c = 'Kilometers';
            SerRec1.Application__c='Automative';
            SerRec1.OwnerId = UserId;
            SerRec1.Mileage__c=10;
            SerRec1.Mileage_Measure__c='Kilometers';
           SerRec1.Application_Desc__c='test';
            //SerRec1.Creator_Location__c='us';
            Insert SerRec1;
            
            
            
            //SerRec = [select id , name,Failure_Point__c,Mileage,Mileage_Measure__c,Complaint_Type__c,Category__c,Shop_Work_Order__c,ESN__c,Failure_Date__c,Unit_Number__c,Creator_Location__c,DSID__c,OwnerId,Application__c,Failure_Point_Measure__c,Warranty_Start_Date__c,Customer_Name__c,VIN__c,Model__c,Make__c,Service_Model__c from CSS_Job_Order__c];/* where id =:SerRec.Id].Creator_Location__c;*/
            //system.debug('jo>>>>'+jo);
            system.debug('SerRec1.Creator_Location__c>>>>>>>'+SerRec1.Creator_Location__c);
            String nameId =[select id,name,Creator_Location__c from CSS_Job_Order__c where id=:SerRec1.Id].name;
            system.debug('nameId>>>>'+nameId);
            //String JobId= nameId;
            
            CSS_List_Of_Values__c css = new CSS_List_Of_Values__c();
            css.Name='test'+math.random();
            css.Picklist_Values_1__c= 'Automotive';
            css.Picklist_Values_2__c= 'AUTOMOTIVE';
            //css.Picklist_Values_3__c= 'dfg';
            css.Type__c='Application Code';
            css.Code__c='130';
            Insert css; 
            system.assertNotEquals('x1yz', css.Name);
            system.debug('===CSS=='+css);
            CSS_List_Of_Values__c css1 = new CSS_List_Of_Values__c();
            css1.Name='test'+math.random();
            css1.Picklist_Values_1__c= 'Component / Part Specific Issue';
            css1.Picklist_Values_2__c= 'Alternator';
            css1.Picklist_Values_3__c= 'ALTERNATOR MALFUNCTIONING';
            css1.Type__c='Complaint Codes';
            css1.Code__c='507';
            Insert css1;   
            system.debug('==CSS1=='+css1);
            
            //string scode1=css_utility.getCodes(null,'Leak','SMOKE - Blue',null);
            //string scode2=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator','ALTERNATOR MALFUNCTIONING');
            string scode3=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator',null);
            string scode4=css_utility.getCodes('Application Code','Automotive',null,null);
            //string scode5=css_utility.getCodes('Application Code',null,null,null);
            system.debug('scode3>>>>'+scode3);
            system.debug('scode4>>>>'+scode4);
            System.runAs(u) {
                // The following code runs as user 'u' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
            }
            
             /*CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
             cid.name = 'RSWClaim';
             cid.ApplicationName__c = 'RSWClaim';
             cid.End_Point__c = 'https://services-test.cummins.com/css/claiminformation	';
             cid.logging__c = 'BOTH';
             cid.AuthEnv__c = 'OAGOAuthTest';
             cid.Method_Type__c = 'POST';
             cid.Timeout__c = 120000;
             insert cid;*/
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name='RSWClaim';
            conDetails.IsActive__c=true;
            conDetails.ApplicationName__c='RSWClaim';
            conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/information';
            conDetails.Method_Type__c='POST';
            conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
            conDetails.Passcode__c='xfgYI9ubUYW1DHPjNJc1D46rhF7KFaYTDXTKB7IHweTwtHB2a3pOLEzY9fzjEWfVtHba+M8T7lk6BE5CvumgPA==';
            conDetails.Username__c='4AX7rk2oT4dNFvlO4NkqAhab+2T05ZVujysERwTX+I8ZCVZW5YStPHB8DyYk8G07M8aHo6uYsZeBYRX73F4ciQ==';
            conDetails.AuthEnv__c='MuleAuth';
            conDetails.Timeout__c=120000;
            conDetails.Logging__c='BOTH';        
            insert conDetails;
            
            
            css_utility.getFederationId(UserId);
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_RSWClaimInfo_Mock());
            system.debug('SerRec>>>>> '+SerRec1);
            CSS_RSWClaimInfo.sendClaimInfoToRSW(SerRec1);
            Test.stopTest();
        }
    }
    
    
    /*static void testMethod2() {
global HTTPResponse respond(HTTPRequest req) {
// Create a fake response
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
res.setBody('{"DataArea":{"ClaimInformation":[{"ServiceProviderCode":"0"}');

}

}*/
    
   
    
    
}