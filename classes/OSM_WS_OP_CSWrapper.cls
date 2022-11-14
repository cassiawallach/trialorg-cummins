/************************************************************
Name:  OSM_WS_OP_CSWrapper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is input wrapper class which will be used to pass
request to service call.                                    
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            23/03/2018     INITIAL DEVELOPMENT     

Pooja : added "responseBody" to handle body in different variable 8/22/2022
 
*************************************************************/
public class OSM_WS_OP_CSWrapper
{
    public String Request {get;set;}
    public String Response {get;set;}
    public String responseBody {get;set;} //Added by Pooja
    public Integer totalAuthCallTime {get;set;} 
    public Integer totalServiceCallTime {get;set;} 
    public String errorMessage {get;set;} 
    public Boolean exceptionFlag {get;set;}
    public String APIURL {get;set;}
    public string requestTime {get; set;}
    public string responseTime {get; set;}
    
    public OSM_WS_OP_CSWrapper ()
    {
        exceptionFlag = false;
    }
}