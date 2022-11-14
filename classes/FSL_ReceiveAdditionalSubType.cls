/*********************************************************************************************************************************
Name:FSL_ReceiveAdditionalSubType
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Additional Sub-Type from MOVEX.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       PiyushR                 8/25/2020                       INITIAL DEVELOPMENT
2.0 -                       Karthik Pedditi         10/15/2021                      If ‘SenderID' = “MOVEX-UK“ then ‘Name’ = “Assignment Number - Payer Account: Payer Name“
3.0 -                       Vijay Avula				3/11/2022						Logic changed to differenciate adding of Additional subtype based on Movex and Movex-Uk sender Id                     
***********************************************************************************************************************************/

@RestResource(urlMapping='/additionalsubtype/*')
//https://cumminscss--gdnzdev.my.salesforce.com/services/apexrest/additionalsubtype
global class FSL_ReceiveAdditionalSubType {
   
    @HttpPost
    global static void handleAdditionalSubtype() {
        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        rw = FSL_ReceiveAdditionalSubType.processAdditionalSubtype(request);
        response.addHeader('Content-Type', 'application/json');
        response.responseBody= Blob.valueOf(JSON.serializePretty(rw));
    }
   
    public static  ResponseDataAreaWrapper processAdditionalSubtype(RestRequest request) {
        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        try {
            String requestJSON = request.requestBody.toString().trim();
            System.debug('::: Request Body = '+requestJSON);
           
            FSL_ReceiveAdditionalSubTypeWrapper wrapper = new FSL_ReceiveAdditionalSubTypeWrapper();
            wrapper = (FSL_ReceiveAdditionalSubTypeWrapper) JSON.deserialize(requestJSON, FSL_ReceiveAdditionalSubTypeWrapper.class);
            rw = executeAdditionalSubtype(wrapper);
        } catch(Exception ex) {
            System.debug('::: Exception in processAdditionalSubtype = '+ex.getStackTraceString());
        }
        System.debug('::: response rw = '+rw);
        return rw;
    }
   
    public Static ResponseDataAreaWrapper executeAdditionalSubtype(FSL_ReceiveAdditionalSubTypeWrapper reqWrapper) {
        String results;
        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        Header rh = new Header();
        DataArea rd = new DataArea();
        List<DataArea>  DataAreaList = new List<DataArea>();
        WorkOrder wo;
        String respCSSJobID=reqWrapper.DataArea.CSSJobID;
        String respERPWONumber=reqWrapper.DataArea.ERPWONumber;
        try {
            List<FSL_Additional_Sub_Type__c > addSubTypeList = new List<FSL_Additional_Sub_Type__c >();
            if(reqWrapper != null) {
                System.debug('::: Request Wrapper = '+reqWrapper.DataArea.CSSJobID);
               //TW-45 Karthik Pedditi
                String workorderNum;
                String SourceType = System.Label.FSL_Source_Environment_Type;
                if(SourceType == 'GZEVLPRD' || Test.isRunningTest())  {
                workorderNum = reqWrapper.DataArea.CSSJobID;
                system.debug('::: WoNumber:'+workorderNum);
                } else {
                String jobId = reqWrapper.DataArea.CSSJobID;
                workorderNum = jobId.substringAfter('-');
                system.debug('::: JobId:'+workorderNum);
                system.debug('::: RequestJobId:'+jobId);
                }
               //TW-45 Karthik Pedditi
                //String workorderNum = reqWrapper.DataArea.CSSJobID;
               
                if(workorderNum != null) {
                    List<WorkOrder> woList = [Select Id, WorkOrderNumber From WorkOrder where WorkOrderNumber =: workorderNum];
                    if(woList.isEmpty()) {
                        rh.Status='ERROR';
                        rh.ReturnCodeDescription='Service Order does not exist';
                       
                        rd.Status='ERROR';
                        rd.ReturnCodeDescription='Service Order does not exist';
                        rd.CSSJobID=respCSSJobID;
                        rd.ERPWONumber=respERPWONumber;
                        DataAreaList.add(rd);
                        rw.Header=rh;
                        rw.DataArea=DataAreaList;
                       
                        return rw;
                    }
                    wo = woList[0];
                    //CT2-1151 start
                    List<FSL_Additional_Sub_Type__c> existingSubType = [SELECT Id,ERP_Job_Line_Number__c,Assignment_Number__c
                                                                        FROM FSL_Additional_Sub_Type__c
                                                                        Where Service_Order__c = :wo.Id];
                    Map<String,FSL_Additional_Sub_Type__c> mapLineNumberToAddSubType = new Map<String,FSL_Additional_Sub_Type__c>();
                    Map<String,FSL_Additional_Sub_Type__c> mapAssignmentNumberToAddSubType = new Map<String,FSL_Additional_Sub_Type__c>();
                   
                    for(FSL_Additional_Sub_Type__c subType :existingSubType){
                        mapLineNumberToAddSubType.put(subType.ERP_Job_Line_Number__c,subType);  
                        mapAssignmentNumberToAddSubType.put(subType.Assignment_Number__c,subType); //MV-250
                    }
                   
                    FSL_Additional_Sub_Type__c addSubType = new FSL_Additional_Sub_Type__c();
                                       
                    //CT2-1151 end
                    //Karthik Pedditi 10/15/2021 Change - If ‘SenderID' = “MOVEX-UK“ then ‘Name’ = “Assignment Number - Payer Account: Payer Name“                  
                    List<Account> accRec=new List<Account>();
                   
                    if(reqWrapper.Header.Sender.SenderID == 'MOVEX-UK') {
                        accRec=[SELECT Id,Name,FSL_Payer_Name__c,FSL_ERP_Customer_Code__c from Account WHERE FSL_ERP_Customer_Code__c=:reqWrapper.DataArea.PayerAccount+'-UK' LIMIT 1]; //TW-116 Karthik Pedditi Payer Name changes
                        if(accRec.isEmpty()) {
                           accRec=[SELECT Id,Name,FSL_Payer_Name__c,FSL_ERP_Customer_Code__c from Account WHERE FSL_ERP_Customer_Code__c=:reqWrapper.DataArea.PayerAccount LIMIT 1]; //TW-116 Karthik Pedditi Payer Name changes
                        }
                        //MV-250 Start
                        if(reqWrapper.DataArea.AssignmentNumber != null && mapAssignmentNumberToAddSubType.containsKey(reqWrapper.DataArea.AssignmentNumber)){
                            addSubType = mapAssignmentNumberToAddSubType.get(reqWrapper.DataArea.AssignmentNumber);    
                        }//MV-250 End
                        addSubType.Name = reqWrapper.DataArea.AssignmentNumber+'-'+reqWrapper.DataArea.PayerAccount+': '+accRec[0].Name;  //TW-116 Karthik Pedditi Payer Name changes
                    } else  {
                        //MV-250 Start
                        if(reqWrapper.DataArea.ERPJobLineNumber != null && mapLineNumberToAddSubType.containsKey(reqWrapper.DataArea.ERPJobLineNumber)){
                            addSubType = mapLineNumberToAddSubType.get(reqWrapper.DataArea.ERPJobLineNumber);    
                        }//MV-250 End
                        addSubType.Name = reqWrapper.DataArea.ERPJobLineNumber+'-'+reqWrapper.DataArea.PrimarySubType;  
                    }
                    addSubType.Service_Order__c = wo.Id;
                    if(reqWrapper.DataArea.PayerAccount != null) {
                        addSubType.Payer_Account__c = reqWrapper.DataArea.PayerAccount;
                    }
                    if(reqWrapper.DataArea.AssignmentNumber!=null) {
                        addSubType.Assignment_Number__c = reqWrapper.DataArea.AssignmentNumber;
                    }
                    if(reqWrapper.DataArea.PrimarySubType != null) {
                        addSubType.Primary__c = true;
                        addSubType.Sub_Type__c = reqWrapper.DataArea.PrimarySubType;
                    }
                    if(reqWrapper.DataArea.ERPJobLineNumber != null) {
                        addSubType.ERP_Job_Line_Number__c = reqWrapper.DataArea.ERPJobLineNumber;
                    }
                    if(reqWrapper.DataArea.Status != null) {
                        addSubType.Status__c = reqWrapper.DataArea.Status;
                    }
                    addSubTypeList.add(addSubType);
                   
                    Set<String> payerAccounts=new  Set<String>();
                    for(FSL_ReceiveAdditionalSubTypeWrapper.AdditionalSubTypes subType : reqWrapper.DataArea.AdditionalSubTypes) {
                        String appUK=subType.PayerAccount+'-UK';   // considering both values(Normal + UK) TW-116
                        payerAccounts.add(subType.PayerAccount);
                        payerAccounts.add(appUK);
                    }
                   
                    Map<String,String> mapGetPayerName=new Map<String,String>();
                    //  List<Account> getAccountsMovUk=[SELECT Id,FSL_Payer_Name__c,FSL_ERP_Customer_Code__c from Account WHERE FSL_Source_ERP__c='MOVEX-UK'];
                    for(Account acc:[SELECT Id,Name,FSL_Payer_Name__c,FSL_ERP_Customer_Code__c from Account WHERE FSL_Source_ERP__c='MOVEX-UK' AND FSL_ERP_Customer_Code__c IN:payerAccounts]){
                        mapGetPayerName.put(acc.FSL_ERP_Customer_Code__c,acc.Name); //TW-116 Karthik Pedditi Payer Name changes
                    }
                    String payName;
                    for(FSL_ReceiveAdditionalSubTypeWrapper.AdditionalSubTypes subType : reqWrapper.DataArea.AdditionalSubTypes) {
                        FSL_Additional_Sub_Type__c newAddSubType = new FSL_Additional_Sub_Type__c();
                        //Karthik Pedditi 10/15/2021
                        if(reqWrapper.Header.Sender.SenderID == 'MOVEX-UK') {
                        //MV-250 Start
                            if(subType.AssignmentNumber != null && mapAssignmentNumberToAddSubType.containsKey(subType.AssignmentNumber)){
                            newAddSubType = mapAssignmentNumberToAddSubType.get(subType.AssignmentNumber);    
                        }//MV-250 End
                            //TW-116 Karthik Pedditi
                            String getUK=subType.PayerAccount+'-UK';
                            payName=mapGetPayerName.get(getUK);
                            
                            if(payName==null){
                                payName=mapGetPayerName.get(subType.PayerAccount);
                            }
                            newAddSubType.Name =subType.AssignmentNumber+'-'+subType.PayerAccount+': '+ payName;
                            //TW-166 End
                        } else  {
                        //MV-250 Start
                            if(subType.ERPJobLineNumber != null && mapLineNumberToAddSubType.containsKey(subType.ERPJobLineNumber)){
                            newAddSubType = mapLineNumberToAddSubType.get(subType.ERPJobLineNumber);    
                        }//MV-250 End
                            newAddSubType.Name = subType.ERPJobLineNumber+'-'+subType.SubType;
                        }
                        newAddSubType.Service_Order__c = wo.Id;
                        newAddSubType.Sub_Type__c = subType.SubType;
                        newAddSubType.Assignment_Number__c = subType.AssignmentNumber;
                        newAddSubType.ERP_Job_Line_Number__c = subType.ERPJobLineNumber;
                        newAddSubType.Payer_Account__c = subType.PayerAccount;
                        newAddSubType.Status__c = subType.Status;
                       
                        addSubTypeList.add(newAddSubType);
                    }
                }
               
                if(!addSubTypeList.isEmpty()) {
                    //insert ;
                    //CT2-1151 changed from insert to Upsert
                    Database.UpsertResult[] saveResults = Database.upsert(addSubTypeList);
                    if(saveResults[0].isSuccess()) {
                        rh.Status='SUCCESS';
                        rh.ReturnCodeDescription='Record processed successfully';
                       
                        rd.Status='SUCCESS';
                        rd.ReturnCodeDescription='Record processed successfully';
                        rd.CSSJobID=respCSSJobID;
                        rd.ERPWONumber=respERPWONumber;
                        DataAreaList.add(rd);
                        rw.Header=rh;
                        rw.DataArea=DataAreaList;
                   
                    } else {
                        rh.Status='ERROR';
                        rh.ReturnCodeDescription='Record Failed to Insert';
                       
                        rd.Status='ERROR';
                        rd.ReturnCodeDescription='Record Failed to Insert';
                        rd.CSSJobID=respCSSJobID;
                        rd.ERPWONumber=respERPWONumber;
                        DataAreaList.add(rd);
                        rw.Header=rh;
                        rw.DataArea=DataAreaList;
                     
                    }
                }
               
            }
        } catch(Exception ex) {
            System.debug('::: Exception in executeAdditionalSubtype = '+ex.getStackTraceString());
                        rh.Status='ERROR';
                        rh.ReturnCodeDescription='Record Failed to Insert';
                       
                        rd.Status='ERROR';
                        rd.ReturnCodeDescription='Record Failed to Insert';
                        rd.CSSJobID=respCSSJobID;
                        rd.ERPWONumber=respERPWONumber;
                        DataAreaList.add(rd);
                        rw.Header=rh;
                        rw.DataArea=DataAreaList;
        }
       
        return rw;
    }
   
    //Response Wrapper    
    global class ResponseDataAreaWrapper {
        public Header Header;
        public List<DataArea> DataArea;
    }
   
    public class DataArea {
        public String Status;
        public String ReturnCodeDescription;
        public String CSSJobID;
        public String ERPWONumber;
    }
   
    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }
}