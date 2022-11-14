public Without Sharing class dbu_ContactUs {
	@AuraEnabled
    public static void insertCon(dbu_ContactUs__c con){ 
        String contactUsRecordId = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByDeveloperName().get('dbu_ContactusRT').getRecordTypeId();
		String suscribeRecordId = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByDeveloperName().get('dbu_SuscribeRT').getRecordTypeId();
        
        String strcontactUsRecordDevName = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByName().get('dbu_ContactusRT').getDeveloperName();
        String strsuscribeRecordDevName = Schema.SObjectType.dbu_ContactUs__c.getRecordTypeInfosByName().get('dbu_SuscribeRT').getDeveloperName();
        dbu_ContactUs__c objContactUs = new dbu_ContactUs__c();
        List<dbu_ContactUs__c> lstContactUs = new List<dbu_ContactUs__c>();
        List<dbu_ContactUs__c> lstContactUsEmail = new List<dbu_ContactUs__c>();
        System.debug('con.dbu_subscribeEmailId__c >>>' + con.dbu_subscribeEmailId__c);
        System.debug('con.dbu_First_Name__c >>>' + con.dbu_First_Name__c);
        if(con.dbu_First_Name__c != null){
            System.debug('Inside 1st If');
            //objContactUs.dbu_recordType__c = strcontactUsRecordDevName;
            objContactUs.RecordTypeId = contactUsRecordId;
            objContactUs.dbu_First_Name__c = con.dbu_First_Name__c;
            objContactUs.dbu_Last_Name__c = con.dbu_Last_Name__c;
            objContactUs.dbu_Phone__c = con.dbu_Phone__c;
            objContactUs.dbu_Email__c = con.dbu_Email__c;
            objContactUs.dbu_State__c = con.dbu_State__c;
            objContactUs.dbu_Zipcode__c = con.dbu_Zipcode__c;
            objContactUs.dbu_Address__c = con.dbu_Address__c;
            objContactUs.dbu_Message__c = con.dbu_Message__c;
            objContactUs.dbu_Product_Support__c = con.dbu_Product_Support__c;
            objContactUs.dbu_ESN__c = con.dbu_ESN__c;
            objContactUs.dbu_GSN__c = con.dbu_GSN__c;
            objContactUs.dbu_Order_Confirmation_Number__c = con.dbu_Order_Confirmation_Number__c;
            objContactUs.dbu_Tell_Us__c = con.dbu_Tell_Us__c;
            objContactUs.dbu_What_Can_we_help_with_us__c = con.dbu_What_Can_we_help_with_us__c;
            objContactUs.dbu_Cummins_Product_Support__c = con.dbu_Cummins_Product_Support__c;
            
            if(con.dbu_Subscribe__c == false){
                objContactUs.dbu_Subscribe__c = true;
            }
            else{
                objContactUs.dbu_Subscribe__c = false;
            }  
            System.debug('objContactUs--->12 '+objContactUs);
            lstContactUs.add(objContactUs);
            lstContactUsEmail = [SELECT Id,dbu_isContected__c,dbu_Email__c FROM dbu_ContactUs__c WHERE dbu_Email__c = : con.dbu_Email__c];
            System.debug('lstContactUsEmails---> '+lstContactUsEmail);
            try
            {
               objContactUs.dbu_isContected__c = 'true';
               insert lstContactUs;
            }
            catch(Exception e)
            {
              System.debug('--->'+e);
            }
        }
        else
        {
                System.debug('Inside 2nd If'); 
                objContactUs.RecordTypeId = suscribeRecordId;
                objContactUs.dbu_subscribeEmailId__c = con.dbu_subscribeEmailId__c;
                if(con.dbu_Subscribe__c == false){
                    objContactUs.dbu_Subscribe__c = true;
                }
                else
                {
                    objContactUs.dbu_Subscribe__c = false;
                }  
                System.debug('current owner:=>'+ objContactUs.OwnerId);
                objContactUs.OwnerId = UserInfo.getUserId();
                System.debug('objContactUs--->12 '+objContactUs);
                lstContactUs.add(objContactUs); 
                try
                {
                    insert lstContactUs;
                }
            	catch(Exception e)
                {
                    System.debug('--->'+e);
                }
        }
    }
}