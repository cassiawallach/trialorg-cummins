public class CSS_WarrantyExtended {

    // global variables
    public id pgId;
    public CSS_Job_Order__c servicejob {
        get;
        set;
    }

    Public String selectedAppCode {
        get;
        set;
    }
    //Added by shanthi
    public String myBase64String {
        get;
        set;
    }
    public boolean reqWrAppBoolean {
        get;
        set;
    }
    public boolean reqWrRegBoolean {
        get;
        set;
    }
    public boolean reqWrTerBoolean {
        get;
        set;
    }
    public boolean reqWrWarBoolean {
        get;
        set;
    }
    public boolean showExtCoverage {
        get;
        set;
    }
    public boolean reqWrEsnBoolean {
        get;
        set;
    }
    public string mil_measure {
        get;
        set;
    }
    public string defValue {
        get;
        set;
    }
    public string MileageKmVal {
        get;
        set;
    }
    public string prevmil_measure;
    public string applicationCode;
    public boolean reqWrcoverBoolean {
        get;
        set;
    }
    public boolean reqWrcertBoolean {
        get;
        set;
    }
    public boolean showWarrDetailsSection {
        get;
        set;
    }
    Public String pagName {
        get;
        set {
            pagName = value;
            system.debug('pagName4444' + pagName);

        }
    }

    public map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> coverageByDefTypeMap {
        get;
        set;
    }
    public map < string, string > coverageURLProceMap {
        get;
        set;
    }
    public DateTime warrentyStartD {
        get;
        set;
    }
    public String mileKmMeasure {
        get;
        set;
    }
    public Integer coverageMaxMonth {
        get;
        set;
    }
    public String UnitMiles;
    public String PointMiles;
    public String UnitKilometers;
    public String PointKilometers;
    public String UnitHours;
    public String PointHours;
    public boolean emissionStatus {get;set;}
    public Boolean noWarranFlagError{get; set;}
    public Map<String, String> tempcoverageURLProceMap{get; set;}
    public Map<String,string> milesHolder = new Map<String,string>();
    public String EmmisionWarrantyDedutibles{get; set;}
    public String ExtendedWarrantyDedutibles{get; set;}
    public String ReconWarrantyDedutibles{get; set;}
    public String NewEngWarrantyDedutibles{get; set;}
    
    public Boolean NewEngWarrantyDedutiblesFlag{get; set;}
    public Boolean EmmisionWarrantyDedutiblesFlag{get; set;}
    public Boolean ExtendedWarrantyDedutiblesFlag{get; set;}
    public Boolean ReconWarrantyDedutiblesFlag{get; set;}

    public CSS_WarrantyExtended() {
        pgId = ApexPages.CurrentPage().getParameters().get('id');
        serviceJob = new CSS_Job_Order__c();
        system.debug('pgId>>>>>>>>>>>>>>>>>' + pgId);
        showWarrDetailsSection = true;
        showExtCoverage = false;
        noWarranFlagError = false;
        NewEngWarrantyDedutiblesFlag = false;
        EmmisionWarrantyDedutiblesFlag = false;
        ExtendedWarrantyDedutiblesFlag = false;
        ReconWarrantyDedutiblesFlag = false;
        if (pgId != null) {
            SOQLServicejob();
            system.debug('Before Region Method ESN>>>>>>>>>>>>>>>>>>>>>' + serviceJob.ESN__c);
            /***** Calling the Region and Territory method to update the values from Siebel service based on user Location *****/
             //Defect No:136225 -SN - 3 Apr 2018 - Replaced AND Condition with OR
            if ((serviceJob.Region__c == null || serviceJob.Region__c == '') || (serviceJob.Territory__c == null || serviceJob.Territory__c == ''))
                regionTerritory();
            system.debug('After Region Method ESN>>>>>>>>>>>>>>>>>>>>>' + serviceJob.ESN__c);
            system.debug('ED  MileageKmVal>>>>>>>>>>>>>>>>>>>>>' + MileageKmVal);
            SelectedAppCode = serviceJob.Application_Desc__c;
            defValue = serviceJob.Mileage_Measure__c;
            //mil_measure = MileageKmVal;
            //mil_measure = 'Miles'; 
            mil_measure = defValue;
            //mil_measure = mileKmMeasure; 
            system.debug('mil_measure>>>' + mil_measure);
            system.debug('defValue>>>' + defValue);


            loadBasicData();
        } else {

            regionTerritory();

        }
    }

    public void SOQLServicejob() {
        serviceJob = [Select id, Region__c, Failure_Date__c,ApplicationCode__c, Territory__c,warrantyIndicatorFlag__c, Warranty_Start_Date__c, Before_In_Service__c,ReconEngineFlag__c,Application_Desc__c,Application__c, ESN__c, Mileage__c,Mileage_Measure__c, CoverageResponse__c, EditCoverage__c, BMSStatus__C, Creator_Location__c, CSS_Job_Location_Code__c, CSS_Hours__c  from CSS_Job_Order__c where id = : pgId];
        System.debug('Warranty Start Date is ' + serviceJob.Warranty_Start_Date__c);
        if(serviceJob.warrantyIndicatorFlag__c!=null && serviceJob.warrantyIndicatorFlag__c!='' && serviceJob.warrantyIndicatorFlag__c=='N')
        noWarranFlagError = true;
    }

    public void regionTerritory() {
        try {
            /****** Calling the Utility Method to query region and territory values from Account based on user Location ******/
            Account RegionTerritory = css_utility.getRegionTerritory((serviceJob == null ? '' : serviceJob.Creator_Location__c));

            system.debug('RegionTerritory>>>>>>>>>>>' + RegionTerritory.Region__c);
            //serviceJob.Region__c = '--None--';
            serviceJob.Region__c = RegionTerritory.Region__c;
            serviceJob.Territory__c = RegionTerritory.Territory__c;
        } catch (exception e) {
            system.debug('Entered into catch of Region Territory method in css_warranty>>>>>>' + e.getLineNumber() + ' ' + e.getMessage());
        }
    }

    public void loadBasicData() {
        //              if(pagName != null && pagName != ''){

        //            if(pagName.equalsIgnoreCase('TND') || pagName.equalsIgnoreCase('REPAIR')){
        try {
            if (serviceJob != null) {
                emissionStatus = false;
                prevmil_measure = mil_measure;
                string Mile;
                Date faildate=serviceJob.Failure_Date__c;  // Story 164795
                Date warrantydate=serviceJob.Warranty_Start_Date__c; 
                Double days = (faildate != null) ? (warrantydate.daysBetween(faildate)) : 0;
                Double Monthsbwfaildatewarrdate = days/30.417;
                system.debug('Days for warranty'+days);
                system.debug('Months for warranty'+Monthsbwfaildatewarrdate);
                string ProductMileage;
                string ProductMeasure;
                if(serviceJob.Mileage__c ==null ){
                	serviceJob.Mileage__c = 0;
                }			
                if(serviceJob.CSS_Hours__c ==null ){
                	serviceJob.CSS_Hours__c = 0;
                }
                
                
                if(serviceJob.Mileage__c != null && Integer.valueOf(serviceJob.Mileage__c) > 0) {
                        if(serviceJob.Mileage_Measure__c != null && serviceJob.Mileage_Measure__c == 'Miles') {
                            UnitMiles = 'Miles';
                            PointMiles = '' + serviceJob.Mileage__c;
                            UnitHours = 'Hours';
                            PointHours = ''+ serviceJob.CSS_Hours__c;
                        } else {
                            //convert into Miles
                            
                            /*Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 0.621371).setScale(0));  
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Miles';*/
                            Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 1.60934).setScale(0)); 
                            //Mile = '' + serviceJob.Mileage__c; // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                            UnitHours = 'Hours';
                            PointHours = ''+ serviceJob.CSS_Hours__c;
                        }
                    } else {
                        if(serviceJob.CSS_Hours__c!=null){
                        UnitHours = 'Hours';
                        PointHours = ''+ serviceJob.CSS_Hours__c;
                        if(mil_measure != null && mil_measure == 'Miles'){
                            UnitMiles = 'Miles';
                            PointMiles = '' + serviceJob.Mileage__c;
                        }
                        else{
                            Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 1.60934).setScale(0));
                            // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                        
                            //Mile = '' + serviceJob.Mileage__c;
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                        }
                    }
            }
                
                 // Story 190403 - Start
                if(serviceJob.ApplicationCode__c=='130' || serviceJob.ApplicationCode__c=='210' || serviceJob.ApplicationCode__c=='220' || serviceJob.ApplicationCode__c=='310' || serviceJob.ApplicationCode__c=='320' || serviceJob.ApplicationCode__c=='410')
                {
                ProductMileage = string.valueof(serviceJob.Mileage__c);
                ProductMeasure = serviceJob.Mileage_Measure__c;
                }
                else{
                ProductMileage = string.valueof(serviceJob.CSS_Hours__c);
                ProductMeasure = 'Hours';
                }
                // Story 190403 - END
                
                if (serviceJob.CoverageResponse__c != null && serviceJob.CoverageResponse__c != '') {
                    basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                    basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(serviceJob.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                    system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                    system.debug('basicCoverageDetails>>>>>>' + basicCoverageDetails);
                    //Building map mapGroupCoverageByDefType
                    mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
                    mapGroupCoverageByDefTypeRecENG = new map < string, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    coverageURLProceMap = new map < string, string > ();
                    tempcoverageURLProceMap = new Map<String, String>();
                    reqWrcoverBoolean = true;
                    Date curDate = Date.today();

                    system.debug('Coverage Details--'+basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails);
                    for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        system.debug('c.CoverageType>>>>>>' + c.CoverageType);
                        //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                        if (c.CoverageType == 'EMS-Emissions Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                            //iterating the CoverageComponentList
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                {   // Story 164795 
                                
                                //calculating miles
                                if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                         milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                    }
                                }
                                
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                
                                //#85179    START
                                // ccl.status = c.status;
                                // ccl.WarrantyEndDate = c.WarrantyEndDate;
                                System.debug('MK-->'+serviceJob.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                If(Integer.valueOf(ccl.CoverageHours) == 9999999)
                                {

                                    if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                        ccl.status = 'Active';
                                    }else{
                                        ccl.status = 'Expired';   
                                    }

                                }else{
                                    if(Integer.valueOf(ccl.CoverageHours) == 0){
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        } 
                                    }
                                    else{
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }
                                    }
                                
                                }
                                }  // Story 164795 
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                }
                                if(serviceJob.Warranty_Start_Date__c != null){
                                    ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format(); //.addDays(-1))
//Added for defect 134966
                                system.debug('EndDate'+ ccl.WarrantyEndDate );
                                ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                }
                                system.debug('Coverage Satish --> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                
                                // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                
                                if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                    date cd = date.parse(ccl.WarrantyEndDate);
                                    DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                    ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));

                                    //Date wed = date.parse(ccl.WarrantyEndDate);
                                    If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                        If(cd >= curDate){
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';
                                        }
                                    }

                                }

                                    if(ccl.status == 'Expired'){
                                        emissionStatus = true;
                                    }

                                ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                //#85179    END
                                //populating the map 
                                if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {

                                    mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                            } //end of inner 1 loop
                            
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
                                	if(EmmisionWarrantyDedutibles != null || EmmisionWarrantyDedutibles != '')
                                    {
                                        EmmisionWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                            
                        } //end of If cond
                        system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefType);
                        
                        //if the coverage type is of NEW-New Engine Warranty
                        if (c.CoverageType == 'NEW-New Engine Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck' + c.CoverageType);
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                {   // Story 164795
                                    
                                //calculating miles
                                if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                    }
                                }
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                
                                //#85179    START
                                //ccl.status = c.status;
                                //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                System.debug('MK-->'+serviceJob.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                If(Integer.valueOf(ccl.CoverageHours) == 9999999 )
                                {

                                    if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                        ccl.status = 'Active';
                                    }else{
                                        ccl.status = 'Expired';   
                                    }

                                }else{ 
                                    if(Integer.valueOf(ccl.CoverageHours) == 0){
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        } 
                                    }
                                    else{
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }
                                    }
                                
                                }
                                }  
                                // Story 164795 
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                }
                                //   ccl.WarrantyEndDate = (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).format() ;
                                if(serviceJob.Warranty_Start_Date__c != null){
                                    ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
//Added for defect 134966
                                ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                }
                                system.debug('Coverage Satish2 --> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                
                                // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                
                                if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                    date cd = date.parse(ccl.WarrantyEndDate);
                                    DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                    ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                                }

                                ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;    
                                //#85179    END
                                //populating the map 
                                if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {

                                    mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                            } //end of inner 2 loop
                            
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
                                    if(NewEngWarrantyDedutibles != null || NewEngWarrantyDedutibles != '')
                                    {
                                        NewEngWarrantyDedutiblesFlag = true;
                                    }
                                    
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    NewEngWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+NewEngWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                            
                        } //end of if cond
                        system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******' + mapGroupCoverageByDefTypeNewENG);
                        
                        
                        //Code for Recon Engine Warranty Coverage start
                        
                        if (c.CoverageType == 'REW-Recon Engine Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('REW-Recon Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'REW-Recon Engine Warranty');
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck' + c.CoverageType);
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                {   // Story 164795
                                    
                                //calculating miles
                                if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                    }
                                }
                                
                                if(mil_measure != null && mil_measure != ''){
                                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                    }
                                }
                                //#85179    START
                                //ccl.status = c.status;
                                //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                System.debug('MK-->'+serviceJob.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                If(Integer.valueOf(ccl.CoverageHours) == 9999999 )
                                {

                                    if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                        ccl.status = 'Active';
                                    }else{
                                        ccl.status = 'Expired';   
                                    }

                                }else{ 
                                    if(Integer.valueOf(ccl.CoverageHours) == 0){
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        } 
                                    }
                                    else{
                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }
                                    }
                                
                                }
                                }  
                                // Story 164795 
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                }
                                //   ccl.WarrantyEndDate = (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).format() ;
                                if(serviceJob.Warranty_Start_Date__c != null){
                                    ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
//Added for defect 134966
                                ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                }
                                system.debug('Coverage Satish2 --> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                
                                // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                
                                if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                    date cd = date.parse(ccl.WarrantyEndDate);
                                    DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                    ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                                }

                                    
                                //#85179    END
                                //populating the map 
                                ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                if (!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)) {

                                    mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                            } //end of inner 2 loop
                            
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
                                	
                                	if(ReconWarrantyDedutibles != null || ReconWarrantyDedutibles != '')
                                    {
                                        ReconWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    ReconWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+ReconWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                        }
                        
                        //Code for Recon Engine Warranty Coverage End
                    } //end of outer for loop

                    if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
                        coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
                    }

                    if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
                        coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
                    }
                    
                    if (mapGroupCoverageByDefTypeRecENG != null && !mapGroupCoverageByDefTypeRecENG.isEmpty()) {
                            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecENG);
                        }

                    system.debug('checking certification details' + basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
                    // Certificate details -- start
                    listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
                    reqWrcertBoolean = false;
                    for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {

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
                        //#85179    START
                        //Added for defect 134966
                        crtdt.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(crtdt.EndDate));
                        System.debug('crtdt.StartDate>>>:'+crtdt.StartDate); // StartDate format: 10/14/2013
                        System.debug('crtdt.EndDate>>>:'+crtdt.EndDate); // StartDate format: 10/14/2018
                        if(crtdt.StartDate != null && crtdt.StartDate != '') {
                            date cd = date.parse(crtdt.StartDate);
                            system.debug('after crtdt.StartDate 11->>>:'+cd);
                            DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                        }
                        if(crtdt.EndDate != null && crtdt.EndDate != '') {
                            date cd = date.parse(crtdt.EndDate);
                            system.debug('after crtdt.EndDate 11->>>:'+cd);
                            DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                        }
                        //#85179    END
                        
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
                 
                 if(listofdeduct != null && listofdeduct.size()>0 && ProgramId != null){//GSSC-494
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
                        if(ExtendedWarrantyDedutibles != null || ExtendedWarrantyDedutibles != '')
                        {
                        	ExtendedWarrantyDedutiblesFlag = true;
                        }
                        break;
                         
                     }
                     
                 }
                 }
                 //S-205 END
                        
                        listcertificatedetails.add(crtdt);


                    }
                    if (listcertificatedetails.isEmpty()){
                        reqWrcertBoolean = true;
                        showExtCoverage = false;
                    }
                    else
                        showExtCoverage = true;
                    system.debug('certificate details' + listcertificatedetails);
                    // Certificate details -- end

                }
                reqWrTerBoolean = false;
            }
            //              }
            //          }     
        } catch (exception e) {
            //Prabhakar Added below Code (19/03) for Defect#134296
            system.debug('EXCEPTION in CSS_WarrantyExtended  >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        /*  if(show_wr_pnl){
options.add(new SelectOption('Miles',system.Label.CSS_Miles));
options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers)); 
} */

        options.add(new SelectOption('Miles', system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers', system.Label.CSS_Kilometers));


        return options;
    }

    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails {
        get;
        set;
    }
    public map < string, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> mapGroupCoverageByDefType {
        get;
        set;
    }
    public map < string, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> mapGroupCoverageByDefTypeNewENG {
        get;
        set;
    }
    public map < string, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> mapGroupCoverageByDefTypeRecENG {
        get;
        set;
    }
    public list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > listcertificatedetails {
        get;
        set;
    }
    public string coverageDetailsSTR;
    public string coverageDetailsSTR2;
    // basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails
    //Stroy 63178
    public pagereference coveragesearch() {
        try {
            emissionStatus = false;
            coverageDetailsSTR = '';
            coverageDetailsSTR2 = '';
            system.debug('AppCode***' + SelectedAppCode);
            if (SelectedAppCode == null || SelectedAppCode == '' || SelectedAppCode == '--None--') {
                reqWrAppBoolean = true;
                return null;
            } else {
                reqWrAppBoolean = false;
            }
            system.debug('serviceJob.Warranty_Start_Date__c***' + serviceJob.Warranty_Start_Date__c);
            
            string ProductMileage;
            string ProductMeasure;
            if(serviceJob.Mileage__c ==null){
            	serviceJob.Mileage__c = 0;
            }			
            if(serviceJob.CSS_Hours__c ==null){
            	serviceJob.CSS_Hours__c = 0;
            }
            
             // Story 190403 - Start
            if(serviceJob.ApplicationCode__c=='130' || serviceJob.ApplicationCode__c=='210' || serviceJob.ApplicationCode__c=='220' || serviceJob.ApplicationCode__c=='310' || serviceJob.ApplicationCode__c=='320' || serviceJob.ApplicationCode__c=='410')
            {
            ProductMileage = string.valueof(serviceJob.Mileage__c);
            ProductMeasure = serviceJob.Mileage_Measure__c;
            }
            else{
            ProductMileage = string.valueof(serviceJob.CSS_Hours__c);
            ProductMeasure = 'Hours';
            }
            // Story 190403 - END
            
            Date faildate=serviceJob.Failure_Date__c;  // Story 164795
            Date warrantydate=serviceJob.Warranty_Start_Date__c; 
            //String Monthsbwfaildatewarrdate =String.valueOf(warrantydate.monthsBetween(faildate)); 
            //system.debug('Months'+Monthsbwfaildatewarrdate);
            Double days;
            if(warrantydate != null)
                days = (warrantydate.daysBetween(faildate));
            Double Monthsbwfaildatewarrdate;
            if(days != null)
                Monthsbwfaildatewarrdate = days/30.417;
            else
                Monthsbwfaildatewarrdate = 0;
            system.debug('Days for warranty'+days);
            system.debug('Months for warranty'+Monthsbwfaildatewarrdate);
            
            if (serviceJob.Warranty_Start_Date__c == null && serviceJob.Before_In_Service__c == false) {
                reqWrWarBoolean = true;
                return null;
            } else {
                reqWrWarBoolean = false;
            }
            system.debug('serviceJob.ESN__c***' + serviceJob.ESN__c);
            if (serviceJob.ESN__c == null || serviceJob.ESN__c == '') {
                reqWrEsnBoolean = true;
                return null;
            } else {
                reqWrEsnBoolean = false;
            }
            system.debug('serviceJob.Region__c***' + serviceJob.Region__c);
            if (serviceJob.Region__c == null || serviceJob.Region__c == '' || serviceJob.Region__c == '--None--') {
                reqWrRegBoolean = true;
                return null;
            } else {
                reqWrRegBoolean = false;
            }
            system.debug('serviceJob.Territory__c***' + serviceJob.Territory__c);
            if (serviceJob.Territory__c == null || serviceJob.Territory__c == '' || serviceJob.Territory__c == '--None--') {
                system.debug('checking the boolean value');
                reqWrTerBoolean = true;
                return null;
            } else {
                system.debug('Inside');
                //mil_measure = 'Miles';
                mil_measure = defValue;
                system.debug('mil_measure in RB' + mil_measure);
                prevmil_measure = mil_measure;
                system.debug('prevmil_measure in coveragesearch' + mil_measure);
                CSS_getBasicCoverageReqJ2A getBasicCoverageReq = new CSS_getBasicCoverageReqJ2A();
                CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                if (serviceJob != null) {
                    reqDA.ESN = serviceJob.ESN__c;
                    reqDA.Region = serviceJob.Region__c;
                    reqDA.Territory = serviceJob.Territory__c;

                    reqDA.JObId = servicejob.id;
                    system.debug('SelectedAppCode******>>>>' + SelectedAppCode);
                    //We are able to call web service when we specify code but Css utility is not returning the code gives exception though values are passed correctly.
                    applicationCode = css_utility.getCodes('Application Code', SelectedAppCode, null, null);
                    system.debug('apllication code' + applicationCode);
                    reqDA.EngineApplicationCode = applicationCode; //'130';// Please call CSS_Utility.getCodes()
                    
                    Date d;
                    String Mile;
                    string warantySDate;
                    if(serviceJob.Before_In_Service__c==false){
                        d = serviceJob.Warranty_Start_Date__c;
                        //'5/1/2010';//String.Valueof(workJob.Warranty_Start_Date__c);
                    }
                    else if(serviceJob.Before_In_Service__c==true){
                        d = serviceJob.Failure_Date__c;
                        system.debug('serviceJob.Failure_Date__c'+serviceJob.Failure_Date__c);
                    }
                    if(d!=null){
                        //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                        warantySDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/d/yyyy');
                    }
                    reqDA.WarrantyStartDate = warantySDate;
                    system.debug('***reqDA.WarrantyStartDate***'+reqDA.WarrantyStartDate);
                    //#85179START
                    // Sai:10/26 : Included > 0 condition in the below IF to check for a valid vlaue.
                    if(serviceJob.Mileage__c != null && Integer.valueOf(serviceJob.Mileage__c) > 0) {
                        if(serviceJob.Mileage_Measure__c != null && serviceJob.Mileage_Measure__c == 'Miles') {
                            reqDA.FailurePoint = '' + serviceJob.Mileage__c;
                            reqDA.FailureUnit = 'Miles';
                            UnitMiles = 'Miles';
                            PointMiles = '' + serviceJob.Mileage__c;
                            UnitHours = 'Hours';
                            PointHours = ''+ serviceJob.CSS_Hours__c;
                        } else {
                            //convert into Miles
                            
                            /*Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 0.621371).setScale(0));  
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Miles';*/
                           // Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 1.60934).setScale(0));
                           // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                            
                            Mile = '' + serviceJob.Mileage__c;
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Kilometers';
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                            UnitHours = 'Hours';
                            PointHours = ''+ serviceJob.CSS_Hours__c;
                        }
                    } else {
                        reqDA.FailurePoint = ''+ serviceJob.CSS_Hours__c;
                        reqDA.FailureUnit = 'Hours';
                        UnitHours = 'Hours';
                        PointHours = ''+ serviceJob.CSS_Hours__c;
                        if(mil_measure != null && mil_measure == 'Miles'){
                            UnitMiles = 'Miles';
                            PointMiles = '' + serviceJob.Mileage__c;
                        }
                        else{
                            //Mile = String.ValueOf((integer.valueOf(serviceJob.Mileage__c) * 1.60934).setScale(0));
                            // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.

                            Mile = '' + serviceJob.Mileage__c;
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                        }
                    }
                    reqDA.ReconFlag  = serviceJob.ReconEngineFlag__c;
                    //reqDA.ReconFlag  = 'N';
                    //#85179END
                    system.debug('***reqDA***'+reqDA);
                    getBasicCoverageReq.DataArea = reqDA;
                    basicCoverageDetails = CSS_WS_SBL.getBasicCoverage(getBasicCoverageReq);
                    if (basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfCoverageDetails.CoverageDetails.size() == 0 &&
                        basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails.size() == 0) {
                        showWarrDetailsSection = false;
                    }
                    else {
                        showWarrDetailsSection = true;
                        system.debug('basicCoverageDetails' + basicCoverageDetails.Header);
                        system.debug('basicCoverageDetails>>>>>>' + basicCoverageDetails);
                        //Building map mapGroupCoverageByDefType
                        mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        mapGroupCoverageByDefTypeRecENG = new map < string, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
                        coverageURLProceMap = new map < string, string > ();
                        tempcoverageURLProceMap = new map < string, string > ();
                        Date curDate = Date.today();
                        reqWrcoverBoolean = true;
                        for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                            system.debug('c.CoverageType>>>>>>' + c.CoverageType);

                            //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                            if (c.CoverageType == 'EMS-Emissions Warranty') {

                                system.debug('insideboolean');
                                reqWrcoverBoolean = false;
                                coverageDetailsSTR = 'CoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                                //iterating the CoverageComponentList
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                     coverageDetailsSTR = coverageDetailsSTR + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795 
                                    system.debug('Unit Testing');
                                    //calculating miles
                                   
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                            //system.debug('checking' + ccl.CoverageMaxMonths);
                                        ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                        string miletokm = ccl.CoverageMiles;
                                        system.debug('Testmiles'+miletokm);
                                        ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                            // coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths;
                                        }

                                    }
                                    
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    } 

                                    coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    //#85179    START
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    If(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                    {

                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }

                                    }else{
                                        if(Integer.valueOf(ccl.CoverageHours) == 0){
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                        }
                                    
                                    }
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    }  // Story 164795 
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }
                                    if(serviceJob.Warranty_Start_Date__c != null){
                                        ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
                                    system.debug('Coverage Satish 3--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
//Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    //vamshi for BIS warranty start date scenario
                                    else if(serviceJob.Before_In_Service__c==true && serviceJob.Failure_Date__c!=null){
                                        ccl.WarrantyEndDate = ((serviceJob.Failure_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
                                    //system.debug('Coverage Satish 3--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
//Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    
                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                    
                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        date cd = date.parse(ccl.WarrantyEndDate);
                                        DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                        ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));

                                        //Date wed = date.parse(ccl.WarrantyEndDate);
                                        If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                            If(cd >= curDate){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';
                                            }
                                        }
                                    }

                                    if(ccl.status == 'Expired'){
                                        emissionStatus = true;
                                    }


                                        
                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                                    system.debug('mapGroupCoverageByDefType>>>>*******123' + mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode));
                                } //end of inner 1 loop
                                system.debug('initialtestresp@@@@@' + coverageDetailsSTR);
                                
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
                                	if(EmmisionWarrantyDedutibles != null || EmmisionWarrantyDedutibles != '')
                                    {
                                        EmmisionWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                            } //end of If cond
                            
                            
                            
                            if (c.CoverageType == 'REW-Recon Engine Warranty') {

                                system.debug('insideboolean');
                                reqWrcoverBoolean = false;
                                coverageDetailsSTR = 'CoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('REW-Recon Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'REW-Recon Engine Warranty');
                                //iterating the CoverageComponentList
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                     coverageDetailsSTR = coverageDetailsSTR + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795 
                                    system.debug('Unit Testing');
                                    //calculating miles
                                   
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                            //system.debug('checking' + ccl.CoverageMaxMonths);
                                            ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                            string miletokm = ccl.CoverageMiles;
                                            system.debug('Testmiles'+miletokm);
                                            ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                            // coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths;
                                        }
                                    }
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    //#85179    START
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    If(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                    {

                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }

                                    }else{ 
                                        if(Integer.valueOf(ccl.CoverageHours) == 0){
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                        }
                                    
                                    }
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    }  // Story 164795 
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }
                                    if(serviceJob.Warranty_Start_Date__c != null){
                                        ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
                                    system.debug('Coverage Satish 3--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
//Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    //vamshi
                                    else if(serviceJob.Before_In_Service__c==true && serviceJob.Failure_Date__c!=null){
                                        ccl.WarrantyEndDate = ((serviceJob.Failure_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
                                   // system.debug('Coverage Satish 3--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
//Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    
                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                    
                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        date cd = date.parse(ccl.WarrantyEndDate);
                                        DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                        ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));

                                        //Date wed = date.parse(ccl.WarrantyEndDate);
                                        If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                            If(cd >= curDate){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';
                                            }
                                        }
                                    }

                                    if(ccl.status == 'Expired'){
                                        emissionStatus = true;
                                    }


                                        
                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefTypeRecENG.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefTypeRecENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefTypeRecENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                                    system.debug('mapGroupCoverageByDefType>>>>*******123' + mapGroupCoverageByDefTypeRecENG.get(ccl.CoverageComponentTypeCode));
                                    
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
                                	
                                	if(ReconWarrantyDedutibles != null || ReconWarrantyDedutibles != '')
                                    {
                                        ReconWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    ReconWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+ReconWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                    
                                } //end of inner 1 loop
                                system.debug('initialtestresp@@@@@' + coverageDetailsSTR);
                            }
                            
                            
                            
                            system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefTypeRecENG);
                            system.debug('initialtestresp######' + coverageDetailsSTR);
                            //if the coverage type is of NEW-New Engine Warranty
                            if (c.CoverageType == 'NEW-New Engine Warranty') {
                                system.debug('Inside');
                                reqWrcoverBoolean = false;
                                system.debug('covgtyperespcheck' + c.CoverageType);
                                system.debug('initialtestresp' + coverageDetailsSTR);
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                                //iterating the CoverageComponentList
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                   
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795 
                                    
                                    //calculating miles
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                            ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) * 1.609344);
                                            string miletokm = ccl.CoverageMiles;
                                            system.debug('Testmiles'+miletokm);
                                            ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                        }
                                    }
                                     if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    //#85179    START
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    If(Integer.valueOf(ccl.CoverageHours) == 9999999)
                                    {

                                        if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                            ccl.status = 'Active';
                                        }else{
                                            ccl.status = 'Expired';   
                                        }

                                    }else{
                                        if(Integer.valueOf(ccl.CoverageHours) == 0){
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate < = (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{
                                            if (serviceJob.Warranty_Start_Date__c != null && curDate <= (serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && serviceJob.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && serviceJob.CSS_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                        }
                                    
                                        
                                    }
                                    //if(serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))     
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    }  // Story 164795 
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }
                                    if(serviceJob.Warranty_Start_Date__c != null){
                                        ccl.WarrantyEndDate = ((serviceJob.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))

                                    //Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    //vamshi
                                    else if(serviceJob.Before_In_Service__c==true && serviceJob.Failure_Date__c!=null){
                                        ccl.WarrantyEndDate = ((serviceJob.Failure_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1))
                                    //system.debug('Coverage Satish 3--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
//Added for defect 134966
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    }
                                    
                                    
                                    system.debug('Coverage Satish 4--> '+ serviceJob.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);    

                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END

                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        date cd = date.parse(ccl.WarrantyEndDate);
                                        DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                        ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                                    }
                                        

                                        
                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                                } //end of inner 2 loop
                                
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
                                    if(NewEngWarrantyDedutibles != null || NewEngWarrantyDedutibles != '')
                                    {
                                        NewEngWarrantyDedutiblesFlag = true;
                                    }
                                    
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    NewEngWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+NewEngWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                            } //end of if cond
                            system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******' + mapGroupCoverageByDefTypeNewENG);
                        } //end of outer for loop

                        system.debug('initialtestresp######@@@@@@' + coverageDetailsSTR);


                        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
                            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
                        }

                        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
                            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
                        }
                        
                        if (mapGroupCoverageByDefTypeRecENG != null && !mapGroupCoverageByDefTypeRecENG.isEmpty()) {
                            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecENG);
                        }
                    }
                }
                reqWrTerBoolean = false;
            }
            // system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
            // Certificate details -- start
            listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
            if (basicCoverageDetails != null) {
                reqWrcertBoolean = false;
                //Added for defect 134966
                Date curDate = Date.today();
                for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {

                 if (mil_measure != null && mil_measure != '') {
                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                            milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                            milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                            //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles) / 0.621371).setScale(0));
                            //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) / 0.621371).setScale(0));
                            crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles)  * 1.609344);
                            string miletokm = crtdt.EndMiles;
                            system.debug('Testmiles'+miletokm);
                            crtdt.EndMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 

                            crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles)  * 1.609344);
                            string milestokm = crtdt.BeginMiles;
                            system.debug('Testmiles'+miletokm);
                            crtdt.BeginMiles= String.ValueOf((Decimal.valueOf(milestokm)).round(System.RoundingMode.CEILING)); 
                        }
                    }
                    
                if(mil_measure != null && mil_measure != ''){
                    if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                           milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                            milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                    }
                }
                    //#85179    START
                    //Added for defect 134966
                    crtdt.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(crtdt.EndDate));
                    if(crtdt.StartDate != null && crtdt.StartDate != '') {
                        date cd = date.parse(crtdt.StartDate);
                        DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                        crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                    }
                    if(crtdt.EndDate != null && crtdt.EndDate != '') {
                        date cd = date.parse(crtdt.EndDate);
                        DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                        crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT));
                    }
                    //#85179    END
                    
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
                 
                 if(listofdeduct != null && listofdeduct.size()>0 && ProgramId != null){//GSSC-494
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
                        if(ExtendedWarrantyDedutibles != null || ExtendedWarrantyDedutibles != '')
                        {
                        	ExtendedWarrantyDedutiblesFlag = true;
                        }
                        break;
                         
                     }
                     
                 }
                 }
                 //S-205 END
                    
                    listcertificatedetails.add(crtdt);
                    system.debug('Certificate list' + listcertificatedetails);



                }
                if (listcertificatedetails.isEmpty()){
                    reqWrcertBoolean = true;
                    showExtCoverage = false;
                }
                else
                    showExtCoverage = true;
            }

            system.debug('certificate details' + listcertificatedetails);


            CSS_Job_Order__c srvjob = new CSS_Job_Order__c();
            srvjob.id = pgId;
            srvjob.Warranty_Start_Date__c = serviceJob.Warranty_Start_Date__c;
            srvjob.Region__c = serviceJob.Region__c;
            srvjob.Territory__c = serviceJob.Territory__c;
          /*  if (coverageDetailsSTR != '' && coverageDetailsSTR2 != '') {
                srvjob.EditCoverage__c = coverageDetailsSTR + coverageDetailsSTR2;
            } else if (coverageDetailsSTR != '' && coverageDetailsSTR2 == '') {
                srvjob.EditCoverage__c = coverageDetailsSTR;
            } else if (coverageDetailsSTR == '' && coverageDetailsSTR2 != '') {
                srvjob.EditCoverage__c = coverageDetailsSTR2;
            } else {
                srvjob.EditCoverage__c = '';
            } */

            if (serviceJob.BMSStatus__c != null && serviceJob.BMSStatus__c.contains('esnChanged')) {
                srvjob.BMSStatus__c = serviceJob.BMSStatus__c.replace(',esnChanged', '');
            }
            update srvjob;



            // Certificate details -- end
            SOQLServicejob();

        } catch (exception e) {
            system.debug('inside basic search' + e.getMessage() + 'in the line number' + e.getLineNumber());
        }
        return null;
    }
    public void updatetext() {
        if (serviceJob != null) {
            update serviceJob;
        }
    }

    public void milekmconv() {
        system.debug('Inside milekmconv method');
        system.debug('Inside milekmconve' + mil_measure);
        mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
        mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
        mapGroupCoverageByDefTypeRecEng = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
        coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
        coverageURLProceMap = new map < string, string > ();
        tempcoverageURLProceMap = new map < string, string > ();
        if (basicCoverageDetails != null) {
            for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                system.debug('c.CoverageType>>>>>>' + c.CoverageType);
                //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                if (c.CoverageType == 'EMS-Emissions Warranty') {
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                    tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                    //iterating the CoverageComponentList
                    for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                        //calculating miles    
                        system.debug('Inside for loop' + mil_measure);
                        system.debug('Inside for loop prevmil_measure' + prevmil_measure);
                        if (mil_measure != null && mil_measure != '') {
                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                system.debug('Inside Kilometers condition');
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 

                            }
                       /*     if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles')) {
                                system.debug('Inside Miles condition');
                                ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
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
                        if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {

                            mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                        }
                        mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                    } //end of inner 1 loop
                } //end of If cond
                system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefType);
                //if the coverage type is of NEW-New Engine Warranty
                if (c.CoverageType == 'NEW-New Engine Warranty') {
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                    tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                    //iterating the CoverageComponentList
                    for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                        //calculating miles                        
                        if (mil_measure != null && mil_measure != '') {
                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                System.debug('*******ccl.CoverageMiles first' + ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                            }
                        /*    if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles')) {
                                ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            } */
                                if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            }
                        }
                        //populating the map 
                        if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {

                            mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                        }
                        mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                    } //end of inner 2 loop
                } //end of if cond
                system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******' + mapGroupCoverageByDefTypeNewENG);
                
                //Code for Recon Engine Warranty Coverage Start
                
                if (c.CoverageType == 'REW-Recon Engine Warranty') {
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('REW-Recon Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                    //iterating the CoverageComponentList
                    for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                        //calculating miles                        
                        if (mil_measure != null && mil_measure != '') {
                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                System.debug('*******ccl.CoverageMiles first' + ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                            }
                         /*   if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles')) {
                                ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            } */
                                if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            }    
                        
                        }
                        //populating the map 
                        if (!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)) {

                            mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                        }
                        mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                    } //end of inner 2 loop
                } //end of if cond
                
                //Code for Recon Engine Warranty Coverage End
                
            } //end of outer for loop 

        } //end of If for null check of basicCoverageDetails
        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
        }
        
        if (mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()) {
            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecEng);
        }

        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
        }
        system.debug('vignesh>>>'+coverageByDefTypeMap);
        listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
        if (basicCoverageDetails != null) {
            for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {
                system.debug('** Inside Certificate For Loop');
                if (mil_measure != null && mil_measure != '') {
                    system.debug('** Inside after mil Measure null check');
                if(mil_measure.equalsIgnoreCase('Kilometers')){   
                    system.debug('** Inside Certificte mil Measure Kilometers');   
                    crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles)  * 1.609344);
                    string miletokm = crtdt.EndMiles;
                    system.debug('Testmiles'+miletokm);
                    crtdt.EndMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                    //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles)/0.621371).setScale(0));
                    //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles)/0.621371).setScale(0));
                    crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles)  * 1.609344);
                    string milestokm = crtdt.BeginMiles;
                    system.debug('Testmiles'+miletokm);
                    crtdt.BeginMiles= String.ValueOf((Decimal.valueOf(milestokm)).round(System.RoundingMode.CEILING)); 
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
        system.debug('***listcertificatedetails-->' + listcertificatedetails);
        //prevmil_measure = mileKmMeasure;
        system.debug('prevmil_measure Before' + prevmil_measure);
        prevmil_measure = mil_measure;
        system.debug('prevmil_measure After' + prevmil_measure);
        //system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);


    }

    //Added by shanthi - Story 85181 
    public string gettoken() {
        long currentTime = System.now().getTime();
        string token = 'CSS' + '|' + (String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }

    //Added by Ekta -Story 85177 
    public String getWarrCreatedDate() {

        //String locale_formatted_date_time_value = css_utility.getFormattedDate(warrentyStartD); //Get formatted String from Utility Class
        //Prabhakar Added below Code (19/03) for Defect#134296
        String locale_formatted_date_time_value = css_utility.getFormattedDateGMT(warrentyStartD); //Get formatted String from Utility Class
        if (locale_formatted_date_time_value != null)
            return locale_formatted_date_time_value.substring(0, 11); //return the string
        else
            return null;
    }

    //#85179    START 
    public String getWarrantyDate(DateTime dInputDate) {

        //String locale_formatted_date_time_value = css_utility.getFormattedDate(dInputDate); //Get formatted String from Utility Class
        //Prabhakar Added below Code (19/03) for Defect#134296
        String locale_formatted_date_time_value = css_utility.getFormattedDateGMT(dInputDate); //Get formatted String from Utility Class
        if (locale_formatted_date_time_value != null)
            return locale_formatted_date_time_value.substring(0, 11); //return the string
        else
            return null;
    }
    //#85179    END
}