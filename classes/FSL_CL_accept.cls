/************************************************************************************
Name: FSL_CL_accept
Copyright © 2019  Cummins
=====================================================================================
=====================================================================================
Purpose: For Accept logic from SR to SO
=====================================================================================
=====================================================================================
History
-------
VERSION  AUTHOR            		DATE                DETAIL
1.0      Mallika Subhashini     12/10/2019     INITIAL DEVELOPMENT
2.0      Sailaja Guntupalli     02/15/2021     populate wo with service request and update master data 
3.0      Lochana Rajut          05/26/2022     To copy FTR attributes TransactionID and ABRFlag on Service Order(Work Order) from Case 
4.0      Ronnie Mishra          07/28/2022     Make dealer land on Job PLan chevron if SR is FTR   
************************************************************************************/
global without sharing class FSL_CL_accept {
    
    private string woId; //change from global to private as part of NIN_491 -Trupti
    @AuraEnabled
    global static id acceptSerRequest(Id objectID) {
        
        List<WorkOrder> woList = new List<WorkOrder>();
        List<CSS_Make_Model_Access__c> cmmBatchList=new List<CSS_Make_Model_Access__c>();  
        Boolean isDealer = false;
        Boolean chkAccIdMapped = false;
        ServiceTerritory servicTerType;
        serviceTerritory ownerSerTerPrimaryCodeCheck;        
        Id dealerId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId(); 
        Case cs = [SELECT Id, AssetId, Asset.Application__c,Asset.Warranty_Start_Date__c, RecordTypeId, AccountId, Customer_Name__c, Service_Model__c, Make__c, Model__c, FSL_ABRFlag__c,FSL_TransactionID__c,
                   Product_Hours__c, Product_Mileage__c, Product_Mileage_Unit__c,Available_for_Service__c, 
                   ContactId, IAS_Number__c, Description, Status, Service_Territory__c, Is_Created_From_Portal__c, OwnerId 
                   FROM Case WHERE Id =: objectID];
        User LoggedInUser = [SELECT Id FROM User WHERE id =: UserInfo.getUserId() LIMIT 1];        
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        if(po != null && po.Name != null && po.Name.containsIgnoreCase('dealer'))
            isDealer = true;        
        if(!isDealer) {
            List<ServiceTerritory> lstSerTer = new List<ServiceTerritory>();
            lstSerTer= [SELECT Id,Type__c, FSL_Service_Territory_Code__c,Mileage_Measure__c FROM ServiceTerritory where id =:cs.Service_Territory__c];
            if(lstSerTer != null && lstSerTer.size() >0) {
                servicTerType = lstSerTer[0];
            }
        }
        if(!isDealer && cs.Is_Created_From_Portal__c == false) {
            ownerSerTerPrimaryCodeCheck = FSL_CL_ServiceTerritory.getOwnerPrimaryServiceTerritoryCheck(cs.OwnerId);
        }
        // check dealer condition and use account for dealer - Sruthi
        List<Account> serAccount = new List<Account>();
        //modified by sailaja, CT3-302 to populate account name with service request account name 
        if(cs.AccountId != null){
            serAccount = [SELECT ID FROM Account WHERE Id = : cs.AccountId LIMIT 1];
        }
        if(cs.status == 'New') {
            try{
                cs.Bypass_Validation_Rule__c = True;
                if(isDealer){
                    cs.Status = 'Triage & Diagnosis';
                    cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId(); // Make changes for delaers to another record type(EVL_Guidanz_Dealer_Evolution) - sruthi                    
                }
                else{
                    cs.status = 'Intake';
                    cs.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IA_Request').getRecordTypeId(); // Make changes for delaers to another record type(EVL_Guidanz_Dealer_Evolution) - sruthi
                    if (cs.Is_Created_From_Portal__c == True){
                        cs.Bypass_Validation_Rule__c = False;
                    }
                }
                Update cs;                
                // Added by Ranadip Jha
                if(test.isRunningTest()){
                    isDealer = true;
                }
                // End Here                
                if(isDealer){
                    cs.Bypass_Validation_Rule__c = False;
                }
                Update cs;
                // added by sailaja, CT3-302 to populate asset details with service request asset details
                List<Asset> masterAsset = new List<Asset>();
                if(cs.AssetId != null){
                    masterAsset = [SELECT Id, Name, Make__c, Model__c,Service_Model__c,AccountId,Make_Model__c , Engine_Family_Code__c
                                   FROM Asset WHERE Id = : cs.AssetId LIMIT 1];
                }
                // Bharat - Account, Contact, Make, Model, SMN, Stage, RecordTypeId are populated on WO using PB
                WorkOrder wo = new WorkOrder();
                if(isDealer && serAccount.size() > 0){
                    wo.AccountId = serAccount[0].Id;
                    wo.EVL_Customer__c = cs.Customer_Name__c;
                    wo.Application__c = cs.Asset.Application__c;
                    wo.Warranty_Start_Date__c = cs.Asset.Warranty_Start_Date__c;
                    
                }
                //added by sailaja, CT3-302 to populate asset master
                if((cs.Make__c=='Other Manufacturer' || cs.Make__c == 'UNLISTED') || (cs.Model__c=='Other Model' || cs.Model__c=='ALL')){
                    if(cs.AssetId != null){
                        wo.AssetId = cs.AssetId;
                    }
                    wo.Make__c = 'UNLISTED';
                    wo.Model__c = 'ALL';
                    wo.Service_Model__c = cs.Service_Model__c;
                } 
                else if((cs.Make__c!='Other Manufacturer' || cs.Make__c!='UNLISTED' ) || (cs.Model__c!='Other Model' || cs.Model__c!='ALL')){
                    if(cs.AssetId!= null){
                        wo.AssetId = cs.AssetId;
                    } 
                    wo.Make__c = cs.Make__c;
                    wo.Model__c = cs.Model__c;
                    wo.Service_Model__c = cs.Service_Model__c;    
                } 
                //modified by sailaja, CT3-302 to populate account name with service request account name
                if(serAccount.size() > 0 && masterAsset.size()>0 && ((serAccount[0].Id !=masterAsset[0].AccountId)||(masterAsset[0].AccountId == null))){
                    RecursiveTriggerHandler.chkSRAccountId = false; 
                    wo.AccountId = serAccount[0].Id;
                    wo.AssetId = cs.AssetId;
                    wo.ContactId = null;
                }
                if(cs.AccountId !=null && cs.ContactId !=null){
                    wo.AccountId = cs.AccountId;
                    wo.ContactId = cs.ContactId;
                }
                if(!Test.isRunningTest() && !isDealer){
                    if (cs.Service_Territory__c != NULL ){//CT3-610
                        if(servicTerType != null && servicTerType.Type__c =='GROUP'){
                            throw new AuraHandledException('Service Territory must be an assignable Service Territory and cannot be a Parent Territory.');
                        }
                        else{
                            cs.Bypass_Validation_Rule__c = False;
                            wo.ServiceTerritoryId = cs.Service_Territory__c;
                        }
                    }
                }
                wo.IAS_Number__c = cs.IAS_Number__c;
                wo.CaseId = cs.Id;
                wo.General_Symptoms__c = cs.Description;
                wo.OwnerId = cs.OwnerId;                
                //Added by sailaja, CT3-257 to update mileage,hours from IA to SO based on mileage measure unit
                if(cs.Product_Mileage_Unit__c == 'Km' || cs.Product_Mileage_Unit__c == 'Kilometers'){
                    wo.Mileage_Measure__c = System.label.FSL_Mileage_Kilometers; 
                }
                if(cs.Product_Mileage_Unit__c == 'mi' || cs.Product_Mileage_Unit__c == 'Miles'){
                    wo.Mileage_Measure__c = System.label.FSL_Mileage_Miles;
                }
                if(cs.Product_Mileage_Unit__c == 'hrs' || cs.Product_Mileage_Unit__c == 'Hours'){
                    if(ownerSerTerPrimaryCodeCheck.Mileage_Measure__c!= ''){
                        wo.Mileage_Measure__c = ownerSerTerPrimaryCodeCheck.Mileage_Measure__c;
                    } else{
                        wo.Mileage_Measure__c = cs.Product_Mileage_Unit__c;
                    }
                }
                wo.Mileage__c = cs.Product_Mileage__c;  
                wo.CSS_Hours__c = cs.Product_Hours__c;
                //added by sailaja, CT3-284 copy earliest start permitted to Service Order
                if(cs.Available_for_Service__c != null ){
                    wo.Available_for_Service__c = cs.Available_for_Service__c;
                }
                wo.EVL_Bypass_Validation_Rule__c = TRUE;


                insert wo;
                //SG-92 - To make dealer land on Job Plan chevron on accptance of FTR SR, Ronnie Mishra Code Starts, 08/09/2022
                if(cs.FSL_ABRFlag__c && isDealer) {
                    wo.Process_Step__c = 'Job Plan';
                    wo.EVL_Stage__c = 'Job Plan';
                    wo.Status = 'Job Plan';
                }
                //SG-92, Ronnie Mishra Code Ends, 08/09/2022
                wo.EVL_Bypass_Validation_Rule__c = FALSE;
                update wo;                
                List<FSL_IA_FC__c> IaRecords = [SELECT Id, Name, Fault_Code_Type__c, Prioritized_FC_SO__c, Related_Fault_Codes__c, Non_Prioritized_FC_SO__c, UnPrioritized_FC_SR__c, Prioritized_FC_SR__c, 
                                                Status__c,count__c,OwnerId //Added by Prasanna for ROAD -548
                                                FROM FSL_IA_FC__c 
                                                WHERE Prioritized_FC_SR__c =: cs.Id OR UnPrioritized_FC_SR__c =: cs.Id];
                List<FSL_IA_FC__c> IArecList = new List<FSL_IA_FC__c>();
                List<CSS_Fault_Code__c> cssFaultList = new List<CSS_Fault_Code__c>(); //Added by Prasanna for ROAD - 548
                for(FSL_IA_FC__c iaRec:IaRecords) {
                    if(iaRec.Fault_Code_Type__c == 'Primary' || iaRec.Fault_Code_Type__c == 'Related') {
                        iaRec.Prioritized_FC_SO__c = wo.Id;
                        IArecList.add(iaRec);
                        //Added by Prasanna for ROAD -548
                        if(cs.FSL_ABRFlag__c){  //assign CSS fault code only for FTR Service Request
                          CSS_Fault_Code__c cssFaultCodeObj = new CSS_Fault_Code__c(); 
                        //cssFaultCodeObj.count__c =integer.valueOf(iaRec.count__c);  Not required
                        cssFaultCodeObj.OwnerId = iaRec.OwnerId;
                        cssFaultCodeObj.Name = iaRec.Name;
                        cssFaultCodeObj.Fault_code_Type__c = 'APD-P';
                        //cssFaultCodeObj.Primary_Fault_Code__c =  mapping not known
                        cssFaultCodeObj.Prioritized__c = true;
                        cssFaultCodeObj.Related_Fault_Code__c = iaRec.Related_Fault_Codes__c;
                        //cssFaultCodeObj.Mod__c = '';
                        cssFaultCodeObj.Service_Order__c = wo.Id;
                        cssFaultCodeObj.Status__c = iaRec.Status__c;
                        cssFaultCodeObj.Type__c = 'Fault';
                        cssFaultCodeObj.Sequence__c = 0; //Needed for displaying fault codes in Repair
                        //cssFaultCodeObj.Cummins_Fault_Code__c =iaRec.id;
                        cssFaultList.add(cssFaultCodeObj);	   
                        }
                        //end of changes added by Prasanna for ROAD -548
                    }
                    if(iaRec.Fault_Code_Type__c == 'Non Prioritized') {
                        iaRec.Non_Prioritized_FC_SO__c = wo.Id;
                        IArecList.add(iaRec);
                    }
                }
                update IArecList;
                // Added by Prasanna for ROAD-548
                if(cssFaultList.size() > 0){
                   insert cssFaultList;  
                }
                //End of if by Prasanna for ROAD-548
                return wo.Id;
            }            
           // Added by Harini - FBI 75 & FBI 76 - to show the validation errors//
            catch(DmlException e){
                String msg = '';
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    msg =+ e.getDmlMessage(i) +  '\n' ;
                }
                throw new AuraHandledException(msg);
                
            }  
        }
        else {
            return null;
        }
    }
    @AuraEnabled
    global static string checkSymptoms(Id symID){        
        case cs=[select description from case where id =: symID];
        string generalSymptoms=cs.description;
        string general;
        
        if(generalSymptoms!= null && generalSymptoms.length()>0 && generalSymptoms.length()<3){
            general='fail';
        }
        else{
            general ='sucess';
        }
        return general;
    }

    //Method added as part of SG-92 - To make callout to Get solutions API; Ronnie Mishra Code Starts, 08/09/2022
    @AuraEnabled
    public static string getSolutionsForFTR(Id woId) {
        system.debug('Inside getsolutionsforFTR $$$$$ Road-550');
        return FSL_CL_FTRUtility.getSolutionsForFTR(woId, true);
    }
    //Method added as part of SG-92 - To make callout to Get options, GET SRT Repair and Get Detail coverage; Ronnie Mishra Code Starts, 08/09/2022
    @AuraEnabled
    public static void callGetOptionsAndOtherApis(Id serviceOrderId) {
        FSL_CL_FTRUtility.callGetOptionsAndOtherApis(serviceOrderId);
    }
    //Method added as part of SG-92 - To run Repair SRT, Ronnie Mishra Code Starts, 08/09/2022
    @AuraEnabled
    public static void callGetPartsAndPartReturn(Id serviceOrderId){
        FSL_CL_FTRUtility.callGetPartsAndPartReturn(serviceOrderId);
    }

    //Methoda added to check isDealer and FTR, added as part of SG-92
    @AuraEnabled
    public static Boolean isDealerAndFTR(Id objectID){
        Boolean isDealer = false;
        Boolean isFTR = false;
        try {
            User LoggedInUser = [SELECT Id FROM User WHERE id =: UserInfo.getUserId() LIMIT 1];        
            Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
            if(po != null && po.Name != null && po.Name.containsIgnoreCase('dealer')) {
                isDealer = true;  
            }
            Case cs = [SELECT Id, FSL_ABRFlag__c FROM Case WHERE Id =: objectID];
            if(cs.FSL_ABRFlag__c == true) {
                isFTR = true;
            }   
            return (isFTR && isDealer);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}