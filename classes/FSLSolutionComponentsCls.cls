/**********************************************************************
Name: FSLSolutionComponentsCls
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
1.0 - Vinod Yelala      05/15/2018      INITIAL DEVELOPMENT      
2.0   Dinesh Yadav      11/18/2020      Dinesh Yadav            
***********************************************************************/
public class FSLSolutionComponentsCls {
    
    @AuraEnabled
    public static List<FSLSolCompWrappers.CSSCompsWrp> getSolComps(String knowId, String urlName, String woId) {
        
        system.debug('URLName>>'+urlName+'<<<know id>>'+knowId);
        String recordtypeName = [select recordtype.developerName from workorder where id=:woId].recordtype.developerName;
        system.debug('recordtypeName>>'+recordtypeName);
        List<FSLSolCompWrappers.CSSCompsWrp> csscomps = new list<FSLSolCompWrappers.CSSCompsWrp>();
        Map<String, FSLSolCompWrappers.CSSCompsWrp> csscompsMap = new Map<String, FSLSolCompWrappers.CSSCompsWrp>();
        FSLSolCompWrappers.CSSCompsWrp tempCSSComp;
        CSS_Solution_Component__c tempCSC;
        list<CSS_Solution_Component__c> cscToIsrt = new List<CSS_Solution_Component__c>();
        Map<String, CSS_Solution_Component__c> cscToIsrtMap=new Map<String, CSS_Solution_Component__c>(); //added by vinod 11/26
        list<FSL_Parts__c> cscOpsToIsrt = new List<FSL_Parts__c>();
        Map<String, list<FSL_Parts__c>> cscOpsToIsrtMap = new Map<String, list<FSL_Parts__c>>(); //added by vinod 11/26
        List<CSS_Solution_Component__c> cssSols = new List<CSS_Solution_Component__c>();
        system.debug('<<+++++cssSols'+cssSols);
        cssSols = [SELECT Id, Solutions__c, Parts__c, Name, Component_Id__c, Selected_Component__c,Parts_Integration_Status__c,
                   (SELECT Part_Name__c, Part_Quantity__c, Replacement_Repair_Reason__c, Select__c, Assignment__c FROM Parts__r) //added Assignment attribute-NIN-481
                   FROM CSS_Solution_Component__c 
                   WHERE Solutions__c=:knowId];
        Boolean isPartsIntegrationCalled = FALSE;
        for(CSS_Solution_Component__c cssSolutionComponent : cssSols) {
            if(cssSolutionComponent.Parts__c >0 && cssSolutionComponent.Parts_Integration_Status__c == 'Yes') {  //added by sruthi VGRS2-248
                isPartsIntegrationCalled = TRUE;
                break;
            }
        }
        if(isPartsIntegrationCalled) {
            // passing solution id to css solution component to get parts.
            for(CSS_Solution_Component__c csc : cssSols) {
                tempCSSComp = new FSLSolCompWrappers.CSSCompsWrp();
                tempCSSComp.compName = csc.Name;
                tempCSSComp.compId = csc.Id;
                tempCSSComp.selectedComp = csc.Selected_Component__c;
                if(csc.Parts__r != null && csc.Parts__r.size() > 0) {
                    for(FSL_Parts__c fslPart : csc.Parts__r) {
                        tempCSSComp.cssSoldOpts.add(new FSLSolCompWrappers.CSSCompPartOptionsWrp(fslPart.Part_Name__c, fslPart.Replacement_Repair_Reason__c, fslPart.Part_Quantity__c, fslPart.Id, fslPart.Select__c, fslPart.Assignment__c));//Added Assignment-trupthi-8/10-NIN-481
                    }
                }
                csscomps.add(tempCSSComp);
                // added below if condition to consider solcomps if component id is blank by vinod 8/16
                if(String.isBlank(csc.Component_Id__c)) {
                    csscompsMap.put(csc.Id, tempCSSComp);
                } else {
                    csscompsMap.put(csc.Component_Id__c, tempCSSComp);
                }
            }
        }
        else {
            Id devPartsRecordTypeId = Schema.SObjectType.FSL_Parts__c.getRecordTypeInfosByName().get('GSQ').getRecordTypeId();
            Id devOptionsRecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
            Set<String> fIds = new Set<String>();
            String optionNbr = '';
            for(CSS_Parts_Options__c cpo : [SELECT Option_Number__c FROM CSS_Parts_Options__c WHERE RecordTypeId = :devOptionsRecordTypeId AND Service_Order__c =:woId LIMIT 1]) {
                optionNbr = cpo.Option_Number__c;
            }
            
            //Raj - Start : 
            //GFSLFM-1072 - Populate System and component code in solution components from Failure Codes object
            //CT3-112 Fix, Dinesh Yadav, 18 Nov 2020.
            string strKnowledgeId = '';
            List<FSL_Component__c> listFslComponent = new List<FSL_Component__c>();
            List<CSS_Solutions__c> lstCSSSol = [SELECT Id, Name, FSL_Solution_Content__c from CSS_Solutions__c WHERE Id=:knowId];
            if(lstCSSSol != null && lstCSSSol.size()>0){
                strKnowledgeId = lstCSSSol[0].FSL_Solution_Content__c; //Getting Knowledge Id from related solution id.
                listFslComponent = [SELECT Id, Name, Component_ID__c 
                                    FROM FSL_Component__c WHERE Knowledge__c=: strKnowledgeId];
            } 
             else{
                listFslComponent = [SELECT Id, Name, Component_ID__c 
                                           FROM FSL_Component__c WHERE Knowledge__r.urlname=:urlName];
            }
            
            Set<String> setComponentId = new Set<String>();
            for(FSL_Component__c fsc : listFslComponent) {
                setComponentId.add(fsc.Component_ID__c);
            }
            system.debug('setComponentId => ' + setComponentId);
            Map<String, FSL_Failure__c> mapFailureCodebyFailureId = new Map<String, FSL_Failure__c>();
            if(!setComponentId.isEmpty()) {
                WorkOrder wo1 = [SELECT Asset.Service_Model__c FROM WorkOrder WHERE Id =: woId];
                List<FSL_Failure__c> listFailureCode = [SELECT Id, Failure_Id__c, Component_Code__c, System_Code__c, Service_Model_Name__c 
                                                        FROM FSL_Failure__c
                                                        WHERE Failure_Id__c IN:setComponentId AND Service_Model_Name__c =: wo1.Asset.Service_Model__c];
                system.debug('listFailureCode => '+listFailureCode);
                for(FSL_Failure__c objFailureCode : listFailureCode){
                    mapFailureCodebyFailureId.put(objFailureCode.Failure_Id__c, objFailureCode);
                }
                system.debug('mapFailureCodebyFailureId => '+mapFailureCodebyFailureId);
            }
            
            
            for(FSL_Component__c fsc : listFslComponent) {
                tempCSSComp = new FSLSolCompWrappers.CSSCompsWrp();
                tempCSSComp.compName = fsc.Name;
                tempCSSComp.compId = fsc.Id;
                csscompsMap.put(fsc.Component_Id__c, tempCSSComp);
                // cscToIsrt.add(new CSS_Solution_Component__c(name=fsc.name, Component_Id__c=fsc.id, Solutions__c=knowId));
                
                CSS_Solution_Component__c objSolutionComponent = new CSS_Solution_Component__c();
                objSolutionComponent.Name = fsc.name;
                objSolutionComponent.Component_Id__c = fsc.Component_ID__c;
                objSolutionComponent.Solutions__c = knowId;
                objSolutionComponent.FSL_Service_Job__c = woId;
                
                if(mapFailureCodebyFailureId.containsKey(fsc.Component_ID__c) && mapFailureCodebyFailureId.get(fsc.Component_ID__c) != null) {
                    system.debug('***** mapFailureCodebyFailureId *****'+mapFailureCodebyFailureId.get(fsc.Component_ID__c));
                    objSolutionComponent.System_Code__c = (mapFailureCodebyFailureId.get(fsc.Component_ID__c).System_Code__c).subString(0, 2);
                    objSolutionComponent.Component_Code__c = (mapFailureCodebyFailureId.get(fsc.Component_ID__c).Component_Code__c).subString(0, 2);
                    if((mapFailureCodebyFailureId.get(fsc.Component_ID__c).System_Code__c).length() > 2) {
                        objSolutionComponent.SystemCode_Desc__c = (mapFailureCodebyFailureId.get(fsc.Component_ID__c).System_Code__c).subString(3);
                    }
                    if((mapFailureCodebyFailureId.get(fsc.Component_ID__c).Component_Code__c).length() > 2) {
                        objSolutionComponent.ComponentCode_Desc__c = (mapFailureCodebyFailureId.get(fsc.Component_ID__c).Component_Code__c).subString(3);
                    }
                    objSolutionComponent.Failure_Code__c = mapFailureCodebyFailureId.get(fsc.Component_ID__c).Id;
                }
                
                cscToIsrtMap.put(fsc.Component_ID__c, objSolutionComponent);                
                // cscToIsrtMap.put(fsc.Component_ID__c, new CSS_Solution_Component__c(name = fsc.name, Component_Id__c = fsc.Component_ID__c, Solutions__c = knowId, FSL_Service_Job__c = woId));//added woId to assign on css sol comp 5/24
                fIds.add(fsc.Component_ID__c);
                // optionnumbers.add(fsc.Component_ID__c); -- For options
            }
            
            // if(recordtypeName != 'SolutionRepair') {
            WorkOrder wo =[SELECT WorkOrderNumber, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, Asset.Service_Model__c, Asset.Equipment_Id__c FROM WorkOrder WHERE id=:woId];
            FSLGetPartsListSRTIntegrationHelper fsrt = new FSLGetPartsListSRTIntegrationHelper();
            // integration to get parts
            Boolean isPartsIntegrationPassed = TRUE;  //added by sruthi  02/22 VGRS2-339
            FSLGetPartsSRTListWrapper fgs;
            fgs = fsrt.getSRTPartsList(fIds, optionNbr, wo);//Replace new Set<String>()-- with options
            if(fgs != null)
            {
                system.debug('fgs: ' +fgs);
                if(fgs.DataArea != null && !fgs.DataArea.isEmpty())
                {
                    system.debug(fgs.DataArea);
                    
                    for(FSLGetPartsSRTListWrapper.DataArea fd : fgs.DataArea)   
                    {
                        FSL_Parts__c fslPart = new FSL_Parts__c (
                            Name = fd.PartNumberService,
                            Part_Name__c = fd.PartNameService,
                            Part_Description__c = fd.PartNumberMfg,
                            Assignment__c = fd.Assignment,
                            Notes__c = fd.Notes,
                            Part_Quantity__c = Decimal.valueOf(fd.Qty),
                            Option_Number__c = fd.OptionNumber,
                            Part_Size__c = fd.PartSize,
                            Service_Order__c = woId,
                            OEM__c = fd.OEM, 
                            FailureName__c = fd.FailureName,
                            RecordTypeId = devPartsRecordTypeId,
                            Solution__c = knowId,
                           // Replacement_Repair_Reason__c='GSQ Part'
                           Replacement_Repair_Reason__c='Suggested Parts Based on Failure (GSQ Part)'
                        );
                        
                        if(cscOpsToIsrtMap.containsKey(fd.FailureID)) {
                            cscOpsToIsrtMap.get(fd.FailureID).add(fslPart);
                        }
                        else {
                            cscOpsToIsrtMap.put(fd.FailureID, new List<FSL_Parts__c>{fslPart});
                        }
                        csscompsMap.get(fd.FailureID).cssSoldOpts.add(new FSLSolCompWrappers.CSSCompPartOptionsWrp(fd.PartNameService, '', Integer.valueOf(fd.Qty), fd.Assignment));//added assignment-trupthi-8/10-NIN-481
                    }
                }
            }
            else{
                isPartsIntegrationPassed = FALSE;  //added by sruthi 02/22 VGRS2-339
            }
            
            // inserts css components
            if(!cscToIsrtMap.isEmpty()) {
                insert cscToIsrtMap.values();
            }
            Map<id, Integer> compid = new Map<id, Integer>();
            if(cscToIsrtMap.size() > 0) {
                Integer partCount=0;
                for(CSS_Solution_Component__c csrt : cscToIsrtMap.values()) {
                    if(cscOpsToIsrtMap.containsKey(csrt.Component_Id__c)) {
                        
                        compid.put(csrt.id,  cscOpsToIsrtMap.get(csrt.Component_ID__c ).size());
                        for(FSL_Parts__c fslPart : cscOpsToIsrtMap.get(csrt.Component_ID__c )) {
                            fslPart.CSS_Solution_Component__c = csrt.Id;
                        }
                        cscOpsToIsrt.addAll(cscOpsToIsrtMap.get(csrt.Component_Id__c));
                    }
                    else{
                        
                        compid.put(csrt.id, 0);
                    }
                    
                    if(csscompsMap.containsKey(csrt.Component_Id__c)) {
                        csscompsMap.get(csrt.Component_Id__c).compId = csrt.Id;
                    }
                }
            }
            
            // inserts parts
            if(!cscOpsToIsrt.isEmpty()) {
                insert cscOpsToIsrt;
            }
            if(!compid.isEmpty())
            {
                for(FSL_Parts__c c: [select CSS_Solution_Component__c from FSL_Parts__c where CSS_Solution_Component__c in :compid.keySet()])
                {
                    system.debug(c.CSS_Solution_Component__c);
                }
            }
            system.debug('compid::'+compid);
            List<CSS_Solution_Component__c> cssr = new List <CSS_Solution_Component__c>();
            for(CSS_Solution_Component__c csrt : [SELECT ID, Parts__c,No_Parts_Returned__c, Selected_Component__c 
                                                  from CSS_Solution_Component__c  WHERE ID in :compid.keySet()])
            {
                
                if(compid.containsKey(csrt.id) && compid.get(csrt.id) == 0)
                {
                    csrt.Parts_Integration_Status__c = 'Yes';
                    if(csrt.Selected_Component__c && csrt.No_Parts_Returned__c == null)
                    {
                        csrt.No_Parts_Returned__c = woid;
                    }
                    else if(!csrt.Selected_Component__c && csrt.No_Parts_Returned__c <> null)
                    {
                        csrt.No_Parts_Returned__c = null;
                    }
                }
                else
                {
                    csrt.Parts_Integration_Status__c = 'Yes';
                }
                cssr.add(csrt);
            }
            update cssr;
            // }
            cssSols = [SELECT Id, Solutions__c, Parts__c, Name, Component_Id__c, Selected_Component__c, 
                       (SELECT Part_Name__c, Part_Quantity__c, Replacement_Repair_Reason__c, Select__c, Assignment__c FROM Parts__r) //Added assignment-trupthi-8/10-NIN-481
                       FROM CSS_Solution_Component__c 
                       WHERE Solutions__c=:knowId];
            
            if(!cssSols.isEmpty()) {
                csscompsMap = new Map<String, FSLSolCompWrappers.CSSCompsWrp>();
                // passing solution id to css solution component to get parts.
                for(CSS_Solution_Component__c csc : cssSols) {
                    system.debug('url--->' + csc.name);
                    system.debug('urldd--->' + csc);
                    tempCSSComp = new FSLSolCompWrappers.CSSCompsWrp();
                    tempCSSComp.compName = csc.Name;
                    tempCSSComp.compId = csc.Id;
                    tempCSSComp.selectedComp = csc.Selected_Component__c;
                    
                    // Commented while changing the Object to FSL_Parts__c from Css_Parts_options__c
                    if(csc.Parts__r != null && csc.Parts__r.size() > 0) {
                        for(FSL_Parts__c fslPart : csc.Parts__r) {
                            system.debug('fslPart>>' + fslPart);
                            tempCSSComp.cssSoldOpts.add(new FSLSolCompWrappers.CSSCompPartOptionsWrp(fslPart.Part_Name__c, fslPart.Replacement_Repair_Reason__c, fslPart.Part_Quantity__c, fslPart.Id, fslPart.Select__c, fslPart.Assignment__c)); //Added assignment-trupthi-8/10-NIN-481
                        }
                    }
                    else if(!isPartsIntegrationPassed){   //added by sruthi 02/22 VGRS2-339
                        tempCSSComp.isPartsIntegrationPassed = FALSE;  //added by sruthi 02/22 VGRS2-339
                    }
                    csscomps.add(tempCSSComp);
                    system.debug('before adding::'+tempCSSComp);
                    // added below if condition to consider solcomps if component id is blank by vinod 8/16
                    if(String.isBlank(csc.Component_Id__c)) {
                        csscompsMap.put(csc.Id, tempCSSComp);
                    }
                    else{// if(String.isBlank(csc.Component_Id__c)){
                        csscompsMap.put(csc.Component_Id__c, tempCSSComp);
                    }
                }
            }
        }
        system.debug('csscomps::' + csscompsMap);
        return csscompsMap.values();
    }
    
    @auraEnabled
    public static List<String> getRepairReasonLOVs() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = FSL_Parts__c.Replacement_Repair_Reason__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple) {
            options.add(f.getValue());
        }
        return options;
    }
    
    /** Added Ravikanth
* Passing lookup field ID to string and inserting the solution component record
**///by vinod yellala 6/12 - for failure add parts-added woId arguement
    @AuraEnabled
    public static String getfailurename(string strcnt , string strfmode, string solid, string strrecId, string cusfailid, String woId) {
        system.debug('check--->'+strcnt+strfmode+solid+strrecId);
        FSL_Fail_Mode__c  strfmodes;
        if(strfmode != null && strfmode != '') {
            strfmodes = [SELECT Id, Name FROM FSL_Fail_Mode__c WHERE Id=:strfmode limit 1];
        }
        // list<CSS_Solution_Component__c> lstsol = new list<CSS_Solution_Component__c>();
        Map<String, CSS_Solution_Component__c> cscToIsrtMap = new Map<String, CSS_Solution_Component__c>();
        list<CSS_Solution_Component__c> lstsols = new list<CSS_Solution_Component__c>();
        if(strcnt != null && strcnt != '') {
            Set<String> failIds = new Set<String>(); // by vinod yella
            for(FSL_Failure__c objfail :[SELECT Id, Name, Component_Code__c, System_Code__c, Failure_Name__c, Failure_Id__c 
                                         FROM FSL_Failure__c WHERE Id=:strcnt]) {
                                             CSS_Solution_Component__c  objsol = new CSS_Solution_Component__c ();
                                             if(objfail.Failure_Name__c != null && objfail.Failure_Name__c != '') {
                                                 objsol.Name = objfail.Failure_Name__c;
                                             } else {
                                                 objsol.Name = objfail.Name;
                                                 //obsol.Name = objfail.Name;
                                             }
                                             
                                             if(objfail.Component_Code__c != null) {
                                                 objsol.Component_Code__c = objfail.Component_Code__c.split('-')[0];
                                             }
                                             if(objfail.System_Code__c !=null) {
                                                 objsol.System_Code__c = objfail.System_Code__c.split('-')[0];
                                             }
                                             
                                             if(strfmodes!=null && strfmodes.Name!='') {
                                                 objsol.Failure_Mode__c = strfmodes.Name.split('-')[0];
                                             }
                                             
                                             objsol.ComponentCode_Desc__c = objfail.Component_Code__c;
                                             objsol.SystemCode_Desc__c = objfail.System_Code__c;
                                             
                                             if(String.isNotBlank( objsol.FailMode_Desc__c)) {
                                                 objsol.FailMode_Desc__c = strfmodes.Name;
                                             }
                                             if(solid != null && solid !='') {
                                                 objsol.Solutions__c = solid;
                                             }
                                             
                                             if(cusfailid !=null) {
                                                 objsol.Custom_Failure_Name__c = objfail.Id;
                                             } else {
                                                 objsol.Failure_Code__c = objfail.Id;
                                             }
                                             
                                             if(strfmode !=null && strfmode !='') {
                                                 objsol.Fail_Mode__c = strfmode;
                                             }
                                             
                                             if(strrecId !=null && strrecId !='') {
                                                 objsol.FSL_Service_Job__c = strrecId;
                                                 system.debug('check service job'+strrecId);
                                                 // objsol.FSL_Service_Order__c = strrecId;
                                             }
                                             
                                             if(String.isNotBlank(objfail.Failure_Id__c)) {
                                                 objsol.Component_Id__c=objfail.Failure_Id__c;
                                                 failIds.add(objfail.Failure_Id__c);
                                             }
                                             
                                             // lstsol.add(objsol); -- commented by vinod yellal 6/12
                                             // added line by vinod yellal 6/12
                                             cscToIsrtMap.put(objfail.Failure_Id__c, objsol);
                                             system.debug('cscToIsrtMap>>'+cscToIsrtMap.size());
                                         }
            String slcompid;
            if(cscToIsrtMap.size() > 0) {
                Id devPartsRecordTypeId = Schema.SObjectType.FSL_Parts__c.getRecordTypeInfosByName().get('GSQ').getRecordTypeId();
                Id devOptionsRecordTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
                String optionNbr = '';
                for(CSS_Parts_Options__c cpo : [SELECT Option_Number__c FROM CSS_Parts_Options__c WHERE RecordTypeId = :devOptionsRecordTypeId AND Service_Order__c =:woId LIMIT 1]) {
                    optionNbr = cpo.Option_Number__c;
                }
                Map<String, List<FSL_Parts__c>> cscOpsToIsrtMap=new Map<String, List<FSL_Parts__c>>();
                WorkOrder wo = [SELECT WorkOrderNumber, Asset.Engine_Family__c, Asset.Engine_Family_Code__c, Asset.Service_Model__c, Asset.Equipment_Id__c FROM WorkOrder WHERE id=:woId];
                // Get Parts is also used for FTR. The same code copied to FSL_CL_FTRUtility.callGetPartsForFTR. Any changes made in below logic also needs to updated to FSL_CL_FTRUtility
                FSLGetPartsListSRTIntegrationHelper fsrt=new FSLGetPartsListSRTIntegrationHelper(); // integration to get parts
                FSLGetPartsSRTListWrapper fgs = fsrt.getSRTPartsList(failIds, optionNbr, wo); // Replace new Set<String>()-- with options
                if(fgs != null) {
                    if(fgs.DataArea != null && !fgs.DataArea.isEmpty()) {
                        FSL_Parts__c fslPart;
                        for(FSLGetPartsSRTListWrapper.DataArea fd : fgs.DataArea) {
                            //tempCSSComp.cssSoldOpts.add(new CSSCompPartOptionsWrp(fd.PartNameService, '', Integer.valueOf(fd.Qty)));
                            fslPart = new FSL_Parts__c (
                                Name = fd.PartNumberService,
                                Part_Name__c = fd.PartNameService,
                                Part_Description__c = fd.PartNumberMfg,
                                Assignment__c = fd.Assignment,
                                Notes__c = fd.Notes,
                                Part_Quantity__c = Decimal.valueOf(fd.Qty),
                                Option_Number__c = fd.OptionNumber,
                                Part_Size__c = fd.PartSize,
                                Service_Order__c = woId,
                                OEM__c = fd.OEM,
                                FailureName__c = fd.FailureName,
                                RecordTypeId = devPartsRecordTypeId,
                               // Replacement_Repair_Reason__c = 'GSQ Part',
                                Replacement_Repair_Reason__c = 'Suggested Parts Based on Failure (GSQ Part)',
                                Solution__c = solid
                            );
                            if(cscOpsToIsrtMap.containsKey(fd.FailureID)) {
                                cscOpsToIsrtMap.get(fd.FailureID).add(fslPart);
                            }
                            else {
                                cscOpsToIsrtMap.put(fd.FailureID, new List<FSL_Parts__c>{fslPart});
                            }
                            // csscompsMap.get(fd.FailureID).cssSoldOpts.add(new FSLSolCompWrappers.CSSCompPartOptionsWrp(fd.PartNameService, '', Integer.valueOf(fd.Qty)));
                        }
                    }
                }
                system.debug('cscOpsToIsrt size' + cscToIsrtMap.size());
                
                // inserts css components
                if(!cscToIsrtMap.isEmpty()) {
                    insert cscToIsrtMap.values();
                    slcompid = cscToIsrtMap.values()[0].Id;
                }
                
                List<FSL_Parts__c> cscOpsToIsrt = new List<FSL_Parts__c>();
                
                if(cscToIsrtMap.size() > 0) {
                    
                    set<id> compid = new set<id>();
                    for(CSS_Solution_Component__c csrt : cscToIsrtMap.values()) {
                        compid.add(csrt.id);
                        
                        if(cscOpsToIsrtMap.containsKey(csrt.Component_Id__c)) {
                            for(FSL_Parts__c fslPart : cscOpsToIsrtMap.get(csrt.Component_ID__c )) {
                                fslPart.CSS_Solution_Component__c = csrt.Id;
                            }
                            cscOpsToIsrt.addAll(cscOpsToIsrtMap.get(csrt.Component_Id__c));
                        }
                    }
                    // Insert parts
                    if(!cscOpsToIsrt.isEmpty()) {
                        insert cscOpsToIsrt;
                    }
                    
                    
                }
                
                
                // Insert lstsol; -- commented by vinod yellal 6/12
            }
            system.debug('slcompid>'+slcompid);
            return slcompid;
        }
        return null;
    }
    
    @auraEnabled
    public static List<FSL_Custom_Part__c> getCustParts(String woId) {
        return FSLAddCustPartsCls.getCSSParts(woId);
    }
    
    @auraEnabled
    public static List<String> getFailures(String solutionId) {
        Set<String> fileCodes = new Set<String>();
        List<String> listFailureCodes = new List<String>();
        List<CSS_Solution_Component__c> listcompo = [SELECT Id, System_Code__c, Component_Code__c
                                                     FROM CSS_Solution_Component__c
                                                     WHERE Solutions__c=:solutionId];
        for(CSS_Solution_Component__c css :listcompo ){
            fileCodes.add(css.System_Code__c+css.Component_Code__c);
        }
        system.debug(fileCodes);
        List<FSL_Failure__c> failures = [SELECT Id
                                         FROM FSL_Failure__c
                                         WHERE NAME IN : fileCodes];
        System.debug(failures);
        for(FSL_Failure__c failure : failures){
            listFailureCodes.add(failure.Id);
        }
        return listFailureCodes;
    }
}