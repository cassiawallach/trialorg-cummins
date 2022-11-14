@isTest
private class FSLFailModeCode_Test {
    
    @isTest static void testNamedCredentialCallout() {
        
        // Set mock data
        string body = '{"DataArea":{"Details":[{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"VY","BusinessUnit":"CMI","TargetID":"CMI"},{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"JM","BusinessUnit":"CMI","TargetID":"CMI"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"53bf5d70-a635-46ea-8f28-64aa64157101"}}';
        FSLFailModeWrapper testWrapper = (FSLFailModeWrapper)JSON.deserialize(body, FSLFailModeWrapper.Class);
        Test.setMock(HttpCalloutMock.class, new FSLFailModeMainMock());
        
        // Test
        test.starttest();
        FSLFailModeBatch fslBatch = new FSLFailModeBatch();
        Iterator<FSLFailModeWrapper> iter = fslBatch.start(null).Iterator();
        FSLFailModeWrapper wrapper = null;
        integer total_fail_modes = 0;
        while(iter.hasNext()){
            total_fail_modes += 1;
            wrapper = iter.next();
        }
        fslBatch.execute(null, new List<FSLFailModeWrapper>{wrapper});
        fslBatch.finish(null);
        system.assert(total_fail_modes==1);
        system.assert(wrapper.Header.MessageIdentifier == testWrapper.Header.MessageIdentifier);
		test.stoptest();
    }
}