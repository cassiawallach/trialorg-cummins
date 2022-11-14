/**********************************************************************
Name:FSL_MovexServiceTerritoryBatchProcess
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used for prepopulate Cash Sale Customer Code on the Service Territory
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0      Ravikanth Macherla         04/30/2019                         
***********************************************************************/
global class FSL_MovexServiceTerritoryBatchProcess implements Database.batchable<FSL_MovexServiceTerritoryWrapper >,Database.AllowsCallouts,Database.Stateful {

    global String tokenStr;
    global String query;
    list<ServiceTerritory> lstST = new list<ServiceTerritory>();
    
    /*STARTS -- START METHOD*/
    global Iterable<FSL_MovexServiceTerritoryWrapper> start(Database.BatchableContext BC) {
    
        system.debug('*****************START METHOD**********************');
        return new FSL_MovexServiceTerittoryRespIterable();
    }
    /*ENDS -- START METHOD*/
    
    /*STARTS -- EXECUTE METHOD*/
    global void execute(Database.BatchableContext info, List<FSL_MovexServiceTerritoryWrapper> scope) { 
        system.debug('testing---->'+scope);
        map<string,Id>  mapres = new map<string,Id>();
        for (ServiceTerritory objst : [select Id,Location_Code__c from ServiceTerritory ]) {
            mapres.put(objst.Location_Code__c,objst.id);
        }
        
        List <ServiceTerritory> acList = new List <ServiceTerritory> ();
        
        for(FSL_MovexServiceTerritoryWrapper fsr : scope) {
            for(FSL_MovexServiceTerritoryWrapper.DataArea objWrapper : fsr.DataArea) {
                if(objWrapper.Code == 'Cash Sale Customer') {
                    system.debug('mapppp--->'+mapres.get(fsr.Header.Location.LocationID));
                    system.debug('check code value'+objWrapper.CodeValue);
                    ServiceTerritory objST = new ServiceTerritory(id=mapres.get(fsr.Header.Location.LocationID));
                    objST.Code_Value__c = objWrapper.CodeValue;
                    objST.Code_Description__c = objWrapper.CodeDescription;
                    acList.add(objST);
                }
            }
        }
        system.debug('update----> '+acList);
        if(acList.size()>0){
            update acList;
        }
    }
    
    global void finish(Database.BatchableContext info) {
        system.debug('*****************FINISH METHOD**********************');
    }
}