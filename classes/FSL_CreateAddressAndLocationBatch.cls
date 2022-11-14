/**********************************************************************
Name:CreateAddressAndLocationBatch
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
Batch Job which retrieves the data from IAM_CDH_Cross_references__c  and updates in Addresses and Locations Object.
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0       Vijay Avula                03/19/2021    Batch Job to update Load Data into Address and Location Object
********************************************************************************************************************/

public class FSL_CreateAddressAndLocationBatch implements Database.batchable<sobject> {

    public static Database.queryLocator start(Database.batchableContext BC){
        String query = 'Select Id, Name, FSL_Distributor_Code__c, FSL_Branch_Code__c, FSL_MoveX_Contact_Id__c,' +
                       'IAM_Account__c, FSL_Job_Contact__c, FSLSite_Contact_Phone__c, FSL_MoveX_Site_Id__c,' +
                       'FSL_Site_Status__c, FSL_Address_Line_1__c, FSL_Address_Line_2__c, FSL_Address_Line_3__c, FSL_City__c,' + 
                       'FSL_State__c, FSL_Postal_Code__c, FSL_Country__c, FSL_Latitude__c, FSL_Longitude__c, FSL_Tax_District__c ' +
                       'From IAM_CDH_Cross_references__c Where IsConverted__c = false Order By CreatedDate DESC ';
        return Database.getQueryLocator(query);
    }
    
    public static void execute(Database.batchableContext BC, List<sobject> scope){
        List<Schema.Location> locationList = new List<Schema.Location>();
        List<Schema.Address> addressList = new List<Schema.Address>();
        List<IAM_CDH_Cross_references__c> iamList = (List<IAM_CDH_Cross_references__c>) scope;
        
        for(IAM_CDH_Cross_references__c iamRecord: iamList){
            Schema.Location loc = new Schema.Location();
            loc.Name = iamRecord.Name;
            loc.FSL_Distributor_Code__c = iamRecord.FSL_Distributor_Code__c;
            loc.FSL_Branch_Code__c = iamRecord.FSL_Branch_Code__c;
            loc.FSL_Contact_ID__c = iamRecord.FSL_MoveX_Contact_Id__c;
            loc.FSL_Account__c = iamRecord.IAM_Account__c;
            loc.FSL_Contact__c = iamRecord.FSL_Job_Contact__c;
            loc.FSL_Contact_Phone__c = iamRecord.FSLSite_Contact_Phone__c;
            locationList.add(loc);  
            
            Schema.Address addr = new Schema.Address();
            addr.IAM_Site__c = iamRecord.Id;
            addr.FSL_Site_Name__c = iamRecord.Name;
            addr.FSL_Site_ID__c = iamRecord.FSL_MoveX_Site_Id__c;
            addr.Status__c = iamRecord.FSL_Site_Status__c;
            addr.Street = iamRecord.FSL_Address_Line_1__c;
            addr.Street += iamRecord.FSL_Address_Line_2__c != null ? ',' + iamRecord.FSL_Address_Line_2__c : '';
            addr.Street += iamRecord.FSL_Address_Line_3__c != null ? ',' + iamRecord.FSL_Address_Line_3__c : '';
            addr.City = iamRecord.FSL_City__c;
            addr.State = iamRecord.FSL_State__c;
            addr.PostalCode = iamRecord.FSL_Postal_Code__c;
            addr.Country = iamRecord.FSL_Country__c;
            addr.Latitude = iamRecord.FSL_Latitude__c != null ? Decimal.valueOf(iamRecord.FSL_Latitude__c) : null;
            addr.Geolocation__Latitude__s = iamRecord.FSL_Latitude__c != null ? Decimal.valueOf(iamRecord.FSL_Latitude__c) : null;
            addr.Longitude = iamRecord.FSL_Longitude__c != null ? Decimal.valueOf(iamRecord.FSL_Longitude__c) : null;
            addr.Geolocation__Longitude__s = iamRecord.FSL_Longitude__c != null ? Decimal.valueOf(iamRecord.FSL_Longitude__c) : null;
            addr.FSL_Tax_District__c = iamRecord.FSL_Tax_District__c;
            addressList.add(addr);
             
        }
        
        List<Database.SaveResult> srLocation = Database.insert(locationList,false);
        Integer i = 0;
        for(Database.SaveResult sr: srLocation){
            if(sr.isSuccess()){
                addressList[i].parentId = sr.getId();
            }
            i++;
        }
        
        List<Database.SaveResult> srAddress = Database.insert(addressList,false);
        i=0;
        for(Database.SaveResult sr: srAddress){
            if(sr.isSuccess()){
                iamList[i].isConverted__c = true; 
            }
            i++;
        }
        
        update iamList;
    }
    
    public static void finish(Database.batchableContext BC){
    
    }
}