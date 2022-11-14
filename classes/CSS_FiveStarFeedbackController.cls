/**********************************************************************
Name:CSS_FiveStarFeedbackController
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: 5* Rating                                                         
======================================================
======================================================
History                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish         04/10/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_FiveStarFeedbackController
{
    public string stValue{get; set;}
    public string strMessage{get;set;}

    public CSS_FiveStarFeedbackController()
    {
        system.debug('Anirudh'+(String)Cache.Session.get('local.CSSPartition.UserLoginCounter'));
        String UserLoginValue = (String)Cache.Session.get('local.CSSPartition.UserLoginCounter');
        if(UserLoginValue == null){
        	User u = [select Id,User_Location__c from user where id=:userInfo.getUserId() LIMIT 1];
            css_utility.setSessionVariables(u.User_Location__c);
        }
        // fb=[select Message__c, FiveStarRating__c from CSS_Feedback_Form__c];

    }
    public void saveFeedback()
    {
        try
        {
            //CSS_Feedback_Form__c fb=[select Message__c, FiveStarRating__c from CSS_Feedback_Form__c];
            system.debug('stValue'+stValue + strMessage);

            Id recordTypeId = Schema.SObjectType.CSS_Feedback_Form__c.getRecordTypeInfosByName().get('FiveStarRating').getRecordTypeId();

            CSS_Feedback_Form__c fb = new CSS_Feedback_Form__c();
            fb.FiveStarRating__c = stValue;
            fb.Message__c = strMessage;
            fb.Username__c = userInfo.getFirstName() + ' ' +userInfo.getLastName(); 
            fb.UserLocation__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            fb.UserId__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
            fb.Region__c = (String)Cache.Session.get('local.CSSPartition.UserRegion');
            fb.UserLocationName__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationName');
            fb.recordTypeId = recordTypeId;
            insert fb;
            
            user u = new user();
            u.UserLoginCounter__c=0;
            u.Id=userInfo.getUserId();
            update u;

            Cache.Session.put('local.CSSPartition.UserLoginCounter', '0');
        }
        catch(exception e)
        {
            system.debug('Save FiveStarRating '+ e.getMessage());
        }
    }
    public void saveNoThanks()
    {
        try
        {
            
            user u = new user();
            u.UserLoginCounter__c=0;
            u.Id=userInfo.getUserId();
            update u;
            
            Id recordTypeId = Schema.SObjectType.CSS_Feedback_Form__c.getRecordTypeInfosByName().get('FiveStarRating').getRecordTypeId();

            CSS_Feedback_Form__c fb = new CSS_Feedback_Form__c();
            fb.FiveStarRating__c = '0';
            fb.Message__c = 'NoThanks';
            fb.Username__c = userInfo.getFirstName() + ' ' +userInfo.getLastName(); 
            fb.UserLocation__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            fb.UserId__c = (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier');
            fb.Region__c = (String)Cache.Session.get('local.CSSPartition.UserRegion');
            fb.UserLocationName__c = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationName');
            fb.recordTypeId = recordTypeId;
            insert fb;
            
            Cache.Session.put('local.CSSPartition.UserLoginCounter', '0');
            
           // system.debug('stValue'+u.UserLoginCounter__c);
            
        }
        catch(exception e)
        {
            system.debug('No Thanks FiveStarRating '+ e.getMessage());
        }
    }    

}