/**********************************************************************
Name:CSS_DataExchangeAdmin
Copyright © 2011  Cummins
                                                        
VERSION  AUTHOR            DATE                DETAIL                                 
2.0 -    Vamshi Krishna  04/06/2018         Story-137899 
***********************************************************************/
public class CSS_DataExchangeAdmin {
    
    @testVisible
    Map<id,Account> accsMap = new Map<id,Account>();
    public Account accDetails {get;set;}
    public List<Account> listAccounts {get;set;}
    public List<SelectOption> locationsOptions{get;set;}
    public String selectedLocationId{get;set;}
    
    public CSS_DataExchangeAdmin(){      
        system.debug(UserInfo.getUserId()); 
        User u = [select Id,AccountId,username from User where Id = :UserInfo.getUserId() ];
         system.debug('**'+u);
       if(u.AccountId!=null)   
      // Query Account and its child accounts records to display them in the vf dropdownlist     
        listAccounts = [
            Select Id,name,Location__c, Customer_Data_Send_to_CSS__c, Customer_Data_Receive_from_CSS__c,Customer_Data_Last_Transfer__c, 
            Vehicle_Unit_Data_Send_to_CSS__c, Vehicle_Unit_Data_Receive_from_CSS__c, Vehicle_Unit_Data_Last_Transfer__c, ESN_Service_History_Send_to_CSS__c, 
            ESN_Service_History_Last_Data_Transfer__c, Fault_Code_Data_Receive_from_CSS__c, Solution_Data_Receive_from_CSS__c, Repair_Data_Receive_from_CSS__c,
            (select  
             Id,name,Location__c, Customer_Data_Send_to_CSS__c, Customer_Data_Receive_from_CSS__c, Customer_Data_Last_Transfer__c, Vehicle_Unit_Data_Send_to_CSS__c, 
             Vehicle_Unit_Data_Receive_from_CSS__c, Vehicle_Unit_Data_Last_Transfer__c, ESN_Service_History_Send_to_CSS__c, ESN_Service_History_Last_Data_Transfer__c, 
             Fault_Code_Data_Receive_from_CSS__c, Solution_Data_Receive_from_CSS__c, Repair_Data_Receive_from_CSS__c from CSS_DE_Parent__r ORDER BY Name) 
            from Account where 
          Id=:u.AccountId];  
        accsMap = new Map<id,Account>();
     //Select option for showing parent and its child locations 
        locationsOptions = new List<SelectOption>();
        if(listAccounts.size()>0){
            locationsOptions.add(new SelectOption('', '--Select--'));
            locationsOptions.add(new SelectOption('--Select All--', '--Select All--'));
           // locationsOptions.add(new SelectOption(listAccounts[0].Id, listAccounts[0].Name));
          //  accsMap.put(listAccounts[0].Id, listAccounts[0]);
            for(Account childAcc: listAccounts[0].CSS_DE_Parent__r){
                locationsOptions.add(new SelectOption(childAcc.Id, childAcc.Name));
                accsMap.put(childAcc.Id, childAcc);
            }
        }
        
    }       
    public void processSelectedLocation(){
        // We need to process for All location when we selected 'selected All'
        if(selectedLocationId == '--Select All--'){
            accDetails = new Account();
        }
        else{
            // We need to process for  selected Location
            accDetails = accsMap.get(selectedLocationId);
        }
    }
    
    public void deSave(){
        if(selectedLocationId == '--Select All--'){ 
            // This method will save changes in Account records
            for(Account acc : accsMap.values()) {
                acc.Customer_Data_Send_to_CSS__c = accDetails.Customer_Data_Send_to_CSS__c;
                acc.Customer_Data_Receive_from_CSS__c = accDetails.Customer_Data_Receive_from_CSS__c;
                acc.Vehicle_Unit_Data_Send_to_CSS__c = accDetails.Vehicle_Unit_Data_Send_to_CSS__c;
                acc.Vehicle_Unit_Data_Receive_from_CSS__c = accDetails.Vehicle_Unit_Data_Receive_from_CSS__c;
                acc.ESN_Service_History_Send_to_CSS__c = accDetails.ESN_Service_History_Send_to_CSS__c;
                acc.Fault_Code_Data_Receive_from_CSS__c = accDetails.Fault_Code_Data_Receive_from_CSS__c;
                acc.Solution_Data_Receive_from_CSS__c = accDetails.Solution_Data_Receive_from_CSS__c;
                acc.Repair_Data_Receive_from_CSS__c = accDetails.Repair_Data_Receive_from_CSS__c;
            }
        }
        else{
            if(!test.isrunningtest())
            accsMap.put(accDetails.Id, accDetails);
        }
        if(!test.isrunningtest())
        update accsMap.values();        
    }
    
}