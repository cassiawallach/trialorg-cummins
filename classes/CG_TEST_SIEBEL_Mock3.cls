@isTest
global class CG_TEST_SIEBEL_Mock3 implements HttpCalloutMock {
       global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            string dt = string.valueOf(date.today());
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            //res.setBody('{"DataArea":{"InShopLaborRate": "20.06","FieldServiceLaborRate": "19.06","WarrantyTrainingCertification":"yes",Region": "INTERNATIONAL","ChannelCode": "110","TravelRate": "0.37","Territory": "CHINA","ChannelOfDistribution": "110-DEALER"},"Header":{"Status":"Success"}}');
            //res.setBody('{\r\n\t\"DataArea\": {\r\n\t\t\"EtoConversionDate\": \"\",\r\n\t\t\"EquipmentId\": \"EQ7503\",\r\n\t\t\"EngineAppCode\": \"130\",\r\n\t\t\"DesignPhaseCode\": \"21\",\r\n\t\t\"ETOOldPSN\": \"12345678\",\r\n\t\t\"ETOOldESN\": \"23231245\",\r\n\t\t\"Manufacturer\": \"AUTOCAR\",\r\n\t\t\"OEMSPCode\": \"01005\",\r\n\t\t\"CriticalPartsListNumber\": \"8257\",\r\n\t\t\"CustomerName\": \"testingTTMl\",\r\n\t\t\"ProdAppCode\": \"BB\",\r\n\t\t\"ServiceModelName\": \"ISX CM570\",\r\n\t\t\"EngineFamilyName\": \"ISXSIGNATURE(APEX)\",\r\n\t\t\"EquipmentConfiguration\": \"CAB OVER\",\r\n\t\t\"PACCARFlag\": \"\",\r\n\t\t\"Esn\": \"79462880\",\r\n\t\t\"EngineBillToCode\": \"01405\",\r\n\t\t\"MarineAppFlag\": \"N\",\r\n\t\t\"AccessCode\": \"B\",\r\n\t\t\"ShipDate\": \"2011-03-05 00:00:00.0\",\r\n\t\t\"AutomotiveAppFlag\": \"Y\",\r\n\t\t\"EngineFamilyCode\": \"10\",\r\n\t\t\"BuildDate\": \"2011-03-01T00:00:00.000-06:00\",\r\n\t\t\"EngineAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"NoWarranty\": \"N\",\r\n\t\t\"ProdAppDesc\": \"AUTOMOTIVE\",\r\n\t\t\"Model\": \"ACX\",\r\n\t\t\"VIN\": \"3HSDJAPT9CN565886\",\r\n\t\t\"WarrantyStartDate\": \"2018-10-01T00:00:00.000-05:00\"\r\n\t},\r\n\t\"Header\": {\r\n\t\t\"Status\": \"Success\"\r\n\t}\r\n}'+;
            //res.setStatusCode(200);
           res.setBody('{"token_type":"Bearer","access_token":"ffYVjhpw7pEigWdjJWmZ9ACyNCySnQB3SbtPGk0H4vYkJ09Hwwzfrv",expires_in":"3600","ext_expires_in":"3600","expires_on":"1561063243","not_before":"1561059343","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWktc3AiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNTYxMDU5MzQzLCJuYmYiOjE1NjEwNTkzNDMsImV4cCI6MTU2MTA2MzI0MywiYWlvIjoiNDJaZ1lIamxzbWozejROTnpnWXQ2aTcrVVp2aUFRPT0iLCJhcHBpZCI6ImFkNzI0MzkyLTU1OTQtNGU4NS1iOWViLWIwZmMxOWMyZmFiZSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJzdWIiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJ0aWQiOiJiMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QiLCJ1dGkiOiJ5aXlZYkdoUzNVcVRWWjVtQzhOZUFBIiwidmVyIjoiMS4wIn0.PrbkWrRFJSojdTqZ5yP-JeanRHQgOrTUuEf5KNQCT0ejR52VJqGpZp4KpGwo4cBMjiPMSVZlizTANROSaghwpx29iNNWgEDrVRE8VM7_eeBolRYuub6fkk0Ie9VmuqWVomlsDFuk24IQT1q_dxdXZBRGPaSZGRq-xcxGblmdg6zGF_NrUYfGPzDdJk6ccFrcYOWSKJHBzYa12dQFiZ_oaf50EK6WG_FB13tcCVQnhqBqU0vYpOzsKobF96v-2CH1bM1GVMCAq_kez00Drvt2qdJCMCEctrt_7lu8qkBQ1OXHBSj9sSy0EnptN7DQ3L6HSxTrRZuoQftTwMsSMzfR8g"}');
        }
        return res;
        
    }
}