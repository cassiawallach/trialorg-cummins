/**********************************************************************
Name: FSL_CL_IntakeWarrantyComp
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: This is Used for the Warranty Page in FSL                                                   
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      01/20/2019      INITIAL DEVELOPMENT
1.1 - Charan Sura       08/18/2021      For CT3-517:Added logic for Warranty and Certificate dates in the 4Cs section for reflecting the correct date format 
***********************************************************************/

public without sharing class FSL_CL_IntakeWarrantyComp {
    //Global Veriables
    public id pgId;
    public string mil_measure{get; set;}
    public string applicationCode;
    
    public boolean insertErrorRecord;//added for integraton error handling logic
    public boolean showWarrDetailsSection{get;set;}
    public map<string,map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>> coverageByDefTypeMap{get;set;}
    public WorkOrder wo{get;set;}
    boolean isnewRecon = false;
    public Boolean showAWSMessage{get;set;}//added by vinod 9/26 to show label
    public FSL_CL_IntakeWarrantyComp(){}
    
    public FSL_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public map<string,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefType{get;set;}
    public map<string,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG{get;set;}
    public map<string,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeEmission{get;set;}
    public list<FSL_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public map<string,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeRecEng{get;set;}//added by vinod 9/19
    public string coverageDetailsSTR;
    public string coverageDetailsSTR2;
    public String returnDescr='';
    public String returnStatus='';
    // Added By Harsha Ragam 
    
    public void coveragesearch() {
        try {
            String emptyString = '';
            system.debug('after mil_measure>>'+mil_measure);
            coverageDetailsSTR = ''; coverageDetailsSTR2 = '';
            FSL_getBasicCoverageReqJ2A getBasicCoverageReq = new FSL_getBasicCoverageReqJ2A();
            FSL_getBasicCoverageReqJ2A.DataArea reqDA = new FSL_getBasicCoverageReqJ2A.DataArea();
            basicCoverageDetails = new FSL_getBasicCoverageResponseJ2A();
            /*
             */
           List<FSL_Coverage_Details__c> existCvgDetails = new List<FSL_Coverage_Details__c>();
            List<Fsl_Certificate_Details__c>  extCerts = new List<Fsl_Certificate_Details__c>();
            existCvgDetails=[SELECT id
                             FROM FSL_Coverage_Details__c
                             WHERE FSL_Service_Order__c =: wo.Id
                            ];
            extCerts = [SELECT id
                        FROM Fsl_Certificate_Details__c
                        WHERE Service_Order__c =: wo.Id
                       ];
            System.debug('Delete existCvgDetails :'+existCvgDetails);
            System.debug('Delete extCerts :'+extCerts);
            
            //Starts - Warranty - FSL Changes-Vinod Yelala - Added to bypass logic for FSL Servicejob object
            //if(wo.Type__c != 'Dealer'){}
            
            if(wo.Asset <> null && String.isNotBlank(wo.Asset.Name)){//sets ESN request to Asset Name
                reqDA.ESN = wo.Asset.Name;
            }
            else {
                reqDA.ESN =  emptyString;
            }
            if(String.isNotBlank(wo.Application__c)){
                reqDA.EngineApplicationCode = wo.Application__c;
            }
            else{
                reqDA.EngineApplicationCode = emptyString;
            }
            if(wo.Type__c != 'Dealer'){
                if(wo.ServiceTerritory <> null && String.isNotBlank(wo.ServiceTerritory.Region__c)){
                    reqDA.Region = wo.ServiceTerritory.Region__c;
                }
                else{
                    reqDA.Region = emptyString;
                }
                if( wo.ServiceTerritory <> null && String.isNotBlank(wo.ServiceTerritory.Territory__c)){
                    reqDA.Territory = wo.ServiceTerritory.Territory__c;
                }
                else{
                    reqDA.Territory = emptyString;
                }
            } else { //updating logic for Dealer to map region and territory from Account
                if(wo.AccountId <> null && String.isNotBlank(wo.Account.Region__c)){
                    reqDA.Region = wo.Account.Region__c;
                }
                else{
                    reqDA.Region = emptyString;
                }
                if( wo.AccountId <> null && String.isNotBlank(wo.Account.Territory__c)){
                    reqDA.Territory = wo.Account.Territory__c;
                }
                else{
                    reqDA.Territory = emptyString;
                }
            }
            Date d;
            string warantySDate;
            if(Wo.Before_In_Service__c == false) {
                d = Wo.Warranty_Start_Date__c;
            }
            else if(Wo.Before_In_Service__c == true) {
                d = Wo.Failure_Date__c;
            }
            else
                d = System.today();
                
            if(d != null)
                reqDA.WarrantyStartDate = DateTime.newInstance(d.year(),d.month(),d.day()).format('MM/d/YYYY');
            else
                reqDA.WarrantyStartDate = emptyString;
                
            //CT3-497 ------------
            Date fd;
            if(Wo.Failure_Date__c != null) {
                fd = Wo.Failure_Date__c ;
            }
            else{
                fd = System.today();
            }
            
            
            reqDA.FailureDate = DateTime.newInstance(fd.year(),fd.month(),fd.day()).format('MM/d/YYYY');
            system.debug('reqDA.FailureDate :: '+reqDA.FailureDate + ' :: '+fd);
            //-------------------
            
            reqDA.PartsWarranty = 'Y';
            if(String.isNotBlank(wo.Application__c) &&
             (wo.Application__c.contains('130') ||
              wo.Application__c.contains('210') ||
              wo.Application__c.contains('220') ||
              wo.Application__c.contains('260') ||
              wo.Application__c.contains('270') ||
              wo.Application__c.contains('310') ||
              wo.Application__c.contains('320') ||
              wo.Application__c.contains('410')))
              // Devon Sumbry Story 2234 
              {
                //Asset Automotive Application Flag is not equal to Y then system was sending null value to failurePoint 
                // & failureUnit which is causing issue in checking warranty coverage. Because on Work Order user added value in Mileage field. 
                // CT3-497, Dinesh Yadav, 06/08/21
                /*if(wo.Asset.Automotive_Application_Flag__c == 'Y')
                {*/
                    reqDA.failurePoint = String.valueOf(wo.Mileage__c);
                    reqDA.failureUnit = wo.Mileage_Measure__c;
                //}
            }
          else
          {
              reqDA.failurePoint=String.valueOf(wo.CSS_Hours__c);
              reqDA.failureUnit= 'Hours';
          }
          if (wo.Asset.Recon_Engine_Flag__c)
          {
              reqDA.ReconFlag = 'Y';
          }
          else
          {
              reqDA.ReconFlag = 'N';
          }
          reqDA.JobId = wo.WorkOrderNumber;
          //End Devon
            //Ends - Warranty - FSL Changes-Vinod Yelala - Added to bypass logic for FSL Servicejob object
            getBasicCoverageReq.DataArea = reqDA;
            System.debug('reqDA' + reqDA);
            //By Priyanka VGRS2-517
             FSL_WS_SBL.calloutGenericMuleNamedCredGetBasicCoverage(getBasicCoverageReq);//callout to get coverage details
          // FSL_WS_SBL.getBasicCoverage(getBasicCoverageReq);//callout to get coverage details 
            basicCoverageDetails = FSL_WS_SBL.basicCoverageDetails;
            FSLIntakeWarrantyResp getRetrybasiccoveragedetails = FSL_WS_SBL.getRetrybasiccoveragedetails;
            System.debug('basicCoverageDetails' + basicCoverageDetails);
            system.debug('response code::'+FSL_WS_SBL.respCode);
            Decimal trueValue= 0;
            Map<Integer, FSL_getBasicCoverageResponseJ2A.coverageDetails> cvgMap = new Map<Integer, FSL_getBasicCoverageResponseJ2A.coverageDetails>();
            //system.debug('basicCoverageDetails.Header::'+basicCoverageDetails.Header);
            if(FSL_WS_SBL.respCode == 200)
            {
                if(basicCoverageDetails == null && getRetrybasiccoveragedetails == null)
                {
                    insertErrorRecord = True;//added for integraton error handling logic
                }               
                system.debug('showWarrDetailsSection::'+basicCoverageDetails);
                system.debug('getRetrybasiccoveragedetails::'+getRetrybasiccoveragedetails);
                
                List<FSL_Coverage_Details__c> covgDetails = new List<FSL_Coverage_Details__c>();
                
                if(basicCoverageDetails == null && getRetrybasiccoveragedetails <> null && getRetrybasiccoveragedetails.Header <> null && String.isNotBlank(getRetrybasiccoveragedetails.Header.Status))
                    returnStatus = getRetrybasiccoveragedetails.Header.Status;
                
                if(basicCoverageDetails <> null && basicCoverageDetails.Header <> null && String.isNotBlank(basicCoverageDetails.Header.Status))
                    returnStatus = basicCoverageDetails.Header.Status;
                
                if(basicCoverageDetails == null && getRetrybasiccoveragedetails <> null && getRetrybasiccoveragedetails.Header <> null && 
                   getRetrybasiccoveragedetails.Header.Status.equalsIgnoreCase('ERROR'))
                {
                    if(getRetrybasiccoveragedetails.Header.ReturnCodeDescription== 'PSN Not Found'){
                        returnDescr = System.Label.FSL_Asset_Nofound;
                    }
                    else if(getRetrybasiccoveragedetails.Header.ReturnCodeDescription== 'Coverage Not Found'){
                        returnDescr = system.Label.FSL_Asset_Nofound;
                    }
                    else if(getRetrybasiccoveragedetails.Header.ReturnCodeDescription== 'Warranty Start Date is Required'){
                        returnDescr = System.Label.FSL_WarrantyStartDate_Error;
                    }
                    else if(getRetrybasiccoveragedetails.Header.ReturnCodeDescription== 'Technical Exception Error. Please Contact Support Team.'){
                        returnDescr = System.Label.FSL_Warranty_Technical;
                    }
                    else
                        returnDescr = System.Label.FSL_Retry;
                }
                else if(basicCoverageDetails <> null && basicCoverageDetails.Header <> null && basicCoverageDetails.Header.Status.equalsIgnoreCase('error'))
                {
                    if(basicCoverageDetails.Header.ReturnCodeDescription== 'PSN Not Found'){
                        returnDescr = System.Label.FSL_Asset_Nofound;
                    }
                    else if(basicCoverageDetails.Header.ReturnCodeDescription== 'Coverage Not Found'){
                        returnDescr = system.Label.FSL_Asset_Nofound;
                    }
                    else if(basicCoverageDetails.Header.ReturnCodeDescription== 'Warranty Start Date is Required'){
                        returnDescr = System.Label.FSL_WarrantyStartDate_Error;
                    }
                    else if(basicCoverageDetails.Header.ReturnCodeDescription== 'Technical Exception Error. Please Contact Support Team.'){
                        returnDescr = System.Label.FSL_Warranty_Technical;
                    }
                    else
                        returnDescr = System.Label.FSL_Retry;
                }
                else if(basicCoverageDetails != null){
                    //Building map mapGroupCoverageByDefType 
                    mapGroupCoverageByDefType=new map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    mapGroupCoverageByDefTypeNewENG=new map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    mapGroupCoverageByDefTypeEmission=new map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                    mapGroupCoverageByDefTypeRecEng = new map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>();//added by vinod 9/19
                    coverageByDefTypeMap = new map<string,map<String,list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>>();
                    for(FSL_getBasicCoverageResponseJ2A.coverageDetails c : basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails)
                    {
                        // Added By BasicCoverage For the Deductible Amount-- Harsha Ragam
                        FSL_getBasicCoverageResponseJ2A.ListOfCoverageDedutibles listofcoveragedebut = c.ListOfCoverageDedutibles;
                        Decimal constantDecutibleAmt = 0;
                        Decimal firstVisitAmt = 0;
                        //system.debug('cvgcomp.ListOfCoverageDedutible' + c.ListOfCoverageDedutibles.CoverageDedutibles);
                        //system.debug('cvgcomp.ListOfCoverageDedutible' + c.ListOfCoverageDedutibles.CoverageDedutibles);
                        for(FSL_getBasicCoverageResponseJ2A.CoverageDedutibles cd : c.ListOfCoverageDedutibles.CoverageDedutibles)
                        {
                            if(cd.firstVisitAmt != null && cd.firstVisitAmt!='')
                                firstVisitAmt = decimal.valueOf(cd.firstVisitAmt);
                            if(cd.constantDecutibleAmt != null && cd.constantDecutibleAmt !='' )
                                constantDecutibleAmt = decimal.valueOf(cd.constantDecutibleAmt);
                        }
                        if(constantDecutibleAmt != null && constantDecutibleAmt !=0)
                        {
                            trueValue = constantDecutibleAmt;
                        }
                        if(constantDecutibleAmt ==0 && firstVisitAmt != null && firstVisitAmt !=0)
                        {
                            trueValue = firstVisitAmt;
                        }
                        //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                        if(c.CoverageType =='EMS-Emissions Warranty') {
                            cvgMap.put(1, c);
                            // coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNote: Deductibles may apply, please check the Warranty Administration Manual for more information:';
                            //iterating the CoverageComponentList
                            for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                String wsd;
                                
                                if(Wo.Warranty_Start_Date__c <> null)
                                    wsd = Wo.Warranty_Start_Date__c.month() + '/' + Wo.Warranty_Start_Date__c.day()+ '/'+Wo.Warranty_Start_Date__c.year();
                                else
                                    wsd = '';
                                
                                // coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNote: Deductibles may apply, please check the Warranty Administration Manual for more information:';
                                // coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNEW-New Engine Warranty:';
                                coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nCoverage Type: '+ccl.CoverageComponentTypeCode;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +'\nStatus: '+ccl.status;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +
                                    '\nWarranty Start: '+ getDateConverted(wsd) +         //CT3-517 
                                    '\nWarranty End: ' + getDateConverted(ccl.ComponentEndDate) +    //CT3-517 
                                    '\nCoverage Months: '+ccl.CoverageMaxMonths+
                                    '\nCoverage Miles: ' + ccl.CoverageMiles +
                                    '\nCoverage Kilometers: ' + String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0))+
                                    '\nCoverage Hours: '+ ccl.CoverageHours+
                                    '\nCoverage Megawatt Hours: '+ccl.MegawattHours+
                                    '\nDeductible: '+trueValue+'\n';
                                //populating the map 
                                if(!mapGroupCoverageByDefTypeEmission.containskey(ccl.CoverageDefenitionType))                                    
                                    mapGroupCoverageByDefTypeEmission.put(ccl.CoverageDefenitionType,new list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                mapGroupCoverageByDefTypeEmission.get(ccl.CoverageDefenitionType).add(ccl);
                                system.debug('coverageDetailsSTR2:: emission'+coverageDetailsSTR2);
                            } //end of inner 2 loop
                            //-Vinod Warranty Search changes - map coverage response details to salesforce object - FSL_Coverage_Details__c
                            for(String key : mapGroupCoverageByDefTypeEmission.keySet())
                            {
                                String milest;
                                string cvghrs;
                                string cvgmhrs;
                                // string wsddate;
                                // wsddate = Wo.Warranty_Start_Date__c.month() + '/' + Wo.Warranty_Start_Date__c.day()+ '/'+Wo.Warranty_Start_Date__c.year();
                                
                                for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList cvgComp : mapGroupCoverageByDefTypeEmission.get(key))
                                { 
                                    // For MegawattHours
                                    if(String.isNotBlank(cvgComp.MegawattHours))
                                    {
                                        if(cvgComp.MegawattHours == '9999999')
                                            cvgmhrs = 'Unlimited';
                                        else
                                            cvgmhrs = cvgComp.MegawattHours;
                                    }
                                    // For Coverage Hours
                                    if(String.isNotBlank(cvgComp.CoverageHours))
                                    {
                                        if(cvgComp.CoverageHours == '9999999')
                                            cvghrs = 'Unlimited';
                                        else
                                            cvghrs = cvgComp.CoverageHours;
                                    }
                                    // For Coverage Miles and Kilometers
                                    String km;
                                    if(String.isNotBlank(cvgComp.CoverageMiles))
                                    {
                                        if(cvgComp.CoverageMiles == '9999999') {
                                            milest = 'Unlimited';
                                            km = 'Unlimited';
                                        }
                                        else {
                                            milest = cvgComp.CoverageMiles;
                                            km = String.ValueOf((Decimal.valueOf(cvgComp.CoverageMiles)/0.621371).setScale(0));
                                        }
                                    }
                                    covgDetails.add(new FSL_Coverage_Details__c(
                                        Component_Type_Code__c = cvgComp.CoverageComponentTypeCode,
                                        Coverage_Type__c = cvgComp.CoverageComponentTypeCode,//'Emissions',//cvgComp.CoverageComponentTypeCode,
                                        Definition_Type__c = cvgComp.CoverageDefenitionType,
                                        Hours__c = cvghrs,
                                        Mega_Watt_Hours__c = cvgmhrs,
                                        Min_Months__c = cvgComp.CoverageMinMonths,
                                        Max_months__c = cvgComp.CoverageMaxMonths,
                                        FSL_Service_Order__c = wo.id,
                                        Status__c = cvgComp.Componentstatus,
                                        Deductible__c = trueValue,
                                        //Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : wo.Failure_Date__c, // Commented as part of as part of NIN-1
                                        Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : null, // changed as part of NIN-1
                                        //Warranty_End__c =  cvgComp.ComponentEndDate,   
                                        Warranty_End__c = wo.Before_In_Service__c == false ? cvgComp.ComponentEndDate : null,  // changed as part of NIN-1
                                        Warranty_End_URL__c = c.WarrantyManualURL,
                                        Procedure_Number__c = c.ProcedureNumber,
                                        Cov_Kms__c = km,
                                        Cov_Miles__c = milest
                                    ));
                                }
                            }
                        }
                        //end of if cond
                        //if the coverage type is of NEW-New Engine Warranty
                        if(c.CoverageType =='NEW-New Engine Warranty'){
                            isnewRecon = true;
                            cvgMap.put(2, c);
                            coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNote: Deductibles may apply, please check the Warranty Administration Manual for more information:';
                            system.debug('coverageDetailsSTR2>>'+coverageDetailsSTR2);//iterating the CoverageComponentList
                            for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                String wsd;
                                system.debug('coverageDetailsSTR2>>'+coverageDetailsSTR2);//iterating the CoverageComponentList
                                if(Wo.Warranty_Start_Date__c <> null)
                                    wsd = Wo.Warranty_Start_Date__c.month() + '/' + Wo.Warranty_Start_Date__c.day()+ '/'+Wo.Warranty_Start_Date__c.year();
                                else
                                    wsd = '';
                                //coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNote: Deductibles may apply, please check the Warranty Administration Manual for more information:';
                                //coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nNEW-New Engine Warranty:';
                                string cvgtype;
                                if(ccl.CoverageComponentTypeCode == 'BASE'){
                                    cvgType = 'New Product Warranty';
                                }
                                else {
                                    cvgType = ccl.CoverageComponentTypeCode;
                                }
                                coverageDetailsSTR2 =  coverageDetailsSTR2 + '\nCoverage Type: '+cvgType;
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nStatus: ' + ccl.status;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +
                                    '\nWarranty Start: '+ getDateConverted(wsd) +     //CT3-517 
                                    '\nWarranty End: ' + getDateConverted(ccl.ComponentEndDate) +   //CT3-517 
                                    '\nCoverage Months: '+ccl.CoverageMaxMonths+
                                    '\nCoverage Miles: ' + ccl.CoverageMiles +
                                    '\nCoverage Kilometers: ' + String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0))+
                                    '\nCoverage Hours: '+ ccl.CoverageHours+
                                    '\nCoverage Megawatt Hours: '+ccl.MegawattHours+
                                    '\nDeductible: '+trueValue+'\n';
                                //populating the map 
                                if(!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageDefenitionType))                                    
                                    mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageDefenitionType,new list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageDefenitionType).add(ccl);
                                system.debug('coverageDetailsSTR2:: new engine'+coverageDetailsSTR2);
                            } //end of inner 2 loop
                            //-Vinod Warranty Search changes - map coverage response details to salesforce object - FSL_Coverage_Details__c
                            for(String key : mapGroupCoverageByDefTypeNewENG.keySet())
                            {
                                String milest;
                                string cvghrs;
                                string cvgmhrs;
                                for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList cvgComp : mapGroupCoverageByDefTypeNewENG.get(key))
                                {   
                                    // For MegawattHours
                                    if(String.isNotBlank(cvgComp.MegawattHours))
                                    {
                                        if(cvgComp.MegawattHours == '9999999')
                                            cvgmhrs = 'Unlimited';
                                        else
                                            cvgmhrs = cvgComp.MegawattHours;
                                    }
                                    // For Coverage Hours
                                    if(String.isNotBlank(cvgComp.CoverageHours))
                                    {
                                        if(cvgComp.CoverageHours == '9999999')
                                            cvghrs = 'Unlimited';
                                        else
                                            cvghrs = cvgComp.CoverageHours;
                                    }
                                    // For Coverage Miles and Kilometers
                                    String km;
                                    if(String.isNotBlank(cvgComp.CoverageMiles))
                                    {
                                        if(cvgComp.CoverageMiles == '9999999') {
                                            milest = 'Unlimited';
                                            km = 'Unlimited';
                                        }
                                        else {
                                            milest = cvgComp.CoverageMiles;
                                            km = String.ValueOf((Decimal.valueOf(cvgComp.CoverageMiles)/0.621371).setScale(0));
                                        }
                                    }
                                    covgDetails.add(new FSL_Coverage_Details__c(
                                        Component_Type_Code__c = cvgComp.CoverageComponentTypeCode,
                                        Coverage_Type__c = cvgComp.CoverageComponentTypeCode == 'BASE'?'New Product Warranty':cvgComp.CoverageComponentTypeCode,
                                        Definition_Type__c = cvgComp.CoverageDefenitionType,
                                        Hours__c = cvghrs,
                                        Mega_Watt_Hours__c = cvgmhrs,
                                        Min_Months__c = cvgComp.CoverageMinMonths,
                                        Max_months__c = cvgComp.CoverageMaxMonths,
                                        FSL_Service_Order__c = wo.id,
                                        Status__c = cvgComp.Componentstatus,
                                        Deductible__c = trueValue,
                                        //Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : wo.Failure_Date__c, // Commented as part of as part of NIN-1
                                        Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : null, // Changed as part of as part of NIN-1
                                        Warranty_End_URL__c = c.WarrantyManualURL,
                                        //Warranty_End__c =  cvgComp.ComponentEndDate,  // Commented as part on NIN-1
                                        Warranty_End__c = wo.Before_In_Service__c == false ? cvgComp.ComponentEndDate : null,  // Changed as part of as part of NIN-1
                                        Procedure_Number__c = c.ProcedureNumber,
                                        Cov_Kms__c = km,
                                        Cov_Miles__c = milest
                                    ));
                                }
                            }
                        }//end of if cond
                        //Code for Recon Engine Warranty start-- 9/19 for recon by vinod
                        if(c.CoverageType =='REW-Recon Engine Warranty'){
                            isnewRecon = true;
                            cvgMap.put(3, c);
                            //iterating the CoverageComponentList
                            for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                                String wsd;
                                if(Wo.Warranty_Start_Date__c <> null)
                                    wsd = Wo.Warranty_Start_Date__c.month() + '/' + Wo.Warranty_Start_Date__c.day()+ '/'+Wo.Warranty_Start_Date__c.year();
                                else
                                    wsd = '';
                                //coverageDetailsSTR2 =  coverageDetailsSTR2 +'\n\n'+'\nREW-Recon Engine Warranty :';
                                string cvgtype;
                                if(ccl.CoverageComponentTypeCode == 'BASE')
                                    cvgType = 'Recon Engine Warranty';
                                else cvgType = ccl.CoverageComponentTypeCode;
                                coverageDetailsSTR2 =  coverageDetailsSTR2 +'\n\n'+'\nCoverage Type: '+cvgType;//ccl.CoverageComponentTypeCode == 'BASE'?'Recon Engine Warranty':ccl.CoverageComponentTypeCode;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +'\n\n'+'\nStatus: '+ccl.status;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +
                                    '\nWarranty Start: '+ getDateConverted(wsd) + //Wo.Warranty_Start_Date__c.month() + '/' + Wo.Warranty_Start_Date__c.day()+ '/'+Wo.Warranty_Start_Date__c.year()+   //CT3-517
                                    '\nWarranty End: ' + getDateConverted(ccl.ComponentEndDate) +  //CT3-517 
                                    '\nCoverage Months: '+ccl.CoverageMaxMonths+
                                    '\nCoverage Miles: ' + ccl.CoverageMiles +
                                    '\nCoverage Kilometers: ' + String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0))+
                                    '\nCoverage Hours: '+ ccl.CoverageHours+
                                    '\nCoverage Megawatt Hours: '+ccl.MegawattHours+
                                    '\nDeductible: '+trueValue+'\n';
                                //populating the map
                                if(!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageDefenitionType)){                                    
                                    mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageDefenitionType,new list<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>());
                                }
                                mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageDefenitionType).add(ccl);
                            }
                            //-Vinod Warranty Search changes - map coverage response details to salesforce object - FSL_Coverage_Details__c
                            for(String key: mapGroupCoverageByDefTypeRecEng.keySet())
                            {
                                String milest;
                                string cvghrs;
                                string cvgmhrs;
                                for(FSL_getBasicCoverageResponseJ2A.CoverageComponentList cvgComp : mapGroupCoverageByDefTypeRecEng.get(key))
                                {   
                                    // For MegawattHours
                                    if(String.isNotBlank(cvgComp.MegawattHours))
                                    {
                                        if(cvgComp.MegawattHours == '9999999')
                                            cvgmhrs = 'Unlimited';
                                        else
                                            cvgmhrs = cvgComp.MegawattHours;
                                    }
                                    // For Coverage Hours
                                    if(String.isNotBlank(cvgComp.CoverageHours))
                                    {
                                        if(cvgComp.CoverageHours == '9999999')
                                            cvghrs = 'Unlimited';
                                        else
                                            cvghrs = cvgComp.CoverageHours;
                                    }
                                    // For Coverage Miles and Kilometers
                                    String km;
                                    if(String.isNotBlank(cvgComp.CoverageMiles))
                                    {
                                        if(cvgComp.CoverageMiles == '9999999') {
                                            milest = 'Unlimited';
                                            km = 'Unlimited';
                                        }
                                        else {
                                            milest = cvgComp.CoverageMiles;
                                            km = String.ValueOf((Decimal.valueOf(cvgComp.CoverageMiles)/0.621371).setScale(0));
                                        }
                                    }
                                    covgDetails.add(new FSL_Coverage_Details__c(
                                        Component_Type_Code__c = cvgComp.CoverageComponentTypeCode,
                                        Coverage_Type__c = cvgComp.CoverageComponentTypeCode == 'BASE'?'Recon Engine Warranty':cvgComp.CoverageComponentTypeCode,
                                        Definition_Type__c = cvgComp.CoverageDefenitionType,
                                        Hours__c = cvghrs,
                                        Mega_Watt_Hours__c = cvgmhrs,
                                        Deductible__c = trueValue,
                                        Min_Months__c = cvgComp.CoverageMinMonths,
                                        Max_months__c = cvgComp.CoverageMaxMonths,
                                        FSL_Service_Order__c = wo.id,
                                        //Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : wo.Failure_Date__c, // Commented as part of as part of NIN-1
                                        Warranty_Start_Date__c = wo.Warranty_Start_Date__c != null && wo.Before_In_Service__c == false ? wo.Warranty_Start_Date__c : null, // Changed as part of as part of NIN-1
                                        Status__c = cvgComp.Componentstatus,
                                        //Warranty_End__c =  cvgComp.ComponentEndDate,  // Commented as part of NIN-1
                                        Warranty_End__c = wo.Before_In_Service__c == false ? cvgComp.ComponentEndDate : null, // Changed as part of NIN-1
                                        Warranty_End_URL__c = c.WarrantyManualURL,
                                        Procedure_Number__c = c.ProcedureNumber,
                                        Cov_Kms__c = km,
                                        Cov_Miles__c = milest
                                    ));
                                }
                            }
                            //end of inner 2 loop
                        }//end of if cond                        
                        //Code for Recon Engine Warranty End -- 9/19 for recon by vinod
                    }//end of outer for loop
                    //Warranty Search - Vinod changes start
                    if(!covgDetails.isEmpty())
                    {
                        
                      /*1/31 by vinod -- Starts --coverage type code sort code starts*/
                       Map<String, List<FSL_Coverage_Details__c>> cdsMap = new Map<String, List<FSL_Coverage_Details__c>>();
                       List<String> covCodes=new List<String>();
                       Set<String> covCodest=new set<String>();//added by vinod to fix the coverage insert issue 10-8-2020
                       
                       for(FSL_Coverage_Details__c cd : covgDetails)
                       {
                           
                           //covCodes.add(cd.Coverage_Type__c);//commented by vinod to fix the coverage insert issue 10-8-2020
                           covCodest.add(cd.Coverage_Type__c);//added by vinod to fix the coverage insert issue 10-8-2020
                           if(!cdsMap.containsKey(cd.Coverage_Type__c)){
                               cdsMap.put(cd.Coverage_Type__c, new List<FSL_Coverage_Details__c>{cd});
                           }
                           else{
                               cdsMap.get(cd.Coverage_Type__c).add(cd);
                           }
                           // system.debug('covgDetails'++++++covgDetails);
                       }
                       covCodes = new List<String>(covCodest);//added by vinod to fix the coverage insert issue 10-8-2020
                        covCodes.sort();
                        List<FSL_Coverage_Details__c> covgDetailsToInsert = new List<FSL_Coverage_Details__c>();
                        List<FSL_Coverage_Details__c> EMISSIONSToInsert = new List<FSL_Coverage_Details__c>();
                        //List<FSL_Coverage_Details__c> EMISSIONSCAToInsert = new List<FSL_Coverage_Details__c>();
                        //covgDetailsToInsert.//
                        for(String s : covCodes)
                        {
                            system.debug('coverage code::'+s);
                            if(s == 'Recon Engine Warranty' || s == 'New Product Warranty' || s == 'EMS-Emissions Warranty')
                            {
                                for(FSL_Coverage_Details__c cd :cdsMap.get(s))
                                {
                                    system.debug('cd+++++>>'+cd);
                                    if(covgDetailsToInsert.size() > 0){
                                        covgDetailsToInsert.add(0, cd);
                                    }
                                    else //fix
                                        covgDetailsToInsert.add(cd); //fix
                                }
                            }
                            else{
                                if(s == 'EMISSIONS' || s == 'EMISSIONS-CA')
                                    EMISSIONSToInsert.addAll(cdsMap.get(s));
                                //else if(s == 'EMISSIONS-CA')
                                //   EMISSIONSCAToInsert.addAll(cdsMap.get(s));
                                else
                                    covgDetailsToInsert.addAll(cdsMap.get(s));
                                system.debug('cdsMap.get(s)+++++>>'+cdsMap.get(s));
                            }                            
                        }
                        system.debug('EMISSIONSToInsert::'+EMISSIONSToInsert);
                        system.debug('covgDetailsToInsert::'+covgDetailsToInsert);
                        if(EMISSIONSToInsert <> null && !EMISSIONSToInsert.isEmpty())
                            covgDetailsToInsert.addAll(EMISSIONSToInsert);
                        coverageDetailsSTR2='';
                        if(isnewrecon )
                            coverageDetailsSTR2 =   'Note: Deductibles may apply, please check the Warranty Administration Manual for more information';
                        else  
                            coverageDetailsSTR2 = ''; 
                        for(FSL_Coverage_Details__c cd : covgDetailsToInsert)
                        {
                            String wsd;
                            if(cd.Warranty_Start_Date__c <> null)
                                wsd = cd.Warranty_Start_Date__c.month() + '/' + cd.Warranty_Start_Date__c.day()+ '/'+cd.Warranty_Start_Date__c.year();
                            else
                                wsd = '';
                            coverageDetailsSTR2 = coverageDetailsSTR2 +'\nCoverage Type: ' + cd.Coverage_Type__c;
                            coverageDetailsSTR2 = coverageDetailsSTR2 +'\nStatus: ' + cd.Status__c;
                            coverageDetailsSTR2 = coverageDetailsSTR2 +
                                '\nWarranty Start: ' + getDateConverted(wsd) +   //CT3-517 
                                '\nWarranty End: ' + getDateConverted(cd.Warranty_End__c) +  //CT3-517 
                                '\nCoverage Months: ' + cd.Max_Months__c +
                                '\nCoverage Miles: ' + cd.Cov_Miles__c +
                                '\nCoverage Kilometers: ' + cd.Cov_Kms__c +
                                '\nCoverage Hours: '+ cd.Hours__c +
                                '\nCoverage Megawatt Hours: ' + cd.Mega_Watt_Hours__c +
                                '\nDeductible: ' + trueValue + '\n';
                        }
                        /*sort on coverage type code ends*/
                        //Insert new coverage details as per latest asset information on Work order.-Vinod Warranty Search
                            System.debug('*** covgDetailsToInsert *** '+covgDetailsToInsert);
                        if(!Test.isRunningTest())
                            insert covgDetailsToInsert;
                    }//Ends
                }
                
                //Starts integration error handling logic
                if(covgDetails.isEmpty() || (insertErrorRecord != null && insertErrorRecord)|| test.isRunningTest()  )
                {
                    insertErrorRecord(wo.id,'Warranty Info up-to-date');
                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\n\nError:'+System.Label.FSLWarrantyIntegrationError;
                }
                //Ends integration error handling logic
                listcertificatedetails = new list<FSL_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
                if(basicCoverageDetails != null){
                    for(FSL_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt :
                        basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails)
                    {
                        Decimal trueValue2= null;
                        Decimal firstVisitAmt ;
                        Decimal constantDecutibleAmt;
                        //System.debug('cert,CoverageDedutibles --' + cert.ListOfExtCoverageDedutibles);
                        FSL_getBasicCoverageResponseJ2A.ListOfExtCoverageDedutibles  lstdeduci = crtdt.ListOfExtCoverageDedutibles;
                        for(FSL_getBasicCoverageResponseJ2A.CoverageDedutibles  cd:lstdeduci.ExtendedCoverageDedutibles )
                        {
                            if(cd.firstVisitAmt != null && cd.firstVisitAmt!='')
                                firstVisitAmt = decimal.valueOf(cd.firstVisitAmt);
                            System.debug('cd.constantDecutibleAm----' + cd.constantDecutibleAmt+'--');
                            if(cd.constantDecutibleAmt != null && cd.constantDecutibleAmt !='' )
                                constantDecutibleAmt = decimal.valueOf(cd.constantDecutibleAmt);
                            System.debug('cd --' + cd.firstVisitAmt+'00');
                            System.debug('cd --' + cd.ConstantDecutibleAmt+'00');
                        }
                        
                        if(constantDecutibleAmt != null && constantDecutibleAmt !=0)
                        {
                            trueValue2 = constantDecutibleAmt;
                        }
                        if((constantDecutibleAmt ==0 || constantDecutibleAmt ==null) && firstVisitAmt != null && firstVisitAmt !=0)
                        {
                            trueValue2 = firstVisitAmt;
                        }
                        
                        System.debug('--------------' + trueValue2);
                        //Added by vinod for the certificate details conversion--9/19
                        if(mil_measure != null && mil_measure != ''){
                            if(mil_measure.equalsIgnoreCase('Kilometers')){
                                // ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles )/0.621371).setScale(0));
                            }                                
                        }
                        //confirm with Bharat.added by vinod 9/26
                        if((showAWSMessage == null || !showAWSMessage) && crtdt.CAPCoverageID.equalsIgnoreCase('AWP'))
                            
                            showAWSMessage=true;
                        listcertificatedetails.add(crtdt);
                    }
                }
                List<Fsl_Certificate_Details__c> certDetails = new List<Fsl_Certificate_Details__c>(); 
                if(!listcertificatedetails.isEmpty())
                {
                    String beginMiles;
                    String endMiles;
                    String being4CsMiles;
                    String being4CsKms;
                    String end4CsMiles;
                    String end4CsKms;
                    String beghrs;
                    String endhrs;
                    coverageDetailsSTR2+='\n\nCertificate Details';
                    for(FSL_getBasicCoverageResponseJ2A.ExtendedCoverageDetails cert : listcertificatedetails)
                    {
                        Decimal trueValue21= 0;
                        Decimal firstVisitAmt ;
                        Decimal constantDecutibleAmt;
                        //System.debug('cert,CoverageDedutibles --' + cert.ListOfExtCoverageDedutibles);
                        FSL_getBasicCoverageResponseJ2A.ListOfExtCoverageDedutibles  lstdeduci = cert.ListOfExtCoverageDedutibles;
                        for(FSL_getBasicCoverageResponseJ2A.CoverageDedutibles  cd:lstdeduci.ExtendedCoverageDedutibles )
                        {
                            if(cd.firstVisitAmt != null && cd.firstVisitAmt!='')
                                firstVisitAmt = decimal.valueOf(cd.firstVisitAmt);
                            System.debug('cd.constantDecutibleAm----' + cd.constantDecutibleAmt+'--');
                            if(cd.constantDecutibleAmt != null && cd.constantDecutibleAmt !='' )
                                constantDecutibleAmt = decimal.valueOf(cd.constantDecutibleAmt);
                        }
                        
                        if(constantDecutibleAmt != null && constantDecutibleAmt !=0)
                        {
                            trueValue21 = constantDecutibleAmt;
                        }
                        if((constantDecutibleAmt ==0 || constantDecutibleAmt ==null) && firstVisitAmt != null && firstVisitAmt !=0)
                        {
                            trueValue21 = firstVisitAmt;
                        }
                        
                        // For Begin Hours code
                        if(String.isNotBlank(cert.BeginHours))
                        {
                            if(cert.BeginHours == '9999999')
                                beghrs = 'Unlimited';
                            else
                                beghrs = cert.BeginHours;
                        }
                        // End Hours Code
                        if(String.isNotBlank(cert.EndHours))
                        {
                            if(cert.EndHours == '9999999')
                                endhrs = 'Unlimited';
                            else
                                endhrs = cert.EndHours;
                        }
                        if(String.isNotBlank(cert.BeginMiles))
                        {
                            if(cert.BeginMiles == '9999999') {
                                beginMiles = 'Mi:Unlimited Km:Unlimited';
                                being4CsMiles = 'Unlimited';
                                being4CsKms = 'Unlimited';
                            }
                            else {
                                beginMiles = 'Mi:' + cert.BeginMiles +'/Km:'+ String.ValueOf((Decimal.valueOf(cert.BeginMiles)/0.621371).setScale(0));
                                being4CsMiles = cert.BeginMiles;
                                being4CsKms = String.ValueOf((Decimal.valueOf(cert.BeginMiles)/0.621371).setScale(0));
                            }
                        }
                        if(String.isNotBlank(cert.EndMiles))
                        {
                            if(cert.EndMiles == '9999999') {
                                endMiles = 'Mi:Unlimited Km:Unlimited';
                                end4CsMiles = 'Unlimited';
                                end4CsKms = 'Unlimited';
                            }
                            else {
                                endMiles = 'Mi:' + cert.EndMiles +'/Km:'+ String.ValueOf((Decimal.valueOf(cert.EndMiles)/0.621371).setScale(0));
                                end4CsMiles = cert.EndMiles;
                                end4CsKms = String.ValueOf((Decimal.valueOf(cert.EndMiles)/0.621371).setScale(0));
                            }
                        }
                        //Harsha Commented this for 4cs Coverage Notes Bug:CT3-317
                       /* coverageDetailsSTR2 =  coverageDetailsSTR2 +'\nCoverage Type: '+cert.CoverageType;
                                coverageDetailsSTR2 = coverageDetailsSTR2 +'\nStatus: '+cert.status;                                
                               coverageDetailsSTR2 +=coverageDetailsSTR2+'\nStart Date: '+cert.StartDate+ */ 
                                 coverageDetailsSTR2 += +'\nCoverage Type:'+cert.CoverageType+'\nStart Date: '+getDateConverted(cert.StartDate)+  //CT3-517 
                             '\nStatus: '+cert.status+
                            '\nExpiry Date: '+getDateConverted(cert.EndDate)+   //CT3-517 
                            '\nBegin Miles: '+being4CsMiles+
                            '\nBegin Kilometers: '+being4CsKms+
                            '\nEnd Miles: '+end4CsMiles+
                            '\nEnd Kilometers: '+end4CsKms+
                            '\nBegin Hours: '+beghrs+
                            '\nEnd Hours: '+endhrs+
                            '\nDeductible: '+trueValue21+'\n';
                        
                        certDetails.add(
                            new Fsl_Certificate_Details__c(
                                CoverageType__c = cert.CoverageType,
                                Begin_Hours__c = beghrs,
                                Begin_Mi_Km__c = beginMiles,
                                Certificate__c = cert.CAPCoverageID+'-'+cert.CertificateNumber,
                                End_Hours__c = endhrs,
                                End_Mi_Km__c = endMiles,
                                Deductible__c = trueValue21,
                                Expiry_Date__c = cert.EndDate,    
                                Status__c = cert.status,
                                Start_Date__c = cert.StartDate,  
                                Warranty_Administration_Manual__c = cert.WarrantyManualURL,
                                Procedure_Number__c = cert.ProcedureNumber,
                                Service_Order__c = wo.Id
                            ));
                    }
                    System.debug('*** certDetails *** '+certDetails);
                    if(!certDetails.isEmpty()){
                        insert certDetails;
                    }
                }
                //insert error record when certificate details are not received.
                system.debug('coverageDetailsSTR2::'+coverageDetailsSTR2);
                If (listcertificatedetails.isEmpty() || certDetails.isEmpty())        
                {
                    Fsl_Certificate_Details__c fcd  = new Fsl_Certificate_Details__c(Service_Order__c=wo.Id, CoverageType__c = System.Label.FSL_Certificate_Details);
                    insert fcd;
                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\n\nError :'+System.Label.FSL_Certificate_Details;
                }
                system.debug('coverageDetailsSTR2::'+coverageDetailsSTR2);
                returnStatus = 'Warranty Info up-to-date';
            }
            else if(FSL_WS_SBL.respCode == 500)
            {
                returnDescr = System.Label.FSL_Retry;
                returnStatus = 'Service Error - Retry Get Coverage';
            }
            
            WorkOrder sOrder = new WorkOrder();
            sOrder.id = wo.id;
            system.debug('coverageDetailsSTR2::'+coverageDetailsSTR2);
            
            if(String.isNotBlank(coverageDetailsSTR2)) {
                sOrder.EditCoverage__c = coverageDetailsSTR2;
            }
            else if(returnStatus.equalsIgnoreCase('ERROR')) {
                sOrder.EditCoverage__c = coverageDetailsSTR2 + '\nError:' + returnDescr;
            }
            system.debug('<<<<FSL_Warranty_Service_Status__c');
            
            sOrder.Warranty_Integration_Status__c = returnStatus;
            sOrder.Warranty_Integration_Descrption__c = returnDescr;
            /*ENDs Added by vinod yellala 4C's changes*/
            
           if(!extCerts.isEmpty()){
                System.debug('**** Delete Certificates ***** :'+extCerts);
                delete extCerts;
            }
            if(!existCvgDetails.isEmpty()){
                System.debug('**** Delete Coverage ***** :'+existCvgDetails);
                delete existCvgDetails;
            }
            update sOrder;
            
        } catch(exception e) {
            system.debug('inside basic search'+e.getLineNumber() + e.getMessage());
        }
    }
    
    //added method to insert error record when no response received for coverage.
    public void insertErrorRecord(Id woId, String warrantyIntStatus ) {
        FSL_Coverage_Details__c fcd  = new FSL_Coverage_Details__c(FSL_Service_Order__c=woId,
                                                                   Coverage_Type__c = System.Label.FSLWarrantyIntegrationError);
        insert fcd;
        if(returnStatus!=null)
        {
            if(returnStatus.equalsIgnoreCase('ERROR'))
            {
                workorder wo = new WorkOrder();
                wo.Id = woId;
                wo.EditCoverage__c = '\nError:'+returnDescr;
                wo.Warranty_Integration_Status__c = warrantyIntStatus;
                update wo;
            }
        }
    }
    public static void deleteExistingCoverageAndCertificates(List<Id> lstWorkOrderIds){
        List<FSL_Coverage_Details__c> existCvgDetails = new List<FSL_Coverage_Details__c>();
        List<Fsl_Certificate_Details__c>  extCerts = new List<Fsl_Certificate_Details__c>();
        existCvgDetails=[SELECT id
                         FROM FSL_Coverage_Details__c
                         WHERE FSL_Service_Order__c IN : lstWorkOrderIds
                        ];
        extCerts = [SELECT id
                    FROM Fsl_Certificate_Details__c
                    WHERE Service_Order__c IN : lstWorkOrderIds
                   ];
        if(!extCerts.isEmpty()){
            System.debug('**** Delete Certificates ***** :'+extCerts);
            delete extCerts;
        }
        if(!existCvgDetails.isEmpty()){
            System.debug('**** Delete Coverage ***** :'+existCvgDetails);
            delete existCvgDetails;
        }
    }
     //Charan Code Starts :Added for conversion of String to date format for CT3-517
     public static String getDateConverted(String str) {          
         String dateFormat = '';
         if(!String.isEmpty(str)) {
             String[] arr;
             Date dt;
             arr = str.split('/');
             dt = Date.newInstance(Integer.valueOf(arr[2]), Integer.valueOf(arr[0]), Integer.valueOf(arr[1]));
             dateFormat = dt.format(); 
             return dateFormat;   
         }
         else {
            
             return dateFormat;
         }
        
        
     }  //Charan Code ends here for CT3-517
    
    
}