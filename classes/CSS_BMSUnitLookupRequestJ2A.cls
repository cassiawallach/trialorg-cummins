/**********************************************************************
Name: CSS_BMSUnitLookupRequestJ2A 
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Request JSON for Unit Lookup 
			Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Anirudh Pesari   08/16/2017       INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_BMSUnitLookupRequestJ2A 
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
        public String ESN{get;set;}
        public String UnitNumber{get;set;} 
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
    public static CSS_BMSUnitLookupRequestJ2A parse(String json) {
		return (CSS_BMSUnitLookupRequestJ2A) System.JSON.deserialize(json, CSS_BMSUnitLookupRequestJ2A.class);
	}
}