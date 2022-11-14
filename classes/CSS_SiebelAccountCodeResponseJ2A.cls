/**********************************************************************
Name: CSS_SRTComponentLookupResponseJ2A
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for Account Code 
            Search Siebel Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Vignesh S      08/22/2017       INITIAL DEVELOPMENT
1.1      Vignesh S      01/22/2017       Added PayCode attribute
1.1      Surender M     03/12/2018       Added new attributes
***********************************************************************/
public class CSS_SiebelAccountCodeResponseJ2A
{
    public Header Header;
    public List<DataArea> DataArea{get;set;}
    
    public class Header{
        public String ReturnCodeDescription{get;set;}
        public String Status{get;set;}
    }
    public class DataArea{
        public String ACCOUNTCODE{get;set;}
        public String DESCRIPTION{get;set;}
        public String COVERAGETYPE{get;set;}
        public List<PAYCODES> PAYCODES{get;set;}
        
        //New Fields as part of #127007
        public String EDSFLAG;
        public String BUSINESSUNIT;
        public String MULTIPSN;
        public String WARRANTY;
        public String CHRYSLERFLAG;
        
    }
    public class PAYCODES{
        public String PAYCODE{get;set;}
        public String PAYCODEDESCRIPTION{get;set;}
    }
    
    public static CSS_SiebelAccountCodeResponseJ2A parse(String json) {
        return (CSS_SiebelAccountCodeResponseJ2A) System.JSON.deserialize(json, CSS_SiebelAccountCodeResponseJ2A.class);
    }
}