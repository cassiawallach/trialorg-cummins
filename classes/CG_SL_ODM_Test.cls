@isTest
global class CG_SL_ODM_Test
{
    
    public static Testmethod void CG_SL_ODM_Method(){
        test.startTest();
        List<CSS_Integration_Details__c> conDetailsList = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='CG_ODMHeaderValidation';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='CG_ODMHeaderValidation';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/header';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='al1ufLm+eGhMQGBP8LNDxP5pPZpbHDAAxeqrz3m3jVc=';
        conDetails.Passcode__c='LU8Ih/SyVzsBI5orDsQgiPXRBslYyUpejYY0rJEwOZUNi9E/Pdv/O7L0K6ixrMbvX0kXyGRL/PimO4JrvQwA1A==';
        conDetails.Username__c='fF16z3F9QZ3PhXtxtcwFD4BQkKe5Lk//8GwngwxCoNiUuHS5jc0kFZOGbLzQC/H7OOFpjPEn6K3kYzVvaSmsbw==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        conDetailsList.add(conDetails);
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='CG_ODMPartsService';
        conDetails1.IsActive__c=true;
        conDetails1.ApplicationName__c='CG_ODMPartsService';
        conDetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/parts';
        conDetails1.Method_Type__c='POST';
        conDetails1.Key__c='C4sulMbYCfRx3CVUszchtEza9MnsYklLiVygpQWh+Ng=';
        conDetails1.Passcode__c='EYE0ipFnJiWAxa55wzsWyEoEinjaEKq+i0Aoc7t5zasuq4+yRbsQ931Qn+Zvs/hTz73rseO1Pp+PfnCt67st8A==';
        conDetails1.Username__c='wB8gCc4HTRkWbRrKOz1sA7hkx+4Wo/iW71OrejFFi+8F942FQ1LaqjbdUzyMw2k1hfbVMJt4+oz9fi9vQjxZkQ==';
        conDetails1.AuthEnv__c='MuleAuth';
        conDetails1.Timeout__c=120000;
        conDetails1.Logging__c='BOTH';
        conDetailsList.add(conDetails1);
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.Name='CG_ODMSRTService';
        conDetails2.IsActive__c=true;
        conDetails2.ApplicationName__c='CG_ODMSRTService';
        conDetails2.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/srt';
        conDetails2.Method_Type__c='POST';
        conDetails2.Key__c='pT0JaPTrclNC0IEw1kKouItFrZj8FoIaOeTa3BfBtBU=';
        conDetails2.Passcode__c='9PO5osUZ1FXtuffsCXoER030YVFd0zHb04jCTDIJHSGo0/D8Dvg7TnDDzFug0XvikpylhLpzOIafKZgA4oZU8Q==';
        conDetails2.Username__c='TxsRUjX4tkHbJhmizDEJgQl1iR3gz+ymxvMvlfMcJNgRn8Mzg6zjx3vikWhbni+ApR1wimYlTfglndjlcNiDKQ==';
        conDetails2.AuthEnv__c='MuleAuth';
        conDetails2.Timeout__c=120000;
        conDetails2.Logging__c='BOTH';
        conDetailsList.add(conDetails2);
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();
        conDetails3.Name='CG_ODMTravelService';
        conDetails3.IsActive__c=true;
        conDetails3.ApplicationName__c='CG_ODMTravelService';
        conDetails3.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/travel';
        conDetails3.Method_Type__c='POST';
        conDetails3.Key__c='7+xApd8H85R81jMkjwdkiKF38kBy/5/Kn0BeJ6oiSyQ=';
        conDetails3.Passcode__c='aPdH2aljLpJNcn257bFad+/cJLEPLgjaDgOff/aMdt14Ftt1S2RBg4gX5E3QDdg0SyU7LFuo0r7BZ7pMrI8IHg==';
        conDetails3.Username__c='ozWoOPV+t28bMeXvUvsLBSxaYOOJbs9Hiq5qltWsIeKH3B3kzMZEe0Fe+kzdSDng4NZGB4mPEJK9iH5ILKyoQQ==';
        conDetails3.AuthEnv__c='MuleAuth';
        conDetails3.Timeout__c=120000;
        conDetails3.Logging__c='BOTH';
        conDetailsList.add(conDetails3);
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.Name='CG_OtherClaimablesValidation';
        conDetails4.IsActive__c=true;
        conDetails4.ApplicationName__c='CG_OtherClaimablesValidation';
        conDetails4.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/othclaimables';
        conDetails4.Method_Type__c='POST';
        conDetails4.Key__c='mqgAfQpGo+aL4xOLDepQfYriZU65gOseboO7EZA3Ncs=';
        conDetails4.Passcode__c='155b3DOk0+mO4T7XK9vC3OdeIxUSar3PlGUg7t9CU/Ov7wSOCI19l69Gh86ChDmYJfimMwXYw+VFgMcn4+Le9g==';
        conDetails4.Username__c='/N8HSCbsSbPYhcDJdQLyef4ZJjE2Jp39TDgQhhAfud/ZmfUYdWTbj5hoioh1YMUxnUM1ea+qJy0E/5ysNh+I6w==';
        conDetails4.AuthEnv__c='MuleAuth';
        conDetails4.Timeout__c=120000;
        conDetails4.Logging__c='BOTH';
        conDetailsList.add(conDetails4);
        
        CSS_Integration_Details__c conDetails5 = new CSS_Integration_Details__c();
        conDetails5.Name='CG_FailureValidation';
        conDetails5.IsActive__c=true;
        conDetails5.ApplicationName__c='CG_FailureValidation';
        conDetails5.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/failure';
        conDetails5.Method_Type__c='POST';
        conDetails5.Key__c='qLA4RqeHtxDlK14xH6l/HaQxxMZgALq11JMifWLiIu4=';
        conDetails5.Passcode__c='yEZSCZ1hNlVb19+yTjhpx1ecHO57KOQCiVBZphqw+KjdV0Gq6MegeUAKOAte+WnIIGF0hEvnjuqDWJfcWpfzjA==';
        conDetails5.Username__c='QICgngUC+kpmjf+YZzZCR2m2ClqcX8ffdIxr6qc0uQzr01gqOAt+SOwrc3fcydoKFORtcoNedXjka6i75gQjgQ==';
        conDetails5.AuthEnv__c='MuleAuth';
        conDetails5.Timeout__c=120000;
        conDetails5.Logging__c='BOTH';
        conDetailsList.add(conDetails5);
        
        CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
        conDetails6.Name='ODMPreSubmitValidation';
        conDetails6.IsActive__c=true;
        conDetails6.ApplicationName__c='ODMPreSubmitValidation';
        conDetails6.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/presubmit';
        conDetails6.Method_Type__c='POST';
        conDetails6.Key__c='sZ5pvJOx0d2RuDFLlOwLhWBJthGTPSpdecFDV/BOsgI=';
        conDetails6.Passcode__c='lECcMTZ+JgxDkAbhugDRxA8xtYAUFyNunmsy59S/0+/Gv0xKJkyPKpfVADCjdVJ4IFoF3uVn7QtEsb3GwMjcQg==';
        conDetails6.Username__c='udj63yv8S6fRVW2L27pz6oMnjPO/85K5FSHT4WC7SdoN9XjA2SeweXZJ2GTkiPQdR3DIZIm46VU7wzd6JU+jRA==';
        conDetails6.AuthEnv__c='MuleAuth';
        conDetails6.Timeout__c=120000;
        conDetails6.Logging__c='BOTH';
        conDetailsList.add(conDetails6);
        
        insert conDetailsList;
            
        string json='{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh559", "ServiceName": "ServiceName" } }, "Request": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "HeaderCampaign": { "campaignId": "oh559", "campaignType": "oh559", "expiryDateNA": "oh559", "expiryDateIntl": "oh559", "effectiveDate": "oh559", "status": "oh559", "completeIndicator": "oh559", "multiFlag": "oh559", "cmpEngineStatusCode": "oh559" }, "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": [ { "code": "oh559" } ], "Parts": [ { "lineNumber": "oh559", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559", "MCEPSelectionFlag": "N", "NXpartId": "", "NXpartPrice": "", "NXpriceBookName": "", "RXpartId": "", "RXpartPrice": "", "RXpriceBookName": "" } ], "Failure": [ { "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "oh559", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "lineNumber": "oh559", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "lineNumber": "oh559", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "oh559", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559", "MCEPFlag": "NW792" }, "DecisionID": "DecisionID" } }';
        CG_ODM_ReqJSONParser odm1 = CG_ODM_ReqJSONParser.parse(json);
        CG_ODM_PreSubmit_ReqJSONParser presubmit=new CG_ODM_PreSubmit_ReqJSONParser();
        CG_OP_OAGWrapper oag1=CG_SL_ODM.callODMHeaderService(odm1);
        CG_OP_OAGWrapper oag2=CG_SL_ODM.callODMPartsService(odm1);
        CG_OP_OAGWrapper oag3=CG_SL_ODM.callODMFailureService(odm1);
        CG_OP_OAGWrapper oag4=CG_SL_ODM.callODMTravelService(odm1);
        CG_OP_OAGWrapper oag7=CG_SL_ODM.callODMOtherClaimableService(odm1);
        CG_OP_OAGWrapper oag5=CG_SL_ODM.callODMPreSubmitService(presubmit);
        CG_OP_OAGWrapper oag6=CG_SL_ODM.callODMSRTService(odm1);
        //CG_OP_OAGWrapper oag17=CG_SL_ODM.callODMHeaderService();
       
        test.stopTest();
    } 
    
    
   public static Testmethod void someTestmethodFailure(){
        Test.startTest();
       List<CSS_Integration_Details__c> conDetailsList = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='CG_ODMHeaderValidation';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='CG_ODMHeaderValidation';
        conDetails.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/header';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='al1ufLm+eGhMQGBP8LNDxP5pPZpbHDAAxeqrz3m3jVc=';
        conDetails.Passcode__c='LU8Ih/SyVzsBI5orDsQgiPXRBslYyUpejYY0rJEwOZUNi9E/Pdv/O7L0K6ixrMbvX0kXyGRL/PimO4JrvQwA1A==';
        conDetails.Username__c='fF16z3F9QZ3PhXtxtcwFD4BQkKe5Lk//8GwngwxCoNiUuHS5jc0kFZOGbLzQC/H7OOFpjPEn6K3kYzVvaSmsbw==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';
        conDetailsList.add(conDetails);
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.Name='CG_ODMPartsService';
        conDetails1.IsActive__c=true;
        conDetails1.ApplicationName__c='CG_ODMPartsService';
        conDetails1.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/parts';
        conDetails1.Method_Type__c='POST';
        conDetails1.Key__c='C4sulMbYCfRx3CVUszchtEza9MnsYklLiVygpQWh+Ng=';
        conDetails1.Passcode__c='EYE0ipFnJiWAxa55wzsWyEoEinjaEKq+i0Aoc7t5zasuq4+yRbsQ931Qn+Zvs/hTz73rseO1Pp+PfnCt67st8A==';
        conDetails1.Username__c='wB8gCc4HTRkWbRrKOz1sA7hkx+4Wo/iW71OrejFFi+8F942FQ1LaqjbdUzyMw2k1hfbVMJt4+oz9fi9vQjxZkQ==';
        conDetails1.AuthEnv__c='MuleAuth';
        conDetails1.Timeout__c=120000;
        conDetails1.Logging__c='BOTH';
        conDetailsList.add(conDetails1);
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.Name='CG_ODMSRTService';
        conDetails2.IsActive__c=true;
        conDetails2.ApplicationName__c='CG_ODMSRTService';
        conDetails2.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/srt';
        conDetails2.Method_Type__c='POST';
        conDetails2.Key__c='pT0JaPTrclNC0IEw1kKouItFrZj8FoIaOeTa3BfBtBU=';
        conDetails2.Passcode__c='9PO5osUZ1FXtuffsCXoER030YVFd0zHb04jCTDIJHSGo0/D8Dvg7TnDDzFug0XvikpylhLpzOIafKZgA4oZU8Q==';
        conDetails2.Username__c='TxsRUjX4tkHbJhmizDEJgQl1iR3gz+ymxvMvlfMcJNgRn8Mzg6zjx3vikWhbni+ApR1wimYlTfglndjlcNiDKQ==';
        conDetails2.AuthEnv__c='MuleAuth';
        conDetails2.Timeout__c=120000;
        conDetails2.Logging__c='BOTH';
        conDetailsList.add(conDetails2);
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();
        conDetails3.Name='CG_ODMTravelService';
        conDetails3.IsActive__c=true;
        conDetails3.ApplicationName__c='CG_ODMTravelService';
        conDetails3.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/travel';
        conDetails3.Method_Type__c='POST';
        conDetails3.Key__c='7+xApd8H85R81jMkjwdkiKF38kBy/5/Kn0BeJ6oiSyQ=';
        conDetails3.Passcode__c='aPdH2aljLpJNcn257bFad+/cJLEPLgjaDgOff/aMdt14Ftt1S2RBg4gX5E3QDdg0SyU7LFuo0r7BZ7pMrI8IHg==';
        conDetails3.Username__c='ozWoOPV+t28bMeXvUvsLBSxaYOOJbs9Hiq5qltWsIeKH3B3kzMZEe0Fe+kzdSDng4NZGB4mPEJK9iH5ILKyoQQ==';
        conDetails3.AuthEnv__c='MuleAuth';
        conDetails3.Timeout__c=120000;
        conDetails3.Logging__c='BOTH';
        conDetailsList.add(conDetails3);
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.Name='CG_OtherClaimablesValidation';
        conDetails4.IsActive__c=true;
        conDetails4.ApplicationName__c='CG_OtherClaimablesValidation';
        conDetails4.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/othclaimables';
        conDetails4.Method_Type__c='POST';
        conDetails4.Key__c='mqgAfQpGo+aL4xOLDepQfYriZU65gOseboO7EZA3Ncs=';
        conDetails4.Passcode__c='155b3DOk0+mO4T7XK9vC3OdeIxUSar3PlGUg7t9CU/Ov7wSOCI19l69Gh86ChDmYJfimMwXYw+VFgMcn4+Le9g==';
        conDetails4.Username__c='/N8HSCbsSbPYhcDJdQLyef4ZJjE2Jp39TDgQhhAfud/ZmfUYdWTbj5hoioh1YMUxnUM1ea+qJy0E/5ysNh+I6w==';
        conDetails4.AuthEnv__c='MuleAuth';
        conDetails4.Timeout__c=120000;
        conDetails4.Logging__c='BOTH';
        conDetailsList.add(conDetails4);
        
        CSS_Integration_Details__c conDetails5 = new CSS_Integration_Details__c();
        conDetails5.Name='CG_FailureValidation';
        conDetails5.IsActive__c=true;
        conDetails5.ApplicationName__c='CG_FailureValidation';
        conDetails5.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/failure';
        conDetails5.Method_Type__c='POST';
        conDetails5.Key__c='qLA4RqeHtxDlK14xH6l/HaQxxMZgALq11JMifWLiIu4=';
        conDetails5.Passcode__c='yEZSCZ1hNlVb19+yTjhpx1ecHO57KOQCiVBZphqw+KjdV0Gq6MegeUAKOAte+WnIIGF0hEvnjuqDWJfcWpfzjA==';
        conDetails5.Username__c='QICgngUC+kpmjf+YZzZCR2m2ClqcX8ffdIxr6qc0uQzr01gqOAt+SOwrc3fcydoKFORtcoNedXjka6i75gQjgQ==';
        conDetails5.AuthEnv__c='MuleAuth';
        conDetails5.Timeout__c=120000;
        conDetails5.Logging__c='BOTH';
        conDetailsList.add(conDetails5);
        
        CSS_Integration_Details__c conDetails6 = new CSS_Integration_Details__c();
        conDetails6.Name='ODMPreSubmitValidation';
        conDetails6.IsActive__c=true;
        conDetails6.ApplicationName__c='ODMPreSubmitValidation';
        conDetails6.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/validation/presubmit';
        conDetails6.Method_Type__c='POST';
        conDetails6.Key__c='sZ5pvJOx0d2RuDFLlOwLhWBJthGTPSpdecFDV/BOsgI=';
        conDetails6.Passcode__c='lECcMTZ+JgxDkAbhugDRxA8xtYAUFyNunmsy59S/0+/Gv0xKJkyPKpfVADCjdVJ4IFoF3uVn7QtEsb3GwMjcQg==';
        conDetails6.Username__c='udj63yv8S6fRVW2L27pz6oMnjPO/85K5FSHT4WC7SdoN9XjA2SeweXZJ2GTkiPQdR3DIZIm46VU7wzd6JU+jRA==';
        conDetails6.AuthEnv__c='MuleAuth';
        conDetails6.Timeout__c=120000;
        conDetails6.Logging__c='BOTH';
        conDetailsList.add(conDetails6);
        
        insert conDetailsList;
       
        Test.setMock(HttpCalloutMock.class, new MyMockFail());  // mock with response = 400
        //CG_ODM_ReqJSONParser odm1='';
       try{
        CG_OP_OAGWrapper oag1=CG_SL_ODM.callODMHeaderService(null);
         oag1.exceptionFlag = true;
        }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag2=CG_SL_ODM.callODMPartsService(null);
          oag2.exceptionFlag = true;
       }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag3=CG_SL_ODM.callODMFailureService(null);
           oag3.exceptionFlag = true;
       }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag4=CG_SL_ODM.callODMTravelService(null);
           oag4.exceptionFlag = true;
       }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag5=CG_SL_ODM.callODMOtherClaimableService(null);
           oag5.exceptionFlag = true;
       }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag6=CG_SL_ODM.callODMPreSubmitService(null);
           oag6.exceptionFlag = true;
       }catch(Exception e){
         
       }
       try{
        CG_OP_OAGWrapper oag7=CG_SL_ODM.callODMSRTService(null);
           oag7.exceptionFlag = true;
       }catch(Exception e){
         
       }
       
        test.stopTest();     
    } 
    
    global class MyMockFail implements HttpCalloutMock {
           
            global HTTPResponse respond(HTTPRequest req) {
                HttpResponse resp = new HttpResponse();
                resp.setStatusCode(400);
                resp.setStatus('Bad request');
                return resp;
            }
    }  
    
    /*public static Testmethod void someTestmethodFailure1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MyMockFail());  // mock with response = 400
        try{
        CG_OP_OAGWrapper oag7=CG_SL_ODM.callODMOtherClaimableService(null);
        }catch(Exception e){
            
        }
        Test.stopTest();
    }*/
   /* public static Testmethod void catchhBlockMethod(){
         CG_IP_OAGWrapper reqWrapper=new CG_IP_OAGWrapper();
        reqWrapper.serviceName = '';
            reqWrapper.methodType = '';
         CG_OP_OAGWrapper returnWrapper=CG_WS_OAG.calloutGeneric(null);
        returnWrapper.exceptionFlag=true;
        CG_ODM_ReqJSONParser reqJson =null;
        CG_SL_ODM.callODMHeaderService(reqJson);
    }*/
    
}