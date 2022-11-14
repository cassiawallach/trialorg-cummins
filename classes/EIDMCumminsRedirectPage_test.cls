@isTest
private class EIDMCumminsRedirectPage_test{

    static testMethod void myUnitTest() 
    {
       
        EIDMCumminsRedirectPage objClass=new EIDMCumminsRedirectPage();
        string strlabel=system.Label.RLS_AppID;
        ApexPages.currentPage().getParameters().put('appid',strlabel);
        objclass.Redirect();
    }
}