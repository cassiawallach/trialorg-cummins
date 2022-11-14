@istest
public class CSS_getPartsListBMSRequestJ2A_Test {
    
    
    static testMethod void testParse() {
		String json=		'{'+
		'"Header": {'+
		'"Sender": {'+
		'"ServiceName": "WOParts",'+
		'"SenderID": "CSS"'+
		'},'+
		'"Target": {'+
		'"TargetID": "BMS"'+
		'},'+
		'"Location": {'+
		'"LocationID": "03742-03750"'+
		'}'+
		'},'+
		'"DataArea": {'+
		'"CSSJobID": "CSS-00002404",'+
		'"DistributorCode": "03742",'+
		'"DistributorBranchCode": "03750",'+
		'"OrderType": "WOQT",'+
		'"BMSQuoteID": "241152",'+
		'"PartDetails": ['+
		'{'+
		'"ProductCodeOEM": "CECO",'+
		'"PartNumberService": "007070500",'+
		'"Quantity": "1"'+
		'},'+
		'{'+
		'"ProductCodeOEM": "DRC",'+
		'"PartNumberService": "430917500RX",'+
		'"Quantity": "2"'+
		'}'+
		']'+
		'}'+
		'}'+
		'';
		CSS_getPartsListBMSRequestJ2A obj = CSS_getPartsListBMSRequestJ2A.parse(json);
		System.assert(obj != null);
	}
}