/**********************************************************************
Name: CSS_BMSContactLookupRequestJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Request JSON for Contact Lookup 
			Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Anirudh Pesari   04/10/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_BMSContactLookupRequestJ2A
{
    public Header Header;
    public DataArea DataArea;
    public class Header{
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    public class DataArea{
        public String CustomerCode{get;set;}
    }
    public class Sender{
        public string ServiceName;
        public string SenderID;
    }
    public class Target{
        public string TargetID;
    }
    public class Location{
        public string LocationID;
    }
    public static CSS_BMSContactLookupRequestJ2A parse(String json) {
		return (CSS_BMSContactLookupRequestJ2A) System.JSON.deserialize(json, CSS_BMSContactLookupRequestJ2A.class);
	}
}