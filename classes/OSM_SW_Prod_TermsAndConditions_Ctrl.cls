public class OSM_SW_Prod_TermsAndConditions_Ctrl 
{
    private final ccrz__E_Product__c product; 
    private final ccrz__E_RequestForQuote__c reqForQuote;
    public String prodID {get;set;}
    public String context {get;set;}

    public OSM_SW_Prod_TermsAndConditions_Ctrl() 
    {
        String val = apexpages.currentpage().getparameters().get('val');
        
       	if(null != val)
        {
            if(val.contains('quote'))
            {
                String quoteId = val.substring(5, val.length());
                
                reqForQuote = [Select ID, Display_Product__c from ccrz__E_RequestForQuote__c where Id=:quoteId];
                
                prodID = reqForQuote.Display_Product__c;
                
            }
            else
            {
                prodID = val;
            }
        }
        
        product = [SELECT Id, OSM_Term_and_Condition__c FROM ccrz__E_Product__c 
                   WHERE Id = :prodID];
    }

    public ccrz__E_Product__c getProduct() {
        return product;
    }
    
    public ccrz__E_RequestForQuote__c getReqForQuote() {
        return reqForQuote;
    }

    
}