/** 
* @Class Name: dbu_ReprocessShipstaionHelper    
* @Description: Reprocess the shipping label data.     
* @Main Author: Ranadip Jha    
* @ Created on: 29/12/2021   
* @Last Modified: 29/12/2021              
*/
public class dbu_ReprocessShipstaionHelper {
    
    @InvocableMethod
    public static void getShipStation(List<ccrz__E_Order__c> orderIds){
        system.debug('orderIds from helper ' + orderIds);
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        List<String> orderItemIds = new List<String>();
        List<String> orders = new List<String>();
        for(ccrz__E_Order__c orderObj : orderIds){
            if(orderObj.dbu_Is_Cloned__c){
                orders.add(orderObj.Id);
            }
        }
        orderItemList = [SELECT ID FROM ccrz__E_OrderItem__c WHERE ccrz__Order__c =:orders];
        system.debug('orderItemList ' + orderItemList);
        if(!orderItemList.isEmpty()){
            for(ccrz__E_OrderItem__c orderItemObj : orderItemList){
                orderItemIds.add(orderItemObj.Id);
            }
            try{
                if(dbu_Integration_ShipStation.firstRun){
                    dbu_Integration_ShipStation.reprocessShipStation(orders,orderItemIds,'');
                    dbu_Integration_ShipStation.firstRun = false;
                }
            }catch(Exception e){
                system.debug('line number ' + e.getLineNumber() + ' info ' + e.getMessage());
            }
        }
    }
}