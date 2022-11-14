/* It accepts location data from WWSPS system and process those new/updated/cancelled locations in IAM */

@RestResource(urlMapping='/wwsps/location/*')
global class IAM_WWSPS_Location_Data_Tranformation{
    
    /* Read request and parse request body */
    @HttpPost
    global static void post() {        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;      
        String requestbody = request.requestBody.toString().trim(); 
        System.debug('### Request Body '+ requestBody);
        if(String.isNotBlank(requestbody)) {        
            try {
                IAM_WWSPS_Location_Parser location =IAM_WWSPS_Location_Parser.Parse(requestbody);
                
                System.debug('#### Printing request body '+location);
                String errorMsg = validateRequest(location.locationInfo);
                String responseString = '';
                if(String.isBlank(errorMsg)) {
                    if(location.locationInfo.Action.Trim().equalsIgnoreCase('New')) {
                        // Create Account
                        responseString = IAM_WWSPS_New_Location_Creation.createWWSPSlocation(location.locationInfo);
                    } else if(location.locationInfo.Action.Trim().equalsIgnoreCase('Change')) {
                        // Update Account
                        responseString = IAM_WWSPS_New_Location_Creation.updateWWSPSlocation(location.locationInfo);
                    } else if(location.locationInfo.Action.Trim().equalsIgnoreCase('Cancel')) {
                        // Cancel/Inactivate Account
                        responseString = IAM_WWSPS_Location_Cancellation.cancelLocation(location.locationInfo);
                        System.debug('Prinitng response String'+responseString);
                    }
                    
                    if(String.isNotBlank(responseString)) {
                        response = getResponse(200, responseString, true);   
                    } else {
                        responseString = 'Not able to process location information. Something unexpected has happened.';
                        captureError(responseString, requestbody);
                        response = getResponse(200, responseString, false);
                    }
                     
                } else {
                    captureError(errorMsg, requestbody);
                    response = getResponse(200, errorMsg, false);
                }
            } catch(Exception e) {
                captureError(e.getMessage(), requestbody);
                response = getResponse(200, e.getMessage(), false);
            }
        }
    }
    
    /* Validate the request to check if all mandatory fields are available */
    private static String validateRequest(IAM_WWSPS_Location_Parser.locationInfo location) {
        
        String fieldName = '';
        List<String> requiredFieldList = new List<String>();
        List<String> validFieldValueList = new List<String>();
        List<String> buValues=new List<String>{'Engines','Power Generation','Turbocharger','Filtration'};
        List<String> actionValues= new List<String>{'New','Changed','Cancel'};    

        if(String.isBlank(location.SPcode)) {
            requiredFieldList.add('SPcode');
        }
        if(String.isBlank(location.ServiceProviderName)) {
            requiredFieldList.add('ServiceProviderName');
        }
        if(String.isBlank(location.COD)&&(!location.action.equalsIgnoreCase('Cancel'))) {
            requiredFieldList.add('COD');
        }
        if(String.isNotBlank(location.OwnershipName)) {            
            Set<String> values = IAM_WWSPS_Utility.getPicklistValues('Ownership','Account');
            System.debug('#### tmplist Ownership - '+values );
            if(!values.contains(location.OwnershipName)){
                validFieldValueList.add('OwnershipName');
            }   
        }
        if(String.isBlank(location.Buss_entity_name)) {
            requiredFieldList.add('Buss_entity_name');
        }
        if(String.isBlank(location.Action)) {
            requiredFieldList.add('Action');
        }
        if(String.isBlank(location.DistributorCode)) {
            requiredFieldList.add('DistributorCode');
        }
        if(String.isBlank(location.DistributorRegion)) {
            requiredFieldList.add('DistributorRegion');
        } else {
            Set<String> values = IAM_WWSPS_Utility.getPicklistValues('IAM_WWSPS_Regions__c','Account');
            System.debug('#### tmplist region - '+values );
            if(!values.contains(location.DistributorRegion)){
                validFieldValueList.add('DistributorRegion');
            }   
        }
        
       /* if(String.isNotBlank(location.State)) {
            Set<String> values = IAM_WWSPS_Utility.getPicklistValues('ShippingStateCode','Account');
            System.debug('#### tmplist State - '+values );
            if(!values.contains(location.State)){
                validFieldValueList.add('State');
            } 
        }
        if(String.isNotBlank(location.Country)) {
            Set<String> values = IAM_WWSPS_Utility.getPicklistValues('ShippingCountryCode','Account');
            System.debug('#### tmplist Country - '+values );
            if(!values.contains(location.Country)){
                validFieldValueList.add('Country');
            } 
        }*/
        
        String errorMsg = '';
        if(!requiredFieldList.isEmpty()) {
            errorMsg = String.join(requiredFieldList, ', ') + ' are required field(s). ';
        }
        if(!validFieldValueList.isEmpty()) {
            errorMsg = errorMsg + String.join(validFieldValueList, ', ') + ' field(s) contain invalid data.';
        }
        System.debug('#### errorMsg ' + errorMsg);
        return errorMsg;
    }

    /* Response returned from IAM */    
    private static RestResponse getResponse(Integer statusCode, String message, Boolean isSuccess) {
        String jsonResponse='';
        RestResponse response = RestContext.response;
        response.addHeader('Content-Type','application/json');
        response.statusCode = statusCode;
        if(isSuccess) {
           jsonResponse='{\n"message":"'+message+'",\n"statusCode":"'+statusCode+'",\n"Status":"Success",\n"Data":null\n}'; 
            //response.responseBody = blob.valueOf('Success : ' + message);
        } else {
            jsonResponse='{\n"message":"'+message+'",\n"statusCode":400,\n"Status":"Error",\n"Data":null\n}';
            //response.responseBody = blob.valueOf('Error : ' + message);
        }
        response.responseBody = blob.valueOf(jsonResponse);
        System.debug('return response'+response);
        return response;
    }
    
    /* If there is error in location creation/updation/revokation then it is 
     * captured in Identity Management Error object*/
    public static void captureError(String errorMsg, String requestData){
        IAM_Identity_Management_Errors__c errObj = new IAM_Identity_Management_Errors__c();
        errObj.IAM_Error_Source__c = 'IAM WWSPS';
        errObj.IAM_Error_Description__c = errorMsg;
        errObj.IAM_Processed_Data__c = requestData;        
        insert errObj;
    }
}