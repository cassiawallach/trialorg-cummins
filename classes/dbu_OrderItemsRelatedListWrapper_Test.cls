@isTest
public with sharing class dbu_OrderItemsRelatedListWrapper_Test {
        public static testMethod void testAddress() {
            dbu_OrderItemsRelatedListWrapper wrapperData = new dbu_OrderItemsRelatedListWrapper();
            wrapperData.quantity= 9;
            wrapperData.price= 9;
            wrapperData.subAmount= 9;
            wrapperData.EOrderItemsS='';
            wrapperData.orderItemStatus='';
            wrapperData.additionalInfo='';
            wrapperData.reasonForReturn='';
            wrapperData.selectedReturnItems= TRUE;
            wrapperData.vertexTax= 9;
            wrapperData.prodId='';
            wrapperData.newQuantity= 3;
            wrapperData.dropOffLocation='';
            wrapperData.estReturnAmount= 27;
            wrapperData.originalQuantity= 5;
            
        }
    
}