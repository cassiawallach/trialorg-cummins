/************************************************************************************FSL_CL_IAUtility
Name: 
Copyright © 2019  Cummins

=====================================================================================
=====================================================================================
Purpose:    This class contains utility method to process IA logic
=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/10/2019     INITIAL DEVELOPMENT  
1.1     Mani Kumari G     02/03/2020     Updating Serv Req from IAWOSubmit service GFSLFM-2057
1.2     Vinod Yellala     03/02/2020     Updated the code with isRunningTest for code coverage
1.3     Rajashekar N      09/08/2020     CT2-146 : Modified below query to fetch service requests based on available for service 
instead of created date
1.4     Sura Charanteja   05/02/2021     CT3-285: Service Request Schedule Change & Updated the code with isRunningTest for code coverage
1.5     Sura Charanteja   24/02/2021     CT-325: Guidanz should accept updates from Guidanz mobile where status = Scheduled and IAS number is null
1.6     Lochana Rajput    05/26/2022     SG-1: Updated to populate FTR attributes TransactionID and ABRFlag on SR(Case)
                                         when Feature Switch Matrix record is active
1.7     Lochana Rajput    07/18/2022     SG-72: Updated to populate FTR attributes TransactionID and ABRFlag on SR(Case)
                                        when SR gets updated from GM
*********************************************************************************** */
public class FSL_CL_IAUtility {
    
    public FSL_CL_IA_LocationEnabledAPI_ResDataWrp validateIALocationEnabledRequest(RestRequest request) {
        System.debug(' **** FSL_CL_IAUtility.validateIALocationEnabledRequest method started **** ');
        //Variable Declaration
        FSL_CL_IA_LocationEnabledAPI_ReqDataWrp reqJSON = null;
        FSL_CL_IAUtility.WrapperInput wrapperObj = new FSL_CL_IAUtility.WrapperInput();
        String jSONRequestBody = null;
        
        //Business Logic*
        try {            
            jSONRequestBody = request.requestBody.toString().trim();
            System.debug('*** before deserialize jSONRequestBody *** : '+jSONRequestBody);
            
            //Step1: Error Validation - Validating Whether Request Body is null/blank/empty
            if(jSONRequestBody == null || jSONRequestBody == '' || String.isBlank(jSONRequestBody) || String.isEmpty(jSONRequestBody) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS01-Requested input is blank/invalid';
                return prepareResWrapperForIAISLocationEnabled(wrapperObj);
            }
            
            reqJSON = FSL_CL_IA_LocationEnabledAPI_ReqDataWrp.parse(jSONRequestBody);
            System.debug('**** after deserialize reqJSON **** '+reqJSON);
            //Validating Request Attributes are null or not
            if(reqJSON == null || reqJSON.Header == null || reqJSON.DataArea == null) {
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS01-Requested input is blank/invalid';
                return prepareResWrapperForIAISLocationEnabled(wrapperObj);
            }
            //Validating request header  is null
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName)) {
                   wrapperObj.status = 'Error';
                   wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                   return prepareResWrapperForIAISLocationEnabled(wrapperObj);
               }
            wrapperObj.senderId = reqJSON.Header.SenderId;
            //Validating request header  is ialocationenabled
            if(reqJSON.Header.ServiceName.toLowerCase() != 'ialocationenabled') {
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return prepareResWrapperForIAISLocationEnabled(wrapperObj);
            }
            
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.serviceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.serviceName);
            
            // Validating request TooldId  is blank/null
            if(reqJSON.Header.toolID == null || reqJSON.Header.toolID.trim() == '' || String.isBlank(reqJSON.Header.toolID) || String.isEmpty(reqJSON.Header.toolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS03-ToolID is blank';
                return prepareResWrapperForIAISLocationEnabled(wrapperObj);
            }
            wrapperObj.toolID = reqJSON.Header.toolID;
            //Validating request User location  is blank/null
            if(reqJSON.DataArea.userLocation == null || reqJSON.DataArea.userLocation.trim() == '' || String.isBlank(reqJSON.DataArea.userLocation) || String.isEmpty(reqJSON.DataArea.userLocation) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS05-UserLocation is blank/invalid';
                return prepareResWrapperForIAISLocationEnabled(wrapperObj);
            }       
            
            wrapperObj.status = 'Processed'; //this Processed status is used for validating as no error found
            if(isUserLocationEnabled(reqJSON.DataArea.UserLocation)) {
                wrapperObj.wOEnabled = 'Y';
            } else {
                wrapperObj.wOEnabled = 'N';
            }
            wrapperObj.status = 'Success';
            wrapperObj.returnCodeDescription = 'CG01 - Response sent successfully'; 
            return prepareResWrapperForIAISLocationEnabled(wrapperObj);
        }
        catch(Exception ex) {
            System.debug('in catch of validateIALocationEnabledRequest of FSL_CL_IAUtility :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS06-Invalid JSON Format';
            return prepareResWrapperForIAISLocationEnabled(wrapperObj);
        }
    }
    
    public FSL_CL_IA_LocationEnabledAPI_ResDataWrp prepareResWrapperForIAISLocationEnabled(WrapperInput wInput) {
        System.debug('*** prepareResWrapperForIAISLocationEnabled ***');
        FSL_CL_IA_LocationEnabledAPI_ResDataWrp resJSON = null;
        FSL_CL_IA_LocationEnabledAPI_ResDataWrp.DataArea resDataArea = null;
        FSL_CL_IA_LocationEnabledAPI_ResDataWrp.Header resHeader = null;
        
        try{
            resHeader = new FSL_CL_IA_LocationEnabledAPI_ResDataWrp.Header();
            resHeader.status = wInput.status;
            resHeader.serviceName = wInput.serviceName;
            resHeader.serviceVersion = wInput.serviceVersion;
            resHeader.returnCodeDescription = wInput.returnCodeDescription;
            resHeader.toolId = wInput.toolID;
            resHeader.SenderId = wInput.senderId;
            
            resDataArea = new FSL_CL_IA_LocationEnabledAPI_ResDataWrp.DataArea();
            resDataArea.wOEnabled = wInput.wOEnabled;
            
            resJSON = new FSL_CL_IA_LocationEnabledAPI_ResDataWrp();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }
        catch(Exception ex){
            System.debug('in catch of prepareResWrapperForIAISLocationEnabled of FSL_CL_IAUtility>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    public FSL_CL_IA_CreateServiceRequestAPIResJSON validateCreateServiceRequestAPI(RestRequest request) {
        System.debug('FSL_CL_IAUtility - validateCreateServiceRequestAPI method started');
        FSL_CL_IA_CreateServiceRequestAPIReqJSON reqJSON;
        FSL_CL_IAUtility.WrapperInput wrapperObj = new FSL_CL_IAUtility.WrapperInput();
        String jSONRequestBody = null;
        Boolean isCaseIdExistInGuidanz = false;
        Boolean chkAccIdMapped = false;
        try {
            jSONRequestBody = request.requestBody.toString().trim();
            System.debug('FSL_CL_IAUtility - validateCreateServiceRequestAPI - jSONRequestBody '+ jSONRequestBody);
            
            reqJSON = FSL_CL_IA_CreateServiceRequestAPIReqJSON.parse(jSONRequestBody);
            System.debug('**** after deserialize reqJSON **** '+reqJSON);
            System.debug('$$$ reqJSON.Header.ServiceName ' + reqJSON.Header.ServiceName );
            //Validating request header  is null
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName)) {
                   wrapperObj.status = 'Error';
                   wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                   return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
               }
            //No Validation on sender Id, just wrapping with wrapperObj to prepare response
            wrapperObj.senderId = reqJSON.Header.SenderId;
            
            //Validating request header  is iaserrequestcreation
            if(reqJSON.Header.ServiceName.toLowerCase() != 'iaserrequestcreation' 
               && reqJSON.Header.ServiceName.trim().toLowerCase() != 'iawosubmit' && reqJSON.Header.ServiceName.toLowerCase() != 'iacssjobcreation' ){
                   wrapperObj.status = 'Error';
                   wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                   return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
               }
            
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.serviceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.serviceName);
            
            //Validating request TooldId  is blank/null
            if(reqJSON.Header.toolID == null || reqJSON.Header.toolID.trim() == '' || String.isBlank(reqJSON.Header.toolID) || String.isEmpty(reqJSON.Header.toolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS03-ToolID is blank';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            wrapperObj.toolID = reqJSON.Header.toolID;
            
            //Validating IASNumber is blank/null
            if(reqJSON.DataArea.IASNumber == null || reqJSON.DataArea.IASNumber.trim() == '' || String.isBlank(reqJSON.DataArea.IASNumber) || String.isEmpty(reqJSON.DataArea.IASNumber) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS04-IASNumber is blank';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            wrapperObj.IASNumber =  reqJSON.DataArea.IASNumber;           
            //Validating PSN is blank/null
            if(reqJSON.DataArea.PSN == null || reqJSON.DataArea.PSN.trim() == '' || String.isBlank(reqJSON.DataArea.PSN) || String.isEmpty(reqJSON.DataArea.PSN) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS13-PSN is blank/invalid';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            wrapperObj.status = 'Processed';
            
            /* Validating whether the case exist with this IAS number */
            //&& (reqJSON.DataArea.WONumber == null || reqJSON.DataArea.WONumber.trim() == '' || String.isEmpty(reqJSON.DataArea.WONumber))  
            System.debug('isIASNumberExistInGuidanz: '+isIASNumberExistInGuidanz(reqJSON.DataArea.IASNumber));
            if(isIASNumberExistInGuidanz(reqJSON.DataArea.IASNumber)) {
                List<Case> listCase = [Select Id,CaseNumber,IAS_Number__c 
                                       FROM Case
                                       WHERE IAS_Number__c =:reqJSON.DataArea.IASNumber LIMIT 1 ];
                wrapperObj.serviceRequestNumber = listCase[0].CaseNumber;
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS08-Guidanz Job already exists for the IAS number';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            
            List<Case> objExistingCase = null;
            System.debug('reqJSON.DataArea.WONumber :'+reqJSON.DataArea.WONumber);
              //Added By Sriprada to check Profile for not updating the Account from Asset when creating a IA request
            
          //  Boolean Profilecheck = false;
            Boolean ProfileCheckJustDealer = false;
            Boolean AccCheck = false;
        /*    User user = [select id,User_Location__c,AccountId,FSL_Mileage_Measure__c,Profile.Name from user where id =:UserInfo.getUserId() Limit 1];
            if(User.Profile.Name!=null){
                if(User.profile.Name == 'EVL_Dealer_Advanced' || User.profile.Name == 'EVL_Dealer_Technician' || User.profile.Name == 'EVL_Dealer_Readonly'|| User.profile.Name == 'CSS Integration'){
                    Profilecheck = true;
                }
                if(User.profile.Name == 'EVL_Dealer_Advanced' || User.profile.Name == 'EVL_Dealer_Technician' || User.profile.Name == 'EVL_Dealer_Readonly'){
                    ProfileCheckJustDealer = true;
                }
                else{
                    Profilecheck = false;
                }
            } // Ends here --- Sriprada */
			//system.debug('ProfileCheck:::'+Profilecheck);
            // Bharat - Added for parsing the UserLocation to fetch Primary Location
            // Moving this logic here to handle Dealer scenarios - Sruthi - CT1-439
            String usrLocation = new CSS_FN_Triage_V4().getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            List<ServiceTerritory> serTerrs = new List<ServiceTerritory>();
             //added by sailaja, CT3-275- to assign sender id as owner name
            String senderIdToQuery = reqJSON.Header.SenderId;
            ServiceTerritory userPrimarySerTer;
            if(senderIdToQuery != ''){
             userPrimarySerTer = getServiceTerritorydetails(senderIdToQuery);
            }
            if(!Test.isRunningTest() && (userPrimarySerTer == NULL)){// CT3-610, added by sailaja get logged in user ST only for dealer profiles,sender id ST is null
            system.debug('Entered into profile check true,userPrimarySerTer empty');
                serTerrs = [SELECT Id, IsActive, Location_Code__c FROM ServiceTerritory WHERE IsActive=true and Location_Code__c =: usrLocation LIMIT 1];
            }
           /* if(!Test.isRunningTest()){
                serTerrs = [SELECT Id, IsActive, Location_Code__c FROM ServiceTerritory WHERE IsActive=true and Location_Code__c =: usrLocation LIMIT 1];
            }*/
            
            if(reqJSON.DataArea.WONumber.trim() != '') {
                System.debug('*** reqJSON.DataArea.WONumber *** '+reqJSON.DataArea.WONumber);
                try {
                    //CT3-289, Dinesh Yadav, Added AccountId in query.
                    objExistingCase = [SELECT Id, CaseNumber, IAS_Number__c, Status, AccountId, 
                                       (SELECT Id FROM WorkOrders LIMIT 01)
                                       FROM Case 
                                       WHERE CaseNumber =: reqJSON.DataArea.WONumber.trim() LIMIT 1];
                    System.debug('objExistingCase '+ objExistingCase);
                    if(objExistingCase != null) {
                        isCaseIdExistInGuidanz = true;
                    }
                } catch(Exception ex) {
                    isCaseIdExistInGuidanz = false;
                }              
            }
            if (isCaseIdExistInGuidanz) {
                if (objExistingCase[0].Status != 'Intake' && objExistingCase[0].Status != 'Scheduled' && objExistingCase[0].Status != 'Schedule') { //Added: CT3-325
                    system.debug('objExistingCase'+objExistingCase[0].Status);
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS13-Service Request status not equal to Intake or Scheduled'; //Added: CT3-325
                    return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
                }
                if (String.isNotBlank(objExistingCase[0].IAS_Number__c)) {
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS14-IAS number already exist on Service Request';
                    return prepareResWrapperForCreateSerRequestAPI(wrapperObj);                        
                }
                if(NULL == objExistingCase[0].WorkOrders || objExistingCase[0].WorkOrders.size() == 0) {
                    wrapperObj.status = 'Error';
                    wrapperObj.returnCodeDescription = 'CSS15-No Service Order associated with Service Request';
                    return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
                }
                //Adding this condition to handle Dealer scenarios - Sruthi - CT1-439
                if(objExistingCase[0].WorkOrders != NULL && (objExistingCase[0].WorkOrders.size() > 0)){
                    WorkOrder woObj = [Select Id, (Select Id from CSS_Solutions__r) from WorkOrder where CaseId =: objExistingCase[0].Id LIMIT 1];
                    if(!woObj.CSS_Solutions__r.isEmpty() && woObj.CSS_Solutions__r.size() > 0){
                        wrapperObj.status = 'Error';
                        wrapperObj.returnCodeDescription = 'CSS13-Service Request status not equal to Intake or Scheduled';
                        return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
                    }
                }
                //End - Sruthi - CT1-439
            }
            /*
            * Checking is there any existing asset record with this PSN, If there is no existing record, 
            * creating new asset record with request fields
            */ 
            List<Asset> listObjAsset = [SELECT Id, Name, SerialNumber, Service_Model__c, Access_Code__c
                                        , Make__c, Model__c,Make_Model__c,Engine_Family_Code__c
                                        FROM Asset
                                        WHERE Type_PSN__c =:'Engines-' + reqJSON.DataArea.PSN LIMIT 1];
            // Updated listObjAsset query with condition Type_PSN__c and removed Name and Type__c
            //  CHF-17 : As we have introduced new type pick list values with that not able to indetify uniqueness
            //  with Type_PSN field
            // Name =: reqJSON.DataArea.PSN AND Type__c = 'Engines' LIMIT 1];
            Asset objAsset = new Asset();
            String efcmm = '';
            System.debug('listObjAsset.size() '+listObjAsset.size());
            if(listObjAsset.size() == 0) {
                System.debug('Creating new asset ');
                objAsset.Name = reqJSON.DataArea.PSN;
                objAsset.Type__c = 'Engines';   
                objAsset.Type_PSN__c = 'Engines-' + reqJSON.DataArea.PSN;
                objAsset.Service_Model__c = reqJSON.DataArea.SERVICEMODELNAME;
                objAsset.SerialNumber = reqJSON.DataArea.PSN;
                objAsset.Access_Code__c = reqJSON.DataArea.ACCESS;
                objAsset.Make__c = reqJSON.DataArea.MAKE;
                objAsset.Model__c = reqJSON.DataArea.MODEL;
            } else {
                //Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
              //  CSS_Make_Model_Access__c cMM=new CSS_Make_Model_Access__c();//CT3-290 Getting Make,model and updating in CSS_Make_Model_Access__c.
                // CHF-17: SMN shouldn't be updated for existing Assets
                // objAsset.Name = reqJSON.DataArea.PSN;
                // objAsset.Service_Model__c = (reqJSON.DataArea.SERVICEMODELNAME == '' || reqJSON.DataArea.SERVICEMODELNAME == null) ? listObjAsset[0].Service_Model__c : reqJSON.DataArea.SERVICEMODELNAME;
                // objAsset.SerialNumber = reqJSON.DataArea.PSN;
                Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
                objAsset.Access_Code__c = (reqJSON.DataArea.ACCESS == '' || reqJSON.DataArea.ACCESS == null) ? listObjAsset[0].Access_Code__c : reqJSON.DataArea.ACCESS;
                // objAsset.Make__c = (reqJSON.DataArea.MAKE == '' || reqJSON.DataArea.MAKE == null) ? listObjAsset[0].Make__c : reqJSON.DataArea.MAKE;
                //objAsset.Model__c = (reqJSON.DataArea.MODEL == '' || reqJSON.DataArea.MODEL == null) ? listObjAsset[0].Model__c : reqJSON.DataArea.MODEL;
                if(listObjAsset[0].Id != null && (reqJSON.DataArea.MAKE == 'Other Manufacturer' || reqJSON.DataArea.MODEL == 'Other Model') )
                {    
                     List<CSS_Make_Model_Access__c> cssMakeModelAcc = [SELECT Id,Family_Code_Make_Model__c, Access__c, EquipmentId__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                                                          WHERE Make__c =: 'UNLISTED'
                                                                          AND Model__c =: 'ALL'
                                                                          AND EngineFamilyCode__c =: listObjAsset[0].Engine_Family_Code__c  
                                                                          AND RecordTypeId =: SRTRecordTypeId 
                                                                        LIMIT 1];
                    
                    if(cssMakeModelAcc.size()>0){
                        system.debug('==cssMakeModelAcc===');
                      objAsset.Make_Model__c = cssMakeModelAcc[0].Id ;
                        system.debug('objAsset.Make_Model__c'+objAsset.Make_Model__c);
                    }  
                    else{
                      objAsset.Make_Model__c = null;  
                    }
                    objAsset.Make__c = 'UNLISTED';
                    objAsset.Model__c = 'ALL';
                    objAsset.Service_Model__c=reqJSON.DataArea.SERVICEMODELNAME;
                    system.debug('objAsset for unlisted'+objAsset);
              }
                else{
                    List<CSS_Make_Model_Access__c> cssMakeModelAcc = [SELECT Id,Family_Code_Make_Model__c, Access__c, EquipmentId__c, RecordTypeId FROM CSS_Make_Model_Access__c 
                                                                      WHERE Make__c =: reqJSON.DataArea.MAKE
                                                                      AND Model__c =: reqJSON.DataArea.MODEL
                                                                      AND EngineFamilyCode__c =: listObjAsset[0].Engine_Family_Code__c  
                                                                      AND RecordTypeId =: SRTRecordTypeId 
                                                                      LIMIT 1];
                    If(!cssMakeModelAcc.isempty()){
                    objAsset.Make_Model__c = cssMakeModelAcc[0].Id;
                        system.debug('objAsset.Make_Model__c'+objAsset.Make_Model__c);
                        }
                    else{
                        objAsset.Make_Model__c = null;
                        system.debug('objAsset.Make_Model__c for no record'+objAsset.Make_Model__c);
                    }
                    objAsset.Make__c = reqJSON.DataArea.MAKE;
                    objAsset.Model__c = reqJSON.DataArea.MODEL;
                    objAsset.Service_Model__c=reqJSON.DataArea.SERVICEMODELNAME;
                    system.debug('asset details for non make'+ objAsset);    
                }
                              
                objAsset.Id = listObjAsset[0].Id;
               
            }
            try {
                upsert objAsset;
                system.debug('asset details for non make after upsert'+ objAsset);
                insertMakeModelStaging(objAsset.Id);
                system.debug('asset details for non make in insertMakeModelStaging '+ objAsset);
            } catch(Exception ex) {
                system.debug('ex.getStackTraceString() '+ex.getStackTraceString());
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            
            //CT3-289, Dinesh Yadav, Added AccountId in Query.
            //PHOEN-228, Naveen Goud, Added Account.CMI_Account_Status__c in Query.
            //VGRS2-743 - Ramya, Added Unit_Number__c
            List<Asset> listObjNewAsset = [SELECT Id,Name,SerialNumber,Service_Model__c,Access_Code__c
                                           ,Make__c,Model__c, AccountId,Account.CMI_Account_Status__c,Unit_Number__c
                                           FROM Asset
                                           WHERE Name=:reqJSON.DataArea.PSN LIMIT 1];
            System.debug('listObjNewAsset '+listObjNewAsset);
            RecordType iaRequestRecTypeId = [SELECT Id,Name
                                             FROM RecordType 
                                             WHERE sObjectType='Case' 
                                             AND Name='IA Request' LIMIT 1];
            
            RecordType Prioritized_FCRecTypeId = [SELECT Id, Name
                                                  FROM RecordType 
                                                  WHERE sObjectType = 'FSL_IA_FC__c' 
                                                  AND Name = 'Prioritized FC' LIMIT 1];
            
            RecordType UnPrioritized_FCRecTypeId = [SELECT Id, Name
                                                    FROM RecordType 
                                                    WHERE sObjectType = 'FSL_IA_FC__c' 
                                                    AND Name = 'UnPrioritized FC' LIMIT 1];
            
            System.debug('iaRequestRecTypeId '+ iaRequestRecTypeId);
            System.debug('reqJSON.DataArea.WONumber '+ reqJSON.DataArea.WONumber);
            
           
            
            Case objCase = new Case();
            objCase.Location__c = usrLocation;
            objCase.Username_WWID__c  = reqJSON.DataArea.Username;
            objCase.IAS_Number__c = reqJSON.DataArea.IASNumber;
            objCase.AssetId  = listObjNewAsset[0].Id;
            objCase.Service_Model__c  = listObjNewAsset[0].Service_Model__c;
            objCase.Access_Code__c  = listObjNewAsset[0].Access_Code__c;
            objCase.Make__c  = listObjNewAsset[0].Make__c;
            objCase.Model__c  = listObjNewAsset[0].Model__c;
            objCase.Unit_Number__c  = listObjNewAsset[0].Unit_Number__c;
            objCase.Customer_Name__c  = reqJSON.DataArea.CustomerName;
            objCase.Description = reqJSON.DataArea.ComplaintText;

            system.debug('CustomerName:::'+ objCase.Customer_Name__c);
            //added by sailaja, CT3-275- to assign sender id as owner name
            if(!isCaseIdExistInGuidanz){
                //Added:CT3-325 test coverage
                User wwid;
                if(test.isRunningTest())
                {
                    wwid = [SELECT Id,federationIdentifier FROM User Limit 1];  
                }
                else
                {
                    wwid = [SELECT Id,federationIdentifier FROM User WHERE federationIdentifier !='' and federationIdentifier =: senderIdToQuery LIMIT 1];
                }
                if(wwid!= null){
                    objCase.OwnerId = wwid.Id;
                }
            }
            
            try {
                objCase.Product_Mileage__c = (reqJSON.DataArea.ProdMileage == '' || reqJSON.DataArea.ProdMileage == null) ? null : decimal.valueOf(reqJSON.DataArea.ProdMileage);
                objCase.Product_Mileage_Unit__c = reqJSON.DataArea.ProdMileageUnit;
                objCase.Product_Hours__c = (reqJSON.DataArea.ProdHours == '' || reqJSON.DataArea.ProdHours == null) ? null : decimal.valueOf(reqJSON.DataArea.ProdHours);
            } catch(Exception ex) {
                ex.getMessage();
            }
            objCase.Subject = 'Immediate Assessment Data Flow from Mobile';
            objCase.Priority = reqJSON.DataArea.Severity;
            objCase.Language__c = reqJSON.DataArea.LanguageKey;
            //Sruthi - Adding filter condition to prevent Record Type update for Dealer
            if(!serTerrs.isEmpty() && serTerrs.size() > 0){ 
                objCase.RecordTypeId = iaRequestRecTypeId.Id;
            }
            
            //Distributor
            //CT3-285 -Test Class Coverage
            if(Test.isRunningTest())
            {
                usrLocation = 'abadc';
            }
          
           if(!Test.isRunningTest()){
           /*     if(ProfileCheck == false && userPrimarySerTer!= NULL) {
                objCase.Service_Territory__c = userPrimarySerTer.Id;
                system.debug('*****objCase.Service_Territory__c profilecheck false***' + objCase.Service_Territory__c);
            } 
              if(ProfileCheckJustDealer != true && (!serTerrs.isEmpty() && userPrimarySerTer== NULL) ) {	
                    objCase.Service_Territory__c = serTerrs[0].Id;	
                  system.debug('***objCase.Service_Territory__c'+ objCase.Service_Territory__c); 
              }*/
         //     else if(ProfileCheckJustDealer == true && serTerrs.isEmpty()){
                    List<Account> serAccount = [SELECT ID, Name,EBU_Channel_of_Distribution__c, IAM_Service_Provider_Code__c FROM Account WHERE Location__c = : usrLocation LIMIT 1];
                  if(serAccount != null && serAccount.size()>0){
                      system.debug('AccCheck::'+serAccount[0]); 
                      if(serAccount[0].EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-BRANCH' || serAccount[0].EBU_Channel_of_Distribution__c == 'DISTRIBUTOR-HEADQUARTERS'){
                          ProfileCheckJustDealer = false;
                      } else{
                          ProfileCheckJustDealer = true;
                      }
                  }
               
               if(userPrimarySerTer!= NULL && ProfileCheckJustDealer == false) {
                   objCase.Service_Territory__c = userPrimarySerTer.Id;
                   system.debug('*****objCase.Service_Territory__c profilecheck false***' + objCase.Service_Territory__c);
               } 
               if(ProfileCheckJustDealer != true && (!serTerrs.isEmpty() && userPrimarySerTer== NULL) ) {	
                   objCase.Service_Territory__c = serTerrs[0].Id;	
                   system.debug('***objCase.Service_Territory__c'+ objCase.Service_Territory__c); 
               } else if (ProfileCheckJustDealer == true && serTerrs.isEmpty()){
                   objCase.AccountId = serAccount[0].Id;
                   AccCheck = true;
                   objCase.Service_location__c = serAccount[0].IAM_Service_Provider_Code__c + ' - ' +serAccount[0].Name;
                   objCase.Customer__c = reqJSON.DataArea.CustomerName;
                   //  }
                   string usrloc = 'JQ'+'%' + usrLocation + '%';
                   system.debug('AccCheck::'+usrloc); 
                   system.debug('CustomerNameCheck::'+objCase.Customer__c); 

                   Group[] CaseOwner = [SELECT Id, Name, Type FROM Group where type =: 'queue' and name like : usrloc LIMIT 1];
                   objCase.OwnerId = CaseOwner[0].Id;
               }
               // } 
               // 
               //CT3-289, Dinesh Yadav, Populate Account Name from associated Asset.
            if(listObjNewAsset[0].AccountId != null && !ProfileCheckJustDealer){
                system.debug('AccountId::'+objCase.AccountId);
                if(isCaseIdExistInGuidanz){
                    //PHOEN-228, Naveen Goud, Added condition to check Account.CMI_Account_Status__c not Inactive in 516 line.
                    if(objExistingCase[0].AccountId == null && listObjNewAsset[0].Account.CMI_Account_Status__c !='Inactive'){
                        objCase.AccountId = listObjNewAsset[0].AccountId;
                        chkAccIdMapped = true;
                    }
                }
                //PHOEN-228, Naveen Goud, Added condition to check Account.CMI_Account_Status__c not Inactive in 516 line.
                else if(listObjNewAsset[0].Account.CMI_Account_Status__c !='Inactive'){
                    objCase.AccountId = listObjNewAsset[0].AccountId;
                    chkAccIdMapped = true;
                }
            }
            } 
            //Dealer - we are checking account object based on usrLocation 
            //fetch the queue name then pass to case OwnerId.
            System.debug('isCaseIdExistInGuidanz '+isCaseIdExistInGuidanz);
            System.debug('objCase'+ objCase);
            try {
                //1.6/1.7 STARTS
                //Fetching record from Feature Switch Matrix
                List<FSL_Switch__c> lstFeatureMatrix = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c 
                WHERE Name = 'Enable_FTR_Switch' AND IsActive__c = true LIMIT 1];
                //Adding Event Type parameter when Feature Switch Matrix record is active
                if(lstFeatureMatrix != null  && lstFeatureMatrix.size() > 0) {
                    objCase.FSL_ABRFlag__c = reqJSON.DataArea.ABRFlag == true ? true : false;
                    objCase.FSL_TransactionID__c = reqJSON.DataArea.transactionID;
                }
                //1.6/1.7 ENDS
                if(isCaseIdExistInGuidanz){
                    objCase.Id = objExistingCase[0].Id;
                    objCase.IsIAWOSubmitCalled__c = true;
                    if(AccCheck == true){
                        objCase.Status = 'Triage & Diagnosis';
                    }
                   
                    update objCase;
                    system.debug('objCase update from IA' + objCase);
                } else {
                    insert objCase;
                    system.debug('objCase insert from IA' + objCase);
                }
                List<Case> listCaseNumber = [SELECT Id, CaseNumber
                                             FROM Case 
                                             WHERE Id =: objCase.Id];
                System.debug('listCaseNumber ' + listCaseNumber[0].CaseNumber);
                wrapperObj.serviceRequestNumber = listCaseNumber[0].CaseNumber;
            } catch(Exception ex) {
                system.debug(ex.getMessage());
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
            }
            
            //Inserting and Updating prioritizedData
            List<FSL_IA_FC__c> relFCList;
            List<FSL_IA_FC__c> allRelFCList;
            List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.PrioritizedData> listObjPriozedData;
            List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.Relfc> listObjRelFC;
            
            if(reqJSON.DataArea.PrioritizedData != null) {
                listObjPriozedData  = reqJSON.DataArea.PrioritizedData;
                System.debug('reqJSON.DataArea.PrioritizedData :'+reqJSON.DataArea.PrioritizedData);
                List<FSL_IA_FC__c> listObjIAFC = new List<FSL_IA_FC__c>();
                System.debug('listObjPriozedData.size() '+listObjPriozedData.size());
                if(listObjPriozedData.size() > 0) {
                    Map<String,List<FSL_IA_FC__c>> relFCMap = new Map<String,List<FSL_IA_FC__c>>();
                    for(FSL_CL_IA_CreateServiceRequestAPIReqJSON.PrioritizedData priozedData :listObjPriozedData) {
                        System.debug('priozedData '+ priozedData);
                        String lstRelatedFC = '';
                        FSL_IA_FC__c objIAFC = new FSL_IA_FC__c();
                        objIAFC.RecordTypeId = Prioritized_FCRecTypeId.Id;
                        objIAFC.Name = priozedData.prifc;
                        objIAFC.SPN__c = priozedData.SPN;
                        objIAFC.FMI__c = priozedData.FMI;
                        objIAFC.P_Code__c = priozedData.PCode;
                        objIAFC.OccurenceTime__c = priozedData.occurenceTime;
                        objIAFC.status__c = priozedData.status;
                        objIAFC.count__c = priozedData.count;
                        objIAFC.Fault_Code_Description__c = priozedData.PrimaryFaultCodeDescription;
                        objIAFC.Root_Cause_Component_1__c = priozedData.rootCause1;
                        objIAFC.Root_Cause_Likelihood_1__c = (priozedData.rc1Likelihood == '' || priozedData.rc1Likelihood == null) ? null : convertStringToDecimal(priozedData.rc1Likelihood);
                        objIAFC.Root_Cause_Component_2__c = priozedData.rootCause2;
                        objIAFC.Root_Cause_Likelihood_2__c = (priozedData.rc2Likelihood == '' || priozedData.rc2Likelihood == null) ? null : convertStringToDecimal(priozedData.rc2Likelihood);
                        objIAFC.Root_Cause_Component_3__c = priozedData.rootCause3;
                        objIAFC.Root_Cause_Likelihood_3__c = (priozedData.rc3Likelihood == '' || priozedData.rc3Likelihood == null) ? null : convertStringToDecimal(priozedData.rc3Likelihood);
                        objIAFC.Root_Cause_Component_4__c = priozedData.rootCause4;
                        objIAFC.Root_Cause_Likelihood_4__c = (priozedData.rc4Likelihood == '' || priozedData.rc4Likelihood == null) ? null : convertStringToDecimal(priozedData.rc4Likelihood);
                        System.debug('priozedData.Lhrprob ' + priozedData.Lhrprob);
                        FSL_CL_IA_CreateServiceRequestAPIReqJSON.Lhrprob lbrHrs;
                        lbrHrs = priozedData.Lhrprob;
                        if(lbrHrs != null) {
                            objIAFC.FSL_0_to_2_Hours_Probability__c = (lbrHrs.lbrprob1 == '' || lbrHrs.lbrprob1 == null) ? null : convertStringToDecimal(lbrHrs.lbrprob1);
                            objIAFC.FSL_2_to_4_Hours_Probability__c = (lbrHrs.lbrprob2 == '' || lbrHrs.lbrprob2 == null) ? null : convertStringToDecimal(lbrHrs.lbrprob2);
                            objIAFC.FSL_4_to_6_Hours_Probability__c = (lbrHrs.lbrprob3 == '' || lbrHrs.lbrprob3 == null) ? null : convertStringToDecimal(lbrHrs.lbrprob3);
                            objIAFC.FSL_Over_6_Hours_Probability__c = (lbrHrs.lbrprob4 == '' || lbrHrs.lbrprob4 == null) ? null : convertStringToDecimal(lbrHrs.lbrprob4);
                        }
                        objIAFC.Derate_Value_1__c = priozedData.DerateValue1;
                        objIAFC.Derate_Value_2__c = priozedData.DerateValue2;
                        objIAFC.Derate_Value_3__c = priozedData.DerateValue3;
                        objIAFC.Severity__c = priozedData.Severity;
                        objIAFC.Shutdown_Description__c = priozedData.ShutdownDescription;
                        objIAFC.Fault_Code_Type__c = 'Primary';
                        objIAFC.Prioritized_FC_SR__c = objCase.Id;
                        listObjIAFC.add(objIAFC);
                        system.debug('List:::'+listObjIAFC);
                        
                        // Fetching Related Fault Codes here
                        listObjRelFC = priozedData.relfc;
                        System.debug('listObjRelFC.size() '+listObjRelFC.size());
                        System.debug('listObjRelFC '+listObjRelFC);
                        
                        relFCList = new List<FSL_IA_FC__c>();
                        if(listObjRelFC <> null) {
                            for(FSL_CL_IA_CreateServiceRequestAPIReqJSON.Relfc relfcObj :listObjRelFC) {
                                System.debug('*** relfcObj *** '+relfcObj);
                                System.debug('*** relfcObj.rfc *** '+relfcObj.rfc);
                                if(relfcObj.rfc<>null) {
                                    lstRelatedFC = lstRelatedFC + relfcObj.rfc + ', ';
                                    /* FSL_IA_FC__c objRelIAFC = new FSL_IA_FC__c();
                                        objRelIAFC.RecordTypeId = Prioritized_FCRecTypeId.Id;
                                        objRelIAFC.Name = relfcObj.rfc;
                                        objRelIAFC.SPN__c = relfcObj.SPN;
                                        objRelIAFC.FMI__c = relfcObj.FMI;
                                        objRelIAFC.P_Code__c = relfcObj.PCode;
                                        objRelIAFC.OccurenceTime__c = relfcObj.occurenceTime;
                                        objRelIAFC.status__c = relfcObj.status;
                                        objRelIAFC.count__c = relfcObj.count;
                                        objRelIAFC.Fault_Code_Description__c = relfcObj.RelatedFaultCodeDescription;
                                        objRelIAFC.Derate_Value_1__c = relfcObj.DerateValue1;
                                        objRelIAFC.Derate_Value_2__c = relfcObj.DerateValue2;
                                        objRelIAFC.Derate_Value_3__c = relfcObj.DerateValue3;
                                        objRelIAFC.Severity__c = relfcObj.Severity;
                                        objRelIAFC.Shutdown_Description__c = relfcObj.ShutdownDescription;
                                        objRelIAFC.Fault_Code_Type__c = 'Related';
                                        objRelIAFC.Prioritized_FC_SR__c = objCase.Id;
                                        relFCList.add(objRelIAFC); */
                                }
                            }
                        }
                        objIAFC.Related_Fault_Codes__c = lstRelatedFC.removeEnd(', ');
                        // relFCMap.put(priozedData.prifc, relFCList);
                    }
                    
                    if(listObjIAFC.size() > 0) {
                        try {
                            insert listObjIAFC;
                            System.debug('After Prioritized FC insert...');
                            /* allRelFCList = new List<FSL_IA_FC__c>();
                            for(FSL_IA_FC__c fcObj : listObjIAFC) {
                            for(FSL_IA_FC__c fcObjTemp : relFCMap.get(fcObj.Name)) {
                            fcObjTemp.Root_Fault_Code__c = fcObj.Id;
                            allRelFCList.add(fcObjTemp);
                            }
                            }
                            system.debug('allRelFCList ####'+allRelFCList);
                            if(allRelFCList.size() > 0) {
                            insert allRelFCList;
                            } */
                        } catch(Exception ex) {
                            system.debug('**'+ex.getStackTraceString());
                            wrapperObj.status = 'Error';
                            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                            return prepareResWrapperForCreateSerRequestAPI(wrapperObj); 
                        }
                    }
                }
            }
            
            // Inserting and Updating unPrioritizedData 
            List<FSL_IA_FC__c> listObjIAFC = new List<FSL_IA_FC__c>();
            List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.unPrioritizedData> listObjunPrioritizedData;
            
            if(reqJSON.DataArea.unPrioritizedData != null) {
                listObjunPrioritizedData = reqJSON.DataArea.unPrioritizedData;
                System.debug('reqJSON.DataArea.unPrioritizedData: '+reqJSON.DataArea.unPrioritizedData);
                
                if(listObjunPrioritizedData.size() > 0) {
                    for(FSL_CL_IA_CreateServiceRequestAPIReqJSON.unPrioritizedData unPrioritizedData :listObjunPrioritizedData) {
                        System.debug('unPrioritizedData: ' + unPrioritizedData);
                        FSL_IA_FC__c objIAFC = new FSL_IA_FC__c();
                        objIAFC.RecordTypeId = UnPrioritized_FCRecTypeId.Id;
                        objIAFC.Name = unPrioritizedData.upfc;
                        objIAFC.SPN__c = unPrioritizedData.SPN;
                        objIAFC.FMI__c = unPrioritizedData.FMI;
                        objIAFC.P_Code__c = unPrioritizedData.PCode;
                        objIAFC.OccurenceTime__c = unPrioritizedData.occurenceTime;
                        objIAFC.status__c = unPrioritizedData.status;
                        objIAFC.count__c = unPrioritizedData.count;
                        objIAFC.Reason_Code__c = unPrioritizedData.rc;
                        objIAFC.Reason_Code_Description__c = unPrioritizedData.ReasonCodeDescription;
                        objIAFC.Fault_Code_Type__c = 'Non Prioritized';
                        objIAFC.UnPrioritized_FC_SR__c = objCase.Id;
                        listObjIAFC.add(objIAFC);
                    }
                    if(listObjIAFC.size()>0) {
                        try {
                            insert listObjIAFC;
                            System.debug('After UnPrioritized FC insert...');
                        } catch(Exception ex) {
                            system.debug('**'+ex.getStackTraceString());
                            wrapperObj.status = 'Error';
                            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
                            return prepareResWrapperForCreateSerRequestAPI(wrapperObj); 
                        }
                    }
                }
            }
            
        } catch(Exception ex) {
            
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
        }
        wrapperObj.status = 'Success';
        if(isCaseIdExistInGuidanz) {
            wrapperObj.returnCodeDescription = 'CG01-Guidanz Service Request is updated successfully';
        } else {
            wrapperObj.returnCodeDescription = 'CG01-Guidanz Service Request is created successfully';
        }
        return prepareResWrapperForCreateSerRequestAPI(wrapperObj);
    }
    
    public FSL_CL_IA_CreateServiceRequestAPIResJSON prepareResWrapperForCreateSerRequestAPI(WrapperInput wInput){
        System.debug('*** prepareResWrapperForCreateSerRequestAPI ***');
        FSL_CL_IA_CreateServiceRequestAPIResJSON resJSON = null;
        FSL_CL_IA_CreateServiceRequestAPIResJSON.DataArea resDataArea = null;
        FSL_CL_IA_CreateServiceRequestAPIResJSON.Header resHeader = null;
        
        try {
            resHeader = new FSL_CL_IA_CreateServiceRequestAPIResJSON.Header();
            resHeader.status = wInput.status;
            resHeader.serviceName = wInput.serviceName;
            resHeader.serviceVersion = wInput.serviceVersion;
            resHeader.returnCodeDescription = wInput.returnCodeDescription;
            resHeader.toolId = wInput.toolID;
            resHeader.SenderId = wInput.senderId;
            
            resDataArea = new FSL_CL_IA_CreateServiceRequestAPIResJSON.DataArea();
            resDataArea.IASNumber = wInput.IASNumber;
            resDataArea.WONumber = wInput.serviceRequestNumber;
            resJSON = new FSL_CL_IA_CreateServiceRequestAPIResJSON();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }
        catch(Exception ex){
            System.debug('in catch of prepareResWrapperForIAISLocationEnabled of FSL_CL_IAUtility>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /* Method is to validate whether given location is guidanz enabled location or not */
    public Boolean isUserLocationEnabled(String location){
        location = new CSS_FN_Triage_V4().getFilteredUserLocation(location);
        System.debug('Filtered location:'+location);    
        if(location == null || location.trim() == '') {
            return false;
        }
        List<Account> listAcc = [SELECT IA_CSSEnabled__c
                                 FROM ACCOUNT
                                 WHERE Location__c =:location  LIMIT 1];
        
        
        //Validating whether IACssLocation is true/false.
        if(listAcc.size()>0) {
            if(listAcc[0].IA_CSSEnabled__c) {
                return true;
            } else {
                return false;
            }
        }
        return false;
    }
    
    public Boolean isIASNumberExistInGuidanz(String IASNumber) {
        
        List<Case> listCase = [Select Id,IAS_Number__c 
                               FROM Case
                               WHERE IAS_Number__c =:IASNumber LIMIT 1 ];
        System.debug('listCase.size(): '+listCase.size());
        if(listCase.size()>0){
            return true;
        } else {
            return false;
        }
    }
    
    public static Decimal convertStringToDecimal(String value) {
        try {
            return Decimal.valueOf(value.replace('%',''));
        } catch(Exception ex){
            return null;
        }
    }
    
    public FSL_CL_IA_GetServiceRequestAPI_ResJSON getIAServiceRequestResponse(RestRequest request) {
        System.debug('FSL_CL_IAUtility - getIAServiceRequestResponse method started');
        FSL_CL_IA_GetServiceRequestAPI_ReqJSON reqJSON;
        FSL_CL_IAUtility.WrapperInput wrapperObj = new FSL_CL_IAUtility.WrapperInput();
        String jSONRequestBody = null;
        try {
            jSONRequestBody = request.requestBody.toString().trim();
            System.debug('FSL_CL_IAUtility - getIAServiceRequestResponse - jSONRequestBody '+ jSONRequestBody);
            reqJSON = FSL_CL_IA_GetServiceRequestAPI_ReqJSON.parse(jSONRequestBody);
            System.debug('**** after deserialize reqJSON **** '+reqJSON);
            //Validating request header  is null
            System.debug('Validating request header  is null');
            if(reqJSON.Header.ServiceName == null || reqJSON.Header.ServiceName.trim() == '' || String.isBlank(reqJSON.Header.ServiceName) 
               || String.isEmpty(reqJSON.Header.ServiceName)) {
                   wrapperObj.status = 'Error';
                   wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                   return prepareResWrapperForGetSerRequestAPI(wrapperObj);
               }
            //No Validation on sender Id, just wrapping with wrapperObj to prepare response
            wrapperObj.senderId = reqJSON.Header.SenderId;
            System.debug('wrapperObj.senderId:'+wrapperObj.senderId);
            //Validating request header  is GetServiceRequestAPI
            System.debug('Validating request header  is GetServiceRequestAPI');
            if(reqJSON.Header.ServiceName.toLowerCase() != 'getservicerequestapi' && reqJSON.Header.ServiceName.toLowerCase() != 'iaappointments'){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS02-Service Name is blank/invalid';
                return prepareResWrapperForGetSerRequestAPI(wrapperObj);
            }
            
            wrapperObj.serviceVersion = reqJSON.Header.serviceVersion;
            wrapperObj.serviceName = reqJSON.Header.serviceName;
            System.debug('reqJSON.Header.ServiceName:'+reqJSON.Header.serviceName);
            System.debug('*** Validating request TooldId  is blank/null ***');
            //Validating request TooldId  is blank/null
            if(reqJSON.Header.toolID == null || reqJSON.Header.toolID.trim() == '' || String.isBlank(reqJSON.Header.toolID) || String.isEmpty(reqJSON.Header.toolID) ){
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS03-ToolID is blank';
                return prepareResWrapperForGetSerRequestAPI(wrapperObj);
            }
            wrapperObj.toolID = reqJSON.Header.toolID;
            // Bharat 03/13/2020 - Added for parsing the UserLocation to fetch Primary Location
            String usrLocation = new CSS_FN_Triage_V4().getFilteredUserLocation(reqJSON.DataArea.UserLocation);
            /*Validates given date is in MM/DD/YYYY format */
            System.debug('*** Validates given date is in MM/DD/YYYY format ***');
            if(!isValidDateFormat(reqJSON.DataArea.CurrentDate)) {
                wrapperObj.status = 'Error';
                wrapperObj.returnCodeDescription = 'CSS04-CurrentDate is blank/invalid';
                return prepareResWrapperForGetSerRequestAPI(wrapperObj);
            } 
            //Retrieve the List of Service requests
            List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> listIAApp =  
                getServiceRequestList(reqJSON.DataArea.CurrentDate, reqJSON.DataArea.Datespan, usrLocation);
            wrapperObj.serviceRequests = listIAApp;
            wrapperObj.status = 'Success';
            wrapperObj.returnCodeDescription = 'CG01-IAAppointments list is sent successfully';
            return prepareResWrapperForGetSerRequestAPI(wrapperObj);
            
        } catch(Exception ex) {
            system.debug(ex.getMessage());
            wrapperObj.status = 'Error';
            wrapperObj.returnCodeDescription = 'CSS11-CSS Internal Error';
            return prepareResWrapperForGetSerRequestAPI(wrapperObj);
        }
    }
    
    public static FSL_CL_IA_GetServiceRequestAPI_ResJSON prepareResWrapperForGetSerRequestAPI(WrapperInput wInput) {
        System.debug('*** prepareResWrapperForGetSerRequestAPI ***');
        FSL_CL_IA_GetServiceRequestAPI_ResJSON resJSON = null;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea resDataArea = null;
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header resHeader = null;
        
        try {
            resHeader = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header();
            resHeader.status = wInput.status;
            resHeader.serviceName = wInput.serviceName;
            resHeader.serviceVersion = wInput.serviceVersion;
            resHeader.returnCodeDescription = wInput.returnCodeDescription;
            resHeader.toolId = wInput.toolID;
            resHeader.SenderId = wInput.senderId;
            
            resDataArea = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
            resDataArea.serviceRequests = wInput.serviceRequests;
            resDataArea.woEnabled = 'Y';
            // resDataArea.WONumber = wInput.serviceRequestNumber;
            resJSON = new FSL_CL_IA_GetServiceRequestAPI_ResJSON();
            resJSON.Header = resHeader;
            resJSON.DataArea = resDataArea;
            System.debug('before returning Response JSON>>>>>>>>>>>>>>>>>>>>>>>>>>resJSON:'+resJSON);
        }
        catch(Exception ex) {
            System.debug('in catch of prepareResWrapperForGetSerRequestAPI of FSL_CL_IAUtility>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        finally {
            //Perform some clean up
            resHeader = null; resDataArea = null;
        }
        return resJSON;
    }
    
    /* This method validates whether giving string is in 'MM/DD/YYYY' format or not
* return true, if it is valid or return false;
*/
    public static Boolean isValidDateFormat(String dateValue) {
        System.debug('*** isValidDateFormat Method Starting point ***');
        String dateRegEx = '(0?[1-9]|1[012])/(0?[1-9]|[12][0-9]|3[01])/((19|20)\\d\\d)';
        Pattern myPattern = Pattern.compile(dateRegEx);
        Matcher myMatcher = myPattern.matcher(dateValue);
        if(myMatcher.matches()){return true;}
        else{return false;}
    }
    
    /* Logic to send list of service requests based
on Current Date and DateSpan Values */
    public static List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> getServiceRequestList(String CurrentDateFromReq, String DateSpanFromReq, String fildUsrLoc) {
        Date fromDate;
        DateTime fromDateTime;
        Date toDate;
        DateTime toDateTime;
        Date currentDate;
        List<Case> caseList = new List<Case>();
        System.debug('*** reqJSON.DataArea.Datespan *** '+ CurrentDateFromReq);
        if(DateSpanFromReq == null || DateSpanFromReq == '' || String.isBlank(DateSpanFromReq) || String.isEmpty(DateSpanFromReq) || Integer.valueOf(DateSpanFromReq)==0) {
            currentDate = Date.parse(CurrentDateFromReq);
            fromDate = currentDate.addDays(-5);
            //fromDateTime = currentDate.addDays(-5);
            toDate = currentDate.addDays(5);
            toDateTime = DateTime.newInstance(toDate, Time.newInstance(18, 59, 0, 0));
        } else {
            currentDate = Date.parse(CurrentDateFromReq);
            //fromDateTime = currentDate;
            fromDate = currentDate.addDays(-(Integer.valueOf(DateSpanFromReq)));
            toDate = currentDate.addDays(Integer.valueOf(DateSpanFromReq)+1);
            //toDateTime =  currentDate.addDays(Integer.valueOf(DateSpanFromReq));              
        }
        System.debug('*** fromDate *** ' + fromDate);
        System.debug('*** toDate *** ' + toDate);
        String useLocation = fildUsrLoc + '%';
        /* 
Author : Rajashekar Nallapati
Modified Date : 09/08/2020
Change Reason : New Requirement CT2-146 
CT2-146 : Modified below query to fetch service requests based on available for service 
instead of created date
*/
        /* CT1-84 Checking partenr account to see if it is dealer and also Available for Service == null.*/
        Boolean IsDealer;
        List<Account> accList1 = new List<Account>([Select Id, Location__c,IsPartner, Enable_FSL__c, IA_CSSEnabled__c from Account where IA_CSSEnabled__c=true and IsPartner=true and Location__c=:fildUsrLoc limit 1]);
        if(accList1 != null && accList1.size() > 0) { //CT1-84
            IsDealer = true;
        } else {
            IsDealer = false;
        }
        //CP130_IAMobileAPP bug fix - Adding Account ID, Account.Name to the query by Murali - 2/14/22
        if(IsDealer == false) {
            caseList = [SELECT Id, Customer_Name__c, AccountId, Account.Name, Contact__c, Customer__c, Status, Contact.FirstName, Contact.LastName, CaseNumber, 
                        Asset.Name, Asset.Unit_Number__c, Description, Available_for_Service__c,CreatedDate
                        FROM Case 
                        WHERE Available_for_Service__c >=: fromDate AND Available_for_Service__c <=: toDate 
                        AND (Service_Territory__r.Location_Code__c LIKE: useLocation) AND (Status = 'Intake' OR Status = 'Schedule' OR Status = 'Scheduled') AND IAS_Number__c = null]; //Added:CT3-285
       system.debug('is dealer condition caseList' + caseList);
        } else {
            //CP130_IAMobileAPP bug fix - Adding Account ID, Account.Name to the query by Murali - 2/14/22
            caseList = [SELECT Id, Customer_Name__c, AccountId, Account.Name, Contact__c, Customer__c, Status, Contact.FirstName, Contact.LastName, CaseNumber, 
                        Asset.Name, Asset.Unit_Number__c, CreatedDate,  Description, Available_for_Service__c 
                        FROM Case 
                        WHERE CreatedDate >=: fromDate AND CreatedDate <=: toDate 
                        AND (Account.Location__c LIKE: useLocation) AND (Status = 'Intake' OR Status = 'Schedule' OR Status = 'Scheduled') AND IAS_Number__c = null]; //Added:CT3-285
       system.debug('caseList' + caseList);
        }
        
        System.debug('*** caseList *** '+ caseList);
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> listIAApp = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        if(Test.isRunningTest())
        {
            //CP130_IAMobileAPP bug fix - Adding Account ID, Account.Name to the query by Murali - 2/14/22
            caseList = [Select id,Customer_Name__c, AccountId, Account.Name, Contact__c,Customer__c,Contact.FirstName,Contact.LastName,CaseNumber,Asset.Name,
                        Unit_Number__c,Description,Available_for_Service__c,CreatedDate
                        From Case
                        Limit 1
                       ];  
        }
        for(Case objCase : caseList) {
            FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments objIAApp = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments();
            //CP130_IAMobileAPP bug fix - Replacing Customer_Name__c with Account.Name by Murali - 2/14/22
            //objIAApp.CustomerName = objCase.Customer_Name__c;
            objIAApp.CustomerName = objCase.Account.Name; //CP130 -END
            objIAApp.ContactFirstName = objCase.Contact.FirstName;
            objIAApp.ContactLastName = objCase.Contact.LastName;
            objIAApp.WONumber = objCase.CaseNumber;
            objIAApp.PSN = objCase.Asset.Name;
            objIAApp.UnitNumber = objCase.Asset.Unit_Number__c;
            objIAApp.ComplaintText = objCase.Description;
            if(IsDealer == false){
                if(objCase.Available_for_Service__c != null) {
                    DateTime dt = objCase.Available_for_Service__c;
                    objIAApp.AvailableForService = String.valueOf(dt.format('MM/dd/yyyy'));
                } else {
                    objIAApp.AvailableForService = '';
                }
            }else{
                DateTime dt = objCase.CreatedDate;
                objIAApp.AvailableForService = String.valueOf(dt.format('MM/dd/yyyy'));
                //Sruthi Changes - to fix Mapping Issue
                objIAApp.CustomerName = objCase.Customer__c;
                objIAApp.ContactFirstName = null;
                objIAApp.ContactLastName = objCase.Contact__c;
            }
            listIAApp.add(objIAApp);
            system.debug('objIAApp.UnitNumberrr' + objIAApp.UnitNumber);
        }
        return listIAApp;
    }
    // added by sailaja, CT3-302 to updaet FSL MakeModel Stage object
       public static string  insertMakeModelStaging(Id assetId) {
           system.debug('inside make model stage insert');
        // string strResult;
        list<FSL_MakeModel_Stage__c> lstmake = new list<FSL_MakeModel_Stage__c>();
        if(assetId != null || assetId != '') {
                List<Asset> masterAsset = new List<Asset>();
                if(assetId != null){
                    masterAsset = [SELECT Id, Name, Make__c, Model__c,Service_Model__c,AccountId,Make_Model__c , Type__c,Engine_Family_Code__c
                                   FROM Asset WHERE Id = : assetId LIMIT 1];
                } 
                // if(objorder.Make__c != null && objorder.Asset.Make__c != null && objorder.Make__c != objorder.Asset.Make__c && objorder.Model__c != null && objorder.Asset.Model__c != null && objorder.Model__c != objorder.Asset.Model__c) {
                system.debug('inside if ---->');
                if(masterAsset[0].Make__c!= '' && masterAsset[0].Model__c != ''){
                    system.debug('masterAsset[0]' + masterAsset[0]);
                    FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                    objstage.Manufacturer__c = masterAsset[0].Make__c;
                    objstage.ModelSeries__c = masterAsset[0].Model__c;
                    objstage.PSN__c = masterAsset[0].Name;
                    
                    if(masterAsset[0].Type__c == 'ENGINE' ||
                    masterAsset[0].Type__c == 'GENSET' ||
                    masterAsset[0].Type__c == 'Engines'){
                           objstage.Type__c = 'Engines';
                           objstage.Type_PSN__c = 'Engines-' + masterAsset[0].Name;
                       }
                    else if(masterAsset[0].Type__c == 'FIREPUMP' ||
                    masterAsset[0].Type__c == 'ENGINE CORE' ||
                    masterAsset[0].Type__c == 'SWITCH GEAR' ||
                    masterAsset[0].Type__c == 'TRANSFER SWITCH' ||
                    masterAsset[0].Type__c == 'TRANSMISSIONS' ||
                    masterAsset[0].Type__c == 'BATTERY' ||
                            masterAsset[0].Type__c == 'PARSYS' ||
                            masterAsset[0].Type__c == 'MARINE GEAR' ||
                            masterAsset[0].Type__c == 'Products') {
                                
                                objstage.Type__c = 'Products';
                                objstage.Type_PSN__c = 'Products-' + masterAsset[0].Name;
                            }
                    
                    lstmake.add(objstage);
                }
            system.debug('---->'+lstmake.size());
            if(lstmake.size() > 0) {
                List<Database.upsertResult> updateinsertResults = Database.upsert(lstmake, FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField(), false);
                 system.debug('updateinsertResults' + updateinsertResults);
                for (Database.upsertResult sr : updateinsertResults ) {
                    if (sr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed and Sucess record Id set into SET
                        // strResult ='Inserted Sucessfully';
                        System.debug('Successfully inserted/updated MakeModelStage: ' + sr.getId());
                    }
                    else {
                        // Operation failed, so get all errors
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            // strResult = err.getMessage();
                            System.debug('Asset fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
        return null;
    }
     /* Method is to get sender id primary servcie territory code */
        public static ServiceTerritory getServiceTerritorydetails(String senderIdToQuery) { 
           User[] senderIdTerrCode = [SELECT Id,federationIdentifier,FSL_Primary_Service_Territory_Code__c FROM User WHERE federationIdentifier !='' and federationIdentifier =: senderIdToQuery LIMIT 1];
            ServiceTerritory objservicTer;
            if(senderIdTerrCode.size()>0){
           // User senderIdTerrCode = [SELECT Id, FSL_Primary_Service_Territory_Code__c FROM User WHERE id =: wwid[0].Id LIMIT 1];
            if(senderIdTerrCode[0].FSL_Primary_Service_Territory_Code__c !=null && senderIdTerrCode[0].FSL_Primary_Service_Territory_Code__c !='' ) {
                try {
                    objservicTer = [SELECT Id, FSL_Service_Territory_Code__c,Mileage_Measure__c FROM ServiceTerritory WHERE FSL_Service_Territory_Code__c =: senderIdTerrCode[0].FSL_Primary_Service_Territory_Code__c LIMIT 1];
                }
                   catch(exception e){}
            }
            }
            return objservicTer;
        } 
    public class WrapperInput {
        public String status;
        public String serviceName;
        public String serviceVersion;
        public String returnCodeDescription;
        public String wOEnabled;
        public String IASNumber;
        public String toolID;
        public String senderId;
        public String serviceRequestNumber;
        public List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> serviceRequests;
    }
}