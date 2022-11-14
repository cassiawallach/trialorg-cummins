global with sharing class OSM_SW_cc_hk_UserInterface extends ccrz.cc_hk_UserInterface.v004 {


    global virtual override String standardRespondJS(){
            String retString = super.standardRespondJS();
            ccrz.ccLog.log('OSM_SW_cc_hk_UserInterface retString:  '+ retString);
            String googeAnalyticId;
        
            Google_Analytic_ID__c currentgoogleId = Google_Analytic_ID__c.getOrgDefaults();
        
            googeAnalyticId = currentgoogleId.GoogleCode_Id__c;
        	String googeAnalytic_GTMAuth = currentgoogleId.Google_GTM_Auth__c;
            String googeAnalytic_GTMPreview = currentgoogleId.Google_GTM_Preview__c;
        	String googleAnalyticAdditionalSrc = currentgoogleId.Google_AdditionalSrc__c;
            
        	retString += '<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({\'gtm.start\': new Date().getTime(),event:\'gtm.js\'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!=\'dataLayer\'?\'&l=\'+l:\'\';j.async=true;j.src=\'https://www.googletagmanager.com/gtm.js?id=\'+i+dl+\''+googleAnalyticAdditionalSrc+'\';f.parentNode.insertBefore(j,f);})(window,document,\'script\',\'dataLayer\',\''+googeAnalyticId+'\');</script>';
        
            ccrz.ccLog.log('OSM_SW_cc_hk_UserInterface retString2 :  '+ retString);
            return retString;
        
    }


}