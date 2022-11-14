/**********************************************************************
Name: CSS_WPR_BMS_WOQTOutboundQuoteResJSON
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper class
            of WOQT Outbound Quote PDF of BMS Rest Service
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/14/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_WPR_BMS_WOQTOutboundQuoteResJSON {
    
    public Header Header{get;set;}
    
    public class Header{
        public String Status{get;set;}
        public String ReturnCodeDescription{get;set;}
        public Location Location{get;set;}
    }
    
    public class Location {
        public String LocationID{get;set;}
    }
    
    public static CSS_WPR_BMS_WOQTOutboundQuoteResJSON parse(String json) {
        return (CSS_WPR_BMS_WOQTOutboundQuoteResJSON) System.JSON.deserialize(json, CSS_WPR_BMS_WOQTOutboundQuoteResJSON.class);
    }
}