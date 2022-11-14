@isTest
public class dbu_PaypalRefundResponse_Test 
{
    public static testMethod void getPaypalPayment(){
        
        dbu_PaypalRefundResponse.parse('{"id":"44X22091FE2796251","create_time":"2020-11-27T17:09:28Z","update_time":"2020-11-27T17:09:28Z","state":"completed","amount":{"total":"633.39","currency":"USD"},"refund_from_transaction_fee":{"currency":"USD","value":"18.37"},"total_refunded_amount":{"currency":"USD","value":"633.39"},"refund_from_received_amount":{"currency":"USD","value":"615.02"},"sale_id":"8EJ13000TK7774824","parent_payment":"PAYID-L7ATEJA4AK914783F302283C","links":[{"href":"https://api.sandbox.paypal.com/v1/payments/refund/44X22091FE2796251","rel":"self","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/payment/PAYID-L7ATEJA4AK914783F302283C","rel":"parent_payment","method":"GET"},{"href":"https://api.sandbox.paypal.com/v1/payments/sale/8EJ13000TK7774824","rel":"sale","method":"GET"}]}');
    }
}