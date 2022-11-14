@isTest
public class dbu_CyberSourcePaymentWrapper_Test 
{
    public static testMethod void getPaypalPayment(){
        
        dbu_CyberSourcePaymentWrapper obj = new dbu_CyberSourcePaymentWrapper();
        obj.returnURL = '';
        obj.lastName = '';
        obj.firstName = '';
        obj.email = '';
        obj.ignoreAvs  = true;
        obj.paymentMethod  = '';
        obj.billingAddressCountryIsoCode  = '';
        obj.billingAddressPostalCode  = '';
        obj.billingAddressStateCode  = '';
        obj.billingAddressCity  = '';
        obj.billingAddressFirstLine  = '';
        obj.cartSFId  = '';
        obj.invoiceId  = '';
        obj.cartId  = '';
        obj.postUrl  = '';
        obj.unsignedFields  = '';
        obj.locale  = '';
        obj.transactionId  = '';
        obj.transactionType  = '';
        obj.utcDate  = '';
        obj.amount  = '';
        obj.currencyCode  = '';
        obj.referenceNumber  = '';
        obj.signedFields  = '';
        obj.profileId  = '';
        obj.signedItems = '';
        obj.signedData  = '';
        obj.accessKey  = '';
    }
}