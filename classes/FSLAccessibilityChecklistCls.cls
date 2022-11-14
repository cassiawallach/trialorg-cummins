/**********************************************************************
Name: FSLAccessibilityChecklistCls
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
public class FSLAccessibilityChecklistCls {
    
    /*below method is for retrieving accessibility checklist data from integration*/
    @AuraEnabled
    public static String getWorkOrderRecordType(String strWorkOrderId) {
        //TESTING
        // system.debug('strWorkOrderId  '+ strWorkOrderId);
        String strRecordName = [SELECT Id, RecordType.Name 
                                FROM WorkOrder 
                                WHERE Id=:strWorkOrderId].RecordType.Name;
        system.debug('strRecordName '+ strRecordName);
        return strRecordName;
    }
    
    // Method for dealer user called from EVL_AccessibilityChecklist Added by Piyush (11/2) for VGRS2-131  
    @AuraEnabled
    public static List<CSSSRTWrps> getAccessbilitySRTs_EVL(String woId, String cssSolId) {
        
        try {
            WorkOrder wo = [SELECT Process_Step__c, RecordType.DeveloperName, Asset.Make__c, Asset.Model__c, 
                            Asset.Equipment_Id__c, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, Asset.Service_Model__c 
                            FROM WorkOrder WHERE Id=:woId];
            Map<String, CSSSRTWrps> cssSrtsMap = new Map<String, CSSSRTWrps>();
            Map<String, CSSSRTWrps> cssSrtsMapSorted = new Map<String, CSSSRTWrps>();
            Map<String, List<CSSSRTWrps>> cssSRTsTitle=new Map<String, List<CSSSRTWrps>>();
            FSL_SRT__c csrt;
            system.debug('cssSolId>>>' + cssSolId+wo.RecordType.DeveloperName);
            // Added by Piyush for VGSR2-191 11/15
            string[] codeList = new list<string>{'19-361' , '19-360' , '19-052' , '19-710' , '00-140' , '19-053', '17-004', '19-0FZ' , '19-0FV' , '19-0FY', '99-901' , '99-902', '99-903', '17-902' ,'17-901'};
            map<string, Boolean> mapCodetoavail = new map<string, Boolean>();
            
            List<FSL_SRT__c> lstWOSRT = [SELECT Id, Name FROM FSL_SRT__c WHERE Service_Order__c =: woId];
            for(FSL_SRT__c SRT : lstWOSRT){
               // string Code = SRT.Name.substring(0,6);
                string Code = SRT.Name.length() >6 ? SRT.Name.substring(0,6) : SRT.Name;//Piyush changed logic to skip N/A 12/7
                system.debug('Code>>>' + Code);
                if(!codeList.contains(Code)){
                    mapCodetoavail.put(Code, TRUE);
                }
            } // VGRS2-191 End
            
            CSS_Solutions__c csSol = [SELECT Id, FaultCode__c, FaultCode__r.Name FROM CSS_Solutions__c WHERE Id=:cssSolId];
            
            List<FSL_SRT__c> lstcsp = [SELECT Id, SRT_Title__c, Name, SRT_Quantity__c, Type__c,
                                  Component_Id__c, CSS_Fault_Code__c, Step_Description__c,
                                  SRT_Access_Code__c, SRT_Time__c, Use_R_Time__c, Access_Code_B__c, Access_Code_C__c,
                                  Step_Id__c, Access_Code_R__c, Access_Code_A__c, SRT_Type__c, Access_Code_D__c
                                  FROM FSL_SRT__c WHERE Solution_Number__c =: cssSolId ORDER BY SRT_Title__c ASC];
    
            for(FSL_SRT__c csp : lstcsp)
            {
                csrt = new FSL_SRT__c(
                    Name = csp.Name,
                    SRT_Title__c = csp.SRT_Title__c,
                    Id = csp.Id,
                    SRT_Quantity__c = csp.SRT_Quantity__c,
                    SRT_Access_Code__c = csp.SRT_Access_Code__c,
                    SRT_Time__c = csp.SRT_Time__c,
                    Use_R_Time__c = csp.Use_R_Time__c,
                    Access_Code_B__c = csp.Access_Code_B__c,
                    Access_Code_C__c = csp.Access_Code_C__c,
                    Step_Id__c = csp.Step_Id__c,
                    Access_Code_R__c = csp.Access_Code_R__c,
                    Access_Code_A__c = csp.Access_Code_A__c,
                    SRT_Type__c = csp.SRT_Type__c,
                    Access_Code_D__c = csp.Access_Code_D__c,
                    Service_Order__c = woId,
                    Solution_Number__c = cssSolId,
                    CSS_Fault_Code__c = csp.CSS_Fault_Code__c,
                    Type__c = csp.Type__c

                ); 
                //End - CT3-613 Changes added by Murali 
                // Added by Piyush for VGSR2-191 11/15
                CSSSRTWrps CSSSRTWrp = new CSSSRTWrps(csrt);
                CSSSRTWrp.isAvail = FALSE;
                // string Code = csrt.Name.substring(0,6);
                string Code = csrt.Name.length() >6 ? csrt.Name.substring(0,6) : csrt.Name;//Piyush changed logic to skip N/A 12/7
                system.debug('csrtCode>>>' + Code);
                if(mapCodetoavail.containskey(Code)){
                    CSSSRTWrp.isAvail = TRUE;
                } // VGRS2-191 End
                cssSrtsMap.put(csrt.Name, CSSSRTWrp);
                if(cssSRTsTitle.containsKey(csp.SRT_Title__c)) {
                    cssSRTsTitle.get(csp.SRT_Title__c).add(CSSSRTWrp);
                }
                else {
                    cssSRTsTitle.put(csp.SRT_Title__c, new List<CSSSRTWrps>{CSSSRTWrp});
                }
            }
            System.debug('cssSRTsTitle'+cssSRTsTitle);
            //Road 82 bug fix by Murali on 10/22/2021 - Handling an object result as a list to avoid running null pointer exception issue
            List<CSS_Make_Model_Access__c> cssMakeModelAcc = [SELECT Id, Access__c FROM CSS_Make_Model_Access__c 
                                                        WHERE Make__c =: wo.Asset.Make__c 
                                                        AND Model__c =: wo.Asset.Model__c 
                                                        AND EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c LIMIT 1];
            
            
            FSLSRTIntegrationHelperCls fsrt = new FSLSRTIntegrationHelperCls();
            FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrts = fsrt.runSRTLookupInterface(wo);
            for(FSLSRTIntegrationWrappers.SRTLookupDataArea csp : fsrts.DataArea) {
                Boolean booleanR = FALSE;
                if(!cssSrtsMap.containsKey(csp.SRTNumber) && !cssMakeModelAcc.isEmpty() && !cssSRTsTitle.containsKey(csp.SRTTitle)) {
                    Decimal srtTm;
                    String srtAccessCode;
                    if(cssMakeModelAcc[0].Access__c == 'A') {
                        srtTm = Decimal.valueOf(csp.ATime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'B') {
                        srtTm = Decimal.valueOf(csp.BTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'C') {
                        srtTm = Decimal.valueOf(csp.CTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'D') {
                        srtTm = Decimal.valueOf(csp.DTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'R') {
                        srtTm = Decimal.valueOf(csp.RTime);
                        booleanR = TRUE;
                    }
                    
                    if(srtTm == null || srtTm == 0.0) {
                        srtAccessCode = 'R';
                        srtTm = Decimal.valueOf(csp.RTime);
                        booleanR = TRUE;
                    }
                    else if(cssMakeModelAcc[0] != null) {
                        srtAccessCode = cssMakeModelAcc[0].Access__c;
                    }
                    
                    csrt = new FSL_SRT__c(
                        Name = csp.SRTNumber,
                        SRT_Title__c = csp.SRTTitle,
                        SRT_Quantity__c = csp.SRTQuantity,
                        SRT_Access_Code__c = srtAccessCode,
                        SRT_Time__c = srtTm,
                        Use_R_Time__c = booleanR,
                        Access_Code_B__c = Decimal.valueOf(csp.BTime),
                        Access_Code_C__c = Decimal.valueOf(csp.CTime),
                        Step_Id__c = csp.StepID,
                        Access_Code_R__c = Decimal.valueOf(csp.RTime),
                        Access_Code_A__c = Decimal.valueOf(csp.ATime),
                        SRT_Type__c = csp.SRTType,
                        Access_Code_D__c = Decimal.valueOf(csp.DTime),
                        Service_Order__c = woId,
                        Solution_Number__c = cssSolId,
                        CSS_Fault_Code__c = csSol.FaultCode__c
                    );
                    if(wo.Process_Step__c == 'Triage & Diagnosis')
                    {
                        csrt.Type__c = 'Diag Access';
                    }
                    else if(wo.Process_Step__c == 'Repair')
                    {
                        csrt.Type__c = 'Repair Access';
                    }                        
                    System.debug('cssSRTsTitle'+csrt);
                   // Added by Piyush for VGSR2-191 11/15
                    CSSSRTWrps CSSSRTWrp = new CSSSRTWrps(csrt);
                    CSSSRTWrp.isAvail = FALSE;
                    string Code = csrt.Name.substring(0,6);
                    if(mapCodetoavail.containskey(Code)){
                        CSSSRTWrp.isAvail = TRUE;
                    }
                    cssSrtsMap.put(csp.SRTNumber, CSSSRTWrp);
                    //added for srt sorting logic - vinod on 9/12
                    if(cssSRTsTitle.containsKey(csrt.SRT_Title__c))
                        cssSRTsTitle.get(csrt.SRT_Title__c).add(CSSSRTWrp);
                    else
                        cssSRTsTitle.put(csrt.SRT_Title__c, new List<CSSSRTWrps>{CSSSRTWrp});
                    //added for srt sorting logic - vinod on 9/12
                }
            }
            
            //added for srt sorting logic - vinod on 9/12
            if(!cssSRTsTitle.isEmpty())
            {
                List<String> orderedTitles = new List<String>(cssSRTsTitle.keySet());
                orderedTitles.sort();
                for(String s : orderedTitles)
                {
                    for(CSSSRTWrps csw : cssSRTsTitle.get(s))
                        cssSrtsMapSorted.put(csw.cssSrt.SRT_Title__c, csw);
                }
            }
            system.debug('cssSrts::'+cssSrtsMap);
            return cssSrtsMapSorted.values();//cssSrtsMap.values();//added for srt sorting logic - vinod on 9/12
            //return cssSrtsMap.values();
        }
        //Exceptions when integration fails.
        catch(System.CalloutException ce)
        {
            return null;
        }
        catch(System.Exception e)
        {
            return null;
        }
    }
    
    @AuraEnabled
    public static List<CSSSRTWrps> getAccessbilitySRTs(String woId, String cssSolId) {
        
        try {
            WorkOrder wo = [SELECT Process_Step__c, RecordType.DeveloperName, Asset.Make__c, Asset.Model__c, 
                            Asset.Equipment_Id__c, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, Asset.Service_Model__c 
                            FROM WorkOrder WHERE Id=:woId];
            Map<String, CSSSRTWrps> cssSrtsMap = new Map<String, CSSSRTWrps>();
            Map<String, CSSSRTWrps> cssSrtsMapSorted = new Map<String, CSSSRTWrps>();
            Map<String, List<CSSSRTWrps>> cssSRTsTitle=new Map<String, List<CSSSRTWrps>>();
            //Map<String, List<CSSSRTWrps>> cssSRTsTitle1=new Map<String, List<CSSSRTWrps>>();
            FSL_SRT__c csrt;
            system.debug('cssSolId>>>' + cssSolId);
            List<String> SRTType = new List<String>();
            if(wo.RecordType.DeveloperName == 'SolutionT_D') {
                SRTType.add('Diag Access');
            }
            
            else if(wo.RecordType.DeveloperName == 'SolutionRepair') {
                SRTType.add('Repair Access');
            }
            
            CSS_Solutions__c csSol = [SELECT Id, FaultCode__c, FaultCode__r.Name FROM CSS_Solutions__c WHERE Id=:cssSolId];
            //Start -  CT3-632 Changes added by Murali AccessSRT Changes
          
            for(FSL_SRT__c csp :  [SELECT Id, SRT_Title__c, Name, SRT_Quantity__c,
                                  Component_Id__c, CSS_Fault_Code__c, Step_Description__c,
                                  SRT_Access_Code__c, SRT_Time__c, Use_R_Time__c, Access_Code_B__c, Access_Code_C__c,
                                  Step_Id__c, Access_Code_R__c, Access_Code_A__c, SRT_Type__c, Access_Code_D__c
                                  FROM FSL_SRT__c WHERE Solution_Number__c = :cssSolId AND Type__c in:SRTType ORDER BY SRT_Title__c ASC])
            {
                csrt = new FSL_SRT__c(
                    Name = csp.Name,
                    SRT_Title__c = csp.SRT_Title__c,
                    Id = csp.Id,
                    SRT_Quantity__c = csp.SRT_Quantity__c,
                    SRT_Access_Code__c = csp.SRT_Access_Code__c,
                    SRT_Time__c = csp.SRT_Time__c,
                    Use_R_Time__c = csp.Use_R_Time__c,
                    Access_Code_B__c = csp.Access_Code_B__c,
                    Access_Code_C__c = csp.Access_Code_C__c,
                    Step_Id__c = csp.Step_Id__c,
                    Access_Code_R__c = csp.Access_Code_R__c,
                    Access_Code_A__c = csp.Access_Code_A__c,
                    SRT_Type__c = csp.SRT_Type__c,
                    Access_Code_D__c = csp.Access_Code_D__c,
                    Service_Order__c = woId,
                    Solution_Number__c = cssSolId,
                    CSS_Fault_Code__c = csp.CSS_Fault_Code__c
                ); 
                //End - CT3-613 Changes added by Murali 
                cssSrtsMap.put(csrt.Name, new CSSSRTWrps(csrt));
                if(cssSRTsTitle.containsKey(csp.SRT_Title__c)) {
                    cssSRTsTitle.get(csp.SRT_Title__c).add(new CSSSRTWrps(csrt));
                }
                else {
                    cssSRTsTitle.put(csp.SRT_Title__c, new List<CSSSRTWrps>{new CSSSRTWrps(csrt)});
                }
            }
            System.debug('cssSRTsTitle'+cssSRTsTitle);
            //Road 82 bug fix by Murali on 10/22/2021 - Handling an object result as a list to avoid running null pointer exception issue
            List<CSS_Make_Model_Access__c> cssMakeModelAcc = [SELECT Id, Access__c FROM CSS_Make_Model_Access__c 
                                                        WHERE Make__c =: wo.Asset.Make__c 
                                                        AND Model__c =: wo.Asset.Model__c 
                                                        AND EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c LIMIT 1];
            
            
            FSLSRTIntegrationHelperCls fsrt = new FSLSRTIntegrationHelperCls();
            FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrts = fsrt.runSRTLookupInterface(wo);
            for(FSLSRTIntegrationWrappers.SRTLookupDataArea csp : fsrts.DataArea) {
                Boolean booleanR = FALSE;
                if(!cssSrtsMap.containsKey(csp.SRTNumber) && !cssMakeModelAcc.isEmpty()) {
                    Decimal srtTm;
                    String srtAccessCode;
                    if(cssMakeModelAcc[0].Access__c == 'A') {
                        srtTm = Decimal.valueOf(csp.ATime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'B') {
                        srtTm = Decimal.valueOf(csp.BTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'C') {
                        srtTm = Decimal.valueOf(csp.CTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'D') {
                        srtTm = Decimal.valueOf(csp.DTime);
                    }
                    else if(cssMakeModelAcc[0].Access__c == 'R') {
                        srtTm = Decimal.valueOf(csp.RTime);
                        booleanR = TRUE;
                    }
                    
                    if(srtTm == null || srtTm == 0.0) {
                        srtAccessCode = 'R';
                        srtTm = Decimal.valueOf(csp.RTime);
                        booleanR = TRUE;
                    }
                    else if(cssMakeModelAcc[0] != null) {
                        srtAccessCode = cssMakeModelAcc[0].Access__c;
                    }
                    
                    csrt = new FSL_SRT__c(
                        Name = csp.SRTNumber,
                        SRT_Title__c = csp.SRTTitle,
                        SRT_Quantity__c = csp.SRTQuantity,
                        SRT_Access_Code__c = srtAccessCode,
                        SRT_Time__c = srtTm,
                        Use_R_Time__c = booleanR,
                        Access_Code_B__c = Decimal.valueOf(csp.BTime),
                        Access_Code_C__c = Decimal.valueOf(csp.CTime),
                        Step_Id__c = csp.StepID,
                        Access_Code_R__c = Decimal.valueOf(csp.RTime),
                        Access_Code_A__c = Decimal.valueOf(csp.ATime),
                        SRT_Type__c = csp.SRTType,
                        Access_Code_D__c = Decimal.valueOf(csp.DTime),
                        Service_Order__c = woId,
                        Solution_Number__c = cssSolId,
                        CSS_Fault_Code__c = csSol.FaultCode__c
                    );
                    if(wo.Process_Step__c == 'Triage & Diagnosis')
                    {
                        csrt.Type__c = 'Diag Access';
                    }
                    else if(wo.Process_Step__c == 'Repair')
                    {
                        csrt.Type__c = 'Repair Access';
                    }                        
                    System.debug('cssSRTsTitle'+csrt);
                    cssSrtsMap.put(csp.SRTNumber, new CSSSRTWrps(csrt));
                    //added for srt sorting logic - vinod on 9/12
                    if(cssSRTsTitle.containsKey(csrt.SRT_Title__c))
                        cssSRTsTitle.get(csrt.SRT_Title__c).add(new CSSSRTWrps(csrt));
                    else
                        cssSRTsTitle.put(csrt.SRT_Title__c, new List<CSSSRTWrps>{new CSSSRTWrps(csrt)});
                    //added for srt sorting logic - vinod on 9/12
                }
            }
            
            //added for srt sorting logic - vinod on 9/12
            if(!cssSRTsTitle.isEmpty())
            {
                List<String> orderedTitles = new List<String>(cssSRTsTitle.keySet());
                orderedTitles.sort();
                for(String s : orderedTitles)
                {
                    for(CSSSRTWrps csw : cssSRTsTitle.get(s))
                        cssSrtsMapSorted.put(csw.cssSrt.SRT_Title__c, csw);
                }
            }
            system.debug('cssSrts::'+cssSrtsMap);
            return cssSrtsMapSorted.values();//cssSrtsMap.values();//added for srt sorting logic - vinod on 9/12
            //return cssSrtsMap.values();
        }
        //Exceptions when integration fails.
        catch(System.CalloutException ce)
        {
            return null;
        }
        catch(System.Exception e)
        {
            return null;
        }
    }
    
    @AuraEnabled
    public static Boolean saveSRTsToDB(List<Object> cssSRTs, Id woId, String cssSolId)    
    {
        try{
	//CT3-25,added below code to update the solution
        system.debug('*** cssSolId**'+cssSolId);
        /*if(cssSolId != null){
        css_solutions__c sol = new css_solutions__c();
        sol.id = cssSolId;
        sol.No_Access_SRT_required__c = false;
        update sol;
        system.debug('sol**'+sol);
        }*/
        system.debug('*** cssSRTs::' + cssSRTs);
        String cssSRTStr = JSON.serialize(cssSRTs);
        System.debug('json cssSRTs>>' + cssSRTStr);
        List<CSSSRTWrps> cssSRTsLst = (List<CSSSRTWrps>)JSON.deserialize(cssSRTStr, List<CSSSRTWrps>.Class);
        //List<CSS_SRT__c> cssSRTsToUpsert = new List<CSS_SRT__c>();
        List<FSL_SRT__c> cssSRTsToUpsert = new List<FSL_SRT__c>();   
        WorkOrder wo = [SELECT Id,EVL_Solution_Marked_Most_Likely__c, Status, recordtype.developerName FROM workorder WHERE id=:woId];  
        system.debug('wo::' + wo);
        Boolean IsDealer = false;
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        system.debug('po::' + po);
        if(po != null && po.Name != null && po.Name.containsIgnoreCase('dealer'))
            IsDealer = true;
        system.debug('IsDealer::' + IsDealer);
        
        String SRTType;
        System.debug('::: Values to check - '+wo.EVL_Solution_Marked_Most_Likely__c+' , Rec Type - '+wo.RecordType.DeveloperName+' , IsDealer - '+IsDealer);
        if((IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == false) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionT_D')) {
            SRTType = 'Diag Access';
            //	} else if((IsDealer && wo.Status == 'Repair') || (IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == true) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionRepair')) {
        } else if((IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == true) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionRepair')) {
            SRTType = 'Repair Access';
        }  
        system.debug('SRTType::' + SRTType);
        
        FSL_SRT__c tempFSrt;
        Set<String> srtNbrs = new Set<String>();
        for(CSSSRTWrps csw : cssSRTsLst)
        {
            srtNbrs.add(csw.cssSrt.Name);
        }
        Map<String, ID> srtNbrsMap = new Map<String, Id>();
        if(!srtNbrs.isEmpty())
        {
            for(FSL_SRT__c srt : [SELECT Id, Name FROM FSL_SRT__c WHERE Name IN: srtNbrs AND Service_Order__c =: woId AND Solution_Number__c =: cssSolId and Type__c =: srtType])
            {
                srtNbrsMap.put(srt.Name, srt.Id);
            }
        }
        List<FSL_SRT__c> cssSRTsToDelete = new List<FSL_SRT__c>();
        for(CSSSRTWrps csw : cssSRTsLst)
        {
            system.debug('csw>'+csw);
            tempFSrt=csw.cssSrt;
            if(srtNbrsMap.containsKey(tempFSrt.Name))
            {
                tempFSrt.Id = srtNbrsMap.get(tempFSrt.Name);
            }
            tempFSrt.Type__c = SRTType;
            
            if(csw.isSelected != null && csw.isSelected == false && csw.cssSrt.Id != null && srtNbrsMap.containsKey(tempFSrt.Name))
                cssSRTsToDelete.add(csw.cssSrt);
            else if(csw.isSelected != null && csw.isSelected)
            {
                csw.cssSrt.SRT_Select__c = csw.isSelected;
                cssSRTsToUpsert.add(csw.cssSrt);            
            }
        }
        system.debug('***cssSRTsToUpsert>>'+cssSRTsToUpsert);
        system.debug('***cssSRTsToDelete::'+cssSRTsToDelete);
        
       
        if(!Test.isRunningTest()){
            if(cssSRTsToUpsert != null && cssSRTsToUpsert.size()>0)
                upsert cssSRTsToUpsert;        
        }
        //CT3-613 -Moved by Murali to do delete after an upsert happen
        if(!cssSRTsToDelete.isEmpty())//added by vinod 10/29
            delete cssSRTsToDelete;//added by vinod 10/29
        /*Starts Added to retrieve Step Description*/
        if(cssSRTsToUpsert.size() > 0)
        {
            List<ID> srtsToFetchStepDescr = new List<ID>();
            for(FSL_SRT__c srt : cssSRTsToUpsert)
            {
                if(String.isBlank(srt.Step_Description__c))
                    srtsToFetchStepDescr.add(srt.Id);
            }
            if(srtsToFetchStepDescr.size()>0)
            {
                FSLSRTIntegrationHelperCls.getSRTDescriptionsInvocable(srtsToFetchStepDescr);
            }
        }
        /*Ends Added to retrieve Step Description*/
        return true;
        }
        catch(exception ex)
        {
            throw new AuraHandledException('Error message=='+ex.getMessage());
            
        }
    }
    //Method for dealer user called from EVL_AccessibilityChecklist added by Piyush(8/10) for CT1- 635 
    @AuraEnabled
    public static Boolean saveSRTDealer(List<Object> cssSRTs, Id woId, String cssSolId, String inputSRTType)    
    {
        String cssSRTStr = JSON.serialize(cssSRTs);
        System.debug('json cssSRTs>>' + cssSRTStr);
        List<CSSSRTWrps> cssSRTsLst = (List<CSSSRTWrps>)JSON.deserialize(cssSRTStr, List<CSSSRTWrps>.Class);
        List<FSL_SRT__c> cssSRTsToUpsert = new List<FSL_SRT__c>();   
        WorkOrder wo = [SELECT Id,EVL_Solution_Marked_Most_Likely__c, Status, recordtype.developerName FROM workorder WHERE id=:woId];  
        system.debug('wo::' + wo);
        Boolean IsDealer = false;
        Profile po = [SELECT Id, Name FROM Profile WHERE Id =: UserInfo.getProfileId()];
        system.debug('po::' + po);
        if(po != null && po.Name != null && po.Name.containsIgnoreCase('dealer'))
            IsDealer = true;
        system.debug('IsDealer::' + IsDealer);
        
        String SRTType;
        System.debug('::: Values to check - '+wo.EVL_Solution_Marked_Most_Likely__c+' , Rec Type - '+wo.RecordType.DeveloperName+' , IsDealer - '+IsDealer);
        
        /* if((IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == false) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionT_D')) {
        SRTType = 'Diag Access';
        //	} else if((IsDealer && wo.Status == 'Repair') || (IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == true) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionRepair')) {
        } else if((IsDealer && wo.EVL_Solution_Marked_Most_Likely__c == true) || (!IsDealer && wo.RecordType.DeveloperName == 'SolutionRepair')) {
        SRTType = 'Repair Access';
        }  */
        
        if(inputSRTType == 'Diagnostic') {
            SRTType = 'Diag Access';
        } else if(inputSRTType == 'Repair') {
            SRTType = 'Repair Access';
        }
        system.debug('SRTType::' + SRTType);
        
        FSL_SRT__c tempFSrt;
        Set<String> srtNbrs = new Set<String>();
        for(CSSSRTWrps csw : cssSRTsLst)
        {
            srtNbrs.add(csw.cssSrt.Name);
        }
      /*  Map<String, ID> srtNbrsMap = new Map<String, Id>();
        if(!srtNbrs.isEmpty())
        {
            for(FSL_SRT__c srt : [SELECT Id, Name FROM FSL_SRT__c WHERE Name IN: srtNbrs AND Service_Order__c =: woId AND Solution_Number__c =: cssSolId and Type__c =: srtType])
            {
                srtNbrsMap.put(srt.Name, srt.Id);
            }
        }*/
        List<FSL_SRT__c> cssSRTsToDelete = new List<FSL_SRT__c>();
        for(CSSSRTWrps csw : cssSRTsLst)
        {
            system.debug('csw>'+csw);
            tempFSrt=csw.cssSrt;
           /* if(srtNbrsMap.containsKey(tempFSrt.Name))
            {
                tempFSrt.Id = srtNbrsMap.get(tempFSrt.Name);
            }*/
            if(csw.cssSrt.Id == null){
                tempFSrt.Type__c = SRTType;
            }
            
          //  if(csw.isSelected != null && csw.isSelected == false && csw.cssSrt.Id != null &&srtNbrsMap.containsKey(tempFSrt.Name))
            if(csw.isSelected != null && csw.isSelected == false && csw.cssSrt.Id != null )
            {
              cssSRTsToDelete.add(csw.cssSrt);
            }
            else if(csw.isSelected != null && csw.isSelected)
            {
                csw.cssSrt.SRT_Select__c = csw.isSelected;
                system.debug('csw>'+csw.cssSrt.Type__c);
                cssSRTsToUpsert.add(csw.cssSrt);            
            }
        }
        system.debug('***cssSRTsToUpsert>>'+cssSRTsToUpsert);
        system.debug('***cssSRTsToDelete::'+cssSRTsToDelete);
        
        if(!cssSRTsToDelete.isEmpty())//added by vinod 10/29
            delete cssSRTsToDelete;//added by vinod 10/29
        if(!Test.isRunningTest()){
            if(cssSRTsToUpsert != null && cssSRTsToUpsert.size()>0)
                upsert cssSRTsToUpsert;        
        }
        /*Starts Added to retrieve Step Description*/
        if(cssSRTsToUpsert.size() > 0)
        {
            List<ID> srtsToFetchStepDescr = new List<ID>();
            for(FSL_SRT__c srt : cssSRTsToUpsert)
            {
                if(String.isBlank(srt.Step_Description__c))
                    srtsToFetchStepDescr.add(srt.Id);
            }
            if(srtsToFetchStepDescr.size()>0)
            {
                FSLSRTIntegrationHelperCls.getSRTDescriptionsInvocable(srtsToFetchStepDescr);
            }
        }
        /*Ends Added to retrieve Step Description*/
        return true;
    }
    //CT1-635 End
    //CT3-25
    @AuraEnabled
    public static css_solutions__c getAccSRTCheck(Id solId) {   
        css_solutions__c solutions =  
            [SELECT Id, No_Access_SRT_required__c FROM css_solutions__c Where Id= :solId limit 1 ];
        return solutions;
    }
    //CT3-25
    @AuraEnabled
    public static css_solutions__c saveAccSRTCheck(Id solId, Boolean accSRTCheck) {   
        // css_solutions__c solutions =  
        // [SELECT Id, No_Access_SRT_required__c FROM css_solutions__c Where Id= :solId limit 1 ];
        css_solutions__c solution = new css_solutions__c();
        solution.id = solId;
        solution.No_Access_SRT_required__c = accSRTCheck;
        update solution;
        return solution;
    }
    //CT3-25
    @AuraEnabled
    public static Integer getSRTCount(Id solId){
        List<FSL_SRT__c> srts = new List<FSL_SRT__c>();
        srts = [SELECT Id, type__c FROM FSL_SRT__c Where Solution_Number__c = :solId and (type__c = 'Diag Access' OR type__c = 'Repair Access')];
        string srtCount;
        if(srts != null && srts.size()>0)
            return srts.size();
        else {
            return 0;
        }
    }
    
    @AuraEnabled
    public static Boolean logAccessSRTAuditEvent(String woId, String cssSolId)
    {
        //String woNo=[select WorkOrderNumber from workorder where id=:woId].WorkOrderNumber;
        CSS_Solutions__c cssSol = [SELECT Id,Solution_Title__c,Rank__c,Diagnostic_Response__c,Fault_Codes__c,Name
                                   FROM CSS_Solutions__c WHERE Id=:cssSolId LIMIT 1];
        Audit_Trail_Event__mdt auditEvent = [select Event_Type__c,Diagnostic_Audit_Trail__c,Event_Description__c from Audit_Trail_Event__mdt where DeveloperName='Event_07'];
        FSLAuditTrialEventLogger fat = new FSLAuditTrialEventLogger();
        return fat.logAccessSRTEvent(auditEvent, woId,cssSol);    
    }
    
    public Class CSSSRTWrps{
        @auraenabled public FSL_SRT__c cssSrt{get;set;}
        @auraenabled public Boolean isSelected{get;set;}
        @auraenabled public Boolean isAvail{get;set;} // Added by Piyush for VGSR2-191 11/15
        @auraenabled public Boolean isDuplicate{get;set;} // Added by Piyush for VGSR2-191 11/15
        public CSSSRTWrps(FSL_SRT__c cssSrt)
        {
            this.cssSrt = cssSrt;
            if(cssSrt.SRT_Quantity__c != null && cssSrt.SRT_Quantity__c > 0)
                this.isSelected = true;
            else
                this.isSelected = false;
        }
    }
}