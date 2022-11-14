/**********************************************************************
Name:FSL_MovexServiceTerritory
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used to update the Service territory with location code , 
code, code value and code description when user login first time.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         3/12/2019  
2.0 	Rajashekar Nallapati		10/06/2020
		Modification : updating code to support Mule Connection
		User Story : https://cumminsit.atlassian.net/browse/CT2-232
***********************************************************************/
public class FSL_MovexServiceTerritory {
    public List<FSL_MovexServiceTerritoryWrapper> getServiceTerritoryResponse() {
        List<FSL_MovexServiceTerritoryWrapper > fslCDSResps = new list<FSL_MovexServiceTerritoryWrapper>();
        HttpRequest req;
        HttpResponse res;
        String strLocationCode;
        String tokenStr;
        Http h = new Http();
        try
        {
            User objUser = [SELECT Id, User_Location__c FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
            strLocationCode = objUser.User_Location__c;
            ServiceTerritory objST = [SELECT Id, Location_Code__c FROM ServiceTerritory WHERE Location_Code__c =:strLocationCode LIMIT 1];
            String locationCode = objST.Location_Code__c.substring(0,11);
            String endPoint;
            Integer timeout;
            String method;
            DateTime startTime = System.Now();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()) {
                conDetails = CSS_getConnnectionDetails.getConnection('GetMoveXLOV');
                endPoint =  conDetails.End_Point__c;
                //Rajashekar ; 10/06/2020 ; Request method updating to POST to GET
                //End Point URL : https://api-ue-stgnf-aw-ex.cummins.com/services-workorders/workorder/subtype?
                //				  ServiceName=GetSubTypeUnitType&SenderID=CSS&TargetID=BMS&LocationID=56270-56255
                endPoint = endPoint+'?ServiceName=GetSubTypeUnitType&SenderID=CSS&TargetID=MOVEX&LocationID='+locationCode;
                timeout =   Integer.valueOf(conDetails.Timeout__c);
                method =    conDetails.Method_Type__c;
            }
            
            
            /* JSONGenerator gen=JSON.createGenerator(true);
            gen.writeStartObject(); //It is used for making starting object(‘{‘)
            gen.writeFieldName('Header');//Here it is used for making name ,value pair
            gen.writeStartObject();
            gen.writeFieldName('Sender');
            gen.writeStartObject();
            gen.writeStringField('ServiceName','GetMoveXLOV');
            gen.writeStringField('SenderID','CSS');
            gen.writeEndObject();//It is used for making end of object(‘}’)
            gen.writeFieldName('Target');
            gen.writeStartObject();
            gen.writeStringField('TargetID','MOVEX');
            gen.writeEndObject();
            gen.writeFieldName('Location');
            gen.writeStartObject();
            gen.writeStringField('LocationID',locationCode);
            gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
            String jsonString = gen.getAsString();
           
            
            req = new HttpRequest();
            req.setMethod('POST');
            req.setTimeout(100000);
           // req.setBody(jsonString);
            CSS_Integration_Details__c movexLOV;
            if(!Test.isRunningTest()) {
                movexLOV = CSS_Integration_Details__c.getInstance('FSL_MoveXLOV');
                req.setEndpoint(movexLOV.End_Point__c);
            }
            else {
                req.setEndpoint('https://services-dev.cummins.com/csswarranty/bmssubtype');
            }*/
			 CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('FSL_MoveXLOV',endPoint, method, '', timeout);
             CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper); 
             res = outputWrapper.response;
           /* tokenStr = FSL_WS_OAG.getAccessToken();
            String authorizationHeader = 'Bearer '+tokenStr;
            req.setHeader('Authorization', authorizationHeader);      
            system.debug('reqreqreq:::'+req);*/
            
            String responseBody;
            if(!Test.isRunningTest()) {
                responseBody = res.getBody();
            }
            else {
                responseBody =
                    '[{"DataArea":[{"CodeDescription":"CASH SALES SERVICE - BRISBANE","CodeValue":"130SERV","Code":"Cash Sale Customer"},{"CodeDescription":"CASH SALES SERVICE - BRISBANE","CodeValue":"130SERV","Code":"Cash Sale Customer"}],"Header":{"Sender":{"ServiceName":"GetMoveXLOV","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Request processed successfully","Location":{"LocationID":"05340-05351"}}}]';
            }
            responseBody = '[' + responseBody + ']'; 
            fslCDSResps = (List<FSL_MovexServiceTerritoryWrapper>)JSON.deserialize(responseBody, List<FSL_MovexServiceTerritoryWrapper>.Class);
            return fslCDSResps;
        }
        catch(System.Exception e)
        {
            system.debug('catch'+e);
            return null;          
        }
    }
}