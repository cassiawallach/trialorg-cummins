/**********************************************************************
Name:FSL_CL_ServiceTerritory
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used for prepopulate the service territory when user creates new service request taking customer location code
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         1/03/2019                         
***********************************************************************/

public class FSL_CL_ServiceTerritory {
    
    @AuraEnabled
    public static ServiceTerritory getServiceTerritorydetails() { 
        ServiceTerritory objservicTer;
        User LoggedInUser = [SELECT Id, FSL_Primary_Service_Territory_Code__c FROM User WHERE id =: UserInfo.getUserId() LIMIT 1];
        if(LoggedInUser.FSL_Primary_Service_Territory_Code__c !=null && LoggedInUser.FSL_Primary_Service_Territory_Code__c !='' ) {
        	try {
                objservicTer = [SELECT Id, FSL_Service_Territory_Code__c,Mileage_Measure__c FROM ServiceTerritory WHERE FSL_Service_Territory_Code__c =: LoggedInUser.FSL_Primary_Service_Territory_Code__c LIMIT 1];
        	}
           	catch(exception e){}
        }
        return objservicTer;
    }
      @AuraEnabled
    public static ServiceTerritory getOwnerPrimaryServiceTerritoryCheck(Id ownerId) { 
        system.debug('ownerId****' + ownerId);
        ServiceTerritory objservicTer;
        List<User> csownerIdTerrCode = [SELECT Id, FSL_Primary_Service_Territory_Code__c FROM User WHERE id =: ownerId LIMIT 1];
        system.debug('csownerIdTerrCode******' + csownerIdTerrCode);
        if(csownerIdTerrCode.size()>0){
            system.debug('inside if csownerIdTerrCode');
          if(csownerIdTerrCode[0].FSL_Primary_Service_Territory_Code__c !=null && csownerIdTerrCode[0].FSL_Primary_Service_Territory_Code__c !='' ) {
        	try {
                objservicTer = [SELECT Id, FSL_Service_Territory_Code__c,Mileage_Measure__c FROM ServiceTerritory WHERE FSL_Service_Territory_Code__c =: csownerIdTerrCode[0].FSL_Primary_Service_Territory_Code__c LIMIT 1];
        	}
           	catch(exception e){}
          }
        }return objservicTer; 
    }
}