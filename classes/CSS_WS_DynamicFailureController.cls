Public Class CSS_WS_DynamicFailureController{
    
    Public CSS_WS_Warranty__c ActualClaim { get; set; }
    Public CreateNewFailure NewFailure { get; set; }
    Public CSS_WS_J2A_GetAccountCoverage AccCoverageResponse { get; set; }
    Public CSS_WS_J2A_GetGSQFailure GSQFailureResponse { get; set; }
    Public List<CreateNewFailure> FailureList { get; set; }
    Public List<String> WSDetailListAccCoverage { get; set; }
    Public List<selectOption> GetComponentList { get; set; }
    Public List<CSS_WS_Failure__c> ListToInsert = new List<CSS_WS_Failure__c>();
    Public Integer FailureToDelete { get; set; }
    Public Integer FailureCounter = 0;
    Public Integer FailuresWithError = 0;
    Public Integer AbbreviateNumber = 45;
    Public String EngineSystemSelectListValue { get; set; }
    Public String FailureModeSelectListValue { get; set; }
    Public String ComponentSelectListValue { get; set; }
    Public String EngineSystemCode = '';
    Public String FailureModeCode = '';
    Public String ComponentCode = '';
    Public String EngineSystemName = '';
    Public String FailureModeName = '';
    Public String ComponentName = '';
    Public String FailureID = '';
    Public Boolean CanAddFailure { get; set; }
    
    Public CSS_WS_DynamicFailureController(ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_DynamicFailureController ****** CSS_WS_DynamicFailureController');
        this.ActualClaim = (CSS_WS_Warranty__c)controller.getRecord();
        this.ClassIni();
    }
    
    Public Class CreateNewFailure{
        Public CSS_WS_Failure__c Failure { get; set; }
        Public Integer Index { get; set; }  
        Public Boolean disableFlag { get; set; }  
        Public CreateNewFailure(Integer Index, String EngineSystemCode, String ComponentCode, String FailureModeCode, String EngineSystemName, String FailureModeName, String ComponentName, Boolean disableFlagR, String FailureID){
            this.Index = Index;
            disableFlag = disableFlagR;
            EngineSystemName = (EngineSystemName == null) ? '' : EngineSystemName;
            FailureModeName = (FailureModeName == null) ? '' : FailureModeName;
            ComponentName = (ComponentName == null) ? '' : ComponentName;
            ComponentCode = (ComponentCode == null) ? '' : ComponentCode;
            EngineSystemCode = (EngineSystemCode == null) ? '' : EngineSystemCode;
            FailureModeCode = (FailureModeCode == null) ? '' : FailureModeCode;
            FailureID = (FailureID == null) ? '' : FailureID;
            this.Failure = new CSS_WS_Failure__c(
                CSS_WS_Failure_Name__c = EngineSystemCode + ComponentCode +' - ' + EngineSystemName + ' ' + ComponentName,
                CSS_WS_EngineSystem__c = EngineSystemName,
                CSS_WS_EngineSystemCode__c = EngineSystemCode,
                CSS_WS_ComponentName__c = ComponentName,
                CSS_WS_ComponentCode__c = ComponentCode,
                CSS_WS_FailureModeName__c = FailureModeName,
                CSS_WS_FailureModeCode__c = FailureModeCode,
                CSS_WS_Failure_ID__c = FailureID);
        }
    }
    
    Public List<selectOption> getFailureList{
        get{
            List<selectOption> Options = new List<selectOption>();
            Options.add(new SelectOption('',Label.CSS_WS_Selection_None));
            CSS_WS_Failure_Master__c[] failures;
            if(this.ActualClaim.CSS_WS_Engine_Family_Code__c != null){//Rule SF14
                failures = [SELECT Engine_System_Code__c, Engine_System_Code_Description__c FROM CSS_WS_Failure_Master__c
                    WHERE Engine_Family_Code__c =: this.ActualClaim.CSS_WS_Engine_Family_Code__c
                    AND Engine_System_Code__c != '' AND Engine_System_Code_Description__c != '' ORDER BY Engine_System_Code__c];
            }
            /*if(String.isEmpty(this.ActualClaim.CSS_WS_Engine_Family_Code__c)){//|| failures.size() == 0){
                failures = [SELECT Engine_System_Code__c, Engine_System_Code_Description__c FROM CSS_WS_Failure_Master__c
                    WHERE Engine_System_Code__c != '' AND Engine_System_Code_Description__c != '' ORDER BY Engine_System_Code__c];
            }*/
            Map<String, CSS_WS_Failure_Master__c> mapFailureBySC = new Map<String, CSS_WS_Failure_Master__c>();
            //Map<String, String> mapFailureTemp = new Map<String, String>();
            if(failures.size() > 0){
                for(CSS_WS_Failure_Master__c failure : failures){
                    mapFailureBySC.put(failure.Engine_System_Code__c, failure);//Delete the repeated elements
                }
                
                // Determine the list of System Codes to display
                if(this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c == '1 - Consumed with proper response' &&  GSQFailureResponse != null){ // the value of this flag means that we have data from GSQ Failures
                    Map<String, String> mapGSQFailureSystem = new Map<String, String>();
                    if(GSQFailureResponse.Header.MessageType.touppercase() == 'S'){
                        if(GSQFailureResponse.DataArea != null){
                            for(integer i=0; i< GSQFailureResponse.DataArea.size(); i++) {
                                mapGSQFailureSystem.put(GSQFailureResponse.DataArea[i].SystemCode, GSQFailureResponse.DataArea[i].SystemCode); // get list of unique system codes from GSQ Failure 
                            }
                        }             
                    }                   
                    // system.debug('Map GSQ: ' + mapGSQFailureSystem );
                    
                    /*for(String system_code : mapGSQFailureSystem.keySet()){ // Previous GSQ logic
                        if(mapFailureBySC.get(system_code) != null){
                             Options.add(new SelectOption(mapFailureBySC.get(system_code).Engine_System_Code__c + '&' + mapFailureBySC.get(system_code).Engine_System_Code_Description__c, 
                                String.valueof(mapFailureBySC.get(system_code).Engine_System_Code__c + ' - ' + mapFailureBySC.get(system_code).Engine_System_Code_Description__c).abbreviate(this.AbbreviateNumber))); // create list of System Codes to display in dropdwon
                        } else {
                           // Values for GSQ failure when these are not into local catalogue 
                            Options.add(new SelectOption(mapGSQFailureSystem.get(system_code) + '&' + mapGSQFailureSystem.get(system_code), 
                                String.valueof(mapGSQFailureSystem.get(system_code) + ' - ' + mapGSQFailureSystem.get(system_code)).abbreviate(this.AbbreviateNumber)));
                        }
                    } */
                    for(String system_code : mapFailureBySC.keySet()){
                        Options.add(new SelectOption(mapFailureBySC.get(system_code).Engine_System_Code__c + '&' + mapFailureBySC.get(system_code).Engine_System_Code_Description__c, 
                                String.valueof(mapFailureBySC.get(system_code).Engine_System_Code__c + ' - ' + mapFailureBySC.get(system_code).Engine_System_Code_Description__c).abbreviate(this.AbbreviateNumber))); // create list of System Codes to display in dropdwon from local catalogue
                    } 
                    for(String system_code_gsq : mapGSQFailureSystem.keySet()){
                        if(mapFailureBySC.get(system_code_gsq) == null){
                           // Values for GSQ failure when these are not into local catalogue 
                            Options.add(new SelectOption(mapGSQFailureSystem.get(system_code_gsq) + '&' + mapGSQFailureSystem.get(system_code_gsq), 
                                String.valueof(mapGSQFailureSystem.get(system_code_gsq) + ' - ' + mapGSQFailureSystem.get(system_code_gsq)).abbreviate(this.AbbreviateNumber)));
                        }
                    }                   
                } else {    // we don't have values from GSQ failure, so the options from failure cataologue are displayed          
                    for(CSS_WS_Failure_Master__c failure : mapFailureBySC.values()){
                        if(mapFailureBySC.size()>= 999){
                            break;
                        }
                        Options.add(new SelectOption(failure.Engine_System_Code__c + '&' + failure.Engine_System_Code_Description__c, 
                                 String.valueof(failure.Engine_System_Code__c + ' - ' + failure.Engine_System_Code_Description__c).abbreviate(this.AbbreviateNumber)));
                    }               
                }
                
                /*for(CSS_WS_Failure_Master__c failure : mapFailureBySC.values()){
                    if(mapFailureBySC.size()>= 999){
                        break;
                    }
                    //if(String.isEmpty(mapFailureTemp.get(failure.Engine_System_Code__c))){
                      //  mapFailureTemp.put(failure.Engine_System_Code__c, failure.Engine_System_Code__c);
                        Options.add(new SelectOption(failure.Engine_System_Code__c + '&' + failure.Engine_System_Code_Description__c, 
                                                 String.valueof(failure.Engine_System_Code__c + ' - ' + failure.Engine_System_Code_Description__c).abbreviate(this.AbbreviateNumber)));
                    //}
                }*/
            }
            failures = null;
            Options.sort();
            return Options;
        }
        set;
    }
    
    Public List<selectOption> GetFailureModeList{
        get{
            List<selectOption> Options = new List<selectOption>();
            Options.add(new SelectOption('',Label.CSS_WS_Selection_None));
            CSS_WS_Fail_Mode_Catalog__c [] failModes = [SELECT CSS_WS_Name__c, CSS_WS_FailMode__c FROM CSS_WS_Fail_Mode_Catalog__c
                WHERE CSS_WS_FailMode__c != null AND CSS_WS_Active__c =: 'Y' ORDER BY CSS_WS_FailMode__c LIMIT 999];
            if(failModes.size() > 0){
                for(CSS_WS_Fail_Mode_Catalog__c failMode: failModes){
                    Options.add(new SelectOption(failMode.CSS_WS_FailMode__c + '&' + failMode.CSS_WS_Name__c, String.valueof(failMode.CSS_WS_FailMode__c + ' - ' + failMode.CSS_WS_Name__c).abbreviate(this.AbbreviateNumber)));
                }
            }
            failModes = null;
            Options.sort();
            return Options;
        }
        set;
    }
    
    Public Integer ValidateDuplicatedFailureCodes(){
        Integer Duplicated = 0;
        Integer FailureListSize = this.FailureList.size();
        for(Integer i = 0; i < FailureListSize; i++){
            for(Integer j = 0; j < FailureListSize; j++){
                String ActualCode = this.FailureList[j].Failure.CSS_WS_EngineSystemCode__c + this.FailureList[j].Failure.CSS_WS_ComponentCode__c;
                String CompareWithThisCode = this.EngineSystemCode + this.ComponentCode;
                if(ActualCode == CompareWithThisCode){
                    Duplicated ++;
                }
            }
        }
        return Duplicated;
    }
    
    Public Void ClassIni(){
        try{
            this.FailureList = new List<CreateNewFailure>();
            Decimal IsClaimCloned = 0;
            if(this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c == '0 - Not consumed'){
                this.CallWSToGetGSQFailure();
            }
            //system.debug('GSQ Failure Flag: ' + this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c);
            //system.debug('GSQ Failure Response: ' + this.GSQFailureResponse);
            
            if(this.ActualClaim.id != null){
                IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id].Is_Clone__c;
            }
            if(this.ActualClaim.id != null && IsClaimCloned != 1){
                List<CSS_WS_Failure__c> SavedFailures = [SELECT CSS_WS_ComponentCode__c, CSS_WS_EngineSystem__c, CSS_WS_EngineSystemCode__c, CSS_WS_FailureModeCode__c,
                    CSS_WS_ComponentName__c, CSS_WS_FailureModeName__c, CSS_WS_Failure_ID__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];            
                if(SavedFailures.size() > 0){
                    this.CanAddFailure = true;
                    for(Integer i = 0; i < SavedFailures.size(); i++){
                        this.EngineSystemSelectListValue = SavedFailures[i].CSS_WS_EngineSystemCode__c + '&' + SavedFailures[i].CSS_WS_EngineSystem__c;
                        this.ComponentSelectListValue = SavedFailures[i].CSS_WS_ComponentCode__c + '&' + SavedFailures[i].CSS_WS_ComponentName__c;
                        this.FailureModeSelectListValue = SavedFailures[i].CSS_WS_FailureModeCode__c + '&' + SavedFailures[i].CSS_WS_FailureModeName__c;
                        this.FailureID = SavedFailures[i].CSS_WS_Failure_ID__c;
                        this.AddNewFailure();
                    } 
                }            
                this.CanAddFailure = (String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c)) ? true : false;
                this.EngineSystemSelectListValue = '';
                this.ComponentSelectListValue = '';
                this.FailureModeSelectListValue = ''; 
                this.FailureID = '';           
                this.SetComponentList();
            }
        } catch(Exception e) {
            System.debug('Error adding: ' + e.getMessage());
            System.debug('Claim: ' + JSON.serialize(this.ActualClaim));
        }
    }
    
    Public Void SetComponentList(){
        List<selectOption> Options = new List<selectOption>();
        Options.add(new SelectOption('',Label.CSS_WS_Selection_None));
        String StringToSplit = this.EngineSystemSelectListValue;
        String[] ValuesFromSplit;
        if(StringToSplit != null){
            if(StringToSplit.contains('&')){
                ValuesFromSplit = StringToSplit.split('&');
            }
        }
        if(ValuesFromSplit != null) {
            CSS_WS_Failure_Master__c [] failures;
            if(this.ActualClaim.CSS_WS_Engine_Family_Code__c != null){//Rule SF14 and SF68
                failures = [SELECT ID, Engine_Component_Code__c, Engine_Component_Code_Description__c
                    FROM CSS_WS_Failure_Master__c WHERE Engine_System_Code__c = :ValuesFromSplit[0] AND Engine_Component_Code__c != ''
                    AND Engine_Component_Code_Description__c != '' AND (Engine_Family_Code__c =: this.ActualClaim.CSS_WS_Engine_Family_Code__c 
                    OR Engine_Family_Code__c ='') ORDER BY Engine_Component_Code__c LIMIT 999];
            } else {
                failures = [SELECT ID, Engine_Component_Code__c, Engine_Component_Code_Description__c
                    FROM CSS_WS_Failure_Master__c WHERE Engine_System_Code__c =: ValuesFromSplit[0] AND Engine_Component_Code__c != ''
                    AND Engine_Component_Code_Description__c != '' ORDER BY Engine_Component_Code__c LIMIT 999];
            }
            Map<String, CSS_WS_Failure_Master__c> mapComponentBySC = new Map<String, CSS_WS_Failure_Master__c>();
            if(failures.size() > 0){
                for(CSS_WS_Failure_Master__c failure : failures){
                    mapComponentBySC.put(failure.Engine_Component_Code__c, failure);//Delete the repeated elements
                }
                
                // Determine the list of Component Codes to display
                if(this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c == '1 - Consumed with proper response' && GSQFailureResponse != null){ // the value of this flag means that we have data from GSQ Failures
                    Map<String, String> mapGSQFailureComponent = new Map<String, String>();
                    if(GSQFailureResponse.Header.MessageType.touppercase() == 'S'){
                        if(GSQFailureResponse.DataArea != null){
                            for(integer i=0; i< GSQFailureResponse.DataArea.size(); i++) {
                                if (GSQFailureResponse.DataArea[i].SystemCode == ValuesFromSplit[0]){
                                    mapGSQFailureComponent.put(GSQFailureResponse.DataArea[i].ComponentCode, GSQFailureResponse.DataArea[i].ComponentCode); // get list of unique component codes from GSQ Failure 
                                }
                            }
                        }             
                    }  
                    //system.debug('mapComponentBySC: ' + mapComponentBySC);
                    //system.debug('mapGSQFailureComponent: ' + mapGSQFailureComponent);  
                                   
                    /*for(String component_code : mapGSQFailureComponent.keySet()){
                        if (mapComponentBySC.get(component_code) != null){
                            Options.add(new SelectOption(mapComponentBySC.get(component_code).Engine_Component_Code__c + '&' + mapComponentBySC.get(component_code).Engine_Component_Code_Description__c, 
                                String.valueof(mapComponentBySC.get(component_code).Engine_Component_Code__c + ' - ' + mapComponentBySC.get(component_code).Engine_Component_Code_Description__c).abbreviate(this.AbbreviateNumber))); // create list of Component Codes to display in dropdwon
                        } else {
                            // Values for GSQ failure when these are not into local catalogue 
                            Options.add(new SelectOption(mapGSQFailureComponent.get(component_code) + '&' + mapGSQFailureComponent.get(component_code), 
                                String.valueof(mapGSQFailureComponent.get(component_code) + ' - ' + mapGSQFailureComponent.get(component_code)).abbreviate(this.AbbreviateNumber))); 
                        }
                    } */
                    for(String component_code : mapComponentBySC.keySet()){
                        Options.add(new SelectOption(mapComponentBySC.get(component_code).Engine_Component_Code__c + '&' + mapComponentBySC.get(component_code).Engine_Component_Code_Description__c, 
                                String.valueof(mapComponentBySC.get(component_code).Engine_Component_Code__c + ' - ' + mapComponentBySC.get(component_code).Engine_Component_Code_Description__c).abbreviate(this.AbbreviateNumber))); // create list of Component Codes to display in dropdwon
                    }  
                    for(String component_code : mapGSQFailureComponent.keySet()){
                        if (mapComponentBySC.get(component_code) == null){
                            // Values for GSQ failure when these are not into local catalogue 
                            Options.add(new SelectOption(mapGSQFailureComponent.get(component_code) + '&' + mapGSQFailureComponent.get(component_code), 
                                String.valueof(mapGSQFailureComponent.get(component_code) + ' - ' + mapGSQFailureComponent.get(component_code)).abbreviate(this.AbbreviateNumber))); 
                        }
                    }                  
                } else {    // we don't have values from GSQ failure, so the options from failure catalogue are displayed           
                    for(CSS_WS_Failure_Master__c failure : mapComponentBySC.values()){
                        if(mapComponentBySC.size()>= 999){
                            break;
                        }
                        Options.add(new SelectOption(String.valueof(failure.Engine_Component_Code__c + '&' + failure.Engine_Component_Code_Description__c),
                                                     String.valueof(failure.Engine_Component_Code__c + ' - ' + failure.Engine_Component_Code_Description__c).abbreviate(this.AbbreviateNumber)));
                    }               
                }
                /*for(CSS_WS_Failure_Master__c failure : mapComponentBySC.values()){
                    if(mapComponentBySC.size()>= 999){
                        break;
                    }
                    Options.add(new SelectOption(String.valueof(failure.Engine_Component_Code__c + '&' + failure.Engine_Component_Code_Description__c),
                                                 String.valueof(failure.Engine_Component_Code__c + ' - ' + failure.Engine_Component_Code_Description__c).abbreviate(this.AbbreviateNumber)));
                }*/
            }           
        }
        Options.sort();
        this.GetComponentList = Options;
    }
    
    Public Void SetNameAndCodeOfFailure(){
        List<String> WhatISet = new List<String> {'failure', 'mode', 'component'};
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        for(Integer i = 0; i < WhatISet.size(); i++){
            if(WhatISet[i] == 'failure'){
                if(this.EngineSystemSelectListValue != '' && this.EngineSystemSelectListValue!= null){
                    String StringToSplit = this.EngineSystemSelectListValue;
                    if(StringToSplit.contains('&')){
                        String[] ValuesFromSplit = StringToSplit.split('&');
                        this.EngineSystemName = ValuesFromSplit[1];
                        this.EngineSystemCode = ValuesFromSplit[0];
                    }
                } else {
                    this.EngineSystemName = '';
                    this.EngineSystemCode = '';
                }
            }
            if(WhatISet[i] == 'mode'){
                if(this.FailureModeSelectListValue != '' && this.FailureModeSelectListValue != null){
                    String StringToSplit = this.FailureModeSelectListValue;
                    if(StringToSplit.contains('&')){
                        String[] ValuesFromSplit = StringToSplit.split('&');
                        this.FailureModeName = ValuesFromSplit[1];
                        this.FailureModeCode = ValuesFromSplit[0];
                    }
                } else {
                    this.FailureModeName = '';
                    this.FailureModeCode = '';
                }
            }
            if(WhatISet[i] == 'component'){
                if(this.ComponentSelectListValue != '' && this.ComponentSelectListValue != null){
                    String StringToSplit = this.ComponentSelectListValue;
                    if(StringToSplit.contains('&')){
                        String[] ValuesFromSplit = StringToSplit.split('&');
                        this.ComponentName = ValuesFromSplit[1];
                        this.ComponentCode = ValuesFromSplit[0];
                    }
                } else {
                    this.ComponentName = '';
                    this.ComponentCode = '';
                }
            }
        }
        if(this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c == '1 - Consumed with proper response' && GSQFailureResponse != null){ // the value of this flag means that we have data from GSQ Failures
            if(GSQFailureResponse.Header.MessageType.touppercase() == 'S'){
                if(GSQFailureResponse.DataArea != null){
                    boolean failure_id_flag = false;
                    for(integer i=0; i< GSQFailureResponse.DataArea.size(); i++) {
                        if (GSQFailureResponse.DataArea[i].SystemCode == this.EngineSystemCode && GSQFailureResponse.DataArea[i].ComponentCode == this.ComponentCode){
                            this.FailureID = GSQFailureResponse.DataArea[i].FailureID;
                            failure_id_flag = true;
                        } 
                    }
                    if(!failure_id_flag){
                        this.FailureID = '';
                    }
                }             
            }                    
        }
    }
    
    Public Void AddNewFailure(){
        if(!String.isEmpty(this.EngineSystemSelectListValue) && !String.isEmpty(FailureModeSelectListValue) && !String.isEmpty(ComponentSelectListValue)){
            if(this.ActualClaim.CSS_WS_HasError__c == 1){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.ActualClaim.CSS_WS_HasMessage__c));
                return;
            }
            if(this.ActualClaim.CSS_WS_HasError__c == 2){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning, this.ActualClaim.CSS_WS_HasMessage__c));
            }
            this.SetNameAndCodeOfFailure();
            if(this.CanAddFailure == true || this.ActualClaim.CSS_WS_Reinstatement_Flag__c == true){ //Allow adding failure even if reinstatement claim with campaign is created. July 2nd 2018
                if(this.ValidateDuplicatedFailureCodes() == 0){//Rule SF15
                    if(this.FailureList.size() < 3){
                        if(this.FailuresWithError == 0){
                            if((this.ActualClaim.CSS_WS_Warranty_Type__c == 'Parte' && this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio' && this.FailureCounter == 0) || (this.ActualClaim.CSS_WS_Campaigns_TRPs__c != null && this.ActualClaim.CSS_WS_Campaigns_TRPs__c != '' && this.FailureCounter == 0 && this.ActualClaim.CSS_WS_Reinstatement_Flag__c == false)){ //allow deleting 1st failure for reinstatement claim with campaign. July 2nd 2018.
                                this.FailureList.add(new CreateNewFailure(this.FailureCounter++, this.EngineSystemCode, this.ComponentCode, this.FailureModeCode,
                                                                          this.EngineSystemName, this.FailureModeName, this.ComponentName, true, this.FailureID));
                            } else {
                                this.FailureList.add(new CreateNewFailure(this.FailureCounter++, this.EngineSystemCode, this.ComponentCode, this.FailureModeCode,
                                                                          this.EngineSystemName, this.FailureModeName, this.ComponentName, false, this.FailureID));  
                            }
                        }
                    } else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Failure_E004));//You cant add more than 3 Failures
                    }
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_Failure_E001));//Duplicated Fail code not allowed
                }
            } 
        }      
    }
    
    Public Void DeleteFailure(){
        Integer FailurePosToDelete = -1;
        Integer i = 0;
        Integer ListSize = this.FailureList.size();
        for(i = 0; i < ListSize; i++){
            if(this.FailureList[i].Index == this.FailureToDelete){
                FailurePosToDelete = i;
            }
        }
        if(FailurePosToDelete != -1){
            this.FailureList.remove(FailurePosToDelete);
        } 
        Integer ListSize_after = this.FailureList.size(); 
        if(ListSize_after == 0 && this.ActualClaim.CSS_WS_Policy_Flag__c == 'Warranty'){
            this.ActualClaim.CSS_WS_Account_Code__c = '';
            this.ActualClaim.CSS_WS_Other_Approver__c = '';
        } 
    }
    
    Public Void SaveFailures(){
        try{
            this.ListToInsert = new List<CSS_WS_Failure__c>();
            for(CreateNewFailure Failure : this.FailureList){
                System.Debug('Failure to insert: ' + JSON.serialize(Failure.Failure));
                if(Failure.Failure.CSS_WS_Warranty__c == null) Failure.Failure.CSS_WS_Warranty__c = this.ActualClaim.id;
                if(Failure.Failure.Id != null) Failure.Failure.Id = null;
                this.ListToInsert.add(Failure.Failure);
            }            
            if(this.FailuresWithError == 0){
                CSS_WS_Failure__c[] ListToRemove = [SELECT Id FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];
                if(ListToRemove.size() > 0){
                    delete ListToRemove;
                }
                System.Debug('List to insert: ' + JSON.serialize(this.ListToInsert));
                insert ListToInsert; 
                if(this.ActualClaim.CSS_WS_Policy_Flag__c == 'Policy WW'){              
                    String approver = this.ActualClaim.Other_Approver_Picklist_WW__c;
                    String[] ValuesFromSplit = approver.split('-');
                    this.ActualClaim.CSS_WS_Other_Approver__c = ValuesFromSplit[0];                 
                }
            }
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected Error, Please contact your System Administrator
            this.FailuresWithError++;
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    Public Void CallWSToGetAccCoverage(){
        if(this.ActualClaim.CSS_WS_Policy_Flag__c == 'Warranty'){ //Rule 1076
            try{
                this.FailuresWithError = 0;
                if(!String.isEmpty(this.EngineSystemCode) && !String.isEmpty(this.ComponentCode) ){
                    List<String> SystemAndComponentCode = new List<String>();
                    List<String> ListToAccCoverage = new List<String>();
                    String NewPartsWarrantyFlg = 'N', ReConPartsWarrantyFlg = 'N', RoadRelayWarrantyFlg = 'N';
                    String AccountCode = '';
                    CSS_WS_Warranty__c ApplicationCode = [SELECT CSS_WS_Engine_Application_Code__c FROM CSS_WS_Warranty__c WHERE id =: this.ActualClaim.Id];
                    String Campaign = (this.ActualClaim.CSS_WS_Campaigns_TRPs__c != null) ? this.ActualClaim.CSS_WS_Campaigns_TRPs__c : '';
                    
                    ListToAccCoverage.add(this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
                    ListToAccCoverage.add(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);  //spcode
                    ListToAccCoverage.add(CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                    ListToAccCoverage.add(String.valueOf(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c));
                    ListToAccCoverage.add(this.ActualClaim.CSS_WS_Failure_Measure__c);
                    ListToAccCoverage.add(ApplicationCode.CSS_WS_Engine_Application_Code__c);
                    ListToAccCoverage.add('');//Need Fault Code for Emission coverage check. Send blank 
                    ListToAccCoverage.add(CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Warranty_Start_Date__c , 'MM/dd/yyyy'));
                    ListToAccCoverage.add(Campaign);
                    if(this.ActualClaim.CSS_WS_Warranty_Type__c == 'Parte' || this.ActualClaim.CSS_WS_Warranty_Type__c == 'Part'){
                        if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo' || this.ActualClaim.CSS_WS_Claim_Type__c == 'New'){
                            NewPartsWarrantyFlg = 'Y';
                        } else if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon'){
                            ReConPartsWarrantyFlg = 'Y';
                        } else if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio' || this.ActualClaim.CSS_WS_Claim_Type__c == 'Road Relay'){
                            RoadRelayWarrantyFlg = 'Y';
                        }
                    }
                    ListToAccCoverage.add(NewPartsWarrantyFlg);   //new parts warranty flag
                    ListToAccCoverage.add(ReConPartsWarrantyFlg); //recon parts warranty flag
                    ListToAccCoverage.add(RoadRelayWarrantyFlg);  //road relay warranty flag
                    
                    if(this.ActualClaim.CSS_WS_Policy_Flag__c == 'Policy WW'){
                        AccountCode = this.ActualClaim.CSS_WS_Account_Code__c;
                    } else if(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'ReCon Engine') {
                        AccountCode = '98';
                    }   
                    if (this.ActualClaim.CSS_WS_Reinstatement_Flag__c){
                        AccountCode = '61';
                    }                 
                    ListToAccCoverage.add(AccountCode);
                    SystemAndComponentCode.add(this.EngineSystemCode + ',' + this.ComponentCode);
                    CSS_WS_J2A_GetAccountCoverage AccCoverageResponseLocal = CSS_WS_GetWebServiceData.getAccountCoverage(ListToAccCoverage, SystemAndComponentCode);
                    //Only First Failure CoverageResponse should be saved in Claim Object
                    if(this.FailureList.size() == 0){
                        this.AccCoverageResponse = AccCoverageResponseLocal;
                    }
                    if(AccCoverageResponseLocal != null){
                        if(AccCoverageResponseLocal.Header.Status.touppercase() == 'SUCCESS'){
                            if(AccCoverageResponseLocal.DataArea.Details[0].Status.touppercase() == 'ERROR'){
                                this.DisplayErrorHandler(AccCoverageResponseLocal.DataArea.Details[0].Message);
                                System.debug('Detail error: ' + AccCoverageResponseLocal.DataArea.Details[0].Message);
                                this.FailuresWithError++;
                                return;
                            } 
                            if(this.FailureList.size() > 0){
                                if(this.ActualClaim.CSS_WS_Account_Code__c != AccCoverageResponseLocal.DataArea.AccountCode){
                                    this.DisplayErrorHandler(Label.CSS_WS_Failure_E002);//This Failure can't be added because the account code is not the same than the first, please create other claim to add this failure.
                                    this.FailuresWithError++;
                                }
                            }
                            AccCoverageResponseLocal = null;
                        } else {
                            this.DisplayErrorHandler(AccCoverageResponseLocal.Header.ReturnCodeDescription);
                        }
                    } else {
                        //System.debug('AccCoverageResponseLocal: ' + JSON.serialize(AccCoverageResponseLocal));
                        this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error - Please contact your System Administrator
                        this.FailuresWithError++;
                    }
                } else {
                    this.FailuresWithError++;
                    //System.debug('Vacios');
                }
            } catch(Exception e) {
                this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error - Please contact your System Administrator
                //System.debug('Error trying to connect to the WS AccCoverageResponseLocal: ' + e.getMessage());
            }
        }
    }
    
    Public Void UpdateClaimWithResponse(){//Rule 1076
        try{
            if(this.ActualClaim.CSS_WS_HasError__c == 0){
                if(this.ActualClaim.CSS_WS_Policy_Flag__c == 'Warranty'){
                    if(this.FailureList.size() == 0 && this.FailuresWithError == 0 && (String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c) || this.ActualClaim.CSS_WS_Reinstatement_Flag__c == true)){ // Allow save coverage values for reinstatement claim with campaign. July 2nd 2018.
                        if( !String.isEmpty( this.AccCoverageResponse.DataArea.AccountCode ) )
                            this.ActualClaim.CSS_WS_Account_Code__c = this.AccCoverageResponse.DataArea.AccountCode;
                        if( !String.isEmpty( this.AccCoverageResponse.DataArea.AccountCodeType) )
                            this.ActualClaim.CSS_WS_Account_Code_Type__c = this.AccCoverageResponse.DataArea.AccountCodeType;
                        if( !String.isEmpty( this.AccCoverageResponse.DataArea.Details[0].SystemCode ) )
                            this.ActualClaim.CSS_WS_System_Code__c = this.AccCoverageResponse.DataArea.Details[0].SystemCode;
                        if( !String.isEmpty( this.AccCoverageResponse.DataArea.Details[0].ComponentCode  ) )
                            this.ActualClaim.CSS_WS_Component_Code__c = this.AccCoverageResponse.DataArea.Details[0].ComponentCode;                      
                        if( !String.isEmpty( this.AccCoverageResponse.DataArea.Details[0].CoveredLaborHrs ) )
                            this.ActualClaim.CSS_WS_Covered_Labor_Hours__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredLaborHrs);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredMealsLodgingAmt ) )
                            this.ActualClaim.CSS_WS_Covered_Meals_Lodging__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredMealsLodgingAmt);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredOCAmount ) )
                            this.ActualClaim.CSS_WS_Covered_OC_Amount__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredOCAmount);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredPartsQty ) )
                            this.ActualClaim.CSS_WS_Covered_Parts_Qty__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredPartsQty);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredTowingMiles ) )
                            this.ActualClaim.CSS_WS_Covered_Towing_Miles__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredTowingMiles);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredTravelLabor ) )
                            this.ActualClaim.CSS_WS_Covered_Travel_Labor__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredTravelLabor);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CoveredTravelMiles ) )
                            this.ActualClaim.CSS_WS_Covered_Travel_Miles__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CoveredTravelMiles);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].DeductibleAmount ) )
                            this.ActualClaim.CSS_WS_Deductible_Amount__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].DeductibleAmount);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CampaignLaborPercentage ) )
                            this.ActualClaim.CSS_WS_Campaign_Labor_Percentage__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CampaignLaborPercentage);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CampaignOCPercentage ) )
                            this.ActualClaim.CSS_WS_Campaign_OC_Percentage__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CampaignOCPercentage);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CampaignPartsPercentage ) )
                            this.ActualClaim.CSS_WS_Campaign_Parts_Percentage__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CampaignPartsPercentage);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CampaignTowingPercentage ) )
                            this.ActualClaim.CSS_WS_Campaign_Towing_Percentage__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CampaignTowingPercentage);
                        if( !String.isEmpty(this.AccCoverageResponse.DataArea.Details[0].CampaignTravelPercentage ) )
                            this.ActualClaim.CSS_WS_Campaign_Travel_Percentage__c = integer.valueof(this.AccCoverageResponse.DataArea.Details[0].CampaignTravelPercentage);
                        this.ActualClaim.CSS_WS_WarrantyId__c = this.AccCoverageResponse.DataArea.Details[0].WarrantyId;
                        String certificateNumber = this.AccCoverageResponse.DataArea.Details[0].CertificateNumber;
                        String certificateNumberId = '';
                        if(certificateNumber != null && certificateNumber.contains('-')){
                            String[] ValuesFromSplit = certificateNumber.split('-');
                            if( ValuesFromSplit != null){
                                certificateNumber = ValuesFromSplit[0];
                                certificateNumberId = ValuesFromSplit[1];
                            }
                        }
                        this.ActualClaim.CSS_WS_Certificate_Number__c = certificateNumber ;
                        this.ActualClaim.CSS_WS_Certificate_Number_Id__c = certificateNumberId;
                        Date failureDate = this.ActualClaim.CSS_WS_Failure_Date_Time__c.date();
                        
                        if (this.ActualClaim.CSS_WS_Reinstatement_Flag__c == false){                                                
                            //New parts from stock Account Code and Possession Flag logic 18/10/2016
                            if( this.ActualClaim.CSS_WS_Failure_Point_Quantity__c != null){
                                if(this.ActualClaim.CSS_WS_Warranty_Type__c == 'Parte'){
                                    if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo'){
                                        if(this.ActualClaim.CSS_WS_Warranty_Start_Date__c == failureDate && Integer.valueof(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c) == 0){
                                            this.ActualClaim.CSS_WS_Account_Code__c = '35';
                                            this.ActualClaim.CSS_WS_Possession_Flag__c = 'N';
                                        }
                                        if(this.ActualClaim.CSS_WS_Warranty_Start_Date__c != failureDate || Integer.valueof(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c) != 0){
                                            this.ActualClaim.CSS_WS_Account_Code__c = '62';
                                            this.ActualClaim.CSS_WS_Possession_Flag__c = 'Y';
                                        }
                                    }
                                    if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon'){
                                        if(this.ActualClaim.CSS_WS_Warranty_Start_Date__c == failureDate && Integer.valueof(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c) == 0){
                                            this.ActualClaim.CSS_WS_Account_Code__c = '41';
                                            this.ActualClaim.CSS_WS_Possession_Flag__c = 'N';
                                        }
                                        if(this.ActualClaim.CSS_WS_Warranty_Start_Date__c != failureDate || Integer.valueof(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c) != 0){
                                            this.ActualClaim.CSS_WS_Account_Code__c = '97';
                                            this.ActualClaim.CSS_WS_Possession_Flag__c = 'Y';
                                        }
                                    }
                                }
                            } 
                        
                            //Pay Code Logic when No Pay Code is returned 17/10/2016
                            Date firstFailDate = system.today();
                            if (failureDate.daysBetween(firstFailDate) < 120){
                                if(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c == this.ActualClaim.CSS_WS_Service_Provider_DR__c){
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'I';
                                } else{
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'R';
                                }       
                            } else if((failureDate.daysBetween(firstFailDate) >= 120)  &&  (failureDate.daysBetween(firstFailDate) < 180)){
                                if(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c == this.ActualClaim.CSS_WS_Service_Provider_DR__c){
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'T';
                                } else{
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'C';
                                }       
                            } else if((failureDate.daysBetween(firstFailDate) >= 180)  &&  (failureDate.daysBetween(firstFailDate) < 365)){
                                if(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c == this.ActualClaim.CSS_WS_Service_Provider_DR__c){
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'S';
                                } else{
                                    this.ActualClaim.CSS_WS_Pay_Code__c = 'L';
                                }       
                            } else if(failureDate.daysBetween(firstFailDate) >= 365){
                                this.ActualClaim.CSS_WS_Pay_Code__c = 'A';    
                            } 
                        }
                        
                        //if(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'ReCon Engine' && this.ActualClaim.CSS_WS_Policy_Flag__c == 'Warranty' && this.ActualClaim.CSS_WS_Reinstatement_Flag__c == false){
                        //    this.ActualClaim.CSS_WS_Account_Code__c = '98';
                        //}
                        //Assign value of Other Approver if Account_Code is "35" or "52" for Warranty claim
                        if(this.ActualClaim.CSS_WS_Account_Code__c == '35'){
                            this.ActualClaim.CSS_WS_Other_Approver__c = 'T72';
                        } else if(this.ActualClaim.CSS_WS_Account_Code__c == '52'){
                            this.ActualClaim.CSS_WS_Other_Approver__c = 'A57';
                        } else if(this.ActualClaim.CSS_WS_Account_Code__c != '61'){    
                            this.ActualClaim.CSS_WS_Other_Approver__c = '';
                        }                       
                        update this.ActualClaim;
                    }
                }
            }   
        } catch(Exception e) {
            this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error - Please contact your System Administrator
            //System.debug('Error in UpdateClaimWithResponse: ' + e.getMessage());
        }  
    }
    
    Public Void FailureCallWSODM(){
        if(this.ActualClaim.CSS_WS_HasError__c == 0){
            if(this.ActualClaim.CSS_WS_Policy_Flag__c=='Warranty'){
                try{
                    CSS_WS_Warranty__c claimData = [
                        SELECT CSS_WS_Pay_Code__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c,
                        CSS_WS_Marine_Application_Flag__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c,
                        CSS_WS_Account_Code_Type__c, CSS_WS_InShopCampaignFlag__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
                    Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c); 
                    Map<String, String> header = new Map<String,String>{};  
                    header.put('bisFlag',(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                    header.put('cmiEngineSerialNumber',this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
                    header.put('cmiServiceProviderCode',this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                    header.put('engineFamily',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                    header.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                    header.put('failureMeasure',this.ActualClaim.CSS_WS_Failure_Measure__c);
                    header.put('failurePoint',this.ActualClaim.CSS_WS_Failure_Point_Quantity__c);
                    header.put('manualAdjudicationFlag','');
                    header.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    header.put('productApplicationCode',claimData.CSS_WS_Product_Application_Code__c);
                    header.put('roNumber',this.ActualClaim.CSS_WS_Repair_Work_Order_Number__c);
                    header.put('serviceModelName',this.ActualClaim.CSS_WS_Service_Model__c);
                    header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Warranty_Start_Date__c, 'MM/dd/yyyy'));
                    header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                    header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
                    header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                    header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                    header.put('outfileAllClaimsFlag','Y');
                    header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                    header.put('engineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
                    header.put('marineFlag',(claimData.CSS_WS_Marine_Application_Flag__c!=null)?claimData.CSS_WS_Marine_Application_Flag__c:'');
                    header.put('buildDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Build_Date__c, 'MM/dd/yyyy'));
                    header.put('etoConversionDate',CSS_WS_ControllerClaim.dateToString(claimData.CSS_WS_Engine_Trade_Out_conversion_date__c, 'MM/dd/yyyy'));
                    header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c == true)? 'Y' : 'N');
                    header.put('productApplicationDesp',(claimData.CSS_WS_Product_Application_Description__c!=null)?claimData.CSS_WS_Product_Application_Description__c:'');
                    if(this.ActualClaim.CSS_WS_Account_Code__c == '61'){
                        header.put('reconPartsWarrantyFlag','N');
                        header.put('newPartsWarrantyFlag','N');
                        header.put('roadRelayWarrantyFlag','N');
                    } else {
                        header.put('reconPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N');
                        header.put('newPartsWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo') ? 'Y' : 'N');
                        header.put('roadRelayWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                    }
                    header.put('engineApplicationCode',this.ActualClaim.CSS_WS_Engine_Application_Code__c);
                    //header.put('roadRelayWarrantyFlag',(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio') ? 'Y' : 'N');
                    
                    List<Map<String, String>> failure = new List<Map<String, String>> ();
                    Map<String, String> failureData = new Map<String,String>{};
                    failureData.put('campaignId',(String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c)) ? '' : this.ActualClaim.CSS_WS_Campaigns_TRPs__c);
                    failureData.put('payCode',(String.isEmpty(claimdata.CSS_WS_Pay_Code__c)) ? '' : claimdata.CSS_WS_Pay_Code__c);
                    failureData.put('totalLaborAmt','');
                    failureData.put('authorizationNumber',(this.ActualClaim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.ActualClaim.CSS_Authorization_Number__c):'');
                    failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                    failureData.put('totalTowingAmt','');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);
                    failureData.put('failCode',EngineSystemCode + ComponentCode);
                    failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('failMode',FailureModeCode);
                    failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                    failureData.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);   
                    failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');
                    failure.add(failureData);
                    
                    CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationFailure(header, failure);
                    if(ODMResponse != null){
                        if(ODMResponse.Response.claim.status.touppercase()=='ERROR'){
                            for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                if(ODMResponse.Response.claim.messages[i].type != null){
                                    if(ODMResponse.Response.claim.messages[i].type.touppercase() == 'ERROR'){
                                        this.DisplayErrorHandler(ODMResponse.Response.claim.messages[i].description);
                                    }
                                } else {
                                    this.DisplayErrorHandler(ODMResponse.Response.claim.messages[i].description);
                                }
                            }
                            
                            ODMResponse = null;
                        } else if(ODMResponse.Response.claim.status.touppercase() == 'WARNING'){
                            for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                this.ActualClaim.CSS_WS_HasError__c = 2;
                                this.ActualClaim.CSS_WS_HasMessage__c = ODMResponse.Response.claim.messages[i].description;
                            }                          
                        }
                        // Update PayCode when the ODM response is different than calculated PayCode value - Apr 3rd 2019
                        if(ODMResponse != null){
                            if(ODMResponse.Response.claim.status.touppercase()!='ERROR'){
                                if( !String.isEmpty(ODMResponse.Response.claim.failure.payCode) ){
                                    if (this.ActualClaim.CSS_WS_Pay_Code__c != ODMResponse.Response.claim.failure.payCode){
                                        this.ActualClaim.CSS_WS_Pay_Code__c = ODMResponse.Response.claim.failure.payCode;
                                    }
                                }
                            }
                        }                        
                    } else {
                        this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        System.debug('ODMResponse is null');
                    }
                } catch(System.Exception e) {
                    this.DisplayErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                    System.Debug(e.getMessage());
                }
            } 
        }
    }
    
    Public Void validateFailure(){
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        if(this.FailureList.size() == 0){
            this.DisplayErrorHandler(Label.CSS_WS_Failure_E003);//Please add at least 1 Failure
        }
    }
    
    Public Void DisplayErrorHandler(String MsgError){
        this.FailuresWithError++;
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = MsgError;
    }
    
    Public Void CallWSToGetGSQFailure(){
        Try{    
            Map<String, String> GSQFailureRequest = new Map<String,String>{};                                
            GSQFailureRequest.put('ServiceModelName',this.ActualClaim.CSS_WS_Service_Model__c);
            GSQFailureRequest.put('LanguageCode','en');
            GSQFailureRequest.put('EngineFamilyCode',this.ActualClaim.CSS_WS_Engine_Family_Code__c);
        
            CSS_WS_J2A_GetGSQFailure GSQFailureResponseLocal = CSS_WS_GetWebServiceData.getGSQFailure(GSQFailureRequest);
            
            if(GSQFailureResponseLocal == null){
                this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c = '3 - Consumed with null response';
            } else if(GSQFailureResponseLocal.Header.MessageType != null){
                if(GSQFailureResponseLocal.Header.MessageType.touppercase() == 'S'){
                    this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c = '1 - Consumed with proper response';
                    this.GSQFailureResponse = GSQFailureResponseLocal;
                } else if(GSQFailureResponseLocal.Header.MessageType.touppercase() == 'E'){
                    this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c = '2 - Consumed with error response';
                }
            } 
        } catch(Exception e) {
            this.ActualClaim.CSS_WS_GSQ_Failure_Flag__c = '4 - Consumed with exception';
            System.debug('Exception error trying to get GSQ Faulure data: ' + e.getMessage());
        }
    }
            
}