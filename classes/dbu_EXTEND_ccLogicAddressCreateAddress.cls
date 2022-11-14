global with sharing class dbu_EXTEND_ccLogicAddressCreateAddress extends ccrz.ccLogicAddressCreateAddress {
    global virtual override Map<String, Object> createAddress(Map<String, Object> inputData) {
		//My Logic
		Map<String,Object> retMap = super.createAddress(inputData); 
        list<string> InsertedAddressIdsList = ((list<string>)retMap.get('addressIdList'));
        list<Map<string,object>> AddressesDetailsList = (list<Map<string,object>>)((Map<string,object>)retMap.get('originalInputData')).get('addressList');
        if(AddressesDetailsList[0].get('dbuContact') != null){
            list<ccrz__E_ContactAddr__c> ContAddList = [select id from ccrz__E_ContactAddr__c where id IN : InsertedAddressIdsList];
            for(ccrz__E_ContactAddr__c eachContAddList : ContAddList){
				eachContAddList.Dbu_Contact__c = (ID)AddressesDetailsList[0].get('dbuContact');
            }
            update ContAddList;
            system.debug('UPDATE SUCCESSFILL!!! - FOR LOGGED IN USER');
        }else{
            system.debug('USUAL FLOW FOR ANNONYMOUS USER');
        }
        return retMap;         
    }		
}