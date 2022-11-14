public class css_warranty {
    
    // global variables
    public transient id pgId;
    public CSS_Job_Order__c servicejob{get;set;}
    
    Public transient String selectedAppCode {get;set;}
    //Added by shanthi
    public transient String myBase64String {get;set;}
    public transient boolean reqWrAppBoolean{get;set;}
    public transient boolean reqWrRegBoolean{get;set;}
    public transient boolean reqWrTerBoolean{get;set;}
    public transient boolean reqWrWarBoolean{get;set;}
    public transient boolean reqWrEsnBoolean{get;set;}
    public string mil_measure{get; set;}
    public transient string defValue{get; set;}
    public transient string MileageKmVal{get; set;}
    public string prevmil_measure;
    public transient string applicationCode;
    public transient boolean reqWrcoverBoolean{get;set;}
    public transient boolean reqWrcertBoolean{get;set;}
    public transient boolean showWarrDetailsSection{get;set;}
    Public transient String pagName{get;set { pagName= value;
                                             system.debug('pagName4444'+pagName);
                                             
                                            }}
    
    public map<string,map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>> coverageByDefTypeMap{get;set;}
    public transient map<string,string> coverageURLProceMap{get;set;}
    public transient DateTime warrentyStartD { get; set; }
    public transient Integer  coverageMaxMonth { get; set; }
    public Map<String,string> milesHolder = new Map<String,string>();//
    //start story 76192
    public transient string sessionlocationChangeValue{get;set;}
    //end story 76192
    public String EmmisionWarrantyDedutibles{get; set;}
    public String ExtendedWarrantyDedutibles{get; set;}
    public String ReconWarrantyDedutibles{get; set;}
    public String NewEngWarrantyDedutibles{get; set;}
    
    public Boolean NewEngWarrantyDedutiblesFlag{get; set;}
    public Boolean EmmisionWarrantyDedutiblesFlag{get; set;}
    public Boolean ExtendedWarrantyDedutiblesFlag{get; set;}
    public Boolean ReconWarrantyDedutiblesFlag{get; set;}
    
    public css_warranty(){                
        pgId = ApexPages.CurrentPage().getParameters().get('id');
        serviceJob = new CSS_Job_Order__c();
        system.debug('pgId>>>>>>>>>>>>>>>>>'+pgId);
        showWarrDetailsSection = true;
        NewEngWarrantyDedutiblesFlag = false;
        EmmisionWarrantyDedutiblesFlag = false;
        ExtendedWarrantyDedutiblesFlag = false;
        ReconWarrantyDedutiblesFlag = false;
        if (pgId!= null){            
            SOQLServicejob();
            sessionlocationChangeValue=(string)Cache.Session.get('warrantyLocationChangeKey');
            if(sessionlocationChangeValue != null && sessionlocationChangeValue != ''){
                clearWarantyFields();
                Cache.Session.remove('warrantyLocationChangeKey');
            }
            system.debug('Before Region Method ESN>>>>>>>>>>>>>>>>>>>>>'+serviceJob.ESN__c);
            /***** Calling the Region and Territory method to update the values from Siebel service based on user Location *****/
            if((serviceJob.Region__c == null || serviceJob.Region__c == '') && (serviceJob.Territory__c == null || serviceJob.Territory__c == ''))
                regionTerritory();
            system.debug('After Region Method ESN>>>>>>>>>>>>>>>>>>>>>'+serviceJob.ESN__c);
            system.debug('ED  MileageKmVal>>>>>>>>>>>>>>>>>>>>>'+MileageKmVal);
            SelectedAppCode = serviceJob.Application_Desc__c;            
            defValue = serviceJob.Mileage_Measure__c;   
            mil_measure = 'Miles'; 
            
            
            
            loadBasicData();
        }else{
            
            regionTerritory();
            
        }
    }
    
    public void SOQLServicejob(){
        serviceJob = [Select id,Region__c,Territory__c,Warranty_Start_Date__c, ReconEngineFlag__c, Application_Desc__c,Application__c, Mileage__c, ESN__c,Mileage_Measure__c, CSS_Hours__c, CoverageResponse__c,EditCoverage__c,BMSStatus__C,Creator_Location__c,CSS_Job_Location_Code__c,Account__r.Region__c,Account__r.Territory__c,Account__r.Type from CSS_Job_Order__c where id= :pgId];
        System.debug('Warranty Start Date is '+serviceJob.Warranty_Start_Date__c);
    }
    
    public void regionTerritory(){
        try{
            /****** Calling the Utility Method to query region and territory values from Account based on user Location ******/
            if(serviceJob == null){
                transient Account RegionTerritory = css_utility.getRegionTerritory('');
                serviceJob.Region__c = RegionTerritory.Region__c;
                serviceJob.Territory__c = RegionTerritory.Territory__c;
            }else{
                serviceJob.Region__c = serviceJob.Account__r.Region__c;
                serviceJob.Territory__c = serviceJob.Account__r.Territory__c;
            }        
        }catch(exception e){
            system.debug('Entered into catch of Region Territory method in css_warranty>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public void loadBasicData(){
        //              if(pagName != null && pagName != ''){
        
        //            if(pagName.equalsIgnoreCase('TND') || pagName.equalsIgnoreCase('REPAIR')){
        try{
            if(serviceJob != null){
                
                if(serviceJob.CoverageResponse__c != null && serviceJob.CoverageResponse__c != ''){
                    basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                    basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(serviceJob.CoverageResponse__c,CSS_getBasicCoverageResponseJ2A.class); 
                    system.debug('basicCoverageDetails coverage resp'+basicCoverageDetails.Header);
                    system.debug('basicCoverageDetails>>>>>>'+basicCoverageDetails);
                    //Building map mapGroupCoverageByDefType
                    mapGroupCoverageByDefType=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    mapGroupCoverageByDefTypeNewENG=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    mapGroupCoverageByDefTypeRecEng=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    coverageByDefTypeMap = new map<string,map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>>(); 
                    coverageURLProceMap = new map<string,string>();
                    reqWrcoverBoolean = true;
                    for(CSS_getBasicCoverageResponseJ2A.coverageDetails c : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails){
                        system.debug('c.CoverageType>>>>>>'+c.CoverageType);
                        //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                        if(c.CoverageType =='EMS-Emissions Warranty'){
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('EMS-Emissions Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                            //iterating the CoverageComponentList
                            for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                //calculating miles
                                if(mil_measure != null && mil_measure != ''){
                                    if(mil_measure.equalsIgnoreCase('Kilometers')){
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                    }                                
                                }
                                
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                //populating the map 
                                if(!mapGroupCoverageByDefType.containskey(ccl.CoverageDefenitionType)){
                                    
                                    mapGroupCoverageByDefType.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                }
                                mapGroupCoverageByDefType.get(ccl.CoverageDefenitionType).add(ccl);
                            }//end of inner 1 loop
                            
                            // S-205 Start
                            for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                
                                if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                {
                                    EmmisionWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                }
                                
                                else {
                                    if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                        EmmisionWarrantyDedutibles = cd.FirstVisitAmt;
                                }
                                if(EmmisionWarrantyDedutibles == null || EmmisionWarrantyDedutibles == '')
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                }
                                
                            }
                            if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                            {
                                EmmisionWarrantyDedutiblesFlag = true;
                                system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                            }
                            // S-205 END
                            
                        }//end of If cond
                        system.debug('mapGroupCoverageByDefType>>>>*******'+mapGroupCoverageByDefType);
                        //if the coverage type is of NEW-New Engine Warranty
                        if(c.CoverageType =='NEW-New Engine Warranty'){
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('NEW-New Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck'+c.CoverageType);
                            for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                //calculating miles
                                if(mil_measure != null && mil_measure != ''){
                                    if(mil_measure.equalsIgnoreCase('Kilometers')){
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                    }                                
                                }
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                
                                
                                //populating the map 
                                if(!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageDefenitionType)){
                                    
                                    mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                }
                                mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageDefenitionType).add(ccl);
                            }//end of inner 2 loop
                            
                            // S-205 Start
                            for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                
                                if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                {
                                    NewEngWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                }
                                
                                else {
                                    if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                        NewEngWarrantyDedutibles = cd.FirstVisitAmt;
                                }
                                if(NewEngWarrantyDedutibles == null || NewEngWarrantyDedutibles == '')
                                {
                                    NewEngWarrantyDedutiblesFlag = true;
                                }
                                
                            }
                            if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                            {
                                NewEngWarrantyDedutiblesFlag = true;
                                system.debug('EmmisionWarrantyDedutiblesFlag1***'+NewEngWarrantyDedutiblesFlag);
                            }
                            // S-205 END
                        }//end of if cond
                        system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******'+mapGroupCoverageByDefTypeNewENG);
                        
                        //Code for Recon Engine Warranty Coverage Start
                        
                        if(c.CoverageType =='REW-Recon Engine Warranty'){
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('REW-Recon Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck'+c.CoverageType);
                            for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                //calculating miles
                                if(mil_measure != null && mil_measure != ''){
                                    if(mil_measure.equalsIgnoreCase('Kilometers')){
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                    }                                
                                }
                                
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                
                                //populating the map 
                                if(!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageDefenitionType)){
                                    
                                    mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                }
                                mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageDefenitionType).add(ccl);
                            }//end of inner 2 loop
                            
                            // S-205 Start
                            for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                
                                if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                {
                                    ReconWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                }
                                
                                else {
                                    if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                        ReconWarrantyDedutibles = cd.FirstVisitAmt;
                                }
                                
                                if(ReconWarrantyDedutibles == null || ReconWarrantyDedutibles == '')
                                {
                                    ReconWarrantyDedutiblesFlag = true;
                                }
                                
                            }
                            if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                            {
                                ReconWarrantyDedutiblesFlag = true;
                                system.debug('EmmisionWarrantyDedutiblesFlag1***'+ReconWarrantyDedutiblesFlag);
                            }
                            // S-205 END
                            
                        }//end of if cond
                        
                        //Code for Recon Engine warranty Coverage End
                        
                    }//end of outer for loop
                    
                    if(mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()){
                        coverageByDefTypeMap.put('NEW-New Engine Warranty',mapGroupCoverageByDefTypeNewENG);
                    }
                    
                    if(mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()){
                        coverageByDefTypeMap.put('REW-Recon Engine Warranty',mapGroupCoverageByDefTypeRecEng);
                    }
                    
                    if(mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()){
                        coverageByDefTypeMap.put('EMS-Emissions Warranty',mapGroupCoverageByDefType);
                    }
                    
                    system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
                    // Certificate details -- start
                    listcertificatedetails = new list<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
                    if(basicCoverageDetails != null){
                        reqWrcertBoolean = false;
                        for(CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails)
                        {
                            listcertificatedetails.add(crtdt);
                            system.debug('Certificate list'+listcertificatedetails);
                            if (mil_measure != null && mil_measure != '') {
                                if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                    milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                                    milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                                    crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles) / 0.621371).setScale(0));
                                    crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) / 0.621371).setScale(0));
                                }
                            }
                            
                            if(mil_measure != null && mil_measure != ''){
                                if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                    milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                                    milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                                }
                            }
                            // S-205 Start
                            String ProgramId = crtdt.ProgramID;
                            Map<string,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>> listofdeduct = new Map<String,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>>();
                            for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ExtendedCovDedutibles: crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles){
                                
                                system.debug('ExtendedCovDedutibles'+ExtendedCovDedutibles);
                                listofdeduct.put(ExtendedCovDedutibles.ProgramID,crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles);
                                system.debug('listofdeduct'+listofdeduct+'ProgramId'+ProgramId);
                                //listofdeduct.get(ProgramId);
                                //system.debug('Test**1'+listofdeduct);
                                
                            } 
                             if(listofdeduct!=null && listofdeduct.size()>0){
                             for(CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ld: listofdeduct.get(ProgramId))
                                    {
                                    system.debug('testprofid'+ProgramId);
                                    system.debug('testprofid2'+ld.ProgramID);
                                    if(ld.ProgramID == ProgramId)
                                    {
                                    if(ld.ConstantDecutibleAmt !=null && ld.ConstantDecutibleAmt !='' && ld.ConstantDecutibleAmt !='0')
                                    {
                                    ExtendedWarrantyDedutibles = ld.ConstantDecutibleAmt;
                                    }
                                    
                                    else {
                                    if (ld.FirstVisitAmt !=null && ld.FirstVisitAmt !='' && ld.FirstVisitAmt !='0')
                                    ExtendedWarrantyDedutibles = ld.FirstVisitAmt;
                                    }
                                    if(ExtendedWarrantyDedutibles == null || ExtendedWarrantyDedutibles == '')
                                    {
                                    ExtendedWarrantyDedutiblesFlag = true;
                                    }
                                    break;
                                    
                                    }
                                    
                                    }
                             }
                            //S-205 END
                            //  listcertificatedetails.add(crtdt);  
                            
                            
                        }
                    }
                    if(listcertificatedetails.isEmpty())
                        reqWrcertBoolean = true;
                    system.debug('certificate details'+listcertificatedetails);
                    // Certificate details -- end
                    
                }
                reqWrTerBoolean=false;
            }
            system.debug('basicCoverageDetails11>>>>>>'+basicCoverageDetails);
            //              }
            //          }     
        } catch(exception e){}
    }   
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        /*  if(show_wr_pnl){
options.add(new SelectOption('Miles',system.Label.CSS_Miles));
options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
} */
        
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        
        
        return options;
    }
    
    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public map<string,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefType{get;set;}
    public map<string,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG{get;set;}
    public map<string,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeRecEng{get;set;}
    public transient list<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public transient string coverageDetailsSTR;
    public transient string coverageDetailsSTR2;
    // basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails
    //Stroy 63178
    public pagereference coveragesearch()
    {
        try{
            coverageDetailsSTR = ''; coverageDetailsSTR2 = '';
            system.debug('AppCode***'+SelectedAppCode);
            if(SelectedAppCode==null || SelectedAppCode=='' || SelectedAppCode=='--None--'){
                reqWrAppBoolean=true;
                return null;
            } else { reqWrAppBoolean=false; }  
            if (serviceJob.Warranty_Start_Date__c == null){
                reqWrWarBoolean=true;
                return null;
            } else { reqWrWarBoolean=false; } 
            if (serviceJob.ESN__c == null || serviceJob.ESN__c == ''){
                reqWrEsnBoolean=true;
                return null;
            } else { reqWrEsnBoolean=false; }
            
            if (serviceJob.Region__c==null || serviceJob.Region__c=='' || serviceJob.Region__c=='--None--'){
                reqWrRegBoolean=true;
                return null;
            } else { reqWrRegBoolean=false; } 
            
            if (serviceJob.Territory__c==null || serviceJob.Territory__c=='' || serviceJob.Territory__c=='--None--'){
                system.debug('checking the boolean value');
                reqWrTerBoolean=true;
                return null;
            } else { 
                system.debug('Inside');
                //mil_measure = 'Miles';
                
                transient CSS_getBasicCoverageReqJ2A getBasicCoverageReq = new CSS_getBasicCoverageReqJ2A();
                transient CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                if(serviceJob!= null){
                    reqDA.ESN = serviceJob.ESN__c;
                    reqDA.Region = serviceJob.Region__c;
                    reqDA.Territory = serviceJob.Territory__c;
                    reqDA.JObId = servicejob.id;
                    system.debug('SelectedAppCode******>>>>'+SelectedAppCode);
                    //We are able to call web service when we specify code but Css utility is not returning the code gives exception though values are passed correctly.
                    applicationCode = css_utility.getCodes('Application Code',SelectedAppCode,null,null);
                    system.debug('apllication code'+applicationCode);
                    reqDA.EngineApplicationCode = applicationCode;//'130';// Please call CSS_Utility.getCodes() 
                    Date d = serviceJob.Warranty_Start_Date__c;
                    string warantySDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/d/YYYY');
                    reqDA.WarrantyStartDate = warantySDate;//'5/1/2010';//String.Valueof(workJob.Warranty_Start_Date__c);
                    // Sai:10/26 : Included > 0 condition in the below IF to check for a valid vlaue.
                    if(serviceJob.Mileage__c != null && Integer.valueOf(serviceJob.Mileage__c) > 0) {
                        if(serviceJob.Mileage_Measure__c != null && serviceJob.Mileage_Measure__c == 'Miles') {
                            reqDA.FailurePoint = '' + serviceJob.Mileage__c;
                            reqDA.FailureUnit = 'Miles';
                        } else {
                            //convert into Miles
                            string Mile;
                            Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 0.621371).setScale(0));  
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Miles';
                        }
                    } else {
                        reqDA.FailurePoint = ''+ serviceJob.CSS_Hours__c;
                        reqDA.FailureUnit = 'Hours';
                    }
                    
                    getBasicCoverageReq.DataArea = reqDA;
                    basicCoverageDetails = CSS_WS_SBL.getBasicCoverage(getBasicCoverageReq);
                    if(basicCoverageDetails == null){   
                        showWarrDetailsSection = false;
                    }               
                    if(basicCoverageDetails != null){
                        showWarrDetailsSection = true;
                        system.debug('basicCoverageDetails'+basicCoverageDetails.Header);
                        system.debug('basicCoverageDetails>>>>>>'+basicCoverageDetails);
                        //Building map mapGroupCoverageByDefType
                        mapGroupCoverageByDefType=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                        mapGroupCoverageByDefTypeNewENG=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                        coverageByDefTypeMap = new map<string,map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>>();
                        coverageURLProceMap = new map<string,string>();                
                        
                        
                        reqWrcoverBoolean = true;
                        for(CSS_getBasicCoverageResponseJ2A.coverageDetails c : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails){
                            system.debug('c.CoverageType>>>>>>'+c.CoverageType);
                            
                            //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                            if(c.CoverageType =='EMS-Emissions Warranty'){
                                
                                system.debug('insideboolean');
                                reqWrcoverBoolean = false;
                                coverageDetailsSTR = 'CoverageType='+c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('EMS-Emissions Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                                //iterating the CoverageComponentList
                                for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                    //calculating miles
                                    coverageDetailsSTR = coverageDetailsSTR + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    if(mil_measure != null && mil_measure != ''){
                                        if(mil_measure.equalsIgnoreCase('Kilometers')){
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                            system.debug('checking'+ccl.CoverageMaxMonths);
                                            // coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths;
                                        }
                                    }
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    
                                    
                                    coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    
                                    //populating the map 
                                    if(!mapGroupCoverageByDefType.containskey(ccl.CoverageDefenitionType)){
                                        
                                        mapGroupCoverageByDefType.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                    }
                                    mapGroupCoverageByDefType.get(ccl.CoverageDefenitionType).add(ccl);
                                    system.debug('mapGroupCoverageByDefType>>>>*******123'+mapGroupCoverageByDefType.get(ccl.CoverageDefenitionType));
                                }//end of inner 1 loop
                                
                                // S-205 Start
                                for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                    
                                    if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                    {
                                        EmmisionWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                    }
                                    
                                    else {
                                        if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                            EmmisionWarrantyDedutibles = cd.FirstVisitAmt;
                                    }
                                    if(EmmisionWarrantyDedutibles == null || EmmisionWarrantyDedutibles == '')
                                    {
                                        EmmisionWarrantyDedutiblesFlag = true;
                                    }
                                    
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                                system.debug('initialtestresp@@@@@'+coverageDetailsSTR);
                            }//end of If cond
                            system.debug('mapGroupCoverageByDefType>>>>*******'+mapGroupCoverageByDefType);
                            system.debug('initialtestresp######'+coverageDetailsSTR);
                            //if the coverage type is of NEW-New Engine Warranty
                            if(c.CoverageType =='NEW-New Engine Warranty'){
                                system.debug('Inside');
                                reqWrcoverBoolean = false;
                                system.debug('covgtyperespcheck'+c.CoverageType);
                                system.debug('initialtestresp'+coverageDetailsSTR);
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageType='+c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('NEW-New Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                                //iterating the CoverageComponentList
                                for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    //calculating miles
                                    if(mil_measure != null && mil_measure != ''){
                                        if(mil_measure.equalsIgnoreCase('Kilometers')){
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                        }                                
                                    }
                                    
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    //populating the map 
                                    if(!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageDefenitionType)){
                                        
                                        mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                    }
                                    mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageDefenitionType).add(ccl);
                                }//end of inner 2 loop
                                
                                // S-205 Start
                                for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                    
                                    if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                    {
                                        NewEngWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                    }
                                    
                                    else {
                                        if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                            NewEngWarrantyDedutibles = cd.FirstVisitAmt;
                                    }
                                    if(NewEngWarrantyDedutibles == null || NewEngWarrantyDedutibles == '')
                                    {
                                        NewEngWarrantyDedutiblesFlag = true;
                                    }
                                    
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                                {
                                    NewEngWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+NewEngWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                            }//end of if cond
                            system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******'+mapGroupCoverageByDefTypeNewENG);
                        }//end of outer for loop
                        
                        system.debug('initialtestresp######@@@@@@'+coverageDetailsSTR);
                        if(mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()){
                            coverageByDefTypeMap.put('NEW-New Engine Warranty',mapGroupCoverageByDefTypeNewENG);
                        }
                        
                        if(mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()){
                            coverageByDefTypeMap.put('EMS-Emissions Warranty',mapGroupCoverageByDefType);
                        }   
                        
                        
                        
                    }
                }
                reqWrTerBoolean=false; 
            }   
            // system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
            // Certificate details -- start
            listcertificatedetails = new list<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
            if(basicCoverageDetails != null){
                reqWrcertBoolean = false;
                for(CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails)
                {
                    if (mil_measure != null && mil_measure != '') {
                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                            milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                            milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                            crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles) / 0.621371).setScale(0));
                            crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) / 0.621371).setScale(0));
                        }
                    }
                    
                    if(mil_measure != null && mil_measure != ''){
                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                            milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                            milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                        }
                    }
                    
                    // S-205 Start
                    String ProgramId = crtdt.ProgramID;
                    Map<string,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>> listofdeduct = new Map<String,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>>();
                    for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ExtendedCovDedutibles: crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles){
                        
                        system.debug('ExtendedCovDedutibles'+ExtendedCovDedutibles);
                        listofdeduct.put(ExtendedCovDedutibles.ProgramID,crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles);
                        system.debug('listofdeduct'+listofdeduct+'ProgramId'+ProgramId);
                        //listofdeduct.get(ProgramId);
                        //system.debug('Test**1'+listofdeduct);
                        
                    } 
                    for(CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ld: listofdeduct.get(ProgramId))
                    {
                        system.debug('testprofid'+ProgramId);
                        system.debug('testprofid2'+ld.ProgramID);
                        if(ld.ProgramID == ProgramId)
                        {
                            if(ld.ConstantDecutibleAmt !=null && ld.ConstantDecutibleAmt !='' && ld.ConstantDecutibleAmt !='0')
                            {
                                ExtendedWarrantyDedutibles = ld.ConstantDecutibleAmt;
                            }
                            
                            else {
                                if (ld.FirstVisitAmt !=null && ld.FirstVisitAmt !='' && ld.FirstVisitAmt !='0')
                                    ExtendedWarrantyDedutibles = ld.FirstVisitAmt;
                            }
                            if(ExtendedWarrantyDedutibles == null || ExtendedWarrantyDedutibles == '')
                            {
                                ExtendedWarrantyDedutiblesFlag = true;
                            }
                            break;
                            
                        }
                        
                    }
                    //S-205 END
                    
                    listcertificatedetails.add(crtdt);
                    system.debug('Certificate list'+listcertificatedetails);
                    
                    
                    
                }
                if(listcertificatedetails.isEmpty())
                    reqWrcertBoolean = true;
            }
            system.debug('certificate details'+listcertificatedetails);
            
            
            Transient CSS_Job_Order__c srvjob = new CSS_Job_Order__c();
            srvjob.id = pgId;
            srvjob.Warranty_Start_Date__c = serviceJob.Warranty_Start_Date__c;
            srvjob.Region__c = serviceJob.Region__c;
            srvjob.Territory__c = serviceJob.Territory__c;
            if(coverageDetailsSTR!='' && coverageDetailsSTR2!=''){
                srvjob.EditCoverage__c = coverageDetailsSTR + coverageDetailsSTR2 ;
            }else if(coverageDetailsSTR!='' && coverageDetailsSTR2==''){
                srvjob.EditCoverage__c = coverageDetailsSTR;
            }else if(coverageDetailsSTR=='' && coverageDetailsSTR2!=''){
                srvjob.EditCoverage__c = coverageDetailsSTR2;
            }else {srvjob.EditCoverage__c =''; }
            
            if(serviceJob.BMSStatus__c!= null && serviceJob.BMSStatus__c.contains('esnChanged')){
                srvjob.BMSStatus__c = serviceJob.BMSStatus__c.replace(',esnChanged', '');
            }
            update srvjob;
            
            
            
            // Certificate details -- end
            SOQLServicejob();
            
        }catch(exception e){
            system.debug('inside basic search'+e.getLineNumber() + e.getMessage());
        }  
        return null;
    } 
    public void updatetext(){
        if(serviceJob != null){
            update serviceJob;
        }      
    }
    
    public void milekmconv(){
        system.debug('Inside milekmconv method');
        mapGroupCoverageByDefType=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        mapGroupCoverageByDefTypeNewENG=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        mapGroupCoverageByDefTypeRecEng=new map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        coverageByDefTypeMap = new map<string,map<String,list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>>();
        coverageURLProceMap = new map<string,string>();
        system.debug('basicCoverageDetails1>>>>>>'+basicCoverageDetails);
        system.debug('basicCoverageDetails2>>>>>>'+mil_measure);
        if(basicCoverageDetails != null){  
            system.debug('basicCoverageDetails>>>>>>'+basicCoverageDetails);
            for(CSS_getBasicCoverageResponseJ2A.coverageDetails c : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails){
                system.debug('c.CoverageType>>>>>>'+c.CoverageType);
                //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                if(c.CoverageType =='EMS-Emissions Warranty'){
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('EMS-Emissions Warranty',c.WarrantyManualURL+c.ProcedureNumber); 
                    //iterating the CoverageComponentList
                    for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                        //calculating miles                        
                        if(mil_measure != null && mil_measure != ''){
                            if(mil_measure.equalsIgnoreCase('Kilometers')){
                                
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                
                            }
                            /*   if(prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles')){
ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)*0.621371).setScale(0));
} */
                            if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) 
                            {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                    system.debug('Inside Miles condition');
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                            } 
                        }
                        //populating the map 
                        if(!mapGroupCoverageByDefType.containskey(ccl.CoverageDefenitionType)){
                            
                            mapGroupCoverageByDefType.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                        }
                        mapGroupCoverageByDefType.get(ccl.CoverageDefenitionType).add(ccl);
                    }//end of inner 1 loop
                }//end of If cond
                system.debug('mapGroupCoverageByDefType>>>>*******'+mapGroupCoverageByDefType);
                //if the coverage type is of NEW-New Engine Warranty
                if(c.CoverageType =='NEW-New Engine Warranty'){
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('NEW-New Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                    //iterating the CoverageComponentList
                    for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                        //calculating miles                        
                        if(mil_measure != null && mil_measure != ''){
                            if(mil_measure.equalsIgnoreCase('Kilometers')){
                                System.debug('*******ccl.CoverageMiles first'+ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING));
                            }
                            if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                    //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                    ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            } 
                        }
                        //populating the map 
                        if(!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageDefenitionType)){
                            
                            mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                        }
                        mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageDefenitionType).add(ccl);
                    }//end of inner 2 loop
                }//end of if cond
                system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******'+mapGroupCoverageByDefTypeNewENG);
                
                //Code for Recon Engine Warranty Coverage start
                
                if(c.CoverageType =='REW-Recon Engine Warranty'){
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('REW-Recon Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                    //iterating the CoverageComponentList
                    for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                        //calculating miles                        
                        if(mil_measure != null && mil_measure != ''){
                            if(mil_measure.equalsIgnoreCase('Kilometers')){
                                System.debug('*******ccl.CoverageMiles first'+ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                            }
                            
                            if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                    //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                    ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            }
                        }
                        //populating the map 
                        if(!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageDefenitionType)){
                            
                            mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageDefenitionType,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                        }
                        mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageDefenitionType).add(ccl);
                        system.debug('TestRecon11'+mapGroupCoverageByDefTypeRecEng);
                    }//end of inner 2 loop
                }//end of if cond
                
                //Code for Recon Engine Warranty Coverage end
            }//end of outer for loop 
            
        }//end of If for null check of basicCoverageDetails
        if(mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()){
            coverageByDefTypeMap.put('NEW-New Engine Warranty',mapGroupCoverageByDefTypeNewENG);
        }
        
        if(mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()){
            coverageByDefTypeMap.put('REW-Recon Engine Warranty',mapGroupCoverageByDefTypeRecEng);
        }
        
        if(mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()){
            coverageByDefTypeMap.put('EMS-Emissions Warranty',mapGroupCoverageByDefType);
        }
        
        listcertificatedetails = new list<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
        system.debug('***basicCoverageDetails***'+basicCoverageDetails);
        if(basicCoverageDetails != null){
            for(CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails)
            {
                system.debug('** crtdt**'+crtdt);
                system.debug('** crtdt.EndMiles**'+crtdt.EndMiles);
                system.debug('** Inside Certificate For Loop');
                system.debug('** mil_measure**'+mil_measure);
                if(mil_measure != null && mil_measure != ''){
                    system.debug('** Inside after mil Measure null check');
                    if(mil_measure.equalsIgnoreCase('Kilometers')){   
                        system.debug('** Inside Certificte mil Measure Kilometers'); 
                        string miletokm;
                        if(crtdt.EndMiles!=null && crtdt.EndMiles!=''){
                            system.debug('** crtdt.EndMiles**'+crtdt.EndMiles);
                            system.debug('** String.ValueOf(Decimal.valueOf(crtdt.EndMiles) * 1.609344)***'+String.ValueOf(Decimal.valueOf(crtdt.EndMiles) * 1.609344)); 
                            crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles) * 1.609344);
                            system.debug('**crtdt.EndMiles**'+crtdt.EndMiles);
                            miletokm = crtdt.EndMiles;
                            system.debug('Testmiles'+miletokm);
                            crtdt.EndMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING));
                        }
                        
                        //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles)/0.621371).setScale(0));
                        //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles)/0.621371).setScale(0));
                        string milestokm;
                        if(crtdt.BeginMiles!=null && crtdt.BeginMiles!=''){
                            crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles) * 1.609344);
                            milestokm = crtdt.BeginMiles;
                            system.debug('Testmiles'+miletokm);
                            crtdt.BeginMiles= String.ValueOf((Decimal.valueOf(milestokm)).round(System.RoundingMode.CEILING));  
                        }
                        
                    }
                    
                    if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null ) { 
                        system.debug('** Inside Certificte mil Measure Miles');
                        crtdt.BeginMiles = milesHolder.get(crtdt.ProcedureNumber);
                        crtdt.EndMiles = milesHolder.get(crtdt.CertificateNumber);
                        system.debug('Testmiles1'+crtdt.EndMiles);
                        //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) * 0.621371).setScale(0));
                        //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles) * 0.621371).setScale(0));
                    }
                }
                
                listcertificatedetails.add(crtdt);      
                
            } 
        }      
        system.debug('***listcertificatedetails-->'+listcertificatedetails);
        system.debug('Today reqWrcertBoolean-->'+reqWrcertBoolean );
        
        if(listcertificatedetails.isEmpty())
            reqWrcertBoolean = true;
        
        prevmil_measure = mil_measure;
        //system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
        
        
    } 
    //Added by shanthi - Story 85181 
    public string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
    //Added by Ekta -Story 85177 
    public String getWarrCreatedDate() {
        
        transient String locale_formatted_date_time_value = css_utility.getFormattedDate(warrentyStartD); //Get formatted String from Utility Class
        if(locale_formatted_date_time_value != null)
            return locale_formatted_date_time_value.substring(0,11); //return the string
        else
            return null;
    }
    
    //start story 76192
    //Method to clear waranty fields when the location is changed
    public void clearWarantyFields(){
        if(serviceJob != null){
            serviceJob.CoverageResponse__c = '';
            /*serviceJob.ESN__c = '';
serviceJob.Warranty_Start_Date__c = null;
serviceJob.Application_Desc__c = '';
serviceJob.Region__c = '';
serviceJob.Territory__c = '';*/
        }
        
    }
    //End Story 76192
    
    
}