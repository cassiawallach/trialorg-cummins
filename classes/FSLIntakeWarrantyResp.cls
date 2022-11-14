/**********************************************************************
Name: FSLIntakeWarrantyResp
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
1.0 - Vinod Yelala      01/20/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLIntakeWarrantyResp {
    public Header Header {get;set;} 
    public BasicCoverageResponseHeader BasicCoverageResponseHeader {get;set;} 
    public class Header {
        public String ReturnCodeDescription {get;set;} 
        public String Status {get;set;} 
        public String Remaining {get;set;} 
    }
    public class BasicCoverageResponseHeader {
        public String Response {get;set;} 
    }
    
}