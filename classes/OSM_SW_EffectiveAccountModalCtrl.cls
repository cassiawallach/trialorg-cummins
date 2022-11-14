/************************************************************
Name:  OSM_SW_EffectiveAccountModalCtrl 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is to over the effective account in OSM.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -   OSM_Developement         19/05/2018     INITIAL DEVELOPMENT          
1.1 - Karthik Raj Golakaram      05/24/2022     MP-854 - Cart contact details
*************************************************************/
global without sharing class OSM_SW_EffectiveAccountModalCtrl {
    public boolean showEffectiveAccount{set;get;}

    public OSM_SW_EffectiveAccountModalCtrl() {
        Boolean effectiveSelectEnabled = false;
        Id userId = ccrz.cc_CallContext.currUserId;
       if(!ccrz.cc_CallContext.isGuest || test.isRunningTest()){
          
            List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c FROM User WHERE id=:userId];
            String userType = '';
            if(!currUser.isEmpty()){
                if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c)){
                    effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));
                    if(featureSwitch != null)
                        effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
                }
            }
       }
       this.showEffectiveAccount = effectiveSelectEnabled;

    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getContactsList(ccrz.cc_RemoteActionContext ctx, String selAccId)
    {
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        id userId = UserInfo.getUserId();
        try{
            List<Contact> contacts = [SELECT Id, Name,MailingAddress,IAM_Contact_Owner__c FROM Contact WHERE AccountId =:selAccId or  IAM_Contact_Owner__c =:userId order by Name asc];
            //Contact con = [Select Id, Name,MailingAddress,IAM_Contact_Owner__c from Contact where IAM_Contact_Owner__c =:userId LIMIT 1];
            
           // system.debug('contact>>>>>'+con);
            system.debug('user id>>>>>'+userId);
            // System.debug('finalReturnContact');
            // System.debug(finalReturnContact);
            //contacts.add(con);
            if(!contacts.isEmpty()){
                CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'contacts' => contacts});
            } else{
                CCOSMPageUtil.buildResponseData(response,false, new Map<String, Object>{'message' => 'No contacts found'});
            }
            
        }
        catch(Exception e){
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','OSM_SW_EffectiveAccountModalCtrl.getContactsList');
            ccrz.ccLog.close(response);
        }
        
        return response;
    }
    @RemoteAction
    global static ccrz.cc_RemoteActionResult updateLatestContact(ccrz.cc_RemoteActionContext ctx, String selContId,String selAcctId){
        ccrz.cc_RemoteActionResult response = CCOSMPageUtil.remoteInit(ctx);
        try{
            ID currUserId = UserInfo.getUserId();
            String cartId = ccrz.cc_CallContext.currCartId;
            
            List<Contact> contacts;
            contacts = [Select ID, IAM_Contact_Owner__c,OSM_Distributor_Admin_Last_Sel__c,OSM_Distributor_Admin_Last_Sel_acc__c,sessionIdRecord__c from Contact where IAM_Contact_Owner__c =:currUserId LIMIT 1];
            List<ccrz__E_Cart__c> cart = [select id,ccrz__Contact__c,ccrz__Account__c,ccrz__EffectiveAccountID__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartId LIMIT 1];//MP-854 added effective account field.
 
            if(!contacts.isEmpty()){
                if(!contacts.isEmpty()){
                    contacts[0].OSM_Distributor_Admin_Last_Sel_acc__c = selAcctId;
                    contacts[0].OSM_Distributor_Admin_Last_Sel__c = selContId;
                    Cache.Session.put('accContactSelected', true);
                }
                update contacts;
            }
            if(!cart.isEmpty()) {
                //MP-854 Changes. This condition will make sure that only Contact on cart will get updated
                if(cart[0].ccrz__Account__c == cart[0].ccrz__EffectiveAccountID__c && selAcctId == cart[0].ccrz__EffectiveAccountID__c) { 
                    cart[0].ccrz__Contact__c = selContId;
                    cart[0].ccrz__Account__c = selAcctId;
                    update cart;
                }
            }


            CCOSMPageUtil.buildResponseData(response,true, new Map<String, Object>{'contacts' => contacts});
        }
        catch(Exception e){
            CCOSMPageUtil.buildResponseData(response, false,
                new Map<String,Object>{'error' => e.getMessage(),'cause' => e.getCause(),'lineno' => e.getLineNumber(),'stack' => e.getStackTraceString()}
            );
        }
        finally{
            ccrz.ccLog.log(System.LoggingLevel.INFO,'M:X','OSM_SW_EffectiveAccountModalCtrl.getContactsList');
            ccrz.ccLog.close(response);
        }
        
        return response;
    }
}