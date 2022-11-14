/************************************************************
Name:  OSM_WS_OAGAccessTokenWrapper 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is generic json to apex class that will take response of
access token request. It will get access token, token type, 
expire date, refresh token after service call is done. 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         26/04/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_WS_OAGAccessTokenWrapper {

    public String access_token;
    public String token_type;
    public String expires_in;
    public String refresh_token;
    public String scope;
    
    // Added for MAR-606
    public String not_before;
    public String expires_on;
    public String ext_expires_in;
    public String resource;
    public String status;
    
    public static OSM_WS_OAGAccessTokenWrapper parse(String json) {
        return (OSM_WS_OAGAccessTokenWrapper) System.JSON.deserialize(json, OSM_WS_OAGAccessTokenWrapper.class);
    }
}