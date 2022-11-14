global  class OSM_SW_cc_hk_Payment extends ccrz.cc_hk_Payment{

    private boolean isValidated = false;
    
    
     global override Map<string, Object> getApplicablePaymentTypes(Map<String,Object> inputData) 
    {
        
        ccrz.ccLog.log(System.LoggingLevel.INFO,'M:E','==========getApplicablePaymentTypes======');
        
      
        
		String paymentContext='';
		if(inputData!=null && inputData.containsKey('paymentTypesContext'))
		{
		  paymentContext =(String) inputData.get('paymentTypesContext');
		}
        
		Map<String,String> paymentTypesMap= new Map<String,String>();
		Map<String, Object> returnData =  super.getApplicablePaymentTypes(inputData);

		if(paymentContext==ccrz.cc_hk_Payment.PAYMENT_CTX_CHECKOUT)
		{
				
			List<ccrz__E_Cart__c> cartLst =	[select id,OSM_Payment_Method__c from ccrz__E_Cart__c where ccrz__EncryptedId__c	=:ccrz.cc_CallContext.currCartId];
			if(cartLst!=null && cartLst.size()>0)
			{
				  ccrz__E_Cart__c cart = cartLst.get(0);
				  if(cart.OSM_Payment_Method__c==null || cart.OSM_Payment_Method__c=='')
				  {
						//raise error
						
				  }
				  else
				  {
						returnData.put(PARAM_APPL_PAYMENT_TYPES,cart.OSM_Payment_Method__c);
				  }
			}
			
		}
		else
		{
			//this is for Invoice Payment
			//for Invoice Payment for CC,configuration name is cci (in CC Admin)
			String paymentTypes='cci';
			returnData.put(PARAM_APPL_PAYMENT_TYPES,paymentTypes);
		}
		ccrz.ccLog.log('===Returning Payment Types==='+returnData);
        return returnData;
    }
    
    
}