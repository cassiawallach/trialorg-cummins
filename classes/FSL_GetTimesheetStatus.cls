/*********************************************************************************************************************************
Name:FSL_GetTimesheetStatus
Copyright © 2021  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class to get timesheet status.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       Raghav Bansal           07/12/2021                      INITIAL DEVELOPMENT 
2.0                         Raghav Bansal           03/16/2021                      Handle the logic for future END Date on timesheets
***********************************************************************************************************************************/
@RestResource(urlMapping='/getTimesheetStatus/*')
global class FSL_GetTimesheetStatus {
    @HttpPost
    global static void getTimesheetStatus() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        ResponseDataWrapper responseWrapper = handleTimesheetStatusRequest(request);
        response.addHeader('Content-Type', 'application/json');
        response.responseBody= Blob.valueOf(JSON.serializePretty(responseWrapper));
    }
    
    private static  ResponseDataWrapper handleTimesheetStatusRequest(RestRequest request) {
        String requestJSON = request.requestBody.toString().trim();
        system.debug('requestJSON++++'+requestJSON);
        FSL_GetTimesheetStatusRequest requestWrapper = (FSL_GetTimesheetStatusRequest) JSON.deserialize(requestJSON, FSL_GetTimesheetStatusRequest.class);
        ResponseDataWrapper responseWrapper = varifyTimesheet(requestWrapper);
        system.debug('responseWrapper++++'+responseWrapper);
        return responseWrapper;
    }
    
    private static  ResponseDataWrapper varifyTimesheet(FSL_GetTimesheetStatusRequest request) {
        ResponseDataWrapper responseWrapper;
        try{
            List<FSL_Additional_Sub_Type__c> ASTList = new List<FSL_Additional_Sub_Type__c>();
            String CSSJobID = request.DataArea.CSSJobID;
            String AssignmentNumber = request.DataArea.AssignmentNumber;
            String ERPJobLineNumber = request.DataArea.ERPJobLineNumber;
            //MV 237- Added By Raghav to handle the future end date logic on timesheets.
            if(String.isNotBlank(ERPJobLineNumber)||String.isNotBlank(AssignmentNumber)){
                List<String> filterList = new List<String>();
                string AST_query = 'SELECT Id,Service_Order__r.WorkOrderNumber,ERP_Job_Line_Number__c,Assignment_Number__c, (SELECT Id FROM Timesheets__r where Status__c =\'new\') FROM FSL_Additional_Sub_Type__c ';
                if(String.isNotBlank(CSSJobID))
                    //Added below line as part of FBI - 383
                    filterList.add(' Service_Order__r.WorkOrderNumber =\'' + String.escapeSingleQuotes(CSSJobID.substringAfter('-')) +'\''); //MV_360 Vijay
                if(String.isNotBlank(ERPJobLineNumber))
                    //Added below line as part of FBI - 383
                    filterList.add(' ERP_Job_Line_Number__c =\'' + String.escapeSingleQuotes(ERPJobLineNumber) +'\'');
                if(String.isNotBlank(AssignmentNumber))
                    //Added below line as part of FBI - 383
                    filterList.add(' Assignment_Number__c =\'' + String.escapeSingleQuotes(AssignmentNumber) +'\'');
                
                if(!filterList.isEmpty()){
                    String whereClause = ' WHERE '+ String.join(filterList, ' AND ');
                    AST_query += whereClause;
                }
                system.debug('AST_query++++'+AST_query);
                //string temp = 'SELECT Id,Service_Order__r.WorkOrderNumber,ERP_Job_Line_Number__c,Assignment_Number__c, (SELECT Id FROM Timesheets__r where Status__c =\''+'new'+'\'' +' AND StartTime__c != null AND (EndTime__c = null OR EndTime__c > TODAY)) FROM FSL_Additional_Sub_Type__c ';
                string temp = 'SELECT Id,Service_Order__r.WorkOrderNumber,ERP_Job_Line_Number__c,Assignment_Number__c, (SELECT Id FROM Timesheets__r where Status__c =\'new\') FROM FSL_Additional_Sub_Type__c ';
                
                for(FSL_Additional_Sub_Type__c additionalSubType: Database.query(AST_query)){
                    //if open timesheet exists
                    if(additionalSubType.Timesheets__r.isEmpty()){
                        responseWrapper = createSuccessResponse(request, 'Y', 'No Open Timesheets, successfully closed Line Number');  
                        additionalSubType.TimesheetFlag__c = true;
                        additionalSubType.Status__c ='Closed';
                    }else{
                        responseWrapper = createSuccessResponse(request,'N', 'Please close the open Timesheets'); 
                        //additionalSubType.TimesheetFlag__c = true;
                        //ASTList.add(additionalSubType);
                    }
                    ASTList.add(additionalSubType);
                }
            }
            if(responseWrapper == null)
                responseWrapper = createErrorResponse(request, 'N', 'r');
            if(!ASTList.isEmpty())
                update ASTList;
            
        }catch(Exception ex){
            responseWrapper = createErrorResponse(request, 'N', 'r');
        }
        return responseWrapper;
    }
    
    private static  ResponseDataWrapper createSuccessResponse(FSL_GetTimesheetStatusRequest request, String LinenumberStatus, String ReturnCodeDescription) {
        String CSSJobID = request.DataArea.CSSJobID;
        String AssignmentNumber = request.DataArea.AssignmentNumber;
        String ERPJobLineNumber = request.DataArea.ERPJobLineNumber;
        return new ResponseDataWrapper('Success', LinenumberStatus, ReturnCodeDescription, CSSJobID, ERPJobLineNumber, AssignmentNumber);
    }
    private static  ResponseDataWrapper createErrorResponse(FSL_GetTimesheetStatusRequest request, String LinenumberStatus, String ReturnCodeDescription) {
        String CSSJobID = request.DataArea.CSSJobID;
        String AssignmentNumber = request.DataArea.AssignmentNumber;
        String ERPJobLineNumber = request.DataArea.ERPJobLineNumber;
        return new ResponseDataWrapper('Error', LinenumberStatus, ReturnCodeDescription, CSSJobID, ERPJobLineNumber, AssignmentNumber);
    }
    
    
    
    
    
    //Response Wrapper    
    global class ResponseDataWrapper {
        public Header Header;
        public DataArea DataArea;
        
        ResponseDataWrapper(String HeaderStatus, String LinenumberStatus, String ReturnCodeDescription, String CSSJobID, String ERPJobLineNumber, String AssignmentNumber){
            this.Header = new Header(HeaderStatus);
            this.DataArea = new DataArea(LinenumberStatus, ReturnCodeDescription, CSSJobID, ERPJobLineNumber, AssignmentNumber);
        }
    }
    
    public class DataArea {
        public String LinenumberStatus;
        public String ReturnCodeDescription;
        public String CSSJobID;
        public String ERPJobLineNumber;
        public String AssignmentNumber;
        
        DataArea(String LinenumberStatus, String ReturnCodeDescription, String CSSJobID, String ERPJobLineNumber, String AssignmentNumber){
            this.LinenumberStatus = LinenumberStatus;
            this.ReturnCodeDescription = ReturnCodeDescription;
            this.CSSJobID = CSSJobID;
            this.ERPJobLineNumber = ERPJobLineNumber;
            this.AssignmentNumber = AssignmentNumber;
        }
    }
    
    public class Header {
        public String Status;
        Header(String Status){
            this.Status = Status;
        }
    }
}