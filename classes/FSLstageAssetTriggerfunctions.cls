/**************************************************************************************
Name: FSLstageAssetTriggerfunctions
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This Class is used to Get Engine data from the Siebel and MoveX through Mule connector.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              Related user stories
1.0      Ravikanth Macherla         06/10/2019        696, 697, 699, 700 ,
1.1      Harsha                     03/06/2020        Source -> BMS Condition
1.2      Bharat Reddy Gunreddy      04/08/2020        Added ERP Logic GFSLFM-2321
1.3      Rajashekar Nallapati       05/05/2020        Addded Logic for Asset uniqueness
1.4      Ravikanth Macherla         07/28/2020        US -CT2-44 and CT2-179
1.5      Dinesh Yadav               26/10/2021        ROAD-37, Update of NONCUMMINS Asset Make, Model feild values from MOVEX 
**************************************************************************************/

public with sharing class FSLstageAssetTriggerfunctions { 
    
    public static voId clonestagetoAsset(List<FSL_Stage_Asset__c> listStageAssets) {
        System.debug('listStageAssets' + listStageAssets);
        // List<Asset> listAsset = new List<Asset>();
        // Start try block for phoen-35
      try{
        Set<Id> setAssetIds = new Set<Id>();
        Set<string> setDeleteStageAssets = new Set<string>();
        Set<String> setContact = new Set<String>();
        Set<String> setSite = new Set<String>();
        Set<String> setCustomerCode = new Set<String>();
        Set<Id> setAccId = new Set<Id>();
        Set<String> setTypePSN = new Set<String>();
        Map<String, Id> mapCustomerAcc = new Map<String, Id>();
        // Map<String, Id> mapCustomerCon = new Map<String, Id>();
        // Map<String, Id> mapCustomerSite = new Map<String, Id>();
        Map<String, Asset> mapAssets = new Map<String, Asset>();
        map<string, string> mapStageAssetId = new Map<String, string>();
        map<string, FSL_Stage_Asset__c> mapStageAsset = new Map<String, FSL_Stage_Asset__c>();
        map<string, Account> mapAccount = new map<string, Account>();
        Map<Id, List<Contact>> mapContactsAccs = new Map<Id, List<Contact>>();
        Map<Id, List<Schema.Address>> mapSitesAccs = new Map<Id, List<Schema.Address>>();//CT2-416 
        Set<String> setEQId = new Set<String>();
        Set<String> setMMEnFC = new Set<String>();
        set<Id> setStageAssetId = new set<Id>();
        Map<String, CSS_Make_Model_Access__c> mapMakeModelEQId = new Map<String, CSS_Make_Model_Access__c>();
        Map<String, CSS_Make_Model_Access__c> mapMakeModelEnFC = new Map<String, CSS_Make_Model_Access__c>();
        
        for (FSL_Stage_Asset__c objstg : listStageAssets) {
            if(objstg.Customer_Code__c != null) {
                setCustomerCode.add(objstg.Customer_Code__c);
            }
            System.debug('setCustomerCode : ' + setCustomerCode);
            if(String.valueOf(objstg.MoveX_Contact_Id__c) != null) {
                setContact.add(String.valueOf(objstg.MoveX_Contact_Id__c ));
            }
            System.debug('setContact : ' + setContact);
            if(String.valueOf(objstg.MoveX_Site_Id__c) != null) {
                setSite.add(objstg.MoveX_Site_Id__c);
            }
            System.debug('setSite : ' + setSite);
           
             System.debug('PSN Stage' + objstg.Type_PSN_IIN__c);
            if(String.valueOf(objstg.Type_PSN_IIN__c) != null) {
                setTypePSN.add(objstg.Type_PSN_IIN__c);
            }
            System.debug('setTypePSN : ' + setTypePSN);
            
            if(string.valueOf(objstg.Equipment_Id__c) != null) {
                setEQId.add(objstg.Equipment_Id__c);
            }
            System.debug('setEQId : ' + setEQId);
            if(string.valueOf(objstg.Family_Code_Make_Model__c) != null) {
                setMMEnFC.add(objstg.Family_Code_Make_Model__c);
            }
            System.debug('setMMEnFC : ' + setMMEnFC);
            
            mapStageAssetId.put(objstg.Type_PSN_IIN__c, objstg.Id);  //PHOEN-35
            mapStageAsset.put(objstg.Type_PSN_IIN__c, objstg);       //PHOEN-112, Dinesh Yadav
            setStageAssetId.add(objstg.id);
        }
        
        if(setTypePSN != null && setTypePSN.size() > 0) {
            for(Asset objAssets : [SELECT Id, Application_Code__c, Type_PSN__c, Make__c, Model__c, Service_Model__c,Individual__c,    //Added Individual__c field in query for Phoen-111
                                   VIN__c, Engine_Family__c, Engine_Family_Code__c, Engine_Family_Name__c, 
                                   Equipment_Configuration__c,Engine_Manufacturer__c, Make_Model__c, Source__c,AccountId,
                                   Account.Name, Account.CMI_Account_Status__c, Account.FSL_ERP_Customer_Code__c
                                   FROM Asset 
                                   WHERE Type_PSN__c IN: setTypePSN]) {
                                       mapAssets.put(objAssets.Type_PSN__c, objAssets);
                                   }
            System.debug('mapAssets : ' + mapAssets);
            
            Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
            for(CSS_Make_Model_Access__c objmakeAcc : [SELECT Id, Access__c, EquipmentId__c, Make__c, Model__c, 
                                                       Family_Code_Make_Model__c, RecordTypeId 
                                                       FROM CSS_Make_Model_Access__c 
                                                       WHERE EquipmentId__c IN: setEQId 
                                                       AND RecordTypeId =: SRTRecordTypeId]) {
                                                           mapMakeModelEQId.put(objmakeAcc.EquipmentId__c, objmakeAcc);
                                                       }
            for(CSS_Make_Model_Access__c objmakeAcc : [SELECT Id, Access__c, EquipmentId__c, Make__c, Model__c, 
                                                       Family_Code_Make_Model__c, RecordTypeId 
                                                       FROM CSS_Make_Model_Access__c 
                                                       WHERE Family_Code_Make_Model__c IN: setMMEnFC 
                                                       AND RecordTypeId =: SRTRecordTypeId]) {
                                                           mapMakeModelEnFC.put(objmakeAcc.Family_Code_Make_Model__c, objmakeAcc);
                                                       }
        }
        
        List<Contact> listContacts = new List<Contact>();
        List<Schema.Address> listSites = new List<Schema.Address>();//CT2-416 
        /* Fetching Account Record Ids */
        Id guIdanzRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id guIdanzCashRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Id Asset_Detail_RecTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByName().get('FSL Detail Asset Record Type').getRecordTypeId();
        
        if(setCustomerCode != null && setCustomerCode.size() > 0) {//CT2-416 : inner query changed from IAM_CDH_Cross_references__r to Addresses__r
            for(Account objAcc : [SELECT Id, FSL_ERP_Customer_Code__c, FSL_Source_ERP__c, CMI_Account_Status__c, Name,
                                  (SELECT Id, FSL_Contact_Id__c, AccountId, IAM_Contact_source__c 
                                   FROM Contacts 
                                   WHERE FSL_Contact_Id__c IN: setContact 
                                   AND IAM_Contact_Status__c = 'Active'), 
                                  (SELECT Id, FSL_Site_ID__c, parent.FSL_Account__c 
                                   FROM Addresses__r 
                                   WHERE FSL_Site_ID__c IN: setSite 
                                   AND Status__c = 'Active') 
                                  FROM Account 
                                  WHERE FSL_ERP_Customer_Code__c IN : setCustomerCode 
                                  AND (RecordTypeId =: guIdanzRTId OR RecordTypeId =: guIdanzCashRTId)]) {
                                      System.debug('objAcc : '+objAcc);
                                      if(objAcc.CMI_Account_Status__c == 'Active'){
                                          mapCustomerAcc.put(objAcc.FSL_ERP_Customer_Code__c, objAcc.Id);
                                          listContacts.addall(objAcc.Contacts);
                                          listSites.addall(objAcc.Addresses__r);//CT2-416
                                      }
                                      
                                      //PHOEN-112, Dinesh Yadav
                                      mapAccount.put(objAcc.FSL_ERP_Customer_Code__c, objAcc);
                                  }
            System.debug('mapCustomerAcc : '+mapCustomerAcc);
            if(listContacts != null && listContacts.size() > 0) {
                for(Contact objCon : listContacts) {
                    if(!mapContactsAccs.containskey(objCon.AccountId)) {
                        mapContactsAccs.put(objCon.AccountId, new List<Contact> {objCon});
                    } else {
                        mapContactsAccs.get(objCon.AccountId).add(objCon);
                    }
                }
            }
            
            if(listSites != null && listSites.size() > 0) {//CT2-416
                for(Schema.Address objSite : listSites) {
                    if(!mapSitesAccs.containskey(objSite.parent.FSL_Account__c)) {
                        mapSitesAccs.put(objSite.parent.FSL_Account__c, new List<Schema.Address> {objSite});
                    } else {
                        mapSitesAccs.get(objSite.parent.FSL_Account__c).add(objSite);
                    }
                }
            }
        }
        
        for (FSL_Stage_Asset__c objstg : listStageAssets) {
            Asset objAsset;
            Asset objAset = new Asset();
            if(objstg.Type_PSN_IIN__c != null && objstg.Type_PSN_IIN__c != '' && mapAssets.containsKey(objstg.Type_PSN_IIN__c)) {
                objAsset = mapAssets.get(objstg.Type_PSN_IIN__c);
                System.debug('Existing Asset');
            }
            
            if(objAsset != null) {
                objAset = objAsset;
                
                // Added objAset.Engine_Manufacturer__c != 'CUMMINS', ROAD-37, Dinesh Yadav, 26 Oct 2021
                if(objstg.Manufacturer__c != null && objstg.Source__c != 'Siebel' && (objAset.Engine_Manufacturer__c != 'CUMMINS' || objAsset.Make__c == null || objAsset.Make__c == 'UNLISTED')) {
                    objAset.Make__c = objstg.Manufacturer__c;
                } else if(objstg.Manufacturer__c != null && objstg.Source__c == 'Siebel') {
                    objAset.Make__c = objstg.Manufacturer__c;
                }
                
                // Added objAset.Engine_Manufacturer__c != 'CUMMINS', ROAD-37, Dinesh Yadav, 26 Oct 2021
                if(objstg.Model__c != null && objstg.Source__c != 'Siebel' && (objAset.Engine_Manufacturer__c != 'CUMMINS' || objAsset.Model__c == null || objAsset.Model__c == 'ALL')) {
                    objAset.Model__c = objstg.Model__c;
                } else if(objstg.Model__c != null && objstg.Source__c == 'Siebel') {
                    objAset.Model__c = objstg.Model__c;
                }
                
                if(objstg.Service_Model_Name__c != null && objstg.Source__c != 'Siebel' && (objAsset.Service_Model__c == null || objAsset.Service_Model__c == 'NONCUMMINS')) {
                    objAset.Service_Model__c = objstg.Service_Model_Name__c;
                } else if(objstg.Service_Model_Name__c != null && objstg.Source__c == 'Siebel') {
                    objAset.Service_Model__c = objstg.Service_Model_Name__c;
                }
                if(objstg.VIN__c != null && objstg.Source__c != 'Siebel' && objAsset.VIN__c == null) {
                    objAset.VIN__c = objstg.VIN__c;
                } else if(objstg.VIN__c != null && objstg.Source__c == 'Siebel') {
                    objAset.VIN__c = objstg.VIN__c;
                }
                if(objstg.Engine_Family_Name__c != null && objstg.Source__c != 'Siebel') {
                    if((objstg.Engine_Family_Name__c).length() > 2 && objAsset.Engine_Family_Name__c == null) {
                        objAset.Engine_Family_Name__c = objstg.Engine_Family_Name__c;
                    } else if(objAsset.Engine_Family_Code__c == null) {
                        objAset.Engine_Family_Code__c = objstg.Engine_Family_Name__c;
                        objAset.Engine_Family__c = objstg.Engine_Family_Name__c;
                    }
                } else if(objstg.Engine_Family_Name__c != null && objstg.Source__c == 'Siebel') {
                    objAset.Engine_Family_Name__c = objstg.Engine_Family_Name__c;
                }
                if(objstg.Engine_Application_Code__c != null && objstg.Source__c != 'Siebel' && objAsset.Application_Code__c == null) {
                    objAset.Application_Code__c = objstg.Engine_Application_Code__c;
                }
                if(objstg.Unit_Type__c != null && objstg.Source__c != 'Siebel' && objAsset.Equipment_Configuration__c == null) {
                    objAset.Equipment_Configuration__c = objstg.Unit_Type__c;
                }
                if(!String.isBlank(objstg.Type__c) && objstg.Source__c != 'Siebel') {
                    objAset.Type__c = objstg.Type__c;
                }
                if(!String.isBlank(objstg.Source__c) && objstg.Source__c != 'Siebel') {
                    objAset.Source__c = objstg.Source__c;
                }
                if(objstg.IndivIdual__c != null) {
                    objAset.IndivIdual__c = objstg.IndivIdual__c;
                }
             /*   // Added by Ravikanth for US-CT2-44
                if(objstg.Engine_Manufacturer__c == Null && objstg.Source__c == 'Siebel'){
                    objAset.Engine_Manufacturer__c = 'CUMMINS';
                }
                if(objstg.Engine_Manufacturer__c == Null && objstg.Source__c != 'Siebel' && (objstg.Service_Model_Name__c == ' NONCUMMINS' || objstg.Service_Model_Name__c == 'NON CUMMINS') && (objstg.Engine_Family_Code__c == '99' || objstg.Engine_Family_Code__c == 'BB')){
                    objAset.Engine_Manufacturer__c = 'OTHER';
                }
                if(objstg.Engine_Manufacturer__c != Null){
                    objAset.Engine_Manufacturer__c = objstg.Engine_Manufacturer__c;
                } */
                //New update logic added by ravikanth for CT2-179
                if( objstg.Source__c != 'Siebel' && objstg.Engine_Manufacturer__c != NULL && objAset.Engine_Manufacturer__c != 'CUMMINS'){
                    
                    objAset.Engine_Manufacturer__c = objstg.Engine_Manufacturer__c;
                     
                }
                
                if( objstg.Source__c != 'Siebel' && objstg.Engine_Manufacturer__c == NULL && objAset.Engine_Manufacturer__c != 'CUMMINS'){
                    
                    objAset.Engine_Manufacturer__c = 'OTHER';
                    
                }
                
                //Ended here for US-CT2-179
                
            }
            else {
                objAset.RecordTypeId = Asset_Detail_RecTypeId;
                if(!String.isBlank(objstg.Name)) {
                    objAset.Name = objstg.Name;
                }
                if(!String.isBlank(objstg.Type__c)) {
                    objAset.Type__c = objstg.Type__c;
                }
              system.debug('check stg psn'+objstg.Type_PSN_IIN__c);
                if(objstg.IndivIdual__c != null && string.valueof(mapAssets.get(objstg.IndivIdual__c)) != objstg.IndivIdual__c) {   //Added for phoen-111
                    objAset.IndivIdual__c = objstg.IndivIdual__c;
                    if(objstg.Type_PSN__c != null && !mapAssets.containskey(objstg.Type_PSN__c)){
                        objAset.Type_PSN__c = objstg.Type_PSN_IIN__c;
                    }
                } else {
                   if(objstg.Type_PSN__c != null && !mapAssets.containskey(objstg.Type_PSN__c)){
                        objAset.Type_PSN__c = objstg.Type_PSN_IIN__c;
                    }else{
                        system.debug('Type PSN value already exists');
                    }
                }
                
                //PHOEN-134, Dinesh Yadav
                if(objAset.Type_PSN__c == null && objstg.Type_PSN_IIN__c != null){
                    objAset.Type_PSN__c = objstg.Type_PSN_IIN__c;
                }
                
                system.debug('check Asset Type PSN '+objAset.Type_PSN__c);
                if(!String.isBlank(objstg.Source__c)) {
                    objAset.Source__c = objstg.Source__c;
                }
                if(objstg.Manufacturer__c != null) {
                    objAset.Make__c = objstg.Manufacturer__c;
                }
                if(objstg.Model__c != null) {
                    objAset.Model__c = objstg.Model__c;
                }
                if(objstg.Service_Model_Name__c != null) {
                    objAset.Service_Model__c = objstg.Service_Model_Name__c;
                }
                if(objstg.VIN__c != null) {
                    objAset.VIN__c = objstg.VIN__c;
                }
                if(objstg.Engine_Family_Name__c!=null) {
                    if((objstg.Engine_Family_Name__c).length() > 2) {
                        objAset.Engine_Family_Name__c = objstg.Engine_Family_Name__c;
                    } else {
                        objAset.Engine_Family_Code__c = objstg.Engine_Family_Name__c;
                        objAset.Engine_Family__c = objstg.Engine_Family_Name__c;
                    } 
                }
                if(objstg.Engine_Application_Code__c != null && objstg.Source__c != 'Siebel') {
                    objAset.Application_Code__c = objstg.Engine_Application_Code__c;
                }
                if(!String.isBlank(objstg.Equipment_Configuration__c) && objstg.Source__c == 'Siebel') {
                    objAset.Equipment_Configuration__c = objstg.Equipment_Configuration__c;
                } else if(!String.isBlank(objstg.Unit_Type__c)) {
                    objAset.Equipment_Configuration__c = objstg.Unit_Type__c;
                }
                // Added by Ravikanth for US-CT2-44
              /*  if(objstg.Engine_Manufacturer__c == Null && objstg.Source__c == 'Siebel'){
                    objAset.Engine_Manufacturer__c = 'CUMMINS';
                }
                if(objstg.Engine_Manufacturer__c == Null && objstg.Source__c != 'Siebel' && (objstg.Service_Model_Name__c == ' NONCUMMINS' || objstg.Service_Model_Name__c == 'NON CUMMINS') && (objstg.Engine_Family_Code__c == '99' || objstg.Engine_Family_Code__c == 'BB')){
                    objAset.Engine_Manufacturer__c = 'OTHER';
                }
                if(objstg.Engine_Manufacturer__c != Null){
                    objAset.Engine_Manufacturer__c = objstg.Engine_Manufacturer__c;
                } */
                System.debug('Checking inside else'+objAset);
                 System.debug('Checking inside else'+objstg);
                //Ended here for US-CT2-44
                //Added new insert logic by ravikanth US CT2-179
                  if(objstg.Source__c == 'Siebel'){
                   objAset.Engine_Manufacturer__c = 'CUMMINS';
               }
             
               if(objstg.Engine_Manufacturer__c == Null && objstg.Source__c != 'Siebel'){
                   objAset.Engine_Manufacturer__c = 'OTHER';
                   }
                if(objstg.Engine_Manufacturer__c != Null && objstg.Source__c != 'Siebel'){
                    objAset.Engine_Manufacturer__c = objstg.Engine_Manufacturer__c;
                } 
            } //Ended here for US-CT2-179
            if(objstg.Source__c != null && objstg.Source__c == 'Siebel') {
                objAset.Engine_Family__c = objstg.Engine_Family_Code__c != null ? objstg.Engine_Family_Code__c : '';
                objAset.Engine_Family_Code__c = objstg.Engine_Family_Code__c != null ? objstg.Engine_Family_Code__c : '';
                objAset.Equipment_Id__c = !String.isBlank(objstg.Equipment_Id__c) ? objstg.Equipment_Id__c : '';
                objAset.Application_Code__c = objstg.Engine_Application_Code__c != null ? objstg.Engine_Application_Code__c : '';
                objAset.Application_Description__c = objstg.Engine_Application_Description__c != null ? objstg.Engine_Application_Description__c : '';
                objAset.Application__c = (objstg.Engine_Application_Code__c != null && objstg.Engine_Application_Description__c != null) ? objstg.Engine_Application_Code__c + ' - ' + objstg.Engine_Application_Description__c : '';
                objAset.Access_Code__c = !String.isBlank(objstg.Access_Code__c) ? objstg.Access_Code__c : '';
                objAset.Automotive_Application_Flag__c = !String.isBlank(objstg.Automotive_Application_Flag__c) ? objstg.Automotive_Application_Flag__c : '';
                if(objstg.BIS_Flag__c == TRUE) {
                    objAset.BIS_Flag__c = objstg.BIS_Flag__c;
                }
                if(objstg.Build_Date__c != null) {
                    objAset.Build_Date__c = objstg.Build_Date__c;
                }
                objAset.Critical_Part_List_Number__c = !String.isBlank(objstg.Critical_Part_List_Number__c) ? objstg.Critical_Part_List_Number__c : '';
                objAset.Design_Phase_Code__c = !String.isBlank(objstg.Design_Phase_Code__c) ? objstg.Design_Phase_Code__c : '';
                objAset.Engine_Bill_To_Code__c = !String.isBlank(objstg.Engine_Bill_To_Code__c) ? objstg.Engine_Bill_To_Code__c : '';
                if(objstg.ETO_Conversion_Date__c != null) {
                    objAset.ETO_Conversion_Date__c = objstg.ETO_Conversion_Date__c;
                }
                objAset.ETO_Old_PSN__c = !String.isBlank(objstg.ETO_Old_PSN__c) ? objstg.ETO_Old_PSN__c : '';
                objAset.Marine_Application_Flag__c = !String.isBlank(objstg.Marine_Application_Flag__c) ? objstg.Marine_Application_Flag__c : '';
                if(objstg.No_Warranty__c != null) {
                    objAset.No_Warranty__c = objstg.No_Warranty__c;
                }
                objAset.OEM_SP_Code__c = !String.isBlank(objstg.OEM_SP_Code__c) ? objstg.OEM_SP_Code__c : '';
                if(objstg.Paccar_Flag__c == TRUE) {
                    objAset.Paccar_Flag__c = objstg.Paccar_Flag__c;
                }
                objAset.Product_Application_Code__c = !String.isBlank(objstg.Product_Application_Code__c) ? objstg.Product_Application_Code__c : '';
                objAset.Product_Application_Description__c = !String.isBlank(objstg.Product_Application_Description__c) ? objstg.Product_Application_Description__c : '';
                if(objstg.Recon_Engine_Flag__c == TRUE) {
                    objAset.Recon_Engine_Flag__c = objstg.Recon_Engine_Flag__c;
                }
                if(objstg.Ship_Date__c != null) {
                    objAset.Ship_Date__c = objstg.Ship_Date__c;
                }
                if(objstg.Warranty_Start_Date__c != null) {
                    objAset.Warranty_Start_Date__c = objstg.Warranty_Start_Date__c;
                }
                
                if(string.valueOf(objstg.Equipment_Id__c) != null) {
                    if(mapMakeModelEQId != null && mapMakeModelEQId.containskey(objstg.Equipment_Id__c)) {
                        objAset.Make_Model__c = mapMakeModelEQId.get(objstg.Equipment_Id__c).Id;
                    }
                } else if(string.valueOf(objstg.Family_Code_Make_Model__c) != null) {
                    if(mapMakeModelEnFC != null && mapMakeModelEnFC.containskey(objstg.Family_Code_Make_Model__c)) {
                        objAset.Make_Model__c = mapMakeModelEnFC.get(objstg.Family_Code_Make_Model__c).Id;
                    }
                }
                System.debug('checking Siebel');
            }
            else {
                objAset.Customer_Name__c = !String.isBlank(objstg.Customer_Name__c) ? objstg.Customer_Name__c : '';
                objAset.Contact_Name__c = !String.isBlank(objstg.Contact_Name__c) ? objstg.Contact_Name__c : '';
                objAset.Owner_Name__c = !String.isBlank(objstg.Owner_Name__c) ? objstg.Owner_Name__c : '';
                objAset.Registration__c = !String.isBlank(objstg.Registration__c) ? objstg.Registration__c : '';
                objAset.Sales_Segment__c = !String.isBlank(objstg.Sales_Segment__c) ? objstg.Sales_Segment__c : '';
                objAset.Unit_Number__c = !String.isBlank(objstg.Unit_Number__c) ? objstg.Unit_Number__c : '';
                if(objstg.Cash_Customer_Flag__c == 'Y') {
                    objAset.Cash_Customer_Flag__c = TRUE;
                } else if(objstg.Cash_Customer_Flag__c == 'N') {
                    objAset.Cash_Customer_Flag__c = FALSE;
                }
                objAset.Address_Line1__c = objstg.Address_Line1__c;
                objAset.City__c = objstg.City__c;
                objAset.State__c = objstg.State__c;
                objAset.MoveX_Customer_Address_1__c = objstg.Customer_Address_1__c;
                objAset.MoveX_Customer_Address_2__c = objstg.Customer_Address_2__c;
                objAset.MoveX_Customer_Address_3__c = objstg.Customer_Address_3__c;
                objAset.MoveX_Phone_Number__c = objstg.Phone_Number__c;
                objAset.MoveX_Email_Id__c = objstg.Email_Id__c;
                objAset.MoveX_ContactId__c = String.valueof(objstg.MoveX_Contact_Id__c);
                objAset.MoveX_SiteId__c = String.valueof(objstg.MoveX_Site_Id__c);
                objAset.Customer_Code__c = objstg.Customer_Code__c;
                System.debug('checking Siebel else');
            }
            if(mapCustomerAcc != null && mapCustomerAcc.containskey(objstg.Customer_Code__c)) {
                objAset.AccountId = mapCustomerAcc.get(objstg.Customer_Code__c);
                system.debug('Account Id**'+objAset.AccountId);
                List<Contact> objCon = new List<Contact>();
                if(mapContactsAccs.containsKey(objAset.AccountId)) {
                    objCon = mapContactsAccs.get(objAset.AccountId);
                }
                if(!objCon.isEmpty()) {
                    for(Contact conMXId : objCon) {
                        if(conMxId.FSL_Contact_Id__c == objstg.MoveX_Contact_Id__c) {
                            objAset.ContactId = conMxId.Id;
                            system.debug('Contact Id**' + objAset.ContactId);
                            Break;
                        }
                    }
                } else {
                    objAset.ContactId = null;
                }
                List<Schema.Address>  objSite = new List<Schema.Address>();//CT2-416
                if(mapSitesAccs.containsKey(objAset.AccountId)) {
                    objSite = mapSitesAccs.get(objAset.AccountId); 
                }
                if(!objSite.isEmpty()) {//CT2-416
                    for(Schema.Address siteMXId : objSite) {
                        //|| objstg.Customer_Code__c == siteMXId.parent.FSL_Account__c, removed. 
                        if(siteMXId.FSL_Site_ID__c == objstg.MoveX_Site_Id__c ) {   //Added for Phoen-111
                            objAset.FSL_Site__c = siteMXId.Id;
                            system.debug('Site Id**' + objAset.FSL_Site__c);
                            Break;
                        }
                    }
                } else {
                    objAset.FSL_Site__c = null; //CT2-416
                }
                System.debug('Inside customer acc');
            }
            
            //PHOEN-110, Dinesh Yadav
            if(!String.isBlank(objstg.Status__c)) {
                objAset.Status = objstg.Status__c;
            }
            mapAssets.put(objAset.Type_PSN__c, objAset);
            // listAsset.add(objAset);
        }
        System.debug('mapAssets: ' + mapAssets.values());
        
        /*for (Database.upsertResult result : upsertResults) {
            if (result.isSuccess()) {
                // Operation was successful, so get the Id of the record that was processed into Sucess record Id set
                setAssetIds.add(result.getId());
                System.debug('Successfully upserted Asset, AssetId: ' + result.getId());
            } else{
                // Operation failed, so get all errors
                for(Database.Error err : result.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Asset fields that affected this error: ' + err.getFields());
                    //Phoen-35 code change starts
                    errDescMap.put(result.getId(),err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
          */
          
        List<FSL_Stage_Asset__c> updStageAssetErr = new List<FSL_Stage_Asset__c>();    //Added for phoen-35
        map<string, string> mapTypePSNToError = new map<string, string>();
        List<Asset> lstAssetUpsert = mapAssets.values();
        List<Database.upsertResult> upsertResults = Database.upsert(lstAssetUpsert, Asset.Type_PSN__c, false);
        map<string,string> errDescMap = new map<string,string> ();  
        for(Integer index = 0, size = upsertResults.size(); index < size; index++) {
            if(upsertResults[index].isSuccess()) {
                // Operation was successful, so get the Id of the record that was processed into Sucess record Id set
                setAssetIds.add(upsertResults[index].getId());
                System.debug('Successfully upserted Asset, AssetId: ' + upsertResults[index].getId());
            }
            else{
                set<id> setStageAssetIdDuplCheck = new set<id>(); //to prevent duplicate list error.
                // Operation failed, so get all errors
                for(Database.Error err : upsertResults[index].getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Asset fields that affected this error: ' + err.getFields());
                    //Phoen-35 code change starts
                    string strErr = err.getStatusCode() +'\n'+ err.getFields() + '\n' + err.getMessage()+'\n'+'Asset Id:: '+upsertResults[index].getId();
                    system.debug('strErr :: '+strErr);
                    mapTypePSNToError.put(lstAssetUpsert[index].Type_PSN__c,strErr);
                    system.debug('mapTypePSNToError :: '+mapTypePSNToError);
                    
                    /* //PHOEN-112, Dinesh Yadav */
                    if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION){
                        system.debug('In Status Code Check :: Check Stage Asset:: '+ mapStageAsset.get(lstAssetUpsert[index].Type_PSN__c));
                        if(err.getFields() != null && err.getFields().contains('AccountId')){
                            strErr = 'ASSET update failed because related account is inactive. Details are: \n';
                            system.debug('In Error Field Check');
                            if(mapStageAsset.get(lstAssetUpsert[index].Type_PSN__c) != null){
                                FSL_Stage_Asset__c objSTAGEASSET = mapStageAsset.get(lstAssetUpsert[index].Type_PSN__c);                                
                                if(objSTAGEASSET.Customer_Code__c != null && mapAccount.get(objSTAGEASSET.Customer_Code__c) != null){
                                    Account objAccount = mapAccount.get(objSTAGEASSET.Customer_Code__c);
                                    strErr = strErr + 'New Account Name(recieved in api) : '+ objAccount.Name +'\n';
                                    strErr = strErr + 'ERP Customer Code : '+ objAccount.FSL_ERP_Customer_Code__c +'\n';
                                }   
                                
                                if(mapAssets.get(lstAssetUpsert[index].Type_PSN__c) != null){
                                    Asset objAssetForErr = mapAssets.get(lstAssetUpsert[index].Type_PSN__c);
                                    strErr = strErr + 'Existing Account Name on Asset : '+ objAssetForErr.Account.Name +'\n';
                                    strErr = strErr + 'ERP Customer Code : '+ objAssetForErr.Account.FSL_ERP_Customer_Code__c +'\n';
                                }
                                
                            }
                        }
                        
                    }
                    
                    /* commented because of 'Record is read only' error. */
                    if(!setStageAssetIdDuplCheck.contains(mapStageAssetId.get(lstAssetUpsert[index].Type_PSN__c))){
                        FSL_Stage_Asset__c objStageAssetErr = new FSL_Stage_Asset__c(Id=mapStageAssetId.get(lstAssetUpsert[index].Type_PSN__c));
                        objStageAssetErr.Error_Description__c = strErr;
                        updStageAssetErr.add(objStageAssetErr);
                        setStageAssetIdDuplCheck.add(mapStageAssetId.get(lstAssetUpsert[index].Type_PSN__c));
                    }
                    
                    string strErrorStatusCode = string.valueOf(err.getStatusCode());
                    if(strErrorStatusCode.contains('DUPLICATE_')){
                        setDeleteStageAssets.add(lstAssetUpsert[index].Type_PSN__c);
                    }
                }
            }
        }
        
        system.debug('updStageAssetErr '+updStageAssetErr);
        if(updStageAssetErr != null && updStageAssetErr.size() > 0){
            update updStageAssetErr;
        }
        //Phoen-35 code change Ends
      
        if(setAssetIds.size() > 0) {
            for(Asset objas : [SELECT Id, Type_PSN__c 
                               FROM Asset 
                               WHERE Id IN:setAssetIds]) {
                                   setDeleteStageAssets.add(objas.Type_PSN__c);
                               }
        }
        
        system.debug('setDeleteStageAssets :: '+setDeleteStageAssets);
        if(setDeleteStageAssets.size() > 0) {
            DELETE [SELECT Id, Type_PSN__c 
                    FROM FSL_Stage_Asset__c 
                    WHERE (Type_PSN__c IN :setDeleteStageAssets OR Type_PSN_IIN__c IN :setDeleteStageAssets) 
                    and Id in :setStageAssetId]; //Added OR Type_PSN_IIN__c IN :setDeleteStageAssets //phoen-39, dinesh yadav
        }
    } //End try block for phoen-35
        //Start catch block for phoen-35
        catch(Exception e){
            system.debug('Error code==>'+e.getLineNumber()+' <===Error==>'+e.getMessage());
        }
        //End catch block for phoen-35
    }
}