/*
* Author : Divyasri Srirangam
* Description: Apex class to to fetch user defined vehicle from the associated shop vehicles.
* TW-237*/
public without sharing class FSL_CL_GetUserDefinedVehicle {

@InvocableMethod(label='Get User Defined Vehicle' description='Returns the list of Shop vehicle Numbers for Tech User' category='Shop Vehicle Number')
public static List<List<Shop_Vehicle_Number__c>> getShopVehicleNumbers(List<ID> ids) {
    List<List<Shop_Vehicle_Number__c>> returnList1 = new List<List<Shop_Vehicle_Number__c>>();
    list<Shop_Vehicle_Number__c> userdefinedList =new list<Shop_Vehicle_Number__c>();
    String UserId =UserInfo.getUserId();
    WorkOrder serOrder =[Select id,ServiceTerritoryId,ServiceTerritory.ParentTerritoryId,
                         ServiceTerritory.Type__c from workOrder
                         where ServiceTerritory.ParentTerritory.Type__c='GROUP' and id in :ids limit 1];
    
   list<Shop_Vehicle_Number__c>shpVehicle =[select id,Name,User__c,Service_Territory__c
                                         from Shop_Vehicle_Number__c
                                         where Service_Territory__c =:serOrder.ServiceTerritory.ParentTerritoryId
                                         ];
    if(shpVehicle.size()>0){
        for(Shop_Vehicle_Number__c svn :shpVehicle){
            if (svn.user__c==UserId){
                userdefinedList.add(svn);
                returnList1.add(userdefinedList);
                return returnList1;
                
                 }
        }
    }
    
    return null;
}
}