/**********************************************************************
Name: CSS_FN_Triage_V4
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of Triage functionality to
            handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION       AUTHOR                 DATE                DETAIL                                 
1.0     Surender Madipeddi        01/30/2020     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_FN_Triage_V4 {

    /*
     * This method is used for creating/Updating CSSJob using IA record
     * 
     */
    public void createUpdateIAGuidanzJob() {
        System.debug('#### entered into createUpdateIAGuidanzJob of CSS_FN_Triage_V4 method ####');
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        WrapperInput wrapperObj;
        CSS_FN_Triage_V4 tgFNObj = new CSS_FN_Triage_V4();
        FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
        try{
            wrapperObj = tgFNObj.validateCreateGuidanzJob(req);
            if(wrapperObj.status =='Error' || wrapperObj.status !='Processed'){
                resJSON = prepareResWrapperForCreateGuidanzJob(wrapperObj);
            }else{
                resJSON = tgFNObj.createUpdateIACSSJob(wrapperObj);
            }
            css_utility.prepareRESTResponse(resJSON, 200);
        }catch(Exception ex){
            System.debug('in catch of createUpdateIACSSJob of CSS_FN_Triage_V4>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            tgFNObj=null;
        }
    }


    public WrapperInput validateCreateGuidanzJob(RestRequest request){
        System.debug('#### entered into validateCreateGuidanzJob of CSS_FN_Triage_V4 method ####');
        FSL_CL_IA_CreateServiceRequestAPIReqJSON reqJSON;
        WrapperInput wrapperObj;
        String jSONRequestBody = null;
        try{
            wrapperObj = new WrapperInput();
            jSONRequestBody = request.requestBody.toString().trim();
            reqJSON = FSL_CL_IA_CreateServiceRequestAPIReqJSON.parse(jSONRequestBody);
            System.debug('**** after deserialize reqJSON **** '+reqJSON);

            //Validating request header ServiceName is null or not
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return wrapperObj;
            }
            //No Validation on sender Id, just wrapping with wrapperObj to prepare response
            wrapperObj.senderId = reqJSON.Header.SenderId;

            //Validating request header  is iaserrequestcreation
            if(reqJSON.Header.ServiceName.toLowerCase() != 'iacssjobcreation' && reqJSON.Header.ServiceName.toLowerCase() != 'iaserrequestcreation' 
               && reqJSON.Header.ServiceName.trim().toLowerCase() != 'iawosubmit'){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return wrapperObj;
            }

            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.serviceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.serviceName);

            //Validating request TooldId  is blank/null
            if(reqJSON.Header.toolID == null || reqJSON.Header.toolID.trim() == '' || String.isBlank(reqJSON.Header.toolID) || String.isEmpty(reqJSON.Header.toolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS03-ToolID is blank';
                return wrapperObj;
            }
            wrapperObj.toolID = reqJSON.Header.toolID;

            //Validating IASNumber is blank/null
            if(reqJSON.DataArea.IASNumber == null || reqJSON.DataArea.IASNumber.trim() == '' || String.isBlank(reqJSON.DataArea.IASNumber) || String.isEmpty(reqJSON.DataArea.IASNumber) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS04-IASNumber is blank';
                return wrapperObj;
            }
            wrapperObj.IASNumber =  reqJSON.DataArea.IASNumber;
            wrapperObj.woNumber =  reqJSON.DataArea.woNumber;

            //Here do logic for length of 11 chars
            String userLocFiltered = getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            System.debug('After validations userLocFiltered>>>>>>:'+userLocFiltered);
            /*if(userLocFiltered == null || userLocFiltered.trim() == '' || String.isBlank(userLocFiltered) || String.isEmpty(userLocFiltered)){ //already covered in main class
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS16-UserLocation is blank/invalid';
                return wrapperObj;
            }*/
            wrapperObj.UserLocation = userLocFiltered;
            wrapperObj.status = 'Processed';

        }catch(Exception ex){
            System.debug('in catch of validateCreateGuidanzJob of FSL_CL_IAUtility>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            return wrapperObj;

        }finally{
            reqJSON=null;jSONRequestBody=null;
        }
        return wrapperObj;

    }

    /*
     * This method is used for creating/Updating CSSJob using IA record
     * 
     */
    public FSL_CL_IA_CreateServiceRequestAPIResJSON createUpdateIACSSJob(WrapperInput wrapperObj){
        System.debug('################# entered into createUpdateIACSSJob of CSS_FN_Triage_V4 method ###################');
        FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
        CSS_DataExchange_Parent__c deObj;
        try{
            resJSON = new FSL_CL_IA_CreateServiceRequestAPIResJSON();
            List<CSS_DataExchange_Parent__c> deObjList = new List<CSS_DataExchange_Parent__c>(
                [Select Id, Name, IAS_Number__c, SenderID__c, Version__c, CSS_Job_Number__c, CSS_Enabled__c, PSN__c, SERVICEMODELNAME__c, ERT__c, MAKE__c, MODEL__c, ACCESS__c, User_Location__c, 
                 User_Location_filtered__c, Customer_Company_Name__c, Complaint_Text__c, Request_JSON__c, Response_JSON__c from CSS_DataExchange_Parent__c where IAS_Number__c=:wrapperObj.IASNumber]);
            /*if(deObjList == null || deObjList.size()<=0){ //check this once to remove
                wrapperObj.status = 'Error';
                wrapperObj.statusMsg = 'CSS06-IAS number does not exist in CSS';
                return prepareResWrapperForCreateGuidanzJob(wrapperObj);
            }*/
            System.debug('wrapperObj>>>:'+wrapperObj);
            System.debug('IASNumber>>>:'+wrapperObj.IASNumber+' WONumber:'+wrapperObj.WONumber);
            if(deObjList == null || deObjList.size()<=0){
                /*if(wrapperObj.WONumber !=null && wrapperObj.WONumber.trim() !=''){
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS17-IASNumber in the request does not exist in CSS'; //new code & messge
                    return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                }*/
            }else{
                deObj = deObjList.get(0);
                if( (wrapperObj.IASNumber !=null && (wrapperObj.WONumber ==null || wrapperObj.WONumber.trim() =='')) && deObj !=null && deObj.CSS_Job_Number__c != null 
                   && deObj.CSS_Job_Number__c.trim() != '' && String.isNotBlank(deObj.CSS_Job_Number__c) && String.isNotEmpty(deObj.CSS_Job_Number__c) ){
                    wrapperObj.WONumber = deObj.CSS_Job_Number__c;
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS08-CSS Job already exists for the IA number';
                    return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                }
            }
            System.debug('Existing IASRecord deObj>>>:'+deObj);

            String userIdAdvancedRole = getAdvancedRoleUserId(wrapperObj.senderId, wrapperObj.userLocation);
            System.debug('userIdAdvancedRole>>>>>>:'+userIdAdvancedRole);
            if(userIdAdvancedRole == null || userIdAdvancedRole.trim() == '' || String.isBlank(userIdAdvancedRole) 
               || String.isEmpty(userIdAdvancedRole) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS09-UserLocation does not have Advanced Role in CSS';
                return prepareResWrapperForCreateGuidanzJob(wrapperObj);
            }

            //Job update from Appointment to Intake & 
            //Update IAS record when it exists else create IAS record when it doesn't exist
            if(wrapperObj.WONumber !=null && wrapperObj.WONumber.trim() !=''){
                System.debug('in update block...cssJobNumber>>>:'+wrapperObj.WONumber);
                //Update CSS Job
                List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id,Name,Customer_Name__c,Status__c,General_Symptoms__c,CSS_Job_Location_Code__c,Request_JSON__c,Response_JSON__c,OwnerId,CreatedById,LastModifiedById from css_job_order__c where Name=:wrapperObj.WONumber limit 1]);
                if(jobList.size()<=0){
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS12-CSS Job in the request does not exist in CSS';
                    return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                }else{
                    if(jobList.get(0).Status__c !='Appointment'){
                        wrapperObj.status = 'Error';
                        wrapperObj.returnCodeDescription = 'CSS13-CSS Job in the request is not in apppointment status';
                        return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                    }
                }

                if(deObj !=null){
                    //Update IAS Record
                    deObj = createUpdateIASRecord(wrapperObj, false, deObj);
                }else{
                    //Create IAS Record
                    deObj = createUpdateIASRecord(wrapperObj, true, deObj);
                }

                //Update CSS Job
                String flagMsg = updateIACSSJob(deObj, userIdAdvancedRole, jobList.get(0));
                if(flagMsg !='Success'){
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                    return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                }
                System.debug('CSS Job is updated successfully...cssJobNumber>>>:'+wrapperObj.WONumber);
                wrapperObj.status = 'Success';
                wrapperObj.returnCodeDescription = 'CG02-Guidanz Job is updated successfully';
            }else{
                //Job create with Intake status &
                //Create IAS record
                System.debug('in create block...cssJobNumber>>>:'+wrapperObj.WONumber);

                if(deObj !=null){
                    //Update IAS Record
                    deObj = createUpdateIASRecord(wrapperObj, false, deObj);
                }else{
                    //Create IAS Record
                    deObj = createUpdateIASRecord(wrapperObj, true, deObj);
                }
                //Create IAS Record
                //deObj = createUpdateIASRecord(wrapperObj, true, deObj);

                //Create CSS Job
                String cssJobNumber = createIACSSJob(deObj, userIdAdvancedRole);
                if(cssJobNumber == null){
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                    return prepareResWrapperForCreateGuidanzJob(wrapperObj);
                }
                wrapperObj.WONumber = cssJobNumber;
                wrapperObj.status = 'Success';
                wrapperObj.returnCodeDescription = 'CG01-Guidanz Job is created successfully';
            }
            return prepareResWrapperForCreateGuidanzJob(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of createUpdateIACSSJob of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            return prepareResWrapperForCreateGuidanzJob(wrapperObj);
        }finally{
            wrapperObj=null;
        }
        //return resJSON;
    }

    /*
     * This method is used for saving Req & Res details for tracking
     */ 
    public CSS_DataExchange_Parent__c createUpdateIASRecord(WrapperInput wrapperObj, Boolean isCreate, CSS_DataExchange_Parent__c dataExchangeObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createUpdateIASRecord method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        //List <Account> accList;
        Boolean successFlag = false;
        //CSS_DataExchange_Parent__c dataExchangeObj = null;
        FSL_CL_IA_CreateServiceRequestAPIReqJSON reqJSON;
        try{
            System.debug('Flag isCreate:'+isCreate);
            String jSONRequestBody = RestContext.request.requestBody.toString().trim();
            //System.debug('jSONRequestBody:'+ jSONRequestBody);
            reqJSON = FSL_CL_IA_CreateServiceRequestAPIReqJSON.parse(jSONRequestBody);
            if(isCreate){
                dataExchangeObj = new CSS_DataExchange_Parent__c();
                dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
            }else{
                //dataExchangeObj = [Select Id, Name, IAS_Number__c, SenderID__c, Version__c, CSS_Job_Number__c, CSS_Enabled__c, PSN__c, SERVICEMODELNAME__c, ERT__c, MAKE__c, MODEL__c, ACCESS__c, User_Location__c, 
                //User_Location_filtered__c, Customer_Company_Name__c, Complaint_Text__c, Request_JSON__c, Response_JSON__c from CSS_DataExchange_Parent__c where IAS_Number__c=:wrapperObj.IASNumber];
            }
            dataExchangeObj.Version__c = 'v04';
            dataExchangeObj.CSS_Job_Number__c = null;
            dataExchangeObj.IAS_Number__c = reqJSON.DataArea.iasNumber;
            dataExchangeObj.CSS_Enabled__c = 'Y';
            dataExchangeObj.ServiceName__c = reqJSON.Header.ServiceName;
            dataExchangeObj.ServiceVersion__c = reqJSON.Header.ServiceVersion;
            dataExchangeObj.ToolID__c = reqJSON.Header.ToolID;
            dataExchangeObj.SenderID__c = reqJSON.Header.SenderID;
            dataExchangeObj.TargetID__c = reqJSON.Header.TargetID;
            dataExchangeObj.PSN__c = reqJSON.DataArea.PSN;
            dataExchangeObj.SERVICEMODELNAME__c = reqJSON.DataArea.SERVICEMODELNAME;
            dataExchangeObj.ERT__c = reqJSON.DataArea.ERT;
            dataExchangeObj.MAKE__c = reqJSON.DataArea.MAKE;
            dataExchangeObj.MODEL__c = reqJSON.DataArea.MODEL;
            dataExchangeObj.ACCESS__c = reqJSON.DataArea.ACCESS;
            dataExchangeObj.Created_By__c = reqJSON.Header.SenderID;
            dataExchangeObj.Updated_By__c = reqJSON.Header.SenderID;
            dataExchangeObj.User_Location__c = reqJSON.DataArea.UserLocation;
            dataExchangeObj.User_Location_filtered__c = wrapperObj.UserLocation;
            if(reqJSON.DataArea.CustomerName.length()>255)
                dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName.trim().substring(0, 255);
            else
                dataExchangeObj.Customer_Company_Name__c = reqJSON.DataArea.CustomerName;
            if(reqJSON.DataArea.ComplaintText.length()>4000)
                dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText.trim().substring(0, 4000);
            else
                dataExchangeObj.Complaint_Text__c = reqJSON.DataArea.ComplaintText;
            dataExchangeObj.Request_JSON__c = jSONRequestBody;
            dataExchangeObj.Response_JSON__c = null;  //add Response JSON here

            //dataExchangeObj = assignResDetails(res, dataExchangeObj, 'CG01-IAS record inserted successfully', null);
            //insert/update DataExchange record here
            if(isCreate){
                insert dataExchangeObj;
                dataExchangeObj = [Select Id, Name, IAS_Number__c, SenderID__c, Version__c, CSS_Job_Number__c, CSS_Enabled__c, PSN__c, SERVICEMODELNAME__c, ERT__c, MAKE__c, MODEL__c, ACCESS__c, User_Location__c, 
                                   User_Location_filtered__c, Customer_Company_Name__c, Complaint_Text__c, Request_JSON__c, Response_JSON__c from CSS_DataExchange_Parent__c where Id=:dataExchangeObj.Id];
            }else {
                update dataExchangeObj;
            }
            System.debug('$$$$$$$$$$$$$$$$$$$$ DataExchange record inserted successfully....Id is:'+dataExchangeObj.Id);

            //Update again here inserted record with IASNumber
            /*CSS_DataExchange_Parent__c deObj = [Select Id, Name, Response_JSON__c from CSS_DataExchange_Parent__c where Id=:dataExchangeObj.Id];
            iasNumber = deObj.Name;
            System.debug('before iasNumber>>>>>>>>>>:'+deObj.Name+' deObj.Response_JSON__c>>>:'+deObj.Response_JSON__c);
            deObj.Response_JSON__c = (deObj.Response_JSON__c).replace('"IASNumber":""', '"IASNumber":\"'+deObj.Name+'\"');
            update deObj;
            System.debug('iasNumber>>>>>>>>>>:'+deObj.Name+' deObj.Response_JSON__c>>>:'+deObj.Response_JSON__c); */

            //assignResDetails(res, null, null, 'Y');


        }catch(Exception ex){
            System.debug('in catch of createUpdateIASRecord of CSS_FN_Triage_V4>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        //return reqJSON.DataArea.IASNumber;
        return dataExchangeObj;
    }


    /*
     * This method is used for creating CSS Job using IA record
     */ 
    public static String createIACSSJob(CSS_DataExchange_Parent__c deObj, String userIdAdvancedRole){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into createIACSSJob method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        css_job_order__c jobObj = null;
        List<Account> accountList;
        String cssJobNumber;
        try{
            jobObj = new css_job_order__c();
            jobObj.ESN_IA__c = deObj.PSN__c;
            //jobObj.ESN__c = deObj.PSN__c;
            //jobObj.Service_Model__c = deObj.SERVICEMODELNAME__c;
            //jobObj.Make__c = deObj.MAKE__c;
            //jobObj.Model__c = deObj.MODEL__c;
            jobObj.Customer_Name__c = deObj.Customer_Company_Name__c;
            jobObj.General_Symptoms__c = deObj.Complaint_Text__c;
            jobObj.CSS_Job_Location_Code__c = deObj.User_Location_filtered__c; //User Location filtered
            jobObj.Request_JSON__c = deObj.Request_JSON__c;
            jobObj.Response_JSON__c = deObj.Response_JSON__c;
            jobObj.Status__c = 'Intake';
            jobObj.IsAppointment__c = 'No';

            //assign Account here
            accountList = new List<Account>([Select Id, Name, Location__c, IA_CSSEnabled__c from Account where Location__c=:deObj.User_Location_filtered__c limit 1]); //Location__c??
            if(accountList.size()>0){
                jobObj.Account__c = (accountList.get(0)).Id;
                jobObj.JobLocation__c = (accountList.get(0)).Name;
            }

            //Owner/Queue assigning
            String locQueueStr = 'JQ-'+deObj.User_Location_filtered__c;
            List<Group> queues = new List<Group>([select Id, Name from Group where Type='Queue' AND Name=:locQueueStr]);
            system.debug('queues' + ' ' +queues);
            if(queues.size()>0){
                jobObj.OwnerId  = queues.get(0).Id;
            }
            jobObj.CreatedById = userIdAdvancedRole;
            jobObj.LastModifiedById = userIdAdvancedRole;
            //end

            //add user_location here
            //accountList = new List<Account>([Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c limit 1]);
            //if(accountList.size()>0)
            //jobObj.JobLocation__c = (accountList.get(0)).Name;
            //jobObj.OwnerId = userIdAdvancedRole;
            //jobObj.CreatedById = userIdAdvancedRole;
            //jobObj.LastModifiedById = userIdAdvancedRole;
            insert jobObj;
            css_job_order__c tempJob = [Select Id, Name from css_job_order__c where Id=:jobObj.Id];
            System.debug('After Job insert>>>:'+tempJob);

            //return [Select Id, Name from css_job_order__c where Id=:jobObj.Id].Name;
            //Update CSS Job Number in IA record
            deObj.CSS_Job_Number__c = [Select Id, Name from css_job_order__c where Id=:jobObj.Id].Name;
            System.debug('CSS Job Number is generated successfully...cssJobNumber>>>:'+deObj.CSS_Job_Number__c);
            update deObj;
            cssJobNumber = deObj.CSS_Job_Number__c;

        }catch(Exception ex){
            System.debug('in catch of createIACSSJob of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            jobObj=null;accountList=null;
        }
        return cssJobNumber;
    }

    /*
     * This method is used for creating CSS Job using IA record
     */ 
    public static String updateIACSSJob(CSS_DataExchange_Parent__c deObj, String userIdAdvancedRole, css_job_order__c jobObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateIACSSJob method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accountList;
        String msg;
        try{
            jobObj.ESN_IA__c = deObj.PSN__c;
            //jobObj.ESN__c = deObj.PSN__c;
            //jobObj.Service_Model__c = deObj.SERVICEMODELNAME__c;
            //jobObj.Make__c = deObj.MAKE__c;
            //jobObj.Model__c = deObj.MODEL__c;
            jobObj.Customer_Name__c = deObj.Customer_Company_Name__c;
            jobObj.General_Symptoms__c = deObj.Complaint_Text__c;
            jobObj.CSS_Job_Location_Code__c = deObj.User_Location_filtered__c; //User Location filtered
            jobObj.Request_JSON__c = deObj.Request_JSON__c;
            jobObj.Response_JSON__c = deObj.Response_JSON__c;
            jobObj.Status__c = 'Intake';
            jobObj.IsAppointment__c = 'No';

            //assign Account here
            accountList = new List<Account>([Select Id, Name, Location__c, IA_CSSEnabled__c from Account where Location__c=:deObj.User_Location_filtered__c limit 1]); //Location__c??
            if(accountList.size()>0){
                jobObj.Account__c = (accountList.get(0)).Id;
                jobObj.JobLocation__c = (accountList.get(0)).Name;
            }

            //Owner/Queue assigning
            String locQueueStr = 'JQ-'+deObj.User_Location_filtered__c;
            List<Group> queues = new List<Group>([select Id, Name from Group where Type='Queue' AND Name=:locQueueStr]);
            system.debug('queues' + ' ' +queues);
            if(queues.size()>0){
                jobObj.OwnerId  = queues.get(0).Id;
            }
            //jobObj.CreatedById = userIdAdvancedRole; //commented since it is update
            //jobObj.LastModifiedById = userIdAdvancedRole;
            //end

            //add user_location here
            //accountList = new List<Account>([Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c limit 1]);
            //if(accountList.size()>0)
            //jobObj.JobLocation__c = (accountList.get(0)).Name;
            //jobObj.OwnerId = userIdAdvancedRole;
            //jobObj.CreatedById = userIdAdvancedRole;
            //jobObj.LastModifiedById = userIdAdvancedRole;
            update jobObj;
            deObj.CSS_Job_Number__c = jobObj.Name;
            update deObj;
            msg = 'Success';
        }catch(Exception ex){
            System.debug('in catch of updateIACSSJob of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            msg = ex.getMessage()+'-'+ex.getLineNumber();
        } finally {
            jobObj=null;accountList=null;
        }
        return msg;
    }


    /*
     * This method is not used in IA-AWS
     */ 
    public String getAdvancedRoleUserId(String inputUserId, String userLocation){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAdvancedRoleUserId method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$inputUserId:'+inputUserId);
        List<User> userList;
        try{
            if(inputUserId == null || inputUserId.trim() == '' || String.isBlank(inputUserId) || String.isEmpty(inputUserId) ){
                //if SenderId is blank then do below logic
                System.debug('if inputUserId is null block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                userList = new List<User>([Select Id, User_Location__c from User where User_Location__c=:userLocation and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                if(userList.size()>0)
                    return (userList.get(0)).Id;
                else
                    return null;
            }else{
                //if SenderId & FederationId are not blank
                System.debug('if inputUserId not null block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                userList = new List<User>([Select Id, FederationIdentifier from User where FederationIdentifier=:inputUserId and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                if(userList.size()>0)
                    return (userList.get(0)).Id;
                else{
                    //if FederationId doesn't have records above then do below logic
                    System.debug('FederationId else block...inputUserId>>>:'+inputUserId+' userLocation>>:'+userLocation);
                    userList = new List<User>([Select Id, User_Location__c from User where User_Location__c=:userLocation and isActive=true and Profile.Name like '%Advanced%' limit 1]);
                    if(userList.size()>0)
                        return (userList.get(0)).Id;
                    else
                        return null;
                }
            }
        }catch(Exception ex){
            System.debug('in catch of getAdvancedRoleUserId of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            userList=null;
        }
        return null;
    }

    /*
     * This method is used for getting Primary/Filtered location
     */ 
    public String getFilteredUserLocation(String userLocation){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getFilteredUserLocation method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$userLocation:'+userLocation);
        List<String> locList;
        String userLoc;
        try{
            //Here do logic for length of 11 chars
            //String userLocation = reqJSON.DataArea.UserLocation;
            //locList = userLocation.trim().split(Pattern.quote('|'));
            locList = userLocation.trim().split('\\|');
            //locList = userLocation.trim().split(',');
            System.debug('locList size>>>>>>>>>>>:'+locList.size());
            if(locList ==null || locList.size()<=0){
                System.debug('enetered into first block of comma separated...locList:'+locList.size());
                if(userLocation.length()>=11)
                    userLoc = userLocation.trim().substring(0, 11);
            }else{
                if(userLocation.contains('-P')){
                    System.debug('enetered into -P block ...');
                    for(String location :locList){
                        System.debug('location>>>>>>>>:'+location+' length>>>>:'+location.length());
                        if(location.contains('-P') && location.length()>=13){
                            userLoc = location.subString(0,13).replace('-P','');
                            System.debug('after removing -P userLoc>>>>>>>>:'+userLoc);
                            userLoc = userLoc.trim();
                            break;
                        }
                    }
                }else {
                    for(String location :locList){
                        if(location.length()>=11){
                            System.debug('enetered into else block of comma separated...');
                            userLoc = location.subString(0,11);
                            userLoc = userLoc.trim();
                            break;
                        }
                    }
                }
            }
            System.debug('After validations inner userLoc>>>>>>:'+userLoc);

        }catch(Exception ex){
            System.debug('in catch of getFilteredUserLocation of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally {
            locList=null;
        }
        return userLoc;
    }

    public FSL_CL_IA_CreateServiceRequestAPIResJSON prepareResWrapperForCreateGuidanzJob(WrapperInput wInput){
        System.debug('*** prepareResWrapperForCreateGuidanzJob ***');
        FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
        FSL_CL_IA_CreateServiceRequestAPIResJSON.DataArea resDataArea = null;
        FSL_CL_IA_CreateServiceRequestAPIResJSON.Header resHeader = null;
        try{
            resHeader = new FSL_CL_IA_CreateServiceRequestAPIResJSON.Header();
            resHeader.status = wInput.status;
            resHeader.serviceName = wInput.serviceName;
            resHeader.serviceVersion = wInput.serviceVersion;
            resHeader.returnCodeDescription = wInput.returnCodeDescription;
            resHeader.toolId = wInput.toolID;
            resHeader.SenderId = wInput.senderId;

            resDataArea = new FSL_CL_IA_CreateServiceRequestAPIResJSON.DataArea();
            resDataArea.IASNumber = wInput.IASNumber;
            resDataArea.WONumber = wInput.WONumber;
            resJSON = new FSL_CL_IA_CreateServiceRequestAPIResJSON();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }
        catch(Exception ex){
            System.debug('in catch of prepareResWrapperForCreateGuidanzJob of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }



    /*
    ** This method is used for providing IA Appointments 
    **
    */
    public void getIAAppointments() {
        System.debug('################# entered into getIAAppointments of CSS_FN_Triage_V4 method ###################');
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        WrapperInput wrapperObj;
        CSS_FN_Triage_V4 tgFNObj = new CSS_FN_Triage_V4();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON resJSON = null;
        try{
            wrapperObj = new WrapperInput();
            wrapperObj = tgFNObj.validateIAAppointments(req);
            if(wrapperObj.status =='Error' || wrapperObj.status !='Processed'){
                resJSON = prepareResWrapperForGetSerRequestAPI(wrapperObj);
            }else{
                resJSON = tgFNObj.getIAAppointments(wrapperObj);
            }
            css_utility.prepareRESTResponse(resJSON, 200);

        }catch(Exception ex){
            System.debug('in catch of getIAAppointments of CSS_FN_Triage_V4>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        } finally {
            wrapperObj=null;tgFNObj=null;
        }
    }

    /*
     * This method is used for validations of IA Appointments
     */
    public WrapperInput validateIAAppointments(RestRequest req){
        System.debug('################# entered into validateIAAppointments method ###################');
        FSL_CL_IA_GetServiceRequestAPI_ReqJSON reqJSON = null;
        WrapperInput wrapperObj;
        String jSONRequestBody = null;
        List<Account> accList = null;
        try{
            wrapperObj = new WrapperInput();
            jSONRequestBody = req.requestBody.toString().trim();
            reqJSON = FSL_CL_IA_GetServiceRequestAPI_ReqJSON.parse(jSONRequestBody);
            System.debug('after deserialize reqJSON>>>>>>>:'+reqJSON);

            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return wrapperObj;
            }
            if(reqJSON.Header.ServiceName.toLowerCase() != 'iaappointments' && reqJSON.Header.ServiceName.toLowerCase() != 'getservicerequestapi'){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return wrapperObj;
            }
            wrapperObj.senderId = reqJSON.Header.SenderId;
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.ServiceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.ServiceName);

            if(reqJSON.Header.ToolID == null || reqJSON.Header.ToolID.trim() == '' || String.isBlank(reqJSON.Header.ToolID) 
               || String.isEmpty(reqJSON.Header.ToolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS03-ToolID is blank';
                return wrapperObj;
            }
            wrapperObj.ToolID = reqJSON.Header.ToolID;

            if(reqJSON.DataArea.CurrentDate == null || reqJSON.DataArea.CurrentDate.trim() == '' || String.isBlank(reqJSON.DataArea.CurrentDate) 
               || String.isEmpty(reqJSON.DataArea.CurrentDate) || reqJSON.DataArea.CurrentDate.trim().length() !=10 
               || !isValidDateFormat(reqJSON.DataArea.CurrentDate) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS04-CurrentDate is blank/invalid';
                return wrapperObj;
            }
            try{
                Date dt = Date.parse(reqJSON.DataArea.CurrentDate.trim());
            }catch(Exception ex){
                System.debug('in catch of Date convertion of validateIAAppointments of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS04-CurrentDate is blank/invalid';
                return wrapperObj;
            }
            wrapperObj.CurrentDate = reqJSON.DataArea.CurrentDate.trim();
            wrapperObj.dateSpan = reqJSON.DataArea.dateSpan;

            //Here do logic for length of 11 chars
            String userLocFiltered = getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            System.debug('After validations userLocFiltered>>>>>>:'+userLocFiltered);
            /*if(userLocFiltered == null || userLocFiltered.trim() == '' || String.isBlank(userLocFiltered) || String.isEmpty(userLocFiltered)){ //Already covered in main class
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS05-UserLocation is blank/invalid';
                return wrapperObj;
            }*/
            wrapperObj.UserLocation = userLocFiltered;

            //Since wrapperObj is not passed from Main class, checking again here for cssEnabled flag
            accList = new List<Account>([Select Id, Location__c, Enable_FSL__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and Location__c=:userLocFiltered limit 1]);
            if(accList != null && accList.size()>0){
                wrapperObj.cssEnabled = 'Y';
            }else{
                wrapperObj.cssEnabled = 'N';
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS07-IAS location is not CSS enabled'; //new code
                return wrapperObj;
            }
            wrapperObj.cssEnabled = 'Y';
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found

        }catch(Exception ex){
            System.debug('in catch of validateIAAppointments of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            //return wrapperObj;
        }finally{
            reqJSON=null;jSONRequestBody=null;accList=null;
        }
        return wrapperObj;
    }


    /* This method validates whether giving string is in 'MM/DD/YYYY' format or not
     * return true, if it is valid or return false;
*/
    public Boolean isValidDateFormat(String dateValue){
        System.debug('*** isValidDateFormat Method Starting point ***');
        String dateRegEx = '(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((19|20)\\d\\d)';
        Pattern myPattern = Pattern.compile(dateRegEx);
        Matcher myMatcher = myPattern.matcher(dateValue);
        if(myMatcher.matches()){return true;}
        else{return false;}
    }


    /*
     * This method is used for send IA Appointments
     * 
     */
    public FSL_CL_IA_GetServiceRequestAPI_ResJSON getIAAppointments(WrapperInput wrapperObj){
        System.debug('################# entered into getIAAppointments of CSS_FN_Triage_V4 method ###################');
        FSL_CL_IA_GetServiceRequestAPI_ResJSON resJSON = null;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments iaAppintObj = null;
        CSS_DataExchange_Parent__c deObj;
        Date givenDate;
        Date fromDate;
        Date toDate;
        try{
            System.debug('input userLocation>>>>is::'+wrapperObj.userLocation+' input CurrentDate>>>>>:'+wrapperObj.CurrentDate);
            resJSON = new FSL_CL_IA_GetServiceRequestAPI_ResJSON();
            wrapperObj.iaAppointList = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
            /*Date cDate = Date.parse(wrapperObj.CurrentDate);
            Date yesterdayDate = cDate.addDays(-1);
            //Date todayDate = cDate.addDays(1);
            Date tomorrowDate = cDate.addDays(1);
            System.debug('cDate>>>>is::'+cDate+' yesterdayDate>>>>>:'+yesterdayDate+' tomorrowDate>>>>>>:'+tomorrowDate);*/
            System.debug('dateSpan:'+wrapperObj.dateSpan+' CurrentDate:'+wrapperObj.CurrentDate);
            if(wrapperObj.dateSpan == null || wrapperObj.dateSpan == '' || String.isBlank(wrapperObj.dateSpan) || String.isEmpty(wrapperObj.dateSpan) 
               || Integer.valueOf(wrapperObj.dateSpan)==0){
                givenDate = Date.parse(wrapperObj.CurrentDate);
                fromDate = givenDate.addDays(-5);
                toDate = givenDate.addDays(5);
            }else{
                givenDate = Date.parse(wrapperObj.CurrentDate);
                fromDate = givenDate.addDays(-(Integer.valueOf(wrapperObj.dateSpan))); //subtract days
                toDate = givenDate.addDays(Integer.valueOf(wrapperObj.dateSpan));
            }  
            System.debug('fromDate:'+fromDate);
            System.debug('toDate:'+toDate);

            /*List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id,Name,Customer_Name__c,First_Name__c,BMS_Last_Name__c,Unit_Number__c,General_Symptoms__c,
                        Date_in_Shop__c,Creator_Location__c from css_job_order__c where Status__c = 'Appointment' and Creator_Location__c=:wrapperObj.userLocation 
                        and (Date_in_Shop__c=:yesterdayDate OR Date_in_Shop__c=:cDate OR Date_in_Shop__c=:tomorrowDate) order by Date_in_Shop__c DESC ]);*/
            List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id,Name,ESN__c,Customer_Name__c,First_Name__c,BMS_Last_Name__c,Unit_Number__c,General_Symptoms__c,
                                                                         Date_in_Shop__c,Creator_Location__c from css_job_order__c where Status__c = 'Appointment' and Creator_Location__c=:wrapperObj.userLocation 
                                                                         and (Date_in_Shop__c >=:fromDate and Date_in_Shop__c <=:toDate) order by Date_in_Shop__c DESC ]);
            /*if(jobList.size()<=0){
                wrapperObj.status = 'Success';
                wrapperObj.statusMsg = 'CG01-IAAppointments list is sent successfully';
                return prepareResWrapperForIAAppoints(wrapperObj);
            }*/
            for(css_job_order__c jobObj: jobList){
                iaAppintObj = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments();
                iaAppintObj.psn = jobObj.ESN__c;
                iaAppintObj.CustomerName = jobObj.Customer_Name__c;
                iaAppintObj.ContactFirstName = jobObj.First_Name__c;
                iaAppintObj.ContactLastName = jobObj.BMS_Last_Name__c;
                iaAppintObj.UnitNumber = jobObj.Unit_Number__c;
                iaAppintObj.ComplaintText = jobObj.General_Symptoms__c;
                if(jobObj.Date_in_Shop__c !=null){
                    //iaAppintObj.AvailableForService = String.valueOf(jobObj.Date_in_Shop__c);
                    iaAppintObj.AvailableForService = jobObj.Date_in_Shop__c.month() + '/' + jobObj.Date_in_Shop__c.day() + '/' + jobObj.Date_in_Shop__c.year();
                }
                iaAppintObj.woNumber = jobObj.Name;
                //iaAppintObj.woEnabled = wrapperObj.cssEnabled;
                wrapperObj.iaAppointList.add(iaAppintObj);
            }
            wrapperObj.status = 'Success';
            wrapperObj.returnCodeDescription = 'CG01-IAAppointments list is sent successfully';
            return prepareResWrapperForGetSerRequestAPI(wrapperObj);
        }catch(Exception ex){
            System.debug('in catch of getIAAppointments of CSS_FN_Triage_V4>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            return prepareResWrapperForGetSerRequestAPI(wrapperObj);
        }finally{
            wrapperObj=null;
        }
        //return resJSON;
    }

    public FSL_CL_IA_GetServiceRequestAPI_ResJSON prepareResWrapperForGetSerRequestAPI(WrapperInput wInput){
        System.debug('*** prepareResWrapperForGetSerRequestAPI ***');
        FSL_CL_IA_GetServiceRequestAPI_ResJSON resJSON = null;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea resDataArea = null;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header resHeader = null;

        try{
            resHeader = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header();
            resHeader.status = wInput.status;
            resHeader.serviceName = wInput.serviceName;
            resHeader.serviceVersion = wInput.serviceVersion;
            resHeader.returnCodeDescription = wInput.returnCodeDescription;
            resHeader.toolId = wInput.toolID;
            resHeader.SenderId = wInput.senderId;

            resDataArea = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
            resDataArea.serviceRequests = wInput.iaAppointList;
            resDataArea.woEnabled = wInput.cssEnabled;
            // resDataArea.WONumber = wInput.serviceRequestNumber;
            resJSON = new FSL_CL_IA_GetServiceRequestAPI_ResJSON();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }
        catch(Exception ex){
            System.debug('in catch of prepareResWrapperForGetSerRequestAPI of FSL_CL_IAUtility>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }


    public class WrapperInput {
        public String status;
        public String senderId;
        public String returnCodeDescription;
        public String psn;
        public String smn;
        public String make;
        public String model;
        public String access;
        public String serviceName;
        public String serviceVersion;
        public String toolID;
        public String algorithm;
        public String ERT;
        public String SELECTMAKE;
        public String SELECTMODEL;
        public String SELECTACCESS;
        //public List<CSS_WPR_TG_MakeModlAcsResJSON2Apex.MAKEMODELACCESS> mmaList;
        public String IASNumber;
        public String WONumber;
        public String CSSEnabled;
        public String userLocation;
        public String CurrentDate;
        public String dateSpan;
        //public List<CSS_WPR_TG_IAAppointmentsResJSON_V1.IAAppointments> iaAppointList;
        public List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> iaAppointList;
    }

}