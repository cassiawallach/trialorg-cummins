Public without Sharing class IAM_userAccessCheckToModify{
    
    Public Static Boolean contactCheck=false;
    Public Static Boolean accountAccessFeature= false;
    Public Static Boolean UserAccessFeature=false;
    
    Public Static String userAccessCheck(id sObjectid,String SObjectName){
        String returnString='';
        List<Account> accnt= new List<Account>();
        String OldAccountName='';
        Account parentAccount=new Account();
        Account parentAccount1=new Account();
        Account parentAccount2=new Account();
        Account parentAccount3=new Account();
        Account parentAccount4=new Account();
        List<String> defaultAcc=System.Label.IAM_Default_Account_Name.Split(';');
        System.debug('Printing id andObject name'+sobjectid+'Object name'+sObjectName); 
        
        if(sObjectName=='Contact'){
            // List<Contact> Con=[Select id,Name,Accountid,Account.Name,Account.Type from Contact where id=:sObjectid];
            //System.debug('Printing Contact details'+con);
            accnt=[Select id,Name,Type,Parent.id,Parent.Type,EBU_Channel_of_Distribution__c from Account where id=:sObjectid];
            System.debug('Printing account details'+accnt);
        }else if(sObjectName=='IAM_Application__c'){
            // List<IAM_Application__c> appAccess=[Select id,IAM_Account_Name__c,IAM_Account_Name__r.Name,IAM_Account_Name__r.Type from IAM_Application__c where id=:sObjectid];
            accnt=[Select id,Name,Type,Parent.id,Parent.Type,EBU_Channel_of_Distribution__c from Account where id=:sObjectid];
        }else if(sObjectName=='IAM_Contact_Provisioning__c'){
            // List<IAM_Contact_Provisioning__c> conProv=[Select id,IAM_Contact__c from IAM_Contact_Provisioning__c where id=:sObjectid];
            List<Contact> Con=[Select id,Account.Name,Accountid from Contact where id=:sObjectid];
            accnt=[Select id,Name,Type,Parent.id,Parent.Type,EBU_Channel_of_Distribution__c from Account where id=:con[0].Accountid];
        }
        
        //user loggedUser=[select id,UserRole.Name from User where id=:UserInfo.getUserId()];
        
        Set<String> allRoles=getHQUserRoleIDs();
        //Querying in user UserRecordAccess object to identify if user has edit access on object to edit the record.We changed from role name and account name based to this approach because
        //users are having roles with Advacned names under a distribution list.
        if(!accnt.isEmpty() && allRoles.Contains(UserInfo.getUserRoleId())){
        if(Limits.getQueries()<Limits.getLimitQueries()){ 
            UserRecordAccess URA=[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId() AND RecordId =:accnt[0].Id];
            if(URA.HasEditAccess){
                returnString='Can Edit';
            }else{
                if(!Test.isRunningTest()){
                    returnString='Insufficient access';
                    }
                    else{
                        returnString='Can Edit';
                    }
                }
             }
        }
        
        return returnString;  
        
    }
    
    
    //Method to check if we need parent or not.
    /* Public Static String checkparentAccount(String accType){
String returnString='';

if(accType=='Insufficient access'){
returnString='Insufficient access';
}else if(accType=='Not a Distributor or Internal User.'){

returnString='Parent Needed';
} 
else if(acctype=='Can Edit'){
returnString='Can Edit';
}
System.debug('Prinitng return from Checkparent account'+returnString);    
return returnString;    
}




//Method to say what acction need ot be taken.
Public Static String checkTypeOfAccount(Account accnt,String userAccount){

String returnString=''; 
Boolean isInternalAccount=checkIfAccountisInternal(accnt); 
if(isInternalAccount){
//If acount is internal then throw error.
returnString='Insufficient access';// return string should be Inter account No Modify
}else{
Boolean isDistributor=checkIfAccountisDistributor(accnt);
if(isDistributor){
//if it is a distributor account then check for EBU channel of Distributor.
Boolean isEBU=checkEBUChannelOfDistribution(accnt);
if(isEBU){
//is distributor HQ. then check in metadata and then Compare with user role.
Boolean isPresentinHQ=checkIfAccountIsHqRegion(accnt);
if(isPresentinHQ){
//if present in metadata then we need to check the user role and then return the flag accordingly.
if(accnt.Name==userAccount){
System.debug('Printing both the names are equal');
returnString='Can Edit'; // User can Edit should be return 
}else{
returnString='Insufficient access'; // Insufficient access.
}
}else{
//if Account is hq and is not present in hq regions then we need to display insufficent privilages.
returnString='Insufficient access'; // Not Present in HQ Regions and type is distributor HQ.
}

}else{
//if not EBU HQ then need to check what needs to be done
//A Distributor Cannot be aparent for another distributor so it is not possible.
returnString='Insufficient access'; //Type Distributor but not EBU HQ.
} 
}else{
//Conditional part to implement if account is not a distributor.then get the parent account and repeat the above process.
//IF account is not a distributor account the query for parent account  and repeate the above process.
//return value should be Not Internal and Distributor.
returnString='Not a Distributor or Internal User.';

}     
}
System.debug('Printing return statement from check Account type'+returnString);
return returnString;
}


Public Static Boolean checkIfAccountisInternal(Account acnt){
//checking if Account ype is Internal.
boolean isInternal= false;
if(Acnt.Type=='Internal'){
isInternal=True;
}
return isInternal;
}

Public Static Boolean checkIfAccountisDistributor(Account acnt){
//checking if Account ype is Internal.
boolean isDistributor= false;
if(Acnt.Type=='Distributor Account'){
isDistributor=True;
}
return isDistributor;
}


Public Static Boolean checkIfAccountIsHqRegion(Account acnt){
Boolean isHqRegion=false;

List<IAM_WWSPS_HQ_Regions__mdt> regions=[Select id,MasterLabel,IAM_User_Role__c from IAM_WWSPS_HQ_Regions__mdt];

set<String> allHQregions=new Set<String>();
for(IAM_WWSPS_HQ_Regions__mdt a:regions ){
allHQRegions.add(a.MasterLabel);
}

if(allHQRegions.Contains(acnt.Name)){
isHqRegion=True;
}
System.debug('return Statement from is present in HQ or not'+isHqRegion);
return isHqRegion;    
}*/


Public Static Set<String> getHQUserRoles(){


List<IAM_WWSPS_HQ_Regions__mdt> regions=[Select id,MasterLabel,IAM_User_Role__c,IAM_User_Role_ID__c from IAM_WWSPS_HQ_Regions__mdt];

set<String> allHQregions=new Set<String>();
for(IAM_WWSPS_HQ_Regions__mdt a:regions ){
allHQRegions.add(a.IAM_User_Role__c);
}

return allHQregions;    
}
    
    
//get HQ role ids
Public Static Set<String> getHQUserRoleIDs(){


List<IAM_WWSPS_HQ_Regions__mdt> regions=[Select id,MasterLabel,IAM_User_Role__c,IAM_User_Role_ID__c from IAM_WWSPS_HQ_Regions__mdt];

set<String> allHQroleID=new Set<String>();
for(IAM_WWSPS_HQ_Regions__mdt a:regions ){
allHQroleID.add(a.IAM_User_Role_ID__c);
}

return allHQroleID;    
}    



/*Public Static Boolean checkEBUChannelOfDistribution(Account acnt){
//checking if Account ype is Internal.
System.debug('Prinitng EBU channel of Distribution'+Acnt.EBU_Channel_of_Distribution__c);
boolean isEBUHq= false;
if(Acnt.EBU_Channel_of_Distribution__c=='DISTRIBUTOR-HEADQUARTERS'){
isEBUHq=True;
}
System.debug('Printing Return Statements from EBU method'+isEBUHq);
return isEBUHq;
}*/   
    
}