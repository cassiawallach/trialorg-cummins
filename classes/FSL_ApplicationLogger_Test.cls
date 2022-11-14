@isTest
public class FSL_ApplicationLogger_Test { 

 static testmethod  void testApplicationLogger1(){
             
      
       test.starttest();
      String strtest = FSL_ApplicationLogger.logStart('test','test1',true);
      test.stoptest();
    }
    static testmethod  void testApplicationLogger2(){
             
      
       test.starttest();
      String strtest = FSL_ApplicationLogger.logMessage('test','test1',true);
      test.stoptest();
    }
    static testmethod  void testApplicationLogger3(){
             
      
       test.starttest();
      String strtest = FSL_ApplicationLogger.logErrorMessage('test','test1',true);
      test.stoptest();
    }
     static testmethod  void testApplicationLogger4(){
             
      
       test.starttest();
      String strtest = FSL_ApplicationLogger.logEnd('test','test1',true);
      test.stoptest();
    }
    
      static testmethod  void testApplicationLogger5(){
             
      
       test.starttest();
        OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
             ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            Asset ast = new Asset();
            ast.Name='79464647';
            ast.Type_PSN__c = 'Engines-79464647';
            insert ast;
            
             Date d = Date.Today();
             WorkOrder SerRec = new WorkORder();
            SerRec.DSID__c='12345';
            //SerRec.ESN__c ='79464647';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Service_Model__c='ESN';
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.Customer_Name__c='Sam Torq';
            SerRec.Warranty_Start_Date__c=d; 
            SerRec.ESN__c = '79464647';
            SerRec.Mileage__c = 12345;
            SerRec.Mileage_measure__c = 'Miles'; 
            SerRec.ServiceTerritoryId = sT.Id;
            SerRec.AssetId = ast.id;
            //SerRec.CSS_Job_Location_Code__c = '03520-04892';
            Insert SerRec;
            
            DateTime dt1 = DateTime.newInstance(2017,2,3,13,20,30);
            DateTime dt2 = DateTime.newInstance(2017,3,3,13,20,30);
            
     FSL_ApplicationLogger.createLog('test',true,dt1 ,dt2 ,SerRec.id);
      test.stoptest();
    }
    
      static testmethod  void testApplicationLoggerfuture(){
             
      
      
        OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
             ServiceTerritory sT= new ServiceTerritory();
            sT.name = 'TEST ST Mobile';
            sT.OperatingHoursId=oh.id;
            sT.Location_Code__c='03250-02851';
            sT.FSL_Service_Territory_Code__c = '02851';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            sT.IsActive=true;
            insert sT;
            
            Asset ast = new Asset();
            ast.Name='79464647';
            ast.Type_PSN__c = 'Engines-79464647';
            insert ast;
            
             Date d = Date.Today();
             WorkOrder SerRec = new WorkORder();
            SerRec.DSID__c='12345';
            //SerRec.ESN__c ='79464647';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Service_Model__c='ESN';
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.Customer_Name__c='Sam Torq';
            SerRec.Warranty_Start_Date__c=d; 
            SerRec.ESN__c = '79464647';
            SerRec.Mileage__c = 12345;
            SerRec.Mileage_measure__c = 'Miles'; 
            SerRec.ServiceTerritoryId = sT.Id;
            SerRec.AssetId = ast.id;
            //SerRec.CSS_Job_Location_Code__c = '03520-04892';
            Insert SerRec;
            
              
            DateTime dt1 = DateTime.newInstance(2017,2,3,13,20,30);
            DateTime dt2 = DateTime.newInstance(2017,3,3,13,20,30);
       test.starttest();      
      FSL_ApplicationLogger.createLogFuture('test',true,dt1,dt2,SerRec.id);
      test.stoptest();
    }
    
    static testmethod void insrtIntegratnErrorlog(){
    test.starttest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_GetServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/GetServiceRequestAPI/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"01/09/2020","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        String JsonRes = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"01/09/2020","Datespan":"4"}}';
       response.responsebody = Blob.valueOf(JsonRes);
        FSL_ApplicationLogger.insertIntegrationErrorLog(request,response,'test','Success','test','test','test');
        test.stoptest();
    }
    
       static testmethod  void insertFSLIntegrationErrorLog(){
       test.starttest();
       FSL_ApplicationLogger.insertFSLIntegrationErrorLog('test','test','servicename','Success','test','test','test');
       test.stoptest();
       
       }

}