@isTest
public class dbu_WrapperInvoiceDetails_Test {
    static testMethod void testInvoiceDetails() {
    
    dbu_WrapperInvoiceDetails wrapperData = new dbu_WrapperInvoiceDetails();
        
        wrapperData.orderCurrency= 'USD';
            wrapperData.paymentType= '';
            wrapperData.name= '';
            wrapperData.lastName='';
            wrapperData.emailID='';
            wrapperData.phone='';
            wrapperData.orderNumber='';
            //wrapperData.orderDate= '04-04-2021';
            wrapperData.totalAmount= 9;
            wrapperData.subTotalAmount= 10;
            wrapperData.subTotalAmountReturn= '3.0';
            wrapperData.estimatedTax= 2;
            wrapperData.shippingCost= 27;
            wrapperData.isPickUpAddress= TRUE;
        	wrapperData.productCost='';
        	wrapperData.handlingFeesReturn='';
        	wrapperData.totalRefund='';
        	wrapperData.dateinfoReturn='';
        	wrapperData.orderId='';
        	//wrapperData.dateinfo='';
        	wrapperData.discountAmount= 4;
        	dbu_WrapperInvoiceDetails.BillToAddress bAdd = new dbu_WrapperInvoiceDetails.BillToAddress();
        	bAdd.firstName = '';
            bAdd.lastName = '';
            bAdd.address1 = '';
            bAdd.address2 = '';
            bAdd.address3 = '';
            bAdd.city = '';
            bAdd.state = '';
            bAdd.country = '';
            bAdd.postalCode = '';
        	dbu_WrapperInvoiceDetails.ShipToAddress sAdd = new dbu_WrapperInvoiceDetails.ShipToAddress();
        	sAdd.firstName = '';
            sAdd.lastName = '';
            sAdd.address1 = '';
            sAdd.address2 = '';
            sAdd.address3 = '';
            sAdd.city = '';
            sAdd.state = '';
            sAdd.country = '';
            sAdd.postalCode = '';
        	dbu_WrapperInvoiceDetails.InvoiceLines iL = new dbu_WrapperInvoiceDetails.InvoiceLines();
        	iL.lineItemName = '';
        	iL.quantity = 3;
        	iL.taxAmount = 10;
        	iL.price = 2.0;
        	iL.returnableOrNot = TRUE;
        	iL.productName = '';
        	iL.proImage = '';
        	iL.unitPrice = 55;
        	iL.unitDiscountedPrice = 22;
        	iL.reasonOfReturn = '';
        	iL.returnedOrNot = FALSE;
        	iL.refundAmount = 57;
        	iL.hasCoreCharge = TRUE;
        	iL.hasCoreChild = TRUE;
        	iL.daysSinceOrderDate = 9;
        	iL.originalQty = 10.0;
        	iL.cloneOrderId = '';
            iL.invoiceLineItemDate = '';
            iL.Id = '';
            iL.taxAmountReturn = '';
            iL.priceReturn = '';
            iL.unitPriceReturn = '';
            iL.unitDiscountedPriceReturn = '';
            iL.refundAmountReturn = '';
        
    }
}