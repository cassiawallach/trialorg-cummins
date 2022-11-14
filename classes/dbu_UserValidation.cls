/**
* Author : Ranadip Jha
* Created on 21st July 2021
* Description : Guest and register user will be validatd using this class.
*/
public without sharing class dbu_UserValidation {
    
    //Order Object validation
    public static boolean validateUser(String orderId){
        system.debug('ORDER ID IN USER VALIDATION FOR ORDER ' + orderId);
        try{
            
            ccrz__E_Order__c orderObj = new ccrz__E_Order__c();
            orderObj = [SELECT ID,OwnerId FROM ccrz__E_Order__c WHERE ID =: orderId];
            if(UserInfo.getUserType() == 'Guest'){
                return validateGuestUser(orderObj.OwnerId);
            }else{
                return validateRegisterUser(orderObj.OwnerId);
            }            
        }catch(Exception e){
            system.debug('EXCEPTION MESSAGE IN USER VALIDATION FOR ORDER OBJECT '+e.getMessage() +''+'Exception Line number USER VALIDATION FOR ORDER OBJECT '+e.getLineNumber());
        }
        return false;
        
    }
    //Cart Object validation
    public static boolean validateUserForCart(String cartId){
        system.debug('CART ID IN USER VALIDATION FOR CART ' + cartId);
        try{
            ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
            cartObj = [SELECT ID,OwnerId FROM ccrz__E_Cart__c WHERE ID =: cartId];
            if(UserInfo.getUserType() == 'Guest'){
                return validateGuestUser(cartObj.OwnerId);
            }else{
                return validateRegisterUser(cartObj.OwnerId);
            }
        }catch(Exception e){
            system.debug('Exception Message in USER VALIDATION FOR CART OBJECT '+e.getMessage() +''+'Exception Line number USER VALIDATION FOR CART OBJECT'+e.getLineNumber());
        }
        return false;
        
    }
    //Invoice Object validation
    /*public static boolean validateUserForInvoice(String invoiceId){
        system.debug('CART ID IN USER VALIDATION FOR INVOICE ' + invoiceId);
        try{
            ccrz__E_Invoice__c invoiceObj = new ccrz__E_Invoice__c();
            invoiceObj = [SELECT ID,OwnerId FROM ccrz__E_Invoice__c WHERE ID =: invoiceId];
            if(UserInfo.getUserType() == 'Guest'){
                return validateGuestUser(invoiceObj.OwnerId);
            }else{
                return validateRegisterUser(invoiceObj.OwnerId);
            }
        }catch(Exception e){
            system.debug('Exception Message in USER VALIDATION FOR INVOICE OBJECT '+e.getMessage() +''+'Exception Line number USER VALIDATION FOR INVOICE OBJECT'+e.getLineNumber());
        }
        return false;
    }*/
    //Guest User validation
    private static boolean validateGuestUser(String ownerId){
        System.debug('IN GUEST USER METHOD');
        String recordOwnerId = System.Label.dbu_GuestUserOwnerId;
        if(ownerId == recordOwnerId){
            return true;
        }
        return false;
    }
    //Register User validation
    private static boolean validateRegisterUser(String ownerId){
        System.debug('IN REGISTER USER METHOD');
        if(UserInfo.getUserId() == ownerId){
            return true;
        }
        
        return false;
    }
}