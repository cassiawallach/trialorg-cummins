@isTest 
private class FlowCustomError_Test {
    static testMethod void validateThrowCustomFlowException() {
      
        Test.startTest();
		List<String> sampleErrorMessages = new List<String>();
		sampleErrorMessages.add('This error occurred when the flow tried to create records: FIELD_CUSTOM_VALIDATION_EXCEPTION: Payer Contact already exists. You can look up ExceptionCode values in the <a href=\'https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_concepts_core_data_objects.htm#\'>SOAP API Developer Guide</a>.');
		FSL_FlowCustomError.throwCustomFlowException(sampleErrorMessages);
        sampleErrorMessages[0] = 'This error occurred when the flow tried to create records: REQUIRED_FIELD_MISSING: Required fields are missing: [Test_Required__c]. You can look up ExceptionCode values in the <a href=\'https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_concepts_core_data_objects.htm#\'>SOAP API Developer Guide</a>.';
        FSL_FlowCustomError.throwCustomFlowException(sampleErrorMessages);        
       	sampleErrorMessages[0] = 'The following exception has occurred: List has no rows for assignment to SObject.';
        FSL_FlowCustomError.throwCustomFlowException(sampleErrorMessages);    
        sampleErrorMessages[0] = 'This error occurred: INSUFFICIENT_ACCESS_OR_READONLY: insufficient access rights on object id. You can look up ExceptionCode values in the <a href=\'https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_concepts_core_data_objects.htm#\'>SOAP API Developer Guide</a>.';
        FSL_FlowCustomError.throwCustomFlowException(sampleErrorMessages);    
        sampleErrorMessages[0] = 'This error occurred: DUPLICATES_DETECTED: A contact record with same name, email and/or phone exists for this account, please use that instead of creating new.. You can look up ExceptionCode values in the <a href=\'https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_concepts_core_data_objects.htm#\'>SOAP API Developer Guide</a>.';
        FSL_FlowCustomError.throwCustomFlowException(sampleErrorMessages);    
        Test.stopTest();
    }
}