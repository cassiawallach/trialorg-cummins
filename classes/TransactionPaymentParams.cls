global class TransactionPaymentParams{
    global String accountNumber {get;set;}
    global String accountType {get;set;}
    global String comments {get;set;}
    global Decimal expirationMonth {get;set;}
    global Decimal expirationYear {get;set;}
    global String paymentType {get;set;}
    global Decimal requestAmount {get;set;}
    global String storedPaymentId {get;set;}
    global String storefront {get;set;}
    global String subAccountNumber {get;set;}
    global String token {get;set;}
    global String transactionCode {get;set;}
    global String transactionPaymentId {get;set;}
    global String transactionSubcode {get;set;}
    global String transactionType {get;set;}
    global String verificationCode {get;set;}
    global boolean saveAsStoredPayment {get; set;}
    global String accountName {get; set;} 
}