/****************************************************************************************
HISTROY

VERSION  AUTHOR            DATE                DETAILS                                 
1.0 - Krishnamoorthi 03/25/2020FSL SP Scheduler methods.
2.0 -Anvesh Reddy Sama      03/25/2020          FSL SPHeader method.
******************************************** ********************************************/
public class FSLSPInfo {
    /*Start: Code for TechnicianInfo  callout*/
    public static void getSPTechnicianData(List<FSL_SPTechnicians_Stage__c> fslSPTechList){
        try {
            
            system.debug('fslSPTechList ' + fslSPTechList);
            list<FSL_SPTechnicians_Stage__c> updateSPTechStgList = new list<FSL_SPTechnicians_Stage__c>();
            list<FSL_SPTechnicians_Stage__c> deleteSPTechStgList = new list<FSL_SPTechnicians_Stage__c>();
            
            set<string> settechrowid= new set<string>(); //Used to query the Accred User
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
			set<string>  externalKeySet = new set<string>();
            
            for(FSL_SPTechnicians_Stage__c spTechStage : fslSPTechList){
                if(spTechStage.TechRowId__c != null && spTechStage.TechRowId__c != '')
                    settechrowid.add(spTechStage.TechRowId__c);
                if(spTechStage.SPCode__c != null && spTechStage.SPCode__c != '')                    
                    setSpCodes.add(spTechStage.SPCode__c); //building set of all spcode to fetch all accounts based on it 
            }
            system.debug('settechrowid ' + settechrowid);
            system.debug('setSpCodes ' + setSpCodes);
            
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add(s);
                }
            }
            
            List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c,IAM_Service_Provider_Code__c  from Account where IAM_Service_Provider_Code__c IN :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.IAM_Service_Provider_Code__c, acc.id);
            }
            system.debug('mapSpCodeAccountId ' + mapSpCodeAccountId);
            
            list<CSS_AccredUser__c> updatedlstAccredUser= new list<CSS_AccredUser__c>(); //Holds the record of accred User
            Map<string, CSS_AccredUser__c> AccredUserMap = new Map<string, CSS_AccredUser__c>();
            
            list<CSS_AccredUser__c> lstAccredUser = [SELECT id,First_Name__c,Last_Name__c,Promotion_Id__c,
                                                     account__c,TECH_ROW_ID__c
                                                     //User_Login_ID__c,Passed_Date_SBL__c,ServiceModelName__c,,SMN_ROW_ID__c,CERT_PERCENTAGE__c
                                                     FROM CSS_AccredUser__c
                                                     WHERE TECH_ROW_ID__c IN : settechrowid ];
            if(lstAccredUser != null && lstAccredUser.size()>0){
                for(CSS_AccredUser__c accuser : lstAccredUser)
                    AccredUserMap.put(accuser.TECH_ROW_ID__c, accuser);
            }
            
            if(AccredUserMap != null && AccredUserMap.size() >0 ) {
                for(FSL_SPTechnicians_Stage__c fslsptech : fslSPTechList){
                    CSS_AccredUser__c accuser = AccredUserMap.get(fslsptech.TechRowId__c);
                    system.debug('accuser ' + accuser);
                    if(accuser != null) {
                        CSS_AccredUser__c updatedaccuser = new CSS_AccredUser__c();
                        updatedaccuser.Id = accuser.Id;
                        updatedaccuser.First_Name__c = fslsptech.FirstName__c;
                        updatedaccuser.Last_Name__c = fslsptech.LastName__c;
                        updatedaccuser.Promotion_Id__c = fslsptech.PromotionId__c;
                        if(fslsptech.SPCode__c != null && fslsptech.SPCode__c.trim() != '' && mapSpCodeAccountId.containskey(fslsptech.SPCode__c))
                            updatedaccuser.account__c = mapSpCodeAccountId.get(fslsptech.SPCode__c); //Map Account Id as lookup Id 
                        //updatedlstAccredUser.add(updatedaccuser);
                        if(!externalKeySet.contains(updatedaccuser.Id))
                			updatedlstAccredUser.add(updatedaccuser);
                		externalKeySet.add(updatedaccuser.Id);                                              
                        deleteSPTechStgList.add(fslsptech);
                        system.debug('deletefslsptech ' + fslsptech);
                    } else {
                        fslsptech.FailureReason__c = 'Invalid Record';
                        updateSPTechStgList.add(fslsptech);
                        system.debug('updatefslsptech ' + fslsptech);
                    }
                }
            } else {
                for(FSL_SPTechnicians_Stage__c fslsptech : fslSPTechList){
                    fslsptech.FailureReason__c = 'Invalid Record';
                    updateSPTechStgList.add(fslsptech);
                    system.debug('updatefslsptech ' + fslsptech);
                }
            }
            
            //DML Operations.
            if(updatedlstAccredUser != null && updatedlstAccredUser.size() > 0)
                update updatedlstAccredUser;
            
            if(deleteSPTechStgList != null && deleteSPTechStgList.size() > 0)
                delete deleteSPTechStgList;
            
            if(updateSPTechStgList != null && updateSPTechStgList.size() > 0)
                update updateSPTechStgList;
            
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPInfo.GetSPTechnicianData execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPInfo.GetSPTechnicianData', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'GetSPTechnicianData');
        }
    }
    
    public static void getSPAffilationsData(List<FSL_SPAffilations_Stage__c> fslSPAffStageList){
        //CSS_FN_SIEBEL.getSPAffiliationData();
        try {
            system.debug('fslSPAffStageList ' + fslSPAffStageList);
            list<FSL_SPAffilations_Stage__c> updateSPAffStgList = new list<FSL_SPAffilations_Stage__c>();
            list<FSL_SPAffilations_Stage__c> deleteSPAffStgList = new list<FSL_SPAffilations_Stage__c>();
            
            set<string> settechrowid= new set<string>(); //Used to query the Accred User
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            set<string>  externalKeySet = new set<string>();
            
            for(FSL_SPAffilations_Stage__c spAffStage : fslSPAffStageList){
                if(spAffStage.SPRowId__c != null && spAffStage.SPRowId__c != '')
                    settechrowid.add(spAffStage.AffiliationRowId__c);
                if(spAffStage.SPCode__c != null && spAffStage.SPCode__c != '')                    
                    setSpCodes.add(spAffStage.SPCode__c); //building set of all spcode to fetch all accounts based on it 
            }
            system.debug('settechrowid ' + settechrowid);
            system.debug('setSpCodes ' + setSpCodes);
            
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add(s);
                }
            }
            
            System.debug('setFormatedSpCodes>>>:'+setFormatedSpCodes);
            
            List<Account> accountList = new List<Account>([SELECT Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c,IAM_Service_Provider_Code__c  
                                                           from Account where IAM_Service_Provider_Code__c IN :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.IAM_Service_Provider_Code__c, acc.id);
            }
            system.debug('mapSpCodeAccountId ' + mapSpCodeAccountId);
            
            list<CSS_OEM_AFFILIATIONS__c> updatedOEMAffUser= new list<CSS_OEM_AFFILIATIONS__c>(); //Holds the record of accred User
            Map<string, CSS_OEM_AFFILIATIONS__c> OEMAffMap = new Map<string, CSS_OEM_AFFILIATIONS__c>();
            
            list<CSS_OEM_AFFILIATIONS__c> lstOEMAff = [SELECT id,AFFILIATION__c,AFFILIATION_ROW_ID__c,LAST_UPDATED_BY__c,
                                                       LAST_UPDATED_DATE__c,PRIMARY__c, SP_CODE__c, SP_NAME__c, 
                                                       SpRowId__c, Account__c
                                                       //User_Login_ID__c,Passed_Date_SBL__c,ServiceModelName__c,,SMN_ROW_ID__c,CERT_PERCENTAGE__c
                                                       FROM CSS_OEM_AFFILIATIONS__c
                                                       WHERE AFFILIATION_ROW_ID__c IN : settechrowid ];
            if(lstOEMAff != null && lstOEMAff.size()>0){
                for(CSS_OEM_AFFILIATIONS__c oemaff : lstOEMAff)
                    OEMAffMap.put(oemaff.AFFILIATION_ROW_ID__c, oemaff);
            }
            
            //if(OEMAffMap != null && OEMAffMap.size() >0 ) 
            for(FSL_SPAffilations_Stage__c fslspAff : fslSPAffStageList){
                CSS_OEM_AFFILIATIONS__c oemaffRecord = OEMAffMap.get(fslspAff.AffiliationRowId__c);
                system.debug('oemaffRecord ' + oemaffRecord);
                //if(oemaffRecord != null) 
                CSS_OEM_AFFILIATIONS__c updatedoemaff = new CSS_OEM_AFFILIATIONS__c();
                
                updatedoemaff.AFFILIATION__c = fslspAff.Affiliation__c;
                updatedoemaff.LAST_UPDATED_BY__c = fslspAff.LastUpdated_By__c;
                updatedoemaff.PRIMARY__c = fslspAff.Primary__c;
                updatedoemaff.SP_CODE__c = fslspAff.SPCode__c;
                updatedoemaff.SpRowId__c = fslspAff.SPRowId__c;
                updatedoemaff.AFFILIATION_ROW_ID__c = fslspAff.AffiliationRowId__c;//External Id - unique Key
                if(oemaffRecord != null) 
                    updatedoemaff.Id = oemaffRecord.Id;
                if(fslspAff.LastUpdatedDate__c != null)
                    updatedoemaff.LAST_UPDATED_DATE__c = string.valueOf(fslspAff.LastUpdatedDate__c);
                if(fslspAff.SPCode__c != null && fslspAff.SPCode__c.trim() != '' && mapSpCodeAccountId.containskey(fslspAff.SPCode__c))
                    updatedoemaff.account__c = mapSpCodeAccountId.get(fslspAff.SPCode__c); //Map Account Id as lookup Id 
                
                if(!externalKeySet.contains(updatedoemaff.AFFILIATION_ROW_ID__c))
                	updatedOEMAffUser.add(updatedoemaff);
                externalKeySet.add(updatedoemaff.AFFILIATION_ROW_ID__c); 
                
                deleteSPAffStgList.add(fslspAff);
                system.debug('delete SPAffStgList ' + fslspAff);
                //} 
                /*else {
//fslspAff.FailureReason__c = 'Invalid Record';
updateSPAffStgList.add(fslspAff);
system.debug('update fslspAff ' + fslspAff);
}*/
            }
            //} 
            //
            /*else {
for(FSL_SPAffilations_Stage__c fslspAff : fslSPAffStageList){
//fslspAff.FailureReason__c = 'Invalid Record';
updateSPAffStgList.add(fslspAff);
system.debug('update fslspAff ' + fslspAff);
}
}*/
            
            //DML Operations.
            if(updatedOEMAffUser != null && updatedOEMAffUser.size() > 0)
                upsert updatedOEMAffUser AFFILIATION_ROW_ID__c;
            
            if(deleteSPAffStgList != null && deleteSPAffStgList.size() > 0)
                delete deleteSPAffStgList;
            
            //if(updateSPAffStgList != null && updateSPAffStgList.size() > 0)
            //update updateSPAffStgList;
            
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPInfo.getSPAffilationsData execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPInfo.getSPAffilationsData', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'getSPAffilationsData');
        }
    }
    
    public static void getSPProductRangeData(List<FSL_SPCertDetails_Stage__c> fslSPCertDetailsStageList){
        try {
            system.debug('fslSPCertDetailsStageList ' + fslSPCertDetailsStageList);
            list<FSL_SPCertDetails_Stage__c> updateCertDetailsStgList = new list<FSL_SPCertDetails_Stage__c>();
            list<FSL_SPCertDetails_Stage__c> deleteCertDetailsStgList = new list<FSL_SPCertDetails_Stage__c>();
            
            set<string> settechrowid= new set<string>(); //Used to query the Accred User
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            Map<string, list<FSL_SPCertDetails_Stage__c>> FSLSPCertStageMap = new Map<string, list<FSL_SPCertDetails_Stage__c>>();
            
            for(FSL_SPCertDetails_Stage__c spCertDetails : fslSPCertDetailsStageList){
                if(spCertDetails.SPCertRowId__c != null && spCertDetails.SPCertRowId__c != '')
                    settechrowid.add(spCertDetails.SPCertRowId__c);
                if(spCertDetails.SPCode__c != null && spCertDetails.SPCode__c != '')                    
                    setSpCodes.add(spCertDetails.SPCode__c); //building set of all spcode to fetch all accounts based on it 
                if(spCertDetails.SPCertRowId__c != null && spCertDetails.SPCertRowId__c != '' && 
                   spCertDetails.SPCode__c != null && spCertDetails.SPCode__c != '') {
                       string uniquekey = spCertDetails.SPCertRowId__c + ':' + spCertDetails.SPCode__c;
                       if(FSLSPCertStageMap.containsKey(uniquekey)){
                           List<FSL_SPCertDetails_Stage__c> stgList = FSLSPCertStageMap.get(uniquekey);
                           stgList.add(spCertDetails);
                           FSLSPCertStageMap.put(uniquekey, stgList);
                       } else {
                           FSLSPCertStageMap.put(uniquekey, new List<FSL_SPCertDetails_Stage__c> { spCertDetails });
                       }
                   }
            }
            system.debug('settechrowid ' + settechrowid);
            system.debug('setSpCodes ' + setSpCodes);
            system.debug('FSLSPCertStageMap ' + FSLSPCertStageMap);
            
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }    
            
            /*
List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
System.debug('accountList>>>:'+accountList);

if(accountList != null && accountList.size()>0){
for(Account acc:accountList)
mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);
}
system.debug('mapSpCodeAccountId ' + mapSpCodeAccountId);
*/
            
            list<CSS_Accreditation__c> updatedlstAccUser = new list<CSS_Accreditation__c>(); //Holds the record of accred User
            Map<string, CSS_Accreditation__c> lstAccUserMap = new Map<string, CSS_Accreditation__c>();
            
            list<CSS_Accreditation__c> lstAccredUser = [SELECT id,CERT_ROW_ID__c, Product_Details__c, account__c,SPCode__c
                                                        FROM CSS_Accreditation__c
                                                        WHERE CERT_ROW_ID__c IN : settechrowid OR 
                                                        SPCode__c IN : setSpCodes];
            if(lstAccredUser != null && lstAccredUser.size()>0){
                for(CSS_Accreditation__c accuser : lstAccredUser)
                    lstAccUserMap.put(accuser.CERT_ROW_ID__c + ':' + accuser.SPCode__c, accuser);
            }
            system.debug('lstAccUserMap ' + lstAccUserMap);
            
            if(lstAccUserMap != null && lstAccUserMap.size() >0 ) {
                for(string spCertDetails : FSLSPCertStageMap.keyset()){
                    CSS_Accreditation__c accuser = lstAccUserMap.get(spCertDetails);
                    system.debug('accuser ' + accuser);
                    
                    list<FSL_SPCertDetails_Stage__c> tempStgList = FSLSPCertStageMap.get(spCertDetails);
                    system.debug('tempStgList ' + tempStgList);
                    
                    if(accuser != null) {
                        CSS_Accreditation__c updatedaccuser = new CSS_Accreditation__c();
                        updatedaccuser.Id = accuser.Id;
                        
                        string FianlJSONValues = '';
                        //string jsonValues = '';
                        list<FSLProductRangeWrapper> stagingPRWrapperList = new list<FSLProductRangeWrapper>();
                        //set<string> uniqueKeySet = new set<string>();
                        map<string, FSLProductRangeWrapper> stagingPRWrapperMap = new map<string, FSLProductRangeWrapper>();
                        for(FSL_SPCertDetails_Stage__c validSTGList : tempStgList) {
                            string uniqueKey = validSTGList.ProductType__c + ':' + 
                                			validSTGList.ProductRange__c +':' + validSTGList.MarketApplication__c; 
                            if(!stagingPRWrapperMap.containskey(uniqueKey)) {
                            	FSLProductRangeWrapper prwrapper= new FSLProductRangeWrapper();
                                prwrapper.PRODUCT_TYPE = validSTGList.ProductType__c;
                                prwrapper.PRODUCT_RANGE = validSTGList.ProductRange__c; 
                                prwrapper.MARKET_APPLICATION = validSTGList.MarketApplication__c;
                                stagingPRWrapperMap.put(uniqueKey, prwrapper);
                                stagingPRWrapperList.add(prwrapper);
                                //uniqueKeySet.add(uniqueKey);  
                            }
                            /*jsonValues +='{' +
                                '\"PRODUCT_TYPE\": \"' + validSTGList.ProductType__c + '\",' +
                                '\"PRODUCT_RANGE\": \"' + validSTGList.ProductRange__c + '\",' +
                                '\"MARKET_APPLICATION\": \"' + validSTGList.MarketApplication__c + '\"' +
                                '},'; 
							*/
                        }
                        /*
                        system.debug('jsonValues ' + jsonValues);
                        if(jsonValues != null && jsonValues != '') {
                            jsonValues = jsonValues.substring(0, jsonValues.length()-1);
                        }
                        system.debug('jsonValues ' + jsonValues);
                        */
                        list<FSLProductRangeWrapper> existingPRWrapperList = new list<FSLProductRangeWrapper>();
                        if(accuser.Product_Details__c != null && accuser.Product_Details__c != '') {
                            existingPRWrapperList = (list<FSLProductRangeWrapper>) JSON.deserialize(accuser.Product_Details__c, list<FSLProductRangeWrapper>.class); 
                            set<string> uniqueKeyExistSet = new set<string>();
                            for(FSLProductRangeWrapper existing : existingPRWrapperList) {
                                uniqueKeyExistSet.add(existing.PRODUCT_TYPE + ':' + 
                                			existing.PRODUCT_RANGE +':' + existing.MARKET_APPLICATION);
                            }
                            
                            for(string stagingKey : stagingPRWrapperMap.keyset()) {
                                if(!uniqueKeyExistSet.contains(stagingKey)) {
                                    existingPRWrapperList.add(stagingPRWrapperMap.get(stagingKey));
                                }
                            }
                            FianlJSONValues = JSON.serialize(existingPRWrapperList);
                            /*string OldJSON = accuser.Product_Details__c;
                            if(OldJSON != null && OldJSON != '') {
                                OldJSON = OldJSON.substring(0, OldJSON.length()-1);
                            }
                            FianlJSONValues = OldJSON + ',' + jsonValues + ']';*/
                        } else {
                            FianlJSONValues = JSON.serialize(stagingPRWrapperList);
                            //FianlJSONValues = '[' + jsonValues + ']';
                        }
                        //string proddetails =
                        /*string json = '[' + 
'{' +
'\"PRODUCT_TYPE\": \"' + spCertDetails.ProductType__c + '\",' +
'\"PRODUCT_RANGE\": \"' + spCertDetails.ProductRange__c + '\",' +
'\"MARKET_APPLICATION\": \"' + spCertDetails.MarketApplication__c + '\"' +
'}' +
']';*/
                        system.debug('FianlJSONValues Fianl '+ FianlJSONValues);
                        updatedaccuser.Product_Details__c = FianlJSONValues;
                        updatedlstAccUser.add(updatedaccuser);
                        deleteCertDetailsStgList.addall(tempStgList);
                        system.debug('delete spCertDetails ' + tempStgList);
                    } else {
                        for(FSL_SPCertDetails_Stage__c invalidSTGList : tempStgList) {
                            invalidSTGList.FailureReason__c = 'Invalid Record';
                            updateCertDetailsStgList.add(invalidSTGList);
                            system.debug('update spCertDetails ' + invalidSTGList);
                        }                       
                    }
                }
            } else {
                for(FSL_SPCertDetails_Stage__c spCertDetails : fslSPCertDetailsStageList){
                    spCertDetails.FailureReason__c = 'Invalid Record';
                    updateCertDetailsStgList.add(spCertDetails);
                    system.debug('update spCertDetails ' + spCertDetails);
                }
            }
            
            //DML Operations.
            if(updatedlstAccUser != null && updatedlstAccUser.size() > 0)
                update updatedlstAccUser;
            
            if(deleteCertDetailsStgList != null && deleteCertDetailsStgList.size() > 0)
                delete deleteCertDetailsStgList;
            
            if(updateCertDetailsStgList != null && updateCertDetailsStgList.size() > 0)
                update updateCertDetailsStgList;         
            
        } catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPInfo.getSPProductRangeData execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            css_utility.LogOutIntError('FSLSPInfo.getSPProductRangeData', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'getSPProductRangeData');
        }
    }
    
    public static void getSPHeaderInfoData(List<FSL_SPHeader_Stage__c> FSLSPHeaderList){
        
        try
        {
            system.debug('FSLSPHeaderList ' + FSLSPHeaderList);
            list<FSL_SPHeader_Stage__c> updateSPHeaderStgList = new list<FSL_SPHeader_Stage__c>();
            list<FSL_SPHeader_Stage__c> deleteSPHeaderStgList = new list<FSL_SPHeader_Stage__c>();
            
            set<string> hqCodes = new set<String>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            Map<String,FSL_SPHeader_Stage__c> mapSpCodesDataArea = new Map<String,FSL_SPHeader_Stage__c>();
            for(FSL_SPHeader_Stage__c SPData : FSLSPHeaderList){
                if(SPData.SPCode__c !=null && SPData.SPCode__c.trim() !=''){
                    setSpCodes.add(SPData.SPCode__c);
                    mapSpCodesDataArea.put(SPData.SPCode__c,SPData);
                }
                if(SPData.DistHQCode__c !=null && SPData.DistHQCode__c.trim() !='')
                    hqCodes.add('%'+SPData.DistHQCode__c);
            }
            
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add(s);
                }
            }
            
            System.debug('setFormatedSpCodes>>>:'+setFormatedSpCodes);
            List<Account> accountHQList = new List<Account>([select Id,IAM_Service_Provider_Code__c,Location__c,CSS_DistributorCode__c  from Account where IAM_Service_Provider_Code__c IN :hqCodes ]);
            system.debug('accountHQList ' + accountHQList);
            Map<String, Id> hqAccountIds = new Map<String, Id>();
            Set<Id> accountIdSet = new Set<Id>();
            if(accountHQList !=null && accountHQList.size()>0){
                for(Account acc : accountHQList){
                    hqAccountIds.put(acc.IAM_Service_Provider_Code__c, acc.Id);
                    //hqAccountIds.put(acc.Location__c.right(5), acc.Id);
                }
            }
            
            //Query for existing accounts in DB to update the account related inforamtion from stage object.
            List<Account> accountListDB = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN :setFormatedSpCodes ]); 
            System.debug('accountListDB>>>:'+accountListDB);
            
            Map<string,account> accountListDBMap =  new map<string,account>();
            for(Account accnt : accountListDB){
                accountListDBMap.put(accnt.IAM_Service_Provider_Code__c, accnt);
            }
            
            System.debug('accountListDBMap>>>:'+accountListDBMap);
            List<Account> accountList = new List<Account>();
            //  Account acc;
            if(accountListDBMap!=null && accountListDBMap.size()>0){
                for(FSL_SPHeader_Stage__c SPHeaderdata : FSLSPHeaderList){
                    if(SPHeaderdata.WWSPSFlag__c =='Y'){
                        Account acct = accountListDBMap.get(SPHeaderdata.SPCode__c);
                        
                        if(acct!=null){
                            Account acc= new Account();
                            acc.id = acct.id;
                            //update Record Type as WWSPS
                            acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
                            //   acc.Name = SPHeaderdata.SpName;   //Anvesh commented as part of bulkAPI stories
                            acc.IAM_Service_Provider_Code__c = SPHeaderdata.SPCode__c; //Last 5 didit Location Code
                            acc.CSS_DBCode__c = SPHeaderdata.RespBranchCode__c; //First 5 digit Location Code
                            acc.CSS_DistributorCode__c = SPHeaderdata.DistHQCode__c;
                            acc.SP_ROW_ID__c = SPHeaderdata.SPRow_Id__c;
                            //  acc.RSS_RESP_BRANCH_CODE__c = SPHeaderdata.RssRespBranchCode;  //Anvesh commented as part of bulkAPI stories
                         //   acc.DIST_HQ_CODE__c = SPHeaderdata.DistHQCode__c; // Anvesh commented as per the discussion with satish no need to update DistHQCode__c field.
                            acc.CHANNEL_OF_DISTRIBUTION__c = SPHeaderdata.SPChannelOfDistribution__c;
                            acc.CHANNEL_CODE__c = SPHeaderdata.SPChannelCode__c;
                            acc.RSS_RESP_BRANCH_NAME__c = SPHeaderdata.RSSRespBranchName__c;
                            acc.RESP_BRANCH_NAME__c = SPHeaderdata.RespBranchName__c;
                            acc.BILL_TO_CODE__c = SPHeaderdata.SPBillToCode__c;
                            acc.BILL_TO_NAME__c = SPHeaderdata.SPBillToName__c;
                            acc.DIST_HQ_NAME__c = SPHeaderdata.DistHQName__c;
                            acc.Primary_Contact_FIRST_NAME__c = SPHeaderdata.SPFirstName__c;
                            acc.Primary_Contact_LAST_NAME__c = SPHeaderdata.SPLastName__c;
                            //  acc.Primary_Contact_PHONE__c = SPHeaderdata.SpPhone;   //Anvesh commented as part of bulkAPI stories
                            acc.Primary_Contact_EMAIL__c = SPHeaderdata.SPEmail__c;
                            acc.WWSPS_FLAG__c = SPHeaderdata.WWSPSFlag__c != null && SPHeaderdata.WWSPSFlag__c.trim() != '' && SPHeaderdata.WWSPSFlag__c.trim() == 'Y' ? true : false;
                            acc.CMI_Account_Status__c = SPHeaderdata.AccountStatus__c;
                            acc.BUSINESS_UNIT__c = SPHeaderdata.BusinessUnit__c;
                            acc.Territory_Code__c = (SPHeaderdata.TerritoryCode__c != null && SPHeaderdata.TerritoryCode__c != '') ? Integer.valueOf(SPHeaderdata.TerritoryCode__c) : 0;
                            acc.Region_Code__c = SPHeaderdata.RegionCode__c;
                            acc.Primary_OEM_Name__c = SPHeaderdata.PrimaryOEMName__c;
                            acc.Primary_OEM_Code__c = SPHeaderdata.PrimaryOEMCode__c;
                            acc.PSBU_Product_Certification__c = SPHeaderdata.PSBUProductCertification__c != null && SPHeaderdata.PSBUProductCertification__c.trim() != '' && SPHeaderdata.PSBUProductCertification__c.trim() == 'Y' ? true : false; 
                            acc.Repair_Level__c = SPHeaderdata.RepairLevel__c != null && SPHeaderdata.RepairLevel__c.trim() != '' && SPHeaderdata.RepairLevel__c.trim() == 'Y' ? true : false; 
                            acc.Cost_Effective_Exclusion__c = SPHeaderdata.CostEffectiveExclusion__c != null && SPHeaderdata.CostEffectiveExclusion__c.trim() != '' && SPHeaderdata.CostEffectiveExclusion__c.trim() == 'Y' ? true : false; 
                            acc.Freeze_Submit_Button__c = SPHeaderdata.FreezeSubmitButton__c != null && SPHeaderdata.FreezeSubmitButton__c.trim() != '' && SPHeaderdata.FreezeSubmitButton__c.trim() == 'Y' ? true : false; 
                            acc.Disable_Web_Access_Flag__c = SPHeaderdata.DisableWebAccessFlag__c != null && SPHeaderdata.DisableWebAccessFlag__c.trim() != '' && SPHeaderdata.DisableWebAccessFlag__c.trim() == 'Y' ? true : false; 
                            acc.Policy__c = SPHeaderdata.Policy__c != null && SPHeaderdata.Policy__c.trim() != '' && SPHeaderdata.Policy__c.trim() == 'Y' ? true : false; 
                            acc.Outfile_All_Claims__c = SPHeaderdata.OutFileAllClaims__c != null && SPHeaderdata.OutFileAllClaims__c.trim() != '' && SPHeaderdata.OutFileAllClaims__c.trim() == 'Y' ? true : false; 
                            acc.PMU_Split_Payment__c = SPHeaderdata.PMUSplitPayment__c != null && SPHeaderdata.PMUSplitPayment__c.trim() != '' && SPHeaderdata.PMUSplitPayment__c.trim() == 'Y' ? true : false; 
                            acc.DSID__c = SPHeaderdata.DSID__c != null && SPHeaderdata.DSID__c.trim() != '' && SPHeaderdata.DSID__c.trim() == 'Y' ? true : false; 
                            acc.DTNA__c = SPHeaderdata.DTNAFlag__c != null && SPHeaderdata.DTNAFlag__c.trim() != '' && SPHeaderdata.DTNAFlag__c.trim() == 'Y' ? true : false; 
                            acc.Paccar__c = SPHeaderdata.PACCAR__c != null && SPHeaderdata.PACCAR__c.trim() != '' && SPHeaderdata.PACCAR__c.trim() == 'Y' ? true : false; 
                            acc.New_OEM__c = SPHeaderdata.NewOEM__c != null && SPHeaderdata.NewOEM__c.trim() != '' && SPHeaderdata.NewOEM__c.trim() == 'Y' ? true : false; 
                            acc.View_Dollar_Amount__c = SPHeaderdata.ViewDollarAmount__c != null && SPHeaderdata.ViewDollarAmount__c.trim() != '' && SPHeaderdata.ViewDollarAmount__c.trim() == 'Y' ? true : false; 
                            acc.Tech_Actual_Hours_Required__c = SPHeaderdata.TechActualHoursRequired__c != null && SPHeaderdata.TechActualHoursRequired__c.trim() != '' && SPHeaderdata.TechActualHoursRequired__c.trim() == 'Y' ? true : false; 
                            acc.Group_Name__c = SPHeaderdata.GroupName__c;
                            acc.Claim_Allowed_Days__c =  SPHeaderdata.ClaimAllowedDays__c;
                            acc.CMI_SP_Expiration_Date__c = SPHeaderdata.CMISPExpirationDate__c!=null ? SPHeaderdata.CMISPExpirationDate__c : null;
                            acc.LTA_Flag__c = SPHeaderdata.LTAFlag__c != null && SPHeaderdata.LTAFlag__c.trim() != ''  && SPHeaderdata.LTAFlag__c.trim() =='Y' ? true : false;
                            acc.Warranty_Fax__c = SPHeaderdata.WarrantyFax__c;
                            //acc.Warranty_Email__c = SPHeaderdata.WarrantyEmail__c;
                            acc.Communication_Method__c = SPHeaderdata.CommunicationMethod__c;
                            acc.Communication_Occurrence__c = SPHeaderdata.CommunicationOccurrence__c;
                            acc.Max_Claim_Amt__c =SPHeaderdata.MaxClaimAmt__c;
                            acc.Cut_Off_Claim_Amt__c = SPHeaderdata.CutOffClaimAmt__c;
                            acc.SCM_Deductible__c = SPHeaderdata.SCMDeductible__c;
                            acc.SCM_Dollar_Amt__c = SPHeaderdata.SCMDollarAmt__c ;
                            acc.Promotion_Id_Flag__c = SPHeaderdata.PromotionIdFlag__c != null && SPHeaderdata.PromotionIdFlag__c.trim() != ''  && SPHeaderdata.PromotionIdFlag__c.trim() =='Y' ? true : false;
                            acc.Product_Certification__c = SPHeaderdata.ProductCertificationFlag__c != null && SPHeaderdata.ProductCertificationFlag__c.trim() != ''  && SPHeaderdata.ProductCertificationFlag__c.trim()=='Y' ? true : false;
                            acc.Warranty_Training_Status__c = SPHeaderdata.WarrantyTrainingStatus__c;
                            acc.Warranty_Training_Certification__c = SPHeaderdata.WrntyTrainingCertification__c != null && SPHeaderdata.WrntyTrainingCertification__c.trim() != ''  && SPHeaderdata.WrntyTrainingCertification__c.trim()=='Y' ? true : false;
                            acc.Territory__c = SPHeaderdata.Territory__c;
                            acc.Region__c = SPHeaderdata.Region__c;
                            acc.isCampTrp__c = SPHeaderdata.CampaignTRP__c;
                            
                            /* Anvesh commented below billing related fields because its directly updating from WWSPS systems 
//Mapping Physical Address Fields
if(SPHeaderdata.StreetAddress1__c != null && SPHeaderdata.StreetAddress1__c.trim() != '')
//Anvesh doubt acc.BillingStreet = SPHeaderdata.StreetAddress1__c;
if(SPHeaderdata.StreetAddress2__c != null && SPHeaderdata.StreetAddress2__c.trim() != ''){
if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
acc.BillingStreet = acc.BillingStreet+','+SPHeaderdata.StreetAddress2__c;
else
acc.BillingStreet = SPHeaderdata.StreetAddress2__c;
}
if(SPHeaderdata.StreetAddress3__c != null && SPHeaderdata.StreetAddress3__c.trim() != ''){
if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
acc.BillingStreet = acc.BillingStreet+','+SPHeaderdata.StreetAddress3__c;
else
acc.BillingStreet = SPHeaderdata.StreetAddress3__c;
}
if(SPHeaderdata.StreetAddress4__c != null && SPHeaderdata.StreetAddress4__c.trim() != ''){
if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
acc.BillingStreet = acc.BillingStreet+','+SPHeaderdata.StreetAddress4__c;
else
acc.BillingStreet = SPHeaderdata.StreetAddress4__c;
}
acc.BillingCity = SPHeaderdata.City__c;
acc.BillingStateCode = SPHeaderdata.State__c; //State Code assigning
if(SPHeaderdata.Country__c !=null && (SPHeaderdata.Country__c=='USA' || SPHeaderdata.Country__c=='United States'))
acc.BillingCountryCode = 'US'; //Country Code
else
acc.BillingCountryCode = SPHeaderdata.Country__c; //Country Code
acc.BillingPostalCode  = SPHeaderdata.ZipPostalCode__c;  */
                            
                            //Mapping Mailing Address Fields
                            if(SPHeaderdata.StreetAddress1__c != null && SPHeaderdata.StreetAddress1__c.trim() != '')
                                acc.ShippingStreet = SPHeaderdata.StreetAddress1__c;
                            if(SPHeaderdata.StreetAddress2__c != null && SPHeaderdata.StreetAddress2__c.trim() != ''){
                                if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                                    acc.ShippingStreet = acc.ShippingStreet+','+SPHeaderdata.StreetAddress2__c;
                                else
                                    acc.ShippingStreet = SPHeaderdata.StreetAddress2__c;
                            }
                            if(SPHeaderdata.StreetAddress3__c != null && SPHeaderdata.StreetAddress3__c.trim() != ''){
                                if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                                    acc.ShippingStreet = acc.ShippingStreet+','+SPHeaderdata.StreetAddress3__c;
                                else
                                    acc.ShippingStreet = SPHeaderdata.StreetAddress3__c;
                            }
                            if(SPHeaderdata.StreetAddress4__c != null && SPHeaderdata.StreetAddress4__c.trim() != ''){
                                if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                                    acc.ShippingStreet = acc.ShippingStreet+','+SPHeaderdata.StreetAddress4__c;
                                else
                                    acc.ShippingStreet = SPHeaderdata.StreetAddress4__c;
                            }
                            if(SPHeaderdata.City__c != null && SPHeaderdata.City__c != '') { 
                                if(SPHeaderdata.City__c.length() < 40) {
                                    acc.ShippingCity = SPHeaderdata.City__c;
                                } else {
                                    acc.ShippingCity = SPHeaderdata.City__c.trim().substring(0,39);
                                }
                            }
                            acc.ShippingStateCode = SPHeaderdata.State__c; //State Code assigning
                            
                            if(SPHeaderdata.Country__c !=null && (SPHeaderdata.Country__c == 'USA' || SPHeaderdata.Country__c == 'United States'))
                                acc.ShippingCountryCode = 'US'; //Country Code
                            else
                                acc.ShippingCountryCode = SPHeaderdata.Country__c; //Country Code
                            acc.ShippingPostalCode  = SPHeaderdata.ZipPostalCode__c; 
                            
                            try{
                                acc.CERTIFICATION_END_DATE__c = SPHeaderdata.CertificationEndDate__c!=null? SPHeaderdata.CertificationEndDate__c: null;
                            }catch(Exception ex){
                                System.debug('in catch of CERTIFICATION_END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                            try{
                                acc.RECERTIFICATION_DATE__c = SPHeaderdata.SPRecertificationDate__c!=null? SPHeaderdata.SPRecertificationDate__c: null;
                            }catch(Exception ex){
                                System.debug('in catch of RECERTIFICATION_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                            try{
                                acc.WWSPS_Account_Created_Date__c = SPHeaderdata.CreatedDate__c!=null? SPHeaderdata.CreatedDate__c: null;
                            }catch(Exception ex){
                                System.debug('in catch of SpCreatedDate convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                            
                            if(SPHeaderdata.DistHQCode__c !=null && SPHeaderdata.DistHQCode__c.trim() !='' && SPHeaderdata.DistHQCode__c != SPHeaderdata.SPCode__c && hqAccountIds.containsKey(SPHeaderdata.DistHQCode__c)){
                                acc.ParentId = hqAccountIds.get(SPHeaderdata.DistHQCode__c); //assigning ParentId Account lookup based on DIST_HQ_CODE__c
                                //acc.Account__c = hqAccountIds.get(SPHeaderdata.DistHqCode);  //assigning Account lookup based on DIST_HQ_CODE__c
                            }
                            //mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);  //adding account Ids based SP_CODE
                            // accountIdSet.add(acc.id);
                            
                            if(!accountList.contains(acc)){  // For avoiding duplicates
                                accountList.add(acc);
                            }
                            deleteSPHeaderStgList.add(SPHeaderdata);
                        }
                        else{
                            SPHeaderdata.FailureReason__c = 'Invalid Record';
                            updateSPHeaderStgList.add(SPHeaderdata);
                        }
                    }
                    else{
                         SPHeaderdata.FailureReason__c = 'Invalid Record';
                    updateSPHeaderStgList.add(SPHeaderdata);
                    }
                }
                System.debug('before update accountList.size()>>>:'+accountList.size());
                
            }
            else{
                for(FSL_SPHeader_Stage__c SPHeaderdata : FSLSPHeaderList){
                    SPHeaderdata.FailureReason__c = 'Invalid Record';
                    updateSPHeaderStgList.add(SPHeaderdata);
                }
            }
            
            system.debug('accountList>>>:'+accountList);
            system.debug('deleteSPHeaderStgList>>>:'+deleteSPHeaderStgList);
             system.debug('updateSPHeaderStgList>>>:'+updateSPHeaderStgList);
            system.debug('size of accountList>>>:'+accountList.size());
            system.debug('size of deleteSPHeaderStgList>>>:'+deleteSPHeaderStgList.size());
             system.debug('size of updateSPHeaderStgList>>>:'+updateSPHeaderStgList.size());
            
            
            
            if(accountList !=null && accountList.size()>0){
                update accountList;
                //upsert accountList IAM_Service_Provider_Code__c;  //upsert
            }
            
            if(deleteSPHeaderStgList!=null && deleteSPHeaderStgList.size()>0){
                delete deleteSPHeaderStgList;
            }
            
            if(updateSPHeaderStgList !=null && updateSPHeaderStgList.size()>0){
                update updateSPHeaderStgList;
                
            }
            
        }   
        catch(Exception e)  {
            system.debug('EXCEPTION of FSLSPInfo.getSPHeaderInfoData getMessage >>> '+e.getMessage() + ' getLineNumber  ' + e.getLineNumber() + ' getCause  ' +e.getCause());
            css_utility.LogOutIntError('FSLSPInfo.getSPHeaderInfoData', e.getLineNumber() + ' ' + e.getLineNumber(), 'BATCH Execution failed', 'getSPHeaderInfoData');
        }
        
    }
    
    public static void getSPCertificationData(List<FSL_SPCertifications_Stage__c> FSLSPCertList){
        
        system.debug('FSLSPCertList ' + FSLSPCertList);
        //  list<FSL_SPCertifications_Stage__c> updateSPCertStgList = new list<FSL_SPCertifications_Stage__c>();
        list<FSL_SPCertifications_Stage__c> deleteSPCertStgList = new list<FSL_SPCertifications_Stage__c>();
        
        List<Account> accountList;
        map<string,id> mapSpCodeAccountId = new map<string,id>();
        try{
            
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            //Get Account Ids to have master detail relation ship account to Accreditation__c
            for(FSL_SPCertifications_Stage__c spCert : FSLSPCertList){
                setSpCodes.add(spCert.SPCode__c); //building set of all spcode to fetch all accounts based on it 
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add(s);
                }
            }
            system.debug('setFormatedSpCodes ' + setFormatedSpCodes);
            accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.IAM_Service_Provider_Code__c, acc.id);
                //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
            }
            
            
            List<CSS_Accreditation__c> accredLstToInsert = new List<CSS_Accreditation__c>();
            CSS_Accreditation__c accred;
            for(FSL_SPCertifications_Stage__c spCert : FSLSPCertList){
                accred = new CSS_Accreditation__c();
                accred.SpCode__c = spCert.SPCode__c;
                accred.SpRowId__c = spCert.SPRowId__c;
                accred.isSMNAccountLevel__c = true; //why this is true always?
                accred.Service_Model_Name__c = spCert.SMN__c;
                accred.OEM_Name__c = spCert.OEM_Name__c;
                accred.OEM_Code__c = spCert.OEMCode__c;
                accred.SERVICE_LEVEL__c = spCert.ServiceLevel__c;
                if(spCert.SPCode__c != null && spCert.SPCode__c.trim() != '' && mapSpCodeAccountId.containskey(spCert.SPCode__c))
                    accred.Account__c = mapSpCodeAccountId.get(spCert.SPCode__c); // Kalpana: Should we do this? or mapping Account__c to da.Sprowid will do? Ans: Current statement is correct
                accred.CERT_ROW_ID__c = spCert.SPCertRowId__c;
                try{
                    accred.StartDate__c = spCert.StartDate__c != null ? spCert.StartDate__c : null;
                }catch(Exception ex){
                    System.debug('in catch of spcert.START_DATE convertion of  >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                try{
                    accred.EndDate__c = spCert.EndDate__c != null ? spCert.EndDate__c : null;
                }catch(Exception ex){
                    System.debug('in catch of spcert.END_DATE convertion of  >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                if(!accredLstToInsert.contains(accred)){
                    accredLstToInsert.add(accred);
                }
                
                deleteSPCertStgList.add(spCert);
            }
            system.debug('accredLstToInsert>>>:'+accredLstToInsert);
            system.debug('deleteSPCertStgList>>>:'+deleteSPCertStgList);
            if(accredLstToInsert != null && accredLstToInsert.size()>0)
                upsert accredLstToInsert CERT_ROW_ID__c;
            
            if(deleteSPCertStgList != null && deleteSPCertStgList.size()>0)
                delete deleteSPCertStgList;
        }
        catch(Exception ex){
            system.debug('EXCEPTION of FSLSPInfo.getSPCertificationData execute >>> '+ex.getMessage() + ' ex.getLineNumber ' + ex.getLineNumber() + ' ex.getCause ' +ex.getCause());
            css_utility.LogOutIntError('FSLSPInfo.getSPCertificationData', ex.getLineNumber() + ' ' + ex.getLineNumber(), 'BATCH Execution failed', 'getSPCertificationData');
        }
        
    }
    
    public static void getSPTechCertificationData(List<FSL_SPTechCert_Stage__c> fslSPTechCertList){
        system.debug('fslSPTechCertList ' + fslSPTechCertList);
        try{
            
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            for(FSL_SPTechCert_Stage__c spTechStage : fslSPTechCertList){
                setSpCodes.add(spTechStage.SPCode__c); //building set of all spcode to fetch all accounts based on it 
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add(s);
                }
            }
            system.debug('setFormatedSpCodes>>>:'+setFormatedSpCodes);
            List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c,IAM_Service_Provider_Code__c from Account where IAM_Service_Provider_Code__c IN :setFormatedSpCodes ]); //need to query all fields ???
            system.debug('accountList>>>:'+accountList);
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.IAM_Service_Provider_Code__c, acc.id);
                //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
            }
            
            list<FSL_SPTechCert_Stage__c> deleteSPTechStgList = new list<FSL_SPTechCert_Stage__c>();
            
            list<CSS_AccredUser__c> lstToUpsertAccredUser = new list<CSS_AccredUser__c>(); //Holds the list of Exsisting Accrediation user record.
            CSS_AccredUser__c accUsr;
            for(FSL_SPTechCert_Stage__c spTechCertStage : fslSPTechCertList){
                accUsr = new CSS_AccredUser__c();
                accUsr.SpCode__c = spTechCertStage.SPCode__c;
                accUsr.SP_ROW_ID__c = spTechCertStage.SPRowId__c;
                accUsr.TECH_ROW_ID__c = spTechCertStage.TechRowId__c;
                accUsr.ServiceModelName__c = spTechCertStage.ServiceModelName__c;
                accUsr.SMN_ROW_ID__c = spTechCertStage.SMNRowId__c;
                accUsr.CERT_PERCENTAGE__c = spTechCertStage.Certification__c != null ? spTechCertStage.Certification__c: 0.0;
                //accUsr.Accreditation__c = mapSMNtoAccreditation.get(da.SpCode+da.ServiceModelName).Id; Not Required .. making it lookup relationship from Master-DEtail. Only relation will be SMN
                if(spTechCertStage.SPCode__c != null && spTechCertStage.SPCode__c.trim() != '' && mapSpCodeAccountId.containskey(spTechCertStage.SPCode__c)) // Changed from Sprowid to spcode__c
                    accUsr.account__c = mapSpCodeAccountId.get(spTechCertStage.SPCode__c); //da.Sprowid; //This should be Account lookup Id
                
                accUsr.UniqueKey__c = spTechCertStage.SPRowId__c+spTechCertStage.SMNRowId__c+spTechCertStage.TechRowId__c;
                
                if(!lstToUpsertAccredUser.contains(accUsr)){
                    lstToUpsertAccredUser.add(accUsr); 
                } 
                deleteSPTechStgList.add(spTechCertStage);
            }
            
            system.debug('lstToUpsertAccredUser>>>:'+lstToUpsertAccredUser);
            system.debug('deleteSPTechStgList>>>:'+deleteSPTechStgList);
            
            system.debug('size of lstToUpsertAccredUser>>>:'+lstToUpsertAccredUser.size());
            system.debug('size of deleteSPTechStgList>>>:'+deleteSPTechStgList.size());
            
            if(lstToUpsertAccredUser != null && lstToUpsertAccredUser.size()>0){
                upsert lstToUpsertAccredUser UniqueKey__c;
            }
            
            if(deleteSPTechStgList != null && deleteSPTechStgList.size()>0){
                delete deleteSPTechStgList;
            }
            
        }catch(Exception ex){
            System.debug('in catch of insertSPTechnicianSMNData of CSS_FN_SIEBEL getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('insertSPTechnicianSMNData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }
    
}