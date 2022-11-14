@isTest(seeAllData=false)
public class CSS_BMSSendParts_Test {
    @testsetup static void testdata()
    {
        CSS_Job_Order__c jobOrder = new css_job_order__c();
        jobOrder.Status__c = 'intake';
        jobOrder.Shop_Work_Order__c='1234';
        jobOrder.Unit_Number__c='12345';
        jobOrder.CSS_Job_Location_Code__c='02957-02957'; 
        insert jobOrder;
        
        
    }
    public static testMethod void testJobOrderData(){
        
        CSS_Job_Order__c jobName = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        string jsonRequestBody = '{'+
            '	\"Header\": {'+
            '		\"Sender\": {'+
            '			\"ServiceName\": \"getBMSParts\",'+
            '			\"SenderID\": \"BMS\"'+
            '		},'+
            '		\"Target\": {'+
            '			\"TargetID\": \"CSS\",'+
            '			\"SourceEnvironment\": \"CGCDWTST\"'+
            '		},'+
            '		\"Location\": {'+
            '			\"LocationID\": \"02400-02394\"'+
            '		}'+
            '	},'+
            '	\"DataArea\": {'+
            '		\"CSSJobId\": \"CSS0087978\",'+
            '		\"DistributorCode\": \"02400\",'+
            '		\"BranchCode\": \"02394\",'+
            '		\"CustomerCode\": \"\",'+
            '		\"OrderType\": \"WO/WOQT\",'+
            '		\"BMSReferenceNumber\": \"98687687\",'+
            '		\"PartDetails\": [{'+
            '				\"PartNumber\": \"876435\",'+
            '				\"PartDescription\": \"\",'+
            '				\"QuantityOrdered\": \"\",'+
            '				\"QuantityUsed\": \"3\",'+
            '				\"PartsReturn\": \"Y\",'+
            '				\"SellPrice\": 345,'+
            '				\"WarrantyAllocation\": 98,'+
            '				\"Comments\": \"\",'+
            '				\"LineType\": \"\",'+
            '				\"SerialNumber\": \"64646\",'+
            '				\"SerialNumberVendor\": \"XYZ\",'+
            '				\"Model\": \"VOLVO\",'+
            '				\"Option\": \"6\",'+
            '				\"ESN\": \"79464646\",'+
            '				\"SSN\": \"765\",'+
            '				\"VIN\": \"54365jhgf98798jhgj\",'+
            '				\"PartOC\": \"PART\",'+
            '				\"TrackingNumber\": \"FN87687688\",'+
            '				\"RID\": \"\",'+
            '				\"Address1\": \"\",'+
            '				\"Address2\": \"\",'+
            '				\"City\": \"\",'+
            '				\"State\": \"\",'+
            '				\"Zip\": \"\",'+
            '				\"CreateUser\": \"WWID\",'+
            '				\"CreateDate\": \"Date\",'+
            '				\"ChangeUser\": \"WWID\",'+
            '				\"ChangeDate\": \"Date\"'+
            '			},'+
            '			{'+
            '				\"PartNumber\": \"876495\",'+
            '				\"PartDescription\": \"\",'+
            '				\"QuantityOrdered\": \"\",'+
            '				\"QuantityUsed\": \"3\",'+
            '				\"PartsReturn\": \"Y\",'+
            '				\"SellPrice\": 345,'+
            '				\"WarrantyAllocation\": 98,'+
            '				\"Comments\": \"\",'+
            '				\"LineType\": \"\",'+
            '				\"SerialNumber\": \"64646\",'+
            '				\"SerialNumberVendor\": \"XYZ\",'+
            '				\"Model\": \"VOLVO\",'+
            '				\"Option\": \"6\",'+
            '				\"ESN\": \"79464646\",'+
            '				\"SSN\": \"765\",'+
            '				\"VIN\": \"54365jhgf98798jhgj\",'+
            '				\"PartOC\": \"PART\",'+
            '				\"TrackingNumber\": \"FN87687688\",'+
            '				\"RID\": \"\",'+
            '				\"Address1\": \"\",'+
            '				\"Address2\": \"\",'+
            '				\"City\": \"\",'+
            '				\"State\": \"\",'+
            '				\"Zip\": \"\",'+
            '				\"CreateUser\": \"WWID\",'+
            '				\"CreateDate\": \"Date\",'+
            '				\"ChangeUser\": \"WWID\",'+
            '				\"ChangeDate\": \"Date\"'+
            '			}'+
            '		]'+
            '	}'+
            '}';
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BMS/V01/CSS/BMSPartsSendToGuidanz/*';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CSS_BMSSendParts.insertBMSPartsData(); 
        Test.stopTest();
    }
    
   
    public static testMethod void testJobOrderData2(){
        string tempSRTID = 'Testing';
        CSS_Job_Order__c jobName = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        CSS_Job_Order__c jobName1 = [SELECT Name,Status__c,Unit_Number__c,CSS_Job_Location_Code__c FROM CSS_Job_Order__c limit 1];
        string sh = jobName1.Name;
        system.assert(string.isNotBlank(sh));
      
        string jsonRequestBody='{ "Header": { "Sender": { "ServiceName": "getBMSParts", "SenderID": "BMS" }, "Target": { "TargetID": "CSS", "SourceEnvironment": "CGCDWTST" }, "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CSSJobId": "'+sh+'", "DistributorCode": "02400", "BranchCode": "02394", "CustomerCode": "123", "OrderType": "WO/WOQT", "BMSReferenceNumber": "98687", "PartDetails": [{ "PartNumber": "876435", "PartDescription": "", "QuantityOrdered": "", "QuantityUsed": "3", "PartsReturn": "Y", "SellPrice": 345, "WarrantyAllocation": 98, "Comments": "", "LineType": "", "SerialNumber": "64646", "SerialNumberVendor": "XYZ", "Model": "VOLVO", "Option": "6", "ESN": "79464646", "SSN": "765", "VIN": "54365jhgf98798jhgj", "PartOC": "PART", "TrackingNumber": "FN87687688", "RID": "", "Address1": "", "Address2": "", "City": "", "State": "", "Zip": "", "CreateUser": "WWID", "CreateDate": "Date", "ChangeUser": "WWID", "ChangeDate": "Date" }, { "PartNumber": "876495", "PartDescription": "", "QuantityOrdered": "", "QuantityUsed": "3", "PartsReturn": "Y", "SellPrice": 345, "WarrantyAllocation": 98, "Comments": "", "LineType": "", "SerialNumber": "64646", "SerialNumberVendor": "XYZ", "Model": "VOLVO", "Option": "6", "ESN": "79464646", "SSN": "765", "VIN": "54365jhgf98798jhgj", "PartOC": "PART", "TrackingNumber": "FN87687688", "RID": "", "Address1": "", "Address2": "", "City": "", "State": "", "Zip": "", "CreateUser": "WWID", "CreateDate": "Date", "ChangeUser": "WWID", "ChangeDate": "Date" } ] } }';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/BMS/V01/CSS/BMSSendpartsToGuidanz/*';  
        req.httpMethod = 'PUT';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CSS_BMSSendParts.insertBMSPartsData(); 
        Test.stopTest();
    }
    
}