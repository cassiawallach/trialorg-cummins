/**********************************************************************
Name: CSS_SRTComponentLookupResponseJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for Component Lookup 
            Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Vignesh S      07/25/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_SRTComponentLookupResponseJ2A
{
    public Header Header;
    public List<DataArea> DataArea{get;set;}
    public class Header{
        public String ReturnCodeDescription{get;set;}
        public String ReturnCode{get;set;}
        public String MessageIdentifier{get;set;}
        public String Status{get;set;}
        public String MessageType{get;set;}//Added as part of Mule Integration
    }
    public class DataArea{
        public String ComponentCode{get;set;}
        public String FailureMode{get;set;}
        public String FailureID{get;set;}
        public String FailureName{get;set;}
        public String SystemCode{get;set;}
    }
    public static CSS_SRTComponentLookupResponseJ2A parse(String json) {
        return (CSS_SRTComponentLookupResponseJ2A) System.JSON.deserialize(json, CSS_SRTComponentLookupResponseJ2A.class);
    }
}