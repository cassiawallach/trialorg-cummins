Public Class CSS_WS_EPRWorkpaper{

    Public CSS_WS_Warranty__c claim { get; set; }
    Public List<CSS_WS_Warranty_Parts__c> parts {get; set;} 
    Public Boolean partsEnabled {get; set;} 
    Public String account_address {get; set;}
    
    Public CSS_WS_EPRWorkpaper(ApexPages.StandardController stdController){
        partsEnabled = false;
        account_address = '';
        this.claim = (CSS_WS_Warranty__c)stdController.getRecord();            
        getParts();
        getAcountAddress();
    }
    
    Public List<CSS_WS_Warranty_Parts__c> getParts(){
        if(parts == null){
            try{                
                parts = [SELECT Id, CSS_WS_Long_Part_Number_del__c, CSS_WS_Description__c, CSS_WS_Quantity__c, CSS_WS_Shipping_Company__c,
                CSS_WS_Tracking_Guide_Code__c, CSS_WS_EPR_Attention__c, CSS_WS_EPR_Note__c FROM CSS_WS_Warranty_Parts__c 
                WHERE CSS_WS_WarrantyID__c =:this.claim.Id AND CSS_WS_Part_Return_Flag__c = True  ORDER BY CSS_WS_Long_Part_Number_del__c ASC];
                if(parts != null && parts.size() != 0){
                    partsEnabled = true;
                    integer i = 0;
                    for(CSS_WS_Warranty_Parts__c part : parts){
                        parts[i].CSS_WS_EPR_Attention__c = parts[i].CSS_WS_EPR_Note__c.substringBetween('MESSAGE:','*');
                        parts[i].CSS_WS_EPR_Note__c = parts[i].CSS_WS_EPR_Note__c.substringAfter('*');
                        i = i + 1;
                    }
                }
                
            } catch (Exception e){
                System.debug('Error: '+e.getMessage());
            }
        }
        return parts;
    }
    
    Public void getAcountAddress(){
        Account[] account_address_list = [SELECT name, BillingAddress FROM Account WHERE IAM_Service_Provider_Code__c =:this.claim.CSS_WS_Service_Provider_Dealer__c AND (Type = 'Dealer Account' OR Type = 'Distributor Account' OR Type = 'Dealer Branch Account' OR Type = 'Distributor Branch Account') AND CMI_Account_Status__c = 'Active' limit 1]; 
        if(account_address_list.size() > 0){
            Address addr = account_address_list[0].BillingAddress;
            account_address = (addr.getStreet() != null) ? addr.getStreet() + ', ' : '';
            account_address = (addr.getCity() != null) ? account_address + addr.getCity() + ', ' : account_address + ''; 
            account_address = (addr.getState() != null) ? account_address + addr.getState() + ', ' : account_address + ''; 
            account_address = (addr.getStateCode() != null) ? account_address + addr.getStateCode() + ', ' : account_address + '';
            account_address = (addr.getPostalCode() != null) ? account_address + addr.getPostalCode() + ', ' : account_address + ''; 
            account_address = (addr.getCountry() != null) ? account_address + addr.getCountry() : account_address + '';  
        }
    }
}