Public Class CSS_WS_DynamicMultiESNController{
    
    Public CSS_WS_Warranty__c ActualClaim { get; set; }
    Public transient List<CSS_WS_MultiESN__c> ListToInsert = new List<CSS_WS_MultiESN__c>();
    Public List<CreateNewESN> ESNsList { get; set; }
    Public Integer ESNToDelete { get; set; }
    Public Integer PositionOfThisESN { get; set; }
    Public Integer ESNsWithError = 0;
    Public Integer ESNCounter = 0;
    Public Boolean EditWADEditable = true; 
    Public String ActualFamilyCode { get; set; }
    Public String SearchWithThisESN { get; set; }
    Public String BISValue = '';
    Public String Detail = '';
    Public String ECMCalibrationBefore = '';
    Public String RevisionoBefore = '';
    Public String ECMCalibrationAfter = '';
    Public String RevisionoAfter = '';
    Public String MultiESN = '';
    Public String FailurePointType = '';
    public String EngineFamilyCode = '';
    Public String ProductApplicationCode = '';
    Public String ServiceModel = '';
    Public String FailurePoint = '';
    Public String UOMFail = '';
    Public Date WarrantyStartDate = null;
    Public Datetime FailureDate = null; 
    
    Public CSS_WS_DynamicMultiESNController(ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_DynamicMultiESNController ****** CSS_WS_DynamicMultiESNController');
        this.ActualClaim = (CSS_WS_Warranty__c)controller.getRecord();
        this.BISValue = (this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'BIS' : '';
        this.LoadPreviousESNs();
    }
    
    Public Class CreateNewESN{
        Public CSS_WS_MultiESN__c ESN {get; set;}
        Public Integer Index {get; set;}
        Public Boolean ValidationFlag {get; set;}
        Public Boolean WADEditable {get; set;}
        Public CreateNewESN(Integer Index, Boolean WADEditable){
            this.Index = Index;
            this.ESN = new CSS_WS_MultiESN__c();
        }
    }
    
    Public Void LoadPreviousESNs(){
        Decimal IsClaimCloned = 0;
        if(this.ActualClaim.id != null){
            IsClaimCloned = [SELECT Is_Clone__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id].Is_Clone__c;
        }
        if(this.ActualClaim.id != null && IsClaimCloned != 1){
            transient List<CSS_WS_MultiESN__c> SavedESNs = [
                SELECT CSS_WS_BIS_2__c, CSS_WS_Detail__c, CSS_WS_ESNCalibrationStart__c, CSS_WS_ESNCalibrationEnd__c, CSS_WS_MultiESN__c,
                CSS_WS_FailureDate__c, CSS_WS_FailurePointType__c, CSS_WS_FailurePoint__c, CSS_WS_WarrantyStartDate__c,
                CSS_WS_EngineFamilyCode__c, CSS_WS_ProductApplicationCode__c, CSS_WS_ServiceModel__c, CSS_WS_Revision_Before__c, CSS_WS_Revision_After__c
                FROM CSS_WS_MultiESN__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];
            this.ActualFamilyCode = this.ActualClaim.CSS_WS_Engine_Family_Code__c;
            Integer SavedESNsSize = SavedESNs.size();
            if(SavedESNsSize > 0){
                this.ESNsList = new List<CreateNewESN>();
                for(Integer i = 0; i < SavedESNsSize; i++){
                    this.BISValue = SavedESNs[i].CSS_WS_BIS_2__c;
                    if(this.BISValue == 'BIS'){//Rule SF12
                        EditWADEditable =  false;
                    } else {
                        EditWADEditable = true;
                    }
                    this.Detail = SavedESNs[i].CSS_WS_Detail__c;
                    this.ECMCalibrationBefore = SavedESNs[i].CSS_WS_ESNCalibrationStart__c;
                    this.ECMCalibrationAfter = SavedESNs[i].CSS_WS_ESNCalibrationEnd__c;
                    this.RevisionoBefore = SavedESNs[i].CSS_WS_Revision_Before__c;
                    this.RevisionoAfter = SavedESNs[i].CSS_WS_Revision_After__c;
                    this.MultiESN = SavedESNs[i].CSS_WS_MultiESN__c;
                    this.FailureDate = SavedESNs[i].CSS_WS_FailureDate__c;
                    this.FailurePointType = SavedESNs[i].CSS_WS_FailurePointType__c;
                    this.FailurePoint = SavedESNs[i].CSS_WS_FailurePoint__c;
                    this.WarrantyStartDate = SavedESNs[i].CSS_WS_WarrantyStartDate__c;
                    this.EngineFamilyCode = SavedESNs[i].CSS_WS_EngineFamilyCode__c;
                    this.ProductApplicationCode = SavedESNs[i].CSS_WS_ProductApplicationCode__c;
                    this.ServiceModel = SavedESNs[i].CSS_WS_ServiceModel__c;
                    this.AddNewESN();
                }
            } else {
                this.ESNsList = new List<CreateNewESN>();
                CreateNewESN NewESN = new CreateNewESN(this.ESNCounter++, EditWADEditable);//Rule SF35
                NewESN.ESN.CSS_WS_BIS_2__c = this.BISValue;
                this.ESNsList.add(NewESN);
            }
        }
    }
    
    Public Void SetDefaultValues(){
        this.BISValue = (this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'BIS' : '';
        if(this.BISValue == 'BIS'){//Rule SF12
            EditWADEditable = false;
        } else {
            EditWADEditable = true;
        }
        this.Detail = '';
        this.ECMCalibrationBefore = '';
        this.ECMCalibrationAfter = '';
        this.RevisionoBefore = '';
        this.RevisionoAfter = '';
        this.MultiESN = '';
        this.FailureDate = null;
        this.FailurePointType = '';
        this.FailurePoint = '';
        this.UOMFail = '';
        this.EngineFamilyCode = '';
        this.ProductApplicationCode = '';
        this.ServiceModel = '';
        this.WarrantyStartDate = null;
    }
    
    Public Void AddNewESN(){
        CreateNewESN NewESN = new CreateNewESN(this.ESNCounter++, EditWADEditable);//Rule SF35
        NewESN.ESN.CSS_WS_BIS_2__c = this.BISValue;
        NewESN.ESN.CSS_WS_Detail__c = this.Detail;
        NewESN.ESN.CSS_WS_ESNCalibrationStart__c = this.ECMCalibrationBefore;
        NewESN.ESN.CSS_WS_ESNCalibrationEnd__c = this.ECMCalibrationAfter;
        NewESN.ESN.CSS_WS_Revision_Before__c = this.RevisionoBefore;
        NewESN.ESN.CSS_WS_Revision_After__c = this.RevisionoAfter;
        NewESN.ESN.CSS_WS_MultiESN__c = this.MultiESN;
        NewESN.ESN.CSS_WS_FailureDate__c = this.FailureDate;
        NewESN.ESN.CSS_WS_FailurePointType__c = this.FailurePointType;
        NewESN.ESN.CSS_WS_FailurePoint__c = this.FailurePoint;
        NewESN.ESN.CSS_WS_WarrantyStartDate__c = this.WarrantyStartDate; 
        NewESN.ESN.CSS_WS_EngineFamilyCode__c = this.EngineFamilyCode;
        NewESN.ESN.CSS_WS_ProductApplicationCode__c = this.ProductApplicationCode;
        NewESN.ESN.CSS_WS_ServiceModel__c = this.ServiceModel;
        this.ESNsList.add(NewESN);
        this.SetDefaultValues();
    }
    
    Public Void DeleteESN(){
        Integer ESNPosToDelete = -1;
        Integer i = 0;
        Integer ListSize = this.ESNsList.size();
        for(i = 0; i < ListSize; i++){
            if(this.ESNsList[i].Index == this.ESNToDelete){
                ESNPosToDelete = i;
            }
        }
        if(ESNPosToDelete != -1){
            this.ESNsList.remove(ESNPosToDelete);
        }
    }
    
    Public Void SaveMultiESNs(){
        try{
            this.ListToInsert = new List<CSS_WS_MultiESN__c>();
            this.ActualClaim.CSS_WS_HasError__c = 0;
            this.ActualClaim.CSS_WS_HasMessage__c = '';
            this.ValidateIfESNsAreCorrect();
            if(this.ActualClaim.CSS_WS_HasError__c == 0){
                transient CSS_WS_MultiESN__c[] ListToRemove = [SELECT Id FROM CSS_WS_MultiESN__c WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id];
                if(ListToRemove.size() > 0){
                    delete ListToRemove;   
                }
                for(CSS_WS_MultiESN__c tem: this.ListToInsert){
                    if(tem.CSS_WS_FailurePoint__c == null){
                        this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E018 + ' ESN ' + tem.CSS_WS_MultiESN__c);////Failure Point Quantity should not be empty ESN
                        break;
                    }
                    if(tem.CSS_WS_ESNCalibrationStart__c != null || tem.CSS_WS_ESNCalibrationEnd__c != null || tem.CSS_WS_Revision_Before__c != null || tem.CSS_WS_Revision_After__c != null){
                        if(tem.CSS_WS_ESNCalibrationStart__c == null){
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E011 + ' ESN ' + tem.CSS_WS_MultiESN__c);//ECM Calibration Before should not be empty ESN
                            break;
                        } else if(tem.CSS_WS_Revision_Before__c == null){
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E074 + ' ESN ' + tem.CSS_WS_MultiESN__c);//Revision Before should not be empty ESN
                            break;
                        } else if(tem.CSS_WS_ESNCalibrationEnd__c == null){
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E010 + ' ESN ' + tem.CSS_WS_MultiESN__c);//ECM Calibration After should not be empty ESN
                            break; 
                        } else if(tem.CSS_WS_Revision_After__c == null){
                            this.DisplayAsincErrorHandler(Label.CSS_WS_Claim_E073 + ' ESN ' + tem.CSS_WS_MultiESN__c);//Revision After should not be empty ESN
                            break;
                        }
                    }
                    insert tem;
                }
                this.ActualClaim.CSS_WS_ESN_Count__c = String.valueOf(this.ListToInsert.size());
                upsert this.ActualClaim;
            }
        } catch(Exception e) {
            this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
        }
    }
    
    Public Void ValidateIfESNsAreCorrect(){
        List<String> ListToValidateESNs = new List<String>();
        String ESNInfoToSend = '';
        for(CreateNewESN esn : this.ESNsList){
            if(!String.isEmpty(esn.ESN.CSS_WS_MultiESN__c)){
                esn.ESN.Id = null;
                if(String.IsEmpty(esn.ESN.CSS_WS_Warranty__c) == true) esn.ESN.CSS_WS_Warranty__c = this.ActualClaim.id;
                ESNInfoToSend = esn.ESN.CSS_WS_MultiESN__c + ',' + CSS_WS_ControllerClaim.dateToString(esn.ESN.CSS_WS_FailureDate__c, 'dd-MMM-yy');
                ListToValidateESNs.add(ESNInfoToSend);
                this.ListToInsert.add(esn.ESN);
            }
        }
        if(String.IsEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c) == false){
            this.MultiESNCallWSToValidateESNs(ListToValidateESNs);
            if(this.ActualClaim.CSS_WS_HasError__c == 0){
                this.MultiESNCallWSToGetAccCoverage();
            }
        } else {
            this.MultiESNCallWSToGetEngineData();
        } 
        if(this.ActualClaim.CSS_WS_HasError__c == 0){
            this.MultiESNCallWSODM();
        }
    }
    
    Public CSS_WS_Engine_Application_Code__c getEngineApplication(String engineApplicationCodeStr){
        try {
            System.debug(engineApplicationCodeStr);
            CSS_WS_Engine_Application_Code__c engineApplicationCode = [
                SELECT Name, Application_Description__c, Default_Measurement__c, Automotive_Flag__c, Marine_Flag__c
                FROM CSS_WS_Engine_Application_Code__c WHERE Name = :engineApplicationCodeStr];
            System.debug(engineApplicationCode.Name);
            return engineApplicationCode;
        } catch (Exception e){
            return null;
        }
    }
    
    Public Void MultiESNCallWSToGetEngineData(){
        for(Integer i = 0; i < this.ESNsList.size(); i++){
            if(this.ESNsList[i].Index == this.PositionOfThisESN){
                if(this.ESNsList[i].ESN.CSS_WS_MultiESN__c.isNumeric() && this.ESNsList[i].ESN.CSS_WS_MultiESN__c.length()==8){
                    transient CSS_WS_J2A_GetEngineData EngineDataResponse = CSS_WS_GetWebServiceData.getEngineData(this.ESNsList[i].ESN.CSS_WS_MultiESN__c);
                    if(EngineDataResponse !=null ){
                        if(EngineDataResponse.Header.Status.touppercase()=='SUCCESS'){
                            if(!String.isEmpty(EngineDataResponse.DataArea.EngineFamilyCode)){//Rule SF70
                                if(this.ActualFamilyCode != EngineDataResponse.DataArea.EngineFamilyCode){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_MultiESN_E001));
                                    this.ESNsList[i].ESN.CSS_WS_MultiESN__c = '';
                                    break;
                                }
                            }
                            if(!String.isEmpty(EngineDataResponse.DataArea.ServiceModelName)){//Rule SF70
                                if(EngineDataResponse.DataArea.ServiceModelName != this.ActualClaim.CSS_WS_Service_Model__c){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_MultiESN_E002));
                                    this.ESNsList[i].ESN.CSS_WS_MultiESN__c = '';
                                    break;
                                }
                            }
                            this.ESNsList[i].ESN.CSS_WS_BIS_2__c = 'BIS';
                            if(EngineDataResponse.DataArea.WarrantyStartDate != '' && EngineDataResponse.DataArea.WarrantyStartDate != null){
                                this.ESNsList[i].WADEditable = true;
                                Date warrantyStartDate = CSS_WS_ControllerClaim.stringToDate(EngineDataResponse.DataArea.WarrantyStartDate, 'YYYY-MM-DDTHH:MM:SS');
                                this.ESNsList[i].ESN.CSS_WS_WarrantyStartDate__c = warrantyStartDate;
                                this.ESNsList[i].ESN.CSS_WS_BIS_2__c = 'No BIS';                      
                            } else {
                                this.ESNsList[i].WADEditable = false;
                            }
                            if(this.ActualClaim.CSS_WS_Warranty_Type__c == 'Parte'){
                                this.ESNsList[i].ESN.CSS_WS_WarrantyStartDate__c =  null;
                                this.ESNsList[i].ESN.CSS_WS_BIS_2__c = 'No BIS';
                            }
                            if(this.ESNsList[i].ESN.CSS_WS_BIS_2__c == 'BIS'){//Rule SF12
                                this.ESNsList[i].WADEditable = true;
                            }
                            this.ESNsList[i].ESN.CSS_WS_Engine_ApplicationCode__c = EngineDataResponse.DataArea.EngineAppCode;
                            this.ESNsList[i].ESN.CSS_WS_EngineFamilyCode__c = EngineDataResponse.DataArea.EngineFamilyCode;
                            this.ESNsList[i].ESN.CSS_WS_ProductApplicationCode__c = EngineDataResponse.DataArea.ProdAppCode;
                            this.ESNsList[i].ESN.CSS_WS_ServiceModel__c = EngineDataResponse.DataArea.ServiceModelName;
                            this.ESNsList[i].ESN.CSS_WS_FailureDate__c = this.ActualClaim.CSS_WS_Failure_Date_Time__c;
                            this.ESNsList[i].ESN.CSS_WS_FailurePointType__c = this.ActualClaim.CSS_WS_Failure_Measure__c;
                        } else {
                            this.DeleteMultiESNCall(i);
                            this.DisplayAsincErrorHandler(EngineDataResponse.Header.ReturnCodeDescription);
                        } 
                    } else {
                        this.DeleteMultiESNCall(i);
                        this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                    }
                    break;
                } else {
                    this.DeleteMultiESNCall(i);
                    break;  
                }
            }
        }
    }
    
    Public Void DeleteMultiESNCall(Integer i){
        this.ESNsList[i].ESN.CSS_WS_MultiESN__c = '';
        this.ESNsList[i].ESN.CSS_WS_WarrantyStartDate__c = null;
        this.ESNsList[i].ESN.CSS_WS_FailureDate__c = null;
        this.ESNsList[i].ESN.CSS_WS_BIS_2__c = '';
        this.ESNsList[i].ESN.CSS_WS_Engine_ApplicationCode__c = '';
        this.ESNsList[i].ESN.CSS_WS_EngineFamilyCode__c = '';
        this.ESNsList[i].ESN.CSS_WS_ProductApplicationCode__c = '';
        this.ESNsList[i].ESN.CSS_WS_ServiceModel__c = '';                            
        this.ESNsList[i].ESN.CSS_WS_FailurePoint__c = '';
        this.ESNsList[i].ESN.CSS_WS_FailurePointType__c = '';
        this.ESNsList[i].ESN.CSS_WS_ESNCalibrationStart__c = '';
        this.ESNsList[i].ESN.CSS_WS_ESNCalibrationEnd__c = '';
        this.ESNsList[i].ESN.CSS_WS_Revision_Before__c = '';
        this.ESNsList[i].ESN.CSS_WS_Revision_After__c = '';
        this.ESNsList[i].ESN.CSS_WS_BIS_2__c = '';
        this.ESNsList[i].ESN.CSS_WS_Detail__c = '';
        this.ESNsList[i].WADEditable = false;
    }
    
    Public Void MultiESNCallWSToValidateESNs(List<String> ESNsToValdiate){
        CSS_WS_Warranty__c policyFlag = [SELECT CSS_WS_Policy_Flag__c FROM CSS_WS_Warranty__c WHERE Id = : this.ActualClaim.Id LIMIT 1];
        if(policyFlag.CSS_WS_Policy_Flag__c == 'Warranty' ){//Rule 1076
            try{
                String CampaignNumber = this.ActualClaim.CSS_WS_Campaigns_TRPs__c;
                transient CSS_WS_J2A_ValidateMultiESN WSValidationResponse = CSS_WS_GetWebServiceData.validateMultiESN(CampaignNumber, ESNsToValdiate);
                this.ActualClaim.CSS_WS_HasError__c = 0;
                this.ActualClaim.CSS_WS_HasMessage__c = '';
                if(WSValidationResponse != null){
                    if(WSValidationResponse.Header.Status.touppercase() == 'SUCCESS'){
                        Integer WSValidationResponseSize = WSValidationResponse.DataArea.Details.size();
                        if(WSValidationResponseSize > 0){
                            for(Integer i = 0; i < WSValidationResponseSize; i++){
                                if(WSValidationResponse.DataArea.Details[i].ValidationFlag == 'N'){
                                    this.DisplayAsincErrorHandler(Label.CSS_WS_MultiESN_E003);//The ESN is not valid
                                    break;
                                }
                            }
                        } 
                    } else {
                        this.DisplayAsincErrorHandler(WSValidationResponse.Header.ReturnCodeDescription);//Unexpected error, please contact your System Administrator
                    }
                } else {
                    this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                }
            } catch(System.Exception e) {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            }
        }
    }
    
    Public Void MultiESNCallWSToGetAccCoverage(){
        CSS_WS_Warranty__c policyFlag = [SELECT CSS_WS_Policy_Flag__c FROM CSS_WS_Warranty__c WHERE Id = : this.ActualClaim.Id LIMIT 1];
        if(policyFlag.CSS_WS_Policy_Flag__c == 'Warranty'){//Rule 1076
            try{
                List<String> SystemAndComponentCode = new List<String>();
                transient CSS_WS_Failure__c FailureCode = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c FROM CSS_WS_Failure__c
                    WHERE CSS_WS_Warranty__c = : this.ActualClaim.Id ORDER BY Id LIMIT 1];
                
                String NewPartsWarrantyFlg = 'N', ReConPartsWarrantyFlg = 'N', RoadRelayWarrantyFlg = 'N'; 
                if(this.ActualClaim.CSS_WS_Warranty_Type__c == 'Parte' || this.ActualClaim.CSS_WS_Warranty_Type__c == 'Part'){
                    if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Nuevo' || this.ActualClaim.CSS_WS_Claim_Type__c == 'New'){
                        NewPartsWarrantyFlg = 'Y';
                    } else if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon'){
                        ReConPartsWarrantyFlg = 'Y';
                    } else if(this.ActualClaim.CSS_WS_Claim_Type__c == 'Herramienta de Servicio' || this.ActualClaim.CSS_WS_Claim_Type__c == 'Road Relay'){
                        RoadRelayWarrantyFlg = 'Y';
                    }
                }
                SystemAndComponentCode.add(FailureCode.CSS_WS_EngineSystemCode__c + ',' + FailureCode.CSS_WS_ComponentCode__c);
                for(CSS_WS_MultiESN__c ESN: this.ListToInsert){
                    List<String> ESNData = new List<String>();
                    ESNData.add(ESN.CSS_WS_MultiESN__c);
                    ESNData.add(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                    ESNData.add(CSS_WS_ControllerClaim.dateToString(ESN.CSS_WS_FailureDate__c, 'MM/dd/yyyy'));
                    ESNData.add((ESN.CSS_WS_FailurePoint__c != null) ? String.valueOf(ESN.CSS_WS_FailurePoint__c) : '');
                    ESNData.add((ESN.CSS_WS_FailurePointType__c != null) ? ESN.CSS_WS_FailurePointType__c : '');
                    ESNData.add(ESN.CSS_WS_Engine_ApplicationCode__c);
                    ESNData.add((this.ActualClaim.CSS_WS_Fault_Code__c != null) ? this.ActualClaim.CSS_WS_Fault_Code__c : '');
                    ESNData.add(CSS_WS_ControllerClaim.dateToString(ESN.CSS_WS_WarrantyStartDate__c, 'MM/dd/yyyy'));
                    ESNData.add((this.ActualClaim.CSS_WS_Campaigns_TRPs__c != null) ? this.ActualClaim.CSS_WS_Campaigns_TRPs__c : '');
                    ESNData.add(NewPartsWarrantyFlg);
                    ESNData.add(ReConPartsWarrantyFlg);
                    ESNData.add(RoadRelayWarrantyFlg);
                    ESNData.add(this.ActualClaim.CSS_WS_Account_Code__c);
                    CSS_WS_J2A_GetAccountCoverage AccCoverageResponse = CSS_WS_GetWebServiceData.getAccountCoverage(ESNData, SystemAndComponentCode);
                    if(AccCoverageResponse != null){
                        if(AccCoverageResponse.Header.Status.touppercase() == 'SUCCESS'){
                            if(AccCoverageResponse.DataArea.Details[0].Status.touppercase() == 'ERROR'){
                                this.DisplayAsincErrorHandler(AccCoverageResponse.DataArea.Details[0].Message);
                                break;
                            }
                        } else {
                            this.DisplayAsincErrorHandler(AccCoverageResponse.Header.ReturnCodeDescription);
                            break;
                        }
                    } else {
                        this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        break;
                    }
                }
            } catch(System.Exception e) {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
            }
        }
    }
    
    Public Void MultiESNCallWSODM(){
        if(this.ActualClaim.CSS_WS_Policy_Flag__c != 'Policy WW'){
            try{
                String ReconFlag = '';
                Integer Position = 1;
                System.debug(this.ListToInsert);
                for(CSS_WS_MultiESN__c ESN: this.ListToInsert){
                    Map<String, String> header = new Map<String,String>{};            
                    Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                  
                    //Query fields not available in the frontend
                    transient CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c, CSS_WS_Marine_Application_Flag__c, 
                        CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
                    
                    header.put('bisFlag',(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
                    header.put('cmiEngineSerialNumber',ESN.CSS_WS_MultiESN__c);
                    header.put('cmiServiceProviderCode',this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
                    header.put('engineFamily',ESN.CSS_WS_EngineFamilyCode__c);
                    header.put('failureDate',CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'MM/dd/yyyy'));
                    header.put('failureMeasure',ESN.CSS_WS_FailurePointType__c);
                    header.put('failurePoint', (ESN.CSS_WS_FailurePoint__c != null) ? ESN.CSS_WS_FailurePoint__c : '');
                    header.put('manualAdjudicationFlag','');
                    header.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                    header.put('productApplicationCode',ESN.CSS_WS_ProductApplicationCode__c);
                    header.put('roNumber',this.ActualClaim.CSS_WS_Repair_Work_Order_Number__c);
                    header.put('serviceModelName',ESN.CSS_WS_ServiceModel__c);
                    header.put('warrantyStartDate',CSS_WS_ControllerClaim.dateToString(ESN.CSS_WS_WarrantyStartDate__c, 'MM/dd/yyyy'));
                    header.put('region',(SPPreferences.BillingCountry.touppercase() == 'MEXICO') ? 'MEXICO' : 'LATIN AMERICA');
                    header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c);
                    header.put('regionCode',SPPreferences.CSS_WS_Region_Code__c);
                    header.put('territory',String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
                    header.put('outfileAllClaimsFlag','Y');
                    header.put('claimAllowedDays',String.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c));
                    header.put('engineFamilyCode',ESN.CSS_WS_EngineFamilyCode__c);
                    header.put('marineFlag','');
                    header.put('buildDate','');
                    header.put('etoConversionDate','');
                    header.put('warrantyIndicatorFlag',(SPPreferences.Warranty_Training_Certification__c == true)? 'Y' : 'N');
                    header.put('productApplicationDesp','');
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
                    
                    transient CSS_WS_J2A_ODM_Validation ODMResponse = CSS_WS_GetWebServiceData.getODMValidationHeader(header);                    
                    
                    if(ODMResponse != null){
                        if(ODMResponse.Response.claim.status.touppercase()=='ERROR'){
                            for(integer i=0; i<ODMResponse.Response.claim.messages.size(); i++){
                                this.DisplayAsincErrorHandler(ODMResponse.Response.claim.messages[i].description);
                            }     
                            break;
                        }
                    } else {
                        this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                        break;
                    }
                    Position++;
                }
            } catch(System.Exception e) {
                this.DisplayAsincErrorHandler(Label.CSS_WS_Global_E001);//Unexpected error, please contact your System Administrator
                System.Debug(e.getMessage());
            }
        }
    }
    
    Public Void DisplayErrorHandler(String MsgError, Integer Position){
        if(Position != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.CSS_WS_MultiESN_E004 + Position + Label.CSS_WS_MultiESN_E005 + MsgError));
        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, MsgError));
        }
    }
    
    Public Void DisplayAsincErrorHandler(String MsgError){
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = MsgError;
    }    
}