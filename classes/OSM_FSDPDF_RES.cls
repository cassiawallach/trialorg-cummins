/******
Name:  OSM_FSDPDF_RES
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       17/12/2018     INITIAL DEVELOPMENT 
*******/
global class OSM_FSDPDF_RES{
    public class OSMResponse {
        public String StatusCode;
        public String StatusDescription;
    }

    public OSMResponse OSMResponse;
    public static OSM_FSDPDF_RES parse(String json) {
        return (OSM_FSDPDF_RES) System.JSON.deserialize(json, OSM_FSDPDF_RES.class);
    }
}