@isTest
public class InvoiceItemWrpr_Test {
	@isTest
    static void testmethod1(){
    	Test.startTest();
        InvoiceItemWrpr InItemWrp = new InvoiceItemWrpr();
        InItemWrp.productName = 'Test';
        InItemWrp.invoiceItemNumber = 'Test';
        InItemWrp.quantity = 2;
        InItemWrp.tax = 0.2;
        InItemWrp.isReturnable = 'Test';
        InItemWrp.unitPrice = 0.2;
        InItemWrp.discPrice = 0.2;
        InItemWrp.price = 0.2;
        InItemWrp.proImage = 'URL';
        InItemWrp.refundAmount = 0.2;
        InItemWrp.returnDate = 'Test';
        InItemWrp.isShipTo = true;
                
        Test.stopTest(); 
    }
}