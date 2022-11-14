Public Class CSS_WS_PartsGridController{
    
    Public CSS_WS_Warranty__c ActualClaim { get; set; } 
    Public Id warrantyId { get; set; }
    Public CreateNewPart NewParts { get; set; }
    Public Static id wId {get{return System.currentPageReference().getParameters().get('Id');} set;}
    Private Map <String, Decimal> partsMap = new Map<String, Decimal>();
    Public List<CreateNewPart> PartList { get; set; }
    Public List<String> SelectedPartValues { get; set; }
    public Boolean isMexico { get; set;}
    Public Integer PartCounter = 1;
    Public Integer SavedPartCount = 0;
    Public Integer totalQuantityParts = 0;
    Public Integer PartToDelete { get; set; }
    Public Integer PartToUpdate { get; set; }
    Public Decimal quantity { get; set; }
    Public Decimal price { get; set; }
    Public String priceBook { get; set; }
    Public Decimal subtotal { get; set; }
    Public Decimal totalQuantity { get; set; }
    Public Decimal TotalAmountParts { get; set; }
    Public String OldPartNum { get; set; }
    Public String partNumber { get; set; }
    Public String longPartNumber { get; set; }
    Public String replacementreason { get; set; }
    Public String superseaded { get; set; }
    Public String partService { get; set; }
    Public String description { get; set; }
    Public String trackingGuideCode { get; set; }
    Public String shippingCompany { get; set; }
    Public String waiverProcess { get; set; }
    Public String eprattention { get; set; }
    Public String eprnote { get; set; }
    Public String partProductCode { get; set; }
    Public Boolean partReturnFlag { get; set; }
    Public Boolean isKit { get; set; }
    public Boolean fromCampaign { get; set;}
    Public Boolean fromPromotion { get; set;}
    Public Decimal siebelUnitPrice { get; set;}
    Public Decimal siebelSubtotal { get; set;}
    Public Account SPPreferencesDist { get; set;}
    Public Account SPPreferencesDlr { get; set;}
    //Public String Replacement_Reason { get; set;}
    Public Integer PartToFind { get; set; }
    
    Public CSS_WS_PartsGridController (ApexPages.StandardController controller){
        System.debug('Inicio CSS_WS_PartsGridController ****** CSS_WS_PartsGridController');
        this.ActualClaim = (CSS_WS_Warranty__c)controller.getRecord();
        this.totalQuantity = 0;
        this.partNumber='';
        this.quantity = 0;
        this.replacementreason='';
        this.superseaded='';
        this.partService='';
        this.isKit=false;
        this.description='';
        this.price = 0.00;  
        this.subtotal=0.00;
        this.TotalAmountParts = 0;
        this.fromCampaign = false;
        this.fromPromotion = false;
        this.siebelUnitPrice = 0;
        this.siebelSubtotal = 0;
        this.priceBook = '';
        this.longPartNumber = '';
        this.partReturnFlag = false;
        this.trackingGuideCode = '';
        this.shippingCompany = '';
        this.waiverProcess = '';
        this.eprattention = '';
        this.eprnote = '';
        this.partProductCode = '';
        this.PartList = new List<CreateNewPart>();
        wId= (this.ActualClaim.Id != NULL) ? this.ActualClaim.Id : wId;
        this.warrantyId=(this.ActualClaim.Id != NULL) ? this.ActualClaim.Id : wId;
        if(this.ActualClaim.Id != NULL){
            SPPreferencesDist = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_DR__c);
            SPPreferencesDlr = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
            //makePartList(getSavedPartsList(wId));
            //computeSubTotal();
        }
    }
    
    Public Class CreateNewPart{
        //Add new record to the PartsGrid Object
        Public CSS_WS_Warranty_Parts__c Part {get; set;}
        Public Integer Index {get; set;}
        Public CreateNewPart(Integer Index, String partNumber, Decimal quantity, String replacementreason, String superseaded, String partService,
                             boolean isKit, string description,  decimal price, decimal subtotal,  Id warrantyId, String priceBook, 
                             Boolean fromCampaign, Boolean fromPromotion, Decimal siebelUnitPrice, Decimal siebelSubtotal, String longPartNumber,
                             Boolean partReturnFlag, String trackingGuideCode, String shippingCompany, String waiverProcess, String eprAttention, String eprNote, String partProductcode){
            this.Index = Index;
            partNumber = (partNumber == null) ? '' : partNumber;
            quantity = (quantity == null) ? 1 : quantity;
            replacementreason = (replacementreason == null) ? '' : replacementreason;
            superseaded = (superseaded == null) ? '' : superseaded;
            partService = (partService == null) ? '' : partService;
            isKit = (partNumber == null) ? false : isKit;
            description = (partNumber == null) ? '' : description; 
            price = (price == null) ? 0.00 : price; 
            subtotal = (subtotal == null) ? 0.00 : subtotal;
            longPartNumber = (longPartNumber == null) ? '' : longPartNumber;
            partReturnFlag = (partNumber == null) ? false : partReturnFlag;
            trackingGuideCode = (partNumber == null) ? '' : trackingGuideCode;
            shippingCompany = (partNumber == null) ? '' : shippingCompany;
            waiverProcess = (partNumber == null) ? '' : waiverProcess;
            eprAttention = (partNumber == null) ? '' : eprAttention;
            eprNote = (partNumber == null) ? '' : eprNote;
            partProductCode = (partNumber == null) ? '' : partProductCode;
            
            this.Part = new CSS_WS_Warranty_Parts__c(
                CSS_WS_PartNumber__c = partNumber,
                CSS_WS_Quantity__c = quantity,
                CSS_WS_ReplacementReasonPicklist__c = replacementreason,
                CSS_WS_Superseaded__c = superseaded,
                CSS_WS_PartService__c = partService, 
                CSS_WS_Kit__c = isKit,
                CSS_WS_Description__c = description, 
                CSS_WS_Unit_Part_Price__c = price,  
                CSS_WS_SubTotal__c = subtotal,
                CSS_WS_WarrantyID__c = warrantyId,
                CSS_WS_priceBook__c = priceBook,
                CSS_WS_From_Campaign__c = fromCampaign,
                CSS_WS_From_Promotion__c = fromPromotion,
                CSS_WS_Siebel_Unit_Part_Price__c = siebelUnitPrice,
                CSS_WS_Siebel_SubTotal__c = siebelSubtotal,
                CSS_WS_Long_Part_Number_del__c = longPartNumber,
                CSS_WS_Part_Return_Flag__c = partReturnFlag,
                CSS_WS_Tracking_Guide_Code__c = trackingGuideCode,
                CSS_WS_Shipping_Company__c = shippingCompany,
                CSS_WS_Waiver_Process__c = waiverProcess,
                CSS_WS_EPR_Attention__c = eprAttention,
                CSS_WS_EPR_Note__c = eprNote,
                CSS_WS_Part_Product_Code__c = partProductCode  
            );
        }
    }
    
    Public List<CSS_WS_Warranty_Parts__c> getSavedPartsList(String warrantyId){
        try {
            List<CSS_WS_Warranty_Parts__c> savedParts = 
                [SELECT Id,CSS_WS_PartNumber__c,CSS_WS_Quantity__c,CSS_WS_ReplacementReasonPicklist__c,CSS_WS_ReplacementReason__c,
                 CSS_WS_Superseaded__c,CSS_WS_PartService__c,CSS_WS_Kit__c,CSS_WS_Description__c,CSS_WS_Unit_Part_Price__c, CSS_WS_Siebel_Unit_Part_Price__c,
                 CSS_WS_Siebel_SubTotal__c, CSS_WS_SubTotal__c, CSS_WS_WarrantyID__c, CSS_WS_From_Campaign__c, CSS_WS_From_Promotion__c, CSS_WS_priceBook__c, 
                 CSS_WS_Long_Part_Number_del__c, CSS_WS_Part_Return_Flag__c, CSS_WS_Tracking_Guide_Code__c, CSS_WS_Shipping_Company__c, CSS_WS_Waiver_Process__c,
                 CSS_WS_EPR_Attention__c, CSS_WS_EPR_Note__c, CSS_WS_Part_Product_Code__c FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c= :warrantyId];
            return savedParts;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null; 
    }
    
    Public PageReference SavePartsGrids(){
        //Query fields not available in the frontend
        CSS_WS_Warranty__c claimData = [SELECT CSS_WS_Covered_Parts_Qty__c, CSS_WS_Policy_Flag__c, CSS_WS_Campaigns_TRPs__c, CSS_WS_Campaign_Parts_Percentage__c, CSS_WS_Account_Code_Type__c FROM CSS_WS_Warranty__c WHERE Id =: this.ActualClaim.Id];
        this.ActualClaim.CSS_WS_HasError__c = 0;
        this.ActualClaim.CSS_WS_HasMessage__c = '';
        boolean claim_part_return_flag = false;
        List<CSS_WS_Warranty_Parts__c> ListToInsert = new List<CSS_WS_Warranty_Parts__c>();
        for(CreateNewPart Part : this.PartList){
            //Validate Replacement Reason is not empty
            if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && Part.Part.CSS_WS_ReplacementReasonPicklist__c == null && Part.Part.CSS_WS_PartNumber__c != ''){//Rule SF52
                this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E001);//You need to select a replacement reason
                return null;
            }
            //Validate Tracking Guide Code is not empty
            if(Part.Part.CSS_WS_Part_Return_Flag__c == True && String.isBlank(Part.Part.CSS_WS_Tracking_Guide_Code__c)){
                this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E008);//Please provide a correct "Tracking Guide Code" for the claimed Part. 
                return null;
            }
            //Validate Tracking Guide Code contains between 7 and 25 characters and diferent than XBU en SLP
            if(Part.Part.CSS_WS_Part_Return_Flag__c == True && Part.Part.CSS_WS_Shipping_Company__c != 'XBU en SLP' && (Part.Part.CSS_WS_Tracking_Guide_Code__c.length() < 7 || Part.Part.CSS_WS_Tracking_Guide_Code__c.length() > 25)){
                this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E008);//Please provide a correct "Tracking Guide Code" for the claimed Part. 
                return null;
            }
            //Validate Shipping Company is not empty
            if(Part.Part.CSS_WS_Part_Return_Flag__c == True && String.isBlank(Part.Part.CSS_WS_Shipping_Company__c)){
                this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E009);//Please provide the "Shipping Company" for the claimed Part. 
                return null;
            }
            //Validate Waiver Process is not empty
            if(Part.Part.CSS_WS_Part_Return_Flag__c == True && Part.Part.CSS_WS_Shipping_Company__c == 'WAIVER' && String.isBlank(Part.Part.CSS_WS_Waiver_Process__c)){
                this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E010);//Please provide the "Waiver Process" for the claimed Part. 
                return null;
            }
            // Enable flag to save into Claim the Part Return Flag
            if(Part.Part.CSS_WS_Part_Return_Flag__c == True){
                claim_part_return_flag = true;
            }
            //Part.Part.CSS_WS_SubTotal__c  = Part.Part.CSS_WS_Quantity__c * Part.Part.CSS_WS_Unit_Part_Price__c;
            if(Part.Part.CSS_WS_PartNumber__c != ''){
                if(Part.Part.Id != null){
                    Part.Part.Id = null;
                }
                this.computeSubTotal();
                ListToInsert.add(Part.Part);
            }
        }
        try {
            //if(totalQuantity <= 25){//Rule SF38 
            //Warranty not campaing
            if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c == null || claimData.CSS_WS_Campaigns_TRPs__c == '')){
                claimData.CSS_WS_Covered_Parts_Qty__c= claimData.CSS_WS_Covered_Parts_Qty__c == null ? 0 : claimData.CSS_WS_Covered_Parts_Qty__c;
                if((totalQuantity <= claimData.CSS_WS_Covered_Parts_Qty__c ) || claimData.CSS_WS_Account_Code_Type__c == 'POL-Policy adjustment' || claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){//Rule SF81
                    delete [SELECT Id FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :wId];
                    upsert ListToInsert;
                    this.ActualClaim.CSS_WS_Total_Amount_Part__c = this.TotalAmountParts;//Rule SF76
                    this.ActualClaim.CSS_WS_Part_Return_Flag__c = (claim_part_return_flag == true ? true : false);
                    upsert this.ActualClaim;
                } else {
                    this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Covered_Parts_Qty__c == null ? 0: claimData.CSS_WS_Covered_Parts_Qty__c) + ' ' + Label.CSS_WS_PartsGrid_E005); //'The coverage doesnt cover more than' n 'parts'
                    return null;
                }
            //Warranty with campaing
            } else if(claimData.CSS_WS_Policy_Flag__c == 'Warranty' && (claimData.CSS_WS_Campaigns_TRPs__c != null && claimData.CSS_WS_Campaigns_TRPs__c != '')){
                claimData.CSS_WS_Campaign_Parts_Percentage__c = claimData.CSS_WS_Campaign_Parts_Percentage__c == null ? 0 : claimData.CSS_WS_Campaign_Parts_Percentage__c;
                if((claimData.CSS_WS_Campaign_Parts_Percentage__c == 0 && ListToInsert.size() > 0) && claimData.CSS_WS_Account_Code_Type__c != 'POL-Policy adjustment' && claimData.CSS_WS_Account_Code_Type__c == 'OTH – Other'){//Rule SF81
                    this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E004 + ' ' + (claimData.CSS_WS_Campaign_Parts_Percentage__c == null ? 0: claimData.CSS_WS_Campaign_Parts_Percentage__c) + ' ' + Label.CSS_WS_PartsGrid_E006); //'The coverage doesnt cover more than' n 'porcentage'
                    return null;
                } else {
                    delete [SELECT Id FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :wId];
                    upsert ListToInsert;
                    this.ActualClaim.CSS_WS_Total_Amount_Part__c = this.TotalAmountParts;//Rule SF76
                    this.ActualClaim.CSS_WS_Part_Return_Flag__c = (claim_part_return_flag == true ? true : false);
                    upsert this.ActualClaim;
                }
            //When is diferent of Warranty
            } else {
                delete [SELECT Id FROM CSS_WS_Warranty_Parts__c WHERE CSS_WS_WarrantyID__c = :wId];
                upsert ListToInsert;
                this.ActualClaim.CSS_WS_Total_Amount_Part__c = this.TotalAmountParts;//Rule SF76
                this.ActualClaim.CSS_WS_Part_Return_Flag__c = (claim_part_return_flag == true ? true : false);
                upsert this.ActualClaim;
            }
            //} else {
            //    this.DisplayErrorHandler(Label.CSS_WS_PartsGrid_E003);//You cannot add more than 25 parts
            //    return null;
            //}
        } catch(Exception e) {
            this.DisplayErrorHandler('Error: ' + e.getMessage());  
            return null;
        }
        return null;
    } 
    
    Public PageReference GetPartsInfo(){
        String JSONValues;    
        try {
            Integer partPosToUpdate = findPartIndex(this.PartToUpdate);
            if(partPosToUpdate == -1){
                EmptyValues(this.PartList[partPosToUpdate].Part);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.CSS_WS_Global_E001));
                return null;
            }
            
            if(this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c == '' || this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c == null){
                EmptyValues(this.PartList[partPosToUpdate].Part);
                if(partsMap.containsKey(OldPartNum)){
                    partsMap.remove(OldPartNum);
                }
                return null;
            }
            String pn = this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c.trim();
            pn = pn.toUpperCase();
            this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c = pn;
            CSS_WS_J2A_GetPartsData response = CSS_WS_GetWebServiceData.getPartsData(this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c);
            if(response == NULL){
                EmptyValues(this.PartList[partPosToUpdate].Part);
                JSONValues = 'NULL';
            } else if(response.Header.Status.toUpperCase() == 'SUCCESS' && response.DataArea != null){
                this.partNumber = this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c;
                if(response.DataArea.PartNumberLong == null || response.DataArea.PartNumberLong == ''){
                    EmptyValues(this.PartList[partPosToUpdate].Part);
                    ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Long_Part));
                } else {
                
                    this.longPartNumber = response.DataArea.PartNumberLong;
                    this.superseaded = response.DataArea.SupersededPartNumber;
                    this.partService = response.DataArea.PartInService;
                    this.isKit = (response.DataArea.KitPartFlag=='Y') ? true : false; 
                    this.description = response.DataArea.PartDescription;
                    this.quantity = 1;//(this.quantity == 0) ? 1 : this.quantity;
                    this.partReturnFlag = false;
                    this.trackingGuideCode = '';
                    this.shippingCompany = '';
                    this.waiverProcess = '';
                    this.eprattention = '';
                    this.eprnote = '';
                    this.partProductCode = response.DataArea.PartProductCode;
                }               
                
                CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(this.ActualClaim.CSS_WS_Service_Provider_DR__c, SPPreferencesDist);
                if(odmRes == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E046));
                    EmptyValues(this.PartList[partPosToUpdate].Part);   
                    return null;
                }
                if(odmRes.Response.claim.status.touppercase()=='SUCCESS' || odmRes.Response.claim.status.touppercase()=='WARNING' ){
                    if(odmRes.Response.claim.messages != null){
                        for(integer i=0; i<odmRes.Response.claim.messages.size(); i++){
                            if(!odmRes.Response.claim.messages[i].description.contains('****ENHANCED PARTS RETURN REQUEST****')){
                                ApexPages.addMessage(new ApexPages.message (ApexPages.severity.WARNING, odmRes.Response.claim.messages[i].description));
                            }
                        }
                    }
                    if (odmRes.Response.claim.parts.priceBook == null || odmRes.Response.claim.parts.priceBook == ''){
                        EmptyValues(this.PartList[partPosToUpdate].Part);
                        ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price_Book));
                        return null;
                    } else {
                        this.priceBook = odmRes.Response.claim.parts.priceBook;
                        //this.partReturnFlag = (odmRes.Response.claim.parts.partReturnFlag == 'Y' ? True : False);
                    }
                    if(odmRes.Response.claim.parts.partPrice == null || odmRes.Response.claim.parts.partPrice == ''){
                        EmptyValues(this.PartList[partPosToUpdate].Part);
                        ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price));
                        return null;
                    } 
                    if(setPriceValues(this.PartList[partPosToUpdate].Part.CSS_WS_PartNumber__c, odmRes.Response.claim.parts.partPrice)){
                        return null;
                    }
                } else {
                    for(integer i=0; i<odmRes.Response.claim.messages.size(); i++){
                        ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, odmRes.Response.claim.messages[i].description));
                    }
                    EmptyValues(this.PartList[partPosToUpdate].Part);
                }
                if(!UpdatePart()){
                    computeSubTotal();
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_PartsGrid_E002));//You cannot enter a repeated part
                }   
                JSONValues = JSON.serialize(response.DataArea);
                computeSubTotal();
            } else if(response.Header.Status.toUpperCase() == 'ERROR'){
                JSONValues = JSON.serialize(response.Header);
                EmptyValues(this.PartList[partPosToUpdate].Part);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, response.Header.ReturnCodeDescription));
            }  
        } catch(exception e) {
            system.debug('Error: '+e.getMessage());
            css_utility.LogOutIntError(JSONValues, 'CSS Error:' + e.getMessage(),'','WS_GetPartsData_Integration');
        }
        return null;
    }
    
    Public CSS_WS_J2A_ODM_Validation GetODMPartsInfo(String serviceProviderCode, Account SPPreferences){
        try{
            List<String> ODMRequestBodyHeader = new List<String>();
            Map<String, String> header = new Map<String,String>();  
            CSS_WS_Warranty__c claimData = [//Query fields not available in the frontend
                SELECT CSS_WS_Pay_Code__c, CSS_WS_Product_Application_Code__c, CSS_WS_Product_Application_Description__c,
                CSS_WS_Marine_Application_Flag__c, CSS_WS_Build_Date__c, CSS_WS_Engine_Trade_Out_conversion_date__c, CSS_WS_Approval_Code__c,
                CSS_WS_Account_Code_Type__c, CSS_WS_InShopCampaignFlag__c
                FROM CSS_WS_Warranty__c 
                WHERE Id =: this.ActualClaim.Id];
            //Account SPPreferences = CSS_WS_ControllerClaim.getSelectedSPAccount(this.ActualClaim.CSS_WS_Service_Provider_DR__c , this.ActualClaim.CSS_WS_Service_Provider_Dealer__c);
            if(SPPreferences.BillingCountry.toUpperCase() == 'MEXICO'){
                this.isMexico = true;
            }
            header.put('bisFlag',(this.ActualClaim.CSS_WS_Warranty_Subtype__c == 'BIS') ? 'Y' : 'N');
            header.put('cmiEngineSerialNumber',this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
            header.put('cmiServiceProviderCode', serviceProviderCode);
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
            header.put('channelOfDistribution',SPPreferences.CSS_WS_Channel_Code__c );
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
        
            String ReconPartsFlag = (this.ActualClaim.CSS_WS_Claim_Type__c == 'Recon') ? 'Y' : 'N';
            List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :this.ActualClaim.Id ];  
            
            List<Map<String, String>> failure = new List<Map<String, String>> ();
            for(CSS_WS_Failure__c cont_fail: fail){
                Map<String, String> failureData = new Map<String,String>{};
                failureData.put('campaignId',(String.isEmpty(this.ActualClaim.CSS_WS_Campaigns_TRPs__c)) ? '' : this.ActualClaim.CSS_WS_Campaigns_TRPs__c);    
                failureData.put('payCode',claimdata.CSS_WS_Pay_Code__c);
                failureData.put('totalLaborAmt','');
                failureData.put('authorizationNumber',(this.ActualClaim.CSS_Authorization_Number__c!= NULL)?String.valueOf(this.ActualClaim.CSS_Authorization_Number__c):'');
                failureData.put('approvalCode',(claimData.CSS_WS_Approval_Code__c!=null)?claimData.CSS_WS_Approval_Code__c:'');
                failureData.put('totalTowingAmt','');
                failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c);
                failureData.put('failCode',cont_fail.CSS_WS_EngineSystemCode__c + cont_fail.CSS_WS_ComponentCode__c);
                failureData.put('coverageType',claimdata.CSS_WS_Account_Code_Type__c);
                failureData.put('failMode',cont_fail.CSS_WS_FailureModeCode__c);
                failureData.put('accountCodeType',claimdata.CSS_WS_Account_Code_Type__c);
                failureData.put('multiESNFlag',(this.ActualClaim.CSS_WS_Multi_ESN__c == true) ? 'Y' : 'N');
                failureData.put('accountCode',this.ActualClaim.CSS_WS_Account_Code__c); 
                failureData.put('inShopCampaignFlag',(claimData.CSS_WS_InShopCampaignFlag__c != null) ? claimData.CSS_WS_InShopCampaignFlag__c : 'N');  
                failure.add(failureData);
            }
            
            List<Map<String, String>> PARTS = new List<Map<String, String>>();
            Map<String, String> partList = new Map<String, String>();
            partList.put('reconPartFlag',ReconPartsFlag); 
            partList.put('partName',this.description);  
            partList.put('lineNumber','1');   
            partList.put('partId',this.longPartNumber); 
            partList.put('priceBook',' ');
            partList.put('partsProductCode',this.partProductCode);
            
            Integer FailurePoint = Integer.valueof(this.ActualClaim.CSS_WS_Failure_Point_Quantity__c);
            Integer ClaimAllowedDays = Integer.valueof(SPPreferences.CSS_WS_Claim_Allow_Days__c); 
            List<List<String>>ODMRequest = new List <List<String>>();
            List<String> partL = new List<String>();
            List<Decimal>partPrice = new Decimal[2];
            partPrice [0] = 0;
            PARTS.add(partList);
            partPrice.add(0);
            
            CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationParts(header, failure, parts);
            return obj;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            return null;
        }
        return null;
    }
    
    Public Boolean CheckRepeatedPart(CSS_WS_Warranty_Parts__c part, Integer Index){
        Boolean res = false;
        if(part.CSS_WS_PartNumber__c == ''){
            if(partsMap.containsKey(OldPartNum)){//Rule SF28
                partsMap.remove(OldPartNum);
            }
            return res;
        }
        if(partsMap.containsKey(part.CSS_WS_PartNumber__c) && partsMap.get(part.CSS_WS_PartNumber__c) != Index){
            res = true;
        } else {
            UpdateMap (part, Index);
        }
        return res;
    }
    
    Public Boolean UpdatePart(){
        Boolean error = false;
        Integer PartPosToUpdate = findPartIndex(this.PartToUpdate);
        if(PartPosToUpdate != -1 &&  this.PartList[PartPosToUpdate].Part.CSS_WS_PartNumber__c  != ''){
            if(!CheckRepeatedPart(this.PartList[PartPosToUpdate].Part, PartPosToUpdate)){
                this.PartList[PartPosToUpdate].Part.CSS_WS_Quantity__c = this.quantity;
                this.PartList[PartPosToUpdate].Part.CSS_WS_ReplacementReasonPicklist__c = this.replacementreason;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Superseaded__c = this.superseaded;
                this.PartList[PartPosToUpdate].Part.CSS_WS_PartService__c = this.partService; 
                this.PartList[PartPosToUpdate].Part.CSS_WS_Kit__c = this.isKit;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Description__c = this.description;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Unit_Part_Price__c = this.price; 
                this.PartList[PartPosToUPdate].Part.CSS_WS_Siebel_Unit_Part_Price__c = this.siebelUnitPrice;
                this.PartList[PartPosToUpdate].Part.CSS_WS_SubTotal__c = this.subtotal;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Siebel_SubTotal__c = this.siebelSubtotal;
                this.PartList[PartPosToUpdate].Part.CSS_WS_WarrantyID__c = this.ActualClaim.Id;
                this.PartList[PartPosToUpdate].Part.CSS_WS_priceBook__c = this.priceBook;
                this.PartList[PartPosToUpdate].Part.CSS_WS_From_Campaign__c = this.fromCampaign;
                this.PartList[PartPosToUpdate].Part.CSS_WS_From_Promotion__c = this.fromPromotion;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Long_Part_Number_del__c = this.longPartNumber;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Part_Return_Flag__c = this.partReturnFlag;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Tracking_Guide_Code__c = this.trackingGuideCode;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Shipping_Company__c = this.shippingCompany;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Waiver_Process__c = this.waiverProcess;
                this.PartList[PartPosToUpdate].Part.CSS_WS_EPR_Attention__c = this.eprAttention;
                this.PartList[PartPosToUpdate].Part.CSS_WS_EPR_Note__c = this.eprNote;
                this.PartList[PartPosToUpdate].Part.CSS_WS_Part_Product_Code__c = this.partProductCode;
                
            } else {
                EmptyValues(this.PartList[PartPosToUpdate].Part);
                error = true;
            }
        } else {
            EmptyValues(this.PartList[PartPosToUpdate].Part);
            if(partsMap.containsKey(OldPartNum)){
                partsMap.remove(OldPartNum);
            }
        }
        computeSubTotal();
        return error;
    }    
    
    Public Integer findPartIndex(Integer partIndexToFind){
        Integer ListSize = this.PartList.size();
        Integer indexFound = -1;
        for(Integer i = 0; i < ListSize; i++){
            System.debug(this.PartList[i].Index);
            if(this.PartList[i].Index == partIndexToFind){
                indexFound = i;
            }
        }        
        return indexFound;
    }
        
    Public Void makePartList(List <CSS_WS_Warranty_Parts__c> parts){
        for(CSS_WS_Warranty_Parts__c p : parts){
            if(p.CSS_WS_priceBook__c  == null || p.CSS_WS_priceBook__c  == ''){
                CSS_WS_J2A_GetPartsData response = CSS_WS_GetWebServiceData.getPartsData(p.CSS_WS_PartNumber__c);
                if(response.Header.Status.toUpperCase() != 'SUCCESS'){
                    continue;
                } 
                this.partNumber = p.CSS_WS_PartNumber__c;
                this.quantity = p.CSS_WS_Quantity__c;
                this.description = p.CSS_WS_Description__c;
                this.longPartNumber = response.DataArea.PartNumberLong;
                this.superseaded = response.DataArea.SupersededPartNumber;
                this.partService = response.DataArea.PartInService;
                this.isKit = (response.DataArea.KitPartFlag=='Y') ? true : false; 
                this.description = response.DataArea.PartDescription;
                this.partProductCode = response.DataArea.PartProductCode;
                
                CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(this.ActualClaim.CSS_WS_Service_Provider_DR__c, SPPreferencesDist);
                
                if(odmRes == null){
                    System.debug('ODM Call');
                } else {
                    if(odmRes.Response.claim.status.touppercase()=='SUCCESS'){
                        this.priceBook = odmRes.Response.claim.parts.priceBook;
                        setPriceValues(p.CSS_WS_PartNumber__c, odmRes.Response.claim.parts.partPrice);
                    } else {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, odmRes.Response.claim.messages[0].description));
                        System.debug(odmRes.Response.claim.messages[0].description);
                        //continue;
                    }
                } 
            } else {
                this.partNumber = p.CSS_WS_PartNumber__c;
                this.quantity = p.CSS_WS_Quantity__c;
                this.superseaded = p.CSS_WS_Superseaded__c;
                this.partService = p.CSS_WS_PartService__c;
                this.isKit = p.CSS_WS_Kit__c;
                this.description = p.CSS_WS_Description__c;
                this.price = p.CSS_WS_Unit_Part_Price__c;
                this.subTotal = p.CSS_WS_SubTotal__c;
                this.priceBook = p.CSS_WS_priceBook__c;
                this.fromCampaign = p.CSS_WS_From_Campaign__c;
                this.fromPromotion = p.CSS_WS_From_promotion__c;
                this.siebelUnitPrice = p.CSS_WS_Siebel_Unit_Part_Price__c;
                this.siebelSubTotal = p.CSS_WS_Siebel_SubTotal__c;
                this.longPartNumber = p.CSS_WS_Long_Part_Number_del__c;
                this.partReturnFlag = p.CSS_WS_Part_Return_Flag__c;
                this.trackingGuideCode = p.CSS_WS_Tracking_Guide_Code__c;
                this.shippingCompany = p.CSS_WS_Shipping_Company__c;
                this.waiverProcess = p.CSS_WS_Waiver_Process__c;
                this.eprAttention = p.CSS_WS_EPR_Attention__c;
                this.eprNote = p.CSS_WS_EPR_Note__c;
                this.partProductCode = p.CSS_WS_Part_Product_Code__c;
            }
            //updateMap (p, this.PartCounter);
            this.PartList.add(new CreateNewPart(
                this.PartCounter++,
                this.partNumber,
                this.quantity,
                p.CSS_WS_ReplacementReasonPicklist__c,
                this.superseaded,
                this.partService,
                this.isKit,
                this.description, 
                this.price,
                this.subTotal,
                wId,
                this.priceBook,
                this.fromCampaign,
                this.fromPromotion,
                this.siebelUnitPrice,
                this.siebelSubTotal,
                this.longPartNumber,
                this.partReturnFlag,
                this.trackingGuideCode,
                this.shippingCompany,
                this.waiverProcess,
                this.eprAttention,
                this.eprNote,
                this.partProductCode
            ));
            updateMap (p, this.PartCounter);
        }
    }  
    
    Public Void computeSubTotal(){
        try {
            this.TotalAmountParts = 0;
            this.totalQuantity = 0;
            boolean show_message = false;
            for(CreateNewPart part : this.PartList){//Rule SF27
                part.Part.CSS_WS_SubTotal__c = part.Part.CSS_WS_Unit_Part_Price__c * part.Part.CSS_WS_Quantity__c;
                part.Part.CSS_WS_Siebel_SubTotal__c = part.Part.CSS_WS_Siebel_Unit_Part_Price__c * part.Part.CSS_WS_Quantity__c;
                this.TotalAmountParts += part.Part.CSS_WS_SubTotal__c;
                this.totalQuantity += Part.Part.CSS_WS_Quantity__c;
                if (part.Part.CSS_WS_Quantity__c > 25){ // To determine if the warning message should be displayed for Quantity > 15
                    show_message = true;
                }
            }
            if(show_message){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_PartsGrid_E003));//Please verify part quantity claimed.
            }
        } catch(Exception e) {
            System.debug('Error: '+ e.getMessage());
        }
    }
    
    Public Void SumPartsAmount(){
        this.TotalAmountParts = 0;
        for(CreateNewPart part : this.PartList){//Rule SF27
            this.TotalAmountParts += part.Part.CSS_WS_SubTotal__c;
        }
    }
      
    Public Void addRow(){
        System.debug('Add row');
        this.computeSubTotal();
        this.PartList.add(new CreateNewPart(this.PartCounter++, '', 1, '', '', '', false, '', 0, 0, this.warrantyId,'', false, false, 0, 0,'', false, '', '', '', '', '', ''));
    }
       
    Public Void AddNewPart(){
        this.PartList.add(new CreateNewPart(this.PartCounter++, this.partNumber, this.quantity, this.replacementreason, this.superseaded, this.partService, 
            this.isKit, this.description, this.price, this.subtotal, this.warrantyId, this.priceBook, this.fromCampaign, this.fromPromotion, this.siebelUnitPrice,
            this.siebelSubtotal, this.longPartNumber, this.partReturnFlag, this.trackingGuideCode, this.shippingCompany, this.waiverProcess, this.eprAttention, this.eprNote, this.partProductCode));
    }
    
    Public Void DeletePart(){
        Integer PartPosToDelete = findPartIndex(this.PartToDelete);
        if(PartPosToDelete != -1){
            if(this.partsMap.containsKey(this.PartList[PartPosToDelete].part.CSS_WS_PartNumber__c)){
                this.partsMap.remove(this.PartList[PartPosToDelete].part.CSS_WS_PartNumber__c);
            }
            this.PartList.remove(PartPosToDelete);
        }
        this.countParts();
        this.sumPartsAmount();
    }  
    
    Public Void EmptyValues(CSS_WS_Warranty_Parts__c part){
        part.CSS_WS_PartNumber__c = '';
        part.CSS_WS_Description__c = '';
        part.CSS_WS_ReplacementReasonPicklist__c = '';
        part.CSS_WS_Superseaded__c = '';
        part.CSS_WS_PartService__c = ''; 
        part.CSS_WS_Quantity__c  = 0;
        part.CSS_WS_Unit_Part_Price__c = 0;
        part.CSS_WS_SubTotal__c = 0;
        part.CSS_WS_Kit__c = false;
        part.CSS_WS_From_Campaign__c = false;
        part.CSS_WS_From_Promotion__c = false;
        part.CSS_WS_Siebel_Unit_Part_Price__c = 0;
        part.CSS_WS_Siebel_SubTotal__c = 0;
        part.CSS_WS_Long_Part_Number_del__c = '';
        part.CSS_WS_Part_Return_Flag__c = false;
        part.CSS_WS_Tracking_Guide_Code__c = '';
        part.CSS_WS_Shipping_Company__c = '';
        part.CSS_WS_Waiver_Process__c = '';
        part.CSS_WS_EPR_Attention__c = '';
        part.CSS_WS_EPR_Note__c = '';
        part.CSS_WS_Part_Product_Code__c = '';
    }
    
    Public Void UpdateMap(CSS_WS_Warranty_Parts__c part, Integer Index){
        if(!partsMap.containsKey(part.CSS_WS_PartNumber__c)){
            partsMap.put(part.CSS_WS_PartNumber__c,  Index);
        } else if(partsMap.get(part.CSS_WS_PartNumber__c) != Index){
            partsMap.remove(part.CSS_WS_PartNumber__c);
            partsMap.put(part.CSS_WS_PartNumber__c,  Index);
        }
    }
    
    Public Void DisplayErrorHandler(String error){
        this.ActualClaim.CSS_WS_HasError__c = 1;
        this.ActualClaim.CSS_WS_HasMessage__c = error;
    }
    
    Public Void countParts(){
        Integer i = 1;
        for(CreateNewPart part : PartList){
            part.Index = i++;
        }
        this.PartCounter = i++;
    }
    
    Public CSS_WS_Parts_In_Promotion__c getPartInPromotion(String partNumber){
        try {
            CSS_WS_Parts_In_Promotion__c part = [SELECT Id, Name, Description__c, DLR_Price__c, DR_Price__c FROM CSS_WS_Parts_In_Promotion__c WHERE Name = :partNumber LIMIT 1];
            return part; 
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }
    
    Public Boolean setPriceValues(String partNumber, String uPriceFromOdm){
        CSS_WS_Parts_In_Promotion__c pProm = getPartInPromotion(partNumber);
        try{
            if(!isDist() && pProm != null){
                // Even if the part is in Promotion we need to get the siebel price and Pricebook that corresponds to Dealer information
                CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c, SPPreferencesDlr);
                if(odmRes == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E046 ));
                    return true;
                }
                if(odmRes.Response.claim.parts.priceBook == null || odmRes.Response.claim.parts.priceBook == ''){
                    ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price_Book));
                    this.price = 0;
                    this.longPartNumber = '';
                    this.siebelUnitPrice = 0;
                    this.fromPromotion = false;
                    this.priceBook = '';
                    this.partReturnFlag = false;
                    return true;
                } 
                if(odmRes.Response.claim.parts.partPrice == null || odmRes.Response.claim.parts.partPrice == ''){
                    ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price));
                    this.price = 0;
                    this.siebelUnitPrice = 0;
                    this.longPartNumber = '';
                    this.fromPromotion = false;
                    this.priceBook = '';
                    this.partReturnFlag = false;
                    return true;
                } 
                if(odmRes.Response.claim.status.touppercase() != 'SUCCESS' && odmRes.Response.claim.status.touppercase() != 'WARNING'){
                    for(integer i=0; i<odmRes.Response.claim.messages.size(); i++){
                        ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, odmRes.Response.claim.messages[i].description));
                    }
                    this.price = 0;
                    this.siebelUnitPrice = 0;
                    this.fromPromotion = false;
                    this.priceBook = '';
                    this.partReturnFlag = false;
                    return true;
                } else {
                    this.priceBook = odmRes.Response.claim.parts.priceBook;
                    this.price = pProm.DLR_Price__c;
                    this.siebelUnitPrice = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);
                    this.fromPromotion = true;
                    return false;
                }            
                // End this change for calling out ODM validation using Dealer data
            } else if (isDist() && pProm != null){
                this.price = pProm.DR_Price__c;
                this.siebelUnitPrice = Decimal.valueOf(uPriceFromOdm);
                this.fromPromotion = true;
                return false;
            }
        } catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        if(!this.isDist()){
            CSS_WS_J2A_ODM_Validation odmRes = this.GetODMPartsInfo(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c, SPPreferencesDlr);
            if(odmRes == null){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CSS_WS_Rescue_E046 ));
                return true;
            }
            if(odmRes.Response.claim.parts.priceBook == null || odmRes.Response.claim.parts.priceBook == ''){
                ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price_Book));
                this.price = 0;
                this.longPartNumber = '';
                this.siebelUnitPrice = 0;
                this.fromPromotion = false;
                this.priceBook = '';
                this.partReturnFlag = false;
                return true;
            } else {
                this.priceBook = odmRes.Response.claim.parts.priceBook;
            }
            if(odmRes.Response.claim.parts.partPrice == null || odmRes.Response.claim.parts.partPrice == ''){
                ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, Label.CSS_WS_No_Price));
                this.price = 0;
                this.siebelUnitPrice = 0;
                this.longPartNumber = '';
                this.fromPromotion = false;
                this.priceBook = '';
                this.partReturnFlag = false;
                return true;
            } 
            if(odmRes.Response.claim.status.touppercase() != 'SUCCESS' && odmRes.Response.claim.status.touppercase() != 'WARNING'){
                for(integer i=0; i<odmRes.Response.claim.messages.size(); i++){
                    ApexPages.addMessage(new ApexPages.message (ApexPages.severity.FATAL, odmRes.Response.claim.messages[i].description));
                }
                this.price = 0;
                this.siebelUnitPrice = 0;
                this.fromPromotion = false;
                this.priceBook = '';
                this.partReturnFlag = false;
                return true;
            } else {
                this.priceBook = odmRes.Response.claim.parts.priceBook;
                this.price = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);
                this.siebelUnitPrice = Decimal.valueOf(odmRes.Response.claim.parts.partPrice);
                this.fromPromotion = false;
            }
        } else {
            this.price = Decimal.valueOf(uPriceFromOdm);
            this.siebelUnitPrice = Decimal.valueOf(uPriceFromOdm);
            this.fromPromotion = false;
        }
        return false;
    }
    
    Public Boolean isDist(){
        if(this.ActualClaim.CSS_WS_Service_Provider_Dealer__c == this.ActualClaim.CSS_WS_Service_Provider_DR__c){
            return true;
        }
        return false;
    }
    
    Public Void executeMakePartList(){
         if (this.ActualClaim.CSS_WS_ODM_SRT_Success_Flag__c){

            if(this.PartList.size() <= 0){
                this.makePartList(getSavedPartsList(wId));
                this.computeSubTotal();
            }
        }
    }
    
    Public List<SelectOption> getShippingCompanyList(){
        List<SelectOption> shipping_company = new List<SelectOption>();
        shipping_company.add(new SelectOption('',Label.CSS_WS_Selection_Shipping_Company));
        shipping_company.add(new SelectOption('DHL', 'DHL'));
        shipping_company.add(new SelectOption('FEDEX', 'FEDEX'));
        shipping_company.add(new SelectOption('UPS', 'UPS'));
        shipping_company.add(new SelectOption('XBU en SLP', 'XBU en SLP'));   
        shipping_company.add(new SelectOption('WAIVER', 'WAIVER'));  
        return shipping_company;
    }
    
    Public Void ValidateShippingCompany(){
        for(CreateNewPart part : this.PartList){
            if(part.part.CSS_WS_Shipping_Company__c == 'XBU en SLP'){ 
                part.part.CSS_WS_Tracking_Guide_Code__c = 'N/A';
            }
            if(part.part.CSS_WS_Shipping_Company__c != 'WAIVER'){ 
                part.part.CSS_WS_Waiver_Process__c = '';
            }
        }
    }
    
    Public List<SelectOption> getWaiverProcessList(){
        List<SelectOption> waiver_process = new List<SelectOption>();
        waiver_process.add(new SelectOption('',Label.CSS_WS_Selection_Waiver_Process));
        waiver_process.add(new SelectOption('Remote Field Repair', 'Remote Field Repair'));
        waiver_process.add(new SelectOption('CFSE Involvement TSR', 'CFSE Involvement TSR'));
        waiver_process.add(new SelectOption('Claim Refile', 'Claim Refile'));
        waiver_process.add(new SelectOption('Over the Counter', 'Over the Counter'));   
        waiver_process.add(new SelectOption('Not Returned', 'Not Returned'));  
        return waiver_process;
    }
    
    Public CSS_WS_J2A_GetPartReturn GetPartReturnInfo(String longpartnumber, Account SPPreferences){
        try{
            List<CSS_WS_Failure__c> fail = [SELECT CSS_WS_EngineSystemCode__c, CSS_WS_ComponentCode__c, CSS_WS_FailureModeCode__c FROM CSS_WS_Failure__c WHERE CSS_WS_Warranty__c = :this.ActualClaim.Id LIMIT 1];  
         
            Map<String, String> header = new Map<String,String>{};
            List<Map<String,String>> details = new List<Map<String,String>>{};
            header.put('PSN', this.ActualClaim.CSS_WS_Engine_Serial_Number__c);
            header.put('FAILDATE', CSS_WS_ControllerClaim.dateToString(this.ActualClaim.CSS_WS_Failure_Date_Time__c, 'yyyy-MM-dd'));
            header.put('DISTICHANNEL', SPPreferences.CSS_WS_Channel_Code__c);
            
            Map<String,String> detail = new Map<String,String>{};
            detail.put('TERRITORYCLASS', String.valueOf(SPPreferences.CSS_WS_Territory_Code__c));
            detail.put('PRODUCTFAMILY', this.ActualClaim.CSS_WS_Engine_Family_Code__c);
            detail.put('PARTNUMBER', longpartnumber);
            detail.put('FAILCODE', fail[0].CSS_WS_EngineSystemCode__c + fail[0].CSS_WS_ComponentCode__c);
            detail.put('ACCOUNTCODE', this.ActualClaim.CSS_WS_Account_Code__c);
            details.add(detail);
            
            CSS_WS_J2A_GetPartReturn obj = CSS_WS_GetWebServiceData.getPartReturn(header, details);
            return obj;
        }catch(exception ex){
            System.debug(ex.getMessage());
            return null;
        }
        return null;
    }
    
    Public PageReference GetERPFlag(){
        
        Integer partPosToFind = findPartIndex(this.PartToFind);
        if(partPosToFind == -1){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL, Label.CSS_WS_Global_E001));
            return null;
        }
            
        if(this.PartList[partPosToFind].Part.CSS_WS_PartNumber__c == '' || this.PartList[partPosToFind].Part.CSS_WS_PartNumber__c == null){
            return null;
        }
        String long_part_number = this.PartList[partPosToFind].Part.CSS_WS_Long_Part_Number_del__c.trim();
        String replacement_reason_value = this.PartList[partPosToFind].Part.CSS_WS_ReplacementReasonPicklist__c;
                
        //system.debug('Replacement Reason: ' + Replacement_Reason);
        if(replacement_reason_value == 'Root Cause' && long_part_number != '' ){
            CSS_WS_J2A_GetPartReturn part_return_res = this.GetPartReturnInfo(long_part_number, SPPreferencesDlr);                
            if(part_return_res != null){
                if(part_return_res.DataArea != null){
                    if(part_return_res.DataArea.size() > 0){
                        if(part_return_res.DataArea[0].PARTNUMBER == long_part_number){
                            if(part_return_res.DataArea[0].EPRFLAG == 'Y'){
                                //this.partReturnFlag = true;
                                this.PartList[partPosToFind].Part.CSS_WS_Part_Return_Flag__c = true;
                                this.PartList[partPosToFind].Part.CSS_WS_EPR_Attention__c = part_return_res.DataArea[0].ATTENTION;
                                String EPR_Note = 'MESSAGE: ' + part_return_res.DataArea[0].ATTENTION;
                                EPR_Note = EPR_Note + ' ' + part_return_res.DataArea[0].COMPANY;
                                EPR_Note = EPR_Note + ' ' + part_return_res.DataArea[0].LOCATION;
                                //EPR_Note = EPR_Note + ' ' + part_return_res.DataArea[0].MESSAGE;
                                EPR_Note = EPR_Note + ' ' + part_return_res.DataArea[0].RETURNMESSAGE;
                                this.PartList[partPosToFind].Part.CSS_WS_EPR_Note__c = EPR_Note;
                                ApexPages.addMessage(new ApexPages.message (ApexPages.severity.WARNING, EPR_Note + ' FOLLOWING PARTS TO BE RETURNED: ' + part_return_res.DataArea[0].PARTNUMBER));
                            } else {
                                //this.partReturnFlag = false;
                                this.PartList[partPosToFind].Part.CSS_WS_Part_Return_Flag__c = false;
                                this.PartList[partPosToFind].Part.CSS_WS_Tracking_Guide_Code__c = '';
                                this.PartList[partPosToFind].Part.CSS_WS_Shipping_Company__c = '';
                                this.PartList[partPosToFind].Part.CSS_WS_EPR_Attention__c = '';
                                this.PartList[partPosToFind].Part.CSS_WS_EPR_Note__c = '';
                            }
                        }
                    }
                }
            }   
        } else {
            this.PartList[partPosToFind].Part.CSS_WS_Part_Return_Flag__c = false;
            this.PartList[partPosToFind].Part.CSS_WS_Tracking_Guide_Code__c = '';
            this.PartList[partPosToFind].Part.CSS_WS_Shipping_Company__c = '';
            this.PartList[partPosToFind].Part.CSS_WS_EPR_Attention__c = '';
            this.PartList[partPosToFind].Part.CSS_WS_EPR_Note__c = '';
        }
        return null;
    }
    
}