Global Class CSS_WS_CreateStmx Implements Schedulable {

    Public Static String CRON_EXP = '0 0 */3 ? * MON-FRI';
    
    Global Void execute(SchedulableContext ctx) {
       processWarrantyClaims();
       //processServiceOrders();
    }
    
    @future(callout = true)
    Public Static Void processWarrantyClaims(){
        CSS_WS_Warranty__c[] pendingClaims = [SELECT CSS_WS_Claim_Number__c, CSS_WS_Service_Provider_Dealer__c, CSS_WS_Service_Provider_DR__c,
            CSS_WS_Claim_Amount__c, CSS_WS_Policy_Flag__c, CSS_WS_Total_Amount_Other_Claimables__c, CSS_WS_Total_Amount_Part__c, CSS_WS_Total_Amount_SRT__c, 
            CSS_WS_Total_Amount_Travel__c, CSS_WS_Claim_Status__c , CSS_WS_Total_Travel__c, CSS_WS_Belongs_To__c, CSS_WS_Total_Parts_Approved__c, 
            CSS_WS_Total_Labor_Approved__c, CSS_WS_Total_Other_Approved__c, CSS_WS_Total_Travel_Approved__c, CSS_WS_Total_Claim_Approved__c,  
            CSS_WS_Total_Parts__c, CSS_WS_Total_Labor__c, CSS_WS_Total_Other__c, CSS_WS_Total_Approved__c, CSS_WS_Parts_Mark_Up__c, CSS_WS_Pay_Code__c,
            CSS_WS_Authorized_Amount__c, CSS_WS_Account_Code__c, CSS_WS_Beyond_Factory_Charges__c, CSS_WS_Travel_Paid_Before__c, CSS_WS_Towing_Amount__c, 
            CSS_WS_Service_Order_Counter_Flag__c, CSS_WS_Service_Provider_DR_ToCharge__c, CSS_WS_Service_Provider_Dealer_ToCharge__c, CSS_WS_Engine_Application_Code__c,
            (SELECT CSS_WS_Total_Price__c FROM CSS_WS_US_Details__r WHERE CSS_WS_Type_Section__c = 'Parts')
            FROM CSS_WS_Warranty__c
            WHERE CSS_WS_Claim_Status__c = 'Pending Planta Payment'//US Claims
            OR CSS_WS_Claim_Status__c = 'Approved for Payment'];//Policy
        Map<String, Map<Id,CSS_WS_Warranty__c>> claimsByDR = new Map<String, Map<Id,CSS_WS_Warranty__c>>{};
            for(CSS_WS_Warranty__c claim : pendingClaims){
                /*if(claimsByDR.get(claim.CSS_WS_Service_Provider_DR__c) == null){//Add claim.CSS_WS_Service_Provider_Dealer__c
                    claimsByDR.put(claim.CSS_WS_Service_Provider_DR__c, new Map<Id, CSS_WS_Warranty__c>{claim.Id => claim});
                } else {
                    claimsByDR.get(claim.CSS_WS_Service_Provider_DR__c).put(claim.Id, claim);
                }*/
                if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){
                    if(claimsByDR.get(claim.CSS_WS_Service_Provider_Dealer_ToCharge__c) == null){//Add claim.CSS_WS_Service_Provider_Dealer_ToCharge__c
                        claimsByDR.put(claim.CSS_WS_Service_Provider_Dealer_ToCharge__c, new Map<Id, CSS_WS_Warranty__c>{claim.Id => claim});
                    } else {
                        claimsByDR.get(claim.CSS_WS_Service_Provider_Dealer_ToCharge__c).put(claim.Id, claim);
                    }
                } else {
                    if(claimsByDR.get(claim.CSS_WS_Service_Provider_Dealer__c) == null){//Add claim.CSS_WS_Service_Provider_Dealer__c
                        claimsByDR.put(claim.CSS_WS_Service_Provider_Dealer__c, new Map<Id, CSS_WS_Warranty__c>{claim.Id => claim});
                    } else {
                        claimsByDR.get(claim.CSS_WS_Service_Provider_Dealer__c).put(claim.Id, claim);
                    }
                }
            }
        Map<String, Account> SPAccountsDealer = new Map<String, Account>();
        Map<String, Account> SPAccountsDistributor = new Map<String, Account>();
        Map<String, Account> SPAccountsFleet = new Map<String, Account>();

        for(Account SPDR : [SELECT Id, CSS_WS_Address_ID_Bill__c, CSS_WS_Address_ID_Ship__c, CSS_WS_Customer_ID__c, IAM_Service_Provider_Code__c, CSS_DBCode__c, Type, CSS_WS_Transfer_Flag__c, BillingCountry FROM Account 
            WHERE (Type = 'Dealer Account' OR Type = 'Distributor Account' OR Type = 'Dealer Branch Account' OR Type = 'Distributor Branch Account' OR Type = 'Fleet') AND 
            (CSS_DBCode__c = '00863' OR CSS_DBCode__c = '74798' OR CSS_DBCode__c = '54699' OR CSS_DBCode__c = '73011' OR CSS_DBCode__c = '56092' 
            OR CSS_DBCode__c = '56155' OR CSS_DBCode__c = '54809' OR CSS_DBCode__c = '54681' OR CSS_DBCode__c = '54701' OR CSS_DBCode__c = '40711' 
            OR CSS_DBCode__c = '54665' OR CSS_DBCode__c = '54700' OR CSS_DBCode__c = '54734') AND CMI_Account_Status__c = 'Active']){
            if(SPDR.Type == 'Dealer Account' || SPDR.Type == 'Dealer Branch Account'){
                SPAccountsDealer.put(SPDR.IAM_Service_Provider_Code__c, SPDR);
            } else if (SPDR.Type == 'Distributor Account' || SPDR.Type == 'Distributor Branch Account'){
                SPAccountsDistributor.put(SPDR.IAM_Service_Provider_Code__c, SPDR);
            } else if (SPDR.Type == 'Fleet'){
                SPAccountsFleet.put(SPDR.CSS_DBCode__c, SPDR); //get Account for Paccar Parts Mexico
            }
        }        
        List<CSS_WS_Warranty__c> claimsToUpdate = new List<CSS_WS_Warranty__c>{};
        Integer count_callout = 0;
            for(String SPDR : claimsByDR.keySet()){
                Map<Id, CSS_WS_Warranty__c> claims = claimsByDR.get(SPDR);
                Map<String, String> header = new Map<String, String>{};
                List<Map<String, String>> details = new List<Map<String, String>>{};
                Decimal totalClaimAmount = 0; 
                Integer lineId = 1;
                String creditNumber = '';
                boolean stmx_flag_exclusion = false;
                for(Id claimId : claims.keySet()){
                    CSS_WS_Warranty__c claim = claims.get(claimId);
                    String distributor;
                    String dealer; 
                    if(claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){// settings for Sales Order Invoice creation
                        distributor = claim.CSS_WS_Service_Provider_DR_ToCharge__c;
                        dealer = claim.CSS_WS_Service_Provider_Dealer_ToCharge__c ;
                    } else {
                        distributor = claim.CSS_WS_Service_Provider_DR__c;
                        dealer = claim.CSS_WS_Service_Provider_Dealer__c ;
                    }                   
                    
                    String TranslatedDescription = '';
                    //Decimal claimAmount = claim.CSS_WS_Claim_Amount__c;
                    Decimal claimAmount = 0;
                    //if(claim.CSS_WS_Belongs_To__c == 'Paccar'){
                    //    distributor = '54699'; //PACCAR MEXICO DR ACCOUNT
                    //    dealer = '54699'; //PACCAR MEXICO DR ACCOUNT
                    //}
                    
                    /*Account SPAccount = [SELECT CSS_WS_Address_ID_Bill__c, CSS_WS_Address_ID_Ship__c, CSS_WS_Customer_ID__c
                        FROM Account WHERE CSS_DealerCode__c =: dealer AND CSS_DBCode__c =: distributor];
                    
                    Account SPAccount = [SELECT CSS_WS_Address_ID_Bill__c, CSS_WS_Address_ID_Ship__c, CSS_WS_Customer_ID__c
                        FROM Account WHERE (CSS_DealerCode__c =: dealer AND CSS_DBCode__c =: distributor AND Type = 'Dealer Account') 
                        OR (CSS_DBCode__c =: distributor AND Type = 'Distributor Account') ORDER BY Type LIMIT 1];*/
                    
                    //---> Change for excluding all claims that the DR/Dealer has empty value for "CSS_WS_Address_ID_Bill__c" field
                    Account SPAccount = new Account();
                    if(claim.CSS_WS_Belongs_To__c == 'Paccar'){
                        distributor = '54699'; //PACCAR MEXICO DR ACCOUNT
                        dealer = '54699'; //PACCAR MEXICO DR ACCOUNT
                        if(SPAccountsFleet.containsKey(distributor)){//If exist the Key is Fleet (Paccar Parts Mexico)
                            SPAccount = SPAccountsFleet.get(distributor);
                        }
                    } else {
                        if(SPAccountsDealer.containsKey(dealer)){//If exist the Key is Dealer
                            SPAccount = SPAccountsDealer.get(dealer);
                        } else if(SPAccountsDistributor.containsKey(distributor)){
                            SPAccount = SPAccountsDistributor.get(distributor);
                        }
                    }
                    if (String.isEmpty(String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c))){
                        // Claim is not added to Statement Creation
                    } else {
                        // Map for this claim is created for being added to Statement Creation
                        stmx_flag_exclusion = true;
                    
                    Map<String, String> detail = new Map<String, String>{};
                    //Header will have the last Claim Number consecutive
                    if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){
                        creditNumber = 'CSSMXF-' + claim.CSS_WS_Claim_Number__c.substring(2);
                    } else {
                        creditNumber = 'CSSMXC-' + claim.CSS_WS_Claim_Number__c.substring(2);
                    }
                    header.put('InterfaceLineAttribute1', creditNumber );
                    detail.put('LineNumber','');
                    detail.put('SalesOrder', String.valueof(claim.CSS_WS_Claim_Number__c));
                    detail.put('InterfaceLineAttribute6', String.valueof(lineId));
                    if(claim.CSS_WS_Claim_Status__c == 'Pending Planta Payment'){//Warranty Claims & PolicyWW claims
                        detail.put('BatchSourceName', 'IAD Credit Memo');
                        detail.put('InventoryItemId', '85267');
                        detail.put('Attribute1', 'BONIFICACION GARANTIAS Linea: '+lineId);
                        detail.put('Description', 'GARANTIAS');
                        TranslatedDescription = 'BONIFICACION GARANTIAS ';
                    } else if (claim.CSS_WS_Account_Code__c != 'P101'){ //Approved for Payment - Policy Claims different than P101
                        detail.put('BatchSourceName', 'IAD Credit Memo');
                        if (claim.CSS_WS_Account_Code__c == 'P99'){
                            detail.put('InventoryItemId', '9947969');
                        } else {
                            detail.put('InventoryItemId', '85253');
                        }
                        detail.put('Attribute1', 'BONIFICACION POLITICA Linea: '+lineId);
                        detail.put('Description', 'POLITICAS DRS-G');
                        TranslatedDescription = 'BONIFICACION POLITICA ';
                    } else if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 1){ //Policy Claims P101 for creating credit statement
                        detail.put('BatchSourceName', 'IAD Credit Memo');
                        detail.put('InventoryItemId', '85267');
                        detail.put('Attribute1', 'PAGO ORDENES DE SERVICIO Linea: '+lineId);
                        detail.put('Description', 'PAGO ORDENES DE SERVICIO');
                        TranslatedDescription = 'PAGO FACTURA ORDENES SERVICIO ';                    
                    } else { //Policy Claims P101 for creating invoice statement
                        detail.put('BatchSourceName', 'IAD Invoice');
                        detail.put('InventoryItemId', '8610647');
                        detail.put('Attribute1', 'CARGO ORDENES DE SERVICIO Linea: '+lineId);
                        detail.put('Description', 'CARGO ORDENES DE SERVICIO');
                        TranslatedDescription = 'FACTURA ORDENES SERVICIO ';                      
                    }
                    //detail.put('Amount', String.valueof(claimAmount * -1));
                    if(claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){// settings for Sales Order Invoice statement
                        detail.put('CustTrxTypeId', '4560');
                        detail.put('Quantity', String.valueof(1));
                    }else{
                        detail.put('CustTrxTypeId', '4558');
                        detail.put('Quantity', String.valueof(-1));                        
                    }
                    detail.put('OrigSystemBillCustomerId', String.valueof(SPAccount.CSS_WS_Customer_ID__c));
                    detail.put('OrigSystemBillAddressId', String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c));
                    detail.put('OrigSystemShipCustomerId', String.valueof(SPAccount.CSS_WS_Customer_ID__c));
                    detail.put('OrigSystemShipAddressId', String.valueof(SPAccount.CSS_WS_Address_ID_Ship__c));
                    //detail.put('UnitSellingPrice',String.valueof(claimAmount));
                    if (claim.CSS_WS_Account_Code__c == 'P101'){
                        detail.put('OrigSystemSoldCustomerId', '""');
                    } else {
                        detail.put('OrigSystemSoldCustomerId', String.valueof(SPAccount.CSS_WS_Customer_ID__c));
                    }
                    //Start change for sending the COMMENTS field - April 29th 2020
                    if(SPAccount.CSS_WS_Transfer_Flag__c){
                        if(claim.CSS_WS_Account_Code__c == 'P101'){ // Adjustment for P101 claims - Jun 19th 2020
                            detail.put('Comments', '');
                        } else{
                            detail.put('Comments', 'TRANSFERENCIA');
                        }
                    } else {
                        detail.put('Comments', '');
                    }
                    //End change for sending the COMMENTS field - April 29th 2020                    
                    TranslatedDescription += 'Folio: ' + claim.CSS_WS_Claim_Number__c + ' ';
                    if (claim.CSS_WS_Policy_Flag__c == 'Warranty' || claim.CSS_WS_Policy_Flag__c == 'Policy WW'){ // For Warranty and PolicyWW
                        // Verify what amount to use for Parts (requested by user or approved by US)
                        if(claim.CSS_WS_Total_Amount_Part__c > 0){
                                                                                    
                            /*
                            // We need to take the sum of Total_Parts, Parts_Mark_Up and Beyond_Factory_Charges. And then compare the values.
                            //Decimal Parts_Mark_Up          = !String.isEmpty(claim.CSS_WS_Parts_Mark_Up__c) ? decimal.valueof(claim.CSS_WS_Parts_Mark_Up__c) : 0;
                            //Decimal Beyond_Factory_Charges = !String.isEmpty(claim.CSS_WS_Beyond_Factory_Charges__c) ? decimal.valueof(claim.CSS_WS_Beyond_Factory_Charges__c) : 0;

                            if (claim.CSS_WS_Total_Parts__c != null){
                                Parts = claim.CSS_WS_Total_Parts__c.setscale(2);
                            } 
                            Decimal Total_Parts = Parts_Mark_Up + Beyond_Factory_Charges + Parts;
                            
                            if(claim.CSS_WS_Total_Parts__c != null && claim.CSS_WS_Total_Amount_Part__c > Total_Parts){                                
                                claim.CSS_WS_Total_Parts_Approved__c = Total_Parts.setscale(2);
                            } else{
                                claim.CSS_WS_Total_Parts_Approved__c = claim.CSS_WS_Total_Amount_Part__c.setscale(2);
                            }
                            */  
                            
                            /* //New way to calculate the total Parts for being paid  
                            Decimal Parts = 0;                          
                            CSS_WS_US_Details__c[] parts_list = claim.CSS_WS_US_Details__r;
                            for(CSS_WS_US_Details__c part: parts_list){
                                if(part.CSS_WS_Total_Price__c != null){
                                    Parts = Parts + part.CSS_WS_Total_Price__c.setscale(2);
                                }
                            }
                            
                            //Decimal Total_Parts = Parts_Mark_Up + Beyond_Factory_Charges + Parts;
                            claim.CSS_WS_Total_Parts_Approved__c = Parts.setscale(2);                            
                            // End the new calculation */   
                            
                            // New adjustment (January 9th 2010). Always the payment for parts will be the sum of Total_Parts, Parts_Mark_Up and Beyond_Factory_Charges.
                            
                            Decimal Parts_Mark_Up          = !String.isEmpty(claim.CSS_WS_Parts_Mark_Up__c) ? decimal.valueof(claim.CSS_WS_Parts_Mark_Up__c) : 0;
                            Decimal Beyond_Factory_Charges = !String.isEmpty(claim.CSS_WS_Beyond_Factory_Charges__c) ? decimal.valueof(claim.CSS_WS_Beyond_Factory_Charges__c) : 0;
                            Decimal Parts = 0; 
                            if (claim.CSS_WS_Total_Parts__c != null){
                                Parts = claim.CSS_WS_Total_Parts__c.setscale(2);
                            }                                                                                   
                            Decimal Total_Parts = Parts_Mark_Up + Beyond_Factory_Charges + Parts;
                            claim.CSS_WS_Total_Parts_Approved__c = Total_Parts.setscale(2);  
                            
                            // End new adjustment.                                                                                 
                            
                            TranslatedDescription += 'Monto Partes: ' + claim.CSS_WS_Total_Parts_Approved__c.setscale(2) + ' ';
                        } else {
                            claim.CSS_WS_Total_Parts_Approved__c = 0;
                        }
                        // Verify what amount to use for Labor (requested by user or approved by US)
                        if(claim.CSS_WS_Total_Amount_SRT__c > 0){
                            if(claim.CSS_WS_Total_Labor__c != null && claim.CSS_WS_Total_Amount_SRT__c > claim.CSS_WS_Total_Labor__c){                                
                                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Labor__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Amount_SRT__c.setscale(2);
                            }
                            TranslatedDescription += 'Monto Mano de Obra: ' + claim.CSS_WS_Total_Labor_Approved__c.setscale(2) + ' ';
                        } else {
                            claim.CSS_WS_Total_Labor_Approved__c = 0;
                        }
                        // Verify what amount to use for Other Claimables (requested by user or approved by US)    
                        if(claim.CSS_WS_Total_Amount_Other_Claimables__c > 0){
                            if (claim.CSS_WS_Total_Other__c != null && claim.CSS_WS_Total_Amount_Other_Claimables__c > claim.CSS_WS_Total_Other__c){
                                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Other__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Amount_Other_Claimables__c.setscale(2);
                            }
                            TranslatedDescription += 'Monto Otros Rec.: ' + claim.CSS_WS_Total_Other_Approved__c.setscale(2) + ' ';
                        } else {
                            claim.CSS_WS_Total_Other_Approved__c = 0;
                        }
                        // Verify what amount to use for Travel (requested by user or approved by US), the rest will be requested by Rescue    
                        if(claim.CSS_WS_Total_Amount_Travel__c > 0){
                            if(claim.CSS_WS_Total_Travel__c != null && claim.CSS_WS_Total_Amount_Travel__c > claim.CSS_WS_Total_Travel__c){
                                TranslatedDescription += 'Monto Viaje: ' + claim.CSS_WS_Total_Travel__c.setscale(2);
                                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Travel__c.setscale(2);
                            } else {
                                TranslatedDescription += 'Monto Viaje: ' + claim.CSS_WS_Total_Amount_Travel__c.setscale(2);
                                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Amount_Travel__c.setscale(2);
                            }
                        } else {
                            claim.CSS_WS_Total_Travel_Approved__c = 0;
                        }                    
                    } else {  // For Policy
                        if (claim.CSS_WS_Account_Code__c == 'P88' || claim.CSS_WS_Account_Code__c == 'P93' || claim.CSS_WS_Account_Code__c == 'P99' || claim.CSS_WS_Account_Code__c == 'P100'){
                            claim.CSS_WS_Total_Parts_Approved__c = 0;
                            claim.CSS_WS_Total_Labor_Approved__c = 0;
                            claim.CSS_WS_Total_Other_Approved__c = 0;
                            claim.CSS_WS_Total_Travel_Approved__c = 0;
                        } else {
                            if(claim.CSS_WS_Total_Amount_Part__c > 0){
                                TranslatedDescription += 'Monto Partes: ' + claim.CSS_WS_Total_Amount_Part__c.setscale(2) + ' ';
                                claim.CSS_WS_Total_Parts_Approved__c = claim.CSS_WS_Total_Amount_Part__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Parts_Approved__c = 0;
                            }   
                            if(claim.CSS_WS_Total_Amount_SRT__c > 0) {
                                TranslatedDescription += 'Monto Mano de Obra: ' + claim.CSS_WS_Total_Amount_SRT__c.setscale(2) + ' ';
                                claim.CSS_WS_Total_Labor_Approved__c = claim.CSS_WS_Total_Amount_SRT__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Labor_Approved__c = 0;
                            }                           
                            if(claim.CSS_WS_Total_Amount_Other_Claimables__c > 0){
                                TranslatedDescription += 'Monto Otros Rec.: ' + claim.CSS_WS_Total_Amount_Other_Claimables__c.setscale(2) + ' ';
                                claim.CSS_WS_Total_Other_Approved__c = claim.CSS_WS_Total_Amount_Other_Claimables__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Other_Approved__c = 0;
                            }                           
                            if(claim.CSS_WS_Total_Amount_Travel__c > 0 && claim.CSS_WS_Travel_Paid_Before__c == false){
                                TranslatedDescription += 'Monto Viaje: ' + claim.CSS_WS_Total_Amount_Travel__c.setscale(2);
                                claim.CSS_WS_Total_Travel_Approved__c = claim.CSS_WS_Total_Amount_Travel__c.setscale(2);
                            } else {
                                claim.CSS_WS_Total_Travel_Approved__c = 0;
                            }
                        }
                    }                    
                    detail.put('TranslatedDescription', TranslatedDescription);
                    // Get total Claim Amount approved by MX
                    if (claim.CSS_WS_Policy_Flag__c == 'Policy' && (claim.CSS_WS_Account_Code__c == 'P88' || claim.CSS_WS_Account_Code__c == 'P93' || claim.CSS_WS_Account_Code__c == 'P99' || claim.CSS_WS_Account_Code__c == 'P100')) {
                        if (claim.CSS_WS_Authorized_Amount__c != null){
                            claim.CSS_WS_Total_Claim_Approved__c = claim.CSS_WS_Authorized_Amount__c.setscale(2);
                        } else {
                            claim.CSS_WS_Total_Claim_Approved__c = 0;
                        }
                    } else {
                        claim.CSS_WS_Total_Claim_Approved__c = claim.CSS_WS_Total_Parts_Approved__c + claim.CSS_WS_Total_Labor_Approved__c + claim.CSS_WS_Total_Other_Approved__c + claim.CSS_WS_Total_Travel_Approved__c;
                    }
                    claimAmount = claim.CSS_WS_Total_Claim_Approved__c.setscale(2);  
                    detail.put('UnitSellingPrice',String.valueof(claimAmount));  
                    if(claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){// settings for Sales Order Invoice statement  
                        detail.put('Amount', String.valueof(claimAmount));
                        totalClaimAmount -= claimAmount;
                    }else{
                        detail.put('Amount', String.valueof(claimAmount * -1));
                        totalClaimAmount += claimAmount;
                    }           
                    details.add(detail);
                    lineId++;
                    //Rescue Difference
                    if(claim.CSS_WS_Engine_Application_Code__c == '410' || claim.CSS_WS_Engine_Application_Code__c == '510' || claim.CSS_WS_Engine_Application_Code__c == '520' 
                         || claim.CSS_WS_Engine_Application_Code__c == '530' || claim.CSS_WS_Engine_Application_Code__c == '610' || claim.CSS_WS_Engine_Application_Code__c == '620' 
                         || claim.CSS_WS_Engine_Application_Code__c == '635' || claim.CSS_WS_Engine_Application_Code__c == '650' || claim.CSS_WS_Engine_Application_Code__c == '655' 
                         || claim.CSS_WS_Engine_Application_Code__c == '660' || claim.CSS_WS_Engine_Application_Code__c == '662' || claim.CSS_WS_Engine_Application_Code__c == '663' 
                         || claim.CSS_WS_Engine_Application_Code__c == '810' || claim.CSS_WS_Engine_Application_Code__c == '820' || claim.CSS_WS_Engine_Application_Code__c == '850' 
                         || claim.CSS_WS_Engine_Application_Code__c == '890' || claim.CSS_WS_Engine_Application_Code__c == '891'){
                    
                        // don't create Rescue Item - Engine Application Code is 410, 510, 520, 530, 610, 620, 635, 650, 655, 660, 662, 663, 810, 820, 850, 890, OR 891
                    } else if((claim.CSS_WS_Pay_Code__c == 'T' || claim.CSS_WS_Pay_Code__c == 'S' || claim.CSS_WS_Pay_Code__c == 'C' || claim.CSS_WS_Pay_Code__c == 'L') && 
                        (claim.CSS_WS_Engine_Application_Code__c == '130' || claim.CSS_WS_Engine_Application_Code__c == '210' || claim.CSS_WS_Engine_Application_Code__c == '220' || claim.CSS_WS_Engine_Application_Code__c == '310'
                         || claim.CSS_WS_Engine_Application_Code__c == '320')){
                    
                        // don't create Rescue Item - (Engine Application Code is 130, 210, 220, 310, OR 320) AND (Pay Code is T, S, C, OR L) 
                    } else if(SPAccount.BillingCountry.toUpperCase() == 'MEXICO' && claim.CSS_WS_Towing_Amount__c > 0){
                    
                        // don't create Rescue Item - Towing amount > 0, AND Mexico Account
                    } else {
                        if(claim.CSS_WS_Total_Travel__c != null && claim.CSS_WS_Total_Amount_Travel__c != null){
                            if(claim.CSS_WS_Total_Travel__c < claim.CSS_WS_Total_Amount_Travel__c){
                                Decimal total = claim.CSS_WS_Total_Amount_Travel__c.setscale(2) - claim.CSS_WS_Total_Travel__c.setscale(2);
                                detail = new Map<String,String>{};
                                detail.put('LineNumber','');
                                detail.put('SalesOrder', String.valueof(claim.CSS_WS_Claim_Number__c));
                                detail.put('InterfaceLineAttribute6',String.valueof(lineId));
                                detail.put('BatchSourceName','IAD Credit Memo');
                                detail.put('Attribute1','BONIFICACION RESCATES Linea: '+lineId);
                                detail.put('Description','RESCATES-G');
                                detail.put('CustTrxTypeId','4558');
                                detail.put('InventoryItemId','85254');
                                detail.put('Amount',String.valueof(total * -1));
                                detail.put('OrigSystemBillCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
                                detail.put('OrigSystemBillAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c));
                                detail.put('OrigSystemShipCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c)); 
                                detail.put('OrigSystemShipAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Ship__c));
                                detail.put('UnitSellingPrice',String.valueof(total));
                                detail.put('Quantity',String.valueof(-1));
                                detail.put('OrigSystemSoldCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
                                //Start change for sending the COMMENTS field - April 29th 2020
                                if(SPAccount.CSS_WS_Transfer_Flag__c){
                                    if(claim.CSS_WS_Account_Code__c == 'P101'){ // Adjustment for P101 claims - Jun 19th 2020
                                        detail.put('Comments', '');
                                    } else{
                                        detail.put('Comments', 'TRANSFERENCIA');
                                    }
                                } else {
                                    detail.put('Comments', '');
                                }
                                //End change for sending the COMMENTS field - April 29th 2020
                                detail.put('TranslatedDescription', 'BONIFICACION RESCATES Folio: ' + claim.CSS_WS_Claim_Number__c + ' Monto Viaje: ' + total.setscale(2));
                                totalClaimAmount += total;
                                details.add(detail);
                                lineId++;
                            }
                        }
                    }
                        
                    //End the process for excluding the claims 
                    }
                }
                header.put('Amount',String.valueof(totalClaimAmount*-1));
                
                //---> Flag used in validation for avoiding WS callout for CreateStatementMX
                if (stmx_flag_exclusion){
                    
                    System.debug('--WARRANTY CREDIT STATEMENT--');
                    CSS_WS_J2A_CreateStatementMX createStatementResponse = CSS_WS_GetWebServiceData.createStatementMX(header, details);//Web Service call
                    
                    if(createStatementResponse != null){
                        if(createStatementResponse.Header.Status.touppercase()=='SUCCESS'){
                            for(Id claimId : claims.keySet()){
                                CSS_WS_Warranty__c claim = claims.get(claimId);
                                
                                //---> Change for excluding all claims that the DR/Dealer has empty value for "CSS_WS_Address_ID_Bill__c" field
                                String distributor;
                                String dealer;
                                if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){ // settings for Sales Order Invoice creation
                                    distributor = claim.CSS_WS_Service_Provider_DR_ToCharge__c;
                                    dealer = claim.CSS_WS_Service_Provider_Dealer_ToCharge__c;
                                } else {
                                    distributor = claim.CSS_WS_Service_Provider_DR__c;
                                    dealer = claim.CSS_WS_Service_Provider_Dealer__c;
                                }
                                //if(claim.CSS_WS_Belongs_To__c == 'Paccar'){
                                //    distributor = '99212'; //PACCAR MEXICO DR ACCOUNT
                                //    dealer = '99212'; //PACCAR MEXICO DR ACCOUNT
                                //}
                                /*Account SPAccount = [SELECT CSS_WS_Address_ID_Bill__c FROM Account 
                                    WHERE (CSS_DealerCode__c =: dealer AND CSS_DBCode__c =: distributor AND Type = 'Dealer Account') 
                                    OR (CSS_DBCode__c =: distributor AND Type = 'Distributor Account') ORDER BY Type LIMIT 1];*/
                                Account SPAccount = new Account();
                                if(claim.CSS_WS_Belongs_To__c == 'Paccar'){
                                    distributor = '54699'; //PACCAR MEXICO DR ACCOUNT
                                    dealer = '54699'; //PACCAR MEXICO DR ACCOUNT
                                    if(SPAccountsFleet.containsKey(distributor)){//If exist the Key is Fleet (Paccar Parts Mexico)
                                        SPAccount = SPAccountsFleet.get(distributor);
                                    }
                                } else {
                                    if(SPAccountsDealer.containsKey(dealer)){//If exist the Key is Dealer
                                        SPAccount = SPAccountsDealer.get(dealer);
                                    } else if(SPAccountsDistributor.containsKey(distributor)){
                                        SPAccount = SPAccountsDistributor.get(distributor);
                                    }
                                }
                                if (String.isEmpty(String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c))){
                                    claim.CSS_WS_Claim_Status__c  = 'Invoice Payment';
                                    //claim.CSS_WS_DR_Credit_Number__c = creditNumber;
                                    claimsToUpdate.add(claim);
                                } else { 
                                    if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 1){ // settings for Sales Order credit statement
                                        claim.CSS_WS_Service_Order_Counter_Flag__c = 2;
                                        claimsToUpdate.add(claim);
                                    } else {
                                        if (claim.CSS_WS_Account_Code__c == 'P101' && claim.CSS_WS_Service_Order_Counter_Flag__c == 2){ // settings for Sales Order invoice statement
                                            claim.CSS_WS_Service_Order_Counter_Flag__c = 3;
                                        }
                                        claim.CSS_WS_Claim_Status__c  = 'Pending CM';
                                        claim.CSS_WS_DR_Credit_Number__c = creditNumber;
                                        claimsToUpdate.add(claim);
                                    }                                       
                                }
                            }
                        }
                    }
                    count_callout = count_callout + 1;
                    if (count_callout >= 49 ){
                        break;
                    }
                } else {
                    for(Id claimId : claims.keySet()){
                        CSS_WS_Warranty__c claim = claims.get(claimId);
                        claim.CSS_WS_Claim_Status__c  = 'Invoice Payment';
                        //claim.CSS_WS_DR_Credit_Number__c = creditNumber;
                        claimsToUpdate.add(claim);
                    }
                }
            }
        if(claimsToUpdate.size() > 0){
            update claimsToUpdate;
        }
        //this.sendEmail(claimsToUpdate.size());
    }
        
    /*@future(callout=true)
Public Static Void processServiceOrders(){
CSS_WS_Service_Order__c[] pendingServiceOrders = [
SELECT Name, Recibe_la_Orden__c, Emite_la_Orden__c, CSS_WS_Estatus__c, Monto_Total_de_Ordenes_de_Servicio__c,
Monto_Total_de_Reclamables__c, Monto_Total_de_Viajes__c, Monto_Total_SRT__c, Monto_Total_Partes__c
FROM CSS_WS_Service_Order__c
WHERE CSS_WS_Estatus__c= 'Pending Payment'
];

List<CSS_WS_Service_Order__c > serviceOrdersToUpdate = new List<CSS_WS_Service_Order__c >{};
for(CSS_WS_Service_Order__c serviceOrder: pendingServiceOrders){
Map<String, String> header = new Map<String,String>{};
List<Map<String,String>> details = new List<Map<String,String>>{};
String creditNumber = 'CSSMXC-'+serviceOrder.Name.substring(3);
String debitNumber = 'CSSMXD-'+serviceOrder.Name.substring(3);
System.debug('TOTAL SO: '+serviceOrder.Monto_Total_de_Ordenes_de_Servicio__c);
Decimal Amount = serviceOrder.Monto_Total_de_Ordenes_de_Servicio__c;
System.debug('TOTAL A SO: '+serviceOrder.Monto_Total_de_Ordenes_de_Servicio__c);
Account SPAccount = [
SELECT CSS_WS_Address_ID_Bill__c, CSS_WS_Address_ID_Ship__c, CSS_WS_Customer_ID__c
FROM Account
WHERE CSS_DealerCode__c =: serviceOrder.Recibe_la_Orden__c
AND CSS_DBCode__c =: serviceOrder.Recibe_la_Orden__c
];
//CREATE CREDIT STATEMENT
Map<String,String> detail = new Map<String,String>{};
header.put('InterfaceLineAttribute1',creditNumber );
header.put('Amount',String.valueof(Amount*-1));
detail.put('LineNumber','');
detail.put('InterfaceLineAttribute6','1');
detail.put('InventoryItemId','85254');
detail.put('BatchSourceName','IAD Credit Memo');
detail.put('Attribute1','BONIFICACION RESCATES Linea: 1');
detail.put('Description','RESCATES-G');
detail.put('CustTrxTypeId','5558');
detail.put('OrigSystemBillCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
detail.put('OrigSystemBillAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c));
detail.put('OrigSystemShipCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
detail.put('OrigSystemShipAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Ship__c));
detail.put('Amount',String.valueof(Amount*-1));
detail.put('UnitSellingPrice',String.valueof(Amount));
detail.put('Quantity',String.valueof(-1));
detail.put('OrigSystemSoldCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
String TranslatedDescription = 'Folio: ' + serviceOrder.name + ' ';
if(serviceOrder.Monto_Total_Partes__c > 0)
TranslatedDescription  += 'Monto Partes: ' + serviceOrder.Monto_Total_Partes__c.setscale(2) + ' ';
if(serviceOrder.Monto_Total_SRT__c > 0)
TranslatedDescription  += 'Monto Mano de Obra: ' + serviceOrder.Monto_Total_SRT__c.setscale(2) + ' ';
if(serviceOrder.Monto_Total_de_Reclamables__c > 0)
TranslatedDescription  += 'Monto Otros Rec.: ' + serviceOrder.Monto_Total_de_Reclamables__c.setscale(2) + ' ';
if(serviceOrder.Monto_Total_de_Viajes__c > 0)
TranslatedDescription  += 'Monto Viaje: ' + serviceOrder.Monto_Total_de_Viajes__c.setscale(2);
detail.put('TranslatedDescription','BONIFICACION RESCATES '+TranslatedDescription);
details.add(detail);
System.debug('--SO CREDIT STATEMENT--');
CSS_WS_J2A_CreateStatementMX createStatementResponse = CSS_WS_GetWebServiceData.createStatementMX(header, details);
if(createStatementResponse != null){
if(createStatementResponse.Header.Status.touppercase()=='SUCCESS'){
serviceOrder.Numero_CM__c= creditNumber;
SPAccount = [
SELECT CSS_WS_Address_ID_Bill__c, CSS_WS_Address_ID_Ship__c, CSS_WS_Customer_ID__c
FROM Account 
WHERE CSS_DealerCode__c =: serviceOrder.Emite_la_Orden__c
AND CSS_DBCode__c =: serviceOrder.Emite_la_Orden__c//Emite
];
//CREATE DEBIT STATEMENT
details = new List<Map<String,String>>{};
detail = new Map<String,String>{};
header = new Map<String,String>{};
header.put('InterfaceLineAttribute1',debitNumber);
header.put('Amount',String.valueof(Amount));
detail.put('LineNumber','0');
detail.put('InterfaceLineAttribute6','1');
detail.put('InventoryItemId','85254');
detail.put('BatchSourceName','Debitos base lotus');
detail.put('Attribute1','CARGO RESCATES Linea: 1');
detail.put('Description','RESCATES-G');
detail.put('CustTrxTypeId','1021');
detail.put('OrigSystemBillCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
detail.put('OrigSystemBillAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Bill__c));
detail.put('OrigSystemShipCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
detail.put('OrigSystemShipAddressId',String.valueof(SPAccount.CSS_WS_Address_ID_Ship__c));
detail.put('Amount',String.valueof(Amount));
detail.put('UnitSellingPrice',String.valueof(Amount));
detail.put('Quantity','1');
detail.put('OrigSystemSoldCustomerId',String.valueof(SPAccount.CSS_WS_Customer_ID__c));
detail.put('TranslatedDescription','CARGO RESCATES '+TranslatedDescription);
details.add(detail);
System.debug('--SO DEBIT STATEMENT--');
createStatementResponse = CSS_WS_GetWebServiceData.createStatementMX(header, details);
if(createStatementResponse != null){
if(createStatementResponse.Header.Status.touppercase()=='SUCCESS'){
serviceOrder.CSS_WS_Estatus__c = 'Pending CM/DM';
serviceOrder.Numero_DM__c= debitNumber;
serviceOrdersToUpdate.add(serviceOrder); 
}
} 
}
}


}
if(serviceOrdersToUpdate.size() > 0){
update serviceOrdersToUpdate;
}

}*/
    
    /*Public Void sendEmail(Integer claimsQty){
List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
Messaging.SingleEmailMessage mail =  new Messaging.SingleEmailMessage();

List<String> sendTo = new List<String>();


if(isSandbox()){
sendTo.add('juan.alcazar@softtek.com');
}else{
Id sysAdmProfileiD = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
List<User> sysAdms = [SELECT id, Email FROM User WHERE ProfileId = :sysAdmProfileiD AND IsActive = true ];

for(User sysAdm : sysAdms){
sendTo.add(sysAdm.Email);
}
}

mail.setToAddresses(sendTo);


String myOrgName = [Select o.Name From Organization o].Name;

mail.setSubject(myOrgName + ' CSS_WS_CreateStmx CrobJob Executed');
String body = claimsQty + ' claims sent';
mail.setHtmlBody(body);

mails.add(mail);

Messaging.sendEmail(mails);


}

public Boolean isSandbox() {
return !String.isEmpty(URL.getSalesforceBaseUrl().getHost().substringBetween('--','.'));
}*/
}