// update Swetha 20th Jan 2022
//  Updated on 04/04/2022
//test line
@isTest
public class CMI_SW_CartTaxWrapper_Test {
    
    static testMethod void testmethod1(){
        CMI_SW_CartTaxWrapper obj = new CMI_SW_CartTaxWrapper();
        obj.vertexTax =2.0;
        obj.isError=true;
        obj.errorMsg='error';
        obj.totalDiscount='3000';
        obj.cartId=id.valueOf('001Q000001K7xSq');
        CMI_SW_CartTaxWrapper.CartLineItem wrapper = new  CMI_SW_CartTaxWrapper.CartLineItem();
        wrapper.CartLineId=id.valueOf('001Q000001K7xSq');
        wrapper.CartLineProductId=id.valueOf('001Q000001K7xSq');
        wrapper.ProductLinkSKU='Test';
        wrapper.couponCode='Test';
        wrapper.hasCoupon=true;
        wrapper.isRenew=true;
        wrapper.billingFrequency='';
        wrapper.vertexTax=2.0;
        wrapper.renewStartDate=2147483648L;
        wrapper.renewEndDate =2147483648L;
        obj.cartIteams=new list<CMI_SW_CartTaxWrapper.CartLineItem>{wrapper};
        
        
    }

}