@isTest
public class CSS_FiveStarFeedbackController_Test {
    Static testmethod void CSS_FiveStarFeedbackController_Test_Method(){
        CSS_Feedback_Form__c fb = new CSS_Feedback_Form__c();
        Test.startTest();
        fb.FiveStarRating__c = 'Test';
        fb.Message__c = 'Test';
        fb.Username__c = 'Venkat';
        fb.UserLocation__c = 'Bangalore';
        fb.UserId__c = '12345';
        fb.Region__c = 'bangalore';
        fb.UserLocationName__c = 'Test';
        insert fb;
    test.stopTest();
    CSS_FiveStarFeedbackController fiveStarfeedback = new CSS_FiveStarFeedbackController();
    fiveStarfeedback.saveFeedback();
    fiveStarfeedback.saveNoThanks();
	}
}