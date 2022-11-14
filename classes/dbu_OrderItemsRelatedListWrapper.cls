public class dbu_OrderItemsRelatedListWrapper {
    public dbu_OrderItemsRelatedListWrapper (){
        
    }
     @AuraEnabled public Decimal quantity;
      @AuraEnabled public Decimal price;
     @AuraEnabled public decimal subAmount;
    @AuraEnabled public String EOrderItemsS;
    @AuraEnabled public String orderItemStatus;
    @AuraEnabled public String sfid;
    @AuraEnabled public String additionalInfo;
    @AuraEnabled public String reasonForReturn;
    @AuraEnabled public Boolean selectedReturnItems;
    @AuraEnabled public Decimal vertexTax;
    @AuraEnabled public string prodId;
    @AuraEnabled public Decimal newQuantity;
    @AuraEnabled public String dropOffLocation;
    @AuraEnabled public decimal estReturnAmount;
    @AuraEnabled public Decimal originalQuantity;
    @AuraEnabled public Boolean dbuIsReturned;
    @AuraEnabled public string estimatedDelivery;
    @AuraEnabled public string estimatedPickUp;
    @AuraEnabled public Boolean dbuisShipTo;
}