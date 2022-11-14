/**********************************************************************
Name:FSL_AssetTriggerHandler
Copyright Â© 2020  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This is class written for User story CT2-46 for Make Model updates 
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     Ravikanth Macherla         7/7/2020    Initial Development 

********************************************************************************************************************/

public class FSL_AssetTriggerHandler{ 
    
    
    public static void updateVIN(Map<id,Asset> mapAssetNew, Map<id,Asset> mapAssetOld)
    {
        list<FSL_MakeModel_Stage__c> lstMakestage = new list<FSL_MakeModel_Stage__c>();
        list<FSL_SMN_DTC__c> lstSMNDtc = new list<FSL_SMN_DTC__c>();
        set<id> setAssetId = new set<id>();
        set<String> setSMN = new set<String>();
        for(Asset objAsset : mapAssetNew.values()){
            if(objAsset.Service_Model__c != Null){
                setSMN.add(objAsset.Service_Model__c);
            }  
        }
        lstSMNDtc = [select id,Name from FSL_SMN_DTC__c where Name in :setSMN];
        if(lstSMNDtc.size() > 0){
            for(Asset objAsset : mapAssetNew.values()){
                if(objAsset.VIN__c != mapAssetOld.get(objAsset.id).VIN__c 
                    || objAsset.Make__c != mapAssetOld.get(objAsset.id).Make__c 
                    || objAsset.Model__c != mapAssetOld.get(objAsset.id).Model__c ){  
                    
                    FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
                    
                    objstage.PSN__c = objAsset.Name;
                    objstage.VIN__c = objAsset.VIN__c;
                    if ( Asset.Make__c != NULL){                      
                        objstage.Manufacturer__c = objAsset.Make__c;
                    }
                    if ( Asset.Model__c != NULL){
                        objstage.ModelSeries__c = objAsset.Model__c;
                    }
                    
                    /*
                    //CT3-609, Dinesh Yadav
                    if(objAsset.Application_Code__c != NULL)
                        objstage.ProductApplicationCode__c = objAsset.Application_Code__c;
                    */
                    
                    if(objAsset.Type__c == 'ENGINE' ||
                       objAsset.Type__c == 'GENSET' ||
                       objAsset.Type__c == 'Engines'){
                           objstage.Type__c = 'Engines';
                           objstage.Type_PSN__c = 'Engines-' + objAsset.Name;
                    }
                       
                    else if(objAsset.Type__c == 'FIREPUMP' ||
                            objAsset.Type__c == 'ENGINE CORE' ||
                            objAsset.Type__c == 'SWITCH GEAR' ||
                            objAsset.Type__c == 'TRANSFER SWITCH' ||
                            objAsset.Type__c == 'TRANSMISSIONS' ||
                            objAsset.Type__c == 'BATTERY' ||
                            objAsset.Type__c == 'PARSYS' ||
                            objAsset.Type__c == 'MARINE GEAR' ||
                            objAsset.Type__c == 'Products') {
                                
                                objstage.Type__c = 'Products';
                                objstage.Type_PSN__c = 'Products-' + objAsset.Name;
                    }
                    
                    lstMakestage.add(objstage);
      
                }   
                }
                try{
                List<Database.upsertResult> upsertResults = Database.upsert(lstMakestage,FSL_MakeModel_Stage__c.Type_PSN__c.getDescribe().getSObjectField(), false);
                
                for (Database.upsertResult result : upsertResults) {
                    if (result.isSuccess()) {
                        // Operation was successful, so get the Id of the record that was processed into Sucess record Id set
                        System.debug('Update VIN ==== Successfully upserted Asset, AssetId: ' + result.getId());

                    } else {
                        // Operation failed, so get all errors
                        for(Database.Error err : result.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Stage fields that affected this error: ' + err.getFields());
                        }
                    }
                }

                    }catch(exception e)
                {
                    system.debug('Update VIN exception ' +e.getMessage());
                }
            }
        }
    }