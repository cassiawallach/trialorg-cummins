/**********************************************************************
Name:EVL_LookupCompController
Copyright © 2020  Cummins
======================================================
======================================================
Purpose: Fetching Account and Asset Records.                                                          
======================================================
======================================================
History                                                            
VERSION  	AUTHOR            			DATE                DETAIL                                 
1.0 	 	Krishnamoorthi N			06/26/2020			INITIAL DEVELOPMENT 
2.0         Piyush                      07/20/2021          CT1-607 changes for Asset and account lookup
3.0         Diksha Rajourohit           8/24/2022           VGRS2-727 DML Query Changes
***********************************************************************/
public  class EVL_LookupCompController {

    @AuraEnabled(cacheable=true)
    public static List < sObject > fetchLookUpValues(String searchType, String searchKeyWord, String ObjectName) {
        system.debug('::: ObjectName-->' + ObjectName);
        system.debug('::: SearchType -->' + searchType+' * and searchKeyWord = '+searchKeyWord);
        //String searchKey = '%' + searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
      	
        if(ObjectName == 'Account') {
            set<string> AccountIdSet = new set<string>();
            System.debug('*** User Id = '+UserInfo.getUserId());
            list<CSS_UserLocation__c> userlocList = [SELECT Id, Name, AccountId__c 
                                                     FROM CSS_UserLocation__c 
                                                     WHERE UserId__c =:UserInfo.getUserId() AND  isActive__c = true]; 
            system.debug('userlocList-->' + userlocList);
            for(CSS_UserLocation__c ul : userlocList) {
                System.debug('*** User Location Acc Id = '+ul.AccountId__c);
                AccountIdSet.add(ul.AccountId__c);
            }
            System.debug('*** Acc Ids = '+AccountIdSet);
            String searchKey = searchKeyWord + '%';
            searchKey = String.escapeSingleQuotes(searchKey);
            System.debug('*** SearchKey = '+searchKey);
            String sQuery =  'select id, Name from ' +ObjectName + ' where Id IN : AccountIdSet'; //SOQL Injection safe 
            //sQuery += ' AND Name LIKE: searchKey ';
            System.debug('*** Query = '+sQuery);
            List < sObject > lstOfRecords = Database.query(sQuery);
            
            for (sObject obj: lstOfRecords) {
                System.debug('*** obj = '+obj);
                returnList.add(obj);
            }
        } else {
            // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
            //String sQuery =  'select id, Name, VIN__c, Unit_Number__c from ' +ObjectName + ' where Name LIKE: searchKey OR VIN__c LIKE: searchKey OR Unit_Number__c LIKE: searchKey limit 50';
            //String sQuery =  'select id, Name, VIN__c, Unit_Number__c from ' +ObjectName + ' where Name =: '+searchKey+'%'+ 'OR VIN__c =:'+ searchKey + '%' +'OR Unit_Number__c =:'+ searchKey limit 50';
            
            String searchKey;
            String queryString = 'Select Id, Name, VIN__c, Unit_Number__c FROM '+ObjectName;
            if(searchType == 'AssetNumber') {
                System.debug('::: Asset Number Search = '+searchType);
                searchKey = searchKeyWord + '%';
                searchKey = String.escapeSingleQuotes(searchKey);
                queryString += ' WHERE Name LIKE: searchKey ';  //SOQL Injection safe
            } else if(searchType == 'VINNumber') {
                System.debug('::: VIN Number Search = '+searchType);
                searchKey = '%' + searchKeyWord;
                searchKey = String.escapeSingleQuotes(searchKey);
                queryString += ' WHERE VIN__c LIKE: searchKey ';   //SOQL Injection safe
            } else if(searchType == 'UnitNumber') {
                //searchKey = searchKeyWord + '%';
                //queryString += ' WHERE Unit_Number__c LIKE: searchKey ';
                searchKey = searchKeyWord;
                searchKey = String.escapeSingleQuotes(searchKey);
                queryString += ' WHERE Unit_Number__c =: searchKey ';  //SOQL Injection safe
            }
            queryString += ' LIMIT 50';
            System.debug('::: Query String = '+queryString);
            List < sObject > lstOfRecords = Database.query(queryString);
            
            for (sObject obj: lstOfRecords) {
                returnList.add(obj);
            }
        }
        System.debug('*** returnList = '+returnList);
        return returnList;
    }
    
    @AuraEnabled
    public static WorkOrder saveServiceOrder(String AccountIdd, String ContactNam, String AssetIdd,String Cus,String CusComp,String shpWrkOrd,String PrdctHrs,String PrdctMil,String MilMes) {
		system.debug('AccountId>>'+AccountIdd+'Customer'+Cus);
        WorkOrder WORec = new WorkOrder();
        WORec.AccountId = (AccountIdd != null && AccountIdd != '' ? Id.valueof(AccountIdd) : null);
        WORec.AssetId = (AssetIdd != null && AssetIdd != '' ? Id.valueof(AssetIdd) : null);
        WORec.EVL_Contact__c = ContactNam;
        WORec.EVL_Customer__c = Cus;
        WORec.General_Symptoms__c = CusComp;
        WORec.Dealer_Shop_Work_Order__c = shpWrkOrd;
        WORec.CSS_Hours__c = (PrdctHrs != null && PrdctHrs != '' ? Decimal.valueof(PrdctHrs) : null);
        WORec.Mileage__c = (PrdctMil != null && PrdctMil != '' ? Decimal.valueof(PrdctMil) : null);
        WORec.Mileage_Measure__c = MilMes;
        Insert WORec;
        system.debug('Success'+WORec.Id);
        return WORec;
    }
    
    @AuraEnabled 
    public static CSS_UserLocation__c fetchUser(){
     // query current user information  
     CSS_UserLocation__c userloc = new CSS_UserLocation__c();
      userloc = [Select Id, Name,AccountId__c, AccountId__r.Name From CSS_UserLocation__c Where UserId__c =:UserInfo.getUserId() AND isPrimary__c = true AND  isActive__c = true Limit 1]; 
        return userloc;
    
    }

}