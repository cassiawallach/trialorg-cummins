@IsTest
global class FSL_MockTest implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req)
    {
        //System.assertEquals( 'POST', req.getMethod( ) );
        
        HttpResponse res = new HttpResponse( );
        res.setHeader( 'Content-Type', 'application/json');  
        if (req.getEndpoint().toLowerCase().contains('query')) 
        {
            res.setBody('{"size":1,"totalSize":1,"done":true,"queryLocator":null,"entityTypeName":"GlobalValueSet","records":[{"attributes":{"type":"GlobalValueSet","url":"/services/data/v41.0/tooling/sobjects/GlobalValueSet/0Nt7F0000004pyWSPD"},"Id":"0Nt7F0000004pyWSDQ","MasterLabel":"Primary Market"}]}');
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
        if(req.getEndpoint().toLowerCase().contains('getToken'))
        {
            res.setBody('{"apiToken":"09Stk!AR4AQF1zO2i3.KhsoAasxRgviPsRW3uGmJf2rg.dFQSWthcy2TRvVU8uw1Q"}');
            res.setStatus('OK');
            
            return res;
        }
        if(req.getEndpoint().toLowerCase().contains('language=en&documentType=PRO&documentId'))
        {
            res.setBody('{"qsolLink":"09Stk!AR4AQF1zO2i3.KhsoAasxRgviPsRW3uGmJf2rg.dFQSWthcy2TRvVU8uw1Q","language":"en"}');
            res.setStatus('OK');
            
            return res;
        }
        if(req.getEndpoint().toLowerCase().contains('GetToken'))
        {
            res.setBody('{"09Stk!AR4AQF1zO2i3.KhsoAasxRgviPsRW3uGmJf2rg.dFQSWthcy2TRvVU8uw1Q"}');
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            res.setStatusCode(200);
            res.setStatus('OK');
            
            return res;
        }
        
        if(req.getEndpoint().toLowerCase().contains('CustomerCode'))
        {
            res.setBody('{"apiToken":"09Stk!AR4AQF1zO2i3.KhsoAasxRgviPsRW3uGmJf2rg.dFQSWthcy2TRvVU8uw1Q"}');
            res.setStatus('OK');
            
            return res;
        }
        if(req.getEndpoint().toLowerCase().contains('serialNumber&faultCode&Language=en'))
        {
            res.setBody('{"faultCode": "123","pid": "P102","spn": "102","fmi": "4","lamp": "Amber","srt": "","description": "Intake Manifold 1 Pressure Sensor Circuit - Voltage Below Normal or Shorted to Low Source","compLocation": "The intake manifold 1 pressure/temperature sensor is located in the air intake manifold.","circuitDescription": "The engine control module (ECM) provides a 5 volt supply to the intake manifold pressure sensor on the sensor supply circuit. The ECM also provides a ground on the sensor return circuit. The intake manifold pressure sensor provides a signal to the ECM on the intake manifold pressure sensor signal circuit. This sensor signal voltage changes based on the pressure in the intake manifold.","reason": "Intake Manifold 1 Pressure Sensor Circuit - Voltage Below Normal or Shorted to Low Source. Low signal voltage or open circuit detected at the intake manifold pressure circuit.","effect": "Possible reduced engine performance.","sysName": "","url": "https://qs-stg.cummins.com/authenticate?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJRU09MX0lOVEVHUkFUSU9OX0FDQ0VTU19UT0tFTiIsImlzSU5UU0VSVklDRSI6InRydWUiLCJpc3MiOiJJbnRlcm5hbCBJbnRlZ3JhdGlvbiBTZXJ2aWNlcyAtIFFTT0wiLCJmbGVldGNvZGUiOiJUOTk5OTk5IiwiZXhwIjoxNTY1NTQ1MjI2LCJpYXQiOjE1NjU1MDIwMjYsImdyb3VwbmFtZSI6WyJJTlRFR1JBVElPTl9RVUlDS1NFUlZFIl0sInVzZXJuYW1lIjoidGVjX3VzZXIiLCJ0YXJnZXQiOiJodHRwczovL3FzLXN0Zy5jdW1taW5zLmNvbSJ9.PEdxbM_jbDMP9P7ABRYGWi8fqr3VdLNqYB_72QMlXWI_wP76uWaK8bh5EGncmyBtPCRqFJt4aTrd4GpAK_otMyx7ddGFXSJQfBJ4H4KaDQEUKgX2gIT50nmN6PlSLYgVtOqKeD4HGfDBNjiRks3eB1CwfMSzzgtzj_5S3kBpZ1g&target=/integrations/pubsys2/xml/en/procedures/189/189-fc123.html","engine": "189"}');
            res.setStatus('OK');
            
            return res;
        }
        if(req.getEndpoint().contains('serialNumber'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[{"optionNumber": "4352144","repairGroup": "17.02","optionDescription": "Upper Engine Gasket Set"},{"optionNumber": "4955590","repairGroup": "17.02","optionDescription": "Kit,Lower Engine Gasket"},{"optionNumber": "4955594-01","repairGroup": "17.02","optionDescription": "Upper Engine Gasket Set"}]');  
            return res;
        }   
        else 
        {
            res.setBody('{"RESPONSE":"ERROR"}');
            res.setStatusCode(200);
            res.setStatus('OK');
        }
        
        if(req.getEndpoint().contains('gettoken'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"access_token":"XN8PBx2p854LkXBZn78J281ZFLTAhlNO4QY7jqZ34e2Wma6vaKf4jH","token_type":"Bearer","expires_in":1200,"refresh_token":"nqtzIv8U4o2oB5UzJx0yQxuf0kBoTmZR22uOVmqq96E4oY","scope":"CSSCloud"}');
            return res;
        }       
        
        if(req.getEndpoint().contains('getQSOLToken'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"apiToken":"XN8PBx2p854LkXBZn78J281ZFLTAhlNO4QY7jqZ34e2Wma6vaKf4jH","token_type":"Bearer","expires_in":1200,"refresh_token":"nqtzIv8U4o2oB5UzJx0yQxuf0kBoTmZR22uOVmqq96E4oY","scope":"CSSCloud"}');
            return res;
        }
        
        if(req.getEndpoint().contains('csswarranty/csssite'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            // res.setBody('{"DataArea": {"SiteID": 0,"CustomerCode": 2110054,"CSSJobID": ""},"Header": {"Sender": {"ServiceName": "CreateUpdateSite","SenderID": "CSS","MessageID": "a758d7bd-ccfb-4e5e-bb15-c8ccccafd725"},"Status": "Error","Target": {"TargetID": ""},"ReturnCodeDescription": "Name must be entered","Location": {"LocationID": ""}}}');  
            res.setBody('{"DataArea": {"SiteID": 40,"CustomerCode": 2110054,"CSSJobID": ""},"Header": {"Sender": {"ServiceName": "CreateUpdateSite","SenderID": "CSS","MessageID": "a758d7bd-ccfb-4e5e-bb15-c8ccccafd725"},"Status": "Success","Target": {"TargetID": ""},"ReturnCodeDescription": "Site created successfully","Location": {"LocationID": ""}}}');  
            return res;
        } 
        else 
        {
            res.setBody('{"DataArea": {"SiteID": 0,"CustomerCode": 2110054,"CSSJobID": ""},"Header": {"Sender": {"ServiceName": "CreateUpdateSite","SenderID": "CSS","MessageID": "a758d7bd-ccfb-4e5e-bb15-c8ccccafd725"},"Status": "Error","Target": {"TargetID": ""},"ReturnCodeDescription": "Name must be entered","Location": {"LocationID": ""}}}');  
            res.setStatusCode(200);
            res.setStatus('OK');
        }
        
        if(req.getEndpoint().contains('csswarranty/csscontact'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            // res.setBody('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00002863","ContactID": 0},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "7c997f48-27b0-4c1c-aa8b-e1ed3d1b3b50"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Combination of Contact Name, Phone# & Email already exist.","Location": {"LocationID": "05340-73633"}}}');
            
            res.setBody('{"DataArea": {"WOReferenceNumber": 2110054,"CSSJobID": "00003071","ContactID": 160},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "3435e5b7-56fc-4ecd-a78a-ab76f3a64661"},"Status": "SUCCESS","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Contact updated successfully","Location": {"LocationID": "05340-73633"}}}');  
        }
        else 
        {
            res.setBody('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00002863","ContactID": 0},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "7c997f48-27b0-4c1c-aa8b-e1ed3d1b3b50"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Combination of Contact Name, Phone# & Email already exist.","Location": {"LocationID": "05340-73633"}}}');
            res.setStatusCode(200);
            res.setStatus('OK');
        }
        
        if(req.getEndpoint().contains('css/bmsunit'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea": {"ESN": 79963830,"UnitNumber": "1234","ServiceModelName": "ISL9 CM2350 L101"},"Header": {"Sender": {"ServiceName": "GetUnitInfo","SenderID": "CSS","MessageID": "7ce2217e-1bb8-4f19-b6b0-373276e6a6d5"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Model must be entered","Location": {"LocationID": "05340-73633"}}}');  
            
            // res.setBody('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00003071","ContactID": 160},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "3435e5b7-56fc-4ecd-a78a-ab76f3a64661"},"Status": "SUCCESS","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Contact updated successfully","Location": {"LocationID": "05340-73633"}}}');  
            return res;
            
        }
        
        if(req.getEndpoint().contains('css/bmscustomer'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea": {"CustomerCode": "211054","CSSJobID": "00002607"},"Header": {"Status": "SUCCESS","ReturnCodeDescription": "Customer details updated successfully"}}');  
        } 
        if(req.getEndpoint().contains('getServiceHistory'))
        {
            //Create a fake response            
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":[{"WorkSummaryCOMPLAINT": "","ClaimNumber": "","Invoice": 1978660,"BMSWOreference": 5189878,"DistanceType": "KILOMETERS","FaultcodesCORRECTION": "","UnitHours": "","WorkSummaryCAUSE": "Injector missfire","ReceivedDate": "2004-10-27T00:00:00.000-00:00","FuelBurn": "","BMSLink": "","CustomerName": "BUNDABERG SUGAR LTD(CLOSED)","ProductModel": "Z-M11","Distance": 802127,"Location": "05340-01247"},{"WorkSummaryCOMPLAINT": "","ClaimNumber": "","Invoice": 1978660,"BMSWOreference": 5189878,"DistanceType": "KILOMETERS","FaultcodesCORRECTION": "","UnitHours": "","WorkSummaryCAUSE": "Injector missfire","ReceivedDate": "2004-10-27T00:00:00.000-00:00","FuelBurn": "","BMSLink": "","CustomerName": "BUNDABERG SUGAR LTD(CLOSED)","ProductModel": "Z-M11","Distance": 802127,"Location": "05340-01247"}]}');
        }   
        if(req.getEndpoint().contains('css/bmsworkorder'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea": {"CSSJobID": "00002745","ContactID": 1921,"WOReferenceNumber": 6393191},"Header": {"Sender": {"ServiceName": "CreateWorkOrder","SenderID": "CSS","MessageID": "98e74b0b-6a8e-47d1-b4b2-5916e4de0291"},"Status": "SUCCESS","Target": {"TargetID": "MOVEX"}, "ReturnCode"="200","ReturnCodeDescription": "WO/WOQT 6393191 updated successfully","Location": {"LocationID": ""}}}');  
            return res;
        }
        if(req.getEndpoint().contains('csswarranty/bmssubtype'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea": {"CodeDescription": "CASH SALES SERVICE - BRISBANE","CodeValue": "130SERV","Code": "Cash Sale Customer"},"Header": {"Sender": {"ServiceName": "GetMoveXLOV","SenderID": "CSS"},"Status": "SUCCESS","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Request processed successfully","Location": {"LocationID": "05340-05351"}}}');
            return res;
        }
        if(req.getEndpoint().contains('QueryRepeatVisitFlag'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea": {"NotificationMessage": "","RepeatVisitFlag": "N","ErrorCode": 0,"NotificationFlag": ""},"Header": {"Status": "Success"}}');  
        }
        if(req.getEndpoint().contains('makemodel'))
        {
            system.debug('testmakeModel-->');
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            //{"Header":{"Target":{"TargetID":"SIEBEL"},"Sender":{"ServiceName":"updateMakeModel","SenderID":"CSS"}},"DataArea":{"MakeModel":[{"Type":"Engines","PSN":"79660448","ProductApplicationCode":"test","ModelSeries":null,"Manufacturer":null}]}}
            //res.setBody('{"Header":{"Target":{"TargetID":"SIEBEL"},"Sender":{"ServiceName":"updateMakeModel","SenderID":"CSS"}},"DataArea":{"MakeModel":[{"cls_Type":"Engines","cls_PSN":"79660448","ProductApplicationCode":"test","ModelSeries":null,"Manufacturer":null}]}}');  
            res.setBody('{"DataArea": {"CustomerCode": 2110054,"CSSJobID": "00002863","ContactID": 0},"Header": {"Sender": {"ServiceName": "CreateUpdateContact","SenderID": "CSS","MessageID": "7c997f48-27b0-4c1c-aa8b-e1ed3d1b3b50"},"Status": "ERROR","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "Combination of Contact Name, Phone# & Email already exist.","Location": {"LocationID": "05340-73633"}}}');
        }
        if(req.getEndpoint().contains('failmodes'))
        {
            system.debug('testmakeModel-->');
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            //{"Header":{"Target":{"TargetID":"SIEBEL"},"Sender":{"ServiceName":"updateMakeModel","SenderID":"CSS"}},"DataArea":{"MakeModel":[{"Type":"Engines","PSN":"79660448","ProductApplicationCode":"test","ModelSeries":null,"Manufacturer":null}]}}
            //res.setBody('{"Header":{"Target":{"TargetID":"SIEBEL"},"Sender":{"ServiceName":"updateMakeModel","SenderID":"CSS"}},"DataArea":{"MakeModel":[{"cls_Type":"Engines","cls_PSN":"79660448","ProductApplicationCode":"test","ModelSeries":null,"Manufacturer":null}]}}');  
            res.setBody('[DataArea=DataArea:[Details=(Details:[Active=Y, BusinessUnit=CMI, Description=CAMPAIGN, FailModeCode=VY, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=CAMPAIGN, FailModeCode=JM, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=CAMPAIGN, FailModeCode=QZ, TargetID=null], Details:[Active=N, BusinessUnit=CMI, Description=WRONG POSITION/LOCATION, FailModeCode=WL, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=CAMPAIGN, FailModeCode=TT, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=LEAKS - OIL, FailModeCode=LO, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=LOW RESISTANCE, FailModeCode=LR, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=INSUFFICIENT, FailModeCode=IS, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=SUPPORT PLUS PARTS, FailModeCode=RV, TargetID=null], Details:[Active=Y, BusinessUnit=CMI, Description=STUCK OPEN, FailModeCode=SO, TargetID=null)], Header=Header:[MessageIdentifier=58a9dc80-eb72-4be3-9276-069fbb8bc8b6, ReturnCodeDescription="Success", Status=Success]]');
        }
        if(req.getEndpoint().contains('GetSolution'))
        {
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody(FSL_TestDataUtility.getFaultCodeResponse());
        }
        return res;
    }
}