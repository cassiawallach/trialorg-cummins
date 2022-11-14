/******
Name:  OSM_CancelLicenses_Helper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       14/01/2019     INITIAL DEVELOPMENT 
*******/
public class OSM_CancelLicenses_Helper{
     public static OSM_CancelLicensesREQWrapper populateRequestObjectData(OSM_CancelLicensesREQ_GeneralizedWrapper inputWrapperObj){
       String Sender_ID ='Mrktplc';
        String Target_ID ='OMS';
        String ServiceName='CancelLicense';
       //Intializing request object
        OSM_CancelLicensesREQWrapper reqObj = new OSM_CancelLicensesREQWrapper();
        reqObj.Header=new OSM_CancelLicensesREQWrapper.Header();
        
        reqObj.Header.Sender=new OSM_CancelLicensesREQWrapper.Sender();
        reqObj.Header.Sender.ServiceName=ServiceName;
        reqObj.Header.Sender.SenderID=Sender_ID; 
        
        reqObj.Header.Target=new OSM_CancelLicensesREQWrapper.Target();
        reqObj.Header.Target.TargetID=Target_ID;
    
        reqObj.CancelLicensesInput=new OSM_CancelLicensesREQWrapper.CancelLicensesInput();        
        reqObj.CancelLicensesInput.ToolName=inputWrapperObj.CancelLicensesInput.ToolName;
        reqObj.CancelLicensesInput.TotalCopies= inputWrapperObj.CancelLicensesInput.TotalCopies;
        reqObj.CancelLicensesInput.RequesterId=OSM_Generic_Utility.truncateRequesterId(inputWrapperObj.CancelLicensesInput.RequesterId); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
        reqObj.CancelLicensesInput.ItemId=inputWrapperObj.CancelLicensesInput.ItemId;            
        return reqObj;
     }
}