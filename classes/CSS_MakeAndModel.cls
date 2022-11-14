/**********************************************************************
Name:CSS_MakeAndModel
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish         6/2/2016      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_MakeAndModel {
    public static void updateEquipmentId(list<CSS_Job_Order__c> newList, map<Id,CSS_Job_Order__c> oldMap){
        try{
            CSS_Job_Order__c jo = new CSS_Job_Order__c();
            //  CSS_Make_Model__c lmodel;
            CSS_Make_Model_Access__c lmodel;

            /*for(CSS_Job_Order__c jobOrder : newList){
                if(newList[0].Qsol_Engine_Family_Code__c !=null && oldMap.get(jobOrder.Id).Make__c!=null && oldMap.get(jobOrder.Id).Model__c!=null){
                    lmodel=[Select EquipmentId__c,AccessCode__c From CSS_Make_Model__c where EngineFamily__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:oldMap.get(jobOrder.Id).Make__c AND Model__c=:oldMap.get(jobOrder.Id).Model__c LIMIT 1];                    
                    jo.Equipment_ID__c=lmodel.EquipmentId__c;
                    jo.AccessCode__c=lmodel.AccessCode__c;
                    jo.id=newList[0].id;
                    update jo;
                } 
            } */  
            //if(newList[0].Qsol_Engine_Family_Code__c !=null && oldMap.get(newList[0].Id).Make__c!=null && oldMap.get(newList[0].Id).Model__c!=null){
            if(newList[0].Qsol_Engine_Family_Code__c !=null && newList[0].Make__c!=null && newList[0].Model__c!=null){
                //lmodel=[Select EquipmentId__c,AccessCode__c From CSS_Make_Model__c where EngineFamily__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:oldMap.get(newList[0].Id).Make__c AND Model__c=:oldMap.get(newList[0].Id).Model__c LIMIT 1];                    
                // lmodel=[Select EquipmentId__c,AccessCode__c From CSS_Make_Model__c where EngineFamily__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:newList[0].Make__c AND Model__c=:newList[0].Model__c LIMIT 1];                    
                lmodel=[Select EquipmentId__c,Access__c From CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' AND EngineFamilyCode__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:newList[0].Make__c AND Model__c=:newList[0].Model__c LIMIT 1]; 
                jo.Equipment_ID__c=lmodel.EquipmentId__c;
                jo.AccessCode__c=lmodel.Access__c;
                jo.id=newList[0].id;
                update jo;
            }
        }catch(exception e){}
    }



    public static void updateEquipmentId(list<CSS_PSN__c> newList){
        try{
            CSS_PSN__c psnRec = new CSS_PSN__c();
            CSS_Make_Model_Access__c lmodel;

            //if(newList[0].Qsol_Engine_Family_Code__c !=null && oldMap.get(newList[0].Id).Make__c!=null && oldMap.get(newList[0].Id).Model__c!=null){
            if(newList[0].Qsol_Engine_Family_Code__c !=null && newList[0].Make__c!=null && newList[0].Model__c!=null){
                lmodel=[Select EquipmentId__c,Access__c From CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' AND EngineFamilyCode__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:newList[0].Make__c AND Model__c=:newList[0].Model__c LIMIT 1]; 
                psnRec.Equipment_ID__c=lmodel.EquipmentId__c;
                psnRec.AccessCode__c=lmodel.Access__c;
                psnRec.id=newList[0].id;
                update psnRec;
                System.debug('after psnRec update ClaimsId>>>:'+newList[0].CSS_Claims__c);
                
                CSS_Claims__c cliamsRec = [Select Id, Name from CSS_Claims__c where Id=:newList[0].CSS_Claims__c];
                cliamsRec.AccessCode__c = lmodel.Access__c;
                update cliamsRec;
                System.debug('after claimsRec update with AccessCode cliamsRec.AccessCode__c>>:'+cliamsRec.AccessCode__c);
                
            }
        }catch(exception e){
            system.debug('Entered into catch block of updateEquipmentId2 method in psnTrigger Class'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }

}