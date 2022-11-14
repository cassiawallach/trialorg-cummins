/**********************************************************************
Name: FSLSymptomsCDSService
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the upserting the symptom Records from CDS Service.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLSymptomsCDSService {
    
    public List<FSLSymptomRespWrapper> getSymptoms() {
        String tokenStr = FSL_WS_OAG.getAccessTokenCDS('CDSgetTokenDomain');
        HttpRequest req;
        HttpResponse res;
        Http h = new Http();
        try
        {
            List<FSLSymptomRespWrapper> fslCDSResps = new List<FSLSymptomRespWrapper>();
            req = new HttpRequest();
            req.setMethod('GET');
            CSS_Integration_Details__c cdsS;
            if(!Test.isRunningTest()) {
               cdsS = CSS_Integration_Details__c.getInstance('CDSgetSymptoms');
               req.setEndpoint(cdsS.End_Point__c);
            }
            else {
                req.setEndpoint('https://cdsdomain-stg.cummins.com/api/v1/Symptom?cdsid=true');
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
                '[{"CDSID":"1234","ID":"b680e4ce-e985-e811-a965-000d3a1c5096","Name":"Aftertreatment Symptom","BusinessUnit":"Engine","ComplaintCode":null,"Status":"Active","cds_highlevelcategoryId":"Testid","cds_highlevelcategory":null,"CreatedOn":"2018-07-12T15:39:51","ModifiedOn":"2018-08-03T18:29:02","CreatedBy":"Shobhit Tandon","LanguageKey":"en"}]';
            }
            fslCDSResps = (List<FSLSymptomRespWrapper>)JSON.deserialize(respStr, List<FSLSymptomRespWrapper>.Class);
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