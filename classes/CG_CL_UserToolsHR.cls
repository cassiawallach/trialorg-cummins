/*
* Block comments with details of changes
*/
public class CG_CL_UserToolsHR
{
    public String myBase64String {get;set;} 
    public string enteredPSN {get; set;}
    public boolean invalidPSN{get; set;}
    public CG_CL_UserToolsHR()
    {
        invalidPSN = true;  
    }
    
    public void startRequest(){
        //Calling SiebelWS to get data 63173-Start
        CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
        CSS_getEngineDataResponseJ2A  engineData;
        CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
        jidi.ESN=enteredPSN;//mainContr.psnRec.PSN__c;
        wrapobj.DataArea = jidi;
        
        engineData = CSS_WS_SBL.getEngineData(wrapobj);
        system.debug('engineData>>>>'+engineData);
        if(enteredPSN != null && enteredPSN != '')
        invalidPSN = false;
        else
        invalidPSN = true;
        if (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){
            if(engineData.DataArea.ServiceModelName == null || engineData.DataArea.ServiceModelName == ''){
                if(enteredPSN.isNumeric() || enteredPSN.length() == 8)
                {
                    invalidPSN=true;
                }
            }
        }else{
            if(enteredPSN.isNumeric() || enteredPSN.length() == 8)
            {
                invalidPSN=true;
            }
        }
        system.debug('invalidPSN>>>'+invalidPSN);
        
    }
    
    // Method for helpful resources - start
    public string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
    /*public string getParts(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        system.debug('enteredPSN>>' + enteredPSN);
        url = url + 'login/lnkmgmt/parts.html?esn='+enteredPSN+'&tokenId='+token; 
        return url;
    }*/
    public string getParts(){		
        string token = gettoken();		
        string url = Label.css_qsol_helpful_links_Parts_DataPlate;		
        system.debug('enteredPSN>>' + enteredPSN);		
        //url = url + '#/integration?serialNumber='+enteredPSN+'&redirectTo=PartsCatalog'; 		
        url = url + 'integration?searchCriteria='+enteredPSN+'&redirectTo=systems'; 		
        return url;		
    }
    /*public string getService(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+enteredPSN+'&tokenId='+token; 
        return url;
    }*/
    public string getService(){		
        string token = gettoken();		
        string url = Label.css_qsol_helpful_links;		
        url = url + 'login/lnkmgmt/service.html?esn='+enteredPSN; 		
        return url;
    }
    /*public string getDataPlate(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+enteredPSN+'&tab=dataplate&tokenId='+token; 
        return url;
    }*/
    public string getDataPlate(){		
        string token = gettoken();		
        string url = Label.css_qsol_helpful_links_Parts_DataPlate;		
        url = url + 'integration?searchCriteria='+enteredPSN+'&redirectTo=dataplate'; 		
        return url;		
    }
   /* public string getSpnFmi(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+enteredPSN+'&tab=spnfmi&tokenId='+token;
        return url;
    }*/
       public string getSpnFmi(){		
        string token = gettoken();		
        string url = Label.css_qsol_helpful_links;		
        url = url + 'login/lnkmgmt/service.html?esn='+enteredPSN;		
        return url;
    }
    
    //Method for getting the Staging the Link for ECM Caibration Revision History as per document no:95975
    public string ECM_CalibrationRevisionHistory(){
        string token = gettoken();
        string url = Label.CSS_ECM_CalibrationRevisionHistory_Link; 
        return url;   
    }   
}