/*
* Block comments with details of changes
*/
public class CSS_GSQPartsJobPlan
{
    public Id Ins_JobId {get; set{Ins_JobId = value; 
                                  system.debug('in setter Ins_JobId>>>>>>>>>>:'+Ins_JobId);
                                  if(singleRun==1){
                                      listpartWrapper = new List<partWrapperClass>();
                                      setpartWrapper = new Set<partWrapperClass>();
                                      listpartWrapper.clear();
                                      setpartWrapper.clear();
                                      getfailcodeDropDown();
                                      getallCustomPartsData(false);
                                      singleRun+=1;
                                      System.debug('in setter GSQ Parts:1');
                                  }
                                 } }
    public String SerjobNumber {get; set;}
    public  boolean ErrorMessage {get; set;}
    //public String coverageType;
    public  boolean DescErrMessage {get; set;}
    public Boolean isDealer {get;set;}
    public string servicepartname{get;set;}
    public  boolean PartNotFoundError {get; set;}//When the part number is not found
    public  boolean PartNoValidationError {get; set;}//when the part is not validated correctly.
    public boolean partnoborder{get;set;}//For red error border around part number
    public  boolean accountcodeReadOnly {get; set;}
    public Integer assignedParts{get;set;}
    public Set<partWrapperClass> setpartWrapper {get;set;}
    public List<partWrapperClass> listpartWrapper {get;set;}//list of all added fields of a row
    public List<partWrapperClass> listpartWrapper2 {get;set;}
    public String SelectedFailCode{get;set;}
    public integer  SelectedPartID{get;set;}
    @testvisible list<CSS_Parts_Options__c> existPartList{get; set;}
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    public Boolean displayPopup2{get;set;}
    public boolean chkReqField{get;set;}
    public Id recTypeIdpart;
    public string partrownumber {get; set;}//Part row number that has been passed from UI
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public integer singleRun=0; 
    //public String coverageType;
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    public Transient Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();// Added by rajesh and vamshi defect 737
     public Map<String,Set<String>> failAccountCodeMap{get;set;}
     //public list<CSS_JobEventTemporary__c> jobEventLst;
     public String coverageType;
     public Set<String> errMsgLst{get;set;}
     public List<String> errMsgLstNew{get;set;}
    public CSS_GSQPartsJobPlan()
    {
      /*  String userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        }*/
        singleRun = 1;
        accountcodeReadOnly=false;
        System.debug('in consturctor CSS_GSQPartsJobPlan');

        JETFA = new list<CSS_JobEventTemporary__c>();
        JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
        for(CSS_JobEventTemporary__c jet : JETFA){
            string temp = jet.Attribute3__c; 
            if(!accCodeMapJET.containskey(temp))
                accCodeMapJET.put(temp,jet);
        }
        getfailcodeDropDown();
       // getAccountCodeDropDown();   
    }

    public void CallGetPartDataService()
    {
        
        try{
        PartNotFoundError = false;
        partnoborder=false;
        if(partrownumber!=null)
            system.debug('Row Number.'+partrownumber);
        system.debug('The whole wrapper'+listpartWrapper);
        listpartWrapper2=listpartWrapper.clone();
        listpartWrapper.clear();
        for(integer i=0;i<listpartWrapper2.size();i++)
        {
            if(string.valueof(listpartWrapper2[i].counting) == partrownumber)
            {
                system.debug('entered into partnumber');
                if(listpartWrapper2[i].servPartNumber!=''){//Defect-#164432
                    CG_OP_OAGWrapper opres = new CG_OP_OAGWrapper();
                    opres = CSS_FN_SIEBEL.getpartsdata(listpartWrapper2[i].servPartNumber.toUpperCase());//The JSON response obtained 
                    system.debug('****opres***8'+opres);
                  //  system.debug('opres.response.getStatusCode()' + opres.response.getStatusCode());
                    //If the Quantity field is empty then default it to 1.
                    IF(listpartWrapper2[i] != null && (listpartWrapper2[i].quantity==null || listpartWrapper2[i].quantity=='' || string.isBlank(listpartWrapper2[i].quantity)))
                        listpartWrapper2[i].quantity='1';
                    listpartWrapper2[i].partName = '';


                    if(opres!=null && opres.response!=null && opres.response.getbody()!=null && opres.response.getbody()!='')
                    {
                        CG_GetPartsdataresWrapper res = (CG_GetPartsdataresWrapper) System.JSON.deserialize(opres.response.getBody(), CG_GetPartsdataresWrapper.class);
                        System.debug('Today res ' +  res);
                        if(res.header.status=='Success')//Service response came back without any error/warning messages
                        {
                            if(string.isNotBlank(res.DataArea.PartDescription) || string.isNotEmpty(res.DataArea.PartDescription)){
                                listpartWrapper2[i].partName = res.DataArea.PartDescription;//store the ‘PartDescription’ in the ‘Part Name’ field on the Pop-up.
                                //listpartWrapper2[i].returnToFactory = res.DataArea.PartInService;
                                onChangeofPartNumber(Integer.valueOf(partrownumber));
                            }
                            else 
                            {
                                system.debug('Service is successful but there is no part no returned.');
                                PartNotFoundError = true;//Part 
                                partnoborder=true;

                            }
                            //Added if condition as per Stroy 166393,-By  Rajesh/Rupesh 2nd Nov 2018
                            //if(Compare the ‘Part Number’ field value from the URP table to the ‘PartNumberLong’ field in the webservice)
                            //4034289RX 403428900RX 
                            //if(If the ‘Part Number’ field value is a Short Part Number i.e. the values from the successful response of the webservice mismatch)
                            //Then store the ‘PartNumberLong’ field value returned by the webservice in the ‘Part Number’ field of the URP Pop-up
                            if(string.isNotBlank(res.DataArea.PartNumberLong) || string.isNotEmpty(res.DataArea.PartNumberLong))
                            {
                                system.debug('The part no long is..'+res.DataArea.PartNumberLong);
                                if(listpartWrapper2[i].servPartNumber !=res.DataArea.PartNumberLong)
                                    listpartWrapper2[i].servPartNumber =res.DataArea.PartNumberLong;//Part number is servPartNumber and Part Name is description
                            }
                            //End
                        }
                        if(res.header.status=='Error' || opres.response.getStatusCode() != 200)//Service response came back with some error or warning
                        {
                            system.debug('Service response came back with some error or warning');
                            PartNotFoundError = true;
                            partnoborder=true;
                            String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ listpartWrapper2[i].servPartNumber +'"}}';
                            CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                            intDetails.Response_Body__c =  opres.response.getbody();
                            intDetails.Processed_Data__c = reqBody;
                            intDetails.Service_Name__c = 'GetPartsData';
                            intDetails.Source__c = 'Siebel';
                            intDetails.Service_Job_Number__c=SerjobNumber;
                            intDetails.Service_Call_Time__c =opres.totalServiceCallTime;
                            insert intDetails;
                            system.debug('Integration records inserted' + intDetails);

                        }

                    }
                    else
                    {
                        PartNoValidationError= true;
                        partnoborder=true;
                         String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ listpartWrapper2[i].servPartNumber +'"}}';
                            CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();
                            intDetails.Response_Body__c = '';
                            intDetails.Processed_Data__c = reqBody;
                            intDetails.Service_Name__c = 'GetPartsData';
                            intDetails.Source__c = 'Siebel';
                            intDetails.Service_Job_Number__c=SerjobNumber;
                           //intDetails.Service_Call_Time__c = 
                            insert intDetails;
                            system.debug('Integration records inserted' + intDetails);
                        system.debug('Output wrapper itself id null,Set the flag for part validation invalid,Please try again');
                    } 
                }
                else{
                    system.debug('**********8888888**********');
                    PartNotFoundError = false;//Defect-#164432
                    partnoborder=false;//Defect-#164432
                    listpartWrapper2[i].servPartNumber=null;
                    listpartWrapper2[i].partName=null;
                    removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                }   
            }

        }
        listpartWrapper=listpartWrapper2.clone();
        listpartWrapper2.clear();
        }
        catch(Exception ex) {
            System.debug('in catch of getPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public void onChangeofPartNumber(Integer selPartnumberr){
        try{
            system.debug('Method goining inside onChangeofPartNumber');
            system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
            system.debug('SelectedPartID>>>>>>>>>>: '+selPartnumberr);
            String accCode;
            String CoveredPar ='';
           

            list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();

            lstSolComp= [SELECT Id, SysCodeAndCompCode__c,In_Shop_SRT_Limit_Flag__c,CampaignLaborPercentage__c,fail_code__c, FailCode_Formula__c ,CSS_CoverageType__c,Covered_Parts__c,Failure_Mode__c, CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c,Root_Cause__c  from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and FailCode_Formula__c!=null and Selected_Component__c=true]; // 
            
            //GSSC-300
            List<SelectOption> options;
             String failCode;
            Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
            Map<String,List<CSS_Solution_Component__c>> FAMap = new Map<String,List<CSS_Solution_Component__c>>();
            List<CSS_Solution_Component__c> failureList;
            List<CSS_Solution_Component__c> FAList;
            system.debug('lstSolComp>>'+lstSolComp);
            if(lstSolComp != null && lstSolComp.size() > 0){
                List<CSS_Solution_Component__c> tempList;
                for(CSS_Solution_Component__c slcp : lstSolComp){
                    String FARec;
                    if(slcp.Type__c == 'Campaign' || slcp.Type__c == 'TRP' || slcp.Type__c == 'ATC')
                        FARec='FieldAction';
                    else
                        FARec='Failure';
                    if(solCmpMap.containsKey(FARec)){
                        tempList = solCmpMap.get(FARec);
                        system.debug('tempList'+tempList);
                        tempList.add(slcp);
                        system.debug('tempList'+tempList);
                        solCmpMap.put(FARec, tempList);
                    }
                    else{
                        tempList = new List<CSS_Solution_Component__c>();
                        tempList.add(slcp);
                        solCmpMap.put(FARec, tempList);
                    }
                }
                failureList = new List<CSS_Solution_Component__c>();
                FAList = new List<CSS_Solution_Component__c>();
                Map<String,List<CSS_Solution_Component__c>> accSolCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
                List<CSS_Solution_Component__c> accSlCmp;
                if(solCmpMap != null){
                    failureList = solCmpMap.get('Failure');
                    FAList = solCmpMap.get('FieldAction');
                }
                system.debug('FAList**'+FAList);
                if(FAList!=null && failureList == null){
                    options=fetchAccountCodeDropDown(FAList[0].fail_code__c);
                    List<CSS_Solution_Component__c> tempListFA;
                    for(CSS_Solution_Component__c slcp : FAList){
                        String InshopFlag;
                        if(slcp.In_Shop_SRT_Limit_Flag__c == true)
                            InshopFlag='Y';
                        else
                            InshopFlag='N';
                        if(FAMap.containsKey(InshopFlag)){
                            tempListFA = FAMap.get(InshopFlag);
                            system.debug('tempListFA'+tempListFA);
                            tempListFA.add(slcp);
                            system.debug('tempListFA'+tempListFA);
                            FAMap.put(InshopFlag, tempListFA);
                        }
                        else{
                            tempListFA = new List<CSS_Solution_Component__c>();
                            tempListFA.add(slcp);
                            FAMap.put(InshopFlag, tempListFA);
                        }
                    }
                    tempListFA = new List<CSS_Solution_Component__c>();
                    for(String slcmpKey: FAMap.keySet()){
                        tempListFA = FAMap.get(slcmpKey);
                        system.debug('tempListFA****'+tempListFA);
                        if(slcmpKey == 'N' && tempListFA.size()==1){
                            system.debug('insideIf***');
                            if((tempListFA[0].CampaignLaborPercentage__c != null && tempListFA[0].CampaignLaborPercentage__c != '' && Double.valueOf(tempListFA[0].CampaignLaborPercentage__c) >0 && (tempListFA[0].CSS_CoverageType__c != 'OTH' && tempListFA[0].CSS_CoverageType__c != 'POL')) || (tempListFA[0].CSS_CoverageType__c == 'OTH' || tempListFA[0].CSS_CoverageType__c == 'POL')){
                                failCode=String.valueof(tempListFA[0].FailCode_Formula__c);
                                system.debug('CSS_Account_Formula__c****'+tempListFA[0].CSS_Account_Formula__c);
                                AccCode=tempListFA[0].CSS_Account_Formula__c;
                            }
                            system.debug('failCode***'+failCode);
                            system.debug('AccCode***'+AccCode);
                        }
                        else
                            continue;
                    }
                }
                
                if(failureList!=null)
                options=fetchAccountCodeDropDown(failureList[0].fail_code__c);//GSSC-190 changed from systemcode and comp code field to fail_code to fix auto population issue
                
                system.debug('**failureList*'+failureList);
                system.debug('**options*'+options);
                if(failureList!=null && failureList.size() >1){
                    for(CSS_Solution_Component__c sc:failureList){
                        if(accSolCmpMap.containsKey(sc.CSS_Account_Formula__c)){
                            accSlCmp=accSolCmpMap.get(sc.CSS_Account_Formula__c);
                            accSlCmp.add(sc);
                            accSolCmpMap.put(sc.CSS_Account_Formula__c,accSlCmp);
                        }
                        else{
                            accSlCmp = new List<CSS_Solution_Component__c>();
                            accSlCmp.add(sc);
                            accSolCmpMap.put(sc.CSS_Account_Formula__c, accSlCmp);
                        }
                    }
                }
                
                if(failureList !=null && failureList.size() >0){
                    if((failureList.size() == 1 && failureList[0].CoveredPartsQty__c != null && Integer.valueOf(failureList[0].CoveredPartsQty__c) >0 && failureList[0].CSS_CoverageType__c != 'OTH' && failureList[0].CSS_CoverageType__c != 'POL') || (failureList.size() == 1 &&(failureList[0].CSS_CoverageType__c == 'OTH' || failureList[0].CSS_CoverageType__c == 'POL'))){
                        system.debug('karthikFirst if');
                        CoveredPar =  failureList[0].CoveredPartsQty__c; 
                        failCode =  String.valueof(failureList[0].FailCode_Formula__c);
                        accCode = failureList[0].CSS_Account_Formula__c;
                    }
                    else if((failureList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 && failureList[0].CoveredPartsQty__c != null && Integer.valueOf(failureList[0].CoveredPartsQty__c) >0 && failureList[0].CSS_CoverageType__c != 'NPW' && failureList[0].CSS_CoverageType__c != 'RPW' && failureList[0].CSS_CoverageType__c != 'RRW' && failureList[0].CSS_CoverageType__c != 'OTH' && failureList[0].CSS_CoverageType__c != 'POL') || (failureList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 &&(failureList[0].CSS_CoverageType__c == 'OTH' || failureList[0].CSS_CoverageType__c == 'POL'))){
                         system.debug('karthikFirst elseif');
                        system.debug('**insideelseIf*'+failureList[0].CSS_Account_Formula__c);
                        CoveredPar =  failureList[0].CoveredPartsQty__c; 
                        failCode =  String.valueof(failureList[0].FailCode_Formula__c);
                        accCode = failureList[0].CSS_Account_Formula__c;
                    }
                    else{
                        system.debug('karthikFirst elseif');
                        failCode =  'Select One';
                        accCode = 'Select One';
                    }
                    
                }
            }
            
            if(CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0 && (failureList!=null && failureList[0].CSS_CoverageType__c!='POL' && failureList[0].Root_Cause__c==true)){  // karthik G Added POL condtion  as part of defect 191853
                system.debug('karthikFirstanoth if');
                CoveredPar = '100'; 

            }
            else if(((CoveredPar!='' && Integer.ValueOf(CoveredPar) > 0) || (CoveredPar=='' || Integer.ValueOf(CoveredPar) == 0)) && (failureList!=null && failureList[0].CSS_CoverageType__c == 'POL' && failureList[0].Root_Cause__c==true)){
                CoveredPar = lstSolComp[0].Covered_Parts__c;  // karthik G added as part of story GSSC-57 

            }
            else if(CoveredPar!='' && Integer.ValueOf(CoveredPar) == 0 ){
               CoveredPar = '0';
            }

            else{
                CoveredPar = '';
            } 
            for(partWrapperClass  prtslist:listpartWrapper2 ){
                system.debug( 'prtslist.counting'+prtslist.counting);
                if(prtslist.counting == selPartnumberr)
                {
                    prtslist.failCode =  failCode;
                    prtslist.returnToFactory='';
                    prtslist.accountCode = accCode ;
                    prtslist.lstFCAC=options;
                    system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar;

                }

               system.debug('karthikF>>>>>>>f'+prtslist.coveredPercent);
            }
        }catch(exception e){
            system.debug('Entered into catch block of onChangeofPartNumber method in cg_cl_claimsuserRequestedParts class'+e.getlinenumber()+e.getMessage());
        }
    }
    public void getallCustomPartsData(Boolean displayPopup2)
    {
        System.debug('in getallCustomPartsData GSQ Parts:3');
        chkReqField = false;
        // DescErrMessage = false;
        if(displayPopup2)
        {
            ErrorMessage = true;
            DescErrMessage = true;
        }
        else
            ErrorMessage = false;
        DescErrMessage = false;
        customPartlstUI = new list<CSS_Parts_Options__c>();
        try
        {
            system.debug('Ins_JobId>>>>>>>>>>:'+Ins_JobId);

            recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            if(!Test.isRunningTest()) {
                customPartlstUI = [select Id,RecordTypeId,Notes__c,OEM__c,Replacement_Reason__c,Get_Fail_Code_Formula__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,
                                   ReturnToFactory__c,Service_Job__c,Covered__c,Fail_Code__c,Account_Code__c,Solutions__c, Parts_Type__c 
                                   from CSS_Parts_Options__c where Service_Job__c =:Ins_JobId and RecordTypeId=:recTypeIdpart and Parts_Type__c ='Custom'];
            } else {
                customPartlstUI = [select Id,RecordTypeId,Notes__c,OEM__c,Replacement_Reason__c,Get_Fail_Code_Formula__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,
                                   ReturnToFactory__c,Service_Job__c,Covered__c,Fail_Code__c,Account_Code__c,Solutions__c, Parts_Type__c
                                   from CSS_Parts_Options__c where Service_Job__c =:Ins_JobId and RecordTypeId=:recTypeIdpart and Parts_Type__c ='Custom' limit 1];
            }
            system.debug('customPartlstUI size>>>:'+customPartlstUI.size()+'customPartlstUI querry>>>>>>>>>>:'+customPartlstUI);
             List<SelectOption> options =  new List<SelectOption>();
                options.add(new SelectOption('Select One','Select One'));
            
            if(customPartlstUI.size()>0){
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                errMsgLst = contr.covLimitValidation(Ins_JobId, null, customPartlstUI, null);
                system.debug('**Before errMsgLst**'+errMsgLst);
                errMsgLst.addAll(contr.covLimitValidationJob(Ins_JobId, customPartlstUI));  //Added as part of the story GSSC-50
                system.debug('**errMsgLst**'+errMsgLst);
                listpartWrapper = new List<partWrapperClass>();
                setpartWrapper = new Set<partWrapperClass>();
                for(integer i=0;i<customPartlstUI.size();i++){
                    if(customPartlstUI[i].Replacement_Reason__c == null || customPartlstUI[i].Replacement_Reason__c == '' || customPartlstUI[i].Replacement_Reason__c == 'Select One'){
                        customPartlstUI[i].Replacement_Reason__c = 'Refer to Narrative';
                    }
                    setpartWrapper.add(new partWrapperClass(i,customPartlstUI[i].Id,String.valueof(customPartlstUI[i].Quantity__c),customPartlstUI[i].Service_partnumber__c,customPartlstUI[i].Part_Name__c,customPartlstUI[i].Replacement_Reason__c,customPartlstUI[i].Notes__c,customPartlstUI[i].OEM__c,customPartlstUI[i].Selected_part__c,customPartlstUI[i].ReturnToFactory__c,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c,fetchAccountCodeDropDown(customPartlstUI[i].Fail_Code__c)));
                }
                if(customPartlstUI.size()<=9) {
                    for(integer i=0;i<10-customPartlstUI.size();i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Notes__c = '';
                        partsoption.OEM__c = '';
                        partsoption.Selected_part__c = false;
                        partsoption.Part_Name__c = '';
                        partsoption.ReturnToFactory__c = '';
                        partsoption.Fail_Code__c = '';
                        partsoption.Account_Code__c = '';
                        partsoption.Replacement_Reason__c='Select One';
                        partsoption.Service_partnumber__c = '';
                        partsoption.Parts_Type__c='Custom';

                        try{
                            System.debug('setpartWrapper size>>>>:'+setpartWrapper.size()+' i===:'+i+' size:'+customPartlstUI.size()+i);
                            setpartWrapper.add(new partWrapperClass(customPartlstUI.size()+i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c,partsoption.ReturnToFactory__c,'',partsoption.Fail_Code__c,partsoption.Account_Code__c,options));
                        }catch(Exception ex){
                            System.debug('in catch of getallCustomPartsData of CSS_GSQParts adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                        }
                        System.debug('setpartWrapper>>>:'+setpartWrapper);
                    }
                    system.debug('customPartlstUI>>>>>>>>>>:'+customPartlstUI);
                }
                system.debug('setpartWrapper exist>>>>>>>>>>:'+setpartWrapper);
            }else{
                listpartWrapper = new List<partWrapperClass>();
                setpartWrapper = new Set<partWrapperClass>();
                for(integer i=0;i<10;i++){
                    CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                    partsoption.Notes__c = '';
                    partsoption.OEM__c = '';
                    partsoption.Selected_part__c = false;
                    partsoption.Part_Name__c = '';
                    partsoption.ReturnToFactory__c = '';
                    partsoption.Fail_Code__c = '';
                    partsoption.Account_Code__c = '';
                    partsoption.Replacement_Reason__c='Select One';
                    partsoption.Service_partnumber__c = '';
                    partsoption.Parts_Type__c='Custom';
                    setpartWrapper.add(new partWrapperClass(customPartlstUI.size()+i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c,partsoption.ReturnToFactory__c,'',partsoption.Fail_Code__c,partsoption.Account_Code__c,options));
                }

                system.debug('setpartWrapper else>>>>>>>>>>:'+setpartWrapper);
            }
            System.debug('The listpartWrapper list is>>>>>>>>>:'+setpartWrapper+' displayPopup2>>>>:'+displayPopup2);
            system.debug('errMsgLst--'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                for(partWrapperClass  prtslist:listpartWrapper){
                    //Added as part of the story GSSC-50 - START
                    List<String> tempStr = new List<String>();
                    if(prtslist.failCode != null && prtslist.failCode != '' && prtslist.failCode != 'Select One'){
                        tempStr = prtslist.failCode.split('-'); 
                    }
                    system.debug('prtslist.failCode'+prtslist.failCode);
                    String temp1;
                    if(tempStr.size() > 0){
                        temp1 = tempStr[tempStr.size()-1];
                    }
                    system.debug('temp1'+temp1);
                    String temp = temp1+';;'+prtslist.accountCode;
                    system.debug('temp'+temp);
                    
                    if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                        prtslist.isPartsCovLimitExceed = true;
                    }
                    else{
                        if(errMsgLst != null && errMsgLst.contains(temp)){
                            prtslist.isPartsCovLimitExceedPW = true;
                            prtslist.isPartsCovLimitExceed = true;
                        }
                        else{
                            prtslist.isPartsCovLimitExceed = false;
                            prtslist.isPartsCovLimitExceedPW = false;
                        }
                    }
                    //Added as part of the story GSSC-50 - END
                }
            }
            errMsgLstNew = new List<String>();
            system.debug('errMsgLst-->'+errMsgLst);
            if(errMsgLst != null && errMsgLst.size() > 0){
                for(String err : errMsgLst){
                    if(!err.contains(';;')){
                        errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg+' '+err);
                    }
                    else{
                        List<String> failCodeAccCode = new List<String>();
                        failCodeAccCode = err.split(';;');
                        errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1]);
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('in catch of getallCustomPartsData of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        if(setpartWrapper.size()>0)
        {

            listpartWrapper.addAll(setpartWrapper);
        }
    }
    public PageReference saveCustomParts()
    {
        System.debug('in saveCustomParts GSQ Parts:4');
        Integer count =0;
        system.debug('############inside saveCustomParts##############');
        chkReqField = false;
        ErrorMessage = false;
        DescErrMessage = false;
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();//The User requested parts to be added to Parts options object 

        PageReference pageRef;
        try
        {
            system.debug('count'+count);
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            try
            {
                if(removeIdsMap.keySet().size()>0)
                {
                    deleteParts();
                }
            }
            catch(Exception e) 
            {
                system.debug('Error in Cust Parts Delete Component ## ' + e.getmessage());
            }

            for(partWrapperClass  prtslist:listpartWrapper )
            {
                //Wrapper Structure as below
                //QuantityPart Number *OEM (Product Code)Part NameReturn to Factory% CoveredFail CodeAccount CodeReplacement / Repair ReasonNotes
                System.debug('The listpartWrapper savelist list is>>>>>>>>>:'+listpartWrapper);
                /*validation has been changed from Part Name to Part Number:154235:Rupesh*/
                if(((prtslist.partName!=null && prtslist.partName!='') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.notes!=null && prtslist.notes!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.servPartNumber == '' || prtslist.servPartNumber == null) && isDealer == true)
                    // if(((prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.notes!=null && prtslist.notes!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.servPartNumber == '' || prtslist.servPartNumber == null))
                    //When part no or quantity or notes or oem or fail code or percent or fail code is not select one AND part no is null (Integration failed) then dom not save hence show error
                {
                    ErrorMessage =true;
                    displayPopup2 = true;
                    count=count+1;
                    system.debug(' count'+count);
                    System.debug('inside error displayPopup2:'+displayPopup2);
                    return null;
                }
                //if(((prtslist.partName==null && prtslist.partName=='') || )  && isDealer == false)
if(((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.notes!=null && prtslist.notes!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.partName == '' || prtslist.partName == null) && isDealer == false)
               {
               // if(((prtslist.servPartNumber!=null && prtslist.servPartNumber!='') || (prtslist.quantity!=null && prtslist.quantity!='') || (prtslist.notes!=null && prtslist.notes!='') || (prtslist.oem!=null && prtslist.oem!='') || (prtslist.failCode!=null && prtslist.failCode!='Select One') || (prtslist.coveredPercent!=null && prtslist.coveredPercent!='')) && (prtslist.partName == '' || prtslist.partName == null) && isDealer == false)
                    //When part no or quantity or notes or oem or fail code or percent or fail code is not select one AND part no is null (Integration failed) then dom not save hence show error
                {
                            system.debug('isDealer ' + isDealer);
                            system.debug('prtslist.servPartNumbers ' + prtslist.servPartNumber);
                            system.debug('prtslist.quantitys ' + prtslist.quantity);
                            system.debug('prtslist.notess ' + prtslist.notes);
                            system.debug('prtslist.oem ' + prtslist.oem);
                            system.debug('prtslist.failCode ' + prtslist.failCode);
                            system.debug('prtslist.coveredPercent ' + prtslist.coveredPercent);
                            system.debug('prtslist.partName ' + prtslist.partName);
                            //ErrorMessage =true;
                            displayPopup2 = false;
                            DescErrMessage = true;
                            count=count+1;
                            system.debug(' count'+count);
                            System.debug('inside error displayPopup1:'+displayPopup2);
                            return null;
                        }
               /* else{displayPopup2 = true;
                            DescErrMessage = true;
                            count=count+1;
                            return null;*/
                 }
                      //  }

            }
            System.debug('count count:'+count);
            if(count==0)
            {
                system.debug('inside if count'+count);
                for(partWrapperClass  prtslist:listpartWrapper )
                {
                    system.debug('list listpartWrapper'+listpartWrapper);
                    if((prtslist.servPartNumber==null || prtslist.servPartNumber=='') && (prtslist.quantity==null || prtslist.quantity=='') && (prtslist.notes==null || prtslist.notes=='') && (prtslist.oem==null || prtslist.oem=='') && (prtslist.failCode==null || prtslist.failCode=='Select One') && (prtslist.coveredPercent==null || prtslist.coveredPercent=='') && (prtslist.partName == '' || prtslist.partName == null))
                    {
                        if(prtslist.ids != null && String.valueOf(prtslist.ids).trim() !='')
                        {
                            removeIdsMap.put(prtslist.ids, String.valueOf(prtslist.ids));
                        }
                    }

                    if(prtslist.partName!=null &&  prtslist.partName!='')
                        //if(prtslist.quantity!=null && prtslist.quantity!='')
                    {
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.recordtypeId  = recTypeIdpart;
                        partsoption.Notes__c = prtslist.notes;
                        partsoption.OEM__c = prtslist.oem;
                        if(prtslist.quantity!='' && prtslist.quantity!=null)
                            partsoption.Quantity__c = Decimal.ValueOf(prtslist.quantity);
                        if(prtslist.quantity=='' || prtslist.quantity==null)
                            partsoption.Quantity__c = 0;
                        partsoption.Selected_part__c = prtslist.selectedPart;
                        //Added as per story 152495
                        if(prtslist.replacementReasson=='' || prtslist.replacementReasson == 'Select One'){
                            partsoption.Replacement_Reason__c = 'Refer to Narrative';
                            system.debug('Replacement Reason'+partsoption.Replacement_Reason__c);
                        }
                        else
                        {
                            system.debug('Inside Else');
                            partsoption.Replacement_Reason__c=prtslist.replacementReasson;
                        }

                        partsoption.Part_Name__c = prtslist.partName;
                        partsoption.Part_Description__c = prtslist.partName;
                        partsoption.ReturnToFactory__c = prtslist.returnToFactory;
                        if(prtslist.failCode=='' && prtslist.failCode == 'Select One'){
                            partsoption.Covered__c = null;
                        }else
                        {
                            if(prtslist.coveredPercent!='' && prtslist.coveredPercent!=null)
                                partsoption.Covered__c = Decimal.valueOf(prtslist.coveredPercent);
                            if(prtslist.coveredPercent=='' || prtslist.coveredPercent==null)
                                partsoption.Covered__c = null;
                        }
                        partsoption.Fail_Code__c = prtslist.failCode; 
                        system.debug('RAJESH+partsoption.Fail_Code__c'+partsoption.Fail_Code__c);
                        if(prtslist.failCode=='' || prtslist.failCode == 'Select One'){
                            partsoption.Account_Code__c = 'Select One';

                        } 
                        else
                        {
                            partsoption.Account_Code__c = prtslist.accountCode;

                        }                                                
                        partsoption.Id=prtslist.ids;
                        partsoption.Id=prtslist.idStr;
                        
                        //GSSC-255 START
                        if(prtslist.servPartNumber!= null && prtslist.servPartNumber != '') {
                            partsoption.Service_partnumber__c = prtslist.servPartNumber.toUpperCase();
                        }
                        //partsoption.Service_partnumber__c = prtslist.servPartNumber;
                        //GSSC-255 END
                        
                        partsoption.Parts_Type__c='Custom';
                        partsoption.Service_Job__c = Ins_JobId;
                        selectedCustPartsList.add(partsoption);
                        System.debug('Unique_Parts_Option__c>>>>:'+partsoption.Unique_Parts_Option__c);
                    }
                    //If there is already an error coming on pop up then also do not save and keep he pop up 
                    system.debug('PartNotFoundError>>'+PartNotFoundError);
                    if(PartNotFoundError ==true||PartNoValidationError==true)
                    {
                        displayPopup2 = true;
                        system.debug('There is some validation error on the pop up.');
                        return null;                         
                    }
                }
                System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
                try
                {
                    if(removeIdsMap.keySet().size()>0)
                    {
                        deleteParts();
                    }
                }
                catch(Exception ex) 
                {
                    System.debug('first in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                }
            }
            system.debug('selectedCustPartsList--'+selectedCustPartsList);
            if(selectedCustPartsList.size()>0)
            {

                System.debug('upsert selectedCustPartsList size>>>>:'+selectedCustPartsList.size()+' selectedCustPartsList>>>>:'+selectedCustPartsList);
                displayPopup2 = false;
                List<CSS_Parts_Options__c> partsEPRFlag = new List<CSS_Parts_Options__c>();
                partsEPRFlag = CSS_FN_SIEBEL.getPartsReturn(selectedCustPartsList);
                for(CSS_Parts_Options__c selParts : selectedCustPartsList)
                {
                    //if(selParts.Id != null)
                    //{
                        for(CSS_Parts_Options__c eprParts : partsEPRFlag)
                        {
                            if(selParts.Service_partnumber__c == eprParts.Service_partnumber__c)
                            {
                                selParts.ReturnToFactory__c = eprParts.ReturnToFactory__c;
                                break;
                            }                            
                        }
                    //}
                }
                system.debug('selectedCustPartsList--'+selectedCustPartsList.size());
                CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
                errMsgLst = new Set<String>();
                if(selectedCustPartsList != null && selectedCustPartsList.size() > 0){
                    errMsgLst = contr.covLimitValidation(Ins_JobId, null, selectedCustPartsList, null);
                    errMsgLst.addAll(contr.covLimitValidationJob(Ins_JobId, selectedCustPartsList));  //Added as part of the story GSSC-50
                }
                system.debug('errMsgLst--'+errMsgLst);
                if(errMsgLst != null && errMsgLst.size() > 0){
                    for(partWrapperClass  prtslist:listpartWrapper){
                        //Added as part of the story GSSC-50 - START
                        List<String> tempStr = new List<String>();
                        if(prtslist.failCode != null && prtslist.failCode != '' && prtslist.failCode != 'Select One'){
                            tempStr = prtslist.failCode.split('-'); 
                        }
                        system.debug('prtslist.failCode'+prtslist.failCode);
                        String temp1;
                        if(tempStr.size() > 0){
                            temp1 = tempStr[tempStr.size()-1];
                        }
                        system.debug('temp1'+temp1);
                        String temp = temp1+';;'+prtslist.accountCode;
                        system.debug('temp'+temp);
                        
                        if(errMsgLst != null && errMsgLst.contains(prtslist.accountCode)){
                            prtslist.isPartsCovLimitExceed = true;
                        }
                        else{
                            if(errMsgLst != null && errMsgLst.contains(temp)){
                                prtslist.isPartsCovLimitExceedPW = true;
                                prtslist.isPartsCovLimitExceed = true;
                            }
                            else{
                                prtslist.isPartsCovLimitExceed = false;
                                prtslist.isPartsCovLimitExceedPW = false;
                            }
                        }
                        //Added as part of the story GSSC-50 - END
                    }
                }else{
                    if(selectedCustPartsList != null && selectedCustPartsList.size() > 0){
                        upsert selectedCustPartsList;
                    }
                    getallCustomPartsData(displayPopup2);
                }
            }
            
        }
        catch(Exception ex) 
        {
            System.debug('second in catch of saveCustomParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        pageRef = new PageReference(sDestURL+'id='+Ins_JobId); 
        system.debug('sDestURL' + sDestURL);
        pageRef.setRedirect(true);
        errMsgLstNew = new List<String>();
        system.debug('errMsgLst-->'+errMsgLst);
        if(errMsgLst != null && errMsgLst.size() > 0){
            for(String err : errMsgLst){
                if(!err.contains(';;')){
                    errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg+' '+err);
                }
                else{
                    List<String> failCodeAccCode = new List<String>();
                    failCodeAccCode = err.split(';;');
                    errMsgLstNew.add(Label.CSS_CoverageLimitExceedMsg_PW1+' '+failCodeAccCode[0]+' '+Label.CSS_CoverageLimitExceedMsg_PW2+' '+failCodeAccCode[1]);
                }
            }
            return null;
        }
        else{
            return pageRef;
        }
    }

    public void AddRow()
    {
        try
        {
            System.debug('in AddRow... GSQ Parts:5 listpartWrapper size>>>:'+listpartWrapper.size()+' listpartWrapper>>:'+listpartWrapper);
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            for(integer i=0;i<10;i++){
                    listpartWrapper2.add(new partWrapperClass(listpartWrapper2.size()+i,null,'',null,null,null,null,null,false,null,'',null,null,null));
               }

           listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }
        catch(Exception ex) 
        {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    } 
    public void removingRow()
    {
        PartNotFoundError=false;
        PartNoValidationError=false; 
        System.debug('in removingRow GSQ Parts:6'+assignedParts);
        System.debug('listpartWrapper IN REMOVE ROW'+listpartWrapper);
        try
        {
            //listpartWrapper2 = new List<partWrapperClass>();
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            
            
            for(Integer i=0;i<listpartWrapper2.size();i++){
                System.debug('assignedParts '+assignedParts);
                System.debug('listpartWrapper[i].counting '+listpartWrapper2[i].counting);
                if(listpartWrapper2[i].counting==assignedParts){
                    listpartWrapper2[i].quantity='';
                    listpartWrapper2[i].servPartNumber='';
                    listpartWrapper2[i].partName='';
                    listpartWrapper2[i].oem='';
                    listpartWrapper2[i].returnToFactory='';
                    listpartWrapper2[i].coveredPercent='';
                    listpartWrapper2[i].failCode='';
                    listpartWrapper2[i].accountCode='';
                    listpartWrapper2[i].replacementReasson='Select one';
                    listpartWrapper2[i].notes='';
                    if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                    }
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                }
            }

            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }
        catch(Exception ex) 
        {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }


    }

    public pageReference closePopup2() { 
        system.debug('in Closepopup2 ');
        displayPopup2 = false;
        pageReference ReturnPage = ApexPages.currentPage(); 
        Id id = ReturnPage.getParameters().get('Id');
        Id symid= ReturnPage.getParameters().get('symid');
        Id fcid= ReturnPage.getParameters().get('fcid');
        String rank= ReturnPage.getParameters().get('rank');  
        ReturnPage.getParameters().clear();
        ReturnPage.getParameters().put('Id', id);
        ReturnPage.getParameters().put('fcid', fcid);
        ReturnPage.getParameters().put('rank', rank);
        ReturnPage.getParameters().put('symid', symid);
        ReturnPage.setRedirect(true);
        return ReturnPage ;
    }

    public void closePopup1()
    {    
        getallCustomPartsData(false);
        PartNotFoundError=false;
        PartNoValidationError=false;
        errMsgLstNew = new List<String>();
    }

    public List<SelectOption> getreplacementReasonOptions()    
    {    
        System.debug('in getreplacementReasonOptions GSQ Parts:7');
        List<SelectOption> options =  new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = CSS_Parts_Options__c.Replacement_Reason__c.getDescribe();    
        List<Schema.picklistEntry> ple = fieldResult.getPicklistValues();    
        for(Schema.picklistEntry f:ple)    
        {    
            if(f.getValue()!='GSQ Part')
            options.add(new selectOption(f.getLabel(),f.getValue()));                    
        }    
        return Options;    
    }

    public void deleteParts(){
        System.debug('in deleteParts GSQ Parts:8');
        try{
            List<CSS_Parts_Options__c> toDeleteCustPartsList = new list<CSS_Parts_Options__c>();
            List<CSS_Parts_Options__c> deleteCustPartsList = new List<CSS_Parts_Options__c>([select Id,Notes__c,OEM__c,Replacement_Reason__c,Quantity__c,Selected_part__c,Part_Name__c,Service_partnumber__c,Service_Job__c,Solutions__c
                                                                                             from CSS_Parts_Options__c where Id in:removeIdsMap.keySet()]);
            if(deleteCustPartsList.size()>0){
                for(CSS_Parts_Options__c d: deleteCustPartsList){
                    for(partWrapperClass  prtslist:listpartWrapper ){
                        System.debug('prtslist.servPartNumber'+prtslist.servPartNumber);
                        System.debug('prtslist.servPartNumber'+d.id + '------->'+prtslist.ids);
                        if(d.id==prtslist.ids && prtslist.servPartNumber=='' ){  //why servPartNumber included in if condition?
                            toDeleteCustPartsList.add(d); 
                            System.debug('delete list');}
                        else{
                        }

                    }     
                }
                if(toDeleteCustPartsList.size()>0)
                    delete toDeleteCustPartsList;
            }
            removeIdsMap = new Map<Id, String>();
        }catch(Exception ex) {
            System.debug('in catch of deleteParts of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for getting failcodes codes- 100309
 /*   public List<SelectOption> getfailcodeDropDown()    
    {    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();

        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        system.debug('Test+solsComp'+Ins_JobId+'99');
        solsComp= [SELECT Id, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and FailCode_Formula__c!=null and (((Type__c != 'Campaign' and Type__c != 'ATC' and Type__c != 'TRP') and Selected_Component__c= true) or ((Type__c = 'Campaign' or Type__c = 'ATC' or Type__c = 'TRP') and Performed__c = true))];// Solutions__r.Diagnostic_Response__c='Most likely the solution' and
        options.add(new SelectOption('Select One','Select One'));
        system.debug('Test+solsComp'+solsComp);
        if(solsComp.size()>0){
            for(CSS_Solution_Component__c f:solsComp)  {
                if(f.FailCode_Formula__c!='Select One')
                    sortableSet.add(f.FailCode_Formula__c);
            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                options.add(new selectOption(s,s));                    
            }   
        }
        return Options;    
    }*/
    
     public List<SelectOption> getfailcodeDropDown(){    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        //CSS_Claims__c claimsObj = new CSS_Claims__c();
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        failAccountCodeMap = new  Map<String, Set<String>>();
        system.debug('Test+solsComp'+Ins_JobId+'99');
        //claimsObj = [SELECT Id, CSS_Job__c FROM CSS_Claims__c WHERE Id =: Wid];
        /*if(claimsObj.CSS_Job__c != null){
        solsComp= [SELECT Id, FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
        }
        else{*/
        //solsComp= [SELECT Id, FailCode_Formula__c, Service_Job__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Service_Job__c = null and Type__c NOT IN ('TRP','ATC','Campaign')];    
        if(Ins_JobId !=null){
            //solsComp= [SELECT Id, FailCode_Formula__c, Service_Job__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:Wid and FailCode_Formula__c!=null and Type__c NOT IN ('TRP','ATC','Campaign') and Selected_Component__c= true];    
            //solsComp= [SELECT Id, SysCodeAndCompCode__c, FailCode_Formula__c , CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c  from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and FailCode_Formula__c!=null and Selected_Component__c= true];
            solsComp= [SELECT Id, SysCodeAndCompCode__c, FailCode_Formula__c , CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c  from CSS_Solution_Component__c where  Service_Job__c =:Ins_JobId and ((FailCode_Formula__c!=null  and Selected_Component__c= true AND Root_Cause__c = true AND Type__c  NOT IN ('TRP','ATC','Campaign')) OR (Type__c IN ('Campaign','TRP','ATC') and Performed_Review__c = true))]; //Replaced Performed__c with Performed_Review__c as part of the defect # 190969
            //solsComp= [SELECT Id, SysCodeAndCompCode__c, FailCode_Formula__c , CSS_Claims__c,Type__c,CSS_Account_Formula__c,CoveredPartsQty__c,CampaignPartsPercentage__c,Selected_Component__c  from CSS_Solution_Component__c where CSS_Claims__c =:Wid and ((FailCode_Formula__c!=null  and Selected_Component__c= true AND Type__c  NOT IN ('TRP','ATC','Campaign')) OR (Type__c IN ('Campaign','TRP','ATC')))]; 
        }
        system.debug('solsCompsize***'+solsComp.size()+'**solcomp***'+solsComp);
        options.add(new SelectOption('Select One','Select One'));
        if(solsComp.size()>0){
            Set<string> acCodeSet;
            for(CSS_Solution_Component__c f:solsComp)  {
                if(f.FailCode_Formula__c!='Select One'&& f.SysCodeAndCompCode__c!=null){
                    sortableSet.add(f.FailCode_Formula__c);
                    if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                        system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                        acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);
                        if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                            if(accCodeMapJET != null){
                                string temp = f.CSS_Account_Formula__c.RIGHT(2);
                                CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                                jetSingle = accCodeMapJET.get(temp);
                                if(jetSingle!= null){
                                    coverageType = jetSingle.Attribute1__c;
                                }
                            }
                            system.debug('coverageType***'+coverageType);
                            
                            if(coverageType == 'OTH' || coverageType == 'POL'){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            else{
                                if((f.CSS_Account_Formula__c !='Select One' && f.CoveredPartsQty__c!=null && Integer.valueOf(f.CoveredPartsQty__c) >0 && f.Selected_Component__c== true) || ((coverageType == 'OTH' || coverageType == 'POL') && f.Selected_Component__c== true))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignPartsPercentage__c != null  && Integer.valueOf(f.CampaignPartsPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')) // || (coverageType == 'OTH' || coverageType == 'POL')
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                        }
                        system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                        failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                    }
                    else{
                        system.debug('**insidecontainkey---else');
                        acCodeSet = new Set<string>();
                        if(f.CSS_Account_Formula__c != null){
                            if(accCodeMapJET != null){
                                string temp = f.CSS_Account_Formula__c.RIGHT(2);
                                CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                                jetSingle = accCodeMapJET.get(temp);
                                if(jetSingle!= null){
                                    coverageType = jetSingle.Attribute1__c;
                                }
                            }
                            system.debug('coverageType***'+coverageType);
                            if(coverageType == 'OTH' || coverageType == 'POL'){
                                acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                            else{
                                system.debug('CSS_Account_Formula__c***'+f.CSS_Account_Formula__c);
                                system.debug('CoveredPartsQty__c***'+f.CoveredPartsQty__c);
                                system.debug('CampaignPartsPercentage__c***'+f.CampaignPartsPercentage__c);
                                system.debug('Type__c***'+f.Type__c);
                                if((f.CSS_Account_Formula__c !='Select One' && f.CoveredPartsQty__c!=null && Integer.valueOf(f.CoveredPartsQty__c) >0 && f.Selected_Component__c== true) || ((coverageType == 'OTH' || coverageType == 'POL') && f.Selected_Component__c== true))
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignPartsPercentage__c != null  && Integer.valueOf(f.CampaignPartsPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign')) // || (coverageType == 'OTH' || coverageType == 'POL')
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                            }
                        }
                        system.debug('**sortableSet*'+f.SysCodeAndCompCode__c+'***'+sortableSet);
                        failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                    }


            }
            system.debug('sortableSet  ' +  sortableSet);
            system.debug('failAccountCodeMap***' +  failAccountCodeMap);
            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                options.add(new selectOption(s,s));                    
            }   
        }
        return Options;   
    }
    
    
    
    
    //END
    //Method for getting Account codes
    //RAJESH START
    public css_job_order__c workJob {get;set;}
    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}
    
     public List<SelectOption> fetchAccountCodeDropDown(String selectedFailCode) {
        List<SelectOption> options;
        try{
            system.debug('failAccountCodeMapsize****'+failAccountCodeMap.size());
            system.debug('failAccountCodeMap****'+failAccountCodeMap);
            system.debug('selectedFailCode****'+selectedFailCode);
            String failCode1;
            String[] tempStr;
            if(selectedFailCode.contains('-')){
                tempStr = selectedFailCode.split('-');
                if(tempStr[1].length()>4){
                    failCode1=tempStr[1].LEFT(4);
                }
                else{
                    failCode1=tempStr[1];
                }
            }
            else{
                if(selectedFailCode.length()>4){
                    failCode1=selectedFailCode.LEFT(4);
                }
                else{
                    failCode1=selectedFailCode;
                }
            }
            options =  new List<SelectOption>();
            system.debug('failCode1****'+failCode1);
            system.debug('selectedFailCodecontains****'+failAccountCodeMap.containsKey(failCode1));
            if(selectedFailCode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(failCode1)){
                system.debug('insideFCIFnull***');
                options.add(new SelectOption('Select One','Select One'));
                return options;
            }

            List<string> sortable = new  List<string>();
            
            if(failAccountCodeMap.containsKey(failCode1)){
                system.debug('**insidefailaccMap');
                Set<string> acCodeSet = failAccountCodeMap.get(failCode1);
                if(acCodeSet.size()>0){
                    options.add(new SelectOption('Select One','Select One'));
                    sortable.AddAll(acCodeSet);}
                else{
                    options.add(new SelectOption('Select One','Select One'));
                }
                sortable.sort();
                if (sortable.size()>0){
                    for(String s:sortable){    
                        options.add(new selectOption(s,s));                    
                    }   
                }
            }
            system.debug('***final ac options' + options);
        }catch(Exception ex) {
            System.debug('in catch of getAccountCodeOptionList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }

/* Commented as part of finding nemo sprint new requirement 
    public List<SelectOption> getAccountCodeDropDown() {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        system.debug('Inside getAccountCodeDropDown method');
        try{
            lstAccountCodes = new list<String>();

            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, Type__c, CampaignPartsPercentage__c, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c, Selected_Component__c from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and Selected_Component__c = true and (CSS_Account_Formula__c !='Select One' and CSS_Account_Formula__c !='')];//Type__c NOT IN ('TRP','ATC','Campaign') - removed as part of the story# 169609
            accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Select One','Select One'));
            for(CSS_Solution_Component__c solcmp : SolCmps)
            {
                String coverageType;
                if(solcmp.CSS_Account_Formula__c != null){
                    string temp = solcmp.CSS_Account_Formula__c.substring(0,solcmp.CSS_Account_Formula__c.length()-3);
                    string temp1 = solcmp.CSS_Account_Formula__c.substring(solcmp.CSS_Account_Formula__c.length()-3,solcmp.CSS_Account_Formula__c.length()); 
                    system.debug('temp--->>>>'+temp);
                    system.debug('temp1--->>>>'+temp1);
                    temp1 = temp1.trim();
                    temp = temp.trim();
                    string temp2 = temp + temp1;
                    CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                    jetSingle = accCodeMapJET.get(temp2);
                    if(jetSingle!= null){
                        coverageType = jetSingle.Attribute1__c;
                    }
                }
                system.debug('solcmp'+solcmp);
                system.debug('solcmp.CSS_Account_Formula__c'+solcmp.CSS_Account_Formula__c);
                system.debug('coverageType***'+coverageType);
                
                if(solcmp.Type__c != 'TRP' && solcmp.Type__c !='ATC' && solcmp.Type__c !='Campaign') {
                    if(isDealer != true){

                        sortableSet.add(solcmp.CSS_Account_Formula__c);
                    }
                    else {
                        system.debug('solcmp.CoveredPartsQty__c'+solcmp.CoveredPartsQty__c);
                        if(solcmp.CoveredPartsQty__c != null && solcmp.CoveredPartsQty__c != '' && Double.valueOf(solcmp.CoveredPartsQty__c) >0  || (coverageType != null && coverageType != '') && coverageType == 'OTH' || coverageType == 'POL')
                            sortableSet.add(solcmp.CSS_Account_Formula__c);
                    }
                }
                else{ 
                    if(solcmp.CampaignPartsPercentage__c != null && solcmp.CampaignPartsPercentage__c != '' && Double.valueOf(solcmp.CampaignPartsPercentage__c) >0 || (coverageType != null && coverageType != '') && coverageType == 'OTH' || coverageType == 'POL')
                        sortableSet.add(solcmp.CSS_Account_Formula__c);
                }


            }
            if(sortableSet.size()>0)
            {
                sortable.AddAll(sortableSet);
            }
            sortable.sort();
            if (sortable.size()>0)
            {
                for(String s:sortable)    
                {
                    if(s != null)
                        accCodes.add(new selectOption(s,s));  
                }   
            }
            system.debug('accCodes--'+accCodes);
        }
        catch(Exception ex){
            system.debug('Exception on getAccountCodeDropDown method in CSS_GSQPartsJobPlan class-->' + ex.getmessage() + ex.getLineNumber());

        }
        return accCodes;       

    } */
    public void onChangeofFailCode(){
        system.debug('Method goining inside onChangeofFailCode');
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        String accCode;
        String CoveredPar ='';
          String failCode1;
        String[] tempStr;
        if(selectedFailCode.contains('-')){
            tempStr = selectedFailCode.split('-');
            if(tempStr[1].length()>4){
                system.debug('insideFCIF '+tempStr[1]);
                failCode1=tempStr[1].LEFT(4);
            }
            else{
                failCode1=tempStr[1];
            }
        }
        else{
            failCode1=selectedFailCode;
        }
       
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        
        if(SelectedFailCode!='Select One'){
            
             List<SelectOption> FailCodeRelatedAC=fetchAccountCodeDropDown(failCode1);
            
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,AccountCode__c,CoveredOCAmount__c,
                          AccountCodeType__c,AccountCodeEdit__c,CampaignPartsPercentage__c,Selected_Component__c,Type__c
                          from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and 
                          FailCode_Formula__c = :SelectedFailCode AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('soOne '+SelectedFailCode+''+Ins_JobId);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
           
            if(lstSolComp != null && lstSolComp.size()!=0){
                if(lstSolComp.size() > 1){
                    string acCode;
                    string compAcCode;
                    acCode = lstSolComp[0].CSS_Account_Formula__c;
                    compAcCode = lstSolComp[0].CSS_Account_Formula__c;
                 
                    system.debug('acCode'+acCode);
                    boolean setAcCode = false;
                    for(integer i=0;i<lstSolComp.size();i++ ){
                        if(lstSolComp[0].Id != lstSolComp[i].Id && acCode != lstSolComp[i].CSS_Account_Formula__c){
                            setAcCode = true;
                            break;
                        }
                    }
                    if(setAcCode==true){
                        accCode='Select One';
                        CoveredPar='';
                    }else{
                        accCode=acCode;
                  }
                    
                     
                }
                else{
                    accCode =lstSolComp[0].CSS_Account_Formula__c; 
                 }
                
                String coverageType;
                system.debug('accCodeMapJET-->'+accCodeMapJET);
                if(lstSolComp[0].CSS_Account_Formula__c != null && lstSolComp[0].CSS_Account_Formula__c != '' && lstSolComp[0].CSS_Account_Formula__c != 'Select One'){
                    string temp = lstSolComp[0].CSS_Account_Formula__c.RIGHT(2);
                    CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                    jetSingle = accCodeMapJET.get(temp);
                    if(jetSingle!= null){
                        coverageType = jetSingle.Attribute1__c;
                    }
                }
                system.debug('lstSolComp[0].CoveredPartsQty__c'+lstSolComp[0].CoveredPartsQty__c);
                if((lstSolComp[0].CoveredPartsQty__c!=null && lstSolComp[0].CoveredPartsQty__c!='' && Double.valueOf(lstSolComp[0].CoveredPartsQty__c) >0 && lstSolComp[0].Selected_Component__c== true) || ((coverageType == 'OTH' || coverageType == 'POL') &&  lstSolComp[0].Selected_Component__c== true))
                    CoveredPar =  lstSolComp[0].CoveredPartsQty__c; 
                else if(lstSolComp[0].CampaignPartsPercentage__c != null && lstSolComp[0].CampaignPartsPercentage__c!='' && Double.valueOf(lstSolComp[0].CampaignPartsPercentage__c) >0 && (lstSolComp[0].Type__c == 'TRP'|| lstSolComp[0].Type__c =='ATC'||lstSolComp[0].Type__c =='Campaign') || (coverageType != 'OTH' || coverageType != 'POL'))
                    CoveredPar =  lstSolComp[0].CampaignPartsPercentage__c; 
                //}
            }


            if(CoveredPar!='' && CoveredPar!=null && Double.ValueOf(CoveredPar) > 0 ){
                CoveredPar = '100';
            }
            else if(CoveredPar!='' && CoveredPar!=null && Double.ValueOf(CoveredPar) == 0){
                CoveredPar = '0';

            }
            else{
                CoveredPar = '';
            }
            system.debug('CoveredParts>>>>>>>>>>: '+CoveredPar);


            for(partWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.returnToFactory='';
                    prtslist.accountCode = accCode ;
                    system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                    if(prtslist.accountCode == null || prtslist.accountCode == 'Select One')
                        prtslist.coveredPercent='';
                    else
                        prtslist.coveredPercent=CoveredPar;
                    prtslist.lstFCAC = FailCodeRelatedAC;
                }
            }
        }
        else{
            accCode='Select One';
            CoveredPar='';
            List<SelectOption> options =  new List<SelectOption>();
            options.add(new SelectOption('Select One','Select One'));
            for(partWrapperClass  prtslist:listpartWrapper ){
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.failCode =  String.valueof(SelectedFailCode);
                    prtslist.coveredPercent='';
                    prtslist.accountCode = accCode ;
                    prtslist.lstFCAC = options;
                    prtslist.returnToFactory='';
                }
            } 
        }
    }

    // public integer  SelectedPartID{get;set;}
    public String SelectedAccountCode{get;set;}
    //Method for getting %coverd when we are chaning Account codes as per #105557 (RAJESH)
    public void onChangeofAccountCode(){
        system.debug('Method goining inside onChangeofAccountCode');
        system.debug('SelectedAccountCode>>>>>>>>>>: '+SelectedAccountCode);
        system.debug('SelectedFailCode>>>>>>>>>>: '+SelectedFailCode);
        system.debug('SelectedPartID>>>>>>>>>>: '+SelectedPartID);
        String CoveredParAC ='';
        list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
        if(SelectedAccountCode!='Select One'){
            //lstSolComp1 = [SELECT  Id,CSS_Account_Formula__c,Type__c, CampaignPartsPercentage__c, CoveredPartsQty__c,CoveredOCAmount__c,FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:Ins_JobId and (CSS_Account_Formula__c = :SelectedAccountCode and FailCode_Formula__c = :SelectedFailCode and CSS_Account_Formula__c!='') ];
            //system.debug('lstSolComp1'+lstSolComp1);
            /*if(lstSolComp1!=null && lstSolComp1.size()!=0){
                system.debug('listpartWrapper-->'+listpartWrapper);


                    if(Integer.valueOf(lstSolComp1[0].CoveredPartsQty__c) >0 && lstSolComp1[0].Selected_Component__c== true)
                        CoveredParAC =  lstSolComp1[0].CoveredPartsQty__c; 
                    else if(Integer.valueOf(lstSolComp1[0].CampaignPartsPercentage__c) >0 && (lstSolComp1[0].Type__c == 'TRP'|| lstSolComp1[0].Type__c =='ATC'||lstSolComp1[0].Type__c =='Campaign'))
                        CoveredParAC =  lstSolComp1[0].CampaignPartsPercentage__c; 

                if(CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0 ){
                    CoveredParAC = '100';
                } 
                else{
                    CoveredParAC = '0';
                } 

                for(partWrapperClass  prtslist:listpartWrapper ){
                    if(prtslist.counting == SelectedPartID){
                        prtslist.accountCode =  String.valueof(SelectedAccountCode);
                        prtslist.returnToFactory='';
                        if((prtslist.accountCode == null || prtslist.accountCode == 'Select One') && (prtslist.failCode == null || prtslist.failCode == 'Select One'))
                            prtslist.coveredPercent='';
                        else
                            prtslist.coveredPercent=CoveredParAC;                   
                    }              
                }
            } */
            //else{
            for(partWrapperClass  prtslist:listpartWrapper )
            {
                if(prtslist.counting == SelectedPartID){
                    prtslist.accountCode =  String.valueof(SelectedAccountCode);
                    prtslist.returnToFactory='';
                    /*if(CoveredParAC!='' && Integer.ValueOf(CoveredParAC) > 0 ){
                            CoveredParAC = '100';
                        } 

                        else if(CoveredParAC!='' && Integer.ValueOf(CoveredParAC) == 0){
                            CoveredParAC = '0';

                        }
                        else{
                            CoveredParAC = '';
                        }*/
                    // prtslist.coveredPercent='0';
                    prtslist.coveredPercent='100';
                }    
            }
            //}
        }
        else  
        {
            CoveredParAC='';
            system.debug('else part');
            for(partWrapperClass  prtslist:listpartWrapper )
            {
                if(prtslist.counting == SelectedPartID)
                {
                    prtslist.accountCode =  String.valueof(SelectedAccountCode);
                    prtslist.coveredPercent='';
                    prtslist.returnToFactory='';
                    system.debug('coveredPercent-->'+prtslist.coveredPercent);
                }
            }            
        }
    } 

    public class partWrapperClass 
    {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String quantity {get;set;}
        public String servPartNumber {get;set;}
        public String partName {get;set;}
        public String returnToFactory {get;set;}
        public String coveredPercent {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public String replacementReasson {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public Boolean selectedPart {get;set;}
        public list<SelectOption> lstFCAC{get;set;}
        public Boolean isPartsCovLimitExceed{get;set;}
        public boolean isPartsCovLimitExceedPW{get;set;}  //Added as part of the story GSSC-50
        public partWrapperClass(Integer counting,Id ids,String quantity,String servPartNumber,String partName,String replacementReasson,String notes,String oem,Boolean selectedPart,String returnToFactory,String coveredPercent,String failCode,String accountCode,list<SelectOption> lstFCAC) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.quantity = quantity;
            this.servPartNumber = servPartNumber;
            this.partName = partName;
            this.replacementReasson = replacementReasson;
            this.notes = notes;
            this.oem = oem;
            this.selectedPart = selectedPart;
            this.returnToFactory = returnToFactory;
            this.coveredPercent = coveredPercent;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.lstFCAC = lstFCAC;
            this.isPartsCovLimitExceed = isPartsCovLimitExceed;
            this.isPartsCovLimitExceedPW = isPartsCovLimitExceedPW; //Added as part of the story GSSC-50
        }        
    }
}