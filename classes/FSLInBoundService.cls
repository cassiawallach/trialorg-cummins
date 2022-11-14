/**********************************************************************
Name: FSLInBoundService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is a Unit inbound service class this is class is used to send the updated work order to Movex 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/28/2019    
1.1     Sunitha Mattaparthi	       1/8/2021       Individual Item Number field as Blank for CMI Assets
***********************************************************************/
public class FSLInBoundService {
    
    public static String Sender = 'CSS';
    public static String TargetERP;
    
    public static CallOutResponseWrap sendJsonRequest(String strWorkOrderId,String accCode, String conId, String stId) {
        string endPoint;
        Integer timeout;
        String method;
        DateTime startTime = System.Now();
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
//        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
/*        if(!Test.isRunningTest()) {
            conDetails = CSS_getConnnectionDetails.getConnection('FSL_InBoundServiceRequest');
            endPoint = conDetails.End_Point__c;
            timeout = Integer.valueOf(conDetails.Timeout__c);
            method = conDetails.Method_Type__c;
        }
        else {
            endPoint = 'https://services-dev.cummins.com/css/bmsunit'; timeout = 120000; method = 'PUT';
            
        }*/
        //CT2-416 : Repair_Site_Name__r.FSL_MoveX_Site_Id__c replaced by Repair_Site_Address__r.FSL_Site_ID__c
        WorkOrder objWorkOrder = [SELECT Id, WorkOrderNumber, Asset.Name, Asset.Unit_Number__c, Asset.Make__c, Asset.Model__c, Asset.Registration__c, 
                                  Asset.Access_Code__c, Asset.VIN__c, Asset.Service_Model__c, Asset.Application_Code__c,Asset.Equipment_Configuration__c,Asset.Individual__c, Repair_Site_Address__r.FSL_Site_ID__c, 
                                  Account.FSL_ERP_Customer_Code__c, Contact.FSL_Contact_Id__c, ServiceTerritory.Location_Code__c, Application__c, 
                                  Fuel_Burn__c, Warranty_Start_Date__c, CSS_Hours__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, Asset.Engine_Family_Code__c, Asset.Engine_Manufacturer__c
                                  FROM WorkOrder WHERE id=:strWorkOrderId LIMIT 1];
        system.debug('workorder--->'+objWorkOrder);
        system.debug('WorkOrderAccCode--->'+accCode);
        
        // Added by Ravi Teja
        User usr = new User();
        usr = [SELECT Id, ERP__c
               FROM User
               WHERE Id=:UserInfo.getUserId() LIMIT 1];
        String TargetERP;
        TargetERP = (String)usr.ERP__c;
        String woNumber;
        String SourceType= System.Label.FSL_Source_Environment_Type;
        if(SourceType == 'GZEVLPRD') {
            woNumber = objWorkOrder.WorkOrderNumber;
        } else {
            woNumber = SourceType.right(3)+'-'+objWorkOrder.WorkOrderNumber;
        }
        String position = objWorkOrder.ServiceTerritory.Location_Code__c;
        String subString = position.substringBefore('-');
        String subString2 = position.substringAfter('-').substring(0,5);
        Datetime warrantyDate = objWorkOrder.Warranty_Start_Date__c;
        Datetime failDate = objWorkOrder.Failure_Date__c;
        String warrStartDate;
        String failureDate;
        String erpVIN = objWorkOrder.Asset.VIN__c;
        String asstVIN;
      //  String distanceType = String.valueOf(objWorkOrder.Mileage_Measure__c);
        if(TargetERP == 'BMS') {
            position = subString + '-' + subString2;
          /*  if(distanceType != null) {
                distanceType = String.valueOf(objWorkOrder.Mileage_Measure__c).toUpperCase();
            }*/
            if(erpVIN == '' || erpVIN == null) {
                asstVIN = 'N/A';
            } else{
                asstVIN = erpVIN;
            }
            if(warrantyDate != null) {
                warrStartDate = warrantyDate.format('dd-MMM-yyyy','GMT');
            } else {
                warrStartDate = '';
            }
            if(failDate != null) {
                failureDate = failDate.format('dd-MMM-yyyy','GMT'); }
            else {
                failureDate = '';
            }
        } else {
            warrStartDate = String.valueOf(warrantyDate);
            failureDate = String.valueOf(failDate);
            asstVIN = erpVIN;
            //distanceType = String.valueOf(objWorkOrder.Mileage_Measure__c);
        }
        
//Generating JSON request
        JSONGenerator gen=JSON.createGenerator(true);
        gen.writeStartObject(); //It is used for making starting object(‘{‘)
        gen.writeFieldName('Header');//Here it is used for making name ,value pair
        gen.writeStartObject();
        gen.writeFieldName('Sender');
        gen.writeStartObject();
        gen.writeStringField('ServiceName','GetUnitInfo');
        gen.writeStringField('SenderID','CSS');
        gen.writeEndObject();//It is used for making end of object(‘}’)
        gen.writeFieldName('Target');
        gen.writeStartObject();
        // Added to make the TargetID dynamic - Ravi Teja
        if(TargetERP == null || TargetERP == '') {
            gen.writeStringField('TargetID','');
        } else {
            gen.writeStringField('TargetID',TargetERP);
        }
        gen.writeEndObject();
        gen.writeFieldName('Location');
        gen.writeStartObject();
        if(objWorkOrder.ServiceTerritory.Location_Code__c == null || objWorkOrder.ServiceTerritory.Location_Code__c == '') {
            gen.writeStringField('LocationID','');
        } else {
            gen.writeStringField('LocationID',position);
        }
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeFieldName('DataArea');
        gen.writeStartObject();
        if(accCode == null || accCode == '') {
            gen.writeStringField('CustomerCode','');
        } else {
            gen.writeStringField('CustomerCode',accCode);
        }
        if(objWorkOrder.Asset.Unit_Number__c == null || objWorkOrder.Asset.Unit_Number__c == '') {
            gen.writeStringField('UnitNumber','');
        } else {
            gen.writeStringField('UnitNumber',objWorkOrder.Asset.Unit_Number__c);
        }
        if(objWorkOrder.Asset.Equipment_Configuration__c == null || objWorkOrder.Asset.Equipment_Configuration__c == '') {
            gen.writeStringField('UnitType','');
        } else {
            gen.writeStringField('UnitType', objWorkOrder.Asset.Equipment_Configuration__c);
        }
        if(objWorkOrder.Asset.Model__c == null || objWorkOrder.Asset.Model__c == '') {
            gen.writeStringField('Model','');
        } else {
            gen.writeStringField('Model',objWorkOrder.Asset.Model__c);
        }
        if(asstVIN == null || asstVIN == '') {
            gen.writeStringField('VIN','');
        } else {
            gen.writeStringField('VIN',asstVIN);        
        }
        if(objWorkOrder.Asset.Make__c == null || objWorkOrder.Asset.Make__c == '') {
            gen.writeStringField('Make','');
        } else {
            gen.writeStringField('Make',objWorkOrder.Asset.Make__c);
        }
        if(objWorkOrder.Asset.Service_Model__c == null || objWorkOrder.Asset.Service_Model__c == '') {
            gen.writeStringField('ServiceModelName','');
        } else {
            gen.writeStringField('ServiceModelName',objWorkOrder.Asset.Service_Model__c);
        }
        if(objWorkOrder.Asset.Name == null || objWorkOrder.Asset.Name == '') {
            gen.writeStringField('ESN','');
        } else {
            gen.writeStringField('ESN',objWorkOrder.Asset.Name);
        }
        if(objWorkOrder.Asset.Engine_Family_Code__c == null || objWorkOrder.Asset.Engine_Family_Code__c == '') {
            gen.writeStringField('EngineFamily','');
        } else {
            gen.writeStringField('EngineFamily',objWorkOrder.Asset.Engine_Family_Code__c);
        }
        if(objWorkOrder.Application__c == null || objWorkOrder.Application__c == '') {
            gen.writeStringField('ApplicationCode','');
        } else {
            gen.writeStringField('ApplicationCode',objWorkOrder.Application__c.left(3));
        }
        if(String.valueOf(objWorkOrder.Mileage_Measure__c) == null || String.valueOf(objWorkOrder.Mileage_Measure__c) == '') {
            gen.writeStringField('DistanceType','');
        } else {
            gen.writeStringField('DistanceType',String.valueOf(objWorkOrder.Mileage_Measure__c).toUpperCase());
        }
        if(String.valueOf(objWorkOrder.Mileage__c) == null || String.valueOf(objWorkOrder.Mileage__c) == '') {
            gen.writeStringField('Distance','');
        } else {
            gen.writeStringField('Distance',String.valueOf(objWorkOrder.Mileage__c));
        }
        
        if(String.valueOf(objWorkOrder.CSS_Hours__c) == null || String.valueOf(objWorkOrder.CSS_Hours__c) == '') {
            gen.writeStringField('Hours','');
        } else {
            gen.writeStringField('Hours',String.valueOf(objWorkOrder.CSS_Hours__c));
        }
        if(String.valueOf(objWorkOrder.Failure_Date__c) == null || String.valueOf(objWorkOrder.Failure_Date__c) == '') {
            gen.writeStringField('FailureDate','');
        } else {
            gen.writeStringField('FailureDate',failureDate);
        }
        if(String.valueOf(objWorkOrder.Warranty_Start_Date__c) == null || String.valueOf(objWorkOrder.Warranty_Start_Date__c) == '') {
            gen.writeStringField('WarrantyStartDate','');
        } else {
            gen.writeStringField('WarrantyStartDate',warrStartDate);
        }
        if(objWorkOrder.Asset.Access_Code__c == null || objWorkOrder.Asset.Access_Code__c == '') {
            gen.writeStringField('AccessCode','');
        } else {
            gen.writeStringField('AccessCode',objWorkOrder.Asset.Access_Code__c);
        }
        if(objWorkOrder.Asset.Registration__c == null || objWorkOrder.Asset.Registration__c == '') {
            gen.writeStringField('Registration','');
        } else {
            gen.writeStringField('Registration',objWorkOrder.Asset.Registration__c);
        }
        if(String.valueOf(objWorkOrder.Fuel_Burn__c) == null || String.valueOf(objWorkOrder.Fuel_Burn__c) == '') {
            gen.writeStringField('FuelBurn','');
        } else {
            gen.writeStringField('FuelBurn',String.valueOf(objWorkOrder.Fuel_Burn__c));
        }
        if(stId == null || stId == '') {
            gen.writeStringField('SiteID','0');
        } else {
            gen.writeStringField('SiteID',stId);
        }
        if(conId == null || conId == '') {
            gen.writeStringField('ContactID','');
        } else {
            gen.writeStringField('ContactID',conId);
        }
        gen.writeStringField('CSSJobID',woNumber); 
        //if(objWorkOrder.Asset.Individual__c == null || objWorkOrder.Asset.Individual__c == '')
        //CT3-262
        if(objWorkOrder.Asset.Individual__c == null || objWorkOrder.Asset.Individual__c == '' || objWorkOrder.Asset.Engine_Manufacturer__c == 'CUMMINS') {
             gen.writeStringField('IndividualItemNumber','');
        } else {
            gen.writeStringField('IndividualItemNumber',objWorkOrder.Asset.Individual__c);
        }
        
         if(objWorkOrder.Asset.Engine_Manufacturer__c == null || objWorkOrder.Asset.Engine_Manufacturer__c == '') {
            gen.writeStringField('EngineManufacturer','');
        } else {
            gen.writeStringField('EngineManufacturer',objWorkOrder.Asset.Engine_Manufacturer__c);
        }
        system.debug('AssetID:'+objWorkOrder.AssetId);
        system.debug('MileageValue:'+objWorkOrder.Mileage__c);

        gen.writeEndObject();
        gen.writeEndObject();
        
        String jsonString = gen.getAsString();
        System.debug('jsonString:'+jsonString);
        
        //commented below lines to use the mule version of calling mechanism -by vinod 8/31
        /*HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setHeader('Content-Type', 'application/json');
        String authorizationHeader = 'Bearer '+getToken();
        req.setHeader('Authorization', authorizationHeader);
        req.setEndpoint(endPoint );
        req.setMethod('PUT');
        req.setTimeout(100000);
        req.setBody(jsonString);
        res = http.send(req);*/ //Sending the Request in JSON format
/*        //changed method signature to make use of newer mule & return type. - mule4 changes 8/31 by vinod
        CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('FSL_InBoundServiceRequest',endPoint, method, jsonString, timeout);
        CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        HttpResponse res = outputWrapper.response;//Ends mule changes
        system.debug('Response - '+res); 
        system.debug('Response - '+res.getBody());*/
        
        //Code for named Credentials
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        system.debug('jsonString**'+jsonString);
		reqWrapper.jsonReqBody = jsonString.replace('null','""');
		//reqWrapper.jsonReqBody = jsonString;
		reqWrapper.methodType = 'POST';
	    reqWrapper.NamedCredential = 'FSL_NC_Engine';
	    reqWrapper.Path = '/unit';
	    reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
		reqWrapper.WorkOrder = strWorkOrderId;
        CG_OP_OAGWrapper returnWrapper;
        //HttpResponse res;
        
        if(jsonString != null){
        	returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
            system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            //res = returnWrapper.response;
        }       
        
        string response;
        response = returnWrapper.response.getbody();
        string returnval;
        String indvItem;
        if(response.contains('"Status":')||test.isRunningTest())
        {          
            JSONParser parser = JSON.createParser(response);  
            while (parser.nextToken() != null)
            {        
                if(parser.getText() == 'Status') 
                {                
                    parser.nextToken();  
                    retWrap.status = (parser.getText());
                    returnval = (parser.getText());  
                }
            } 
        }
        
        if(response.contains('"IndividualItemNumber":'))
        {
            JSONParser parser = JSON.createParser(response);
            while (parser.nextToken() != null)
            {
                if(parser.getText() == 'IndividualItemNumber')
                {
                    parser.nextToken();
                    indvItem = String.valueOf((parser.getText()));
                    //returnval = indvItem;
                    //System.debug('recordId = '+token);
                }
            } 
        }
        if((response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL')) || test.isRunningTest())
        {          
            JSONParser parser = JSON.createParser(response);  
            while (parser.nextToken() != null)
            {        
                if(parser.getText() == 'ReturnCodeDescription')  
                {               
                    parser.nextToken(); 
                    returnval = (parser.getText()); 
                    retWrap.msg = (parser.getText());
                } 
            } 
        } 
        
        System.debug('entered into FSLInBoundService  error and printing response:'+retWrap);
        System.debug('before int logging:'+retWrap.status);
        if(retWrap != null && (retWrap.status == 'ERROR' || retWrap.status == 'FAIL') && !Test.isRunningTest()) {
            System.debug('inside int logging:'+retWrap.status);
                FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonString,String.valueOf(retWrap),'FSL_InBoundServiceRequest','Error',String.valueOf(TargetERP),'toolId','CSS');
                System.debug(' FSLInBoundService logged integration log:'); 
            } 
        Asset ast = new Asset();
        ast.Individual__c = indvItem;
        retWrap.asstObj = ast;
        retWrap.asstObj.Id = objWorkOrder.Asset.Id;
        
        system.debug('retWrap>>>:'+retWrap);
        system.debug('retWrap>>>:'+retWrap.asstObj.id);
        // system.debug('IndividualItemNumber:'+ast.Individual__c);
        // added by Ravikanth
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'GetUnitInfo',res.getStatus(),'code','Guidanz',Sender,strWorkOrderId,TargetERP));
        return retWrap;
    }
    
    public class CallOutResponseWrap {
        Public Asset asstObj;
        Public string status;
        Public string msg;
        Public string IndividualItemNumber;
    }
}