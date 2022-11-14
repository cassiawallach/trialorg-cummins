public class TestProductSetupRes
{
    public ID objUserID;
    
    public ccrz__E_AccountGroup__c accountGroup;
    public Account account;
    public Contact contact;
    
    public ccrz__E_Product__c compositeProduct;
    public List<ccrz__E_Product__c> componentList;
    public List<ccrz__E_CompositeProduct__c> compositeProductObjectList;
    
    public ccrz__E_PriceList__c priceList;
    public List<ccrz__E_SubProdTerm__c> subProdTermList;
    public List<ccrz__E_PriceListItem__c> priceListItemList;
    
    Public User loggedInUser;
}