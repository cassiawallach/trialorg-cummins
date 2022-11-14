global with sharing class CustomLoginController {
public string customLabelValue{get;set;}
public string forgotpwdcustomLabelValue{get;set;}
global CustomLoginController () {
customLabelValue = System.Label.ABO_user_sign_up_link;
forgotpwdcustomLabelValue= System.Label.ABO_forgot_password;
}

  global PageReference doLogin() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }


    public String password { get; set; }

    public String username { get; set; }
}