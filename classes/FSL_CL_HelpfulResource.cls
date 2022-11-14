public class FSL_CL_HelpfulResource {
    public static String myBase64String {get;set;} 
    public static string psnValue {get; set;}
    public static boolean invalidPSN{get; set;}
    
    public FSL_CL_HelpfulResource()
    {
        invalidPSN = true;  
    }
    
    @AuraEnabled
    public static map<String, String> startRequest(String enteredPSN){
        Map<String, String> linksMap = new Map<String, String>();
        psnValue = enteredPSN;
        List<Asset> assetList = new List<Asset>();
        assetList = [Select Id, Name From Asset where Name =: enteredPSN];
        System.debug('::: Asset List - '+assetList);
        
        if(!assetList.isEmpty()) {
            invalidPSN = false;
            linksMap.put('isPSNValid', 'TRUE');
            linksMap.put('partlink', getParts());
            linksMap.put('servicelink', getService());
            linksMap.put('dataPlatelink', getDataPlate());
            linksMap.put('smnfmilink', getSpnFmi());
            linksMap.put('ecmlink', ECM_CalibrationRevisionHistory());
            linksMap.put('wiringdiagramlink', getWiringDiagram()); //story : CT2-78
            System.debug('::: Links Map - '+linksMap);
        } else {
            invalidPSN = true;
            linksMap.put('isPSNValid', 'FALSE');
        }
        return linksMap;
    }
    
    // Method for helpful resources - start
    public static string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
    
    public static string getParts(){
        // return 'http://parts-stg.cummins.com/integration?serialNumber='+psnValue;  
        string url = Label.FSL_HR_Parts_Catalog_Link;
		
		string strLang = getLanguage();
		if(strLang == 'ko')
			url = url+psnValue+'&language=en'; //Added English default of QSOL team confirmed KO is not working. 
		else
			url = url+psnValue+'&language='+getLanguage();
		
		
        //url = url+psnValue+'&language='+getLanguage();
        return url;
    }
  
    public static string getService(){
        System.debug('::: PSN Value getService - '+psnValue);
        string token = gettoken();
        string url = Label.fsl_qsol_helpful_links ;
        url = url + 'login/lnkmgmt/service.html?esn='+psnValue+'&tokenId='+token+'&language='+getLanguage();
        return url;
        
    }
    
    public static string getDataPlate(){
       // return 'http://parts-stg.cummins.com/integration?serialNumber='+psnValue+'&redirectTo=dataplate'; 
        string url = Label.FSL_HR_Parts_Catalog_Link;
		
		string strLang = getLanguage();
		if(strLang == 'ko')
			url = url+psnValue+'&redirectTo=dataplate'+'&language=en'; //Added English default of QSOL team confirmed KO is not working. 
		else
			url = url+psnValue+'&redirectTo=dataplate'+'&language='+getLanguage();
		
        return url;
    }
    
    public static string getSpnFmi(){
        string token = gettoken();
        string url = Label.fsl_qsol_helpful_links ;
        url = url + 'login/lnkmgmt/service.html?esn='+psnValue+'&tab=spnfmi&tokenId='+token+'&language='+getLanguage();
        return url;
    }
    
    //Method for getting the Staging the Link for ECM Caibration Revision History as per document no:95975
    public static string ECM_CalibrationRevisionHistory(){
        string token = gettoken();
        string url = Label.CSS_ECM_CalibrationRevisionHistory_Link; 
        url = url +'&language='+getLanguage();
        //string url = 'https://qs-stg.cummins.com/qs3/portal/ecm/spreadsheet_display.html?header=false';
        return url;   
    }  
    
     //Method for getting the Staging the Link for Wiring Diagram As per story CT2-78: Rajesh M
    public static string getWiringDiagram(){
       // return 'http://parts-stg.cummins.com/integration?serialNumber='+psnValue+'&redirectTo=dataplate'; 
        string url = Label.FSL_Helpful_Resources_Wiring_Diagram_Link;
        url = url+psnValue+'&language='+getLanguage();
        return url;
    }
    
    public static string getLanguage(){
        //CT3-626
        //Modified By: Dinesh Yadav, 10 Sep 21 For QSOL launguage.
        System.debug(' ::::: ' + UserInfo.getLanguage()) ;
        CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
        system.debug('csAccountLang :: '+csAccountLang);
        string strCSS_QsolLanguage ='en';
        if(csAccountLang != null){
            if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
        }
        //req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ 'TSB' +'&'+'language='+strCSS_QsolLanguage+'&businessUnit=EBU');
        return strCSS_QsolLanguage;
        /* ------------End * CT3-626 -----*/
    }
    //Added by Piyush for VGRS2-231
    @AuraEnabled
    public static Boolean isdealerProfile(){
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id=: UserInfo.getProfileId() AND Name like '%dealer%'];
        return profile.size() > 0;
    }
    // VGRS2-231 End
}