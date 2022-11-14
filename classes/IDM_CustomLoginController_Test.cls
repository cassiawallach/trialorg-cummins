@isTest
private class IDM_CustomLoginController_Test{

    static testMethod void myUnitTest() 
    {   App_Mapping__c obj=new App_Mapping__c();
    obj.name='test';
    obj.Back_page__c='test';
    obj.Registration__c=true;
    
    insert obj;
        string strlabel=system.Label.RLS_AppID;
        ApexPages.currentPage().getParameters().put('appid',obj.id  );
        IDM_CustomLoginController objCls=new IDM_CustomLoginController();
        objCls.redirectBackpage();
        //objcls.Redirect();
        objcls.redirectRegistartionpage();
        objcls.redirectpage();
        objcls.doLogin();
        App_Mapping__c objApp=new App_Mapping__c();
        ApexPages.currentPage().getParameters().put('appid',obj.id);
        ApexPages.standardController controllernew = new ApexPages.standardController(obj);
        IDM_CustomLoginController objCls1=new IDM_CustomLoginController(controllernew);

    }
    
}