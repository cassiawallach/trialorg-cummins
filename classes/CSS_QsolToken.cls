public class CSS_QsolToken {
    public String myBase64String {get;set;} 
    public String sESN;
    public boolean SouthPacificUser{get;set;}
    public Boolean isDealer{get; set;}
    public void setsESN(String argId){
        sESN = argId; 
        //System.debug('The value of svfComp is'+sVfComp);
    } 
    // Written code to implement 93994
    public CSS_QsolToken(){
        try{
             //Checking Delaer or Distributor
        isDealer = true;
        String userType = css_utility.getOrgType(UserInfo.getUserId());
        if(userType !=null && userType !=''){
            if(userType == 'DISTR'){
                isDealer = true;
            }else{
                isDealer = false;
            }
        }
             SouthPacificUser= false;
            Id userId = UserInfo.getUserId();
            User usr = css_utility.getUserAttributes(userId);
            String strLoc = usr.User_Location__c;
            Account regTerritory = css_utility.getRegionTerritory(strLoc);
            system.debug('**regTerritory**'+regTerritory); 
            //if (((regTerritory.Region__c=='AUSTRALIA') || (regTerritory.Region__c=='NEW ZEALAND')) && regTerritory.Type=='Distributor Account')
            if ((regTerritory.Region__c.toUpperCase()=='AUSTRALIA/ NEW ZEALAND') && (regTerritory.Type=='Distributor Account'))
            {
                SouthPacificUser = true; 
            }         
            else
            { SouthPacificUser = false; 
            }
            system.debug('**SouthPacificUser**'+SouthPacificUser); 
        }
        catch(Exception e)
        { system.debug('SouthPacificUser'+e.getMessage());}
    }
    public String getsESN(){
        return sESN; 
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
        url = url + 'login/lnkmgmt/parts.html?esn='+sESN+'&tokenId='+token; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }*/
    public string getParts(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links_Parts_DataPlate;
        url = url + 'integration?searchCriteria='+sESN+'&redirectTo=systems'; 
        //url = url + '#/integration?serialNumber='+sESN+'&redirectTo=PartsCatalog'; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }
        /*public string getService(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+sESN+'&tokenId='+token; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }*/
    public string getService(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+sESN; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }
    /*public string getDataPlate(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        url = url + 'login/lnkmgmt/service.html?esn='+sESN+'&tab=dataplate&tokenId='+token; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }*/
    public string getDataPlate(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links_Parts_DataPlate;
        url = url + 'integration?searchCriteria='+sESN+'&redirectTo=dataplate'; 
        //login/lnkmgmt/parts.html?esn={!jobESN}&tokenId={!token}
        return url;
    }
    /*public string getSpnFmi(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        //url = url + 'qs3/portal/search/redirect/service.html?esn='+sESN+'&tab=spnfmi&tokenId='+token; 
        url = url + 'login/lnkmgmt/service.html?esn='+sESN+'&tab=spnfmi&tokenId='+token;
        return url;
    }*/
     public string getSpnFmi(){
        string token = gettoken();
        string url = Label.css_qsol_helpful_links;
        //url = url + 'qs3/portal/search/redirect/service.html?esn='+sESN+'&tab=spnfmi&tokenId='+token; 
        url = url + 'login/lnkmgmt/service.html?esn='+sESN+'&tab=spnfmi';
        return url;
    }
    
//Method for getting the Staging the Link for Customer Complaint Prompt Sheets
     public string getCustomerComplntPromptSheet(){
        string token = gettoken();
        string url = Label.CSS_Customer_Complaint_Prompt_Sheets_links; //it's stroting the Staging Link
        return url;
    }
//Method for getting the Staging Link for South Pacific Forms Story document no:93994
     public string getSouthPacificForms(){
      //  string token = gettoken();
        string url = Label.CSS_South_Pacific_Forms_Link; 
        return url;   
    } 
    //Method for getting the Staging the Link for ECM Caibration Revision History as per document no:95975
        public string ECM_CalibrationRevisionHistory(){
        string token = gettoken();
        string url = Label.CSS_ECM_CalibrationRevisionHistory_Link; 
        return url;   
    }   
    
        //Method for getting the Staging the Link for Policy Resource System as per document no:100936
        public string Policy_Resource_System(){
        string token = gettoken();
        string url = Label.CSS_Support_Plans_in_Policy_Resource_System_PRS; 
        return url;   
    }    
    //Method for customer intake wizard spread sheet #107322
     public string wizardSpreadSheet(){
                 string token = gettoken();
                 string    url = Label.CSS_Customer_Intake_Wizard_spreadsheet_link;        
                    return url;   
    }
 }