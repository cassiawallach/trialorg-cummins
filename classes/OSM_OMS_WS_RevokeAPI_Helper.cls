/************************************************************
Name:  OSM_OMS_WS_RevokeAPI_Helper
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
1.0 -   Sangeeta            17/01/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_OMS_WS_RevokeAPI_Helper{
    

    public static OSM_OMS_WS_RevokeLicenseReq populateRequestObjectData(OSM_OMS_WS_RevokeGeneralized_IP_Wrapper inputWrapperObj)
    {
        // Defining variable whose values which are static values
        String Sender_ID = 'Mrktplc';
        String Target_ID = 'OMS';
        //String ServiceName='Revoke License';
        String ServiceName=System.Label.OMS_Revoke_API_Service_Name;
        String toolName='INSITE';
        
        //Intializing request object
        OSM_OMS_WS_RevokeLicenseReq reqObj = new OSM_OMS_WS_RevokeLicenseReq();
        reqObj.Header=new OSM_OMS_WS_RevokeLicenseReq.Header();
        reqObj.Header.Sender=new OSM_OMS_WS_RevokeLicenseReq.Sender();
        reqObj.Header.Target=new OSM_OMS_WS_RevokeLicenseReq.Target();
        reqObj.RevokeLicensesInput=new OSM_OMS_WS_RevokeLicenseReq.RevokeLicensesInput();
        reqObj.RevokeLicensesInput.InstanceIdList=new List<OSM_OMS_WS_RevokeLicenseReq.InstanceIdList>();
        //
        
        //Populating request object data
        reqObj.Header.Sender.SenderID=Sender_ID;
        reqObj.Header.Sender.ServiceName=ServiceName;
        reqObj.Header.Target.TargetID=Target_ID;
        //reqObj.RevokeLicensesInput.InstanceIdList.Instance=inputWrapperObj.RevokeLicensesInput.InstanceIdList.Instance;
        reqObj.RevokeLicensesInput.ToolName=toolName;
        reqObj.RevokeLicensesInput.RequesterId=OSM_Generic_Utility.truncateRequesterId(inputWrapperObj.RevokeLicensesInput.RequesterId); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
        for(OSM_OMS_WS_RevokeGeneralized_IP_Wrapper.InstanceIdList instanceIdWrapperObj:inputWrapperObj.RevokeLicensesInput.InstanceIdList)
        {
            OSM_OMS_WS_RevokeLicenseReq.InstanceIdList wrapperObj=new  OSM_OMS_WS_RevokeLicenseReq.InstanceIdList();
            wrapperObj.Instance=instanceIdWrapperObj.Instance;
            reqObj.RevokeLicensesInput.InstanceIdList.add(wrapperObj);
        }
    
          
        system.debug('the object detail which we are retruning back>>>>>'+reqObj);
        return reqObj;
    }
}