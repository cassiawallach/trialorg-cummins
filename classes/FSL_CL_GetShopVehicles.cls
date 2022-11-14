/*
* Author : Divyasri Srirangam
* Description: Apex class to to fetch all the associated shop vehicles.
* TW-237*/

public without sharing class FSL_CL_GetShopVehicles {
  @InvocableMethod(label='Get Shop Vehicles' description='Returns the list of Shop vehicle Numbers for Tech User' category='Shop Vehicle Number')
public static List<List<Shop_Vehicle_Number__c>> getShopVehicleNumbers(List<ID> ids) {
    String UserId =UserInfo.getUserId();
    List<List<Shop_Vehicle_Number__c>> returnList1 = new List<List<Shop_Vehicle_Number__c>>();
    WorkOrder serOrder =[Select id,ServiceTerritoryId,ServiceTerritory.ParentTerritoryId,
                         ServiceTerritory.Type__c from workOrder
                         where ServiceTerritory.ParentTerritory.Type__c='GROUP' and id in :ids limit 1];
       list<Shop_Vehicle_Number__c> shpVehicleList  =[select id,Name,User__c,Service_Territory__c
                                                 from Shop_Vehicle_Number__c
                                                 where Service_Territory__c =:serOrder.ServiceTerritory.ParentTerritoryId
                                                 and user__c!=:UserId];
    
        if(shpVehicleList.size()>0){
           
            returnList1.add(shpVehicleList);
            system.debug('returnList1'+returnList1);
            return  returnList1;
        }
    system.debug('returnList'+returnList1);
    return null;
  
}
}