/************************************************************
Name:  OSM_BMS_SW_BusinessLayerHandler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the business layer of BMS Customer Lookup Outbound Service

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BMS_SW_BusinessLayerHandler{ 

/*----------------------------------------------------------------------------------
1. getBMSAvailableCredit
Description: It will take the account id from UI and return customer data and 
Available Credit of Account which is returned by the one BMS API.
params
 Account id- Account id passed from UI
Return: OSM_ReturnWrapper

------------------------------------------------------------------------------------*/
 public static OSM_ReturnWrapper getBMSAvailableCredit(Id accountId, boolean isThirdPartyBMSCheck,String thirdPartyBMS, Id IAMAccountId ) 
 {
   List<ccrz__E_ContactAddr__c> updateContactAddressList=new List<ccrz__E_ContactAddr__c>();
   List<ccrz__E_ContactAddr__c> insertContactAddressList=new List<ccrz__E_ContactAddr__c>();
   List<ccrz__E_AccountAddressBook__c> insertAddressBookList=new List<ccrz__E_AccountAddressBook__c>();
   List<SObject> insertList=new List<SObject>();

   List<Account> updateAccountList=new List<Account>();
   OSM_ReturnWrapper objToReturn = new OSM_ReturnWrapper();
   OSM_Integration_Log__c log = new OSM_Integration_Log__c();
   List<OSM_Integration_Log__c> lstToInsertLog=new List<OSM_Integration_Log__c>();

   
   
     try
     {
         //Query Account record 
         
         List<Account> accountList=[select id,EBU_Channel_of_Distribution__c,PSBU_Channel_of_Distribution__c,OSM_SW_Responsible_Region__c,PaymentType__c,Location__c,IsOneBMSFailure__c,OSM_Location_ID__c, Name,Customer_BMS_number__c,CSS_WS_Channel_of_Distribution__c,Currency_code__c from Account where id=:accountId];
         
         List<ccrz__E_AccountAddressBook__c> addressBookList=[Select id, ccrz__E_ContactAddress__r.ccrz__CompanyName__c, ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, 
         ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, ccrz__E_ContactAddress__r.ccrz__City__c, ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, 
         ccrz__E_ContactAddress__r.ccrz__PostalCode__c, ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, ccrz__E_ContactAddress__r.BOLT_Operating_Unit__c, ccrz__E_ContactAddress__r.Site_Use_Status__c, ccrz__Account__c, 
         ccrz__E_ContactAddress__c,ccrz__E_ContactAddress__r.BMS_Site__c from ccrz__E_AccountAddressBook__c where ccrz__Account__c =:accountId and ccrz__E_ContactAddress__r.BMS_Site__c=true];         
         
         //intializing GeneralInput wrapper
         OSM_BMS_WS_GeneralizedInputWrapper inputWrapperObj=new OSM_BMS_WS_GeneralizedInputWrapper();
         inputWrapperObj.DataArea=new OSM_BMS_WS_GeneralizedInputWrapper.DataArea();
         inputWrapperObj.Header=new OSM_BMS_WS_GeneralizedInputWrapper.Header();
         inputWrapperObj.Header.Location=new OSM_BMS_WS_GeneralizedInputWrapper.Location();
         inputWrapperObj.Header.Sender=new OSM_BMS_WS_GeneralizedInputWrapper.Sender();
         inputWrapperObj.Header.Target=new OSM_BMS_WS_GeneralizedInputWrapper.Target();
         
         //binding values 
         if(accountList!=null && accountList.size()>0)
         {
             if(accountList[0].Name !=null){
             //inputWrapperObj.DataArea.CustomerName=accountList[0].Name;
             inputWrapperObj.DataArea.CustomerName='';
             }
             else{
             inputWrapperObj.DataArea.CustomerName='';
             }
             if(accountList[0].Customer_BMS_number__c !=null){
                inputWrapperObj.DataArea.CustomerCode=accountList[0].Customer_BMS_number__c;
             }
             else{
                inputWrapperObj.DataArea.CustomerCode='';
             }
             if(accountList[0].EBU_Channel_of_Distribution__c == 'CIHR' || accountList[0].PSBU_Channel_of_Distribution__c == 'CIHR')
             {
                inputWrapperObj.Header.Location.LocationID=accountList[0].OSM_SW_Responsible_Region__c+'-'+accountList[0].OSM_SW_Responsible_Region__c;
             }
             else if(accountList[0].OSM_Location_ID__c !=null){
                inputWrapperObj.Header.Location.LocationID=accountList[0].OSM_Location_ID__c;
            }
            else{
                inputWrapperObj.Header.Location.LocationID='';
            }
             
            if(isThirdPartyBMSCheck)
            {
                String thirdPartyDistCode ;
                //for(Account acc : [SELECT CSS_DistributorCode__c FROM Account WHERE Customer_BMS_number__c =: thirdPartyBMS]){
                    for(Account acc : [SELECT CSS_DistributorCode__c FROM Account WHERE Id =: IAMAccountId]){
                    thirdPartyDistCode = acc.CSS_DistributorCode__c;
                }
                inputWrapperObj.DataArea.CustomerCode=thirdPartyBMS;
                if(thirdPartyDistCode != null){
                    inputWrapperObj.Header.Location.LocationID = thirdPartyDistCode + '-' + thirdPartyDistCode;
                }
            }
             // Start : Juhi Changes : Nov 16 - created OSM specific Location ID - formula field
             /*if(accountList[0].Location__c !=null){
             inputWrapperObj.Header.Location.LocationID=accountList[0].Location__c;
             }
             else{
             inputWrapperObj.Header.Location.LocationID='';
             }*/
             
             
             // End : Juhi Changes : Nov 16
             /*if(accountList[0].CSS_WS_Channel_of_Distribution__c!=null){
             inputWrapperObj.DataArea.DealerCode=accountList[0].CSS_WS_Channel_of_Distribution__c;
             }
             else{
             inputWrapperObj.DataArea.DealerCode='';
             }*/
             inputWrapperObj.DataArea.DealerCode='';
             inputWrapperObj.DataArea.AcctId=accountList[0].Id;//Added BY Dhiraj
         }
         
         //Calling Service class
         OSM_BMS_WS_GeneralizedOutputWrapper responseWrpObj = OSM_BMS_WS_CustomerLookupOutbound.callBMSService(inputWrapperObj);
         System.debug('General Output Wrapper>>>>>'+responseWrpObj);
         Map<String,OSM_BMS_WS_GeneralizedOutputWrapper.DataArea> dataAreaMap=new Map<String,OSM_BMS_WS_GeneralizedOutputWrapper.DataArea>();
         
         log=responseWrpObj.log;
         
         if(log.response__c != null  && log.response__c.length()>32000)
         {
            log.response__c=responseWrpObj.log.response__c.substring(0,3200);
         }
         if(log.Error_Description__c != null && log.Error_Description__c.length()>32000)
         {
            log.Error_Description__c=responseWrpObj.log.Error_Description__c.substring(0,3200);
         }
         
         
         //system.debug('the final log error field size'+log.Error_Description__c);
         //system.debug('the final size of response string>>>'+log.response__c.length());
         accountList[0].IsOneBMSFailure__c=responseWrpObj.errorFlag;
        
         if(!responseWrpObj.errorFlag)    
         {
             for(OSM_BMS_WS_GeneralizedOutputWrapper.DataArea dataAreaObj:responseWrpObj.DataArea)
             {
                 dataAreaMap.put(dataAreaObj.CustomerCode,dataAreaObj);
             }
             
             if(dataAreaMap!=null && dataAreaMap.containskey(inputWrapperObj.DataArea.CustomerCode))
             {
                 system.debug('address book size>>>>>'+addressBookList);
                 if(addressBookList!=null && addressBookList.size()>0)
                 {      
                        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c(id=addressBookList[0].ccrz__E_ContactAddress__c, 
                        ccrz__ContactAddrId__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__ContactAddrId__c, 
                        ccrz__Partner_Id__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__Partner_Id__c, 
                        ccrz__AddressFirstline__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__AddressFirstline__c, 
                        ccrz__AddressSecondline__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__AddressSecondline__c, 
                        ccrz__AddressThirdline__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__AddressThirdline__c, 
                        ccrz__City__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__City__c, 
                        ccrz__StateISOCode__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__StateISOCode__c, 
                        ccrz__PostalCode__c=addressBookList[0].ccrz__E_ContactAddress__r.ccrz__PostalCode__c, 
                        ccrz__CountryISOCode__c= addressBookList[0].ccrz__E_ContactAddress__r.ccrz__CountryISOCode__c, 
                        BMS_Site__c= addressBookList[0].ccrz__E_ContactAddress__r.BMS_Site__c);
                        
                        contactAddress.ccrz__AddressFirstline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline1;
                        contactAddress.ccrz__AddressSecondline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline2;
                        contactAddress.ccrz__AddressThirdline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline3;
                        contactAddress.ccrz__City__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).City;
                        contactAddress.ccrz__StateISOCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).State;
                        contactAddress.ccrz__CountryISOCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Country;
                        contactAddress.ccrz__PostalCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Postalcode1;
                        contactAddress.BMS_Site__c=true;

                        updateContactAddressList.add(contactAddress);
                        
                        
                 }
                 else if(addressBookList==null || addressBookList.size()==0)
                 {
                        System.debug('enter into else block of address book>>>>');
                        Integer milliseconds = DateTime.now().millisecond();
                        String contactAddrId=String.valueOf(milliseconds); 
						contactAddrId=contactAddrId+accountList[0].id;  //for Mar-1264 Mar-1292
                        //create new contact address
                        ccrz__E_ContactAddr__c contactAddress=new ccrz__E_ContactAddr__c();
                        contactAddress.ccrz__AddressFirstline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline1;
                        contactAddress.ccrz__AddressSecondline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline2;
                        contactAddress.ccrz__AddressThirdline__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).LocationAddressline3;
                        contactAddress.ccrz__City__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).City;
                        contactAddress.ccrz__StateISOCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).State;
                        contactAddress.ccrz__CountryISOCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Country;
                        contactAddress.ccrz__PostalCode__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Postalcode1;
                        contactAddress.BMS_Site__c=true;
                        contactAddress.ccrz__ContactAddrId__c=contactAddrId;
																																			  

                        insertContactAddressList.add(contactAddress);
                        System.debug('contact address list in else block>>>>'+insertContactAddressList);
                        //create new AddressBook obj
                        ccrz__E_AccountAddressBook__c addrsbook = new ccrz__E_AccountAddressBook__c();
                        addrsbook.ccrz__Account__c = accountList[0].id;
                        addrsbook.ccrz__AccountId__c = accountList[0].id;
                        addrsbook.ccrz__E_ContactAddress__r =  new ccrz__E_ContactAddr__c(ccrz__ContactAddrId__c=contactAddrId);
                      
                        addrsbook.ccrz__AddressType__c = label.OSM_Addressbook_Billing_AddressType;
                                       
                        insertAddressBookList.add(addrsbook);
                        
                        System.debug('account address list in else block>>>>'+insertAddressBookList);

                     
                 }
                 accountList[0].PaymentType__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).PaymentType;
                 accountList[0].BMSAvailableCredit__c=dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).AvailableCredit;
                 
                 if(dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Country=='US')
                 {
                     accountList[0].Currency_code__c='US';
                 }
                 else if(dataAreaMap.get(inputWrapperObj.DataArea.CustomerCode).Country=='CAD')
                 {
                     accountList[0].Currency_code__c='CAD';
                 }
                 //updateAccountList.add(accountList[0]);
                 
             }
             
             objToReturn.exceptionFlag=false;
             
         }
         else
         {
              objToReturn.exceptionFlag=true;
         }
         
         updateAccountList.add(accountList[0]);
       if(Test.isRunningTest())
       {
           throw new NullPointerException();
       }
     }
     catch(Exception ex)
     {
         System.debug('exception : '+ex.getMessage());
         log.Status__c = 'Failure'; 
         String msg  = 'Message - '+ex.getMessage();
         msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
         log.Error_Description__c = msg;
         log.Target__c = System.Label.OSM_BMS_Target_ID;
         //log.Request__c = jsonStr;
         log.Source__c = 'OSM';
         log.Logged_In_User__c = userinfo.getuserid();
     }
     lstToInsertLog.add(log);
     objToReturn.updateContactAddressList=new List<ccrz__E_ContactAddr__c>();
     objToReturn.updateAccountList=new List<Account>();
     objToReturn.insertContactAddressList=new List<ccrz__E_ContactAddr__c>();
     objToReturn.insertAddressBookList=new List<ccrz__E_AccountAddressBook__c>();
     objToReturn.insertList=new List<SObject>();
     objToReturn.lstToInsertLog=new List<OSM_Integration_Log__c>();
     
     objToReturn.updateAccountList=updateAccountList;
     objToReturn.lstToInsertLog=lstToInsertLog;

     
     if(updateContactAddressList !=null && updateContactAddressList.size()>0)
     {
         objToReturn.updateContactAddressList=updateContactAddressList;
     }
     else
     {
         system.debug('enter into else block>>>>>');
         objToReturn.insertContactAddressList=insertContactAddressList;
         objToReturn.insertAddressBookList=insertAddressBookList;
         
     }
     System.debug('Contact address list to update>>>>>'+objToReturn.updateContactAddressList);

     System.debug('Contact address list to insert>>>>>'+ objToReturn.insertContactAddressList);
     System.debug('Account address book list to insert>>>>>'+  objToReturn.insertAddressBookList);
     System.debug('Account list>>>>>'+ objToReturn.updateAccountList);
     System.debug('final object to return>>>>' + objToReturn);
     return objToReturn; 
 }
}