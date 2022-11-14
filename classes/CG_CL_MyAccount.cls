/**********************************************************************
Name:CG_CL_MyAccount
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for the page CG_MyAccount
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                DETAIL                                 
1.0 -    Miruthula Kanagaraj    15/10/2019    INITIAL DEVELOPMENT                    
***********************************************************************/

public class CG_CL_MyAccount {
    public list<CSS_UserLocation__c> lstUserLocations;
    public list<CSS_UserLocation__c> lstUserJobLocations{get;set;}
    public list<CSS_UserLocation__c> lstUserClaimLocations{get;set;}
    public List<activeLocationsWrapper> locationWrapperListJob{get;set;}
    public List<activeLocationsWrapper> locationWrapperListClaim{get;set;}
    
    public CG_CL_MyAccount(){
        fetchUserLocations();
    }
    public List<CSS_UserLocation__c> JobLocations{get{
        if(JobLocations==null)JobLocations = [Select id,Location_Name__c,isServiceJobs__c,Location_Source__c from CSS_UserLocation__c where UserId__c=:userInfo.getUserId() and isServiceJobs__c = true and isActive__c = true and Location_Source__c = 'LDAP'];
        return JobLocations;
    }set;}

    public List<CSS_UserLocation__c> ClaimLocations{get{
        if(ClaimLocations==null)ClaimLocations = [Select id,Location_Name__c, Enable_Claim__c,isClaims__c,Location_Source__c from CSS_UserLocation__c where UserId__c=:userInfo.getUserId() and isClaims__c = true and isActive__c = true and Location_Source__c = 'ARF'];
        return ClaimLocations;
    }set;}

    public User userDetail{get{
        if(userDetail==null)userDetail = [SELECT id, DefaultCurrencyIsoCode, CurrencyIsoCode From User Where id =: userInfo.getUserId() limit 1];
        return userDetail;
    }set;} 

    public list<CurrencyType> Currencies{get{
        if(Currencies==null)Currencies = [SELECT Id, IsoCode, ConversionRate FROM CurrencyType where IsActive = true];
        return Currencies;
    }set;}

    public String selectedValue{get;set;}

    public List<SelectOption> getOptions(){
        try{
            Map<string, string> currMap = new Map<string, string>();
            for(Schema.PicklistEntry f : CurrencyType.IsoCode.getDescribe().getPicklistValues()) {
                currMap.put(f.getValue(), f.getLabel());
            }

            system.debug('currMap>>>' + currMap);

            List<SelectOption> options = new List<SelectOption>();
            for(CurrencyType f : Currencies)
            {
                if(userDetail.DefaultCurrencyIsoCode == f.IsoCode){
                    selectedValue = f.IsoCode ;
                }    
                options.add(new SelectOption(f.IsoCode,currMap.get(f.IsoCode)));
            }
            system.debug('options'+options);
            system.debug('selectedValue' +selectedValue); 

            return options;
        }
        catch(exception e){
            system.debug('Exception in linenumber>> ' +e.getLineNumber() + 'Message' + e.getMessage());
        }
        return null;
    }

    public String selCurrency {get;set;}
    public String assignSelCurrency;

    public void OnChangeSelectedCurrency(){
        system.debug('selCurrency>>>' + selCurrency);
        assignSelCurrency = selCurrency;
    }
    
    public void SaveAndContinue(){
        //assignSelCurrency = selCurrency;
       system.debug('assignSelCurrency' +assignSelCurrency);
       if(assignSelCurrency!=null)
            userDetail.DefaultCurrencyIsoCode = assignSelCurrency;
        else
             userDetail.DefaultCurrencyIsoCode = selectedValue;
             
        update userDetail;
    }
    
    public void fetchUserLocations(){
        lstUserLocations = new list<CSS_UserLocation__c>();
        lstUserLocations = CG_BL_Claims.fetchActiveLocations();
        system.debug('lstUserLocations--'+lstUserLocations);

        if(lstUserLocations != null && lstUserLocations.size() > 0){
            lstUserJobLocations = new list<CSS_UserLocation__c>();
            //lstUserClaimLocations = new list<CSS_UserLocation__c>();
            locationWrapperListClaim = new List<activeLocationsWrapper>();
            for(CSS_UserLocation__c userLoc: lstUserLocations){
                if(userLoc.Location_Source__c == 'LDAP'){
                    lstUserJobLocations.add(userLoc);
                }
                /*else if(userLoc.Location_Source__c == 'ARF'){
                    //locationWrapperListClaim.add(new activeLocationsWrapper(userLoc.Location_code__c,userLoc.Location_Name__c,userLoc.isPrimary__c));
                    lstUserClaimLocations.add(userLoc);
                }*/
            }
            system.debug('lstUserJobLocations--'+lstUserJobLocations);
            system.debug('lstUserClaimLocations--'+lstUserClaimLocations);
        }
    }
    
    public class activeLocationsWrapper{
        public String locCode{get; set;}
        public String locName{get; set;}
        public Boolean isPrimary{get; set;}

        public activeLocationsWrapper(string locCode, string locName, boolean isPrimary){
            this.locCode = locCode;
            this.locName = locName;
            this.isPrimary = isPrimary;
        }
    }


}