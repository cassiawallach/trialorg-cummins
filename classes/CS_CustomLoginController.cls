global class CS_CustomLoginController {

 // private final Loginu log;
    public String username{get;set;}
    public String password{get;set;}
    public user u{get;set;}
    integer m;
   
       
     global PageReference doLogin() {
    PageReference startPage ;
    startPage = Site.login(username, password, null);     
    
     return startPage; 
}
public pagereference redirect(){
 PageReference demoPage = new pagereference('/CMI_CompanyReg');
    demoPage.setRedirect(true);
    return demoPage;
}
}