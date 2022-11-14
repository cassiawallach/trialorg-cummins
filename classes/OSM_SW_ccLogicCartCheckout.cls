//this class needs to be deleted...
global with sharing class OSM_SW_ccLogicCartCheckout extends ccrz.cc_api_cartExtension {

    private boolean isValidated = false;
    private boolean isAllowCheckout = false;
    private final List<ccrz.cc_bean_Message> retMessages = new List<ccrz.cc_bean_Message>();
    
    global override boolean allowCheckout(Map<String, Object> inputData){
        super.allowCheckout(inputData);
        ccrz.cc_bean_CartSummary cartBeanSummary  = (ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN);
        System.debug('cart bean summary in allow checkout : '+ cartBeanSummary);
        if(label.OSM_DA_API_BYPassProductDetail=='true')
        {
            validate(cartBeanSummary);
        }
        else
        {
            isAllowCheckout=true;
        }
        ccrz.ccLog.log('=====Returning isAllowCheckout===='+isAllowCheckout);
        return isAllowCheckout;
    }
    
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String, Object> inputData){
        super.getCartMessages(inputData);
        ccrz.cc_bean_CartSummary cartBeanSummary  = (ccrz.cc_bean_CartSummary)inputData.get(ccrz.cc_api_CartExtension.PARAM_CARTBEAN);
        System.debug('cart bean summary in getCartMessages : '+ cartBeanSummary);
         if(label.OSM_DA_API_BYPassProductDetail=='true')
         {
            validate(cartBeanSummary);
         }
        return retMessages;
    }
    @TestVisible
     private void validate(final ccrz.cc_bean_CartSummary cartBean){
         if(!isValidated){
            List<String> cartidlist = new List<String>{};
            cartidlist.add(cartBean.sfid);
            Map<String, Object> inputDataCart = new Map<String, Object>{
                                ccrz.ccApiCart.CART_IDLIST => cartidlist,
                                    ccrz.ccAPI.API_VERSION => ccrz.ccApi.CURRENT_VERSION};
           /* Map<String,Object> inputDataAccount = new Map<String,Object>{
                                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                    ccrz.ccApiAccount.ID => ccrz.cc_CallContext.currAccountId};*/
            Map<String,Object> inputDataAccount = new Map<String,Object>{
                                ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                                    ccrz.ccApiAccount.ID => ccrz.cc_CallContext.effAccountId};                             
            //Double totalAmount = 0.0;
            Boolean onHold = false;
            /*Map<String, Object> outputDataCart = ccrz.ccAPICart.fetch(inputDataCart);
             if (outputDataCart.get(ccrz.ccAPICart.CART_OBJLIST) != null){
                 List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) outputDataCart.get(ccrz.ccAPICart.CART_OBJLIST);
                 if(outputCartList[0].get('totalAmount') != null){
                     totalAmount = (Double) outputCartList[0].get('totalAmount');
                 }
             }*/
            Map<String, Object> outputDataAccount = ccrz.ccAPIAccount.fetch(inputDataAccount);
            if(outputDataAccount.get(ccrz.ccAPIAccount.ACCOUNTS) != null){
                List<Map<String,Object>> accounts = (List<Map<String,Object>>) outputDataAccount.get(ccrz.ccAPIAccount.ACCOUNTS);
                Map<String, Object> account = accounts.get(0);
                System.debug('===Account Object : '+account);
                Id accntId = (Id)account.get('sfid');
                List<Account> accntObj = [SELECT Id, Bolt_Credit_Hold__c from Account where Id =: accntId];
                System.debug('onhold Status := '+ accntObj[0].get('Bolt_Credit_Hold__c') );
                if(accntObj.isEmpty() == false){
                    if(accntObj[0].get('Bolt_Credit_Hold__c') != null){
                        onHold = (Boolean)accntObj[0].get('Bolt_Credit_Hold__c');
                    }    
                }
                
            }
            if(onHold == true){
                if(!isAllowCheckout){
                    System.debug('Inside writing messages');
                    ccrz.cc_bean_Message msg = new ccrz.cc_bean_Message();
                    msg.labelId= 'CC_Checkout';
                    msg.type= ccrz.cc_bean_Message.MessageType.CUSTOM;
                    msg.severity= ccrz.cc_bean_Message.MessageSeverity.ERROR;
                    msg.classToAppend= 'messagingSection-Info';
                    retMessages.add(msg);
                }
            }else{
                isAllowCheckout = true;
            }
         }
         isValidated = true;
     } 
}