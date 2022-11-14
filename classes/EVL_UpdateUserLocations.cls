/**********************************************************************
Name:EVL_UpdateUserLocations
Copyright © 2022  Cummins
======================================================
======================================================
Purpose:                                                            
------- This class is used for Inactivate users
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Ramya Sanikommu    06/15/2022       INITIAL DEVELOPMENT(VGRS2-614)
***********************************************************************/
public class EVL_UpdateUserLocations {
    @InvocableMethod (label = 'InActive User Locations' description = 'Inactivate User Location records')
    public static void getUserLocations(List<List<String>> Locations) {
        List<CSS_UserLocation__c> inActiveUserLocations = new List<CSS_UserLocation__c>();
        List<String> strLocations = Locations[0];
        system.debug('-------strLocations----'+strLocations);
        if(!strLocations.isEmpty()){
            for(CSS_UserLocation__c usrLocation : [Select Id,isActive__c,isPrimary__c,Location_code__c from CSS_UserLocation__c where isActive__c = true and Location_code__c IN : strLocations]){
                usrLocation.isActive__c = false;
                //usrLocation.isPrimary__c = false;
                inActiveUserLocations.add(usrLocation);
            }
        }
        if(!inActiveUserLocations.isEmpty()){
            system.debug('----inActiveUserLocations-----'+inActiveUserLocations);
          	update inActiveUserLocations;
            
        }
      	
    }

}