/**********************************************************************
Name: FSL_WO_Comment_Inbound
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: 
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0     Harsha              14-Feb-2020    INITIAL DEVELOPMENT  
2.0     Harsha Ragam        09/08/2020     Mule Api Changes for BMS-WO Comment Inound
3.0     Karthik Pedditi     02/23/2022     TW-84 Job Notes Integration
4.0     Karthik Pedditi     03/24/2022     TW-87 Error Logging and Error Handling
5.0     Prasanna Savalam    05/27/2022     Changes to add Named credentials
***********************************************************************/
public class FSL_WO_Comment_Inbound {
    
    //Special receive Token Method to enable switch between BMS Instances without impacting other Integrations
    public static String Sender = 'CSS';
    public static String TargetERP;
    public static String responseMsg;
    
    //Method to call WOComment Inbound
    public static FSL_WOCommentInboundJson2Apex callWOCommentInboundService(String location,String WorkOrderNumber,String OrderType,String BMSReferenceNumber,String CommentType,String Comment,String CreateUser,String ChangeUser, String CreateDate, String ChangeDate){
        FSL_WOCommentInboundJson2Apex commentInboundDetails;
        String endPointURL;
        string message;
        FSL_IP_NamedCredentialWrapper reqWrapper = null; //Added by Prasanna for ROAD -366
        CG_OP_OAGWrapper returnWrapper = null; //Added by Prasanna for ROAD -366
        String jsonResponse = '';
        try {

            // Added by Prasanna For ROAD-366
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Workorders';
            reqWrapper.Path = '/workorder/comments';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            system.debug('endPointURL Wo Comment' +  ' ' + reqWrapper.endPoint);
            
            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            if(location != null && location != '')
                locArray = location.split('-');
            if(locArray != null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }
            if(Comment == null || Comment == ''){
                Comment = ' ';
            }
            //Added for Phoen-287
            else{             
                Comment = addEscapeChar(Comment);
            }
            system.debug('Comment***:'+Comment);
            String woNumber;
            String SourceType= System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                woNumber = WorkOrderNumber;
                system.debug('WoNumber:'+woNumber);
            } else {
                woNumber = SourceType.right(3)+'-'+WorkOrderNumber;
                system.debug('WoNumber:'+woNumber);
            }
           
            User usr = [SELECT Id,ERP__c FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
            String TargetERP;
            TargetERP = (String)usr.ERP__c;
            
            //Building Request Body or request String 
            string JSONReq = '{ "Header": {  "Sender": {   "ServiceName": "SetComment",   "SenderID": "CSS"  },"Target": { "TargetID": "'+TargetERP+'" },  "Location": {   "LocationID": "'+location+'"  } }, "DataArea": {  "CSSJobID": "'+woNumber+'",  "DistributorNumber": "'+distrCode+'",  "Branchnumber": "'+brnchCode+'",  "OrderType": "'+OrderType+'",  "BMSReferenceNumber": "'+BMSReferenceNumber+'",  "CommentType": "'+CommentType+'",  "Comment": "'+Comment+'" ,  "CreateUser": "'+CreateUser+'" ,  "CreateDate": "'+CreateDate+'" ,  "ChangeUser": "'+ChangeUser+'" ,  "ChangeDate": "'+ChangeDate+'" }}';             
            JSONReq = JSONReq.replaceAll('(\\r|\\n)+', '  '); 
           
            System.debug('request JSON ======'+JSONReq);
          
           // Added by Prasanna For ROAD-366
            reqWrapper.jsonReqBody=JSONReq;
            reqWrapper.WorkOrder = woNumber;
            if(reqWrapper != null){
                returnWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
                 system.debug('StatusCode>>>>: '+returnWrapper.response.getStatusCode());
                 system.debug('Status>>>>: '+returnWrapper.response.getStatus());
                 system.debug('Response body>>>:'+returnWrapper.response.getbody());
                 jsonResponse = returnWrapper.response.getbody();
            }
           
            //Deserialize the response from Bms web service respose__c field to the Wrapper Class 
            commentInboundDetails = (FSL_WOCommentInboundJson2Apex)JSON.deserializeStrict(jsonResponse,FSL_WOCommentInboundJson2Apex.class);
            system.debug('WOComment Details >>>>'+commentInboundDetails.Header +'*************'+commentInboundDetails);
            system.debug('success_commentInboundDetails >>>>'+commentInboundDetails);
            
            List<FSL_Integration_Error_Log__c> errorLogRecords = new List<FSL_Integration_Error_Log__c>();

            If(errorLogRecords.size()>0){
                Database.SaveResult[] results = Database.insert(errorLogRecords, false);
            }
            system.debug('commentInboundDetails'+commentInboundDetails);
            return commentInboundDetails;
        } catch(Exception ex) {
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                if(message.contains('timed out')) {
                    FSL_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', 'RESPONSE IS NULL', 'BMS');
                }
                else {
                    FSL_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', returnWrapper.response==null?'RESPONSE IS NULL':jsonResponse, 'BMS');
                }
            }
        }
        return null;
    }
   /** Charan : Start for Phoen-287**/
    public static string addEscapeChar(string inputString) {
        if(inputString.contains('\\') ){
            string addbackslash = '\\\\';
            inputString = inputString.replace('\\',addbackslash);
            system.debug('inputString  :::' +inputString);
        }
        if(inputString.contains('"') ){
            string adddoublecodes = '\\"';
            inputString = inputString.replace('"',adddoublecodes);
            system.debug('inputString  :::' +inputString);
        }
        system.debug('Actual inputString  :::' +inputString);
        return inputString;
    } 
    /**Phoen-287 Code ends **/
}