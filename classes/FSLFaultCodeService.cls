/**********************************************************************
Name: FSLFaultCodeService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is a web service class it is used to get Fault code values 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/19/2019                         
***********************************************************************/
public class FSLFaultCodeService {
    
    public List<FSLFaultCodeWrapper> getFaultCodes()
    {
        FSL_Fault_Code__c Fault = [SELECT Id, Revision__c FROM FSL_Fault_Code__c ORDER BY Revision__c DESC LIMIT 1];
        String strVersion;
        if(Fault != Null && Fault.Revision__c != Null) {
            strVersion = Fault.Revision__c;
        }
        String tokenStr = FSL_WS_OAG.getAccessTokenCDS('CDSgetToken14602');
        HttpRequest req;
        HttpResponse res;
        Http h = new Http();
        String responseBody;
        try
        {
            system.debug('getFaultCodes method');
            List<FSLFaultCodeWrapper> fslCDSResps = new list<FSLFaultCodeWrapper>();
            req = new HttpRequest();
            req.setMethod('GET');
            CSS_Integration_Details__c cdsF;
            if(!Test.isRunningTest()) {
                cdsF = CSS_Integration_Details__c.getInstance('CDSgetJ14602');
                req.setEndpoint(cdsF.End_Point__c + '&Version=' + strVersion + '&LanguageKey=' + cdsF.Language__c);
            }
            else {
                req.setEndpoint('https://cdsfaultcodes-stg.cummins.com/api/J14602AppACoreII?cdsID=true&Version=100&ToolID=GuidanzWeb&LanguageKey=en');
            }
            String authorizationHeader = 'Bearer '+tokenStr;
            req.setHeader('Authorization', authorizationHeader);
            system.debug('reqreqreq:::'+req);
            res = h.send(req);
            responseBody = res.getBody(); 
            system.debug('responseBody -->'+responseBody );
            responseBody = responseBody.replace('"Cummins Fault Code"','"Cummins_Fault_Code"'); 
            responseBody = responseBody.replace('"J2012 Pcode"','"J2012_Pcode"');
            responseBody = responseBody.replace('"Lamp Color"','"Lamp_Color"');
            responseBody = responseBody.replace('"Lamp Device"','"Lamp_Device"'); 
            responseBody = responseBody.replace('"Algorithm Description"','"Algorithm_Description"');
            responseBody = responseBody.replace('"Cummins Description"','"Cummins_Description"');
            responseBody = responseBody.replace('"Published in CES 14602"','"Published_in_CES_14602"');
            responseBody = responseBody.replace('"Special Instructions"','"Special_Instructions"');
            
            if(!Test.isRunningTest()) {
                return (List<FSLFaultCodeWrapper>)JSON.deserialize(responseBody , List<FSLFaultCodeWrapper>.Class);
            } else {
                String resp_Body = '[{"Id":"12a2dfce-3570-e911-a865-000d3a372701","Published_in_CES_14602":true,"Cummins_Fault_Code":11114,"Revision":213,"PID":"Not Mapped","SID":"Not Mapped","MID":"Not Mapped","J1587 FMI":"2","SPN":"990","J1939FMI":"21","J2012_Pcode":"6756","Lamp_Color":"None","Lamp_Device":"None","Cummins_Description":"Total Compression Brake Distance - Data Not Rational - Drifted Low","Special_Instructions":null,"Algorithm_Description":null,"Information":null,"AWL_Suppression":"None","AWL_Suppression_Reserved_2":"None","AWL_Suppression_Reserved_3":"None","AWL_Suppression_Reserved_4":"None","AWL_Suppression_Reserved_5":"None","AWL_Suppression_Reserved_6":"None","AWL_Suppression_Reserved_7":"None","AWL_Suppression_Reserved_8":"None","J2012-3 BYTE DTC":null,"FTB":null,"LanguageKey":"en"}]';
                return (List<FSLFaultCodeWrapper>)JSON.deserialize(resp_Body , List<FSLFaultCodeWrapper>.Class);
            }
        }
        catch(System.Exception e) {
            system.debug('catch'+e);
            return null;
        }
    }
    
    /* public class DeserializeResponse {
public String access_token;
public String instance_url;
public String id;
public String token_type;
public String issued_at;
public String signature;
// public string css_id__c;
} */
}