/**********************************************************************
Name: CSS_SRTComponentLookupRequestJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Request JSON for Component Lookup 
            Service(Failure Code)
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Vignesh        07/25/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_SRTComponentLookupRequestJ2A
{
    public Header Header;
    public DataArea DataArea;
    public class Header{
        public Sender Sender;
        public Target Target;
    }
    public class DataArea{
        public String ServiceModelName{get;set;}
        public String LanguageCode{get;set;}
        public String EngineFamilyCode{get;set;}
    }
    public class Sender{
        public string ServiceName;
        public string SenderID;
    }
    public class Target{
        public string TargetID;
    }
    public static CSS_SRTComponentLookupRequestJ2A parse(String json) {
        return (CSS_SRTComponentLookupRequestJ2A) System.JSON.deserialize(json, CSS_SRTComponentLookupRequestJ2A.class);
  }
}