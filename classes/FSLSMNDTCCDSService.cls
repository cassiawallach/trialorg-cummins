/**********************************************************************
Name: FSLSMNDTCCDSService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the CDS Service were we hitting the end points.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLSMNDTCCDSService {
    
    public List<FSLSMNDTCRespWrapper> getSMNDTC() {
        
        String tokenStr = FSL_WS_OAG.getAccessTokenCDS('CDSgetTokenDomain');
        HttpRequest req;
        HttpResponse res;
        Http h = new Http();
        try
        {
            List<FSLSMNDTCRespWrapper> fslCDSResps = new List<FSLSMNDTCRespWrapper>();
            req = new HttpRequest();
            req.setMethod('GET');
            CSS_Integration_Details__c cdsS;
            if(!Test.isRunningTest()) {
                cdsS = CSS_Integration_Details__c.getInstance('CDSgetSMNDTC');
                req.setEndpoint(cdsS.End_Point__c);
            }
            else {
                req.setEndpoint('https://cdsdomain-stg.cummins.com/api/v1/ServiceModelName?cdsID=true');
            }
            String authorizationHeader = 'Bearer '+tokenStr;
            req.setHeader('Authorization', authorizationHeader);
            system.debug('reqreqreq:::'+req);
            String respStr;
            if(!Test.isRunningTest()) {
                res = h.send(req);
            	respStr = res.getBody();
            }
            else {
                respStr =
                '[{"CDSID":"1234","ID":"f29b989c-31a0-e811-a98a-000d3a161089","BusinessUnit":"Engine","FaultTypePcode":"Yes","Status":"Active","FaultTypeSPNFMI":null,"FaultTypeFC":"Yes","CreatedOn":"2018-07-12T15:39:51","ModifiedOn":"2018-08-03T18:29:02","CreatedBy":"Shobhit Tandon"}]';
            }
            fslCDSResps = (List<FSLSMNDTCRespWrapper>)JSON.deserialize(respStr, List<FSLSMNDTCRespWrapper>.Class);
            system.debug('response for syptoms\n::'+fslCDSResps);
            return fslCDSResps;
        }
        catch(System.Exception e )
        {
            system.debug('catch'+e);
            return null;          
        }
    }
    /* public class DeserializeResponse
    {
        public String access_token;
        public String instance_url;
        public String id;
        public String token_type;
        public String issued_at;
        public String signature;
        // public string css_id__c;
    }*/
}