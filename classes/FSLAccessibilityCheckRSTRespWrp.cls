/**********************************************************************
Name:FSLAccessibilityChecklistCls
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLAccessibilityCheckRSTRespWrp {
    public DataArea DataArea{get;set;}
    public Header Header{get;set;}
    public class DataArea
    {
        public List<CaseResponse> CaseResponse{get;set;}
        public DataArea()
        {
            //CaseResponse=new List<CaseResponse>();
        }        
    }
    public FSLAccessibilityCheckRSTRespWrp ()
    {
        DataArea=new DataArea();
        Header=new Header();
    }
    public Class Header
    {
        public String Status;
        public String ReturnCodeDescription;
        public Header()
        {
            Status='';
            ReturnCodeDescription='';
        }
    }
    public class CaseResponse
    {
        public String SRTTitle{get;set;}
        public String SRTDetails{get;set;}
        public String SRTID{get;set;}
        public CaseResponse()
        {
            SRTTitle='';
            SRTDetails='';
            SRTID='';
        }
    }
    public class AccessTokenWrp{
        public String access_token;
        public String token_type;
        public String expires_in;
        public String refresh_token;
        public String scope;
    }
}