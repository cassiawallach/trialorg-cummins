/**********************************************************************
Name:CG_CL_ClaimsWarrantyComp
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this component Controller .
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                DATE                DETAIL                                 
1.0 -    Rajesh Pasupuleti     02/06/2018          INITIAL DEVELOPMENT  
1.1 -    Surender M            02/19/2018          Added Warranty Coverage Search functionality
1.2 -    Rupesh Pande          02/20/2018          Fixed all Validations
2.0 -    Rajesh Pasupuleti     02/21/2018          Added code for Page Load
***********************************************************************/
public class CG_CL_ClaimsWarrantyComp
{
    //Global Veriables
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}

    public CG_CL_ClaimsWarranty mainContr{set; get;} //stopped using

    public Boolean reqWrAppBoolean{get;set;}
    public Boolean reqWrWarBoolean{get;set;}
    public Boolean reqWrEsnBoolean{get;set;}
    public Boolean reqWrRegBoolean{get;set;}
    public Boolean reqWrTerBoolean{get;set;}
    public Boolean showWarrDetailsSection{get;set;}
    public Boolean reqWrcoverBoolean{get;set;}
    public Boolean reqWrcertBoolean{get;set;}
    public Boolean showExtCoverage{get;set;}
    public string dealer{get;set;}
    public Boolean myFlag{get; set;}
    //public String MileageKmVal{get;set;}
    //public DateTime warrentyStartD{get;set;} //stopped using
    public String myBase64String{get;set;}

    public List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public Map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> coverageByDefTypeMap{get;set;}
    public Map<String, List <CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG{get;set;}
    public Map<String, List <CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeRecEng{get;set;}
    public Map<String, List <CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefType{get;set;}

    public string mil_measure{get;set;}
    public string defValue{get;set;} 

    //public CSS_PSN__c PSNJob ;
    //public string MileageKmVal{get;set;}
    //Public String selectedAppCode{get;set;} 
    //public CSS_Claims__c ClaimsJob{get;set;}

    public string prevmil_measure;
    public String UnitMiles;
    public String PointMiles;
    public String UnitKilometers;
    public String PointKilometers;
    public String UnitHours;
    public String PointHours;
    //public string applicationCode;

    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public map < string, string > coverageURLProceMap{get;set;}
    public map < string, string > tempcoverageURLProceMap{get;set;}
    public boolean emissionStatus {get;set;}
    public Boolean coverageFlag{get; set;}
    public string Region{get;set;} 
    public string Territory{get;set;} 
    public Map<String,string> milesHolder = new Map<String,string>();//
    
    public String EmmisionWarrantyDedutibles{get; set;}
    public String ExtendedWarrantyDedutibles{get; set;}
    public String ReconWarrantyDedutibles{get; set;}
    public String NewEngWarrantyDedutibles{get; set;}
    
    public Boolean NewEngWarrantyDedutiblesFlag{get; set;}
    public Boolean EmmisionWarrantyDedutiblesFlag{get; set;}
    public Boolean ExtendedWarrantyDedutiblesFlag{get; set;}
    public Boolean ReconWarrantyDedutiblesFlag{get; set;}
    
    //constructor
    public CG_CL_ClaimsWarrantyComp()
    {
        try{
            coverageFlag=false;
            System.debug('IN CG_CL_ClaimsWarrantyComp constructor...');
            //try {
            //In Place of service job id we have claim id from page URL
            cId = ApexPages.CurrentPage().getParameters().get('id');
            //serviceJob = new CSS_Job_Order__c();
            system.debug('cId>>>>>>>>>>>>>>>>>' + cId);

            //system.debug('mainContr>>>>>>>>>>>>>>>>>' + mainContr);
        //system.debug(' mainContr.claimsRec>>>>>>>>>>>>>>>>>' +  mainContr.claimsRec);
            myFlag=false;
            showWarrDetailsSection = true;
            showExtCoverage = false;
            NewEngWarrantyDedutiblesFlag = false;
            EmmisionWarrantyDedutiblesFlag = false;
            ExtendedWarrantyDedutiblesFlag = false;
            ReconWarrantyDedutiblesFlag = false;
            if(cId == null) {
                claimsRec = new CSS_Claims__c();
                psnRec = new CSS_PSN__c();
            } else 
            {
                //list<css_claims__c>claimsRec=[select id,Location_Code__c from css_claims__c];
                SOQLClaimsJob();
                //Populating Reegion Territory from Account for Auto Claims
                //if(claimsRec.css_job__c != null && claimsRec.css_job__c != '')
                if(claimsRec.css_job__c != null)
                {
                    if((claimsRec.Region__c == null || claimsRec.Region__c == '') || (claimsRec.Territory__c == null || claimsRec.Territory__c == ''))
                        regionTerritory();
                    system.debug('After Region Method ESN>>>>>>>>>>>>>>>>>>>>>'+claimsRec.ESN__c);

                }
                //NEW STORY TO BE REQUESTED
                /********************************************************************************************************************************************/
                //If the Claim does not have the service Job
                else
                {
                    system.debug('claimsRec.Location_Code__c--'+claimsRec.Location_Code__c);
                    Account RegionTerritory = css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
                    claimsRec.Region__c = RegionTerritory.Region__c;
                    claimsRec.Territory__c = RegionTerritory.Territory__c;
                    Region=RegionTerritory.Region__c;
                    Territory=RegionTerritory.Territory__c;
                }


                /********************************************************************************************************************************************/
                defValue = psnRec.Mileage_Measure__c;
                mil_measure = defValue;
                loadBasicData();
                system.debug('claimsRec22>>>>:'+claimsRec);
                system.debug('psnRec22>>>>:'+psnRec);
                system.debug('mil_measure'+ mil_measure);
            }
            /*}catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsWarrantyComp constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }*/
            System.debug('returning from CG_CL_ClaimsWarrantyComp constructor...');
            dealer = css_utility.getOrgType(userInfo.getUserID());
            if(dealer == 'DLR')
                coverageSearch();

        }catch(exception e){
            system.debug('Entered into catch of constructor method in css_ClaiwarrantyComp >>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }

    }
    public void regionTerritory()
    {
        try{
            css_job_order__c servicejob = new css_job_order__c();
            servicejob = [select id,Creator_Location__c from css_job_order__c where id = :claimsRec.css_job__c];
            /****** Calling the Utility Method to query region and territory values from Account based on user Location ******/
            Account RegionTerritory = css_utility.getRegionTerritory((servicejob ==null ? '': servicejob.Creator_Location__c));
            //RegionTerritory=css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
            system.debug('RegionTerritory>>>>>>>>>>>'+RegionTerritory.Region__c);
            //serviceJob.Region__c = '--None--';
            claimsRec.Region__c = RegionTerritory.Region__c;
            claimsRec.Territory__c = RegionTerritory.Territory__c;
            Region=RegionTerritory.Region__c;
            Territory=RegionTerritory.Territory__c;
        }catch(exception e)
        {
            system.debug('Entered into catch of Region Territory method in css_warranty>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    public void loadBasicData() {
        system.debug('in loadBasicData method claimsRec>>>>:'+claimsRec);
        try {

            if (claimsRec != null) 
            {
                emissionStatus = false;
                prevmil_measure = mil_measure;

                Date faildate=psnRec.Failure_Date__c;  // Story 164795
                Date warrantydate=psnRec.Warranty_Start_Date__c; 
                //String Monthsbwfaildatewarrdate =String.valueOf(warrantydate.monthsBetween(faildate)); 
                //system.debug('Months'+Monthsbwfaildatewarrdate);
                Double days;
                if(warrantydate != null)
                    days = (warrantydate.daysBetween(faildate));
                else
                    days = 0;
                if(psnRec.Mileage__c ==null){
                psnRec.Mileage__c = 0;
                }
                if(psnRec.Product_Hours__c ==null){
                	psnRec.Product_Hours__c = 0;
                }
                Double Monthsbwfaildatewarrdate = days/30.417;
                system.debug('Days for warranty'+days);
                system.debug('Months for warranty'+Monthsbwfaildatewarrdate);
                string ProductMileage;
                string ProductMeasure;
                string Mile;
                
                //Story # 190403 - Start
                    if(psnRec.Mileage__c != null && Integer.valueOf(psnRec.Mileage__c) > 0) {
                        if(psnRec.Mileage_Measure__c != null && psnRec.Mileage_Measure__c == 'Miles') {
                            UnitMiles = 'Miles';
                            PointMiles = '' + psnRec.Mileage__c;
                            UnitHours = 'Hours';
                            PointHours = ''+psnRec.Product_Hours__c;
                        } else {
                            //convert into KM
                            
                           /* Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 0.621371).setScale(0));  
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Miles'; */
                            Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 1.60934).setScale(0));
                            // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                            //Mile = '' + psnRec.Mileage__c; // Added by vamshi
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                            UnitHours = 'Hours';
                            PointHours = ''+psnRec.Product_Hours__c;
                        }
                    } else {
                        //reqDA.FailurePoint = ''+ psnRec.CSS_Hours__c; // Here what is CSS_Hours__c???
                        if(psnRec.Product_Hours__c!=null){
                        UnitHours = 'Hours';
                        PointHours = ''+psnRec.Product_Hours__c;
                        if(mil_measure != null && mil_measure == 'Miles'){
                            UnitMiles = 'Miles';
                            PointMiles = '' + psnRec.Mileage__c;
                        }
                        else{
                            Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 1.60934).setScale(0));
                            // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                            //Mile = '' + psnRec.Mileage__c;
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                        }
                    }
                    } //Story # 190403 - END
                
                 // Story 190403 - Start
                if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410')
                {
                ProductMileage = string.valueof(psnRec.Mileage__c);
                ProductMeasure = psnRec.Mileage_Measure__c;
                }
                else{
                ProductMileage = string.valueof(psnRec.Product_Hours__c);
                ProductMeasure = 'Hours';
                }
                // Story 190403 - END 

                if (claimsRec.CoverageResponse__c != null && claimsRec.CoverageResponse__c != '') {
                    basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                    basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(claimsRec.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                    system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                    system.debug('basicCoverageDetails>>>>>>' + basicCoverageDetails);
                    //Building map mapGroupCoverageByDefType
                    mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    mapGroupCoverageByDefTypeRecEng = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                    coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
                    coverageURLProceMap = new map < string, string > ();
                    tempcoverageURLProceMap = new map < string, string > ();
                    reqWrcoverBoolean = true;
                    Date curDate = Date.today();
                    //Setting wsd for logic calculation inside the method loadBasicData
                    if(psnRec.Before_In_Service__c==true)
                        psnRec.Warranty_Start_Date__c=psnRec.Failure_Date__c;
                    system.debug('Coverage Details--'+basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails);
                    for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        system.debug('c.CoverageType>>>>>>' + c.CoverageType);
                        //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                        if (c.CoverageType == 'EMS-Emissions Warranty') {
                            reqWrcoverBoolean = false;
                            //URl and Procedure Map Values
                            coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                            tempcoverageURLProceMap.put(c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                            //iterating the CoverageComponentList
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                   //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                               {    //Story 164795   

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
                                    System.debug('MK-->'+psnRec.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                    If(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0 ){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{ 
                                           
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        }
                                    } //Story 164795 
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                } 
                                    //  Removed addDays(-1) as per story 189584
                                   // ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                    ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                    system.debug('Coverage Satish --> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));

                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    if(Test.isRunningTest()){
                                        UnitMiles='Miles';
                                      
                                    }
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
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);

                                            If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                                If(cd >= curDate){
                                                    ccl.status = 'Active';
                                                }else{
                                                    ccl.status = 'Expired';
                                                }
                                            }

                                            System.debug('Before calculation1...cd>>>:'+cd);

                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
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
                            tempcoverageURLProceMap.put(c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck' + c.CoverageType);
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                               {    //Story 164795   
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
                                    System.debug('MK-->'+psnRec.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                    If(Decimal.valueOf(ccl.CoverageHours) == 9999999 )
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0 ){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                            
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        } 
                                    //   ccl.WarrantyEndDate = (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).format() ;
                               } // Story 164795
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                } 
                                //  Removed addDays(-1) as per story 189584
                                  //  ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                    ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                    system.debug('Coverage Satish2 --> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));


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
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);

                                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                        ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */

                                            //Years, Months, Days calculation below
                                            System.debug('Before calculation2...cd>>>:'+cd);
                                            //ccl.remaining = CSS_Utility.calculateYearsMonthsDays(System.Today(), cd);

                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                        }
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
                                    //if(NewEngWarrantyDedutibles == null || NewEngWarrantyDedutibles == '')
                                    if(NewEngWarrantyDedutibles !=null || NewEngWarrantyDedutibles != '')
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
                            tempcoverageURLProceMap.put(c.WarrantyManualURL + c.ProcedureNumber,'REW-Recon Engine Warranty');
                            //iterating the CoverageComponentList
                            system.debug('new engine typecheck' + c.CoverageType);
                            for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                               {    //Story 164795   
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
                                    System.debug('MK-->'+psnRec.Mileage__c +' '+ Decimal.valueOf(ccl.CoverageMiles));

                                   If(Decimal.valueOf(ccl.CoverageHours) == 9999999 )
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0 ){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                           
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        } 
                                    //   ccl.WarrantyEndDate = (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).format() ;
                               } // Story 164795
                                else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                { 
                                    system.debug('Testing Months');
                                    ccl.status = 'Active';
                                } 
                                //  Removed addDays(-1) as per story 189584
                                   // ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                    ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                    system.debug('Coverage Satish2 --> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));

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
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0) )
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
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);

                                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                        ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */

                                            //Years, Months, Days calculation below
                                            System.debug('Before calculation2...cd>>>:'+cd);
                                            //ccl.remaining = CSS_Utility.calculateYearsMonthsDays(System.Today(), cd);

                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                        }
                                    }



                                //#85179    END
                                //populating the map
                                ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                if (!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)) {
                                    mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                }
                                mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                                system.debug('Test122'+mapGroupCoverageByDefTypeRecEng);
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
                                	
                                //	if(ReconWarrantyDedutibles == null || ReconWarrantyDedutibles == '')
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
                    if(mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()){
                    coverageByDefTypeMap.put('C-Recon Engine Warranty',mapGroupCoverageByDefTypeRecEng);
                    system.debug('Test122'+coverageByDefTypeMap);
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
                crtdt.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(crtdt.EndDate));
                        //#85179    START

                        System.debug('crtdt.StartDate>>>:'+crtdt.StartDate); // StartDate format: 10/14/2013
                        System.debug('crtdt.EndDate>>>:'+crtdt.EndDate); // StartDate format: 10/14/2018
                        if(crtdt.StartDate != null && crtdt.StartDate != '') {
                            system.debug('before crtdt.StartDate11->>>:'+crtdt.StartDate);
                            //date cd = date.valueof(crtdt.StartDate);
                            //datetime cd = date.valueof(crtdt.StartDate + '00:000:00');
                            //string cdstr = (date.valueof(crtdt.StartDate)).format('mm/dd/yyyy');
                            try{
                                Date cd = Date.parse(crtdt.StartDate);
                                crtdt.StartDate = getFormattedDate(cd);
                                system.debug('after crtdt.StartDate11->>>:'+cd);
                                /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT));*/
                            }catch(Exception e)  {
                                system.debug('EXCEPTION occured while converting  11 Start Date in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
                            }
                        }

                        if(crtdt.EndDate != null && crtdt.EndDate != '') {
                            try{
                                date cd1 = Date.parse(crtdt.EndDate);
                                crtdt.EndDate = getFormattedDate(cd1);
                                system.debug('after crtdt.EndDate 22->>>:'+cd1);
                                /*DateTime mydateGMT1 =  dateTime.newInstance(date.newInstance(cd1.year(), cd1.month(), cd1.day()), time.newInstance(00, 00, 00, 00));
                                crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT1)); */

                                //Years, Months, Days calculation below
                                //crtdt.remaining = CSS_Utility.calculateYearsMonthsDays(System.Today(), cd1);

                            }catch(Exception e)  {
                                system.debug('EXCEPTION occured while converting 22 End Date in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
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
                 if(listofdeduct != null  && listofdeduct.size()>0){
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

                        //#85179    END
                        listcertificatedetails.add(crtdt);


                    }
                    if (listcertificatedetails.isEmpty()){
                        reqWrcertBoolean = true;
                        showExtCoverage = false;
                    }
                    else{
                        showExtCoverage = true;
                        // psnrec.CoverageFlag__c = false;                        
                        system.debug('certificate details' + listcertificatedetails);
                        // UpdatePSNRecord();
                        // Certificate details -- end
                    }
                    //Reset wsd value back
                    if(psnRec.Before_In_Service__c==true)
                        psnRec.Warranty_Start_Date__c=null;
                }
                reqWrTerBoolean = false;
            }
            //              }
            //          }    
            //showWarrDetailsSection = false; //temporarily added need to delete ???
        } catch (exception e) {
            system.debug('in loadBasicData EXCEPTION of CG_CL_Claimswarranty >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }



    public pagereference coverageSearch() 
    {
        emissionStatus = false;
        String coverageDetailsSTR = '';
        String coverageDetailsSTR2 = '';
        //String mil_measure;
        //String prevmil_measure;
        String applicationCode;
        String SelectedAppCode = psnRec.Application__c;
        //CSS_getBasicCoverageResponseJ2A basicCoverageDetails;
        map < string, string > coverageURLProceMap;
        //DateTime warrentyStartD;
        String mileKmMeasure;
        Integer coverageMaxMonth;
        string ProductMileage;
        string ProductMeasure;

        try 
        {
            Account RegionTerritory = css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
            claimsRec.Region__c = RegionTerritory.Region__c;
            claimsRec.Territory__c = RegionTerritory.Territory__c;
            system.debug('Region&Territory--'+claimsRec.Region__c+' '+claimsRec.Territory__c);

            Date faildate=psnRec.Failure_Date__c;  // Story 164795
            Date warrantydate=psnRec.Warranty_Start_Date__c; 
            system.debug('warrantydate'+warrantydate);
            //String Monthsbwfaildatewarrdate =String.valueOf(warrantydate.monthsBetween(faildate)); 
            Double days;
            if(warrantydate != null)
                days=(warrantydate.daysBetween(faildate));
            else
                days = 0;
            if(psnRec.Mileage__c ==null){
                psnRec.Mileage__c = 0;
            }
            if(psnRec.Product_Hours__c ==null){
            	psnRec.Product_Hours__c = 0;
            }
            Double Monthsbwfaildatewarrdate = days/30.417;
            system.debug('Days for warranty'+days);
            system.debug('Months for warranty'+Monthsbwfaildatewarrdate);

            /*App code error start*/
            system.debug('AppCode***' + SelectedAppCode);
            if (SelectedAppCode == null || SelectedAppCode == '' || SelectedAppCode == '--None--') {
                reqWrAppBoolean = true;
                return null;
            } 
            else 
            {
                reqWrAppBoolean = false;
            }
            /*App code error end*/

            /*Warranty ST Date error start*/
            system.debug('psnRec.Warranty_Start_Date__c***' + psnRec.Warranty_Start_Date__c);
            if (psnRec.Warranty_Start_Date__c == null && psnRec.Before_In_Service__c!=true) {
                reqWrWarBoolean = true;
                return null;
            } 
            else 
            {
                reqWrWarBoolean = false;
            }
            /*Warranty ST Date error end*/


            /*PSN error Start*/
            system.debug('psnRec..ESN__c***' + psnRec.PSN__c);
            if (psnRec.PSN__c == null || psnRec.PSN__c == '') {
                reqWrEsnBoolean = true;
                return null;
            } 
            else 
            {
                reqWrEsnBoolean = false;
            }
            /*PSN error end*/

            /*Region error start*/
            system.debug('claimsRec.Region__c***' + claimsRec.Region__c);
            if (claimsRec.Region__c == null || claimsRec.Region__c == '' || claimsRec.Region__c == '--None--') {
                reqWrRegBoolean = true;
                return null;
            } 
            else 
            {
                reqWrRegBoolean = false;
            }
            /*Region error end*/


            /*Territory error start*/
            system.debug('claimsRec.Territory__c***' + claimsRec.Territory__c);
            if (claimsRec.Territory__c == null || claimsRec.Territory__c == '' || claimsRec.Territory__c == '--None--') {
                system.debug('checking the boolean value');
                reqWrTerBoolean = true;
                return null;
            } 
            /*Territory error end*/
            else 
                //Starting Integration to search Warranty
            {
                system.debug('Inside');
                //mil_measure = 'Miles';
                mil_measure = defValue;
                system.debug('mil_measure in RB' + mil_measure);
                prevmil_measure = mil_measure;
                system.debug('prevmil_measure in coveragesearch' + mil_measure);
                CSS_getBasicCoverageReqJ2A getBasicCoverageReq = new CSS_getBasicCoverageReqJ2A();
                CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                if (psnRec != null) {
                    psnrec.CoverageFlag__c = false;
                    reqDA.ESN = psnRec.PSN__c;
                    reqDA.Region = claimsRec.Region__c;
                    reqDA.Territory = claimsRec.Territory__c;
                    Region=reqDA.Region;
                    Territory=reqDA.Territory;
                    reqDA.ReconFlag = claimsRec.ReconEngineFlag__c;  //added as per the story 156820
                    reqDA.JObId = psnRec.id; // Check Claim Id Here????
                    system.debug('SelectedAppCode******>>>>' + SelectedAppCode);
                    //We are able to call web service when we specify code but Css utility is not returning the code gives exception though values are passed correctly.
                    applicationCode = css_utility.getCodes('Application Code', SelectedAppCode, null, null);
                    system.debug('apllication code' + applicationCode);
                    reqDA.EngineApplicationCode = applicationCode; //'130';// Please call CSS_Utility.getCodes()
                    /*Date d = psnRec.Warranty_Start_Date__c;
                    string warantySDate = DateTime.newInstance(d.year(), d.month(), d.day()).format('MM/d/YYYY');
                    reqDA.WarrantyStartDate = warantySDate; //'5/1/2010';//String.Valueof(workJob.Warranty_Start_Date__c);*/

                    Date d;
                    string Mile;
                    string warantySDate;
                    if(psnRec.Before_In_Service__c==false){
                        d = psnRec.Warranty_Start_Date__c;
                        //'5/1/2010';//String.Valueof(workJob.Warranty_Start_Date__c);
                    }
                    else if(psnRec.Before_In_Service__c==true){
                        d = psnRec.Failure_Date__c;
                    }
                    if(d!=null){
                        warantySDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/d/YYYY');
                    }
                    reqDA.WarrantyStartDate = warantySDate;

                    //#85179START
                    //Included > 0 condition in the below IF to check for a valid vlaue.
                    //Story # 190403 - Start
                    if(psnRec.Mileage__c != null && Integer.valueOf(psnRec.Mileage__c) > 0) {
                        if(psnRec.Mileage_Measure__c != null && psnRec.Mileage_Measure__c == 'Miles') {
                            reqDA.FailurePoint = '' + psnRec.Mileage__c;
                            reqDA.FailureUnit = 'Miles';
                            UnitMiles = 'Miles';
                            PointMiles = '' + psnRec.Mileage__c;
                            UnitHours = 'Hours';
                            PointHours = ''+psnRec.Product_Hours__c;
                        } else {
                            //convert into KM
                            
                           /* Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 0.621371).setScale(0));  
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Miles'; */
                            //Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 1.60934).setScale(0));
                             // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.

                            Mile = '' + psnRec.Mileage__c;
                            reqDA.FailurePoint = Mile;
                            reqDA.FailureUnit = 'Kilometers';
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                            UnitHours = 'Hours';
                            PointHours = ''+psnRec.Product_Hours__c;
                        }
                    } else {
                        //reqDA.FailurePoint = ''+ psnRec.CSS_Hours__c; // Here what is CSS_Hours__c???
                        reqDA.FailureUnit = 'Hours';
                        reqDA.FailurePoint = ''+psnRec.Product_Hours__c;
                        UnitHours = 'Hours';
                        PointHours = ''+psnRec.Product_Hours__c;
                        if(mil_measure != null && mil_measure == 'Miles'){
                            UnitMiles = 'Miles';
                            PointMiles = '' + psnRec.Mileage__c;
                        }
                        else{
                            //Mile = String.ValueOf((integer.valueOf(psnRec.Mileage__c) * 1.60934).setScale(0));
                            // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.

                            Mile = '' + psnRec.Mileage__c;
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                        }
                    } //Story # 190403 - END
                    
                    // Story 190403 - Start
                    
                    if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410')
                    {
                    ProductMileage = string.valueof(psnRec.Mileage__c);
                    ProductMeasure = psnRec.Mileage_Measure__c;
                    }
                    else{
                    ProductMileage = string.valueof(psnRec.Product_Hours__c);
                    ProductMeasure = 'Hours';
                    }
                    // Story 190403 - END 

                    //#85179END
                    getBasicCoverageReq.DataArea = reqDA;
                    system.debug('reqDA.Region' + getBasicCoverageReq);
                    system.debug('CoverageFlag__ccoverageFlag' +coverageFlag);
                    /*Called getClaimsBasicCoverage function as it is being added in CSS_WS_SBL class seperately to handle claims warranty data.*/
                   if(!Test.isRunningTest()){
                    basicCoverageDetails = CSS_WS_SBL.getClaimsBasicCoverage(getBasicCoverageReq,coverageFlag);
                   } else{
                      //basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                      httpResponse res_test = new httpResponse();
                        //String basicCoverageDetails_Test='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
                        //String basicCoverageDetails_Test = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';
                       //String basicCoverageDetails_Test = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';
String basicCoverageDetails_Test='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"1/16/2020","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-029","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"9999999","CoverageMaxMonths":"24","CoverageComponentTypeCode":"STRT/ALT","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"0"},{"CoverageHours":"10000","CoverageMaxMonths":"36","CoverageComponentTypeCode":"EXTENDED","MegawattHours":"0","CoverageDefenitionType":"EXTENDED","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"2000","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"12","CoverageMiles":"10"},{"CoverageHours":"500","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"BASE","BeginMonths":"25","FirstVisitAmt":"100","ProgramID":"","BeginMiles":"0","BeginMegawattHours":""}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-072.html","WarrantyEndDate":"1/16/2022","CoverageType":"REW-Recon Engine Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"10"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"0"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"IC3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"CN3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"HM3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT1","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MT2","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"UPI","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"0","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"MRR","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"100","SubsequentVisitAmt":"0","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"0","ProgramID":"MR3","BeginMiles":"0","BeginMegawattHours":""},{"BeginHours":"0","ConstantDecutibleAmt":"200","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"","ProgramID":"TF3","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"100","ProgramID":"MRQ","BeginMiles":"0","BeginMegawattHours":"0"},{"BeginHours":"0","ConstantDecutibleAmt":"","SubsequentVisitAmt":"","CoverageDefTypeCode":"EXTENDED","BeginMonths":"0","FirstVisitAmt":"200","ProgramID":"TF2","BeginMiles":"0","BeginMegawattHours":"0"}]},"CAPCoverageID":"ICX","ProgramID":"TF3","BeginMiles":"0","EndDate":"01/16/2022","StartDate":"01/16/2017","BeginHours":"0","EndMiles":"9999999","CertificateNumber":"TF31000964","EndHours":"9999999","ProcedureNumber":"111-505-145"}]}}}}';
                      res_test.setBody(basicCoverageDetails_Test);
                      
                       basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(res_test.getBody(), CSS_getBasicCoverageResponseJ2A.class);
                        system.debug('Testdate'+basicCoverageDetails);
                    }
                    system.debug('reqDA.Region' + reqDA.Region);
                    System.debug('basicCoverageDetails Response>>>:'+basicCoverageDetails);
                    if (basicCoverageDetails==null || basicCoverageDetails.Header==null || basicCoverageDetails.Header.Status==null ||  (basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfCoverageDetails.CoverageDetails.size() == 0 &&
                                                                                                                                         basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails.size() == 0) ) {
                        showWarrDetailsSection = false;
                    }

                    else 
                    {//22-Feb-2018 - Shreerath - setting coverage Flag = false
                        showWarrDetailsSection = true;
                        system.debug('basicCoverageDetails' + basicCoverageDetails.Header);
                        system.debug('basicCoverageDetails>>>>>>:' + basicCoverageDetails);
                        //Building map mapGroupCoverageByDefType
                        mapGroupCoverageByDefType = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        mapGroupCoverageByDefTypeNewENG = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        mapGroupCoverageByDefTypeRecEng = new map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >> ();
                        coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
                        coverageURLProceMap = new map < string, string > ();
                        tempcoverageURLProceMap = new map < string, string > ();

                        Date curDate = Date.today();
                        //Setting the WSD value for below logic calculation 
                        if(psnRec.Before_In_Service__c==true)
                            psnRec.Warranty_Start_Date__c=psnRec.Failure_Date__c;
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

                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {    //Story 164795   
                                        //calculating miles
                                        system.debug('Testmesure'+mil_measure);                               
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
                                        // ccl.status = c.status;
                                        //ccl.WarrantyEndDate = c.WarrantyEndDate;

                                        If(Decimal.valueOf(ccl.CoverageHours) == 9999999.0)
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0.0 ){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{ 
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        }
                                    } //Story 164795
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    } 

                                       //  Removed addDays(-1) as per story 189584
                                       //  ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                       ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                        system.debug('Coverage Satish 3--> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                        ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));

                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'PointHours'+UnitMiles+'PointMiles'+PointMiles);
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
                                            try{
                                                date cd = date.parse(ccl.WarrantyEndDate);
                                                ccl.WarrantyEndDate = getFormattedDate(cd);

                                                If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                                    If(cd >= curDate){
                                                        ccl.status = 'Active';
                                                    }else{
                                                        ccl.status = 'Expired';
                                                    }
                                                }

                                            }catch(Exception e)  {
                                                system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
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
                                system.debug('Trestcovdect'+c.ListOfCoverageDedutibles.CoverageDedutibles);
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()>0 )
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                                }
                                
                                // S-205 END
                                
                                system.debug('initialtestresp@@@@@' + coverageDetailsSTR);
                            } //end of If cond
                            system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefType);
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
                                    system.debug('Test2@@'+coverageDetailsSTR2);
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))

                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {    //Story 164795   

                                        //calculating miles
                                        system.debug('Test2@@**');
                                        system.debug('Test2@@**'+mil_measure);
                                        if (mil_measure != null && mil_measure != '') {
                                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                                milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                                string miletokm = ccl.CoverageMiles;
                                                system.debug('Testmiles'+miletokm);
                                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                            }
                                        }
                                        system.debug('Test2@@**'+mil_measure);
                                        if(mil_measure != null && mil_measure != ''){
                                            if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                             system.debug('Test2@@22**'+milesHolder);
                                            }
                                         }
                                        
                                        coverageDetailsSTR2 = coverageDetailsSTR2 + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                        //#85179    START
                                        // ccl.status = c.status;
                                        //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                        If(Decimal.valueOf(ccl.CoverageHours) == 9999999 )
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0 ){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        } 
                                        //if(psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))     
                                        //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    } // Story 164795
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }
                                    
                                    //  Removed addDays(-1) as per story 189584
                                     //    ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                       ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                        system.debug('Coverage Satish 4--> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);  
                                        ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));

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
                                            try{
                                                date cd = date.parse(ccl.WarrantyEndDate);
                                                ccl.WarrantyEndDate = getFormattedDate(cd);
                                                /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                            ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                                            }catch(Exception e)  {
                                                system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                            }
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
                            
                            //Code for Recon Engine Warranty Coverage start
                            
                            if (c.CoverageType == 'REW-Recon Engine Warranty') {
                                system.debug('Inside');
                                reqWrcoverBoolean = false;
                                system.debug('covgtyperespcheck' + c.CoverageType);
                                system.debug('initialtestresp' + coverageDetailsSTR);
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('REW-Recon Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'REW-Recon Engine Warranty');
                                //iterating the CoverageComponentList
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))

                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {    //Story 164795   

                                        //calculating miles
                                        if (mil_measure != null && mil_measure != '') {
                                            if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                                milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
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
                                        If(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                            if (curDate < (psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && psnRec.Mileage__c <= Decimal.valueOf(ccl.CoverageMiles) && psnRec.Product_Hours__c <= Decimal.valueOf(ccl.CoverageHours)){
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        }
                                        //if(psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))     
                                        //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    } // Story 164795
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }
                                    
                                    //  Removed addDays(-1) as per story 189584
                                        //  ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))).addDays(-1)).format() ;
                                      ccl.WarrantyEndDate = ((psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;
                                        system.debug('Coverage Satish 4--> '+ psnRec.Warranty_Start_Date__c +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);  
                                        ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));

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
                                            try{
                                                date cd = date.parse(ccl.WarrantyEndDate);
                                                ccl.WarrantyEndDate = getFormattedDate(cd);
                                                /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                            ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                                            }catch(Exception e)  {
                                                system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                            }
                                        }


                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                                    system.debug('Test222'+mapGroupCoverageByDefTypeRecEng);
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
                        system.debug('initialtestresp######@@@@@@' + coverageDetailsSTR);


                        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
                            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
                        }

                        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
                            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
                        }
                        
                        if (mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()) {
                            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecEng);
                        }
                        
                        //Reset the WSD value back.
                        if(psnRec.Before_In_Service__c==true)
                            psnRec.Warranty_Start_Date__c=null;
                    }
                }
                reqWrTerBoolean = false;
            }
            // system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
            // Certificate details -- start
            listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
            if (basicCoverageDetails != null) {
                reqWrcertBoolean = false;
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
                    crtdt.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(crtdt.EndDate));
                    
                    
                    //#85179    START

                    if(crtdt.StartDate != null && crtdt.StartDate != '') {
                        try{
                            date cd = date.parse(crtdt.StartDate);
                            crtdt.StartDate = getFormattedDate(cd);
                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                        }catch(Exception e)  {
                            system.debug('EXCEPTION occured while converting crtdt.StartDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                        }
                    }
                    if(crtdt.EndDate != null && crtdt.EndDate != '') {
                        try{
                            date cd = date.parse(crtdt.EndDate);
                            crtdt.EndDate = getFormattedDate(cd);
                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                        }catch(Exception e)  {
                            system.debug('EXCEPTION occured while converting crtdt.StartDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
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
                 if(listofdeduct != null  && listofdeduct.size()>0){
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

                    //#85179    END
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
            // Certificate details -- end

            //why do we need below code for Update since already doing in CSS_WS_SBL ???
            CSS_Claims__c claimsNewRec = new CSS_Claims__c();
            claimsNewRec.id = claimsRec.Id;
            claimsNewRec.Region__c = claimsRec.Region__c;
            claimsNewRec.Territory__c = claimsRec.Territory__c;

           /* String covRespTemp;
            if (coverageDetailsSTR != '' && coverageDetailsSTR2 != '') {
                //claimsNewRec.EditCoverage__c = coverageDetailsSTR + coverageDetailsSTR2;
                covRespTemp = coverageDetailsSTR + coverageDetailsSTR2;
            } else if (coverageDetailsSTR != '' && coverageDetailsSTR2 == '') {
               // claimsNewRec.EditCoverage__c = coverageDetailsSTR;
                covRespTemp = coverageDetailsSTR;
            } else if (coverageDetailsSTR == '' && coverageDetailsSTR2 != '') {
               // claimsNewRec.EditCoverage__c = coverageDetailsSTR2;
                covRespTemp = coverageDetailsSTR2;
            } else {
                //claimsNewRec.EditCoverage__c = '';
                covRespTemp = '';
            } */
            system.debug('coverageFlag-->'+coverageFlag);
            if(coverageFlag==true)
                update claimsNewRec;

            //22-feb-2018- Shreerath - update the PSN Record for resetting the Coverage Flag
            CSS_PSN__c psnNewRec = new CSS_PSN__c();
            psnNewRec.Id = psnRec.Id;
            System.debug('psnRec.CoverageFlag__c>>:'+psnRec.CoverageFlag__c);
            psnNewRec.CoverageFlag__c = psnRec.CoverageFlag__c;      
            //psnNewRec.Warranty_Start_Date__c = psnRec.Warranty_Start_Date__c;
            if(coverageFlag==true)
                update psnNewRec;

            SOQLClaimsJob(); //to retrive updated info

        } catch (exception e) {
            system.debug('Exception occured inside basic coverageSearch getMessage>>>:' + e.getMessage()+' getLineNumber>>>>:'+e.getLineNumber());
        }
        System.debug('final showWarrDetailsSection>>>:'+showWarrDetailsSection);
        return null;
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
        System.debug('in milekmconv basicCoverageDetails>>>:'+basicCoverageDetails);
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
                            if (prevmil_measure != null && prevmil_measure != '' && mil_measure != null && mil_measure != '' && mil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
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
                
            } //end of outer for loop 

        } //end of If for null check of basicCoverageDetails
        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);

        }

        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
        }
        
         if (mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()) {
            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecEng);
        }
        system.debug('coverageByDefTypeMap>>>'+coverageByDefTypeMap);
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


    /*
    public String getWarrantyDate(DateTime dInputDate) {
        String locale_formatted_date_time_value = css_utility.getFormattedDate(dInputDate); //Get formatted String from Utility Class
        if (locale_formatted_date_time_value != null)
            return locale_formatted_date_time_value.substring(0, 11); //return the string
        else
            return null;
    }*/

    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Miles', system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers', system.Label.CSS_Kilometers));
        return options;
    }

    public string gettoken() {
        long currentTime = System.now().getTime();
        string token = 'CSS' + '|' + (String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }

    /* commented below method bcz created duplicate method below for this
    public String getWarrCreatedDate() {
        System.debug('warrentyStartD>>>:'+warrentyStartD);
        String locale_formatted_date_time_value = css_utility.getFormattedDate(warrentyStartD); //Get formatted String from Utility Class
        System.debug('locale_formatted_date_time_value>>>:'+locale_formatted_date_time_value);
        if (locale_formatted_date_time_value != null){
            System.debug('final warrentyStartD>>>:'+locale_formatted_date_time_value.substring(0, 11));
            return locale_formatted_date_time_value.substring(0, 11); //return the string
        } 
        else
            return null;
    }*/

    public String getWarrCreatedDate() {
        return getFormattedDate(psnRec.Warranty_Start_Date__c);

    }

    public String getFormatedFailureDate(){
        return getFormattedDate(psnRec.Failure_Date__c);
    }

    public String getFormattedDate(Date d){
        String formattedDate;
        try{
            formattedDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch getFormattedDate exception>>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return formattedDate;
    }


    public void SOQLClaimsJob() 
    {
        try{
            claimsRec =[Select Id,Name,Region__c,Status__c,Territory__c,ReconEngineFlag__c,CoverageResponse__c,ESN__c,css_job__c,Location_Code__c,
                        (Select Id,Name,PSN__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                         Warranty_Start_Date__c,Before_In_Service__c,Product_Hours__c,ApplicationCode__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :cId];
                        //system.debug('EXCEPTION of claimsRec claimsRec >>> '+claimsRec);
            if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                psnRec = claimsRec.CSS_PSNs__r.get(0);
            }else
                psnRec = new CSS_PSN__c();
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsWarrantyComp constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }




}