/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-24-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class dbu_PaypalSalesResponse_Test 
{
    public static testMethod void getPaypalPayment(){
        
        dbu_PaypalSalesResponse.parse('{"id":"PAYID-L7I4DVI26481637EL400862G","intent":"sale","state":"approved","cart":"45G63666KV720881V","payer":{"payment_method":"paypal","status":"VERIFIED","payer_info":{"email":"sb-t4aeu3655935@personal.example.com","first_name":"John","last_name":"Doe","payer_id":"FJPKUSZ3CSNFN","shipping_address":{"recipient_name":"test User","line1":"1460 N NATIONAL RD","city":"SCOTTSDALE","state":"AZ","postal_code":"85259","country_code":"US"},"country_code":"US"}},"transactions":[{"amount":{"total":"410.23","currency":"USD","details":{"subtotal":"343.28","tax":"26.95","shipping":"40.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payee":{"merchant_id":"L8DZ428LLHEPU","email":"sb-nzkxo3658589@business.example.com"},"description":"The payment transaction description.","item_list":{"items":[{"name":"Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408","price":"303.28","currency":"USD","tax":"0.00","quantity":1},{"name":"Core: Cummins C0147046408 PUMP,FUEL INJECTION","sku":"C0147046408-1","price":"40.00","currency":"USD","tax":"0.00","quantity":1}],"shipping_address":{"recipient_name":"test User","line1":"1460 N NATIONAL RD","city":"SCOTTSDALE","state":"AZ","postal_code":"85259","country_code":"US"},"shipping_phone_number":"+9 (999) 999-9999"},"related_resources":[{"sale":{"id":"5Y248988LT753363E","state":"pending","amount":{"total":"410.23","currency":"USD","details":{"subtotal":"343.28","tax":"26.95","shipping":"40.00","insurance":"0.00","handling_fee":"0.00","shipping_discount":"0.00","discount":"0.00"}},"payment_mode":"INSTANT_TRANSFER","reason_code":"PAYMENT_REVIEW","protection_eligibility":"INELIGIBLE","transaction_fee":{"value":"12.20","currency":"USD"},"parent_payment":"PAYID-L7I4DVI26481637EL400862G","create_time":"2020-12-10T06:36:43Z","update_time":"2020-12-10T06:36:43Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/sale/5Y248988LT753363E","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/5Y248988LT753363E/refund","rel":"refund","method":"POST"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7I4DVI26481637EL400862G","rel":"parent_payment","method":"GET"}]}}]}],"failed_transactions":[],"create_time":"2020-12-10T06:36:05Z","update_time":"2020-12-10T06:36:43Z","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7I4DVI26481637EL400862G","rel":"self","method":"GET"}]}');
    }
    //uat deployment
}