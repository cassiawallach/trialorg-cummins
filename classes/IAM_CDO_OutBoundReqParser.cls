/************************************************************
Name:  IAM_CDO_OutBoundReqParser
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Request Parser Class for CDO out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Chetan Gaikwad	         10/05/2022         INITIAL DEVELOPMENT
*****************************************************/
public class IAM_CDO_OutBoundReqParser {
    
    //Wrapper class begins// 
    Public static String IAM_CDO_ReqParserClass(id appId, String action){
        String JSONstring;
        IAM_Contact_Provisioning__c cdoUserFeatureRecords = [select id,IAM_Contact__r.Username__c,IAM_Contact__r.FirstName,IAM_Contact__r.LastName,IAM_User_Type__c,IAM_Contact__r.phone, IAM_Contact__r.Language_Preferences__c,
                                                             IAM_Contact__r.Email,IAM_Status__c,IAM_Contact__r.IAM_Contact_Status__c,IAM_Role__c, IAM_Contact__r.Account.CMI_Account_Num__c,IAM_Application_Name__c,IAM_DA_Customer_List__c,
                                                             IAM_Account_Application__r.IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c,IAM_Contact__r.Account.IAM_Primary_Market_Segment__c from IAM_Contact_Provisioning__c where id=:appId];
        
        registrationInformation lstWrapperNew=new registrationInformation(cdoUserFeatureRecords);
        System.debug('Printing list wrapper info'+lstWrapperNew);
        if(lstWrapperNew!=null){
            JSONString = JSON.serialize(lstWrapperNew);
        }
        System.debug('Printing return string '+JSONstring);
        return JSONstring;
    }
    
    
    Public class registrationInformation{
        Public userInfo userInfo{set;get;}
        
        Public registrationInformation(IAM_Contact_Provisioning__c conApp){
            this.userInfo=new userInfo(conApp);
        }
    } 
    
    public class userInfo {
        
        public String appName{get;set;}
        public String accountNumber{get;set;}
        public String emailAddress{get;set;}
        public String userName{get;set;}
        public String firstName{get;set;}
        public String lastName{get;set;}
        public String userStatus{get;set;}
        public String subscriptionStatus{get;set;}
        public String phoneNumber{get;set;}
        public String role{get;set;}
        public String roleType{get;set;}
        public String accountAccess{get;set;}
        public String distributionChannel{get;set;}
        public String primaryMarketType{get;set;}
        public String languagePreference{get;set;}
        
        Public userInfo(IAM_Contact_Provisioning__c conApp){
            This.appName=conApp.IAM_Application_Name__c;
            This.accountNumber=conApp.IAM_Contact__r.Account.CMI_Account_Num__c;
            This.emailAddress=conApp.IAM_Contact__r.Email;
            This.userName=conApp.IAM_Contact__r.Username__c;
            This.firstName=conApp.IAM_Contact__r.FirstName;
            This.lastName=conApp.IAM_Contact__r.LastName;
            This.userStatus=conApp.IAM_Contact__r.IAM_Contact_Status__c;
            This.subscriptionStatus=conApp.IAM_Status__c;
            This.accountAccess=conApp.IAM_DA_Customer_List__c;
            This.role=conApp.IAM_Role__c;
            This.roleType=conApp.IAM_User_Type__c;
            This.phoneNumber=conApp.IAM_Contact__r.phone;
            This.distributionChannel=conApp.IAM_Contact__r.Account.CHANNEL_OF_DISTRIBUTION__c;
            This.primaryMarketType=conApp.IAM_Contact__r.Account.IAM_Primary_Market_Segment__c;
            if(conApp.IAM_Contact__r.Language_Preferences__c!=null || conApp.IAM_Contact__r.Language_Preferences__c!='' ){
                This.languagePreference=conApp.IAM_Contact__r.Language_Preferences__c;
            }else{
                This.languagePreference='English';
            }
        }
    }
    
    // Below code is to capture CDO response received from Mule
    public static CDOResponse getResponseuserrequest(String response){
        return (IAM_CDO_OutBoundReqParser.CDOResponse) System.JSON.deserialize(response, CDOResponse.class);
    }
    
    public class CDOResponse{
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
        public String Message;
        public String MessageType;
    }
    
}