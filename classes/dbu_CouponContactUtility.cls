public class dbu_CouponContactUtility {
   
    public static Map<String,Boolean> getCouponContacts(List<Ecom_Coupon_Contact__c> couponContact){
        
        Map<String,Boolean> contactInclusionMap = new Map<String,Boolean>();
        contactInclusionMap.put('isIncluded',false);
        contactInclusionMap.put('isExcluded',false);
        if(UserInfo.getUserType() != 'Guest'){
            List<Ecom_Coupon_Contact__c> couponExclusionContacts = new List<Ecom_Coupon_Contact__c>();
            User currentUser = [SELECT Id,	CompanyName,ContactId FROM User WHERE id =: UserInfo.getUserId()];
            Contact currentUserContact = new Contact();
            if(currentUser.ContactId != Null){
                currentUserContact = [select Id, Email from Contact where Id=:currentUser.ContactId];
            }
            System.debug('ContactList ===='+ couponContact.size());
            if(couponContact.size() > 0){
            for(Ecom_Coupon_Contact__c contactObj : couponContact){
                if(contactObj.Ecom_Coupon_Contact_Type__c == 'Inclusion'){
                    if(contactObj.Contact__r.Email == currentUserContact.Email){
                        contactInclusionMap.put('isIncluded', true);
                    }
                }else if(contactObj.Ecom_Coupon_Contact_Type__c == 'Exclusion'){
                     if(contactObj.Contact__r.Email == currentUserContact.Email){
                        contactInclusionMap.put('isExcluded', true);
                    }
                }
            }
            }//else{
             //   contactInclusionMap.put('isExcluded', true);
             //   return contactInclusionMap;
            //}
        }
        return contactInclusionMap;
    }
}