/**********************************************************************
Name: FSLAddCustPartsCls
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLAddCustPartsCls {
    
    @auraEnabled
    public static List<String> getRepairReasonLOVs() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = FSL_Custom_Part__c.Replacement_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple) {
            //options.add(f.getValue());
            options.add(f.getLabel());	//Changed value to label to handle language translations
        }
        return options;
    }
    
    @AuraEnabled
    public static void saveParts(List<FSL_Custom_Part__c> partsToInsrt, String woId){//, String Name) {        
        List<FSL_Custom_Part__c> partsToInsrtNew = new List<FSL_Custom_Part__c>();
        for(FSL_Custom_Part__c cssp : partsToInsrt) {
            if(!String.isBlank( String.valueOf(cssp.Name)))
            {
                if(String.isBlank(String.valueOf(cssp.Service_Order__c))) {
                    cssp.Service_Order__c = woId;
                    
                }
                partsToInsrtNew.add(cssp);
            }
        }
        system.debug('partsToInsrt>>'+partsToInsrt);
        upsert partsToInsrtNew;
        //added by sai as part of CT1-400
        //Commenting this code for Ct1-605 defect#3, after checking with sai as this is not required for CT1-400
    /*   Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();

        WorkOrder Wod = new WorkOrder(Id=woId, Type__c= 'Dealer' );
        Wod.Status = 'Triage & Diagnosis';
        Wod.EVL_Stage__c = 'Triage & Diagnosis';
        Wod.Process_Step__c = '';
        Wod.RecordTypeId = evalRTID;
         update wod; */
        
    }
    
    @AuraEnabled
    public static String getProfileInfo(){
        try{
            Boolean isFactoryRole = false;
            String ProfileCheck;
            String profileId = UserInfo.getProfileId();
            Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
            String UserId = USerInfo.getUserId();
            User usr = [SELECT Id,  UserRole.Name FROM User WHERE Id =: UserId];
            if(profile.Name == 'CSS_Service_Advanced' && usr.UserRole.Name == 'factory')
            {
                Profilecheck = 'FU';
                isFactoryRole = true;
            }
            
            system.debug('profile>>>>>>>>>>'+profile.Name);
            if(profile.Name == 'EVL_Dealer_Advanced' || profile.Name == 'EVL_Dealer_Technician' || profile.Name == 'EVL_Dealer_Readonly'){
                Profilecheck = 'true';
                isFactoryRole = false;
            }
            else if(!profile.Name.containsIgnoreCase('dealer') && isFactoryRole == false){
                Profilecheck = 'false';
            }
            system.debug('profile>>>>>>>>>>>'+profile.Name);
            return Profilecheck;
            
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    
    @AuraEnabled
    public static Boolean deleteCSSParts(List<FSL_Custom_Part__c> partsToDel) {
        List<FSL_Custom_Part__c> partsToDelTemp= new List<FSL_Custom_Part__c>();
        try {
            for(FSL_Custom_Part__c cssp : partsToDel) {
                if(cssp.id != null) {
                    partsToDelTemp.add(cssp);
                }
            }
            system.debug('partsToInsrt>>'+partsToDelTemp);
            delete partsToDelTemp;
            return true;
        }
        catch(System.Exception e) {
            system.debug('e>>'+e);
            return false;
        }
    }
    
    @AuraEnabled 
    public static List<FSL_Custom_Part__c> getCSSParts(String woId) {
        Id recdtypeId = Schema.SObjectType.FSL_Custom_Part__c.getRecordTypeInfosByDeveloperName().get('Preventive_Maintenance_Part').getRecordTypeId();//added by mallika as part of cps-102 to not display the PM part records:10/29
        List<FSL_Custom_Part__c> cssParts= new  List<FSL_Custom_Part__c>();
        cssParts = [SELECT Id, Quantity__c, Name, Part_Number__c, Notes__c, Replacement_Reason__c, Service_Order__c FROM 
                    FSL_Custom_Part__c WHERE Service_Order__c =: woId AND RecordTypeId !=: recdtypeId ORDER BY Name ASC,createdDate DESC];
        return cssParts;
    }
    
    @AuraEnabled 
    public static WorkOrder getWoInfo(String woId) { //added by sruthi as part of VGRS2-147 12/7/21
        
        WorkOrder wo = [Select Id, Type__c from WorkOrder where Id =: woId LIMIT 1];
        
        return wo;
    }
    
    @AuraEnabled
    public static list <FSL_Custom_Part__c> fetchcustompart(String sortField, boolean isAsc,String woId) {
        String sSoql = 'SELECT Id, Quantity__c, Name, Part_Number__c, Notes__c, Replacement_Reason__c, Service_Order__c FROM FSL_Custom_Part__c ';
        sSoql += ' WHERE Service_Order__c =\''+ String.escapeSingleQuotes(woId)+'\''; // Added this line as part of FBI - 383.
        system.debug('sortField-->' + sortField);
        
        if (sortField != '') {
            sSoql += ' order by ' + String.escapeSingleQuotes(sortField);// Added this line as part of FBI - 383
            
            // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
            if (isAsc) {
                sSoql += ' asc';
            } else {
                sSoql += ' desc';
            }
        }
        // set record limit to query 
        sSoql += ' LIMIT 50';
        
        System.debug('@Developer -->sSoql:' + sSoql);
        list<FSL_Custom_Part__c> lstResult;
        try {
            system.debug('The query is' + sSoql);
            lstResult = Database.query(sSoql);
            List<FSL_Custom_Part__c> returnConList = new List<FSL_Custom_Part__c>();
            
            for (FSL_Custom_Part__c c: lstResult) {
                returnConList.add(c);
            }
            return returnConList;
        } 
        catch (Exception ex) {
            // for handle Exception
            return null;
        }
    }
    
    @auraEnabled
    public static String getPartName(String partNo) {
        String partName = '';
        
        String profileId = UserInfo.getProfileId();
        Profile ProfileD = [SELECT Id, Name from Profile WHERE ID =: profileId];
        
        String usrRoleId = UserInfo.getUserRoleId();
        UserRole usrRole;
        if(usrRoleId != NULL){
            usrRole = [Select Id, Name from UserRole where Id =: usrRoleId];
        }
        
        if(Test.isRunningTest() || (ProfileD != null && ProfileD.Name != null && ProfileD.Name.contains('Dealer')) || (usrRole != NULL && usrRole.Name != NULL && usrRole.Name.EqualsIgnoreCase('factory'))) {
            CG_OP_OAGWrapper opres = new CG_OP_OAGWrapper();
            opres = FSL_WS_SBL.getpartsdata(partNo);
            
            if(opres!=null && opres.response!=null && opres.response.getbody()!=null && opres.response.getbody()!='') {
                CG_GetPartsdataresWrapper res = (CG_GetPartsdataresWrapper) System.JSON.deserialize(opres.response.getBody(), CG_GetPartsdataresWrapper.class);
                System.debug('Today res ' +  res);
                if(res.header.status=='Success') {//Service response came back without any error/warning messages
                    if(string.isNotBlank(res.DataArea.PartDescription) || string.isNotEmpty(res.DataArea.PartDescription)){
                        partName = res.DataArea.PartDescription;
                    } else {
                        //system.debug('Service is successful but there is no part no returned.');                    
                        partName = '';
                    }
                    if(res.header.status=='Error' || opres.response.getStatusCode() != 200) {//Service response came back with some error or warning
                        /*system.debug('Service response came back with some error or warning');*/
                        partName = '';
                    }
                } else {
                    /*system.debug('Service response came back with some error or warning');*/
                    partName = '';
                } 
            }
        } 
        return partName;
    }
}