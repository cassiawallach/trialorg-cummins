public class OSM_SW_TestDataHelper_Ctrl {
    
    
    public static ccrz__E_Cart__c createNewCart(string storefront,string carttype,Id userid,boolean activecart,string status)
        
    {
        ccrz__E_Cart__c newcart = new ccrz__E_Cart__c();
        newcart.ccrz__Storefront__c = storefront;
        newcart.ccrz__CartType__c = carttype;
        newcart.ccrz__ActiveCart__c = activecart;
        newcart.ccrz__CartStatus__c=status;
        newcart.ccrz__User__c = userid;
        insert newcart;
        return newcart;
        
    }
    public static ccrz__E_Product__c createNewProduct(string name,string status,Integer quantity,string sku,Date startdate,Date Enddate,string gname)
        
    {
        ccrz__E_Product__c newproduct = new ccrz__E_Product__c();
        newproduct.name = name;
        newproduct.ccrz__ProductStatus__c = status;
        newproduct.ccrz__Quantityperunit__c = quantity;
        newproduct.ccrz__SKU__c = sku;
        newproduct.ccrz__StartDate__c = startdate;
        newproduct.ccrz__EndDate__c = Enddate;
        newproduct.Group_Name__c = gname;
        insert newproduct;
        return newproduct;
        
    }
    public static ccrz__E_SubProdTerm__c createSubProdTerm(string name,Datetime startdate,Datetime enddate,Id Productid,string operation)
        
    {
        ccrz__E_SubProdTerm__c newSubProdTerm = new ccrz__E_SubProdTerm__c();
        newSubProdTerm.name = name;
        newSubProdTerm.ccrz__EffectiveStart__c = startdate;
        newSubProdTerm.ccrz__EffectiveEnd__c = enddate;
        newSubProdTerm.ccrz__CCProduct__c = Productid;
        newSubProdTerm.Operation__c =operation;
        insert newSubProdTerm;
        return newSubProdTerm;
        
    }
     public static ccrz__E_CartItem__c createNewCartitem(string cartid,string carttype,Integer quantity ,id Productid,id subprodterm,decimal price)
        
    {
        ccrz__E_CartItem__c newCartItem = new ccrz__E_CartItem__c();
        newCartItem.ccrz__Cart__c = cartid;
        newCartItem.ccrz__Quantity__c = quantity;
        newCartItem.ccrz__Product__c = Productid;
        newCartItem.ccrz__SubProdTerm__c = subprodterm;
		newCartItem.ccrz__Price__c	= price;
        insert newCartItem;
        return newCartItem;
        
    }
    public static contact createNewContact(string firstname,string lastname,string email)
        
    {
        contact newcontact = new contact();
        newcontact.FirstName = firstname;
        newcontact.LastName = lastname;
        newcontact.Email = email;
        insert newcontact;
        return newcontact;
    }
}