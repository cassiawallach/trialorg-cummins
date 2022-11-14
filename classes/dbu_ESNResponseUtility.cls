public Without Sharing class dbu_ESNResponseUtility {
    
@future
    public static void SaveESNSearchResponse(String esnResultTobeSaved, string vin)
    {
        try
        {
            system.debug('<<<<<<<<<<<<<<<< entering in SaveESNSearchResponse >>>>>>>>>>>');
            List<dbu_partsresponse__c> responseList = (List<dbu_partsresponse__c>)json.deserialize(esnResultTobeSaved, List<dbu_partsresponse__c>.class); //deserialize the reponse

            //CECI-978 - Updated the logic to Upsert the parts response data based on the External ID and delete old data - Abhilash - Start
            List<dbu_partsresponse__c> partsToUpsert = new List<dbu_partsresponse__c>();
            set<string> partsResExtId = new set<string>();
            set<string> updatedESN = new set<string> ();

            for(dbu_partsresponse__c partRes : responseList){

                string extId = partRes.dbu_ESNNumber__c + '_' + partRes.Number_Z__c;
                updatedESN.add(partRes.dbu_ESNNumber__c);

                if(!partsResExtId.contains(extId)){
                    partsResExtId.add(extId);
                    partRes.DBU_Parts_Response_ID__c = extId;
                    if(vin != null && vin != ''){
                        partRes.dbu_VINNumber__c = vin;
                    }
                    partsToUpsert.add(partRes);
                }
                
            }
           
            //insert responseList;
            system.debug('partsToUpsert count -->> ' + partsToUpsert.size());
            system.debug('partsToUpsert --> ' + partsToUpsert);
            upsert partsToUpsert DBU_Parts_Response_ID__c;


            List<dbu_partsresponse__c> deleteOlderPartsResData = new List<dbu_partsresponse__c>();
            Date dtToDeleteCache  = System.Today() - Integer.ValueOf(System.Label.dbu_cache_update_days);

            Integer dmlRowsLimit = Limits.getLimitDMLRows();
            system.debug('dmlRowsLimit --> '+ dmlRowsLimit);
            
            deleteOlderPartsResData = [SELECT Id,
                                        Number_Z__c,
                                        dbu_ESNNumber__c,
                                        dbu_Description__c
                                        FROM dbu_partsresponse__c
                                        WHERE dbu_ESNNumber__c IN :updatedESN 
                                        and LastModifiedDate < :dtToDeleteCache LIMIT :dmlRowsLimit];


            system.debug('deleteOlderPartsResData --> ' + deleteOlderPartsResData);
            Delete deleteOlderPartsResData;

            //CECI-978 - Abhilash - End
        }
        catch(Exception e)
        {
            System.debug('Failed to insert ESN Search response');
        }
    }
    @future
     public static void SaveSearchResponse(String esnResultTobeSaved,string searchparam,string storecountry,string UserIp)
    {
        try
        {
			dbu_searchString__c obj = new dbu_searchString__c();
            obj.dbu_userSearchString__c = searchparam;
            obj.dbu_storeCountry__c=storecountry;
            obj.dbu_userIpAddress__c = UserIp;
            insert obj;
            system.debug('obj'+obj);
           
            List<dbu_Search_Results__c> responseList = (List<dbu_Search_Results__c>)json.deserialize(esnResultTobeSaved, List<dbu_Search_Results__c>.class); //deserialize the reponse
           
           // insert responseList;
            system.debug('responseList'+responseList);
             List<dbu_Search_Results__c> finalres = new list<dbu_Search_Results__c>() ;
            for(dbu_Search_Results__c res :responseList){
                res.dbu_search__c = obj.Id;
                finalres.add(res);
            }
           insert finalres;
            system.debug('finalres'+finalres);
           
        }
        catch(Exception e)
        {
            System.debug('Failed to insert ESN Search response');
        }
    }
     }