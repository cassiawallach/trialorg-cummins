/**********************************************************************
Name: CSS_SiebelFailCodeResponseJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for Fail Code 
            Search Siebel Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Krishnamoorthi N      08/22/2017       INITIAL DEVELOPMENT
***********************************************************************/
public class CSS_SiebelFailCodeResponseJ2A {
    
    public Header Header;
    public DataArea DataArea;
    
    public class Header{
        public String MessageIdentifier{get;set;}
        public String ReturnCode{get;set;}
        public String ReturnCodeDescription{get;set;}
        public String Status{get;set;}
        public string MessageType {get;set;} // Added for Mule Integration
    }
    
    public class DataArea{
        public list<Details> Details {get;set;} 
    }    
    
    public class Details {
    public String SystemCode{get;set;}
        public String SystemName{get;set;}
        public String ComponentCode{get;set;}
        public String ComponentName{get;set;}
        public String FailureName{get;set;}
        public String ServiceGroupCode{get;set;}
        public String Created{get;set;}
        public String Active{get;set;}
        public String UpdatedDate{get;set;}
        public String BusinesUnit{get;set;}  
    }
    
    public static CSS_SiebelFailCodeResponseJ2A parse(String json) {
        return (CSS_SiebelFailCodeResponseJ2A) System.JSON.deserialize(json, CSS_SiebelFailCodeResponseJ2A.class);
    }
}