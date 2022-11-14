/********************************************************************************
Name:FSL_CL_AdminSRTApi
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class for Admin SRT Integrtion
======================================================
User story : CT2-345
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
V.1.0 	 Rajashekar N		11/13/2020		   Send Admin SRTs to ERP
V.1.2	 Karthik Pedditi	06/04/2021		   Removing this class as part of CT2-720
*********************************************************************************/

public class FSL_CL_AdminSRTApi {
	
    /* Method to prepare request joson */
   /* public static String getRequestApi(String workOrderId){
        //Creating an instance for RequestWrapper which will hold request json
        FSL_CL_AdminSRT_RequestWrapper requestApi = new FSL_CL_AdminSRT_RequestWrapper();
        
        
        // Holds request Header class attributes
        requestApi.Header  = new FSL_CL_AdminSRT_RequestWrapper.Header();
        requestApi.Header.Sender  = new FSL_CL_AdminSRT_RequestWrapper.Sender();
        requestApi.Header.Target  = new FSL_CL_AdminSRT_RequestWrapper.Target();
        requestApi.Header.Location  = new FSL_CL_AdminSRT_RequestWrapper.Location();
        
         // Holds request Data area class attributes
        requestApi.DataArea = new FSL_CL_AdminSRT_RequestWrapper.DataArea();
        List<FSL_CL_AdminSRT_RequestWrapper.SRTs> lstAdminSRTs = new List<FSL_CL_AdminSRT_RequestWrapper.SRTs>();
       
        //Assigning Service name
        requestApi.Header.Sender.ServiceName ='SRTData';
        //Assigning Sender Id
        requestApi.Header.Sender.SenderID ='Guidanz';
        //Assigning Target Id
        requestApi.Header.Target.TargetID = 'BMS';
        
        // Fetching work order related attributes where workOrder Id equal to workOrderId
        WorkOrder objWorkOrder = [SELECT Id, WorkOrderNumber, Shop_Work_Order__c, ServiceTerritory.Location_Code__c,
                                  		Make__c, Model__c, 
                                  		Asset.Engine_Family_Code__c
                                  FROM WorkOrder
                                  Where Id =: workOrderId];
        
        //Assigning ServiceTerritory.Location_Code__c
        if(objWorkOrder.ServiceTerritory.Location_Code__c.length() > 11){
            requestApi.Header.Location.LocationID = objWorkOrder.ServiceTerritory.Location_Code__c.subString(0,11);
        }else{
            requestApi.Header.Location.LocationID = null;
        }
        //Assigning WorkOrderNumber to  GuidanzJobID
        requestApi.DataArea.GuidanzJobID 	= objWorkOrder.WorkOrderNumber;
        //Assigning Shop_Work_Order__c to  ShopWONumber
        requestApi.DataArea.ShopWONumber 	= objWorkOrder.Shop_Work_Order__c;
         //Assigning Make__c to  Make
        requestApi.DataArea.Make		 	= objWorkOrder.Make__c;
         //Assigning Model__c to  Model
        requestApi.DataArea.Model		 	= objWorkOrder.Model__c;
         //Assigning Asset.Engine_Family_Code__c to  EngineFamilyCode
        requestApi.DataArea.EngineFamilyCode= objWorkOrder.Asset.Engine_Family_Code__c;
        //Retrieving SRTs  where service order equal to recordId AND type equal to Admin
        List<FSL_SRT__c> fslSRTs 			= [SELECT Access_Code__c, Name, SRT_Quantity__c, SRT_Time__c, Actual_SRT_Time__c
                                               FROM FSL_SRT__c
                                               WHERE Service_Order__c =: workOrderId AND(Type__c = 'Admin' OR Type__c='Travel') 
                                              ];
        //Will enter into the loop if the srt list size is greater than zero
        if(fslSRTs.size()>0){
            for(FSL_SRT__c objSRTs : fslSRTs ){
                FSL_CL_AdminSRT_RequestWrapper.SRTs adminSRTs = new FSL_CL_AdminSRT_RequestWrapper.SRTs();
                adminSRTs.AccessCode 	= objSRTs.Access_Code__c;
                if(objSRTs.Name!='Travel'){
                    adminSRTs.SRTgroupnum 	= objSRTs.Name.split('-')[0]; //eg Name = 00-901-00
                    adminSRTs.Procedureno 	= objSRTs.Name.split('-')[1]; //eg Name = 00-901-00
                    adminSRTs.Stepnumber 	= objSRTs.Name.split('-')[2]; //eg Name = 00-901-00
                }else if(objSRTs.Name =='Travel'){
                    adminSRTs.SRTgroupnum 	= 'Travel';
                    adminSRTs.Procedureno 	= 'Travel';
                    adminSRTs.Stepnumber 	= 'Travel';
                }
                
                adminSRTs.SRTTime		= String.valueOf(objSRTs.SRT_Time__c);
                adminSRTs.ActualSRTTime = objSRTs.Actual_SRT_Time__c;
                adminSRTs.SRTquantity	= String.valueOf(objSRTs.SRT_Quantity__c);
                lstAdminSRTs.add(adminSRTs);
            }
        }
        
        //Assigni
		requestApi.DataArea.SRTs 	= lstAdminSRTs; 
        String requestJSON = JSON.serialize(requestApi);
        System.debug('requestJSON : '+requestJSON);
        return requestJSON;
    }
    
    public static void adminSRTApi(String workOrderId){
        CG_IP_OAGWrapper requestWrapper = new CG_IP_OAGWrapper();
        requestWrapper.serviceName = '';
        requestWrapper.jsonReqBody = getRequestApi(workOrderId);
        CG_OP_OAGWrapper responseWrapper = CG_WS_Mule.calloutGenericMule(requestWrapper);
        
    }
    
    @future(callOut = true)
    public static void future_adminSRTApi(String workOrderId){
        adminSRTApi(workOrderId);
    } */
    public static void dummy(){
        Integer i=0;
        i++;
    }            
}