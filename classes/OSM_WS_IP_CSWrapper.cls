/************************************************************
Name:  OSM_WS_IP_CSWrapper
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

*************************************************************/
public class OSM_WS_IP_CSWrapper
{
    
    public String jsonReqBody{get;set;}
    public String serviceName {get;set;} 
    public String AuthEnv {get;set;}
    public Boolean AccesTokenRequired {get;set;}
    public String methodType {get;set;}
    public Integer timeOut {get;set;}
    
    // added for MAR-606
    public String cmsOrderId {get; set;}
    public String MessageID {get; set;}
    public String Timestamp {get; set;}
    public String ToolName {get; set;}
    public String ActivationKey {get; set;}
    
    public String CustomerName {get; set;}
    public String CustomerCode {get; set;}
    public String DealerCode {get; set;}
    public String LocationID {get; set;}
    public String TargetID {get; set;}
    public String SenderID {get; set;}
    
    public OSM_WS_IP_CSWrapper()
    {
        jsonReqBody = '';
    }
}