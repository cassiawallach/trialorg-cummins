/*
* Block comments with details of changes
*/
public class CG_CL_PartsFromERPController
{
    public id pgId{get;set;}
    public list<CSS_Parts_Options__c> partsList{get; set;}
    public list<partWrapper> lstpartWrapper{get;set;}

    public Boolean isDealer{get;set;}
    public string failcodeSelected{get;set;}
    public string acccodeSelected{get;set;}
    public string partIdSelected{get;set;}
    public Id partRecTypeId;
    //public CSS_Job_Order__c workJob{get;set;}
    boolean flag=false;
    public CG_CL_PartsFromERPController()
    {

        //Dealer Check Code
        isDealer = true;
        String userType = css_utility.getOrgType(UserInfo.getUserId());
        if(userType =='DLR'){
            isDealer = true;   
        }else if(userType == 'DISTR'){
            isDealer = false;   
        }
        system.debug('isDealer**'+isDealer);
        pgId=ApexPages.CurrentPage().getParameters().get('id');//To get the URL Parameter
        system.debug('JobId**'+pgId);
        //lstpartWrapper = new list<partWrapper>();
        GetPartsfromERP();//This function is populating the Parts From ERP Chevron
        solsComp = [select name,action__c,Parts_Warranty__c,FailCode_Formula__c,Component_Id__c,Failure_Date__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,Failure_Measure__c,CSS_Account_Formula__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code__c ,Fail_Code_Editable__c,AccountCodeEdit__c,AccountCode__c,AccountCodeType__c,Authorization_Number__C,Approval_Code__c,Pay_Code__c,CSS_CoverageType__c,
                    Claim_Type__c,Failure_Mode__c,RoadRelay_Warranty__c,CoveredPartsQty__c,System_Code__c,Component_Code__c
                    from CSS_Solution_Component__c where Service_Job__c=:pgId and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
    }
    public void GetPartsfromERP()
    {
        //ID of the record type as there are five reccord types on the Part Options Object
        partRecTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        //Parts Coming from BMS
        partsList = [select Id, Name, Quantity__c, Quantity_Used__c,RecordType.Name,Parts_Type__c,Part_Description__c,Part_Name__c,Sell_Price__c, Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c from CSS_Parts_Options__c where Service_Job__c =: pgId AND RecordTypeId=:partRecTypeId AND PartOC__c IN ('PART','OC','TOW')];

        list<CSS_Parts_Options__c> existpartsList = new list<CSS_Parts_Options__c>();
        list<String> partnumList = new list<string>();//Service Parts numbers in a list
        String FailCode = '';
        String AccCode = '';
        Decimal TotalPrice = 0.00;
        Boolean ExistPart = false;//Why we are taking this variable?? See this variable description below
        lstpartWrapper = new list<partWrapper>();//Instantiation of the Wrapper
        system.debug('PartsList BMS:'+PartsList+'***size::'+PartsList.size());
        if(partsList != null && partsList.size()>0)
        {
            for(CSS_Parts_Options__c part: partsList)
            {
                system.debug('****Parts Number from BMS: ******'+part.Service_partnumber__c);
                if((part.Part_Name__c != null && part.Part_Name__c != '') && part.Part_Name__c.toLowerCase() != 'towing')
                {
                    system.debug('InsideTowing**');
                    partnumList.add(part.Service_partnumber__c);//All the Parts numbers fetched from the BMS list has been added to partsnumlist
                }
            }
            //The query shows parts coming from GUIDANZ
            existpartsList = [select id,ReturnToFactory__c,Service_partnumber__c,Parts_Return__c,Fail_Code__c,Account_Code__c,FailurepartId__c,FailurepartId__r.fail_code__c,FailurepartId__r.FailCode_Formula__c, FailurepartId__r.CSS_Account_Formula__c from CSS_Parts_Options__c where Service_Job__c =: pgId AND Service_partnumber__c IN :partnumList AND recordType.Name != 'BMS Parts'];
            system.debug('PartsList GUIDANZ:'+existpartsList+'***size::'+existpartsList.size());
            for(CSS_Parts_Options__c part: partsList)
            {
                FailCode='';
                AccCode='';
                TotalPrice = 0.00;
                ExistPart = false;
                /*if(existpartsList != null && existpartsList.size()>0)
                {
                    for(CSS_Parts_Options__c epart: existpartsList)
                    {
                        system.debug('****Parts Number from GUIDANZ: ******'+epart.Service_partnumber__c);
                        if(part.Service_partnumber__c == epart.Service_partnumber__c)
                        {
                            //IF (THE PART NO FROM BMS==PART NO FROM GUIDANZ)
                            //THEN RETURN TO FACTORY FIELD=POPULATED FROM GUIDANZ
                            //part.ReturnToFactory__c=epart.ReturnToFactory__c; //Commented by Rajkumar and doing the same in web service itself   //RUPESH STORY# 147375 SIMPSONS SPRINT (Only One line Added)
                            //The below two lines were moved above from else part
                            // AccCode = epart.Account_Code__c;
                            ExistPart = true;//If there exists a part number in BMS matches with the partnumber in the GUIDANZ then make this variable also as true

                            if(epart.Fail_Code__c != null & epart.Fail_Code__c!=''){
                                FailCode = epart.Fail_Code__c;
                                AccCode = epart.Account_Code__c;
                            }
                            else
                            {
                                FailCode=epart.FailurepartId__r.FailCode_Formula__c;
                                AccCode = epart.FailurepartId__r.CSS_Account_Formula__c;
                            }
                            if(part.Warranty_Allocation__c!=null && part.Warranty_Allocation__c==0){
                                AccCode='';

                            }                            
                        }
                    }

                }*/
                system.debug('AccCodeOutside>>>>>>>'+AccCode);
                if(part.Quantity_Used__c == null || part.Quantity_Used__c == '')
                    part.Quantity_Used__c='0';

                //use % Covered in the Total Calculation
                system.debug('part.Covered__c>>>>>>>'+part.Warranty_Allocation__c);
                system.debug('AccCode>>>>>>>'+AccCode);
                if(part.Warranty_Allocation__c!=null && part.Warranty_Allocation__c>0 && AccCode!='' && AccCode!=null){
                    system.debug('part.Covered__c>>>>>>>'+part.Warranty_Allocation__c);
                    system.debug('TotalPrice>>>>>>>'+TotalPrice);
                    TotalPrice=part.Sell_Price__c*integer.valueof(part.Quantity_Used__c)*(part.Warranty_Allocation__c/100);

                }
                if((part.Warranty_Allocation__c!=null && part.Warranty_Allocation__c==0) || AccCode!='' || AccCode!=null ){
                    system.debug('else part.Covered__c>>>>>>>'+part.Warranty_Allocation__c);
                    system.debug('else TotalPrice>>>>>>>'+TotalPrice);
                    TotalPrice=part.Sell_Price__c*integer.valueof(part.Quantity_Used__c);
                }
                //lstpartWrapper.add(new partWrapper(part.id,part.Service_partnumber__c,part.Part_Description__c,integer.valueof(part.Quantity_Used__c),part.ReturnToFactory__c,part.Sell_Price__c,part.Sell_Price__c*integer.valueof(part.Quantity_Used__c),part.Warranty_Allocation__c,FailCode,AccCode,part.Comments__c,ExistPart,part.Part_Name__c,part.Quantity__c,part.Covered__c,accCodes));
                lstpartWrapper.add(new partWrapper(part.id,part.Service_partnumber__c,part.Part_Description__c,integer.valueof(part.Quantity_Used__c),part.ReturnToFactory__c,part.Sell_Price__c,TotalPrice,part.Warranty_Allocation__c,part.Fail_Code__c,part.Account_Code__c,part.Comments__c,ExistPart,part.Part_Name__c,part.Quantity__c,part.Covered__c,accCodes));


            }
        }

    }
    public void saveParts()
    {
        List<CSS_Parts_Options__c> partslist = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partslistToEPR = new List<CSS_Parts_Options__c>();
        system.debug('lstpartWrapperInSAVE****'+lstpartWrapper);
        if(lstpartWrapper!=null && lstpartWrapper.size() > 0)
        {
            for(partWrapper part: lstpartWrapper)
            {
                if(part.partIds!=null)
                {
                    if(part.ExistPart == true){
                        if(part.failcode=='Select One')
                        {
                            part.failcode='';
                        }
                        if(part.accountcode=='Select One')
                        {
                            part.accountcode='';
                        }
                        CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(id=part.partIds,Service_partnumber__c=part.servicePartNumber,Part_Description__c=part.partDesc,Part_Name__c=part.partName ,Quantity__c=part.quantity,Covered__c=part.ODMcovered,
                                                                                 Quantity_Used__c=string.valueof(part.qty),Parts_Return__c=part.returnToFactory,Sell_Price__c=part.SellPrice,
                                                                                 Warranty_Allocation__c=part.covered,Fail_Code__c=part.failCode,Account_Code__c=part.accountcode,Comments__c=part.Comments,RecordTypeId=partRecTypeId);
                        partslist.add(partComp);
                        system.debug('kalpana partComp'+partComp);
                    }

                    else
                    {
                        //If there exists a value in the fail code and the account code..Helped by Kalpana
                        if(part.failcode!='Select One' && part.accountcode!='Select One' && part.ExistPart==false)
                        {
                            CSS_Parts_Options__c partCompEPR = new CSS_Parts_Options__c(id=part.partIds,Service_partnumber__c=part.servicePartNumber,Part_Description__c=part.partDesc,Part_Name__c=part.partName ,Quantity__c=part.quantity,Covered__c=part.ODMcovered,
                                                                                        Quantity_Used__c=string.valueof(part.qty),Parts_Return__c=part.returnToFactory,Sell_Price__c=part.SellPrice,
                                                                                        Warranty_Allocation__c=part.covered,Fail_Code__c=part.failCode,Account_Code__c=part.accountcode,
                                                                                        Comments__c=part.Comments,RecordTypeId=partRecTypeId);
                            partslistToEPR.add(partCompEPR);
                        }
                        else
                        {
                            if(part.failcode=='Select One')
                            {
                                part.failcode='';
                            }
                            if(part.accountcode=='Select One')
                            {
                                part.accountcode='';
                            }
                            CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(id=part.partIds,Service_partnumber__c=part.servicePartNumber,Part_Description__c=part.partDesc,Part_Name__c=part.partName ,Quantity__c=part.quantity,Covered__c=part.ODMcovered,
                                                                                     Quantity_Used__c=string.valueof(part.qty),Parts_Return__c=part.returnToFactory,Sell_Price__c=part.SellPrice,
                                                                                     Warranty_Allocation__c=part.covered,Fail_Code__c=part.failCode,Account_Code__c=part.accountcode,Comments__c=part.Comments,RecordTypeId=partRecTypeId);
                            partslist.add(partComp);

                        }
                    }
                } 
            }
        }

        //Call the EPR service(getPartReturn)
        list<CSS_Parts_Options__c> EprReturnedPartlist;
        if(partslistToEPR != null && partslistToEPR.size() > 0)
            EprReturnedPartlist=CSS_FN_SIEBEL.getPartsReturn(partslistToEPR);

        if(EprReturnedPartlist != null && EprReturnedPartlist.size() >0){
            system.debug('***Parts Returned***'+EprReturnedPartlist);
            for(partWrapper part: lstpartWrapper)
            {
                for (CSS_Parts_Options__c epart:EprReturnedPartlist)
                {
                    if(part.partIds!=null)
                    {
                        if(part.partIds == epart.id)
                        {
                            part.returnToFactory=epart.ReturnToFactory__c;
                            CSS_Parts_Options__c partComp2 = new CSS_Parts_Options__c(id=part.partIds,Service_partnumber__c=part.servicePartNumber,Part_Description__c=part.partDesc,
                                                                                      Quantity_Used__c=string.valueof(part.qty),ReturnToFactory__c=part.returnToFactory,Sell_Price__c=part.SellPrice,
                                                                                      Warranty_Allocation__c=part.covered,Fail_Code__c=part.failCode,Account_Code__c=part.accountcode,Comments__c=part.Comments,RecordTypeId=partRecTypeId);
                            partslist.add(partComp2);
                        }
                        if(part.failcode=='Select One')
                        {
                            part.failcode='';
                        }
                        if(part.accountcode=='Select One')
                        {
                            part.accountcode='';
                        }

                    }

                    system.debug('Return to Factory from the Service:'+part.returnToFactory);
                }

            } 

        }

        //Call ODM Service 


        system.debug('before calling ODM service:'+solsComp+'**partslist***'+partslist);
        boolean partsValidation = CG_BL_ODM.callODMPartsValidationService(workJob,null,null,'JOB',solsComp,partslist,false); 
        system.debug('partsValidation****'+partsValidation);
        system.debug('partslist****'+partslist);
        if(partslist!=null && partslist.size()>0)
            update partslist;


    }
    public List<SelectOption> options{get;set;}
    public List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
    public List<CSS_Solution_Component__c> solsCompFC = new List<CSS_Solution_Component__c>(); //Declared another variable, sothat the ODM process will not be affected.Only used for getfailcodes method
    //Method for display the fail codes from UI side 
    public List<SelectOption> getfailcodes()    
    {    
        system.debug('Inside FailCodes**');
        options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();

        //solsComp= [SELECT Id, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:pgid and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
        solsCompFC= [SELECT Id, FailCode_Formula__c,Parts_Warranty__c from CSS_Solution_Component__c where Service_Job__c =:pgid and FailCode_Formula__c!=null and ((Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true and Type__c NOT IN ('Campaign','TRP','ATC')) OR (Type__c IN ('Campaign','TRP','ATC') and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))))];
        system.debug('solComp**'+solsCompFC);
        options.add(new SelectOption('Select One','Select One'));
        system.debug('Test+solsComp'+solsCompFC);
        if(solsComp.size()>0){
            for(CSS_Solution_Component__c f:solsCompFC)  {
                if(f.FailCode_Formula__c!='Select One')
                    sortableSet.add(f.FailCode_Formula__c);

                system.debug('sortableSet  ' +  sortableSet);


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
    //Logic for account Code dispaly 

    public css_job_order__c workJob {get;set;}
    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public list<CSS_JobEventTemporary__c> jobEventTemp {get;set;}


    public List<SelectOption> getAccountCodes() {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        system.debug('Inside acc method');
        try{
            lstAccountCodes = new list<String>();

            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            //List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:pgid];
            system.debug('Creator_Location__c'+workJob.Creator_Location__c);
            Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;

            system.debug('orgtype--->'+orgtype);
            //system.debug('Regionterritory--->'+Regionterritory.Region__c);
            system.debug('userRole--->'+userRole);

            if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE')) 
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{ 
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }

            if(jobEventTemp.size() > 0)
            {
                system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                system.debug('jobEventTempData-->'+jobEventTemp);
                accCodes = new List<SelectOption>();
                accCodes.add(new SelectOption('Select One','Select One'));
                for(CSS_JobEventTemporary__c j : jobEventTemp){
                    string s = j.Attribute2__c+' '+ j.Attribute3__c;

                    sortableSet.add(s); //Ed
                    // accCodes.add(new SelectOption(s,s));
                    //lstAccountCodes.add(j.Attribute2__c);
                    //lstAccountCodes.add(s);
                }
            }
            for(CSS_Solution_Component__c solcmp : solsComp){
                /*if(solcmp.AccountCode__c !=null &&  solcmp.AccountCode__c != '')
sortableSet.add(solcmp.AccountCode__c);
if(solcmp.AccountCodeEdit__c !=null &&  solcmp.AccountCodeEdit__c != '')
sortableSet.add(solcmp.AccountCodeEdit__c); */
                if(solcmp.CSS_Account_Formula__c !=null)
                    sortableSet.add(solcmp.CSS_Account_Formula__c);
            }
            system.debug('sortableSet'+ sortableSet);
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);}
            sortable.sort();
            if (sortable.size()>0){
                for(String s:sortable)    
                {accCodes.add(new selectOption(s,s));  }   
            }
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }
        return accCodes;       

    }
    public void FailCodeChange(){
        // try {
        system.debug('InsideFailcoddechange**');
        system.debug('failcodeSelected**'+failcodeSelected);
        system.debug('partIdSelected**'+partIdSelected);
        accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption('Select One','Select One'));
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(failcodeSelected!='Select One'){
            //lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c from CSS_Solution_Component__c where Service_Job__c =:wid and FailCode_Formula__c = :SelectedFailCode and AccountCodeEdit__c!=''];
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:pgid and FailCode_Formula__c = :failcodeSelected and CSS_Account_Formula__c!='']; // AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            // system.debug('lstSolCompsize'+lstSolComp[0].CSS_Account_Formula__c);
            if(lstSolComp != null && lstSolComp.size()!=0){
                for(CSS_Solution_Component__c solComp: lstSolComp){
                    system.debug('SolComp loop**'+solComp.CSS_Account_Formula__c);
                    if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null)
                        sortableSet.add(solComp.CSS_Account_Formula__c);
                    system.debug('lstpartWrapper**'+lstpartWrapper);
                    if(lstpartWrapper!=null){
                        for(PartWrapper  prtslist:lstpartWrapper ){
                            system.debug('partIdSelected**'+partIdSelected);
                            system.debug('prtslist.partIds**'+prtslist.partIds);
                            if(prtslist.partIds == partIdSelected)
                            {
                                system.debug('Inside PartID IF**'+partIdSelected);
                                prtslist.failCode =  String.valueof(failcodeSelected);
                                if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null ){
                                    //prtslist.accountCode = solComp.CSS_Account_Formula__c;
                                    if(prtslist.covered>0){
                                        prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty*(prtslist.covered/100);
                                        prtslist.accountCode = solComp.CSS_Account_Formula__c;}
                                    else{
                                        prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty;
                                        prtslist.accountCode = '';
                                    }
                                }
                                else{
                                    prtslist.accountCode = '';
                                    prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty;

                                }
                                system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                            }
                        }
                    }

                }
                system.debug('sortableSet'+ sortableSet);
                if(sortableSet.size()>0){
                    sortable.AddAll(sortableSet);}
                else{
                    lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:pgid]; // AND CSS_Account_Formula__c!=''];
                    system.debug('lstSolCompELSE**'+lstSolComp);
                    if(lstSolComp != null && lstSolComp.size()!=0){
                        for(CSS_Solution_Component__c solComp: lstSolComp){
                            system.debug('SolComp loop2**'+solComp.CSS_Account_Formula__c);
                            if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null)
                                sortableSet.add(solComp.CSS_Account_Formula__c);
                        }
                    }
                    if(sortableSet.size()>0){
                        sortable.AddAll(sortableSet);}
                    system.debug('ELSESortableSet**'+sortableSet);
                }
                sortable.sort();
                system.debug('sortable'+ sortable);
                if (sortable.size()>0){
                    for(String s:sortable)    
                    {
                        accCodes.add(new selectOption(s,s));  }   

                }

                if(lstpartWrapper!=null){
                    for(PartWrapper  prtslist:lstpartWrapper ){

                        if(prtslist.partIds == partIdSelected)
                        {
                            prtslist.accCodes = accCodes;


                        }
                        system.debug('failcodeSelectd'+failcodeSelected);
                        system.debug('prtslist.accCodes'+prtslist.accCodes);
                    }

                }

                system.debug('accCodes**'+accCodes);
                system.debug('failcodeSelectd'+failcodeSelected);
                // }
                /*  }
catch(Exception ex){
system.debug('Exception on OnchangeofFailCode method -->' + ex.getmessage() + ex.getLineNumber());

}*/
            }
        }
        else{
            if(lstpartWrapper!=null){
                for(PartWrapper  prtslist:lstpartWrapper ){
                    if(prtslist.partIds == partIdSelected)
                    {
                        prtslist.failCode = '';
                        prtslist.accountCode = '';
                        break;
                    }
                }
            }
        }
    }
    public void onaccCodechange(){
        system.debug('Inside accOcdeMethod**'+acccodeSelected);
        system.debug('Inside accOcdeMethod**'+failcodeSelected);
        accCodes = new List<SelectOption>();
        accCodes.add(new SelectOption(acccodeSelected,acccodeSelected));
        accCodes.add(new SelectOption('Select One','Select One'));
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
        if(acccodeSelected != 'SelectOne'){
            /*  if(lstpartWrapper!=null){
for(PartWrapper  prtslist:lstpartWrapper ){

if(prtslist.partIds == partIdSelected)
{
system.debug('Inside PartID IF**'+partIdSelected);
// prtslist.failCode =  String.valueof(failcodeSelected);
// prtslist.coveredPercent = String.valueof(CoveredPar);

prtslist.accountCode = acccodeSelected;
system.debug('prtslist.accountCode-->'+prtslist.accountCode);
}
}
}*/
            lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:pgid and FailCode_Formula__c = :failcodeSelected]; // AND CSS_Account_Formula__c!=''];
            system.debug('lstSolComp'+lstSolComp);
            system.debug('lstSolCompSize'+ ' ' + lstSolComp.size());
            // system.debug('lstSolCompsize'+lstSolComp[0].CSS_Account_Formula__c);
            if(lstSolComp != null && lstSolComp.size()!=0){
                for(CSS_Solution_Component__c solComp: lstSolComp){
                    system.debug('SolComp loop**'+solComp.CSS_Account_Formula__c);
                    if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null)
                        sortableSet.add(solComp.CSS_Account_Formula__c);
                    system.debug('lstpartWrapper**'+lstpartWrapper);
                    if(lstpartWrapper!=null){
                        for(PartWrapper  prtslist:lstpartWrapper ){

                            if(prtslist.partIds == partIdSelected)
                            {
                                system.debug('Inside PartID IF**'+partIdSelected);
                                prtslist.failCode =  String.valueof(failcodeSelected);
                                if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null){
                                    prtslist.accountCode = solComp.CSS_Account_Formula__c;

                                    if(prtslist.covered>0)
                                        prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty*(prtslist.covered/100);
                                    else
                                        prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty;
                                }
                                else{
                                    prtslist.accountCode = '';
                                    prtslist.TotalPrice=prtslist.SellPrice*prtslist.qty;

                                }
                                system.debug('prtslist.accountCode-->'+prtslist.accountCode);
                            }
                        }
                    }

                }
                system.debug('sortableSet'+ sortableSet);
                if(sortableSet.size()>0){
                    sortable.AddAll(sortableSet);}
                else{
                    lstSolComp = [SELECT  Id,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c from CSS_Solution_Component__c where Service_Job__c =:pgid]; // AND CSS_Account_Formula__c!=''];
                    system.debug('lstSolCompELSE**'+lstSolComp);
                    if(lstSolComp != null && lstSolComp.size()!=0){
                        for(CSS_Solution_Component__c solComp: lstSolComp){
                            system.debug('SolComp loop2**'+solComp.CSS_Account_Formula__c);
                            if(solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c != null)
                                sortableSet.add(solComp.CSS_Account_Formula__c);
                        }
                    }
                    if(sortableSet.size()>0){
                        sortable.AddAll(sortableSet);}
                    system.debug('ELSESortableSet**'+sortableSet);
                }
                sortable.sort();
                system.debug('sortable'+ sortable);
                if (sortable.size()>0){
                    for(String s:sortable)    
                    {
                        accCodes.add(new selectOption(s,s));  }   

                    //}
                    /*else
accCodes.add(new selectOption(sortable[0],sortable[0])); */  
                    if(lstpartWrapper!=null){
                        for(PartWrapper  prtslist:lstpartWrapper ){

                            if(prtslist.partIds == partIdSelected)
                            {
                                prtslist.accCodes = accCodes;
                            }
                            system.debug('failcodeSelectd'+failcodeSelected);
                            system.debug('prtslist.accCodes'+prtslist.accCodes);
                        }

                    }

                    system.debug('accCodes**'+accCodes);
                    system.debug('failcodeSelectd'+failcodeSelected);
                }
                /*  }
catch(Exception ex){
system.debug('Exception on OnchangeofFailCode method -->' + ex.getmessage() + ex.getLineNumber());

}*/
            }
        }

    }        
    public class PartWrapper
    {

        public Id partIds {get;set;}
        public string partName;
        public Decimal quantity;
        public Decimal ODMcovered;
        public string servicePartNumber {get;set;}
        public string partDesc {get;set;}
        public integer qty {get;set;}
        public string returnToFactory {get;set;}
        public Decimal SellPrice {get;set;}
        public Decimal TotalPrice {get;set;}
        public Decimal covered {get;set;}
        public String failCode {get;set;}
        public string accountCode {get;set;}
        public String Comments {get;set;}
        public Boolean ExistPart {get;set;}
        public List<selectOption> accCodes {get;set;}
        public PartWrapper(Id partIds,string servicePartNumber,string partDesc,integer qty,string returnToFactory,Decimal SellPrice,Decimal TotalPrice,Decimal covered,String failCode,String accountCode,String comments,Boolean ExistPart,string partName,Decimal quantity,Decimal ODMcovered,List<selectOption> accCodes){

            this.partIds=partIds;
            /*this.partName=partName;
            this.quantity=quantity;
            this.ODMcovered=ODMcovered; */
            this.servicePartNumber = servicePartNumber;
            this.partDesc = partDesc;
            this.qty = qty;
            this.returnToFactory = returnToFactory;
            this.SellPrice = SellPrice;
            this.TotalPrice = TotalPrice;
            this.covered = covered;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.Comments = Comments;
            this.ExistPart = ExistPart;
            this.accCodes = accCodes;
            //System.debug('PartWrapper==='+CG_CL_PartsFromERPController.PartWrapper.partIds);
        }
    }
}