/************************************************************
Name: 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is helper class of Service layer.

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BMS_WS_CustomerOutbound_Helper{
    
/*----------------------------------------------------------------------------------
1. populateRequestObjectData
Description:This is the helper class method which will bind the static and dynamic values  
params
 OSM_BMS_WS_GeneralizedInputWrapper- object of OSM_BMS_WS_GeneralizedInputWrapper
Return: OSM_BMS_WS_CustomerOuboundReq

------------------------------------------------------------------------------------*/
    public static OSM_BMS_WS_CustomerOuboundReq populateRequestObjectData(OSM_BMS_WS_GeneralizedInputWrapper inputWrapperObj)
    {
        // Defining variable whose values will come through custom label(Static)
        String Sender_ID = System.Label.OSM_BMS_Sender_ID;
        String Target_ID = System.Label.OSM_BMS_Target_ID;
        String ServiceName=System.Label.OSM_BMS_Service_Name;
        
        //Intializing request object
        OSM_BMS_WS_CustomerOuboundReq reqObj = new OSM_BMS_WS_CustomerOuboundReq();
        reqObj.DataArea=new OSM_BMS_WS_CustomerOuboundReq.DataArea();
        reqObj.Header=new OSM_BMS_WS_CustomerOuboundReq.Header();
        reqObj.Header.Location=new OSM_BMS_WS_CustomerOuboundReq.Location();
        reqObj.Header.Sender=new OSM_BMS_WS_CustomerOuboundReq.Sender();
        reqObj.Header.Target=new OSM_BMS_WS_CustomerOuboundReq.Target();
        
        //Populating request object data
        reqObj.Header.Sender.SenderID=Sender_ID;
        reqObj.Header.Sender.ServiceName=ServiceName;
        reqObj.Header.Target.TargetID=Target_ID;
        reqObj.DataArea.CustomerName=inputWrapperObj.DataArea.CustomerName;
        //reqObj.DataArea.CustomerName='';
        reqObj.DataArea.CustomerCode=inputWrapperObj.DataArea.CustomerCode;
        reqObj.DataArea.DealerCode=inputWrapperObj.DataArea.DealerCode;
        reqObj.Header.Location.LocationID=inputWrapperObj.Header.Location.LocationID;
        
             
                   
        
        return reqObj;
    }
}