/************************************************************
Name:  OSM_SW_Header_Ctrl 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the Controller Class for the Header for OSM
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -   OSM_Developement         19/05/2018     INITIAL DEVELOPMENT          
1.1 - Karthik Golakaram      05/24/2022     MP-854 - Cart contact details
*************************************************************/
global without sharing class OSM_SW_Header_Ctrl 
{
     
    public String googeAnalyticId {get; set;}
    public String googleAdditionalSrc {get; set;}
    public String currentUserId {get; set;}
    public boolean Isguest{set;get;}
    public boolean showEffectiveAccount{set;get;}
    public String FirstName{get;set;}
    public string loginUrl{get;set;}
    public boolean nonUSCustomer{get;set;}
    public boolean nonTermCustomer{get;set;}
    public boolean isOnBehalfLogin{get;set;}
    public String  maintenanceMessage{get;set;}
    public Boolean showMaintainMessage{get;set;}
    public Boolean showRenewalMessage{get;set;}
  global static String storelocationflag {get;set;} //Added By Dhiraj
    //public static String storelocationflagUS {get;set;} //Added By Dhiraj
    //public static String storelocationflagCA {get;set;} //Added By Dhiraj
    
    public OSM_SW_Header_Ctrl() 
    {
        Google_Analytic_ID__c currentgoogleId = Google_Analytic_ID__c.getOrgDefaults();
        googeAnalyticId = currentgoogleId.GoogleCode_Id__c;
        googleAdditionalSrc = currentgoogleId.Google_AdditionalSrc__c;
        this.nonUSCustomer = false;
        this.nonTermCustomer=false;
        this.showMaintainMessage=false;
        this.showRenewalMessage=false;
        currentUserId = String.valueOf(UserInfo.getProfileId());
        String currAccId;
        if(!Test.isRunningTest())
          currAccId= ccrz.cc_CallContext.currAccountId;
        isOnBehalfLogin = ccrz.cc_CallContext.isOnBehalf;
        if(Test.isRunningTest())
        {
            Isguest=true;
        }
        else
        {
            Isguest = ccrz.cc_CallContext.isGuest;
        }
            ccrz.ccLog.log(System.LoggingLevel.DEBUG,'Guest User', +Isguest);
            if (!Isguest|| Test.isRunningTest()) 
            {
                //User usr = OSM_SW_ProdDetailUtils_Ctrl.getUserDetailbyContact(ccrz.cc_CallContext.currContact.Id);
                //FirstName = usr.FirstName;
                if(Test.isRunningTest())
                {
                    List<Account> accss = new List<Account>();
                    accss = [select Id from Account limit 1];
                    if(accss.size()>0)
                        currAccId = accss[0].Id;
                }
                List<Account> accs = [SELECT id,BillingCountry,ShippingCountry,CSS_DistributorCode__c FROM Account WHERE id =: currAccId];
                if(accs[0].BillingCountry != null)
                {
                    if(!accs.isEmpty() && !Label.OSM_North_America_Country.containsignorecase(accs[0].BillingCountry) && !label.OSM_PO_Distributor_List.contains(accs[0].CSS_DistributorCode__c)){
                        nonUSCustomer = true;
                    }
                }
                else if(accs[0].ShippingCountry != null)
                {
                    if(!accs.isEmpty() && !Label.OSM_North_America_Country.containsignorecase(accs[0].ShippingCountry) && !label.OSM_PO_Distributor_List.contains(accs[0].CSS_DistributorCode__c)){
                        nonUSCustomer = true;
                    }
                }
                    
                  

                String cartId = ccrz.cc_CallContext.currCartId;
                FirstName  = UserInfo.getFirstName();
                Id userId = ccrz.cc_CallContext.currUserId;
                Boolean effectiveSelectEnabled = false;
                List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c,OSM_Term_Condition_Acceptance_Date__c     FROM User WHERE id=:userId];
                String userType = '';
                if(!currUser.isEmpty()){
                    if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c)){
                        effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));
                        if(featureSwitch != null)
                            effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
                    }
                }
                this.showEffectiveAccount = effectiveSelectEnabled;
               
                if(ccrz.cc_CallContext.currContact != null){
                     FirstName  = ccrz.cc_CallContext.currContact.FirstName;
                }
                if(currUser!=null && currUser[0].OSM_Term_Condition_Acceptance_Date__c==Null && nonUSCustomer==false &&  isOnBehalfLogin==false)
                nonTermCustomer=true;
               //MP-734 Code Start
                 set<id> renewIds = new set<id>();
                 for(ccrz__E_Subscription__c subs:[Select id,Name,ccrz__Account__c,Renewed_From_Subscription__c from ccrz__E_Subscription__c where ccrz__Account__c=:currAccId AND ccrz__SubscriptionStatus__c='Renew']){
                     renewIds.add(subs.Renewed_From_Subscription__c);
                 }
                 list<ccrz__E_Subscription__c> listsubS= new list<ccrz__E_Subscription__c>();
                 listsubS=[Select id,Name,ccrz__Account__c,OSM_Subscription_End_Date__c from ccrz__E_Subscription__c where ccrz__Account__c=:currAccId AND OSM_Subscription_End_Date__c <=: system.today().addDays(+30) AND OSM_Subscription_End_Date__c >=: system.today() AND ccrz__SubscriptionStatus__c='Active' AND ID Not IN:renewIds];
                 system.debug('listsubS-->>'+listsubS);
                 if(listsubS.size()>0){
                     showRenewalMessage=true;
                 }
               //MP-734 Code Ends
            }
        
         if(Isguest)
         {
            String urlPath = Site.getPathPrefix();
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm(); 
            baseUrl = getUrl(baseUrl);
            String currentPage = String.valueOf(ApexPages.currentPage());
            currentPage = currentPage.removeStart('System.PageReference[/apex');
            currentPage = currentPage.removeEnd(']');
            loginUrl = label.OSM_Login_App_Url + '&retURL='+ baseUrl+ urlPath+currentPage;//+getUrlParams(ApexPages.currentPage().getParameters());   
        }
        
         DateTime StartDate;
         DateTime EndDate;
                
        List<OSM_Maintenance_Message__c> currRecord = [SELECT Id,Start_Time__c,End_Time__c,Start_Date__c,End_Date__c, System_Available__c, Show_Custom_Message__c, Custom_Maintenance_Message__c  FROM  OSM_Maintenance_Message__c ORDER BY CreatedDate DESC limit 1];
        
        if(currRecord!=null  && currRecord.size()>0)
        {
                if(!currRecord[0].System_Available__c || Test.isRunningTest())
                {
                    String myEndTimeUpdated='';
                    String myStartTimeUpdated='';
                    String myStartTime='';
                    String myEndTime='';
                    maintenanceMessage='';
                    DateTime now = System.now();
                    Time nowTime = now.time();
                    //String myStartTime=currRecord[0].Start_Time__c.hour() +':'+currRecord[0].Start_Time__c.minute();
                    if(currRecord[0].Start_Time__c!=null)
                    myStartTime=String.valueOf(currRecord[0].Start_Time__c);
                    
                    if(myStartTime!=null && myStartTime.contains('.000Z'))
                    myStartTimeUpdated=myStartTime.removeEnd('.000Z');
                    //String myEndTime=currRecord[0].End_Time__c.hour() +':'+currRecord[0].End_Time__c.minute();
                    
                    if(currRecord[0].End_Time__c!=null)
                    myEndTime=String.valueOf(currRecord[0].End_Time__c);
                    
                    if(myEndTime!=null && myEndTime.contains('.000Z'))
                    myEndTimeUpdated=myEndTime.removeEnd('.000Z');
                    System.debug('My Start Time'+myStartTime+'end Time is'+myEndTime);
                    //System.debug('Start date is'+currRecord[0].Start_Date__c+'End date is'+currRecord[0].End_Date__c+'Today date is'+System.today());
                    if(currRecord[0].Start_Date__c!=null && currRecord[0].End_Date__c!=null && System.today() >= currRecord[0].Start_Date__c && (currRecord[0].Start_Time__c<nowTime && currRecord[0].End_Time__c>nowTime) && System.today() <= currRecord[0].End_Date__c ){
                    	if(currRecord[0].Show_Custom_Message__c == false){
                    		maintenanceMessage='Marketplace is having a scheduled maintenance from '+myStartTimeUpdated+ ' on ' +currRecord[0].Start_Date__c.format()+' until '+ myEndTimeUpdated+ ' on ' + currRecord[0].End_Date__c.format() + ' and cannot process orders during this period . Thank you for your patience.';                            
                        }else if(currRecord[0].Show_Custom_Message__c == true){
                            maintenanceMessage = currRecord[0].Custom_Maintenance_Message__c + ' . '+'Marketplace is having a scheduled maintenance from '+myStartTimeUpdated+ ' on ' +currRecord[0].Start_Date__c.format()+' until '+ myEndTimeUpdated+ ' on ' + currRecord[0].End_Date__c.format() + ' and cannot process orders during this period .' + ' Thank you for your patience.'; 
                                                        }                    	 
                        this.showMaintainMessage=true;
                    }
                }
                else
                {
                    this.showMaintainMessage=false;
                }
            }
        //System.debug('conatructor location =' + storelocationflag);
         
        
        //Below Code Added by Dhiraj
            //Cache.Session.remove('storelocationflagKey');
            //storelocationflag ='us';
            if (UserInfo.getUserType() != 'Guest'){      
            if((String) Cache.Session.get('storelocationflagKey') == 'us'){storelocationflag ='us';} 
            if((String) Cache.Session.get('storelocationflagKey') == 'canada'){storelocationflag ='canada';} 
            }
            //Code Ended
        
    }
    
    String getUrl(String returls)
    {
        if(Label.OSM_Login_Include_https == 'true' && !returls.contains('https://')){
                    returls = 'https://'+returls;
                }
                    
                if(Label.OSM_Login_Include_https != 'true' && returls.contains('https://')){
                        returls = returls.replace('https://','');                    
                    }
        return returls;
    }

    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult invalidateCartItem(ccrz.cc_RemoteActionContext ctx)
    {
      
       ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult result = new ccrz.cc_RemoteActionResult();
        result.success = true;
        system.debug('ctx--->'+ctx);
        String cartEncId = ccrz.cc_CallContext.currCartId;

        //MP-854 - Changes for On behalf of Effective Account 
        List<Contact> loggedInContact = [SELECT id, IAM_Contact_Owner__c, OSM_Distributor_Admin_Last_Sel__c, OSM_Distributor_Admin_Last_Sel_acc__c 
                                         FROM Contact 
                                         WHERE IAM_Contact_Owner__c=:UserInfo.getUserId() LIMIT 1];
        List<ccrz__E_Cart__c> cartDetails = [SELECT id, ccrz__Account__c, ccrz__Contact__c, ccrz__EffectiveAccountID__c
                                             FROM ccrz__E_Cart__c
                                             WHERE ccrz__EncryptedId__c=: cartEncId LIMIT 1];
        if(!loggedInContact.isEmpty()) {
            if(String.isNotBlank(loggedInContact[0].OSM_Distributor_Admin_Last_Sel_acc__c) && String.isNotBlank(loggedInContact[0].OSM_Distributor_Admin_Last_Sel__c)) {
                if(loggedInContact[0].OSM_Distributor_Admin_Last_Sel_acc__c == cartDetails[0].ccrz__EffectiveAccountID__c
                && (loggedInContact[0].OSM_Distributor_Admin_Last_Sel_acc__c != cartDetails[0].ccrz__Account__c || 
                loggedInContact[0].OSM_Distributor_Admin_Last_Sel__c != cartDetails[0].ccrz__Contact__c)) {
                    System.debug('Printing detials of the cart that is going to update'+cartDetails);
                    cartDetails[0].ccrz__Account__c = loggedInContact[0].OSM_Distributor_Admin_Last_Sel_acc__c;
                    cartDetails[0].ccrz__Contact__c = loggedInContact[0].OSM_Distributor_Admin_Last_Sel__c;
                    update cartDetails;
                }
            }
        }
        //MP-854 Changes for Effective Account to get correct contact details

        if(String.isNotBlank(cartEncId))
        {
            List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
            
            lstCartItem = [Select Id,ccrz__Product__c, ccrz__Product__r.Group_Name__c,ccrz__DisplayProduct__c,ccrz__Cart__r.ccrz__Account__c from ccrz__E_CartItem__c where ccrz__Cart__r.ccrz__EncryptedId__c =: cartEncId AND CreatedDate < TODAY ];
            
            System.debug('Cart Item To query: '+lstCartItem);
            
            if(lstCartItem != null && lstCartItem.size() > 0)
            {
                    
                List<ccrz__E_Subscription__c> lstSubsc = new List<ccrz__E_Subscription__c>();
                
                Id accountId = lstCartItem[0].ccrz__Cart__r.ccrz__Account__c;
                lstSubsc = [Select Id,ccrz__SubscriptionProduct__c, OSM_Display_Product__c,ccrz__SubscriptionProduct__r.Group_Name__c  from ccrz__E_Subscription__c where ccrz__Account__c =: accountId AND OSM_Subscription_End_Date__c >= TODAY AND ccrz__SubscriptionStatus__c = 'Active'];
                
                if(lstSubsc.size() > 0 )
                {
                        try
                        {
                            delete lstCartItem;
                        }
                        Catch(Exception ex)
                        {
                            System.debug('Error in method invalidCartItem '+ex);
                        }
                    
                }
            }
            
            
        }
        return result;
    }
   @RemoteAction
    global static ccrz.cc_RemoteActionResult getCurrProratedTotal(ccrz.cc_RemoteActionContext ctx){
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        try{
            String cartId = ccrz.cc_CallContext.currCartId;
            // List<ccrz__E_Cart__c> cartforId = new List<ccrz__E_Cart__c>();
            // ccrz__E_Cart__c currCart;
            List<Map<String, Object>> outputCartList;
             
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPICart.CART_ENCID => cartId,
                ccrz.ccAPI.API_VERSION => 8,
                ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_S
            };
            Map<String, Object> outputData = ccrz.ccAPICart.fetch(inputData);
            if (outputData.get(ccrz.ccAPICart.CART_OBJLIST) != null) {
                // The cast to List<Map<String, Object>> is necessary...
                outputCartList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPICart.CART_OBJLIST);

                // The cast, again, is necessary...
        
            }

            // cartforId = [SELECT Id, Sum_Prorated_Price_AfterDiscount__c FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =:cartId];
            // if(!cartforId.isEmpty()){
            //     currCart = cartforId[0];
            // }
            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'outputData'=>outputCartList});
        }catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','getCurrProratedTotal');
            ccrz.ccLog.close(response);
        }
        return response;
    }
     @RemoteAction
    global static ccrz.cc_RemoteActionResult getTermsConditionSelDate(ccrz.cc_RemoteActionContext ctx){
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
         Id userId = ccrz.cc_CallContext.currUserId;
                
        List<User> currUser = [SELECT Id,OSM_Term_Condition_Acceptance_Date__c     FROM User WHERE id=:userId];
        try{
            if(currUser!=null)
            {
              currUser[0].OSM_Term_Condition_Acceptance_Date__c=system.today();
              update currUser;
              response.success=true;
            }
        }
        catch (Exception e) {
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','getCurrProratedTotal');
            ccrz.ccLog.close(response);
        }
        
       
        return response;
      }
    
    
    @RemoteAction
    global static String goToUSStore(String location){
        Cache.Session.remove('storelocationflagKey'); 
        storelocationflag = location;
        Cache.Session.put('storelocationflagKey', storelocationflag);
        return storelocationflag;
    }
   @RemoteAction
    global static String goToCAStore(String location){
        Cache.Session.remove('storelocationflagKey'); 
        System.debug('location =' + location);
        storelocationflag = location;
        Cache.Session.put('storelocationflagKey', storelocationflag);
        return storelocationflag;
    }       
}