public class CG_CL_CoverageLimitExceedValidation{ 
    public List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
    public Map<String, String> accCodeCovTypeMap = new Map<String, String>();
    public String orgType{get; set;}
    public User u1;
    public CSS_Claims__c claimsRec = new CSS_Claims__c();
    
    public void fetchJET() {
        List<CSS_JobEventTemporary__c> jobEventTempList = new List<CSS_JobEventTemporary__c>();
        jobEventTempList = css_utility.getJobEventTemp();
        for(CSS_JobEventTemporary__c jet : jobEventTempList) {
            if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
            }
        }
        /*for(CSS_JobEventTemporary__c jet : [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes']){
            if(!accCodeCovTypeMap.containsKey(jet.Attribute3__c)){
                accCodeCovTypeMap.put(jet.Attribute3__c, jet.Attribute1__c);
            }
        }*/

    }
    
    public CG_CL_CoverageLimitExceedValidation(){
        fetchJET();
        orgType = css_utility.getOrgType(UserInfo.getUserId());
        //u1 = [Select UserRole.Name from User WHERE Id=: UserInfo.getUserId()];
    }
    //Below method is implemented as part of the stories 179806(Job non PW, non POL, non OTH) and GSSC-50(Job - PW)
    //and 179800(Claims non PW, non POL, non OTH) and 180117(Claims - PW)
    //Claim Scenarios - Dealer/Distributor - Manual and Dealer Automatic Claims
    //Job Scenarios - Dealer/Factory users
    public Set<String> covLimitValidation(Id jobId, Id claimId, List<CSS_Parts_Options__c> urplst, List<CSS_Parts_Options__c> ocplst){
        try{
            if(claimId != null){
                claimsRec = [SELECT Id, Account__r.Type, CSS_Job__c, Dealer_Service_Job__c FROM CSS_Claims__c WHERE Id =: claimId];
            }
            //u1 = [Select UserRole.Name from User WHERE Id=: UserInfo.getUserId()];
            u1 = CSS_utility.getUserAttributes(UserInfo.getUserId());
            //Karthik G IAM Changes 
            boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
            //fetchJET();
            system.debug('jobId--'+jobId);
            system.debug('orgType--'+orgType);            
            if((jobId != null && (orgType == 'DLR' || (u1.UserRoleName__c != null && u1.UserRoleName__c.contains('Factory')))) ||
               (claimId != null && (DealerTypeFlag==true && claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null) ||
                (DealerTypeFlag!= true && claimsRec.CSS_Job__c == null && claimsRec.Dealer_Service_Job__c == null) ||
                (DealerTypeFlag==true && (claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null)))){
                    
                    List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
                    Map<String, CSS_Solution_Component__c> solCompQty = new Map<String, CSS_Solution_Component__c>();
                    Map<String, CSS_Solution_Component__c> solCompQtyPW = new Map<String, CSS_Solution_Component__c>();
                    List<CSS_Solution_Component__c> solCompUpd = new List<CSS_Solution_Component__c>();
                    List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
                    Id recTypeIdpart;
                    Set<String> errorLst = new Set<String>();
                    Map<String, Decimal> partsQuantity = new Map<String, Decimal>();
                    Map<String, Decimal> partsAmount = new Map<String, Decimal>();
                    Map<String, Decimal> partsQuantityPW = new Map<String, Decimal>();
                    Map<String, Decimal> partsAmountPW = new Map<String, Decimal>();
                    
                    if(jobId != null){
                        lstSolComp = [SELECT Id, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CoveredOCAmount__c, SysCodeAndCompCode__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: jobId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c NOT IN ('Campaign','ATC','TRP') order by CSS_Failure_Sequence_Number__c];
                        if(urplst != null){
                            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE Service_Job__c =: jobId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                            lstParts.addAll(urplst);
                        }
                        else if(ocplst != null){
                            lstParts.addAll(ocplst);
                        }
                        else{
                            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE Service_Job__c =: jobId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND ((selected_part__c = true AND Parts_Type__c = '') OR (Parts_Type__c = 'Custom'))];
                        }
                    }
                    else{
                        lstSolComp = [SELECT Id, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CoveredOCAmount__c, SysCodeAndCompCode__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c NOT IN ('Campaign','ATC','TRP') order by CSS_Failure_Sequence_Number__c];
                        if(urplst != null){
                            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                            lstParts.addAll(urplst);
                        }
                        else if(ocplst != null){
                            lstParts.addAll(ocplst);
                        }
                        else{
                            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND ((selected_part__c = true AND Parts_Type__c = '') OR (Parts_Type__c = 'Custom'))];
                        }
                    }
                    
                    system.debug('lstParts--'+lstParts);
                    system.debug('lstSolComp-->'+lstSolComp);
                    for(CSS_Solution_Component__c solcom : lstSolComp){
                        String covtype = '';
                        if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                            covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                        }
                        if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                            if(!solCompQty.containsKey(solcom.CSS_Account_Formula__c)){
                                solCompQty.put(solcom.CSS_Account_Formula__c, solcom);
                            }
                        }
                        else{
                            //if((covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW') && claimId != null){
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){   //Removed claimId != null condition as part of the story GSSC-50
                                String temp = solcom.SysCodeAndCompCode__c+';;'+solcom.CSS_Account_Formula__c;
                                if(!solCompQtyPW.containsKey(temp)){
                                    solCompQtyPW.put(temp, solcom);
                                }
                            }
                        }
                    }
                    for(CSS_Parts_Options__c parts : lstParts){
                        String covtype = '';
                        if(accCodeCovTypeMap != null && parts.Account_Code__c != null){
                            covtype = accCodeCovTypeMap.get(parts.Account_Code__c.RIGHT(2));
                        }
                        system.debug('covtype-->'+covtype);
                        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                        if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                            system.debug('parts.RecordTypeId'+parts.RecordTypeId);
                            system.debug('recTypeIdpartTemp'+recTypeIdpartTemp);
                            if(parts.RecordTypeId != recTypeIdpartTemp){
                                system.debug('inside if');
                                if(!partsQuantity.containsKey(parts.Account_Code__c)){
                                    partsQuantity.put(parts.Account_Code__c, parts.Quantity__c);
                                }
                                else{
                                    Decimal temp = partsQuantity.get(parts.Account_Code__c);
                                    temp += parts.Quantity__c;
                                    partsQuantity.put(parts.Account_Code__c, temp);
                                }
                            }
                            else{
                                Decimal expTotalTemp = claimId == null ? parts.Amount__c : parts.ExpenseTotal__c;
                                if(!partsAmount.containsKey(parts.Account_Code__c)){
                                    partsAmount.put(parts.Account_Code__c, expTotalTemp);
                                }
                                else{
                                    Decimal temp = partsAmount.get(parts.Account_Code__c);
                                    if(temp == null)
                                        temp = 0.0;
                                    if(expTotalTemp == null)
                                        expTotalTemp = 0.0;
                                    temp += expTotalTemp;
                                    partsAmount.put(parts.Account_Code__c, temp);
                                }
                            }
                        }
                        else{
                            //if((covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW') && claimId != null){
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){ //Removed claimId != null condition as part of the story GSSC-50
                                List<String> tempFC_Lst = new List<String>();
                                //Added below condition for defect 209
                                if(parts.Get_Fail_Code_Formula__c!='' & parts.Get_Fail_Code_Formula__c!=null)
                                tempFC_Lst = parts.Get_Fail_Code_Formula__c.split('-');
                                else if (parts.Fail_Code__c!='' & parts.Fail_Code__c!=null)
                                tempFC_Lst = parts.Fail_Code__c.split('-');
                                String tempFC = tempFC_Lst[tempFC_Lst.size()-1];
                                String tempParts = tempFC.LEFT(4)+';;'+parts.Account_Code__c;
                                if(parts.RecordTypeId != recTypeIdpartTemp){
                                    if(!partsQuantityPW.containsKey(tempParts)){
                                        partsQuantityPW.put(tempParts, parts.Quantity__c);
                                    }
                                    else{
                                        Decimal temp = partsQuantityPW.get(tempParts);
                                        temp += parts.Quantity__c;
                                        partsQuantityPW.put(tempParts, temp);
                                    } 
                                }
                                else{
                                    Decimal expTotalTemp = claimId == null ? parts.Amount__c : parts.ExpenseTotal__c;
                                    if(!partsAmountPW.containsKey(tempParts)){
                                        partsAmountPW.put(tempParts, expTotalTemp);
                                    }
                                    else{
                                        Decimal temp = partsAmountPW.get(tempParts);
                                        temp += expTotalTemp;
                                        partsAmountPW.put(tempParts, temp);
                                    } 
                                }
                            }
                        }
                    }
                    
                    
                    //Loop for URP/GSQ parts quantity Non-PW account codes
                    for(String prtsqty : partsQuantity.keyset()){
                        CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                        solCmpTemp = solCompQty.get(prtsqty);
                        Decimal partsQtyTemp = partsQuantity.get(prtsqty);
                        
                        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                        if(ocplst == null && solCmpTemp != null){ //For GSQ Parts and URPs
                            if(solCmpTemp != null && solCmpTemp.CoveredPartsQty__c != null && solCmpTemp.CoveredPartsQty__c != '' && partsQtyTemp > decimal.valueof(solCmpTemp.CoveredPartsQty__c)){
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = Label.CSS_CoverageLimitExceedMsg+' '+prtsqty;
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                errorLst.add(prtsqty);
                                solCompUpd.add(singleSolComp);
                            }
                            else{
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = '';
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                        }
                        
                    }
                    //Loop for OC parts amount Non-PW account codes
                    for(String prtsqty : partsAmount.keyset()){
                        CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                        solCmpTemp = solCompQty.get(prtsqty);
                        Decimal partsQtyTemp = partsAmount.get(prtsqty);
                        system.debug('partsQtyTemp--'+partsQtyTemp);
                        system.debug('ocplst--'+ocplst);
                        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                        if(ocplst != null && solCmpTemp != null){  //For Other Claimables
                            if(solCmpTemp != null && partsQtyTemp > decimal.valueof(solCmpTemp.CoveredOCAmount__c)){
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = Label.CSS_OC_CoverageLimitExceedMsg+' '+prtsqty;
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                errorLst.add(prtsqty);
                                solCompUpd.add(singleSolComp);
                            }
                            else{
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = '';
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                        }
                    }
                    //Loop for URP/GSQ parts quantity PW account codes
                    for(String prtsqty : partsQuantityPW.keyset()){
                        CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                        solCmpTemp = solCompQtyPW.get(prtsqty);
                        Decimal partsQtyTemp = partsQuantityPW.get(prtsqty); 
                        
                        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                        if(ocplst == null){ //For GSQ Parts and URPs
                            if(solCmpTemp != null && solCmpTemp.CoveredPartsQty__c != null && solCmpTemp.CoveredPartsQty__c != '' && partsQtyTemp > decimal.valueof(solCmpTemp.CoveredPartsQty__c)){
                                List<String> failCodeAccCode = new List<String>();
                                failCodeAccCode = prtsqty.split(';;');
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1];
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                errorLst.add(prtsqty);
                                solCompUpd.add(singleSolComp);
                            }
                            else{
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = '';
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                        }
                        
                    }
                    //Loop for OC parts amount PW account codes
                    for(String prtsqty : partsAmountPW.keyset()){
                        CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                        solCmpTemp = solCompQtyPW.get(prtsqty);
                        Decimal partsQtyTemp = partsAmountPW.get(prtsqty); 
                        CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                        if(ocplst != null){ //For Other Claimables
                            if(solCmpTemp != null && partsQtyTemp > decimal.valueof(solCmpTemp.CoveredOCAmount__c)){
                                system.debug('PART QUANTITY GREATER THEN BACK END:ERROR');
                                List<String> failCodeAccCode = new List<String>();
                                failCodeAccCode = prtsqty.split(';;');
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = Label.CSS_OC_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_OC_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1];
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                errorLst.add(prtsqty);
                                solCompUpd.add(singleSolComp);
                            }
                            else{
                                system.debug('PART QUANTITY LESS THEN BACK END:SUCESS');
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsg__c = '';
                                singleSolComp.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                        }
                    }
                    system.debug('solCompUpd-->'+solCompUpd);
                    List<CSS_Parts_Options__c> partsOptLst = new List<CSS_Parts_Options__c>();
                    if(solCompUpd != null && solCompUpd.size() > 0 && urplst == null && ocplst == null){ 
                        update solCompUpd;
                        system.debug('errorLst-->'+errorLst);
                        system.debug('lstParts-->'+lstParts);
                        for(CSS_Parts_Options__c po : lstParts){
                            CSS_Parts_Options__c partSingle = new CSS_Parts_Options__c();
                            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            if(po.RecordTypeId == recTypeIdpartTemp && po.Parts_Type__c != 'Custom'){
                                system.debug('po.Account_Code__c'+po.Account_Code__c);
                                if(errorLst != null && errorLst.contains(po.Account_Code__c)){
                                    //update part
                                    partSingle.Id = po.Id;
                                    partSingle.CoverageLimitExceedMsg__c = po.Account_Code__c;//Label.CSS_CoverageLimitExceedMsg+' '+po.Account_Code__c;
                                    partSingle.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                    if(!partsOptLst.contains(partSingle))
                                        partsOptLst.add(partSingle);
                                }
                                else{
                                    List<String> tempLstStr = new List<String>();
                                    if(po.Fail_Code__c != null && po.Fail_Code__c != '' && po.Fail_Code__c != 'Select One')
                                        tempLstStr = po.Fail_Code__c.split('-');
                                    String temp1;
                                    if(tempLstStr.size() > 0)
                                        temp1 = tempLstStr[tempLstStr.size()-1];
                                    String temp = temp1+';;'+po.Account_Code__c;
                                    system.debug('temp--'+temp);
                                    system.debug('temp1--'+temp1);
                                    if(errorLst != null && errorLst.contains(temp)){
                                        //update parts
                                        partSingle.Id = po.Id;
                                        partSingle.CoverageLimitExceedMsg__c = temp;//Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+po.Account_Code__c;
                                        partSingle.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                        if(!partsOptLst.contains(partSingle))
                                            partsOptLst.add(partSingle);
                                    }
                                    else{
                                        //null error messages
                                        partSingle.Id = po.Id;
                                        partSingle.CoverageLimitExceedMsg__c = '';
                                        partSingle.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                        if(!partsOptLst.contains(partSingle))
                                            partsOptLst.add(partSingle);
                                    }
                                }
                            }
                        }
                        system.debug('partsOptLst-->'+partsOptLst);
                        if(partsOptLst != null && partsOptLst.size() > 0){
                            update partsOptLst;
                        }
                        else{
                            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            List<CSS_Parts_Options__c> lstPartsTemp = new List<CSS_Parts_Options__c>();
                            if(claimId != null){
                                lstPartsTemp = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND RecordTypeId =: recTypeIdpart AND Parts_Type__c != 'Custom'];
                            }
                            for(CSS_Parts_Options__c part : lstPartsTemp){
                                CSS_Parts_Options__c partSingle = new CSS_Parts_Options__c();
                                partSingle.Id = part.Id;
                                partSingle.CoverageLimitExceedMsg__c = '';
                                partSingle.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                if(!partsOptLst.contains(partSingle))
                                    partsOptLst.add(partSingle);
                            }
                            if(partsOptLst != null && partsOptLst.size() > 0){
                                update partsOptLst;
                            }
                        }
                    }
                    else if(solCompUpd == null || solCompUpd.size() == 0){
                        for(CSS_Solution_Component__c sc : lstSolComp){
                            CSS_Solution_Component__c solc = new CSS_Solution_Component__c();
                            solc.Id = sc.Id;
                            solc.CoverageLimitExceedMsg__c = '';
                            solc.CoverageLimitExceedMsg_Status__c = 'PASSED';
                            solCompUpd.add(solc);
                            for(CSS_Parts_Options__c po : lstParts){
                                CSS_Parts_Options__c partSingle = new CSS_Parts_Options__c();
                                Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                                if(po.RecordTypeId == recTypeIdpartTemp && po.Parts_Type__c != 'Custom'){
                                    partSingle.Id = po.Id;
                                    partSingle.CoverageLimitExceedMsg__c = '';
                                    partSingle.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                    if(!partsOptLst.contains(partSingle))
                                        partsOptLst.add(partSingle);
                                }
                            }
                        }
                        if(solCompUpd != null && solCompUpd.size() > 0){
                            update solCompUpd;
                        }
                        if(partsOptLst != null && partsOptLst.size() > 0){
                            update partsOptLst;
                        }
                    }
                    system.debug('errorLst--'+errorLst);
                    return errorLst;
                }
            else{
                system.debug('errorLst Else--');
                return null;
            }
        }catch(exception ex){
            System.debug('In catch in cov limit exceeded: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            return null;
        }
    }
    
    //Below method is implemented as part of the story GSSC-50(Job - PW)
    //Job Scenarios - Dealer/Factory/Distributor users
    public Set<String> covLimitValidationJob(Id jobId, List<CSS_Parts_Options__c> urplst){
        try{
            system.debug('jobId--'+jobId);
            if(jobId != null){
                List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
                Map<String, CSS_Solution_Component__c> solCompQtyPW = new Map<String, CSS_Solution_Component__c>();
                List<CSS_Solution_Component__c> solCompUpd = new List<CSS_Solution_Component__c>();
                List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
                Id recTypeIdpart;
                Set<String> errorLst = new Set<String>();
                Map<String, Decimal> partsQuantityPW = new Map<String, Decimal>();
                Map<String, Decimal> partsAmountPW = new Map<String, Decimal>();

                lstSolComp = [SELECT Id, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CoveredOCAmount__c, SysCodeAndCompCode__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: jobId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c NOT IN ('Campaign','ATC','TRP') order by CSS_Failure_Sequence_Number__c];
                if(urplst != null){
                    recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                    lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE Service_Job__c =: jobId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                    lstParts.addAll(urplst);
                }
                else{
                    recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                    lstParts = [SELECT Id, Account_Code__c, Quantity__c, Amount__c, ExpenseTotal__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c FROM CSS_Parts_Options__c WHERE Service_Job__c =: jobId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart AND ((selected_part__c = true AND Parts_Type__c = '') OR (Parts_Type__c = 'Custom'))];
                }
                system.debug('lstParts--'+lstParts);
                system.debug('lstSolComp-->'+lstSolComp);
                for(CSS_Solution_Component__c solcom : lstSolComp){
                    String covtype = '';
                    if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                        covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                    }
                    if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                        String temp = solcom.SysCodeAndCompCode__c+';;'+solcom.CSS_Account_Formula__c;
                        if(!solCompQtyPW.containsKey(temp)){
                            solCompQtyPW.put(temp, solcom);
                        }
                    }
                }
                for(CSS_Parts_Options__c parts : lstParts){
                    String covtype = '';
                    if(accCodeCovTypeMap != null && parts.Account_Code__c != null){
                        covtype = accCodeCovTypeMap.get(parts.Account_Code__c.RIGHT(2));
                    }
                    system.debug('covtype-->'+covtype);
                    if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                        List<String> tempFC_Lst = new List<String>();
                        //tempFC_Lst = parts.Fail_Code__c.split('-'); // Defect 209
                        if(parts.Get_Fail_Code_Formula__c!='' & parts.Get_Fail_Code_Formula__c!=null)
                        tempFC_Lst = parts.Get_Fail_Code_Formula__c.split('-');
                        else if (parts.Fail_Code__c!='' & parts.Fail_Code__c!=null)
                        tempFC_Lst = parts.Fail_Code__c.split('-');
                        
                        String tempFC = tempFC_Lst[tempFC_Lst.size()-1];
                        String tempParts = tempFC.LEFT(4)+';;'+parts.Account_Code__c;
                        system.debug('parts.RecordTypeId-->'+parts.RecordTypeId);
                        if(!partsQuantityPW.containsKey(tempParts)){
                            partsQuantityPW.put(tempParts, parts.Quantity__c);
                        }
                        else{
                            Decimal temp = partsQuantityPW.get(tempParts);
                            temp += parts.Quantity__c;
                            partsQuantityPW.put(tempParts, temp);
                        }
                    }
                }
                system.debug('partsQuantityPW--'+partsQuantityPW);
                system.debug('partsAmountPW--'+partsAmountPW);
                //Loop for URP/GSQ parts quantity PW account codes
                for(String prtsqty : partsQuantityPW.keyset()){
                    CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                    solCmpTemp = solCompQtyPW.get(prtsqty);
                    Decimal partsQtyTemp = partsQuantityPW.get(prtsqty); 
                    system.debug('partsQtyTemp--'+partsQtyTemp);
                    system.debug('solCmpTemp--'+solCmpTemp);
                    CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                    if(solCmpTemp != null && solCmpTemp.CoveredPartsQty__c != null && solCmpTemp.CoveredPartsQty__c != '' && partsQtyTemp > decimal.valueof(solCmpTemp.CoveredPartsQty__c)){
                        system.debug('Inside IF');
                        List<String> failCodeAccCode = new List<String>();
                        failCodeAccCode = prtsqty.split(';;');
                        singleSolComp.Id = solCmpTemp.Id;
                        singleSolComp.CoverageLimitExceedMsg__c = Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1];
                        singleSolComp.CoverageLimitExceedMsg_Status__c = 'ERROR';
                        errorLst.add(prtsqty);
                        solCompUpd.add(singleSolComp);
                    }
                    else{
                        system.debug('Inside Else');
                        singleSolComp.Id = solCmpTemp.Id;
                        singleSolComp.CoverageLimitExceedMsg__c = '';
                        singleSolComp.CoverageLimitExceedMsg_Status__c = 'PASSED';
                        solCompUpd.add(singleSolComp);
                    }
                }
                system.debug('solCompUpd-->'+solCompUpd);
                List<CSS_Parts_Options__c> partsOptLst = new List<CSS_Parts_Options__c>();
                if(solCompUpd != null && solCompUpd.size() > 0 && urplst == null){ 
                    update solCompUpd;
                    system.debug('errorLst-->'+errorLst);
                    system.debug('lstParts-->'+lstParts);
                    for(CSS_Parts_Options__c po : lstParts){
                        CSS_Parts_Options__c partSingle = new CSS_Parts_Options__c();
                        Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                        if(po.RecordTypeId == recTypeIdpartTemp && po.Parts_Type__c != 'Custom'){
                            system.debug('po.Account_Code__c'+po.Account_Code__c);
                            if(errorLst != null && errorLst.contains(po.Account_Code__c)){
                                //update part
                                partSingle.Id = po.Id;
                                partSingle.CoverageLimitExceedMsg__c = po.Account_Code__c;//Label.CSS_CoverageLimitExceedMsg+' '+po.Account_Code__c;
                                partSingle.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                if(!partsOptLst.contains(partSingle))
                                    partsOptLst.add(partSingle);
                            }
                            else{
                                List<String> tempLstStr = new List<String>();
                                if(po.Fail_Code__c != null && po.Fail_Code__c != '' && po.Fail_Code__c != 'Select One')
                                    tempLstStr = po.Fail_Code__c.split('-');
                                String temp1;
                                if(tempLstStr.size() > 0)
                                    temp1 = tempLstStr[tempLstStr.size()-1];
                                String temp = temp1+';;'+po.Account_Code__c;
                                system.debug('temp--'+temp);
                                system.debug('temp1--'+temp1);
                                if(errorLst != null && errorLst.contains(temp)){
                                    //update parts
                                    partSingle.Id = po.Id;
                                    partSingle.CoverageLimitExceedMsg__c = temp;//Label.CSS_CoverageLimitExceedMsg_PW1+' '+temp1+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+po.Account_Code__c;
                                    partSingle.CoverageLimitExceedMsg_Status__c = 'ERROR';
                                    if(!partsOptLst.contains(partSingle))
                                        partsOptLst.add(partSingle);
                                }
                                else{
                                    //null error messages
                                    partSingle.Id = po.Id;
                                    partSingle.CoverageLimitExceedMsg__c = '';
                                    partSingle.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                    if(!partsOptLst.contains(partSingle))
                                        partsOptLst.add(partSingle);
                                }
                            }
                        }
                    }
                    system.debug('partsOptLst-->'+partsOptLst);
                    if(partsOptLst != null && partsOptLst.size() > 0){
                        update partsOptLst;
                    }
                }
                else if(solCompUpd == null || solCompUpd.size() == 0){
                    for(CSS_Solution_Component__c sc : lstSolComp){
                        CSS_Solution_Component__c solc = new CSS_Solution_Component__c();
                        solc.Id = sc.Id;
                        solc.CoverageLimitExceedMsg__c = '';
                        solc.CoverageLimitExceedMsg_Status__c = 'PASSED';
                        solCompUpd.add(solc);
                        for(CSS_Parts_Options__c po : lstParts){
                            CSS_Parts_Options__c partSingle = new CSS_Parts_Options__c();
                            Id recTypeIdpartTemp = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
                            if(po.RecordTypeId == recTypeIdpartTemp && po.Parts_Type__c != 'Custom'){
                                partSingle.Id = po.Id;
                                partSingle.CoverageLimitExceedMsg__c = '';
                                partSingle.CoverageLimitExceedMsg_Status__c = 'PASSED';
                                if(!partsOptLst.contains(partSingle))
                                    partsOptLst.add(partSingle);
                            }
                        }
                    }
                    if(solCompUpd != null && solCompUpd.size() > 0){
                        update solCompUpd;
                    }
                    if(partsOptLst != null && partsOptLst.size() > 0){
                        update partsOptLst;
                    }
                }
                system.debug('errorLst--'+errorLst);
                return errorLst;
            }
            else{
               
                return null;
            }
        }catch(exception ex){
                System.debug('In catch in cov limit exceeded: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                return null;
            }
        }
    
    //Below method is implemented as part of the stories 179802(Claims) and 179808(Job) -By RAJESH 02 Apr 2019
    public  void covLimitValidationSRT(Id jobId, Id claimId){
        system.debug('******enter inside the method***');
        system.debug('******enter inside the method and jobid***'+jobid);
        system.debug('******enter inside the method and claimId***'+claimId);
        try{
            List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
            Map<String, CSS_Solution_Component__c> solCompClaHou = new Map<String, CSS_Solution_Component__c>();
            //List<CSS_Claims__c> clmUpdRec = new List<CSS_Claims__c>();
            //List<CSS_Job_Order__c> jobUpdRec = new List<CSS_Job_Order__c>();
            List<CSS_SRT__c> lstSRTs = new List<CSS_SRT__c>();
            List<CSS_Solution_Component__c> solCompUpd = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
            Map<String, Decimal> srtClaimedHour = new Map<String, Decimal>();
            
            //u1 = [Select UserRole.Name from User WHERE Id=: UserInfo.getUserId()];
            u1 = CSS_utility.getUserAttributes(UserInfo.getUserId());
            if(orgType == 'DLR' || (u1.UserRoleName__c != null && u1.UserRoleName__c.contains('Factory'))) {
                if(jobId != null){
                    lstSolComp = [SELECT Id, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c, CoveredOCAmount__c,Type__c,CoverageLimitExceedMsgSRT__c,CoverageLimitExceedMsgSRT_Status__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: jobId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c NOT IN('CAMPAIGN','ATC','TRP') order by CSS_Failure_Sequence_Number__c];
                    lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,Type__C, Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where Job_Order__c =: jobId AND isPerformed__c=true AND Type__c NOT IN('Field Action','Field Action Access')];
                }
                else if(claimId != null) {
                    lstSolComp = [SELECT Id, CSS_Account_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c, CoveredOCAmount__c,Type__c,CoverageLimitExceedMsgSRT__c,CoverageLimitExceedMsgSRT_Status__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND Type__c NOT IN('CAMPAIGN','ATC','TRP') AND CSS_Account_Formula__c != '' order by CSS_Failure_Sequence_Number__c];
                    lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,Type__C, Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where CSS_Claims__c=:claimId AND isPerformed__c=true AND Type__c NOT IN('Field Action','Field Action Access')];
                }
            }
            system.debug('*****lstSolComp****'+lstSolComp);
            system.debug('*****lstSRTs****'+lstSRTs);
            //fetchJET();
            if(lstSolComp!=null && lstSolComp.size()>0){
                for(CSS_Solution_Component__c solcom : lstSolComp){
                    String covtype = '';
                    if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                        covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                    }
                    if(!solCompClaHou.containsKey(solcom.CSS_Account_Formula__c) && covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW' && covtype != ''){
                        solCompClaHou.put(solcom.CSS_Account_Formula__c, solcom);
                    }
                }
            }
            system.debug('solCompClaHou**'+solCompClaHou);
            if(lstSRTs!=null && lstSRTs.size()>0){  
                for(CSS_SRT__c srts : lstSRTs){
                    //system.debug('*****accCodeCovTypeMap****'+accCodeCovTypeMap);
                    //system.debug('******SRT List Size***'+lstSRTs.size());
                    if(srts.Type__c=='99time')
                        srts.Account_Code__c=srts.Account_Code_Description__c; 
                    if(srts.Account_Code__c!=null){
                        system.debug('*****srts.Account_Code__c****'+srts.Account_Code__c);
                        system.debug('*****srts.Account_Code__c.RIGHT(2)****'+srts.Account_Code__c.RIGHT(2));
                        String covtype = '';
                        if(accCodeCovTypeMap != null && srts.Account_Code__c != null){
                            covtype = accCodeCovTypeMap.get(srts.Account_Code__c.RIGHT(2));
                        }
                        system.debug('*****covtype****'+covtype);
                        if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW' && covtype != '' && covtype !=null){
                            if(!srtClaimedHour.containsKey(srts.Account_Code__c.trim()) && srts.Extended_Hours__c!=null ){
                                srtClaimedHour.put(srts.Account_Code__c.trim(), srts.Extended_Hours__c);
                                //system.debug('srtClaimedHour inside if'+srtClaimedHour);
                            }
                            else if(srts.Extended_Hours__c!=null && srts.Account_Code__c!=null){
                                //system.debug('*****srtClaimedHour****'+srtClaimedHour);
                                //system.debug('*****srts.Account_Code__c****'+srts.Account_Code__c);
                                //system.debug('*****srts.Extended_Hours__c****'+srts.Extended_Hours__c);
                                Decimal temp = srtClaimedHour.get(srts.Account_Code__c.trim());
                                //system.debug('*****temp****'+temp);
                                temp = temp + srts.Extended_Hours__c;
                                ///system.debug('*****temp + srts.Extended_Hours__c****'+temp + srts.Extended_Hours__c);
                                srtClaimedHour.put(srts.Account_Code__c, temp);
                            }
                        }
                    }
                }
                system.debug('****solCompUpd***'+solCompUpd);
                system.debug('****srtClaimedHour***'+srtClaimedHour);
                for(String srtClmHo : srtClaimedHour.keyset()){
                    CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                    solCmpTemp = solCompClaHou.get(srtClmHo);
                    Decimal srtClaimedHourTemp = srtClaimedHour.get(srtClmHo);
                    if(solCmpTemp!=null ){
                        system.debug('srtClaimedHourTemp**'+srtClaimedHourTemp);
                        system.debug('****solCmpTemp.CoveredLaborHrs__c***'+solCmpTemp.CoveredLaborHrs__c);
                        if(srtClaimedHourTemp > decimal.valueof(solCmpTemp.CoveredLaborHrs__c)){
                            if(jobId!=null && (orgType == 'DLR' || (u1.UserRoleName__c != null && u1.UserRoleName__c.contains('Factory')))){
                                
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsgSRT__c = Label.CSS_CoverageLimitExceedMsgforSRT+' '+srtClmHo;
                                singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'ERROR';
                                solCompUpd.add(singleSolComp);
                                system.debug('Inside If**'+solCompUpd);
                            }
                            else{
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsgSRT__c = Label.CSS_CoverageLimitExceedMsgforSRT+' '+srtClmHo;
                                singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'ERROR';
                                solCompUpd.add(singleSolComp);
                                system.debug('Inside else**'+solCompUpd);
                            }
                            
                        }
                        else{
                            if(jobId!=null && (orgType == 'DLR' || (u1.UserRoleName__c != null && u1.UserRoleName__c.contains('Factory')))){
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsgSRT__c = '';
                                singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                            else{
                                singleSolComp.Id = solCmpTemp.Id;
                                singleSolComp.CoverageLimitExceedMsgSRT__c = '';
                                singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'PASSED';
                                solCompUpd.add(singleSolComp);
                            }
                        }
                    }
                }
            }
            else{
                system.debug('****Inside else when Claims contains 0 SRTs***');
                if(lstSolComp!=null && lstSolComp.size()>0){
                    system.debug('****lstSolComp Inside else when Claims contains 0 SRTs***'+lstSolComp);
                    for(CSS_Solution_Component__c solcom : lstSolComp){
                        String covtype = '';
                        if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                            covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                        }
                        //system.debug('****covtype Inside else when Claims contains 0 SRTs***'+covtype);
                        if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW' && covtype != ''){
                            //if(jobId!=null || claimId!=null){
                            //system.debug('****Inside else when Claims contains 0 SRTs***');
                            singleSolComp.Id = solcom.Id;
                            singleSolComp.CoverageLimitExceedMsgSRT__c = '';
                            singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'PASSED';
                            solCompUpd.add(singleSolComp);
                            //}
                        }
                    }
                    system.debug('****solCompUpd Inside else when Claims contains 0 SRTs***'+solCompUpd);
                }
            }
            
            system.debug('Final**'+solCompUpd);
            /* if(solCompUpd != null && solCompUpd.size() > 0){
update solCompUpd;
system.debug('******record clmUpdRec enter inside the method***'+solCompUpd);
}*/
            if(solCompUpd != null && solCompUpd.size() > 0){
                
                Set<CSS_Solution_Component__c> myset = new Set<CSS_Solution_Component__c>();
                List<CSS_Solution_Component__c> result = new List<CSS_Solution_Component__c>(); 
                myset.addAll(solCompUpd);
                result.addAll(myset);
                
                update result;
                system.debug('******record clmUpdRec enter inside the method***'+solCompUpd);
            }
        }
        catch(exception ex){
            system.debug('In catch block of covLimitValidationSRT-->'+ex.getMessage()+'-->At line number-->'+ex.getLineNumber());
        }
    }
    
    public  void covLimitfailcodeValidation(Id jobId, Id claimId){
        try{
            system.debug('******enter inside the method covLimitfailcodeValidation***');
            system.debug('******enter inside the method and jobid***'+jobid);
            system.debug('******enter inside the method and claimId***'+claimId);
            List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
            Map<String, CSS_Solution_Component__c> solCompClaHou = new Map<String, CSS_Solution_Component__c>();//solCompQty
            List<CSS_Solution_Component__c> solCompUpd = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> solCompUpdTemp = new List<CSS_Solution_Component__c>();
            List<CSS_Claims__c> clmUpdRec = new List<CSS_Claims__c>();
            List<CSS_SRT__c> lstSRTs = new List<CSS_SRT__c>();//lstParts
            //Id recTypeIdpart;
            Set<String> errorLst = new Set<String>();
            Map<String, Decimal> srtClaimedHour = new Map<String, Decimal>();//partsQuantity
            
            if(jobId != null){
                lstSolComp = [SELECT Id, Selected_Component__c,CSS_Account_Formula__c,FailCode_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c, CoveredOCAmount__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: jobId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Selected_Component__c=true order by CSS_Failure_Sequence_Number__c];
                lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,FailCode__c, Type__c,Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where Job_Order__c =: jobId AND isPerformed__c=true AND Type__c NOT IN('Field Action','Field Action Access')];
            }
            else{
                lstSolComp = [SELECT Id, Selected_Component__c,CSS_Account_Formula__c,SysCodeAndCompCode__c,FailCode_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Selected_Component__c=true order by CSS_Failure_Sequence_Number__c];
                //Added Account_Code_Description__c field in below query condition as per defect #184720,-By RAJESH 7th May 2019
                lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,FailCode__c, Type__C,Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where CSS_Claims__c =: claimId AND isPerformed__c=true AND (Account_Code__c!='' OR Account_Code__c!=null OR Account_Code_Description__c!='' OR Account_Code_Description__c!=null) AND Type__c NOT IN('Field Action','Field Action Access')];
            } 
            //fetchJET();
            system.debug('*****lstSolComp****'+lstSolComp);
            system.debug('*****lstSRTs****'+lstSRTs);
            for(CSS_Solution_Component__c solcom : lstSolComp){
                String covtype = '';
                if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                }
                system.debug('*****covtype ****'+covtype);
                if(!solCompClaHou.containsKey(solcom.CSS_Account_Formula__c) && (covtype != 'OTH' && covtype != 'POL') && (covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW')&& claimId != null){
                    String temp = solcom.SysCodeAndCompCode__c+';;'+solcom.CSS_Account_Formula__c;
                    solCompClaHou.put(temp, solcom);
                    system.debug('*****solCompClaHou****'+solCompClaHou);                
                }
                //new code
                if((covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW') && claimId != null){
                    solCompUpdTemp.add(solcom);
                }
                
                
            }
            
            if(lstSRTs !=null && lstSRTs.size()>0){
                for(CSS_SRT__c srts : lstSRTs){
                    system.debug('*****inside size of lstSRTs from query '+lstSRTs.size());
                    system.debug('*****after size of SRT forloop srts.'+srts);
                    if(srts.Type__c=='99time')
                        srts.Account_Code__c=srts.Account_Code_Description__c;
                    system.debug('*****inside SRT forloop srts.'+srts);                    
                    system.debug('*****before srts.Account_Code__claHou****'+srts.Account_Code__c);
                    String covtype1 = '';
                    if(accCodeCovTypeMap != null && srts.Account_Code__c != null){
                        covtype1 = accCodeCovTypeMap.get(srts.Account_Code__c.RIGHT(2));
                    }
                    system.debug('*****covtype1****'+covtype1);
                    if( (covtype1 != 'OTH' || covtype1 != 'POL') && (covtype1 == 'NPW' || covtype1 == 'RPW' || covtype1 == 'RRW') && claimId != null){
                        List<String> tempFC_Lst = new List<String>();
                        tempFC_Lst = srts.FailCode__c.split('-');
                        system.debug('****inside main if  tempFC_Lst***'+tempFC_Lst);
                        String tempFC = tempFC_Lst[tempFC_Lst.size()-1];
                        String tempParts = tempFC+';;'+srts.Account_Code__c;
                        if(!srtClaimedHour.containsKey(tempParts) && srts.Extended_Hours__c!=null ){
                            srtClaimedHour.put(tempParts, srts.Extended_Hours__c);
                        }
                        else{
                            Decimal temp = 0.0;
                            temp = srtClaimedHour.get(tempParts);
                            //if(srts.Extended_Hours__c == null)
                            //srts.Extended_Hours__c = 0;
                            if(temp != null && srts.Extended_Hours__c != null)
                                temp += srts.Extended_Hours__c;
                            srtClaimedHour.put(tempParts, temp);
                            system.debug('****inside else srtClaimedHour***'+srtClaimedHour);
                        }
                    }
                }
                system.debug('****before loop srtClaimedHour>:'+srtClaimedHour);
                for(String srtClmHo : srtClaimedHour.keyset()){
                    system.debug('***srtClmHo**'+srtClmHo);
                    CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                    system.debug('***solCompClaHou**'+solCompClaHou);
                    solCmpTemp = solCompClaHou.get(srtClmHo);
                    Decimal srtClaimedHourTemp = srtClaimedHour.get(srtClmHo);
                    CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                    //system.debug('***solCmpTemp.CoveredLaborHrs__c**'+solCmpTemp.CoveredLaborHrs__c);
                    //system.debug('***srtClaimedHourTemp**'+srtClaimedHourTemp);
                    if(solCmpTemp != null && solCmpTemp.CoveredLaborHrs__c != null && solCmpTemp.CoveredLaborHrs__c != '' && srtClaimedHourTemp > decimal.valueof(solCmpTemp.CoveredLaborHrs__c)){
                        system.debug('Inside IF');
                        List<String> failCodeAccCode = new List<String>();
                        failCodeAccCode = srtClmHo.split(';;');
                        singleSolComp.Id = solCmpTemp.Id;
                        singleSolComp.CoverageLimitExceedMsgSRT__c = Label.CSS_CoverageLimitExceedMsgFail+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1];
                        singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'ERROR';
                        solCompUpd.add(singleSolComp);
                    }
                    else{
                        if(solCmpTemp != null){ //Kalpana,Added null check
                            singleSolComp.Id = solCmpTemp.Id;
                            singleSolComp.CoverageLimitExceedMsgSRT__c = '';
                            singleSolComp.CoverageLimitExceedMsgSRT_Status__c  = 'PASSED';
                            solCompUpd.add(singleSolComp);
                        }
                    }
                }
            }else{
                if(solCompUpdTemp !=null && solCompUpdTemp.size()>0){
                    for(CSS_Solution_Component__c solcom : solCompUpdTemp){
                        solcom.CoverageLimitExceedMsgSRT__c = '';
                        solcom.CoverageLimitExceedMsgSRT_Status__c  = 'PASSED';
                        solCompUpd.add(solcom);
                    }
                }
                
            }
            system.debug('****before update solCompUpd>:'+solCompUpd);
            if(solCompUpd != null && solCompUpd.size() > 0){
                update solCompUpd;
                system.debug('****Final updated record clmUpdRec***'+solCompUpd);
            }
            // return errorLst;
        }
        catch(exception ex){
            System.debug('In last catch in cov limit exceeded: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
    }
    
    public  void covLimitfailcodeJobValidation(Id jobId, Id claimId){
        try{
            system.debug('******enter inside the method NEWcodeValidation***');
            system.debug('******enter inside the method and  NEW jobid***'+jobid);
            system.debug('******enter inside the method and claimId***'+claimId);
            List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
            Map<String, CSS_Solution_Component__c> solCompClaHou = new Map<String, CSS_Solution_Component__c>();//solCompQty
            List<CSS_Solution_Component__c> solCompUpd = new List<CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> solCompUpdTemp = new List<CSS_Solution_Component__c>();
            List<CSS_Claims__c> clmUpdRec = new List<CSS_Claims__c>();
            List<CSS_SRT__c> lstSRTs = new List<CSS_SRT__c>();//lstParts
            //Id recTypeIdpart;
            Set<String> errorLst = new Set<String>();
            Map<String, Decimal> srtClaimedHour = new Map<String, Decimal>();//partsQuantity
            
            if(jobId != null){
                lstSolComp = [SELECT Id, Selected_Component__c,CSS_Account_Formula__c,SysCodeAndCompCode__c,FailCode_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c, CoveredOCAmount__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: jobId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Selected_Component__c=true order by CSS_Failure_Sequence_Number__c];
                lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,FailCode__c, Type__c,Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where Job_Order__c =: jobId AND isPerformed__c=true AND Type__c NOT IN('Field Action','Field Action Access')];
            }
            else{
                lstSolComp = [SELECT Id, Selected_Component__c,CSS_Account_Formula__c,SysCodeAndCompCode__c,FailCode_Formula__c, CSS_Failure_Sequence_Number__c, CoveredLaborHrs__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Selected_Component__c=true order by CSS_Failure_Sequence_Number__c];
                //Added Account_Code_Description__c field in below query condition as per defect #184720,-By RAJESH 7th May 2019
                lstSRTs=[select id,Extended_Hours__c, SRT_Time__c,isPerformed__c, SRT_AccessiblityCheck__c,FailCode__c, Type__C,Account_Code__c,Account_Code_Description__c,Calculated_Claimed_Hours__c from CSS_SRT__c where CSS_Claims__c =: claimId AND isPerformed__c=true AND (Account_Code__c!='' OR Account_Code__c!=null OR Account_Code_Description__c!='' OR Account_Code_Description__c!=null) AND Type__c NOT IN('Field Action','Field Action Access')];
            } 
            //fetchJET();
            system.debug('*****lstSolComp****'+lstSolComp);
            system.debug('*****lstSRTs****'+lstSRTs);
            for(CSS_Solution_Component__c solcom : lstSolComp){
                String covtype = '';
                if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                    system.debug('accCodeCovTypeMap****' + accCodeCovTypeMap);
                    system.debug(solcom.CSS_Account_Formula__c.RIGHT(2)  +'*******'+ solcom.CSS_Account_Formula__c + 'solcom.CSS_Account_Formula__c'  );
                    covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                }
                system.debug('*****covtype NEW ****'+covtype);
                if(!solCompClaHou.containsKey(solcom.CSS_Account_Formula__c) && (covtype != 'OTH' && covtype != 'POL') && (covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW')&& jobId != null){
                    String temp = solcom.SysCodeAndCompCode__c+';;'+solcom.CSS_Account_Formula__c;
                    solCompClaHou.put(temp, solcom);
                    system.debug('*****solCompClaHou**** NEW'+solCompClaHou);                
                }
                //new code
                if((covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW') && jobId != null){
                    solCompUpdTemp.add(solcom);
                }
                
                
            }
            
            if(lstSRTs !=null && lstSRTs.size()>0){
                for(CSS_SRT__c srts : lstSRTs){
                    system.debug('*****inside NEW size of lstSRTs from query '+lstSRTs.size());
                    system.debug('*****after size of SRT forloop srts.'+srts);
                    if(srts.Type__c=='99time')
                        srts.Account_Code__c=srts.Account_Code_Description__c;
                    system.debug('*****inside SRT forloop srts.'+srts);                    
                    system.debug('*****before srts.Account_Code__claHou****'+srts.Account_Code__c);
                    String covtype1 = '';
                    if(accCodeCovTypeMap != null && srts.Account_Code__c != null){
                        system.debug('Inside AccountMap*******');
                        covtype1 = accCodeCovTypeMap.get(srts.Account_Code__c.RIGHT(2));
                    }
                    system.debug('*****covtype1**** NEW'+covtype1);
                    if( (covtype1 != 'OTH' || covtype1 != 'POL') && (covtype1 == 'NPW' || covtype1 == 'RPW' || covtype1 == 'RRW') && jobId!= null){
                        List<String> tempFC_Lst = new List<String>();
                        tempFC_Lst = srts.FailCode__c.split('-');
                        system.debug('****inside main if  tempFC_Lst***'+tempFC_Lst);
                        String tempFC = tempFC_Lst[tempFC_Lst.size()-1];
                        String tempParts = tempFC+';;'+srts.Account_Code__c;
                        if(!srtClaimedHour.containsKey(tempParts) && srts.Extended_Hours__c!=null ){
                            srtClaimedHour.put(tempParts, srts.Extended_Hours__c);
                        }
                        else{
                            Decimal temp = 0.0;
                            temp = srtClaimedHour.get(tempParts);
                            //if(srts.Extended_Hours__c == null)
                            //srts.Extended_Hours__c = 0;
                            if(temp != null && srts.Extended_Hours__c != null)
                                temp += srts.Extended_Hours__c;
                            srtClaimedHour.put(tempParts, temp);
                            system.debug('****inside else srtClaimedHour***'+srtClaimedHour);
                        }
                    }
                }
                system.debug('****before loop srtClaimedHour>:'+srtClaimedHour);
                for(String srtClmHo : srtClaimedHour.keyset()){
                    system.debug('***srtClmHo**'+srtClmHo);
                    CSS_Solution_Component__c solCmpTemp = new CSS_Solution_Component__c();
                    system.debug('***solCompClaHou**'+solCompClaHou);
                    solCmpTemp = solCompClaHou.get(srtClmHo);
                    Decimal srtClaimedHourTemp = srtClaimedHour.get(srtClmHo);
                    CSS_Solution_Component__c singleSolComp = new CSS_Solution_Component__c();
                    system.debug('***solCmpTemp.CoveredLaborHrs__c**'+solCmpTemp.CoveredLaborHrs__c);
                    //system.debug('***srtClaimedHourTemp**'+srtClaimedHourTemp);
                    system.debug(solCmpTemp + '*****solCmpTemp****');
                    if(solCmpTemp != null && solCmpTemp.CoveredLaborHrs__c != null && solCmpTemp.CoveredLaborHrs__c != '' && srtClaimedHourTemp > decimal.valueof(solCmpTemp.CoveredLaborHrs__c)){
                        system.debug('Inside IF');
                        List<String> failCodeAccCode = new List<String>();
                        failCodeAccCode = srtClmHo.split(';;');
                        singleSolComp.Id = solCmpTemp.Id;
                        singleSolComp.CoverageLimitExceedMsgSRT__c = Label.CSS_CoverageLimitExceedMsgFail+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1];
                        singleSolComp.CoverageLimitExceedMsgSRT_Status__c = 'ERROR';
                        System.debug(singleSolComp.CoverageLimitExceedMsgSRT_Status__c + '******NEW STATUS');
                        solCompUpd.add(singleSolComp);
                    }
                    else{
                        if(solCmpTemp != null){ //Kalpana,Added null check
                            singleSolComp.Id = solCmpTemp.Id;
                            singleSolComp.CoverageLimitExceedMsgSRT__c = '';
                            singleSolComp.CoverageLimitExceedMsgSRT_Status__c  = 'PASSED';
                            solCompUpd.add(singleSolComp);
                        }
                    }
                }
            }else{
                if(solCompUpdTemp !=null && solCompUpdTemp.size()>0){
                    for(CSS_Solution_Component__c solcom : solCompUpdTemp){
                        solcom.CoverageLimitExceedMsgSRT__c = '';
                        solcom.CoverageLimitExceedMsgSRT_Status__c  = 'PASSED';
                        solCompUpd.add(solcom);
                    }
                    
                }
                
            }
            system.debug('****before update solCompUpd>:'+solCompUpd);
            if(solCompUpd != null && solCompUpd.size() > 0){
                update solCompUpd;
                system.debug('****Final updated record clmUpdRec***'+solCompUpd);
            }
            // return errorLst;
        }
        catch(exception ex){
            System.debug('In last catch in cov limit exceeded: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
    }
    
    
    
    public map<string,map<string,string>> covLimitValidation_TTML(id claimId, List<CSS_Parts_Options__c> lstParts){
        system.debug('***calling covLimitValidation_TTML method****');
        map<string,map<string,string>> TTMLerrors = new  map<string,map<string,string>>();
        Map<String, CSS_Solution_Component__c> solCompexp = new Map<String, CSS_Solution_Component__c>();
        map<string,decimal> comparemap = new map<string,decimal>();
        map<string,decimal> hourstravled = new map<string,decimal>();
        Map<String, Decimal> hourexp = new Map<String, Decimal>();
        //////
        map<string,decimal> CompMealsLodge = new map<string,decimal>();
        Map<String, Decimal> mealslodgeexp = new Map<String, Decimal>();
        map<string,decimal> Comnoncomap = new map<string,decimal>();
        Map<String, Decimal> mileageexp = new Map<String, Decimal>();
        Map<String, Decimal> partsexp = new Map<String, Decimal>();
        Map<String, Decimal> towingMap = new Map<String, Decimal>();
        map<id,CSS_Solution_Component__c> errormap = new map<id,CSS_Solution_Component__c>();
        
        List<CSS_Solution_Component__c> lstSolComp = [SELECT Id,name,SysCodeAndCompCode__c, CoveredTowingMiles__c,CSS_Account_Formula__c,CoveredTravelLabourErrMsg__c,CoveredTravelLabourStatus__c,CoverageTravelBaseFareExceedMsg__c,CoverageTravelBaseFareMsgTstatus__c,CoveredTravelBaseFareAmt__c,CoveredTravelMiles__c,CoveredTravelLabor__c,CoveredMealsLodgingAmt__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c Not In('TRP','ATC','CAMPAIGN') order by CSS_Failure_Sequence_Number__c];
        
        //fetchJET();
        
        for(CSS_Solution_Component__c solcom : lstSolComp){
            String covtype = '';
            if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
            }
            if(!solCompexp.containsKey(solcom.CSS_Account_Formula__c)){
                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){// || covtype == 'OTH'){
                    solCompexp.put(solcom.SysCodeAndCompCode__c+'-'+solcom.CSS_Account_Formula__c, solcom);
                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                    solCompexp.put(solcom.SysCodeAndCompCode__c+'-'+solcom.CSS_Account_Formula__c, solcom);
                }
            }
        }
        
        for(CSS_Parts_Options__c parts : lstParts){
            
            if(solCompexp.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c)){
                
                decimal temptype ;
                decimal temphrsfield ;
                decimal tempmealslodgefield;
                decimal tempmileage;
                decimal tempTowing;
                CSS_Solution_Component__c sol=  solCompexp.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                system.debug('solAccountCode$$$'+sol);
                switch on parts.Type__c{
                    when 'Commercial-Travel','Meals','Lodging'{
                        
                        if(parts.Type__c=='Commercial-Travel'){
                            temptype=parts.ExpenseTotal__c;
                            system.debug('commerical ');
                            if(!comparemap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                                comparemap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelBaseFareAmt__c));
                        }
                    } when 'Non Commercial-Travel'{
                        tempmileage=parts.Mileage__c;
                        if(!Comnoncomap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                            Comnoncomap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelMiles__c));
                        
                    }
                    //added below code for getting error message when type equals to Towing as per story #183916,-By RAJESH 14th May 2019
                    when 'Towing'{
                        temptype=parts.ExpenseTotal__c;
                        if(!towingMap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                            towingMap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTowingMiles__c));
                        system.debug('***First time towingMap****'+towingMap);
                    }
                    //End
                }
                //Logic for Mileage calculations
                if(parts.Type__c=='Non Commercial-Travel'){
                    if(!mileageexp.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim())){
                        mileageexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), tempmileage);
                    }
                    else {
                        Decimal mileage = mileageexp.get(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim());
                        if(mileage==null)
                            mileage=0.0;
                        if(tempmileage==null)
                            tempmileage=0.0;
                        mileage = mileage+tempmileage;
                        mileageexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), mileage);
                    }
                    system.debug('Non-Comm***'+parts.Type__c+ 'mileage***'+mileageexp);
                }
                //Logic for Mileage calculations End
                ////Logic for Meals & Logic calculation
                if(parts.ExpenseTotal__c!=null && (parts.Type__c=='Meals' || parts.Type__c=='Lodging'))
                {
                    tempmealslodgefield=parts.ExpenseTotal__c;
                    
                    if(!CompMealsLodge.containsKey('Mealslod'+'&'+parts.Account_Code__c.trim()))
                        CompMealsLodge.put('Mealslod'+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredMealsLodgingAmt__c));
                    
                    
                    if(!mealslodgeexp.containsKey('Mealslod'+'&'+parts.Account_Code__c.trim())){
                        mealslodgeexp.put('Mealslod'+'&'+parts.Account_Code__c.trim(), tempmealslodgefield);
                    }
                    else {
                        Decimal hour = mealslodgeexp.get('Mealslod'+'&'+parts.Account_Code__c.trim());
                        if(hour==null)
                            hour=0.0;
                        if(tempmealslodgefield==null)
                            tempmealslodgefield=0.0;
                        hour = hour+tempmealslodgefield;
                        mealslodgeexp.put('Mealslod'+'&'+parts.Account_Code__c.trim(), hour);
                    }
                    system.debug('MealsandLodge***'+parts.Type__c+ 'mealslodgeexp***'+mealslodgeexp);
                }
                ////Logic for Meals & Logic calculation End
                
                //Logic for HoursTravelled calculation
                if(parts.HoursTravelled__c!=null){
                    temphrsfield=parts.HoursTravelled__c;
                    if(!hourstravled.containsKey(parts.Account_Code__c.trim()))
                        hourstravled.put('hrstravled'+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelLabor__c));
                    if(!hourexp.containsKey('hrstravled'+'&'+parts.Account_Code__c.trim())){
                        hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), temphrsfield);
                    }else {
                        Decimal hour = hourexp.get('hrstravled'+'&'+parts.Account_Code__c.trim());
                        if(hour==null)
                            hour=0.0;
                        if(temphrsfield==null)
                            temphrsfield=0.0;
                        hour = hour+temphrsfield;
                        hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), hour);
                        
                    }
                    
                }
                
                if(!partsexp.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim())){
                    partsexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), temptype);
                }else {
                    Decimal temp = partsexp.get(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim());
                    if(temp==null)
                        temp=0.0;
                    if(temptype==null)
                        temptype=0.0;
                    temp = temp+temptype;
                    partsexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), temp);
                    
                }
                
                
            }
            
        }
        
        for(CSS_Parts_Options__c parts : lstParts){
            
            if(solCompexp.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c)){
                map<string,string> parterror = new  map<string,string>();
                CSS_Solution_Component__c solCmpTemp =solCompexp.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                string errorkey = parts.Type__c.trim()+'&'+ (parts.Account_Code__c != null ? parts.Account_Code__c.trim() : '');
                String covtype = '';
                if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                }
                
                
                //COMMERCIAL ERROR
                if(partsexp.get(errorkey) > comparemap.get(errorkey)){
                    if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                        parterror.put('COMMERCIAL',label.CSS_TTMLCoveredTravelErr_C+'@'+parts.fail_code__c +' '+Label.CSS_CoverageLimitExceedMsg_PW2 +' ' +parts.Account_Code__c);
                        
                    }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                        parterror.put('COMMERCIAL',label.CSS_TTML_TravelbasefareamountMgs+parts.Account_Code__c);
                        
                    }
                }
                //added below code for getting error message when type equals to Towing as per story #183916,-By RAJESH 14th May 2019
                if(partsexp.get(errorkey) > towingMap.get(errorkey)){
                    system.debug('***getting value from towingMap****'+towingMap.get(errorkey));
                    system.debug('***covtype****'+covtype);
                    if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                        system.debug('***Failures are associated ***');
                        parterror.put('Towing',label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Fail_Code+'@'+parts.fail_code__c +' '+Label.CSS_CoverageLimitExceedMsg_PW2 +' ' +parts.Account_Code__c);
                        system.debug('***just checking which value is retrurn by map in if****'+parterror);  
                    }
                    else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                        system.debug('***Failures are NOT associated ***');
                        parterror.put('Towing',label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Account_Code+parts.Account_Code__c);
                        system.debug('***just checking which value is retrurn by map in else ****'+parterror);
                    }
                }
                //End
                string errorkey1 ='hrstravled'+'&'+parts.Account_Code__c.trim();
                //HOURS TRAVLLED ERROR
                if(parts.HoursTravelled__c!=null && hourexp.containsKey(errorkey1) && hourstravled.containsKey(errorkey1) ){
                    if(hourexp.get(errorkey1) > hourstravled.get(errorkey1)){
                        
                        if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                            parterror.put('HOURSTRAVELLED',Label.CSS_TTMLLabourCoveredErr_C+'@'+parts.fail_code__c +' '+Label.CSS_CoverageLimitExceedMsg_PW2 +' ' +parts.Account_Code__c);
                        }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){ 
                            parterror.put('HOURSTRAVELLED',Label.CSS_HoursTravelErrMSG+parts.Account_Code__c);
                        }
                        
                        
                    }
                }
                //MILEAGE ERROR - NON COMMERCIAL
                string errorkey5 = parts.Type__c.trim()+'&'+ (parts.Account_Code__c != null ? parts.Account_Code__c.trim() : '');
                if(parts.Mileage__c!=null && mileageexp.containsKey(errorkey5) && Comnoncomap.containsKey(errorkey5) ){
                    if(mileageexp.get(errorkey5) > Comnoncomap.get(errorkey5)){
                        if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                            parterror.put('MILES',label.CSS_TTMLCoveredMilesErr_C+'@'+parts.fail_code__c +' ' +Label.CSS_CoverageLimitExceedMsg_PW2 + ' ' +parts.Account_Code__c);
                        }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                            parterror.put('MILES',Label.CSS_TTML_TravelMilesErrMsg+parts.Account_Code__c);
                        }
                    }
                }
                //MEALS AND LODGING ERROR
                string errorkey2 ='Mealslod'+'&'+parts.Account_Code__c.trim();
                if(parts.ExpenseTotal__c!=null && mealslodgeexp.containsKey(errorkey2) && CompMealsLodge.containsKey(errorkey2) && (parts.Type__c=='Meals' || parts.Type__c=='Lodging')){
                    if(mealslodgeexp.get(errorkey2) > CompMealsLodge.get(errorkey2)){
                        
                        if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                            parterror.put('MEALSANDLODGE',label.CSS_TTMLCoveredMealsLodgErr_C+'@'+parts.fail_code__c +' ' +Label.CSS_CoverageLimitExceedMsg_PW2 + ' ' +parts.Account_Code__c);
                        }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                            parterror.put('MEALSANDLODGE',label.CSS_TTML_MealsLodgingErrMSG+parts.Account_Code__c);
                            
                        }
                    }
                }
                
                if(parterror.size()>0 && parterror!=null ){
                    TTMLerrors.put(parts.TTMLWrapperID__c,parterror);
                }
                
            }
        }
        
        
        return TTMLerrors;
    }
    // Created by Nandigam sasi as part of GSSC-49 and GSSC-53  storys
    public Map<string,Map<string,string>> CoverageLimitValidation_TTML(id claimId, List<CSS_Parts_Options__c> lstParts){
        Map<string,map<string,string>> TTMLerrors = new  Map<string,map<string,string>>();
        Map<string,map<string,decimal>> compare = new  Map<string,map<string,decimal>>();
        Map<string,map<string,decimal>> compareNpw = new  Map<string,map<string,decimal>>();
        Map<String, CSS_Solution_Component__c> solCompexp = new Map<String, CSS_Solution_Component__c>();
        Map<String, CSS_Solution_Component__c> solCompNpw = new Map<String, CSS_Solution_Component__c>();
        Map<string,decimal> hourstravled = new map<string,decimal>();
        Map<string,decimal> hourstravledNpw = new map<string,decimal>();
        Map<String, Decimal> mileageexp = new Map<String, Decimal>();
        Map<String, Decimal> mileageNpw = new Map<String, Decimal>();
        Map<String, Decimal> coveredtrvl = new Map<String, Decimal>();
        Map<String, Decimal> coveredtrvlNpw = new Map<String, Decimal>();
        
        Map<String, Decimal> hourexp = new Map<String, Decimal>();
        Boolean Checkfailcodeaccodecombination;
        Boolean CheckAccodecombination;
        List<CSS_Solution_Component__c> lstSolComp = [SELECT Id,name,SysCodeAndCompCode__c, CoveredTowingMiles__c,CSS_Account_Formula__c,CoveredTravelLabourErrMsg__c,CoveredTravelLabourStatus__c,CoverageTravelBaseFareExceedMsg__c,CoverageTravelBaseFareMsgTstatus__c,CoveredTravelBaseFareAmt__c,CoveredTravelMiles__c,CoveredTravelLabor__c,CoveredMealsLodgingAmt__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c,Service_Job__c FROM CSS_Solution_Component__c WHERE Service_Job__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c Not In('TRP','ATC','CAMPAIGN') order by CSS_Failure_Sequence_Number__c];
        for(CSS_Solution_Component__c solcom : lstSolComp){
            String covtype='';
            if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
            }
            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW' ){
                solCompexp.put(solcom.SysCodeAndCompCode__c+'-'+solcom.CSS_Account_Formula__c, solcom);
                Checkfailcodeaccodecombination = true;
            }
            else if(covtype != 'NPW' || covtype != 'RPW' || covtype != 'RRW' || covtype != 'OTH' || covtype != 'POL' ){
                solCompNpw.put(solcom.SysCodeAndCompCode__c+'-'+solcom.CSS_Account_Formula__c, solcom);
                CheckAccodecombination = true;
            }
        }
        for(CSS_Parts_Options__c parts : lstParts){
            if(solCompexp.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!=''  ){
                CSS_Solution_Component__c sol=  solCompexp.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                string combinationkey=parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()+'&'+parts.Fail_Code__c.trim();
                switch on parts.Type__c{
                    when 'Meals','Lodging'{
                         if(!compare.containsKey(combinationkey))
                            compare.put(combinationkey,new map<string,decimal>{'CoveredML'=>decimal.valueof(sol.CoveredMealsLodgingAmt__c)});  
                        else{
                            Map<String, Decimal> oldvalue =compare.get(combinationkey);
                            if(!oldvalue.containsKey('CoveredML')){
                                oldvalue.put('CoveredML',decimal.valueof(sol.CoveredMealsLodgingAmt__c));
                                compare.put(combinationkey,oldvalue); 
                            }
                        }
                       if(parts.ExpenseTotal__c!=null){
                            if(!mileageexp.containsKey('CoveredML'))
                                mileageexp.put('CoveredML',parts.ExpenseTotal__c);   
                            else
                                mileageexp.put('CoveredML',mileageexp.get('CoveredML')+parts.ExpenseTotal__c);
                        }
                    } when 'Non Commercial-Travel'{
                         if(!compare.containsKey(combinationkey))
                            compare.put(combinationkey,new Map<String, Decimal>{'HoursTraveled'=>decimal.valueof(sol.CoveredTravelLabor__c),'Milage'=>decimal.valueof(sol.CoveredTravelMiles__c)});
                        else{
                            Map<String, Decimal> oldvalue =compare.get(combinationkey);
                            if(!oldvalue.containsKey('HoursTraveled')){
                                oldvalue.put('HoursTraveled',decimal.valueof(sol.CoveredTravelLabor__c));
                                oldvalue.put('Milage',decimal.valueof(sol.CoveredTravelMiles__c));
                                compare.put(combinationkey,oldvalue); 
                            }  
                        }
                        if(parts.HoursTravelled__c!=null){
                            if(!hourstravled.containsKey(combinationkey))
                                hourstravled.put(combinationkey,parts.HoursTravelled__c);  
                            else hourstravled.put(combinationkey,hourstravled.get(combinationkey)+parts.HoursTravelled__c);
                               
                            if(!hourexp.containsKey('hrstravled'+'&'+parts.Account_Code__c.trim())){
                                hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), parts.HoursTravelled__c);
                            }    
                          } 
                        if(parts.Mileage__c!=null){
                           if(!coveredtrvl.containsKey(combinationkey))
                                coveredtrvl.put(combinationkey,parts.Mileage__c);   
                            else{
                            coveredtrvl.put(combinationkey,coveredtrvl.get(combinationkey)+parts.Mileage__c);
                            
                            }
                        }
                    }
                    
                }
                
                
            }
            if(solCompNpw.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!=''  ){
                CSS_Solution_Component__c sol=  solCompNpw.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                string combinationkeyNpw=parts.Type__c.trim()+'&'+parts.Account_Code__c.trim();
                switch on parts.Type__c{
                    when 'Meals','Lodging'{
                         if(!compareNpw.containsKey(combinationkeyNpw))
                            compareNpw.put(combinationkeyNpw,new map<string,decimal>{'CoveredML'=>decimal.valueof(sol.CoveredMealsLodgingAmt__c)});  
                        else{
                            Map<String, Decimal> oldvalueNpw =compareNpw.get(combinationkeyNpw);
                            if(!oldvalueNpw.containsKey('CoveredML')){
                                oldvalueNpw.put('CoveredML',decimal.valueof(sol.CoveredMealsLodgingAmt__c));
                                compareNpw.put(combinationkeyNpw,oldvalueNpw); 
                            }
                        }
                        system.debug('ExpenseTotal NPW----->>>'+parts.ExpenseTotal__c);
                        if(parts.ExpenseTotal__c!=null){
                            if(!mileageNpw.containsKey('CoveredML'))
                                mileageNpw.put('CoveredML',parts.ExpenseTotal__c);   
                            else
                                mileageNpw.put('CoveredML',mileageNpw.get('CoveredML')+parts.ExpenseTotal__c);
                        }
                        
                    } when 'Non Commercial-Travel'{
                         if(!compareNpw.containsKey(combinationkeyNpw))
                            compareNpw.put(combinationkeyNpw,new Map<String, Decimal>{'HoursTraveled'=>decimal.valueof(sol.CoveredTravelLabor__c),'Milage'=>decimal.valueof(sol.CoveredTravelMiles__c)});
                        else{
                            Map<String, Decimal> oldvalueNpw =compareNpw.get(combinationkeyNpw);
                            if(!oldvalueNpw.containsKey('HoursTraveled')){
                                oldvalueNpw.put('HoursTraveled',decimal.valueof(sol.CoveredTravelLabor__c));
                                oldvalueNpw.put('Milage',decimal.valueof(sol.CoveredTravelMiles__c));
                                compareNpw.put(combinationkeyNpw,oldvalueNpw); 
                            }  
                        }
                        if(parts.HoursTravelled__c!=null){
                            if(!hourstravledNpw.containsKey(combinationkeyNpw)) hourstravledNpw.put(combinationkeyNpw,parts.HoursTravelled__c);  
                            else hourstravledNpw.put(combinationkeyNpw,hourstravledNpw.get(combinationkeyNpw)+parts.HoursTravelled__c);
                            if(!hourexp.containsKey('hrstravled'+'&'+parts.Account_Code__c.trim())){
                                hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), parts.HoursTravelled__c);
                            }    
                          } 
                        if(parts.Mileage__c!=null){
                             if(!coveredtrvlNpw.containsKey(combinationkeyNpw))
                                coveredtrvlNpw.put(combinationkeyNpw,parts.Mileage__c);   
                            else{
                            coveredtrvlNpw.put(combinationkeyNpw,coveredtrvlNpw.get(combinationkeyNpw)+parts.Mileage__c);
                            
                            }
                        }
                    }
                    
                }
                
                
            }
       
            
        }
     for(CSS_Parts_Options__c parts : lstParts){
           if(solCompexp.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!='' ){
                CSS_Solution_Component__c solCmpTemp =solCompexp.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                string combinationkey=parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()+'&'+parts.Fail_Code__c.trim();
                string combinationkeys=parts.Type__c.trim()+'&'+parts.Account_Code__c.trim();
                String covtype = '';
                if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                }
                if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                }
                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW' ){
                    map<string,string> parterror = new  map<string,string>();
                    map<string,decimal> comparevalue= compare.get(combinationkey);
                    for(string key :comparevalue.keyset()){
                        switch on key{
                            when 'HoursTraveled'{
                                if(hourstravled.containsKey(combinationkey)){
                                    if(hourstravled.get(combinationkey)>comparevalue.get(key)){
                                       parterror.put(key,label.CSS_HoursTravelledErrorMsg+' '+parts.fail_code__c +' and Account Code: ' +parts.Account_Code__c);
                                    } 
                                }
                                
                            }when 'Milage'{
                                if(coveredtrvl.containsKey(combinationkey)){
                                    if(coveredtrvl.get(combinationkey)>comparevalue.get(key)){
                                        parterror.put(key,label.CSS_TTMLCoveredMilesErr_C+' '+parts.fail_code__c +' and Account Code: ' +parts.Account_Code__c);
                                    } 
                                }
                            }when 'CoveredML' {
                                system.debug('CoveredML'+key);
                                if(mileageexp.containsKey(key)){
                                     
                                    if(mileageexp.get(key)>comparevalue.get(key)){
                                       parterror.put(key,label.CSS_TTMLCoveredMealsLodgErr_C+' '+parts.fail_code__c +' and Account Code: ' +parts.Account_Code__c);
                                    } 
                                }
                                
                            }
                        }
                    }
                    if(parterror.size()>0 && parterror!=null ){
                        if(!TTMLerrors.containsKey(combinationkey))
                         TTMLerrors.put(combinationkey,parterror);
                        else{
                           map<string,string> olderror = TTMLerrors.get(combinationkey);
                           for(string err:parterror.keyset()){
                               olderror.put(err,parterror.get(err)); 
                           }
                            TTMLerrors.put(combinationkey,olderror);
                        }
                      }
                }
                
           }
           
           if(solCompNpw.containsKey(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c) && parts.Account_Code__c!=null && parts.Account_Code__c!='' && parts.Fail_Code__c!=null && parts.Fail_Code__c!='' ){
                CSS_Solution_Component__c solCmpNpw =solCompNpw.get(parts.Fail_Code__c.substringAfterLast('-')+'-'+parts.Account_Code__c);
                string combinationkeys=parts.Type__c.trim()+'&'+parts.Account_Code__c.trim();
                String covtypeNpw = '';
                if(accCodeCovTypeMap != null && solCmpNpw.CSS_Account_Formula__c != null){
                    covtypeNpw = accCodeCovTypeMap.get(solCmpNpw.CSS_Account_Formula__c.RIGHT(2));
                }
               system.debug('covtypeNpw#'+covtypeNpw);
                
                //Story - 53
                
                   if (covtypeNpw != 'NPW' || covtypeNpw != 'RPW' || covtypeNpw != 'RRW' || covtypeNpw != 'OTH' || covtypeNpw != 'POL'){
                    map<string,string> parterrorNpw = new  map<string,string>();
                    map<string,decimal> comparevalueNpw= compareNpw.get(combinationkeys);
                    if(comparevalueNpw != null){
                        for(string key :comparevalueNpw.keyset()){
                            switch on key{
                                when 'HoursTraveled'{
                                    if(hourstravledNpw.containsKey(combinationkeys)){
                                     if(hourstravledNpw.get(combinationkeys)>comparevalueNpw.get(key)){
                                            parterrorNpw.put(key,label.CG_Travel_Labor_claimed_coverage_limit +parts.Account_Code__c);
                                        } 
                                    }  
                                    
                                }when 'Milage'{
                                     if(coveredtrvlNpw.containsKey(combinationkeys)){
                                        if(coveredtrvlNpw.get(combinationkeys)>comparevalueNpw.get(key)){
                                        parterrorNpw.put(key,label.CG_TravelMiles_Claimed_exceeds_coverage_limit+parts.Account_Code__c);
                                     } 
                                    }
                                }when 'CoveredML' {
                                    if(mileageNpw.containsKey(key)){
                                        if(mileageNpw.get(key)>comparevalueNpw.get(key)){
                                        parterrorNpw.put(key,label.CG_Meals_Lodging_Amount_claimed_exceeds_coverage_limit +parts.Account_Code__c);
                                      } 
                                    }
                                    
                                }
                            }
                        }
                    }
                     if(parterrorNpw.size()>0 && parterrorNpw!=null ){
                        if(!TTMLerrors.containsKey(combinationkeys))
                         TTMLerrors.put(combinationkeys,parterrorNpw);
                        else{
                           map<string,string> olderrorNPW = TTMLerrors.get(combinationkeys);
                           for(string err:parterrorNpw.keyset()){
                               olderrorNPW.put(err,parterrorNpw.get(err)); 
                           }
                            TTMLerrors.put(combinationkeys,olderrorNPW);
                        }
                      }
                }
                // Story - 53
                
           }
         }
        system.debug('TTML PopUp Erros---->>>>>'+TTMLerrors+'TTML PopUp Erros Size----'+TTMLerrors.size());
        return TTMLerrors;
    }
   //public  Set<String> covLimitValidationTTML(Id jobId, Id claimId, List<CSS_Parts_Options__c> ttmllst,boolean updaterecords){
    public  List<String> covLimitValidationTTML(Id jobId, Id claimId, List<CSS_Parts_Options__c> ttmllst,boolean updaterecords){
        try{
            List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
            Map<String, CSS_Solution_Component__c> solCompexp = new Map<String, CSS_Solution_Component__c>();
            List<CSS_Solution_Component__c> solCompUpd9 = new List<CSS_Solution_Component__c>();
            List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
            Id recTypeIdpart;
            //Set<String> errorLst = new Set<String>();
            List<String> errorLst = new List<String>();
            Map<String, Decimal> partsexp = new Map<String, Decimal>();
            set<string> failcodeerrors = new set<string>();
            map<id,decimal>  releatedmap = new map<id,decimal>();
            //system.debug('ttml size'+ttmllst.size());
            
            lstSolComp = [SELECT Id, CoveredTowingMiles__c,CSS_Account_Formula__c,CoveredTravelLabourErrMsg__c,CoveredTravelLabourStatus__c,CoverageTravelBaseFareExceedMsg__c,CoverageTravelBaseFareMsgTstatus__c,CoveredTravelBaseFareAmt__c,CoveredTravelMiles__c,CoveredTravelLabor__c,CoveredMealsLodgingAmt__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND Type__c Not In('TRP','ATC','CAMPAIGN') order by CSS_Failure_Sequence_Number__c];
            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            if(ttmllst != null){
                lstParts = [SELECT Id, Account_Code__c,fail_code__c,Type__c,ExpenseTotal__c,Mileage__c,HoursTravelled__c, Quantity__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart   AND ID NOT IN :ttmllst];//AND selected_part__c = true
                lstParts.addAll(ttmllst);  
            }else{
                lstParts = [SELECT Id, Account_Code__c,fail_code__c,Type__c,ExpenseTotal__c,Mileage__c,HoursTravelled__c, Quantity__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One' AND RecordTypeId =: recTypeIdpart  ];
                
            }
            
            //fetchJET();
            
            for(CSS_Solution_Component__c solcom : lstSolComp){
                String covtype = '';
                if(accCodeCovTypeMap != null && solcom.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solcom.CSS_Account_Formula__c.RIGHT(2));
                }
                system.debug('covtypeacc before if'+covtype);
                if(!solCompexp.containsKey(solcom.CSS_Account_Formula__c)){
                    
                    if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){// || covtype == 'OTH'){
                        system.debug('inside covtype postive'+covtype);
                        solCompexp.put(solcom.CSS_Account_Formula__c, solcom);
                        failcodeerrors.add(solcom.CSS_Account_Formula__c);
                    }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                        solCompexp.put(solcom.CSS_Account_Formula__c, solcom);
                        system.debug('inside covtype negative'+covtype);
                        
                    }
                }
                
                system.debug('Solition Map'+solCompexp);
                
            }
            
            map<string,decimal> comparemap = new map<string,decimal>();
            map<string,decimal> hourstravled = new map<string,decimal>();
            Map<String, Decimal> hourexp = new Map<String, Decimal>();
            //////
            map<string,decimal> CompMealsLodge = new map<string,decimal>();
            Map<String, Decimal> mealslodgeexp = new Map<String, Decimal>();
            map<string,decimal> Comnoncomap = new map<string,decimal>();
            Map<String, Decimal> mileageexp = new Map<String, Decimal>();
            Map<String, Decimal> towingMap = new Map<String, Decimal>();
            
            //////
            
            for(CSS_Parts_Options__c parts : lstParts){
                
                if(solCompexp.containsKey(parts.Account_Code__c)){
                    
                    decimal temptype ;
                    decimal temphrsfield ;
                    decimal tempmealslodgefield;
                    decimal tempmileage;
                    CSS_Solution_Component__c sol=  solCompexp.get(parts.Account_Code__c);
                    system.debug('solAccountCode$$$'+sol);
                    switch on parts.Type__c{
                        when 'Commercial-Travel','Meals','Lodging'{
                            
                            if(parts.Type__c=='Commercial-Travel'){
                                temptype=parts.ExpenseTotal__c;
                                system.debug('commerical ');
                                if(!comparemap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                                    comparemap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelBaseFareAmt__c));
                            }
                        } when 'Non Commercial-Travel'{
                            tempmileage=parts.Mileage__c;
                            if(!Comnoncomap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                                Comnoncomap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelMiles__c));
                            
                        }
                        //added below code for getting error message when type equals to Towing as per story #183916,-By RAJESH 14th May 2019
                        when 'Towing'{
                            temptype=parts.ExpenseTotal__c;
                            if(!towingMap.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim()))
                                towingMap.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTowingMiles__c));
                            system.debug('***First time towingMap ****'+towingMap);
                        }
                        //End
                    }
                    //Logic for Mileage calculations
                    if(parts.Type__c=='Non Commercial-Travel'){
                        
                        /*      if(!Comnoncomap.containsKey(parts.Account_Code__c.trim()))
Comnoncomap.put('hrstravled'+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelMiles__c));
system.debug('insidehrs'+Comnoncomap); */
                        
                        if(!mileageexp.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim())){
                            mileageexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), tempmileage);
                        }
                        else {
                            Decimal mileage = mileageexp.get(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim());
                            if(mileage==null)
                                mileage=0.0;
                            if(tempmileage==null)
                                tempmileage=0.0;
                            mileage = mileage+tempmileage;
                            mileageexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), mileage);
                        }
                        system.debug('Non-Comm***'+parts.Type__c+ 'mileage***'+mileageexp);
                    }
                    //Logic for Mileage calculations End
                    ////Logic for Meals & Logic calculation
                    if(parts.ExpenseTotal__c!=null && (parts.Type__c=='Meals' || parts.Type__c=='Lodging'))
                    {
                        tempmealslodgefield=parts.ExpenseTotal__c;
                        
                        if(!CompMealsLodge.containsKey('Mealslod'+'&'+parts.Account_Code__c.trim()))
                            CompMealsLodge.put('Mealslod'+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredMealsLodgingAmt__c));
                        
                        
                        if(!mealslodgeexp.containsKey('Mealslod'+'&'+parts.Account_Code__c.trim())){
                            mealslodgeexp.put('Mealslod'+'&'+parts.Account_Code__c.trim(), tempmealslodgefield);
                        }
                        else {
                            Decimal hour = mealslodgeexp.get('Mealslod'+'&'+parts.Account_Code__c.trim());
                            if(hour==null)
                                hour=0.0;
                            if(tempmealslodgefield==null)
                                tempmealslodgefield=0.0;
                            hour = hour+tempmealslodgefield;
                            mealslodgeexp.put('Mealslod'+'&'+parts.Account_Code__c.trim(), hour);
                        }
                        system.debug('MealsandLodge***'+parts.Type__c+ 'mealslodgeexp***'+mealslodgeexp);
                    }
                    ////Logic for Meals & Logic calculation End
                    
                    //Logic for HoursTravelled calculation
                    if(parts.HoursTravelled__c!=null ){
                        temphrsfield=parts.HoursTravelled__c;
                        if(!hourstravled.containsKey(parts.Account_Code__c.trim()))
                            hourstravled.put('hrstravled'+'&'+parts.Account_Code__c.trim(),decimal.valueof(sol.CoveredTravelLabor__c));
                        system.debug('insidehrs'+temphrsfield);
                        
                        if(!hourexp.containsKey('hrstravled'+'&'+parts.Account_Code__c.trim())){
                            hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), temphrsfield);
                            system.debug('HoursTravlled***'+temphrsfield);
                        }
                        else {
                            Decimal hour = hourexp.get('hrstravled'+'&'+parts.Account_Code__c.trim());
                            if(hour==null)
                                hour=0.0;
                            if(temphrsfield==null)
                                temphrsfield=0.0;
                            hour = hour+temphrsfield;
                            hourexp.put('hrstravled'+'&'+parts.Account_Code__c.trim(), hour);
                            system.debug('hour'+hour);
                        }
                        system.debug('parts.Type__c***'+parts.Type__c+'hourstotal&&&'+hourexp);
                    }
                    
                    //Logic for HoursTravelled calculation End
                    //Logic for Commercial Travel Logic
                    
                    if(!partsexp.containsKey(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim())){
                        partsexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), temptype);
                        system.debug('parts.Type__c'+parts.Type__c+ 'temtype++'+temptype);
                    }
                    else {
                        Decimal temp = partsexp.get(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim());
                        if(temp==null)
                            temp=0.0;
                        if(temptype==null)
                            temptype=0.0;
                        temp = temp+temptype;
                        partsexp.put(parts.Type__c.trim()+'&'+parts.Account_Code__c.trim(), temp);
                        system.debug('parts.Type__c'+parts.Type__c+'tempp'+temp);
                    }
                    
                    
                }
                
            }
            map<id,CSS_Solution_Component__c> errormap = new map<id,CSS_Solution_Component__c>();
            for(CSS_Parts_Options__c parts : lstParts){
                
                if(solCompexp.containsKey(parts.Account_Code__c)){
                    
                    CSS_Solution_Component__c solCmpTemp =solCompexp.get(parts.Account_Code__c);
                    string errorkey =parts.Type__c.trim()+'&'+ (parts.Account_Code__c != null ? parts.Account_Code__c.trim() : '');
                    String covtype = '';
                    if(accCodeCovTypeMap != null && solCmpTemp.CSS_Account_Formula__c != null){
                        covtype = accCodeCovTypeMap.get(solCmpTemp.CSS_Account_Formula__c.RIGHT(2));
                    }
                    if(partsexp.get(errorkey) > comparemap.get(errorkey)){
                        if(errormap.containsKey(solCmpTemp.id)){
                            CSS_Solution_Component__c oldrecord =errormap.get(solCmpTemp.id);
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey+'$'+parts.fail_code__c+';';
                                errorLst.add(errorkey+'$'+parts.fail_code__c);
                            }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey+';';
                                errorLst.add(errorkey);
                            }
                            errormap.put(solCmpTemp.id,oldrecord);
                        }
                        else{
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){// || covtype == 'OTH'){
                                system.debug('inside cal npw2'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                                solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey+'$'+parts.fail_code__c+';';
                                solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                errorLst.add(errorkey+'$'+parts.fail_code__c);
                            }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey+';';
                                solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                errorLst.add(errorkey);
                                system.debug('inside cal else  coverage'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                            }
                            errormap.put(solCmpTemp.id,solCmpTemp);
                        }
                        
                    }
                    //added below code for getting error message when type equals to Towing as per story #183916,-By RAJESH 14th May 2019
                    system.debug('***errorkey****'+errorkey);
                    system.debug('***partsexp.get(errorkey)****'+partsexp.get(errorkey));
                    system.debug('towingMap.get(errorkey)'+towingMap.get(errorkey));
                    
                    if(partsexp.get(errorkey) > towingMap.get(errorkey)){
                        system.debug('***getting value from towingMap****'+towingMap.get(errorkey));
                        system.debug('***covtype****'+covtype);
                        if(errormap.containsKey(solCmpTemp.id)){
                            CSS_Solution_Component__c oldrecord =errormap.get(solCmpTemp.id);
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey+'$'+parts.fail_code__c+';';
                                errorLst.add(errorkey+'$'+parts.fail_code__c);
                            }
                            else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey+';';
                                errorLst.add(errorkey);
                            }
                            errormap.put(solCmpTemp.id,oldrecord);
                        }
                        else{
                            system.debug('***Inside in else**'); 
                            if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                system.debug('***CoverageTravelBaseFareExceedMsg__c inside if from else part***'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                                solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey+'$'+parts.fail_code__c+';';
                                solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                errorLst.add(errorkey+'$'+parts.fail_code__c);
                            }
                            else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                system.debug('***Inside in else if from else part**'); 
                                solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey+';';
                                solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                errorLst.add(errorkey);
                                system.debug('inside cal else  coverage'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                            }
                            errormap.put(solCmpTemp.id,solCmpTemp);
                        }
                    }
                    if(partsexp.get(errorkey) <= towingMap.get(errorkey)){
                        system.debug('***enter inside main else ***');
                        solCmpTemp.CoverageTravelBaseFareExceedMsg__c='';
                        solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'PASSED';
                        errormap.put(solCmpTemp.id,solCmpTemp);
                    }
                    //End
                    
                    /////////////////////////////////////////////////////////////
                    string errorkey1 ='hrstravled'+'&'+parts.Account_Code__c.trim();
                    
                    if(parts.HoursTravelled__c!=null && hourexp.containsKey(errorkey1) && hourstravled.containsKey(errorkey1) ){
                        system.debug('hourexp.get(errorkey1)'+hourexp.get(errorkey1));
                        system.debug('hourstravled.get(errorkey1'+hourstravled.get(errorkey1));
                        system.debug('Errorkey'+errorkey);
                        
                        if(hourexp.get(errorkey1) > hourstravled.get(errorkey1)){
                            if(errormap.containsKey(solCmpTemp.id)){
                                system.debug('hourstravled.get(errorkey1'+hourstravled.get(errorkey1));
                                CSS_Solution_Component__c oldrecord =errormap.get(solCmpTemp.id);
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey1+'$'+parts.fail_code__c+'#hours'+';';
                                    errorLst.add(errorkey+'$'+parts.fail_code__c+'#hours');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey1+'#hours'+';';
                                    //errorLst.add(errorkey1+'#hours');
                                    errorLst.add(errorkey+'#hours');
                                    system.debug('oldrecord.CoverageTravelBaseFareExceedMsg__c'+oldrecord.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,oldrecord);
                            }
                            else{
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey1+'$'+parts.fail_code__c+'#hours'+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey+'$'+parts.fail_code__c+'#hours');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey1+'#hours'+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey+'#hours');
                                    system.debug('inside cal else2  coverage'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,solCmpTemp);
                            }
                            
                        }
                        else{ //Else condition is added as part of the defect # 191597 to handle negative scenario
                            solCmpTemp.CoverageTravelBaseFareExceedMsg__c = '';
                            solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'PASSED';
                            errormap.put(solCmpTemp.id,solCmpTemp);
                        }
                    }
                    ///////Mileage////////
                    
                    
                    string errorkey5 = parts.Type__c.trim()+'&'+parts.Account_Code__c.trim();
                    if(parts.Mileage__c!=null && mileageexp.containsKey(errorkey5) && Comnoncomap.containsKey(errorkey5) ){
                        system.debug('mileageexp.containsKey(errorkey5)'+mileageexp.get(errorkey5));
                        system.debug('Comnoncomap.containsKey(errorkey5)'+Comnoncomap.get(errorkey5));
                        
                        
                        if(mileageexp.get(errorkey5) > Comnoncomap.get(errorkey5)){
                            if(errormap.containsKey(solCmpTemp.id)){
                                system.debug('mileageexp.get(errorkey5**'+mileageexp.get(errorkey5));
                                system.debug('Comnoncomap.containsKey(errorkey5)'+Comnoncomap.get(errorkey5));
                                CSS_Solution_Component__c oldrecord =errormap.get(solCmpTemp.id);
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey5+'$'+parts.fail_code__c+';';
                                    errorLst.add(errorkey5+'$'+parts.fail_code__c+'*');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey5+';';
                                    errorLst.add(errorkey5+'*');
                                    system.debug('oldrecord.CoverageTravelBaseFareExceedMsg__c'+oldrecord.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,oldrecord);
                            }
                            else{
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey5+'$'+parts.fail_code__c+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey5+'$'+parts.fail_code__c+'*');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey5+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey5+'*');
                                    system.debug('inside cal else2  coverage'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,solCmpTemp);
                            }
                            
                        }
                        else{ //Else condition is added as part of the defect # 191597 to handle negative scenario
                            solCmpTemp.CoverageTravelBaseFareExceedMsg__c = '';
                            solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'PASSED';
                            errormap.put(solCmpTemp.id,solCmpTemp);
                        }
                    }
                    //////Mileage End//////
                    ///////////Code for Meals and Lodging Logic total
                    string errorkey2 ='Mealslod'+'&'+parts.Account_Code__c.trim();
                    if(parts.ExpenseTotal__c!=null && mealslodgeexp.containsKey(errorkey2) && CompMealsLodge.containsKey(errorkey2) && (parts.Type__c=='Meals' || parts.Type__c=='Lodging')){
                        if(mealslodgeexp.get(errorkey2) > CompMealsLodge.get(errorkey2)){
                            if(errormap.containsKey(solCmpTemp.id)){
                                CSS_Solution_Component__c oldrecord =errormap.get(solCmpTemp.id);
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey2+'$'+parts.fail_code__c+'@mealodge'+';';
                                    errorLst.add(errorkey2+'$'+parts.fail_code__c+'@mealodge');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    oldrecord.CoverageTravelBaseFareExceedMsg__c += errorkey2+'@mealodge'+';';
                                    errorLst.add(errorkey2+'@mealodge');
                                    system.debug('oldrecord.CoverageTravelBaseFareExceedMsg__c'+oldrecord.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,oldrecord);
                            }
                            else{
                                if(covtype == 'NPW' || covtype == 'RPW' || covtype == 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey2+'$'+parts.fail_code__c+'@mealodge'+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey2+'$'+parts.fail_code__c+'@mealodge');
                                }else if(covtype != 'OTH' && covtype != 'POL' && covtype != 'NPW' && covtype != 'RPW' && covtype != 'RRW'){
                                    solCmpTemp.CoverageTravelBaseFareExceedMsg__c=errorkey2+'@mealodge'+';';
                                    solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'ERROR'; 
                                    errorLst.add(errorkey2+'@mealodge');
                                    system.debug('inside cal else2  coverage'+solCmpTemp.CoverageTravelBaseFareExceedMsg__c);
                                }
                                errormap.put(solCmpTemp.id,solCmpTemp);
                            }
                            
                        }
                    }
                    if(solCmpTemp.CoverageTravelBaseFareMsgTstatus__c==null || solCmpTemp.CoverageTravelBaseFareExceedMsg__c == ''){
                        solCmpTemp.CoverageTravelBaseFareExceedMsg__c = '';
                        solCmpTemp.CoverageTravelBaseFareMsgTstatus__c = 'PASSED';
                        errormap.put(solCmpTemp.id,solCmpTemp);
                    }
                }
            }
            
            system.debug('Updating records'+errormap.size());
            if(errormap != null && errormap.size() > 0 && updaterecords){
                system.debug('Updating records'+errormap.size());
                update errormap.values();
            }
            system.debug('errorLst'+errorLst);
            return  errorLst;
            
        }
        catch(Exception ex) {
            System.debug('In last catch in cov limit exceeded: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            return null;
        }
    }
    
    // public static list<string> validationerrortypes(set<string> errors){
    public static set<string> validationerrortypes(List<string> errors){
        //list<string> errortypes = new list<string>();
        system.debug('*****inside validationerrortypes method***');        
        system.debug('*****errors*****'+errors);
        set<string> errortypes = new set<string>();
        for(String msg : errors){
            system.debug('*****msg*****'+msg);
            if(msg.substringBefore('&')=='Commercial-Travel' && !msg.contains('#')){
                if(msg.contains('$')){
                    errortypes.add(label.CSS_TTMLCoveredTravelErr_C+msg.substringafter('$')+' and Account Code :'+msg.substringafter('&').substringBefore('$'));
                    
                }else{
                    errortypes.add(Label.CSS_TTML_TravelbasefareamountMgs +msg.substringafter('&'));  
                }
            }
            else if(msg.substringBefore('&')=='Non Commercial-Travel' && !msg.contains('#')){
                if(msg.contains('$'))
                    errortypes.add(label.CSS_TTMLCoveredMilesErr_C +msg.substringafter('$').substringBefore('*')+' and Account Code :'+msg.substringafter('&').substringBefore('$'));
                else
                    errortypes.add(Label.CSS_TTML_TravelMilesErrMsg +msg.substringafter('&').substringBefore('*'));
            }
            //else if( msg.substringBefore('&')=='hrstravled'){
            else if(msg.contains('#')){
                if(msg.contains('$'))
                    errortypes.add(Label.CSS_TTMLLabourCoveredErr_C +msg.substringafter('$').substringBefore('#')+' and Account Code :'+  msg.substringafter('&').substringBefore('$')); 
                else
                    errortypes.add(Label.CSS_HoursTravelErrMSG +msg.substringafter('&').substringBefore('#'));
            }
            else if(msg.substringBefore('&')=='Mealslod'){
                if(msg.contains('$'))
                    errortypes.add(label.CSS_TTMLCoveredMealsLodgErr_C +msg.substringafter('$').substringBefore('@')+' and Account Code :'+  msg.substringafter('&').substringBefore('$')); 
                else
                    errortypes.add(label.CSS_TTML_MealsLodgingErrMSG +msg.substringafter('&').substringBefore('@'));
            }
            else if(msg.substringBefore('&')=='Towing'){
                system.debug('*****inside else if when type eqauls to Towing***');
                if(msg.contains('$')){
                    errortypes.add(label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Fail_Code +msg.substringafter('$').substringBefore('@')+' and Account Code :'+  msg.substringafter('&').substringBefore('$')); 
                    system.debug('*****inside if part errortypes***'+errortypes);
                }
                else{
                    errortypes.add(label.CSS_Towing_Amount_claimed_exceeds_the_coverage_limit_for_the_Account_Code +msg.substringafter('&'));
                    system.debug('*****inside else if part errortypes***'+errortypes);
                }
            }
            //End
        }
        system.debug('*****errortypes***'+errortypes);
        return errortypes;
    }
    //To check if a Claim is covered for URP/TTML/OC and SRT - Story #178812
    public List<Boolean> checkFailuresCovered(Id claimId, Boolean needToUpdate){
        system.debug('inside checkFailuresCovered method');
        List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
        List<Boolean> isURPCovered = new List<Boolean>(); //index 0
        List<Boolean> isOCCovered = new List<Boolean>(); //index 1
        List<Boolean> isTTMLCovered = new List<Boolean>(); //index 2
        List<Boolean> isDiagRepSRTCovered = new List<Boolean>(); //index 3
        List<Boolean> isFieldActionSRTCovered = new List<Boolean>(); //index 4
        List<Boolean> resultLst = new List<Boolean>();
        lstSolComp = [SELECT Id, CSS_Account_Formula__c,Type__c, CSS_Failure_Sequence_Number__c, CoveredPartsQty__c, CampaignPartsPercentage__c, CoveredOCAmount__c, 
                      CampaignOCPercentage__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, CoveredTravelBaseFareAmt__c, CoveredTravelLabor__c,
                      CoveredTravelMiles__c, CoveredTowingMiles__c, CoveredMealsLodgingAmt__c, CampaignTravelPercentage__c, CampaignTowingPercentage__c
                      FROM CSS_Solution_Component__c 
                      WHERE CSS_Claims__c =: claimId AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c != '' AND ((Type__c IN ('ATC','TRP','Campaign') AND Selected_Component__c = true) OR (Type__c NOT IN ('ATC','TRP','Campaign')))];
        CSS_Claims__c claimRec = new CSS_Claims__c();
        claimRec.Id = claimId;
        //fetchJET();
        if(lstSolComp != null && lstSolComp.size() > 0){
            system.debug('inside if condition');
            for(CSS_Solution_Component__c solComp : lstSolComp){
                String covtype = '';
                if(accCodeCovTypeMap != null && solComp.CSS_Account_Formula__c != null){
                    covtype = accCodeCovTypeMap.get(solComp.CSS_Account_Formula__c.RIGHT(2));
                }
                system.debug('covtype**'+covtype);
                if(covtype != 'OTH' && covtype != 'POL'){
                    //URP
                    if(solComp.Type__c != 'Campaign' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){
                        system.debug('solComp.CoveredPartsQty__c**'+solComp.CoveredPartsQty__c);
                        if(solComp.CoveredPartsQty__c == null || (solComp.CoveredPartsQty__c != null && double.valueOf(solComp.CoveredPartsQty__c) == 0)){
                            isURPCovered.add(false); //= false;
                        }
                        else if(solComp.CoveredPartsQty__c != null && double.valueOf(solComp.CoveredPartsQty__c) > 0){
                            isURPCovered.add(true);
                        }
                    }
                    else{
                        if(solComp.CampaignPartsPercentage__c == null || (solComp.CampaignPartsPercentage__c != null && double.valueOf(solComp.CampaignPartsPercentage__c) == 0)){
                            isURPCovered.add(false); //= false;
                        }
                        else if(solComp.CampaignPartsPercentage__c != null && Integer.valueOf(solComp.CampaignPartsPercentage__c) > 0){
                            isURPCovered.add(true);
                        }
                    }
                    //TTML
                    if(solComp.Type__c != 'Campaign' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){
                        if((solComp.CoveredTravelBaseFareAmt__c == null || (solComp.CoveredTravelBaseFareAmt__c != null && Integer.valueOf(solComp.CoveredTravelBaseFareAmt__c) == 0)) ||
                           (solComp.CoveredTravelLabor__c == null || (solComp.CoveredTravelLabor__c != null && Integer.valueOf(solComp.CoveredTravelLabor__c) == 0))){ //Commercial
                               isTTMLCovered.add(false); //= false;
                           }
                        else if((solComp.CoveredTravelBaseFareAmt__c != null && Integer.valueOf(solComp.CoveredTravelBaseFareAmt__c) > 0) && 
                                (solComp.CoveredTravelLabor__c != null && Integer.valueOf(solComp.CoveredTravelLabor__c) > 0)){
                                    isTTMLCovered.add(true);
                                }
                        if((solComp.CoveredTravelMiles__c == null || (solComp.CoveredTravelMiles__c != null && Integer.valueOf(solComp.CoveredTravelMiles__c) == 0)) ||
                           (solComp.CoveredTravelLabor__c == null || (solComp.CoveredTravelLabor__c != null && Integer.valueOf(solComp.CoveredTravelLabor__c) == 0))){ //Non-Commercial
                               isTTMLCovered.add(false); //= false;
                           }
                        else if((solComp.CoveredTravelMiles__c != null && Integer.valueOf(solComp.CoveredTravelMiles__c) > 0) && 
                                (solComp.CoveredTravelLabor__c != null && Integer.valueOf(solComp.CoveredTravelLabor__c) > 0)){
                                    isTTMLCovered.add(true);
                                }
                        if(solComp.CoveredTowingMiles__c == null || (solComp.CoveredTowingMiles__c != null && double.valueOf(solComp.CoveredTowingMiles__c) == 0)){ //Towing
                            isTTMLCovered.add(false); //= false;
                        }
                        else if(solComp.CoveredTowingMiles__c != null && double.valueOf(solComp.CoveredTowingMiles__c) > 0){
                            isTTMLCovered.add(true);
                        }
                        if(solComp.CoveredMealsLodgingAmt__c == null || (solComp.CoveredMealsLodgingAmt__c != null && Integer.valueOf(solComp.CoveredMealsLodgingAmt__c) == 0)){ //Meals/Lodging
                            isTTMLCovered.add(false); //= false;
                        }
                        else if(solComp.CoveredMealsLodgingAmt__c != null && Integer.valueOf(solComp.CoveredMealsLodgingAmt__c) > 0){
                            isTTMLCovered.add(true);
                        }
                    }
                    else{
                        //Commercial/Non-Commercial/Meals/Loding
                        if(solComp.CampaignTravelPercentage__c == null || (solComp.CampaignTravelPercentage__c != null && Integer.valueOf(solComp.CampaignTravelPercentage__c) == 0)){
                            isTTMLCovered.add(false); //= false;
                        }
                        else if(solComp.CampaignTravelPercentage__c != null && Integer.valueOf(solComp.CampaignTravelPercentage__c) > 0){
                            isTTMLCovered.add(true);
                        }
                        //Towing
                        if(solComp.CampaignTowingPercentage__c == null || (solComp.CampaignTowingPercentage__c != null && Integer.valueOf(solComp.CampaignTowingPercentage__c) == 0)){
                            isTTMLCovered.add(false); //= false;
                        }
                        else if(solComp.CampaignTowingPercentage__c != null && Integer.valueOf(solComp.CampaignTowingPercentage__c) > 0){
                            isTTMLCovered.add(true);
                        }
                    }
                    //OC
                    if(solComp.Type__c != 'Campaign' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){
                        if(solComp.CoveredOCAmount__c == null || (solComp.CoveredOCAmount__c != null && Integer.valueOf(solComp.CoveredOCAmount__c) == 0)){
                            isOCCovered.add(false); //= false;
                        }
                        else if(solComp.CoveredOCAmount__c != null && Integer.valueOf(solComp.CoveredOCAmount__c) > 0){
                            isOCCovered.add(true);
                        }
                    }
                    else{
                        if(solComp.CampaignOCPercentage__c == null || (solComp.CampaignOCPercentage__c != null && Integer.valueOf(solComp.CampaignOCPercentage__c) == 0)){
                            isOCCovered.add(false); //= false;
                        }
                        else if(solComp.CampaignOCPercentage__c != null && Integer.valueOf(solComp.CampaignOCPercentage__c) > 0){
                            isOCCovered.add(true);
                        }
                    }
                    //SRT
                    if(solComp.Type__c != 'Campaign' && solComp.Type__c != 'TRP' && solComp.Type__c != 'ATC'){ //Diag/Rep SRT
                        if(solComp.CoveredLaborHrs__c == null || (solComp.CoveredLaborHrs__c != null && Integer.valueOf(solComp.CoveredLaborHrs__c) == 0)){
                            isDiagRepSRTCovered.add(false); //= false;
                        }
                        else if(solComp.CoveredLaborHrs__c != null && Integer.valueOf(solComp.CoveredLaborHrs__c) > 0){
                            isDiagRepSRTCovered.add(true);
                        }
                    }
                    else{ //Field Action SRT
                        if(solComp.CampaignLaborPercentage__c == null || (solComp.CampaignLaborPercentage__c != null && Integer.valueOf(solComp.CampaignLaborPercentage__c) == 0)){
                            isFieldActionSRTCovered.add(false); //= false;
                        }
                        else if(solComp.CampaignLaborPercentage__c != null && Integer.valueOf(solComp.CampaignLaborPercentage__c) > 0){
                            isFieldActionSRTCovered.add(true);
                        }
                    }
                }
                else{
                    isURPCovered.add(true);
                    isTTMLCovered.add(true);
                    isOCCovered.add(true);
                    isDiagRepSRTCovered.add(true);
                    isFieldActionSRTCovered.add(true);
                }
            }
            system.debug('inside if condition isURPCovered'+isURPCovered);
            system.debug('inside if condition isOCCovered'+isOCCovered);
            system.debug('inside if condition isTTMLCovered'+isTTMLCovered);
            system.debug('inside if condition isDiagRepSRTCovered'+isDiagRepSRTCovered);
            system.debug('inside if condition isFieldActionSRTCovered'+isFieldActionSRTCovered);
        }
        else{
            claimRec.CoveragePartsErrMsg__c = '';//Label.CSS_Coverage_not_found_for_Parts;
            claimRec.CoverageOCErrMsg__c = '';//Label.CSS_Coverage_not_found_for_OC;
            claimRec.CoverageTTMLErrMsg__c = '';//Label.CSS_Coverage_not_found_for_TTML;
            claimRec.CoverageSRTErrMsg__c = '';//Label.CSS_Coverage_not_found_for_SRTs;
            resultLst.add(true);
            resultLst.add(true); 
            resultLst.add(true);
            resultLst.add(true);
            resultLst.add(true);
            system.debug('inside else '+claimRec);
        }
        system.debug('result lst-->'+resultLst);
        if(lstSolComp != null && lstSolComp.size() > 0){
            if(isURPCovered.contains(true)){
                resultLst.add(true);//(0, true);//[0] = true;
                claimRec.CoveragePartsErrMsg__c = '';
            }
            else{
                resultLst.add(false);//(0, false);
                claimRec.CoveragePartsErrMsg__c = Label.CSS_Coverage_not_found_for_Parts;
            }
            if(isOCCovered.contains(true)){
                resultLst.add(true);
                claimRec.CoverageOCErrMsg__c = '';
            }
            else{
                resultLst.add(false);
                claimRec.CoverageOCErrMsg__c = Label.CSS_Coverage_not_found_for_OC;
            }
            if(isTTMLCovered.contains(true)){
                resultLst.add(true);
                claimRec.CoverageTTMLErrMsg__c = '';
            }
            else{
                resultLst.add(false);
                claimRec.CoverageTTMLErrMsg__c = Label.CSS_Coverage_not_found_for_TTML;
            }
            if(isDiagRepSRTCovered.contains(true)){
                resultLst.add(true);
                claimRec.CoverageSRTErrMsg__c = '';
            }
            else{
                resultLst.add(false);
                claimRec.CoverageSRTErrMsg__c = Label.CSS_Coverage_not_found_for_SRTs;
            }
            if(isFieldActionSRTCovered.contains(true)){
                resultLst.add(true);
                claimRec.CoverageSRTErrMsg__c = '';
            }
            else{
                resultLst.add(false);
                if(claimRec.CoverageSRTErrMsg__c == ''){
                    //do notihng
                }
                else{
                    claimRec.CoverageSRTErrMsg__c = Label.CSS_Coverage_not_found_for_SRTs;
                }
            }
        }
        system.debug('before if condition-->'+claimRec);
        system.debug('before if condition-->'+needToUpdate);
        if(claimRec != null && needToUpdate == true){
            system.debug('inside if condition-->'+claimRec);
            update claimRec;
        }
        system.debug('resultLst'+resultLst);
        return resultLst;
    }
}