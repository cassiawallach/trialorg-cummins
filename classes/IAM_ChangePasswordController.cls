/************************************************************
Name:  IAM_ChangePasswordController
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Controller class for IAM_ChangePasswordController for change password page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -   Karthik Golakaram       11/3/2020     Made changes to display language in only Change password page 
*****************************************************/
/********************************************************************************
***********************************************************************************/

public with sharing class IAM_ChangePasswordController {
    public Boolean InvalidPass{get;set;}
    public Boolean resetqa{get;set;}
    public boolean errordiv{get; set;} // to display error msg
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;} 
    Public boolean samePassword{get;set;}
    Public user u{get;set;}       
    public String err{get;set;}
    public String currentRecordId {get;set;}
    public App_Mapping__c app{set;get;}
    Public Boolean passwordinput{set;get;}//variable to show password input section any time
    public Boolean questioninput{set;get;}//variable to show question section .
    public Boolean answrquestion{set;get;}//variable to show question to get answer if already set.
    Public string errorQuestion{set;get;}
    Public String errorAnswer{set;get;}  
    public boolean errorfound{set;get;} 
    public String challangeAnswer{set;get;}
    public String challangeAnswer1{set;get;} // for new 3 challenge question and answer functionality
    public String challangeAnswer2{set;get;}
    public String challangeAnswer3{set;get;}
    public boolean passerrordiv{get; set;} // to display error msg
    public String challangequestion1{set;get;} // for new 3 challenge question and answer functionality
    public String challangequestion2{set;get;}
    public String challangequestion3{set;get;}
    public String newPass{set;get;}
    
    Public String errorAnswer2{set;get;} 
    Public String errorAnswer3{set;get;} 
    Public string errorQuestion2{set;get;}
    Public string errorQuestion3{set;get;}
    public Static boolean isChangePasswordPage=false;// added variable to dispaly language dropdown in change passowrd page only - 11/03/2020
    
    public IAM_ChangePasswordController() {
        //  InvalidPass=false;
        errordiv = false;
        isChangePasswordPage=true;
        u=[select id,name,email,LastLoginDate,username,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,IAM_Challange_Answer1__c,IAM_Challange_Answer2__c,IAM_Challange_Answer3__c,IAM_Challange_Answer__c,IAM_Challenge_Question_1__c  from user where id=:UserInfo.getUserId()];
        samePassword=false;//variable to see if same password is set all the time.
        System.debug('Printing user details== '+u);
        //Below lines are for setting application name and other values
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        system.debug('Id'+currentRecordId);
        if(currentRecordId!=null){
            app = [select AppId__c,Name,CMI_External_Start_Url__c,Internal_Employee_link__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,  Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=: currentRecordId  ];
            
            system.debug('Id'+app);
        }
        else
        {
            app = [select AppId__c,Name,CMI_External_Start_Url__c,Internal_Employee_link__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c, Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where id=:System.Label.IAM_Default_Appmap];
            system.debug('app============'+app);
        }
        //End if this section.
        //Setting value in order to display qustion block or in order to display set password deplendin upon the login date
        // if(u.LastLoginDate!=null){
        if(u.IAM_Challange_Answer1__c==''||u.IAM_Challange_Answer1__c==null){
            System.debug('Entered login date is not null but user did not set his Security questoin');
            answrquestion=false;
            passwordinput=false;
            questioninput=true; 
        }else{
            System.debug('Entered login date is not null and user needs to answer the question');
            questioninput=true; 
            answrquestion=true;
            passwordinput=false;
            resetqa=true;                 
        }
        
        //  }else{
        System.debug('User login date is null so first time user needs to set his security quesion');
        // answrquestion=false;
        // passwordinput=false;
        //  questioninput=true;
        //}
        
        
    }
    public pageReference resetAnswer(){
        system.debug('entered reset meth');
        u.IAM_Challenge_Question_1__c='';
        u.IAM_Challenge_Question_2__c='';
        u.IAM_Challenge_Question_3__c='';
        u.IAM_Challange_Answer1__c='';
        u.IAM_Challange_Answer2__c='';
        u.IAM_Challange_Answer3__c='';
        update u;
        resetqa=false;
        PageReference tempPage = ApexPages.currentPage();            
        tempPage.setRedirect(true);
        return tempPage;
    }
    public  pageReference newpassword() {
        System.debug('calling the fuction');
        System.debug('Printing error message'+err);
        Try{
            errordiv=false;
            //Changing this page redirect from below linr ot IDM password confirmation.
            //Since we do not have any profile level redirections we are redirecting it to a static page 
            //pageReference EIDM=new pageReference('/IAM_CumminsRedirectPage_new?appid='+app.id);
            u=[select id,IAM_Lastpassword__c,contactid,name,email,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,LastLoginDate,username,IAM_Challange_Answer1__c,IAM_Challange_Answer2__c,IAM_Challange_Answer3__c,IAM_Challange_Answer__c from user where id=:UserInfo.getUserId()];
            Contact conAppID=[Select Id,IAM_AppId__c,Account.IAM_Primary_Market_Segment__C from contact where Id =: u.contactid];
            Date dateToday = Date.today();
            String sMonth = String.valueof(dateToday.month());
            String sDay = String.valueof(dateToday.day());
            if(sMonth.length()==1){
                sMonth = '0' + sMonth;
            }
            if(sDay.length()==1){
                sDay = '0' + sDay;
            }
            String sToday = String.valueof(dateToday.year()) + sMonth + sDay ;
            u.IAM_Lastpassword__c=sToday ;
            
            update u;
      
            String userId=u.id;
            System.setpassword(userId,newPass);
            String startUrl='';
            
            System.debug('Printing contact logged in'+conAppID);
            if(!String.isEmpty(conAppID.IAM_AppId__c)){
                //Get application Name.
                App_Mapping__c appCS=IAM_Utility.getAppMapping(conAppId.IAM_AppId__c);
                if(appCS.Name!=System.Label.IAM_AppName_ConnectedSolutions){
                    System.debug('prinitng default or not connected solutions path');
                    StartUrl='/IAM_Authorize?appid='+conAppID.IAM_AppId__c;
                }else if(appCS.Name==System.Label.IAM_AppName_ConnectedSolutions){
                    //get the Primary market segment from Account and then decide to choose what needs to be done.
                    List<String> marketSegments= System.Label.IAM_PrevenTech_Market_Segments.Split(';');
                    System.debug('Prinitng market segments'+marketsegments);
                    System.debug('Printing market segment from Account'+conAppID.Account.IAM_Primary_Market_Segment__c);
                    System.debug('Printing condidtion 1'+(!marketSegments.isEmpty()&&!String.isBlank(conAppID.Account.IAM_Primary_Market_Segment__c)));
                    System.debug('Prinitng Condition 2'+(marketSegments.Contains(conAppID.Account.IAM_Primary_Market_Segment__c)));
                    if(!marketSegments.isEmpty()&&!String.isBlank(conAppID.Account.IAM_Primary_Market_Segment__c)){
                        if(marketSegments.Contains(conAppID.Account.IAM_Primary_Market_Segment__c)){
                                    //route User to Preventech application.
                             StartURL=IAM_Utility.getAppMapping(System.Label.IAM_AppName_PrevenTech).CMI_External_Start_Url__c;
                                    
                        }else{
                                    //route user to Connected solutions.
                             StartURL=IAM_Utility.getAppMapping(System.Label.IAM_AppName_ConnectedSolutions).CMI_External_Start_Url__c;
                                    
                            }
                    }else{
                            StartUrl=app.CMI_External_Start_Url__c;
                    }
                }
            }else{
                 StartUrl=app.CMI_External_Start_Url__c;
            }
            
            System.debug('Priniting Start URL'+StartUrl);
            PageReference loginURL=site.login(u.username,newPass,StartUrl);
            loginURL.setRedirect(True);
            System.debug('test set' +loginURL);
            
            //this redirection can only be achived for 1 st time registration only. On forget password and all other places where user 
            //access guest user pages to get reset password email we cannot update the contact with the appid to which user is trying
            //to reset password for.So we need to update contact back with null value
            Set<id> idToUpdate= new Set<id>();
            idToUpdate.add(conAppId.id);
            IAM_Utility.updateAppIdOnContact(idToUpdate);
            return loginURL;
        }catch(Exception err){
            if(err.getMessage().Contains('valid repeated password')){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Warning,err.getMessage());
                String error=System.Label.IAM_Old_Password;
                myMsg = new ApexPages.Message(ApexPages.Severity.INFO,error);
                ApexPages.addMessage(myMsg); 
                InvalidPass=true;
                errordiv=false;
                system.debug('@@@@@@@@@@'+InvalidPass);
                return null ;
            }
            else 
            {
                System.debug('Printing error message'+err.getMessage());
                return null ;
            }                
        }  
        
       // return null ; 
    }
    
    Public pageReference setAnswer(){
        
        errorQuestion='';
        errorAnswer='';
        errorQuestion2='';
        errorAnswer2='';
        errorQuestion3='';
        errorAnswer3='';
        errorfound=false;
        // issue- 525 Amarnath Mishra changes **********03-26-2019
        // Changed the error message "Please select a valid Answer" to "Please enter a valid Answer"  
        if(challangeAnswer1==null|| challangeAnswer1==''){
            errorAnswer = Label.IAM_Enter_Valid_Answer;
            errorfound = true; 
        }
        if(challangeAnswer2==null|| challangeAnswer2==''){
            errorAnswer2 = Label.IAM_Enter_Valid_Answer;
            errorfound=true;
        }
        if(challangeAnswer3==null|| challangeAnswer3==''){
            errorAnswer3 = Label.IAM_Enter_Valid_Answer;
            errorfound=true;   
        }
        if(questioninput==true && answrquestion==false){ 
            if(challangequestion1==challangequestion2){
                errorQuestion = Label.IAM_Do_Not_Select_Duplicate;
                errorfound=true;
            }else
                
                if(challangequestion2==challangequestion3){
                    errorQuestion2 = Label.IAM_Do_Not_Select_Duplicate;
                    errorfound=true;
                }else
                    
                    if(challangequestion1==challangequestion3){
                        errorQuestion3 = Label.IAM_Do_Not_Select_Duplicate;
                        errorfound=true;
                    } 
        }
        
        if(errorfound==True){
            return null;
        }else{
            Savepoint sp = Database.setSavepoint();
            try{
                /*Here we are going to assaign challange answer to user field when questioninput is ture and answrquestion is false
In the below block we will update question and answer with the user input*/
                System.debug('questioninput'+questioninput);
                System.debug('answrquestion'+answrquestion);
                if(questioninput==true && answrquestion==false){
                    u.IAM_Challenge_Question_1__c= challangequestion1;
                    u.IAM_Challenge_Question_2__c= challangequestion2;
                    u.IAM_Challenge_Question_3__c= challangequestion3;
                    
                    u.IAM_Challange_Answer1__c=challangeAnswer1;
                    u.IAM_Challange_Answer2__c=challangeAnswer2;
                    u.IAM_Challange_Answer3__c=challangeAnswer3;  
                    Database.SaveResult sr = Database.update(u, false);
                    if (sr.isSuccess()) {
                        System.debug('id insert is successfull');
                        answrquestion=false;
                        passwordinput=True;
                        questioninput=false;
                        errordiv = True;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.IAM_Security_Que_Setup_Complete);
                        ApexPages.addMessage(myMsg);
                        return null;
                    }else
                    {
                        System.debug('Printing error message'+sr.getErrors());
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.IAM_Error_Occured);
                        errordiv=true;
                        answrquestion=true;
                        
                        ApexPages.addMessage(myMsg);
                        
                        return null;
                    }
                }
                //In below condition we will be validating the user answer with the user field on the user record
                else if(questioninput==true && answrquestion==true){
                    
                    if(u.IAM_Challange_Answer1__c==challangeAnswer1 && u.IAM_Challange_Answer2__c==challangeAnswer2 && u.IAM_Challange_Answer3__c==challangeAnswer3){
                        System.debug('Printing error message89');
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.IAM_Set_Password);
                        ApexPages.addMessage(myMsg);
                        answrquestion=false;
                        passwordinput=True;
                        questioninput=false;
                        errordiv = True;
                        return null;
                    }else{
                        System.debug('Printing error message90');
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.IAM_Enter_Correct_Answer);
                        ApexPages.addMessage(myMsg);
                        errordiv = True;
                        answrquestion=true;
                        passwordinput=false;
                        resetqa=false;
                        return null;
                    }
                    
                }
                
            }catch(Exception e){
                Database.rollback(sp); 
                system.debug('exception: is comming 1'+e);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
                ApexPages.addMessage(myMsg);
                return null;
            }  
        } 
        return null;   
    }
    
    /*  Public pageReference ChangeQuestion(){
if(u.IAM_Challange_Answer__c==challangeAnswer){
answrquestion=false;
passwordinput=false;
questioninput=true; 
return null;
}else{
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter correct Answer to set a new question.');
ApexPages.addMessage(myMsg);
return null;

}
} */
    
    
    public pageReference Changelanguage(){        
        
        string language=Apexpages.currentpage().getParameters().get('selectedLanguage');
        System.debug('Selected language is====='+language);
        System.debug('PResent vf page url is ==='+ApexPages.currentPage().getHeaders().get('referer'));
        String PresentURL=ApexPages.currentPage().getHeaders().get('referer');
        PageReference company = new pageReference(PresentURL);
        System.debug('Current page====='+company);
        company.getParameters().put('lang',language);
        system.debug('return url is====='+company);
        return company.setRedirect(true);
        
    }
    
    
    Public List<Selectoption> getselectedquestionfields(){
        Schema.DescribeFieldResult describeResult = User.IAM_Challenge_Question_1__c.getDescribe();
        // get the picklist values from this describe result
        List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();
        List<Selectoption> lstnamesel = new List<Selectoption>();
        lstnamesel.add(new selectOption('', Label.IAM_Select_Question));
        for (Schema.PicklistEntry pEntry : entries) {        
            lstnamesel.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));       
        } 
        return lstnamesel; 
    }
    
    //method to set isChangePassword flag in CS_Header Component
    Public Static boolean checkPageName(){
        Boolean returnVale=false;
            if(isChangePasswordPage){
                returnVale=true;
            }
        return returnVale;    
        }
}