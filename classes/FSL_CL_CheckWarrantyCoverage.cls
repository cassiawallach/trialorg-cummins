/**********************************************************************
Name: FSL_CL_CheckWarrantyCoverage    
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for CheckWarrantyCoverage in User tools.

=======================================================================
=======================================================================

VERSION  AUTHOR            DATE                DETAIL                                 
1.0      PiyushR           2/8/2019            INITIAL DEVELOPMENT
1.1      Charan            1/27/2021          CT3-280-warranty coverage variable(Start Date) update  
1.2      Dinesh Yadav      07/06/2021         CT3-498,Failure date is less than warranty start date + coverage month then it should be active.
1.3      Charan            17/06/2021         CT3-530,while calling basic coverage webservice added logic to ensure right failure point and failure unit are sent.
***********************************************************************/
public without sharing class FSL_CL_CheckWarrantyCoverage {
    /* Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
Static String executionLog = 'Log Start';*/
    public static Boolean donotskippflag{get;set;}
    public static CSS_quickserveCumminsComWebservices.ModelName rDataPlate;
    public static string productAppdesc{get;set;}
    public static string productAppcode{get;set;}
    public Static Map<String,String> mapDescriptionToCode;
    public static String filterApplication{get;set;}
    public static Boolean recconFlag{get;set;}
    public static Boolean displaySrvModPopup {get;set;}
    public static Date WarrStartDt{get;set;}
    public static Boolean wsdReadOnlyFromContr{get;set;}
    public static String FormattedDate {get; set;}
    public static Boolean bisFlag{get;set;}
    public static Boolean ExternReturnDateFlag{get;set;}
    public static Boolean ReadonlyBIS{get;set;}
    public static Map<Object,List<String>> dependValuesByControlValue{get; set;}
    public static FSL_getBasicCoverageResponseJ2A basicCoverageDetails{get; set;}
    public static List<CoverageComponentWrapper> CoverageComponentWrapperList{get;set;}
    public static List<fieldActionWrapper> listFieldActionWrapper{get;set;}
    @AuraEnabled public static Integer faCountcontr{get;set;}
    
    @AuraEnabled
    public static boolean requredProfile(){
        system.debug('inside requredProfile');
        Id profId = userInfo.getProfileId();
        Profile usrProfile = [SELECT Id,Name FROM PROFILE WHERE ID =:profId ];
            if(usrProfile.Name == 'EVL_Dealer_Advanced' || usrProfile.Name == 'EVL_Dealer_Technician' || usrProfile.Name == 'EVL_Dealer_Readonly'){
                return FALSE;
            }
        else
            return TRUE;
    }
    @AuraEnabled
    public static List<WorkOrderWrapper> startRequest(String psnValue){
        System.debug('::: PSN Value - '+psnValue);
        List<Asset> assetList = new List<Asset>();
        List<pickListWrapper> ApplicationList;
        List<WorkOrderWrapper> workOrderWrapperList;
        WorkOrderWrapper woWrapper;
        String selectedAppValue;
        try {
            if(String.isNotEmpty(psnValue)) {
                if(psnValue.length() > 2) {
                    //String serachStr = psnValue;
                    //String searchQuery = 'FIND \''+serachStr+'\' IN ALL FIELDS RETURNING Asset(Name)';
                    //system.debug('Query:'+searchQuery);
                    //List<List<SObject>> searchList = search.query(searchQuery);
                    //assetList = ((List<Asset>)searchList[0]);
                    assetList = [Select Id,Name, Warranty_Start_Date__c, Application_Code__c,No_Warranty__c,Type__c,Engine_Manufacturer__c From Asset where Name=: psnValue ];   //Added:Phoen-128
                    
                    if(!assetList.isEmpty()) {
                        Asset asset = new Asset();
                        if(assetList.size() == 1){
                            asset = assetList[0];
                        }
                        else{
                            for(Asset objAsset : assetList){
                                if(objAsset.Type__c=='Engines' || objAsset.Type__c=='ENGINE'){
                                    asset = objAsset;
                                    break;
                                }
                            }
                        }
                        
                        
                 //       Asset asset = [Select Id, Warranty_Start_Date__c, Application_Code__c,No_Warranty__c,Type__c,Engine_Manufacturer__c From Asset where Name=: psnValue AND (Type__c='Engines' OR Type__c='ENGINE') LIMIT 1 ];   //Added:CT3-485 Charan-No_Warranty__c field
                        
                        ApplicationList = new List<pickListWrapper>();
                        Schema.DescribeFieldResult fieldResult = WorkOrder.Application__c.getDescribe();
                        
                        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
                        
                        for (Schema.PicklistEntry p: pList) {
                            if(asset.Application_Code__c != null) {
                                ApplicationList.add(new pickListWrapper(p.getLabel(), p.getValue(), p.getValue().containsIgnoreCase(asset.Application_Code__c)));
                            } else {
                                ApplicationList.add(new pickListWrapper(p.getLabel(), p.getValue(), null));
                            }
                        }
                        Account[] acc;
                        Boolean NonCumminsFlag = false;
                        if((asset.Engine_Manufacturer__c == null || asset.Engine_Manufacturer__c =='') && !Test.isRunningTest()){
                           NonCumminsFlag = true;
                           system.debug('***NonCumminsAssetFlag' + NonCumminsFlag);
             
                          }
                        if(asset.Engine_Manufacturer__c != 'CUMMINS' && !Test.isRunningTest()) {
                            NonCumminsFlag = true;
                           system.debug('***NonCumminsAssetFlag' + NonCumminsFlag);
        }
                       /* if(fsli.wo.Asset.Engine_Manufacturer__c == null || fsli.wo.Asset.Engine_Manufacturer__c == null){
			obj.ErrorType = 'Non_CumminsAsset';            
        } 
        else if(fsli.wo.Asset.Engine_Manufacturer__c != 'CUMMINS' && !Test.isRunningTest()) {
            obj.ErrorType = 'Non_CumminsAsset';
            system.debug('***Non cummmins in getWarrantyDetailsNew' + obj.ErrorType);
        } */
                        //CT1-372 By Priyanka
                        String primaryServiceProviderCode;
                        Boolean Profilecheck = false;
                        User user = [select id,User_Location__c,AccountId,FSL_Mileage_Measure__c,Profile.Name from user where id =:UserInfo.getUserId() Limit 1];
                        if(User.Profile.Name!=null){
                            if(User.profile.Name == 'EVL_Dealer_Advanced' || User.profile.Name == 'EVL_Dealer_Technician' || User.profile.Name == 'EVL_Dealer_Readonly'){
                                Profilecheck = true;
                            }
                            else{
                                Profilecheck = false;
                            }
                        }
                        if(Profilecheck && user.User_Location__c !=null){
                            if(user.User_Location__c.contains('P')&&user.User_Location__c.contains(',')){
                                String[] locations=user.User_Location__c.split(',');
                                for(String location:locations){
                                    if(location.contains('P')){
                                        primaryServiceProviderCode= location.substringBefore('-P').split('-')[1];
                                    }
                                }
                                if(primaryServiceProviderCode!=null){
                                    acc=[SELECT id,Territory__c, Region__c from account where IAM_Service_Provider_Code__c =:primaryServiceProviderCode LIMIT 1];                                              }
                            }
                            
                            else{
                                
                                primaryServiceProviderCode=user.User_Location__c.split('-')[1];
                                
                                
                                if(primaryServiceProviderCode!=null){
                                    acc=[SELECT id,Territory__c, Region__c from account where IAM_Service_Provider_Code__c =:primaryServiceProviderCode LIMIT 1];                      
                                }
                            }
                        }
                        
                        
                        // Account acc=[SELECT id,Territory__c, Region__c from account where id in (select AccountId from user where id =:UserInfo.getUserId()) LIMIT 1];//CT3-464
                        workOrderWrapperList = new List<WorkOrderWrapper>();
                        woWrapper = new WorkOrderWrapper();
                        woWrapper.pickListWrapperList = ApplicationList;
                        woWrapper.warrantyStartDate = asset.Warranty_Start_Date__c;
                        woWrapper.Application = asset.Application_Code__c;
                        woWrapper.NowarrantyFlag = asset.No_Warranty__c;   //Added:CT3-485 Charan
                        woWrapper.NonCumminsAssetFlag = NonCumminsFlag; 
                        woWrapper.profileCheckIsDealer = Profilecheck;
                        system.debug('woWrapper.profileCheckIsDealer' + woWrapper.profileCheckIsDealer);
                        if(Profilecheck && acc!=null){
                            if(acc.size()>0){
                                woWrapper.Region=acc[0].Region__c;
                                woWrapper.Territory=acc[0].Territory__c;
                            }
                            if(user!=null ){
                                woWrapper.Mileage_Measure=user.FSL_Mileage_Measure__c;
                            }
                        }
                        
                        //woWrapper.Region=acc.Region__c;//commented as part of  CT3-464
                        // woWrapper.Territory=acc.Territory__c;//commented as part of CT3-464
                        
                        workOrderWrapperList.add(woWrapper);                        
                    }
                } 
            }
            
            System.debug(':::WorkOrder List - '+workOrderWrapperList); 
            return workOrderWrapperList;
            
        } catch(Exception ex) {
            System.debug('::: Exception - '+ex.getMessage()+' and '+ex.getCause());
            System.debug('::: Exception Stack - '+ex.getStackTraceString());
            return new List<WorkOrderWrapper>();
        }
    }
    
    
    
    @AuraEnabled
    public static WorkOrderWrapper getUserRegionTerrValues(){
        WorkOrderWrapper  userTerrRegion = new WorkOrderWrapper();
        User usr = [select id,FSL_Primary_Service_Territory_Code__c from user where id =:UserInfo.getUserId() Limit 1];
        ServiceTerritory serTerr;
        if(usr.FSL_Primary_Service_Territory_Code__c!='' ){
           serTerr=[SELECT id,Territory__c, Region__c,Mileage_Measure__c,FSL_Service_Territory_Code__c from ServiceTerritory where FSL_Service_Territory_Code__c =:usr.FSL_Primary_Service_Territory_Code__c LIMIT 1];  
        
    }
        system.debug('serTerr' + serTerr);
            userTerrRegion.Region=serTerr.Region__c;
            userTerrRegion.Territory = serTerr.Territory__c;
            userTerrRegion.Mileage_Measure = serTerr.Mileage_Measure__c;
       return userTerrRegion;
}

@AuraEnabled
public static List<pickListWrapper> getRegionValues(){
    List<pickListWrapper> options = new List<pickListWrapper>();
    Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Region__c.getDescribe();
    List<Schema.PicklistEntry> regValues = fieldResult.getPicklistValues();        
    for(Schema.PicklistEntry picklst : regValues){
        options.add(new pickListWrapper(picklst.getLabel(),picklst.getValue(), false));
    }
    return options;
} 

@AuraEnabled
public static List<pickListWrapper> getApplicationList(){
    List<pickListWrapper> options = new List<pickListWrapper>();
    Schema.DescribeFieldResult fieldResult = WorkOrder.Application__c.getDescribe();
    List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();        
    for(Schema.PicklistEntry picklst : pList){
        options.add(new pickListWrapper(picklst.getLabel(),picklst.getValue(), false));
    }
    return options;
}


@AuraEnabled
public static List<pickListWrapper> getTerritoryValues(String regionSelected){
    List<pickListWrapper> terriotyOptions = new List<pickListWrapper>();
    dependValuesByControlValue = new Map<Object,List<String>>();
    dependValuesByControlValue = getDependentPicklistValues(CSS_Claims__c.Territory__c);
    
    for(Object contrPicklst : dependValuesByControlValue.keySet()){
        if(regionSelected == String.valueof(contrPicklst)){       
            for(String depPicklst : dependValuesByControlValue.get(contrPicklst)){
                terriotyOptions.add(new pickListWrapper(depPicklst,depPicklst,false));
            }
            break;
        }
    }
    System.debug(':::terriotyOptions - '+terriotyOptions);
    return terriotyOptions;
}

public static Map<Object,List<String>> getDependentPicklistValues(Schema.sObjectField dependToken){
    Schema.DescribeFieldResult depend = dependToken.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    if(controlToken == null) 
        return null;
    Schema.DescribeFieldResult control = controlToken.getDescribe();
    List<Schema.PicklistEntry> controlEntries = (control.getType() == Schema.DisplayType.Boolean ? null : control.getPicklistValues());
    
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
    for(Schema.PicklistEntry entry : depend.getPicklistValues()){
        if(entry.isActive()){
            List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
            for(Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++){
                Object controlValue = (controlEntries == null ? (Object)(index == 1) : (Object)(controlEntries[index].isActive() ? controlEntries[index].getLabel() : null));
                Integer bitIndex = index/6, bitShift = 5 - Math.mod(index,6);
                if(controlValue == null || base64chars.size() < 4 || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0) 
                    continue;
                if(!dependentPicklistValues.containsKey(controlValue)){
                    dependentPicklistValues.put(controlValue,new List<String>());
                }
                dependentPicklistValues.get(controlValue).add(entry.getLabel());
            }
        }
    }
    return dependentPicklistValues;
}

public class WorkOrderWrapper {
    @AuraEnabled public List<pickListWrapper> pickListWrapperList;
    @AuraEnabled public Date warrantyStartDate;
    @AuraEnabled public String Application;
    @AuraEnabled public String Region;
    @AuraEnabled public String Territory;
    @AuraEnabled public String Mileage_Measure;
    @AuraEnabled public boolean NowarrantyFlag;   //Added:CT3-485 Charan
    @AuraEnabled public boolean NonCumminsAssetFlag; 
    @AuraEnabled public boolean profileCheckIsDealer; //Added:CT3-487 Sailaja
}


public class pickListWrapper {
    @AuraEnabled public string Label;
    @AuraEnabled public string Value;
    @AuraEnabled public Boolean selected;
    
    public pickListWrapper(string Label, string Value, Boolean selected){
        this.Label = Label;
        this.Value = Value;
        this.selected = selected;
    }
    
}

private static String getDateFormat(String strDate) {
    String warrantyStartDate = strDate;
    String[] strArr = warrantyStartDate.split('-');
    Integer intDate = integer.valueOf(strArr[2]);
    Integer intMonth = integer.valueOf(strArr[1]);
    Integer inYear = integer.valueOf(strArr[0]);
    String newStringDate = intMonth+'/'+intDate+'/'+inYear;
    System.debug('::Date value = '+newStringDate);
    return newStringDate;
}

private static String getLocaleDate(String dateString) {
    String[] stringArray = dateString.split('/');
    Integer valueOne = Integer.valueOf(stringArray[0]);
    Integer valueTwo = Integer.valueOf(stringArray[1]);
    Integer yearValue = Integer.valueOf(stringArray[2]);
    String newDateVal = valueTwo+'/'+valueOne+'/'+yearValue;
    System.debug('::: Date New = '+ newDateVal+' ** and Parsed Date = '+date.parse(newDateVal));
    return newDateVal;
}



@AuraEnabled
public static List<CoverageComponentWrapper> fetchWarrantyCoverage(String config) {
    System.debug('::: Config >> '+config);
    searchParamWrapper configWrap = (searchParamWrapper)JSON.deserialize(config, searchParamWrapper.class);
    System.debug('::: Deserailized Config - '+configWrap); 
    //[appValue=410, esnValue=79788868, regionValue=AUSTRALIA/ NEW ZEALAND, terrValue=AUSTRALIA, warrantyStartDate=2014-12-08] 
    String psnValue = configWrap.esnValue;
    String reconFlag;
    
    String displayCoverageType = configWrap.displayCoverage;
    System.debug('::: displayCoverageType = '+displayCoverageType);
    
    Date WarrStartDt;
    String WarrantyStartDate;
    String startDate;
    if(configWrap.warrantyStartDate != null && configWrap.warrantyStartDate != '') {
        WarrStartDt = date.valueof(configWrap.warrantyStartDate);
        WarrantyStartDate = getFormattedDate(WarrStartDt);
        startDate = getDateFormat(configWrap.warrantyStartDate);
    } else {
        WarrStartDt = date.valueof(System.today());
        WarrantyStartDate = getFormattedDate(WarrStartDt);
        startDate = getDateFormat(String.valueOf(System.today()));
    }
    
    //CT3-498, Dinesh Yadav 
    Date failureDt;
    string strfailureDt;
    string strfailureDate;
    if(configWrap.failureDate != null && configWrap.failureDate != '') {
        failureDt = date.valueof(configWrap.failureDate);
        strfailureDt = getFormattedDate(failureDt);
        strfailureDate = getDateFormat(configWrap.failureDate);
    }
    else {
        failureDt = date.valueof(System.today());
        strfailureDt = getFormattedDate(failureDt);
        strfailureDate = getDateFormat(String.valueOf(System.today()));
    }
    
    String failureUnitValue;
    String failureUnitType;
 // ---------------charan ct3-530 story change starts here -------------------------
   
   /* if(configWrap.prodMileage == '0' || configWrap.prodMileage == null) {
        failureUnitType = 'Hours';
        failureUnitValue = configWrap.prodHour;
    } else {
        failureUnitType = configWrap.prodMileageType;
        failureUnitValue = configWrap.prodMileage;
    }*/
    if((configWrap.prodMileage != '0' || configWrap.prodMileage != null) && String.isNotBlank(configWrap.appValue) &&
	  (configWrap.appValue.contains('130') ||
	  configWrap.appValue.contains('210') ||
	  configWrap.appValue.contains('220') ||
	  configWrap.appValue.contains('260') ||
	  configWrap.appValue.contains('270') ||
	  configWrap.appValue.contains('310') ||
	  configWrap.appValue.contains('320') ||
	  configWrap.appValue.contains('410')))
	{
		failureUnitType = configWrap.prodMileageType;
        failureUnitValue = configWrap.prodMileage;
	}
	else
	{
		failureUnitType = 'Hours';
		failureUnitValue = configWrap.prodHour;
	}
    
	// ---------------charanct3-530  story change end here -------------------------
    
    System.debug('::: Warranty Start Date = '+startDate);
    
    List<asset> assetList = [SELECT Id, Name, Warranty_Start_Date__c , Recon_Engine_Flag__c FROM Asset where Name=: psnValue];
    if(assetList[0].Recon_Engine_Flag__c) {
        reconFlag = 'Y';
    } else {
        reconFlag = 'N';
    }
    
    System.debug(':::ReconFlag Value = '+reconFlag);        
    
    CSS_getBasicCoverageReqJ2A getBasicCoverageReq = new CSS_getBasicCoverageReqJ2A();
    CSS_getBasicCoverageReqJ2A.DataArea requestData = new CSS_getBasicCoverageReqJ2A.DataArea();
    
    basicCoverageDetails = new FSL_getBasicCoverageResponseJ2A();
    
    List <FSL_getBasicCoverageResponseJ2A.CoverageComponentList> coverageComponentList = 
        new List <FSL_getBasicCoverageResponseJ2A.CoverageComponentList> ();
    
    Map<String, List <FSL_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG = 
        new Map<String, List <FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>();
    Map<String, Map<String, List<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>> coverageByDefTypeMap = 
        new Map<String, Map<String, List<FSL_getBasicCoverageResponseJ2A.CoverageComponentList>>> ();
    
    
    map < string, string > coverageURLProceMap = new map < string, string > ();
    map < string, string > tempcoverageURLProceMap = new map < string, string > ();
    
    requestData.ESN = configWrap.esnValue;
    requestData.EngineApplicationCode = configWrap.appValue;
    requestData.Region = configWrap.regionValue;
    requestData.Territory = configWrap.terrValue;
    requestData.WarrantyStartDate = startDate;
    requestData.FailureDate = strfailureDate;
    requestData.FailurePoint = failureUnitValue;
    requestData.FailureUnit = failureUnitType;
    requestData.PartsWarranty = 'Y';
    requestData.ReconFlag = reconFlag;
    //requestData.JobId = null;
    
    getBasicCoverageReq.DataArea = requestData;
    system.debug('::: getBasicCoverageReq' + ' ' + getBasicCoverageReq);
    
    // basicCoverageDetails = FSL_WS_SBL.getBasicCoverage(getBasicCoverageReq);
    
    //Will remove later when integration work - added to hardcode the integration end point
   // basicCoverageDetails =  getBasicCoverage(getBasicCoverageReq);
  //  getNamedCredBasicCoverage
  
   //By Priyanka VGRS2-517
    basicCoverageDetails =  getNamedCredBasicCoverage(getBasicCoverageReq);
    
    System.debug('::: BasicCoverageDetails - '+basicCoverageDetails);
    
    //List<CoverageComponentWrapper> CoverageComponentWrapperList = new List<CoverageComponentWrapper>(); commenting for Mile KM Conversion
    CoverageComponentWrapperList = new List<CoverageComponentWrapper>();
    
    Date curDate = Date.today(); // replace all below curDate usage with FailureDate. 
    String prodMileKm = configWrap.prodMileage;
    String prodHours = configWrap.prodHour;
    
    if(basicCoverageDetails != null) {
        
        System.debug(':::BasicCoverageDetails => '+basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails);
        System.debug(':::ExtendedCoverageDetails => '+basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
        for (FSL_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
            System.debug('::: CoverageDetails = '+c);
            system.debug('::: c.CoverageType>>>>>>' + c.CoverageType);
            
            //CT3-544, Dinesh Yadav
            Decimal constantDecutibleAmt = 0;
            Decimal firstVisitAmt = 0;
            for(FSL_getBasicCoverageResponseJ2A.CoverageDedutibles cd : c.ListOfCoverageDedutibles.CoverageDedutibles)
            {
                if(cd.firstVisitAmt != null && cd.firstVisitAmt!='')
                    firstVisitAmt = decimal.valueOf(cd.firstVisitAmt);
                if(cd.constantDecutibleAmt != null && cd.constantDecutibleAmt !='' )
                    constantDecutibleAmt = decimal.valueOf(cd.constantDecutibleAmt);
            }
            
            System.debug('firstVisitAmt --' + firstVisitAmt + ' constantDecutibleAmt --'+constantDecutibleAmt);
            
            for (FSL_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                CoverageComponentWrapper coverage = new CoverageComponentWrapper();
                coverage.status = ccl.Componentstatus;
                
                String remainingValue = '';
                system.debug('ComponentEnddate :: '+ccl.ComponentEnddate);
                system.debug('WarrantyEndDate :: '+ccl.WarrantyEndDate);
                if(ccl.ComponentEnddate != null && ccl.ComponentEnddate!= '') {
                    String crtdtEndDate;
            
                    /*if(UserInfo.getLocale() != 'en_US') {
                        crtdtEndDate = getLocaleDate(ccl.ComponentEnddate);
                        
                    } else {
                        crtdtEndDate = ccl.ComponentEnddate;                      
                    }*/
                    string[] stringArray = ccl.ComponentEnddate.split('/');
                    Integer monthValue = Integer.valueOf(stringArray[0]);
                    Integer dateValue = Integer.valueOf(stringArray[1]);
                    Integer yearValue = Integer.valueOf(stringArray[2]);
                    Date myDate = date.newinstance(yearValue, monthValue, dateValue);

                    system.debug('crtdtEndDate 1 :: '+crtdtEndDate);
                    system.debug('crtdtEndDate myDate :: '+myDate);
                    try{
                        //date cd = date.parse(crtdtEndDate); //CT3-545
                        date cd = myDate;
                        system.debug('cd update date :: '+cd);
                        ccl.WarrantyEndDate = getFormattedDate(cd);
                        coverage.WarrantyEndDate = ccl.WarrantyEndDate;

                        remainingValue = css_utility.getRemainingYearsMonthsDays(failureDt,myDate);
                    }
                    catch(Exception e)  {
                        system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                    }
                }
                
                coverage.WarrantyStartDate = WarrantyStartDate;
                coverage.CoverageType = c.CoverageType;
                coverage.CoverageHours = ccl.CoverageHours;
                coverage.CoverageMaxMonths = ccl.CoverageMaxMonths;
                coverage.CoverageComponentTypeCode = ccl.CoverageComponentTypeCode;
                coverage.MegawattHours = ccl.MegawattHours;
                coverage.CoverageDefenitionType = ccl.CoverageDefenitionType;
                coverage.CoverageMinMonths = ccl.CoverageMinMonths;
                coverage.CoverageMiles = ccl.CoverageMiles;
                coverage.WarrantyManualURL = c.WarrantyManualURL+c.ProcedureNumber;
                coverage.Remaining = remainingValue;
                
                //CT3-544, Dinesh Yadav
                if(constantDecutibleAmt != 0)
                	coverage.Dedutibles = string.valueOf(constantDecutibleAmt);
                else 
                    coverage.Dedutibles = string.valueOf(firstVisitAmt);
                
                CoverageComponentWrapperList.add(coverage);
                system.debug('CoverageComponentWrapperList**'+CoverageComponentWrapperList);
            } //end of inner 2 loop
            /*} else {// Harsha commented for User Tools
System.debug(':::::: 2 c.CoverageType>>>>>> '+c.CoverageType);
}*/// Harsha commented for User Tools
            
        }
        
        //ExtendedCoverageDetails
        for (FSL_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) 
        {
            
            // String Warranty_Start_Date = ''; // Commented for CT3-280 fix  
            String Warranty_End_Date = '';
            System.debug('::: Date Values = '+failureDt+' *** '+crtdt.EndDate);
            String crtdtEndDate;
            
            /*if(UserInfo.getLocale() == 'en_US') {
                crtdtEndDate = getLocaleDate(crtdt.EndDate);
                
            } else {
                crtdtEndDate = crtdt.EndDate;
                
            }*/
           
            String remainingValue = '';
            if(crtdt.EndDate != null && crtdt.EndDate != '') {
                try{
                    string[] stringArray = crtdt.EndDate.split('/');
                    Integer monthValue = Integer.valueOf(stringArray[0]);
                    Integer dateValue = Integer.valueOf(stringArray[1]);
                    Integer yearValue = Integer.valueOf(stringArray[2]);
                    Date myDate = date.newinstance(yearValue, monthValue, dateValue);
        
                    //date cd = date.parse(crtdtEndDate);
                    date cd = myDate;
                    Warranty_End_Date = getFormattedDate(cd);
                    
                    remainingValue = css_utility.getRemainingYearsMonthsDays(failureDt,myDate);
                }catch(Exception e)  {
                    system.debug('::: EXCEPTION occured while converting crtdt.EndDate >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                }
            }
            
            //CT3-544, Dinesh Yadav
            Decimal firstVisitAmt = 0;
            Decimal constantDecutibleAmt = 0;
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
            
            CoverageComponentWrapper coverage = new CoverageComponentWrapper();
            coverage.status = crtdt.Status;
            coverage.WarrantyEndDate = Warranty_End_Date;
            //  WarrantyStartDate added for CT3-280 fix 
            coverage.WarrantyStartDate = WarrantyStartDate; 
            coverage.CoverageType = null;
            coverage.CoverageHours = crtdt.EndHours;
            coverage.CoverageMaxMonths = crtdt.Months;
            coverage.CoverageComponentTypeCode = 'Extended Warranty '+crtdt.CAPCoverageID+'/'+crtdt.CertificateNumber;
            coverage.MegawattHours = null;
            coverage.CoverageDefenitionType = null;
            coverage.CoverageMinMonths = null;
            coverage.CoverageMiles = crtdt.EndMiles;
            coverage.WarrantyManualURL = crtdt.WarrantyManualURL+crtdt.ProcedureNumber;
            coverage.Remaining = remainingValue;
            
            //CT3-544, Dinesh Yadav
            if(constantDecutibleAmt != 0)
                coverage.Dedutibles = string.valueOf(constantDecutibleAmt);
            else 
                coverage.Dedutibles = string.valueOf(firstVisitAmt);
            
            CoverageComponentWrapperList.add(coverage);
        }
        
    } else {
        System.debug('::: BasicCoverageDetails is NULL');
    }
    system.debug('CoverageComponentWrapperList**'+CoverageComponentWrapperList);
    if(!CoverageComponentWrapperList.isEmpty()){
        return CoverageComponentWrapperList;
    } else {
        return null;
    }
}
//method to fetch field actions from webservice:CT3-7...
/*@AuraEnabled
public static Integer myCount(){
return faCount;
}*/
@AuraEnabled
public static List<fieldActionWrapper> fetchFieldActions(String config) {
    //try{
    listFieldActionWrapper = new List<fieldActionWrapper>();
    System.debug('::: Config >> '+config);
    searchParamWrapper configWrap = (searchParamWrapper)JSON.deserialize(config, searchParamWrapper.class);
    System.debug('::: Deserailized Config - '+configWrap); 
    string strESN = configWrap.esnValue;
    Date failureDate;
    if(configWrap.failureDate != null)
        failureDate = date.valueof(configWrap.failureDate);
    else {
        failureDate = system.today(); 
    }
    system.debug('FDate**'+failureDate);
    /*if(configWrap.warrantyStartDate != null && configWrap.warrantyStartDate != '') {
WarrStartDt = date.valueof(configWrap.warrantyStartDate);
WarrantyStartDate = getFormattedDate(WarrStartDt);
startDate = getDateFormat(configWrap.warrantyStartDate);
} else {
WarrStartDt = date.valueof(System.today());
WarrantyStartDate = getFormattedDate(WarrStartDt);
startDate = getDateFormat(String.valueOf(System.today()));
}*/
    string strRegion = configWrap.regionValue;
    string strTerritory = configWrap.terrValue;
    //String strFdate = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('DD-MMM-YY');
    DateTime dFdate= DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day());
    //String strFdate = dFdate.format('DD-MMM-YY');
    String strFdate = css_utility.FormatDate(failureDate);
    String strFdate1 = dFdate.format('DD-MMM-YY'); //not working 190-jul-20
    system.debug('Year**'+failureDate.year());
    system.debug('Month**'+failureDate.month());
    system.debug('Day**'+failureDate.day());
    system.debug('strFdate**'+strFdate);
    strFdate = strFdate.replace(' ','-');
    string [] strarray = new List<string>();
    strarray = strFdate.split('-');
    //string strYear = strarray[2].left(2); //CT3-253 - Dinesh Yadav
    string strYear = strarray[2].right(2); //CT3-253 - Dinesh Yadav
    system.debug('strFdate**'+strFdate);
    system.debug('strYear**'+strYear);
    strFdate = strarray[0]+'-'+strarray[1]+'-'+strYear;
    system.debug('Final FailureDate**'+strFdate);
    /*// Preparing Request body and passing the parameters dynamically 
FSLgetCampaignRequestwrap.Sender fslcamp = new FSLgetCampaignRequestwrap.Sender();
fslcamp.ServiceName = 'GetCampaign';
fslcamp.SenderID = 'CSS';
fslcamp.MessageID = '';

FSLgetCampaignRequestwrap.DataArea clsData = new FSLgetCampaignRequestwrap.DataArea();
clsData.Territory = strTerritory ;
clsData.Region = strRegion ;
//clsData.FailureDate = objWO.Formatted_Date__c; //strFdate;
clsData.FailureDate = strFdate; //strFdate;
clsData.Esn = strESN ;

FSLgetCampaignRequestwrap.Header fslhead = new FSLgetCampaignRequestwrap.Header();
fslhead.Target = 'CSSWarranty';
fslhead.Sender = fslcamp;

FSLgetCampaignRequestwrap clswrp = new FSLgetCampaignRequestwrap();
clswrp.DataArea = clsData;
clswrp.Header = fslhead ;
system.debug('***i just added debug for clswrp***'+clswrp);
String jsonreq = JSON.serialize(clswrp);
system.debug('***i just added debug for jsonreq***'+jsonreq);*/
    List<CSS_Solution_Component__c> lstSC = new List<CSS_Solution_Component__c>();
    system.debug('Line 550 strRegion'+strRegion+'strTerritory'+strTerritory+'strFdat'+strFdate);
    lstSC = FSL_GETCampaignServices.getFieldActions(strESN,strRegion,strTerritory,strFdate); //passing null for woId for now.
    system.debug('Retrieved FieldActions--->'+lstSC);
    //Now put the list into a wrapper
    listFieldActionWrapper = new List<fieldActionWrapper>();
    if(lstSC != null && lstSC.size()>0){
        //faCount = string.valueof(lstSC.size());
        faCountcontr = lstSC.size();
        for(CSS_Solution_Component__c solcomp : lstSC){
            // listFieldActionWrapper.add(new fieldActionWrapper(solcomp.id,solComp.name,SolComp.Type__c+'-'+SolComp.Campaign_Description__c) );
            listFieldActionWrapper.add(new fieldActionWrapper(solcomp.id,solComp.name,SolComp.Campaign_Description__c,SolComp.FSL_Link__c) );
        }
        system.debug('Retrieved FieldActionsWrapper--->'+listFieldActionWrapper);
    }
    //Testing code
    /*system.debug('before updating strESN--->'+strESN);
if(strESN=='79462280'){
//objWO.Available_FAs_Count__c = '1';
//objWO.Required_To_Complete__c = '1';
system.debug('in updating strESN--->'+strESN);
}else{
objWO.Available_FAs_Count__c = '2';
objWO.Required_To_Complete__c = '1';
system.debug('in updating strESN--->'+strESN);
}
update objWO;
system.debug('after updating strESN--->'+strESN);
*/
    // }catch(Exception e){
    //    System.debug('Exception in calling FA service...');
    // }
    return listFieldActionWrapper;
}
//BY Priyanka for VGRS2-517
public static FSL_getBasicCoverageResponseJ2A getNamedCredBasicCoverage(CSS_getBasicCoverageReqJ2A getBasicCoverageReq) {
    
    System.debug('::: in getBasicCoverage of CSS_WS_SBL....');
     CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
		FSL_IP_NamedCredentialWrapper reqWrap = new FSL_IP_NamedCredentialWrapper();
    FSL_getBasicCoverageResponseJ2A basicCoverageDetails;
    string endPointURL;
    HttpResponse res = new HttpResponse();
    HttpRequest req1 = new HttpRequest();
    string message;
    try{
        string ESN;
        string Region;
        string Territory;
        string WarrantyStartDate;
        string EngineApplicationCode;
        string Jobd;
        string FailurePoint;
        string FailureUnit;
        string reconFlag;
        string failureDate;
        
        ESN = getBasicCoverageReq.DataArea.ESN;
        Region = getBasicCoverageReq.DataArea.Region;   
        Territory = getBasicCoverageReq.DataArea.Territory;   
        WarrantyStartDate = getBasicCoverageReq.DataArea.WarrantyStartDate;   
        EngineApplicationCode = getBasicCoverageReq.DataArea.EngineApplicationCode;
        Jobd = getBasicCoverageReq.DataArea.JobId;   
        FailurePoint = getBasicCoverageReq.DataArea.FailurePoint;
        FailureUnit = getBasicCoverageReq.DataArea.FailureUnit; 
        reconFlag = getBasicCoverageReq.DataArea.ReconFlag;
        failureDate = getBasicCoverageReq.DataArea.FailureDate;
        
        reqWrap.methodType = 'POST';
    reqWrap.NamedCredential = 'FSL_NC_Warranty';
    reqWrap.Path = '/v1/coverage/basic';
     String JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","FailureDate": "'+FailureDate+'","PartsWarranty": "Y", "FailurePoint":"'+FailurePoint+'", "FailureUnit":"'+FailureUnit+'", "ReconFlag":"'+reconFlag+'"}}'; //#85179
           // req1.setBody(JSONReq);
         reqWrap.jsonReqBody = JSONReq;
    reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                       					where DeveloperName=: reqWrap.NamedCredential 
                       					LIMIT 1].Endpoint+reqWrap.Path;
        
        if(Test.isRunningTest() && reqWrap.jsonReqBody == null)
                {
                throw new CSS_MyException('Exception to cover Catch block');
                }
                           

                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
             system.debug(' priyaresponse>>>>>>>>>>>'+returnWrapper);
   
        if(Test.isRunningTest()) {
            String resBody = FSL_TestDataUtility.checkWarrantyResponses();
            res.setStatusCode(200);
            res.setBody(resBody);
        } else {
              res = returnWrapper.response;
            //  system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
            //executionLog = FSL_ApplicationLogger.logMessage('Response Body '+res,executionLog,isEligibleForAppLogging);
            // FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
        }
        
        System.debug('getBasicCoverage res****'+res);
        //Setting response to the string
        // string jsonResponseBody = res.getBody();
        if(res.getStatusCode() == 200){
            string jsonResponseBody = res.getBody();
            system.debug('getBasicCoverage Response jsonrespbasiccov>>>>:'+jsonResponseBody);
            system.debug('jobd::'+jobd);
            if(Test.isRunningTest()){
                jsonResponseBody='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/27/2015","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6251","ComponentEndDate":"3/27/2014","ComponentStatus":"Expired","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6251","ComponentEndDate":"3/27/2015","ComponentStatus":"Expired","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"3/27/2018","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","ComponentEndDate":"3/27/2018","ComponentStatus":"Expired","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","ComponentEndDate":"3/27/2018","ComponentStatus":"Expired","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"03/27/2018","StartDate":"03/27/2013","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000189","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"03/27/2016","StartDate":"03/27/2013","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000189","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"}]}}}}';
            }
            //de-serializing the response and mapping it to wrapper class
            basicCoverageDetails= (FSL_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,FSL_getBasicCoverageResponseJ2A.class);
            System.debug('Status Code >>> :: '+res.getStatusCode());
            System.debug('REST response is :: '+res);
            system.debug('Response Body >>>'+res.getbody());
            
            
            
            
            system.debug('WarpperResponse'+basicCoverageDetails);
        }
        
        else{
            
            css_utility.LogOutIntError(endPointURL,res.toString()+'-SBL get basic Coverage', res.getStatus()+string.valueOf(res.getStatuscode()), 'SBL');
        }
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
    }
    catch(Exception ex){
        System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
        System.debug('getMessage*********************is :: '+ex.getMessage());
        if(!Test.isRunningTest()){
            message = ex.getMessage();
            //executionLog = FSL_ApplicationLogger.logMessage('Exception Reason '+message ,executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
            if(message.contains('timed out')){
                css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', 'RESPONSE IS NULL', 'SBL');
            }
            else{
                css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', res.getBody(), 'SBL');
            }
        }
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
    }
    
    return basicCoverageDetails;
    
}
/*
//Start Method to get basic Coverage...This function is to be used in warranty coverage Search Functionality/
public static FSL_getBasicCoverageResponseJ2A getBasicCoverage(CSS_getBasicCoverageReqJ2A getBasicCoverageReq) {
    //DateTime startTime = System.Now();
    //executionLog = FSL_ApplicationLogger.logStart('FSL_CL_CheckWarrantyCoverage : getBasicCoverage method ' + startTime, executionLog , isEligibleForAppLogging);
    //executionLog = FSL_ApplicationLogger.logMessage('WorkOrder Id '+'',executionLog,isEligibleForAppLogging);
    //executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+getBasicCoverageReq,executionLog,isEligibleForAppLogging);
    //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
    FSL_getBasicCoverageResponseJ2A basicCoverageDetails;
    string endPointURL;
    HttpResponse res = new HttpResponse();
    HttpRequest req1 = new HttpRequest();
    string message;
    try{
        string ESN;
        string Region;
        string Territory;
        string WarrantyStartDate;
        string EngineApplicationCode;
        string Jobd;
        string FailurePoint;
        string FailureUnit;
        string reconFlag;
        string failureDate;
        
        ESN = getBasicCoverageReq.DataArea.ESN;
        Region = getBasicCoverageReq.DataArea.Region;   
        Territory = getBasicCoverageReq.DataArea.Territory;   
        WarrantyStartDate = getBasicCoverageReq.DataArea.WarrantyStartDate;   
        EngineApplicationCode = getBasicCoverageReq.DataArea.EngineApplicationCode;
        Jobd = getBasicCoverageReq.DataArea.JobId;   
        FailurePoint = getBasicCoverageReq.DataArea.FailurePoint;
        FailureUnit = getBasicCoverageReq.DataArea.FailureUnit; 
        reconFlag = getBasicCoverageReq.DataArea.ReconFlag;
        failureDate = getBasicCoverageReq.DataArea.FailureDate;
        
        Http h1 = new Http();
        //  HttpRequest req1 = new HttpRequest();
        String access_token =null;
        if(!Test.isRunningTest()){// Harsha Added for User Tools Mule Changes
            access_token =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').AuthEnv__c,'CSS_SBL_BCOVER').accessToken;//receiveToken();
        }else{// Harsha Added for User Tools Mule Changes
            access_token='';
        }// Harsha Added for User Tools Mule Changes
        
        
        
        if(!Test.isRunningTest()){
            endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER').End_Point__c; // Connecting to stg
            //executionLog = FSL_ApplicationLogger.logMessage('End point URL '+endPointURL,executionLog,isEligibleForAppLogging);
            //  system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
        }else{
            endPointURL = 'https://services-dev.cummins.com/csswarranty/';
        }
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();// Harsha Added for User Tools Mule Changes
        conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_BCOVER');// Harsha Added for User Tools Mule Changes
        system.debug('endPoinbasiccoveragetURL--->'+endPointURL);
        req1.setHeader('Authorization','Bearer '+access_token);
        if(Test.isRunningTest()){// Harsha Added for User Tools Mule Changes
            conDetails= new CSS_Integration_Details__c();
            conDetails.Username__c=conDetails.Username__c==null? '4546545456454545444545': conDetails.Username__c;
            conDetails.Passcode__c=conDetails.Passcode__c==null? '54654564564654655454564565': conDetails.Passcode__c;
        }
        req1.setHeader('client-id',conDetails.Username__c);// Harsha Added for User Tools Mule Changes
        req1.setHeader('client-secret',conDetails.Passcode__c);// Harsha Added for User Tools Mule Changes
        req1.setMethod('POST');
        req1.setEndpoint(endPointURL);
        //Building Request 
        req1.setHeader('Content-Type','application/json');
        // req1.setMethod('POST');
        // req1.setEndpoint(endPointURL);
        //string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","PartsWarranty": "Y"}}';             
        System.debug('getBasicCoverage EngineApplicationCode>>>:'+EngineApplicationCode);
        System.debug('failureDate ::'+failureDate);
        string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetBasicCoverage","SenderID": "CSS"},"Target": { "TargetID": "SIEBEL" }},"DataArea": {"ESN": "'+ESN+'","EngineApplicationCode": "'+EngineApplicationCode+'","Region": "'+Region+'","Territory": "'+Territory+'","WarrantyStartDate": "'+WarrantyStartDate+'","FailureDate": "'+failureDate+'", "PartsWarranty": "Y", "FailurePoint":"'+FailurePoint+'", "FailureUnit":"'+FailureUnit+'", "ReconFlag":"'+reconFlag+'"}}';  //#85179           
        req1.setBody(JSONReq);
        System.debug('getBasicCoverage req1.getBody======'+req1.getBody());
        //Sending request 
        if(Test.isRunningTest()) {
            String resBody = FSL_TestDataUtility.checkWarrantyResponses();
            res.setStatusCode(200);
            res.setBody(resBody);
        } else {
            res = h1.send(req1);
            //  system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
            //executionLog = FSL_ApplicationLogger.logMessage('Response Body '+res,executionLog,isEligibleForAppLogging);
            // FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
        }
        
        System.debug('getBasicCoverage res****'+res);
        //Setting response to the string
        // string jsonResponseBody = res.getBody();
        if(res.getStatusCode() == 200){
            string jsonResponseBody = res.getBody();
            system.debug('getBasicCoverage Response jsonrespbasiccov>>>>:'+jsonResponseBody);
            system.debug('jobd::'+jobd);
            if(Test.isRunningTest()){
                jsonResponseBody='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"3/27/2015","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6251","ComponentEndDate":"3/27/2014","ComponentStatus":"Expired","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6251","ComponentEndDate":"3/27/2015","ComponentStatus":"Expired","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"3/27/2018","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","ComponentEndDate":"3/27/2018","ComponentStatus":"Expired","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","ComponentEndDate":"3/27/2018","ComponentStatus":"Expired","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"03/27/2018","StartDate":"03/27/2013","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000189","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"03/27/2016","StartDate":"03/27/2013","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000189","EndHours":"0","CoverageType":"CAP-Customized Assurance Plan","ProcedureNumber":"111-505-129"}]}}}}';
            }
            //de-serializing the response and mapping it to wrapper class
            basicCoverageDetails= (FSL_getBasicCoverageResponseJ2A)JSON.deserialize(jsonResponseBody,FSL_getBasicCoverageResponseJ2A.class);
            System.debug('Status Code >>> :: '+res.getStatusCode());
            System.debug('REST response is :: '+res);
            system.debug('Response Body >>>'+res.getbody());
            
            
            
            
            system.debug('WarpperResponse'+basicCoverageDetails);
        }
        
        else{
            
            css_utility.LogOutIntError(endPointURL,res.toString()+'-SBL get basic Coverage', res.getStatus()+string.valueOf(res.getStatuscode()), 'SBL');
        }
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
    }
    catch(Exception ex){
        System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
        System.debug('getMessage*********************is :: '+ex.getMessage());
        if(!Test.isRunningTest()){
            message = ex.getMessage();
            //executionLog = FSL_ApplicationLogger.logMessage('Exception Reason '+message ,executionLog,isEligibleForAppLogging);
            //FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),null);
            if(message.contains('timed out')){
                css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', 'RESPONSE IS NULL', 'SBL');
            }
            else{
                css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-SBL get basic Coverage', res.getBody(), 'SBL');
            }
        }
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req1.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
    }
    
    return basicCoverageDetails;
    
}
*/
public static string receiveToken(){
    System.debug('::: receiveToken get called');
    string accessToken;
    string endPoint;
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    try{
        // HttpRequest req = new HttpRequest();
        Http http = new Http();
        string client_id;
        string client_secret;
        system.debug('::: oagdescrip');
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        if(!Test.isRunningTest()){
            conDetails = getConnection('OAGOAuth');
            //conDetails = getConnection('MuleAuthDEV');
            system.debug(':::conDetails' + conDetails);
            endPoint = conDetails.End_Point__c;
            client_id = conDetails.Username__c;   
            client_secret = ConDetails.Passcode__c; 
            
            /*endPoint = 'https://services-stg-oauth.cummins.com/api/oauth/token/css'; 
client_id = '20f56d87-8e65-46ce-9649-85d7c9335db7';  
client_secret = 'd95d65da-f878-489a-aa1e-20919269cc19'; */
        }
        else{
            endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
            client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
        }
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
        req.setTimeout(120000);
        if(!Test.isRunningTest()){
            res = http.send(req);
            // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
        }else{
            res.setBody('{"access_token":"94pPkrL0Yt2guPTJJxM9PYTxZZ8it2YYy2twpGN8q7EN313l1GU6sX","token_type":"Bearer","expires_in":24000,"refresh_token":"VGaPh5uivMb7vtGUoT7aXeN9pyaa0QiYH7Im1qE7g7WNLZ","scope":"CSSCloud"}');
            res.setStatusCode(200);
        }
        string jSONRequestBody = res.getBody();
        CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
        accessToken = wo1.access_token;
        System.debug(':::BODY: '+res.getBody());  
        System.debug(':::Status: '+res.getStatus());
        System.debug(':::Status Code: '+res.getStatusCode());
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage'));  
    }
    catch(exception e){
        System.debug(':::in catch of receiveToken of CSS_SRT class... Error lineNo>>>>>>>>>>>>>>:'+e.getLineNumber()+' Error msg>>>>>>>>>>>>>>>:'+e.getMessage());
        if(!Test.isRunningTest()){
            css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res==null?'RESPONSE IS NULL':res.getBody(), 'SRT');
            //  System.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'get basic Coverage',res.getStatus(),'code','toolid',''));  
            //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'CheckWarantyCoverage',res.getStatus(),'code','toolid','Guidanz',Null,'CheckWarantyCoverage')); 
        }
    }
    return accessToken;
} 

public static CSS_Integration_Details__c getConnection(string appName){
    Blob key = Blob.valueOf('12345678901234567890123456789012');
    string algo = 'AES256';
    CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
    System.debug(':::Application Name is '+appName);
    CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(appName);
    system.debug(':::getting app'+conDetails);
    if(conDetails != null && conDetails.IsActive__c == true)
    {
        inteDetails.Name = conDetails.Name;
        inteDetails.ApplicationName__c = conDetails.ApplicationName__c;
        inteDetails.End_Point__c = conDetails.End_Point__c;
        inteDetails.IsActive__c = conDetails.IsActive__c;
        inteDetails.Key__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Key__c)).toString();
        inteDetails.Passcode__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Passcode__c)).toString();
        inteDetails.Username__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Username__c)).toString();
        
        system.debug(':::inteDetails***'+inteDetails);
        return inteDetails;
    }
    else
        return null;
}

public static String getFormattedDate(Date d){
    String formattedDate;
    try{
        system.debug(':::Date d ==> '+d);
        if(d != null)
            formattedDate = css_utility.FormatDate(d);
    }catch(exception e){ 
        system.debug(':::Exception in catch getFormattedDate exception>>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
    }
    return formattedDate;
}

public static List<SelectOption> getApplication() {
    List<SelectOption> lstApplications;
    CSS_WPR_SBL_ApplicationResJSON resJSON;
    try {
        resJSON = CG_BL_Intake.getApplicationCodesWrapper();
        
        //create a map with code and description
        mapDescriptionToCode = new map<string,string>();
        
        lstApplications = new List<SelectOption>();
        lstApplications.add(new SelectOption('','Select One'));
        //lstApplications.add(new SelectOption('','----Select One----'));
        System.debug(':::CSS_WPR_SBL_ApplicationResJSON - '+resJSON); //BDS
        if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
            for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                if(det.ActiveFlag == 'Y'){
                    lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                    mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                }
            }
        }
        lstApplications.sort();
        system.debug('lstApplications>>>'+lstApplications);
        
    }catch(exception e){
        system.debug('EXCEPTION of CG_CL_IntakeUENoERP - getApplicationCodes Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
    }
    return lstApplications;
}


public class CoverageComponentWrapper {
    @AuraEnabled public String status{get;set;}
    @AuraEnabled public String WarrantyStartDate{get;set;}
    @AuraEnabled public String WarrantyEndDate{get;set;}
    @AuraEnabled public String coverageType{get;set;}
    @AuraEnabled public String CoverageHours{get;set;}
    @AuraEnabled public String CoverageMaxMonths{get;set;}
    @AuraEnabled public String CoverageComponentTypeCode{get;set;}
    @AuraEnabled public String MegawattHours{get;set;}
    @AuraEnabled public String CoverageDefenitionType{get;set;}
    @AuraEnabled public String CoverageMinMonths{get;set;}
    @AuraEnabled public String CoverageMiles{get;set;}
    @AuraEnabled public String WarrantyManualURL{get;set;}
    @AuraEnabled public String Remaining{get;set;}
    @AuraEnabled public String Dedutibles{get;set;} //Added:Charan
    
}

public class fieldActionWrapper {
    @AuraEnabled public String id{get;set;}
    @AuraEnabled public String faName{get;set;}
    @AuraEnabled public String faDescription{get;set;}
    @AuraEnabled public String faLink{get;set;}
    public fieldActionWrapper(String id, String faName, String faDescription, String faLink){
        this.id = id;
        this.faName =  faName;
        this.faDescription = faDescription;
        this.faLink = faLink;
    }
}

public class searchParamWrapper {
    @AuraEnabled public String esnValue;
    @AuraEnabled public String appValue;
    @AuraEnabled public String regionValue;
    @AuraEnabled public String terrValue;
    @AuraEnabled public String warrantyStartDate;
    @AuraEnabled public String displayCoverage;
    @AuraEnabled public String prodMileage;
    @AuraEnabled public String prodMileageType;
    @AuraEnabled public String prodHour;
    @AuraEnabled public String failureDate;
    
    public searchParamWrapper(String esnValue, String appValue, String regionValue, String terrValue, String warrantyStartDate, String displayCoverage, 
                              String prodMileage, String prodMileageType, String prodHour, String failureDate) {
                                  this.esnValue = esnValue;
                                  this.appValue = appValue;
                                  this.regionValue = regionValue;
                                  this.terrValue = terrValue;
                                  this.warrantyStartDate = warrantyStartDate;
                                  this.displayCoverage = displayCoverage;
                                  this.prodMileage = prodMileage;
                                  this.prodMileageType = prodMileageType;
                                  this.prodHour = prodHour;
                              }
}
}