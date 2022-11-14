@isTest
private class EIDMCumminsRedirectPage_mobile_test{

    static testMethod void myUnitTest() 
    {
       
        EIDMCumminsRedirectPage_mobile objClass=new EIDMCumminsRedirectPage_mobile();
        string strlabel=system.Label.RLS_AppID;
        

        ApexPages.currentPage().getParameters().put('appid',strlabel);
        ApexPages.currentPage().getParameters().put('language','en_US');
        objclass.Redirect();
    
    }
     static testMethod void myUnitTest2() 
    {
       
        EIDMCumminsRedirectPage_mobile objClass=new EIDMCumminsRedirectPage_mobile();
        string strlabel=system.Label.RLS_AppID;
        

        ApexPages.currentPage().getParameters().put('appid',strlabel);
        ApexPages.currentPage().getParameters().put('language','');
        objclass.Redirect();
    
    }

}