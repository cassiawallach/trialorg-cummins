public class FSL_SMNTriggerHandler {

   public  void BeforeInsert(List<FSL_Failure__c> newList){
        List<FSL_Failure__c> sm = new List<FSL_Failure__c>();
        for(FSL_Failure__c fl : newList){
            if(fl.Service_Model_Name__c != null){
                sm.add(fl);
            }
        }
        if(!sm.isEmpty()){
            populateSMNLookup(sm);
        }
    }
	
	public void BeforeUpdate(Map<ID,FSL_Failure__c> newMap, Map<ID,FSL_Failure__c> oldMap){
        system.debug('Testbefeorupdate');
        List<FSL_Failure__c> smnChange = new List<FSL_Failure__c>();
        List<FSL_Failure__c> newList = new List<FSL_Failure__c>(newMap.values());
        List<FSL_Failure__c> oldList = new List<FSL_Failure__c>(oldMap.values());
        
        for(FSL_Failure__c fl : newList){
          if(oldMap!=null) {
            if(newList[0].Service_Model_Name__c != null && fl.Service_Model_Name__c != oldMap.get(fl.id).Service_Model_Name__c ){
                smnChange.add(fl);
                system.debug('Testnewlist'+smnChange);
            }
              else{
                  smnChange.add(fl);
              }
          }
        }
        
        if(!smnChange.isEmpty()){
            populateSMNLookup(smnChange);
            //system.debug('Testoldlist'+populateSMNLookup);
			}
		}
		
	private void populateSMNLookup(List<FSL_Failure__c> mySMN){
        Set<String> smnName = new Set<String>();
        for(FSL_Failure__c fc : mySMN){
            if(fc.Service_Model_Name__c == null){
                fc.FSL_SMN__c = null;
            } else {
                smnName.add(fc.Service_Model_Name__c);
            }
        }
        Map<String,Id> smnNameToId = new Map<String,Id>();
        for( FSL_SMN_DTC__c c : [SELECT ID, Name FROM FSL_SMN_DTC__c WHERE Name IN :smnName ]){
            smnNameToId.put(c.Name,c.id);
			
			}
        for(FSL_Failure__c fail : mySMN){
            if(fail.Service_Model_Name__c != null){
                fail.FSL_SMN__c = smnNameToId.get(fail.Service_Model_Name__c);
            }
        }

    }
}