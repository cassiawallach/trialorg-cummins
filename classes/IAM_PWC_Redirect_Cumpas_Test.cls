@isTest
private class IAM_PWC_Redirect_Cumpas_Test{

    static testMethod void myUnitTest() 
    {  
    App_Mapping__c obj=new App_Mapping__c();
    obj.name='test';
    obj.Back_page__c='test';
    obj.Registration__c=true;
    obj.IAM_Default_Role__c='User';
    obj.IAM_App_Protected_By__c='SAML';
    insert obj;
    
 
        string strlabel=system.Label.RLS_AppID;
        ApexPages.currentPage().getParameters().put('appid',obj.id  );
        ApexPages.currentPage().getParameters().put('UID','pwc_paccar1');
        ApexPages.currentPage().getParameters().put('FedexemailId','gmail@gmail.com');
        IAM_PWC_RedirectCumpas objCls=new IAM_PWC_RedirectCumpas();
        objCls.redirect();
        
        App_Mapping__c objApp=new App_Mapping__c();
        ApexPages.currentPage().getParameters().put('appid',obj.id);
        ApexPages.standardController controllernew = new ApexPages.standardController(obj);
        

    }
    
    
    

}