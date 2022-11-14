@isTest(SeeAllData=true)
public class CSS_getOverlapSRT_Test {
    // method to Test Jobplan inbound
    static TestMethod void testCSS_getOverlapSRT() {
        // Set mock callout class    
       
        Test.setMock(HttpCalloutMock.class, new CSS_getOverlapSRT_mock_Test ());
        Test.startTest();
                CSS_getOverlapSRTReqJ2A   req = new CSS_getOverlapSRTReqJ2A  ();
req.Header= new CSS_getOverlapSRTReqJ2A.Header();
req.Header.Sender= new CSS_getOverlapSRTReqJ2A.Sender();
req.Header.Sender.ServiceName = 'GetOverlapSRT';
req.Header.Sender.SenderID='CSS';
req.Header.Target= new CSS_getOverlapSRTReqJ2A.Target();
req.Header.Target.TargetID='SRT';
req.DataArea= new CSS_getOverlapSRTReqJ2A.DataArea();
req.DataArea.Jobid='CSS-000001234';
req.DataArea.ClaimID='C100002045';
req.DataArea.Languagecode='en';
req.DataArea.DTTimestamp='2016-10-03T14:52:26.412-04:00';
req.DataArea.EffectiveDTTime='2016-10-03T14:52:26.412-04:00';
req.DataArea.Steps  = new list<CSS_getOverlapSRTReqJ2A.Steps>();
CSS_getOverlapSRTReqJ2A.Steps ser = new CSS_getOverlapSRTReqJ2A.Steps();
ser.StepId=1234;
ser.Qty=2;
ser.AccessCode='R';

req.DataArea.Steps.add(ser);


     CSS_getOverlapSRT.getOverlapSRTDetails(req);
        Test.stopTest();
        //System.assertEquals('expected'; a.Description);
    }
    
}