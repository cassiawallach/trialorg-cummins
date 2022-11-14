/*******************************************************************************************************************
Name: FSL_CL_CICOWebService 
Description: Timesheet Trigger Handler class.

Version                 Date                    Author                      Summary Of Change
-----------------------------------------------------------------------------------------------------
1.0                   10/22/2021                Vijay Avula                  Class created for CICO Webservice - CT2-30
2.0                   02/21/2022                Raghav Bansal                Revert the timesheet status in case of integration failure-MV224
3.0                   03/28/2022                Vijay Avula                  Added logic to send different values when ever Current User ERP is 'MOVEX'- MV_440
********************************************************************************************************************/
public without sharing class FSL_CL_CICOService {

    public static Boolean testSuccess = true;
    
    @future(callout=true) 
    public static void sendTimesheets(List<Id> timesheetIdList, String oldMapString){
        Map<String, FSL_Timesheet__c> oldMap = (Map<String, FSL_Timesheet__c>)JSON.deserialize(oldMapString, Map<String, FSL_Timesheet__c>.class);
        List<FSL_Timesheet__c> timesheetList = [SELECT id, Service_Order__r.WorkOrderNumber, Service_Order__r.Shop_Work_Order__c,Service_Order__r.Mileage_Measure__c,
                                                Service_Order__r.Repair_Location__c,Service_Order__r.Type__c,Service_Order__r.Payer__r.FSL_ERP_Customer_Code__c,
                                                Name, Reason__c , Status__c, StartTime__c, EndTime__c, Change_Reason__c,Notes__c,
                                                Resource_Name__c, Type__c, Sub_Type__c, Additional_Sub_Type__r.name,
                                                Start_Address__c, End_Address__c, Mileage__c, Calculated_Mileage__c, Vehicle__c,Shop_Vehicle_Number__r.Name,
                                                Billing_Type__c, Duration_hr__c, Duration_min__c, Additional_Sub_Type__r.Assignment_Number__c,
                                                Additional_Sub_Type__r.ERP_Job_Line_Number__c,Resource__r.IAM_UID__c,Additional_Sub_Type__r.Payer_Account__c,Additional_Sub_Type__r.Sub_Type__c,
                                                Service_Order__r.FSL_Sub_Type__r.Code_Value__c,Service_Order__r.ServiceTerritory.Location_Code__c,Timesheet_Submitted__c,FSL_TimesheetInvalid__c
                                                FROM FSL_Timesheet__c
                                                WHERE Id IN :timesheetIdList
                                                LIMIT 50000];
        User currentUser = [Select ERP__c,User_Location__c,IAM_UID__c,FSL_Primary_Service_Territory_Code__c From User Where Id = :UserInfo.getUserId()];
        List<ERP_Code_Mapping__mdt> erpCodeMapping = [SELECT AdditionalSubType__c FROM ERP_Code_Mapping__mdt WHERE MasterLabel = :currentUser.ERP__c];
        
        FSL_CL_CICOReqWrapper reqObj = new FSL_CL_CICOReqWrapper();
        reqObj.Header = new FSL_CL_CICOReqWrapper.Header();
        reqObj.Header.Sender = new FSL_CL_CICOReqWrapper.Sender('CICOData','Guidanz');
        reqObj.Header.Target = new FSL_CL_CICOReqWrapper.Target(currentUser.ERP__c);
        
        if(currentUser.User_Location__c != null){
            //Movex MV_440
            if(currentUser.ERP__c != 'BMS'){
                if(currentUser.FSL_Primary_Service_Territory_Code__c != null){
                    String[] splitRes = currentUser.FSL_Primary_Service_Territory_Code__c.split('-');
                    reqObj.Header.Location = new FSL_CL_CICOReqWrapper.Location(currentUser.User_Location__c + '-' + splitRes[1]);
                } else{
                    reqObj.Header.Location = new FSL_CL_CICOReqWrapper.Location(currentUser.User_Location__c);
                }
            } else {
                reqObj.Header.Location = new FSL_CL_CICOReqWrapper.Location(currentUser.User_Location__c.left(11));
            }//Movex MV_440
        } else{
            reqObj.Header.Location = new FSL_CL_CICOReqWrapper.Location('');
        }
        
        reqObj.DataArea = new FSL_CL_CICOReqWrapper.DataArea();
        
        for(FSL_Timesheet__c timesheet:timesheetList){
            FSL_CL_CICOReqWrapper.Timesheet timesheetObj = new FSL_CL_CICOReqWrapper.Timesheet();
            //timesheetObj.WorkOrderNumber = 'DEV-'+ timesheet.Service_Order__r.WorkOrderNumber;
            String SourceType = System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                timesheetObj.WorkOrderNumber = timesheet.Service_Order__r.WorkOrderNumber;
                system.debug('WoNumber:'+timesheetObj.WorkOrderNumber);
            } else {
                timesheetObj.WorkOrderNumber = SourceType.right(3)+'-'+timesheet.Service_Order__r.WorkOrderNumber;
                system.debug('WoNumber:'+timesheetObj.WorkOrderNumber);
            }
            timesheetObj.ShopWorkOrder = timesheet.Service_Order__r.Shop_Work_Order__c != null ? timesheet.Service_Order__r.Shop_Work_Order__c : '';
            timesheetObj.RepairLocation = timesheet.Service_Order__r.Repair_Location__c != null ? timesheet.Service_Order__r.Repair_Location__c : '';
            timesheetObj.TimesheetNumber = timesheet.Name;
            timesheetObj.Reason = timesheet.Reason__c != null ? timesheet.Reason__c : '';
            //timesheetObj.Status = timesheet.Status__c != null ? timesheet.Status__c : '';
            // timesheetObj.Status = timesheet.Timesheet_Submitted__c ? 'Submitted' : (oldMap.get(timesheet.Id).Status__c != null ? oldMap.get(timesheet.Id).Status__c : '');
            timesheetObj.Status = timesheet.FSL_TimesheetInvalid__c ?'Invalid' : timesheet.Timesheet_Submitted__c ? 'Submitted' : (oldMap.get(timesheet.Id).Status__c != null ? oldMap.get(timesheet.Id).Status__c : '');
      
                
            
            timesheetObj.StartTime = timesheet.StartTime__c != null ? string.valueOfGmt(timesheet.StartTime__c) : '';
            timesheetObj.EndTime = timesheet.EndTime__c != null ? string.valueOfGmt(timesheet.EndTime__c) : '';
            timesheetObj.hrDuration = timesheet.Duration_hr__c != null ? string.valueOf(timesheet.Duration_hr__c) : '';
            timesheetObj.minDuration = timesheet.Duration_min__c != null ? string.valueOf(timesheet.Duration_min__c) : '';
            timesheetObj.ChangeReason = timesheet.Change_Reason__c != null ? timesheet.Change_Reason__c : '';
            timesheetObj.Notes = timesheet.Notes__c != null ? timesheet.Notes__c : '';
            timesheetObj.ResourceName = timesheet.Resource_Name__c != null ? timesheet.Resource_Name__c : '';
            timesheetObj.ResourceWWID = timesheet.Resource__r.IAM_UID__c != null ? timesheet.Resource__r.IAM_UID__c :'';
            timesheetObj.ApproverWWID = currentUser.IAM_UID__c != null ? currentUser.IAM_UID__c :'';
            //Movex MV_440
            if(currentUser.ERP__c != 'BMS'){
                
                timesheetObj.SubType= timesheet?.Service_Order__r?.FSL_Sub_Type__r?.Code_Value__c != null ? timesheet.Service_Order__r.FSL_Sub_Type__r.Code_Value__c : '';
                timesheetObj.PayerAccount = timesheet.Service_Order__r?.Payer__r?.FSL_ERP_Customer_Code__c != null ? timesheet.Service_Order__r.Payer__r.FSL_ERP_Customer_Code__c : '';
            } else{
                
                timesheetObj.SubType= timesheet.Sub_Type__c != null ? timesheet.Sub_Type__c : '';
                timesheetObj.PayerAccount = timesheet.Additional_Sub_Type__r?.Payer_Account__c != null ? timesheet.Additional_Sub_Type__r.Payer_Account__c : '';
            }
            //Movex MV_440
            timesheetObj.Type= timesheet.Service_Order__r?.Type__c != null ? timesheet.Service_Order__r.Type__c: '';
            if(erpCodeMapping !=null && !erpCodeMapping.isEmpty()){
                if(erpCodeMapping[0].AdditionalSubType__c == 'SubType'){
                    timesheetObj.AdditionalSubType = timesheetObj.SubType;
                } else{
                    timesheetObj.AdditionalSubType = timesheetObj.PayerAccount;
                }
            } 
            //timesheetObj.AdditionalSubType= timesheet.Additional_Sub_Type__r?.name != null ? timesheet.Additional_Sub_Type__r.name : '';
            
            timesheetObj.AssignmentNumber= timesheet.Additional_Sub_Type__r?.Assignment_Number__c != null ? timesheet.Additional_Sub_Type__r.Assignment_Number__c : '';
            timesheetObj.LineNumber= timesheet.Additional_Sub_Type__r?.ERP_Job_Line_Number__c != null ? timesheet.Additional_Sub_Type__r.ERP_Job_Line_Number__c : '';
            timesheetObj.BillingType= timesheet.Billing_Type__c != null ? timesheet.Billing_Type__c : '';
            //timesheetObj.Vehicle= timesheet.Vehicle__c != null ? timesheet.Vehicle__c : '';
            timesheetObj.Vehicle= timesheet.Shop_Vehicle_Number__r?.Name != null ? String.valueOf(timesheet.Shop_Vehicle_Number__r.Name) : (timesheet.Vehicle__c!=null? String.valueOf(timesheet.Vehicle__c):'');
            //timesheetObj.Mileage= timesheet.Mileage__c != null ? String.valueOf(timesheet.Mileage__c) : '';
            timesheetObj.Mileage= timesheet.Mileage__c != null ? String.valueOf(timesheet.Mileage__c) :timesheet.Calculated_Mileage__c!=null? String.valueOf(timesheet.Calculated_Mileage__c):'';
            timesheetObj.MileageMeasure= timesheet.Service_Order__r.Mileage_Measure__c != null ? timesheet.Service_Order__r.Mileage_Measure__c : '';
            //timesheetObj.MileageMeasure= timesheet.Calculated_Mileage__c != null ? String.valueOf(timesheet.Calculated_Mileage__c) : '';
            timesheetObj.StartAddress= timesheet.Start_Address__c != null ? timesheet.Start_Address__c : '';
            timesheetObj.EndAddress= timesheet.End_Address__c != null ? timesheet.End_Address__c : '';
            reqObj.DataArea.Timesheets.add(timesheetObj);
        }
        System.debug('@@@Req Body:'+JSON.serialize(reqObj));
        
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        CG_OP_OAGWrapper resWrapper;
        String accessToken;
        final String SERVICE_NAME = 'FSL_CL_CICOWebService';
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection(SERVICE_NAME);
        
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(conDetails.AuthEnv__c,SERVICE_NAME);
        accesstoken = accessTokenOPWrap.accessToken;
        reqWrapper.jsonReqBody = JSON.serialize(reqObj);
        reqWrapper.serviceName = SERVICE_NAME;
        reqWrapper.methodType = conDetails.Method_Type__c;
        reqWrapper.endPoint = conDetails.End_Point__c;
        //Send Request
        resWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
        System.debug('###RES:'+ resWrapper);
        
        //Stop trigger execution
        FSL_CL_TimesheetTriggerHandler.runTrigger = false;
        if(!resWrapper.exceptionFlag && resWrapper.response != null){
            if(Test.isRunningTest() && !testSuccess){
                String body = '{"Header": { "Status": "SUCCESS", "ReturnCodeDescription": "Time Entries processed Successfully", "Location": { "LocationID": "02850-02991" }},' +
                    '"DataArea": { "Timesheets": [{"TimesheetNumber": "' + timesheetList[0].name + '","ReturnCodeDescription": "Error proccessing Time Entry ","Status": "ERROR"}]}}';
                resWrapper.response.setBody(body);
            } else if(Test.isRunningTest() && testSuccess){
                String body = '{"Header": { "Status": "SUCCESS", "ReturnCodeDescription": "Time Entries processed Successfully", "Location": { "LocationID": "02850-02991" }},' +
                    '"DataArea": { "Timesheets": [{"TimesheetNumber": "' + timesheetList[0].name + '","ReturnCodeDescription": "Proccessing Successfull","Status": "SUCCESS"}]}}';
                resWrapper.response.setBody(body);
            }
            if(String.isNotEmpty(resWrapper.response.getBody())){
                try{
                    FSL_CL_CICOResWrapper resObj = (FSL_CL_CICOResWrapper)JSON.deserialize(resWrapper.response.getBody(),FSL_CL_CICOResWrapper.class);
                    if(resObj.DataArea != null && !resObj.DataArea.Timesheets.isEmpty()){
                        Map<String,String> timesheetErrorNameMap = new Map<String,String>();
                        Set<String> timesheetSuccessNameSet = new Set<String>();
                        for(FSL_CL_CICOResWrapper.Timesheet timesheet: resObj.DataArea.Timesheets){
                            if(timesheet.Status == 'SUCCESS'){
                                timesheetSuccessNameSet.add(timesheet.TimesheetNumber);    
                            }
                            else {
                                timesheetErrorNameMap.put(timesheet.TimesheetNumber,timesheet.ReturnCodeDescription);    
                            }
                        }
                        if(!timesheetErrorNameMap.keySet().isEmpty() || !timesheetSuccessNameSet.isEmpty()){
                            Id submittedTimesheetRecordTypeID = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Submitted_Timesheet').getRecordTypeId();
                            List<FSL_Timesheet__c> timesheets = [Select id,name From FSL_Timesheet__c Where Name IN :timesheetErrorNameMap.KeySet() OR Name IN :timesheetSuccessNameSet];
                            for(FSL_Timesheet__c timesheet: timesheets){
                                if(timesheetSuccessNameSet.contains(timesheet.name)){
                                    timesheet.recordTypeId = submittedTimesheetRecordTypeID;
                                    timesheet.Submit_to_ERP__c = false;
                                    timesheet.Timesheet_Submitted__c = true;
                                    timesheet.Error_Message__c  = '';
                                } else if(timesheetErrorNameMap.containsKey(timesheet.name)){
                                    timesheet.Status__c = oldMap.get(timesheet.Id).Status__c;
                                    timesheet.Error_Message__c = timesheetErrorNameMap.get(timesheet.name);
                                    timesheet.Submit_to_ERP__c = false;         
                                }      
                            }
                            FSL_CL_TimesheetTriggerHandler.sentToMule = true;
                            update timesheets;
                        }
                    }
                } catch(Exception ex){
                    for(FSL_Timesheet__c timesheet: timesheetList){
                        timesheet.Status__c = oldMap.get(timesheet.Id).Status__c;
                        timesheet.Error_Message__c = ex.getMessage();
                        timesheet.Submit_to_ERP__c = false;

                    }
                    update timesheetList;
                }
            }
        }else{   //Raghav:mv-224 : to revert the timesheet status in case of integration failure
            List<FSL_Timesheet__c> timesheetListtoUpdate = new List<FSL_Timesheet__c>();
            for(FSL_Timesheet__c timesheet: timesheetList){
                FSL_Timesheet__c TMSObj  = new FSL_Timesheet__c(
                    Id=timesheet.Id, 
                    Status__c = oldMap.get(timesheet.Id).Status__c,
                    Submit_to_ERP__c = False,
                    Error_Message__c  = resWrapper.exceptionMessage);
                timesheetListtoUpdate.add(TMSObj);
            }
            update timesheetListtoUpdate;
        }
    }
}