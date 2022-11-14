@isTest
private class IAM_PWC_Login_Test{

    static testMethod void myUnitTest() 
    {  
    App_Mapping__c obj=new App_Mapping__c();
    obj.name='test';
    obj.Back_page__c='test';
    obj.Registration__c=true;
    obj.IAM_Default_Role__c='User';
    obj.IAM_App_Protected_By__c='SAML';
    insert obj;
    
    contact con= new contact();
    con.firstName='Fname';
    con.LastName='Lname';
    con.email='testemail@cummins.com';
    con.IAM_Cummins_Login_ID__c='testusenrmaecummins@cummins.com';
    con.CMI_Contact_Type__c='Primary';
    con.IAM_Challange_Answer__c='town';
    insert con;
    
   
    
        string strlabel=system.Label.RLS_AppID;
        ApexPages.currentPage().getParameters().put('appid',obj.id  );
        ApexPages.currentPage().getParameters().put('UID','pwc_paccar1');
       
        IAM_PWC_Login objCls=new IAM_PWC_Login();
        objCls.doPWCLogin();
        
        App_Mapping__c objApp=new App_Mapping__c();
        ApexPages.currentPage().getParameters().put('appid',obj.id);
        ApexPages.standardController controllernew = new ApexPages.standardController(obj);
        

    }
    
    
    
    static testMethod void myUnitTest1() 
    {  
    App_Mapping__c obj=new App_Mapping__c();
    obj.name='test';
    obj.Back_page__c='test';
    obj.Registration__c=true;
    obj.IAM_Default_Role__c='User';
    obj.IAM_App_Protected_By__c='SAML';
    insert obj;
    
    contact con= new contact();
    con.firstName='Fname';
    con.LastName='Lname';
    con.email='testemail@cummins.com';
    con.IAM_Cummins_Login_ID__c='testusenrmaecummins@cummins.com';
    con.CMI_Contact_Type__c='Primary';
    con.IAM_Challange_Answer__c='town';
    insert con;
    
   
    
        string strlabel=system.Label.RLS_AppID;
        ApexPages.currentPage().getParameters().put('appid',obj.id  );
        ApexPages.currentPage().getParameters().put('UID','pwc_paccar1');
        ApexPages.currentPage().getParameters().put('FedexemailId','gmail@gmail.com');
       
        IAM_PWC_Login objCls=new IAM_PWC_Login();
        objCls.doPWCLogin();
        
        App_Mapping__c objApp=new App_Mapping__c();
        ApexPages.currentPage().getParameters().put('appid',obj.id);
        ApexPages.standardController controllernew = new ApexPages.standardController(obj);
        

    }
}