@isTest
public class FSLFailModeResWrapper_Test {
	 static testmethod void testmethod1()
     {
         String json = '{"DataArea":{"Details":[{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"VY","BusinessUnit":"CMI","TargetID":"CMI"},{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"JM","BusinessUnit":"CMI","TargetID":"CMI"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"53bf5d70-a635-46ea-8f28-64aa64157101"}}';
         FSLFailModeWrapper op = FSLFailModeWrapper.parse(json);
         system.assert(op!=null);
     }
}