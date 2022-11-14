/**********************************************************************
Name: FSL_SiebelWSbatch
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to populate the custom failure names, system code, component code and Fail mode from
Siebel warranty system
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         5/03/2019                         
***********************************************************************/
public class FSL_SiebelWSbatch implements Database.batchable<CSS_SiebelFailCodeResponseJ2A>,Database.AllowsCallouts,Database.Stateful {
    public list<FSL_Failure__c>  lstfail = new list<FSL_Failure__c>();
    
    public Iterable<CSS_SiebelFailCodeResponseJ2A> start(Database.BatchableContext BC) {
        return new FSLSiebelRespIterable();
    }
    
    public void execute(Database.BatchableContext info, List<CSS_SiebelFailCodeResponseJ2A> scope) {
        system.debug('check---->'+scope);
        for(CSS_SiebelFailCodeResponseJ2A fsr : scope) {
            if(fsr !=null && fsr.DataArea !=null && fsr.DataArea.Details.size()>0 ) {
                for(CSS_SiebelFailCodeResponseJ2A.Details objWrapper : fsr.DataArea.Details) {
                    system.debug('wrapper---->' + objWrapper );
                    FSL_Failure__c objfail = new FSL_Failure__c ();
                    objfail.Name = objWrapper.SystemCode + objWrapper.ComponentCode;
                    objfail.Failure_Name__c = objWrapper.FailureName;
                    objfail.Component_Code__c = objWrapper.ComponentCode + '-' + objWrapper.ComponentName;
                    objfail.System_Code__c = objWrapper.SystemCode + '-' + objWrapper.SystemName;
                    objfail.Business_Unit__c = objWrapper.BusinesUnit;
                    lstfail.add(objfail);
                }
            }
        }
        if(lstfail.size()>0) {
            Database.upsert(lstfail, false);
        }
    }
    
    public void finish(Database.BatchableContext info) {
        
    }
}