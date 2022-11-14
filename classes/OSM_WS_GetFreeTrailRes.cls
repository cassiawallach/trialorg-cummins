/************************************************************
Name:  OSM_WS_GetFreeTrailRes 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is response class for free trial 
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         01/07/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_WS_GetFreeTrailRes {
 
    public String Status;
    public String Request;
    public String Response;
    public Integer totalServiceCallTime;
    public Integer totalAuthCallTime; 
    public Boolean exceptionFlag;
    public String errorMessage;
    public String exceptionMessage;
 
}