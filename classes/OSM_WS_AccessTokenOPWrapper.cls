/************************************************************
Name:  OSM_WS_AccessTokenOPWrapper
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

global class OSM_WS_AccessTokenOPWrapper {

    public String accessToken;
    public Integer totalAuthCallTime;
    public Boolean exceptionFlag = false;
    public String errorMessage;
    
    public static OSM_WS_AccessTokenOPWrapper parse(String json) {
        return (OSM_WS_AccessTokenOPWrapper) System.JSON.deserialize(json, OSM_WS_AccessTokenOPWrapper.class);
    }
}