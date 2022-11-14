public class CG_CL_AddFailure_GSQPartspopup{

    public Id Ins_JobId{set;get;} 
    public Id JobsolutionId{set;get;} 
    public string srank{set;get;} 
    public string selectedFNameValue{get;set;}
    public string selectedCustFNameValue {get;set;}
    public string selectedFailModeValue {get;set;}
    public string selectedSysCodeValue {get;set;}//System Codes
    public string selectedCompCodeValue {get;set;}//Com Codes
    public string selectedFName{get;set;}//Faiulre Names
    public string selectedSysCode {get;set;}//System Codes
    public string selectedCompCode {get;set;}//Com Codes
    public Set<String> failureNameList{get;set;}//faliureNameList
   // public Set<String> componentCodeList{get;set;}//componentCodeList
    public Set<String> systemCodeList{get;set;}//systemCodeList
    public Map<string,string> custFailureNameList {get;set;}//Custom failure name
    // public Set<String> custFailureNameList {get;set;}//Custom failure name
    public CSS_Job_Order__c serviceJob {get;set;}
    public  Map<String,String> failureNameWithSystemCodeMap{get;set;}
    public  Map<String,String> failureNameWithCompCodeMap{get;set;}
    public transient Map<String,String> custFailureNameSysCodeMap{get;set;}
    public  transient Map<String,String> custFailureNameCompCodeMap{get;set;}
    public  Map<String,String> sysCodeCustFailureNameMap{get;set;}
    //public  Map<String,String> sysCodeCompCodeCustFailureNameMap{get;set;}
    public string selectedFailMode {get;set;}
    public string selectedCustFName {get;set;}
    public Map<String,String> failureNameWithFailureIdMap = new Map<String,String>(); //{get;set;}
    public Boolean noSysCompCode{get;set;}
    public Boolean invalidFailure{get;set;}
    public Boolean invalidCustFailure{get;set;}
    public Boolean invalidSysCode{get;set;}
    public Boolean invalidCompCode{get;set;}
    public Boolean invalidFailMode{get;set;}
    public Boolean invalidFaultCode{get;set;}
    public Map<string, string> systemCodeMap{get;set;}//Added as part of design change
    public Map<string, string> componentCodeMap{get;set;}//Added as part of design change
    public boolean CustFailAllowflag; //Added as part of design change

    public CG_CL_AddFailure_GSQPartspopup(){
        System.debug('JobsolutionId::::' + JobsolutionId);
        failureNameList = new Set<String>();
        //componentCodeList = new Set<String>();
        custFailureNameList=new Map<String,String>();
        //custFailureNameList=new Set<String>();
        systemCodeList = new Set<String>();
        selectedCustFNameValue=null;
        CustFailAllowflag=false;//Added as part of design change
        failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap = new Map<String,String>();
        custFailureNameSysCodeMap = new Map<String,String>();
        custFailureNameCompCodeMap = new Map<String,String>();
        sysCodeCustFailureNameMap = new Map<String,String>();
        componentCodeMap = new Map<String,String>();
        systemCodeMap= new Map<string,string>();
        invalidFailure=false;
        invalidCustFailure=false;
        invalidCompCode=false;
        invalidSysCode=false;
        invalidCustFailure=false;
        invalidFailure=false;
        invalidFailMode = false ;
        // sysCodeCompCodeCustFailureNameMap= new Map<String,String>();
        Ins_JobId = ApexPages.CurrentPage().getParameters().get('Id');  
        serviceJob = [SELECT Id, ESN__c ,Name, Service_Model__c, Qsol_Engine_Family_Code__c, Equipment_ID__c from CSS_Job_Order__c where id =: Ins_JobId];
    }
  
    public void getSRTFailurenamesOnLoad() { 
        System.debug('failureCodeDetails failureNameList:' + failureNameList);
        if(serviceJob.Service_Model__c != null && serviceJob.Qsol_Engine_Family_Code__c !=null) {
            CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
            try{
                CSS_JobEventTemporary__c[] jobEventTemp;// = new CSS_JobEventTemporary__c();
                String smn_engFamCode = serviceJob.Service_Model__c + ';;' + serviceJob.Qsol_Engine_Family_Code__c;
                System.debug('failureCodeDetails failureNameList:' + smn_engFamCode);
                try{
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode AND Key__c = 'getFailureCodesSRT' AND CreatedDate = LAST_N_DAYS:7 LIMIT 1];
                }
                catch(exception Err){
                }
                System.debug('jobEventTemp.size() :' + jobEventTemp.size());
                if((jobEventTemp.size()==0) || (jobEventTemp.size()!=0 &&  jobEventTemp[0].Reason__c==null)){

                    CSS_FN_SRT controller = new CSS_FN_SRT();
                    failureCodeDetails = controller.getFailureCodesSRT(serviceJob.Service_Model__c,serviceJob.Qsol_Engine_Family_Code__c, 'en');

                    System.debug('failureCodeDetails :' + failureCodeDetails);
                    //Insert FaliureCode Details to Job Event Temp Object : Kalpana
                    String output = JSON.serialize(failureCodeDetails);
                    CSS_JobEventTemporary__c jobEventTempRec = new CSS_JobEventTemporary__c();
                    jobEventTempRec.Attribute1__c = serviceJob.Service_Model__c;
                    jobEventTempRec.Attribute2__c = serviceJob.Qsol_Engine_Family_Code__c;
                    jobEventTempRec.Attribute3__c = serviceJob.Service_Model__c + ';;' + serviceJob.Qsol_Engine_Family_Code__c; 
                    jobEventTempRec.Reason__c = output;
                    jobEventTempRec.Key__c = 'GetFailureCodesSRT';
                    //insert jobEventTempRec;
                    //put all the failureName , SystemCode and Component code in a List
                    for(CSS_SRTComponentLookupResponseJ2A.DataArea data: failureCodeDetails.DataArea) {
                        //data.FailureName = data.FailureName.remove('\'');
                        failureNameList.add(data.FailureName);

                        //failureNameWithSystemCodeMap.put(data.FailureName,data.SystemCode);
                        failureNameWithFailureIdMap.put(data.FailureName,data.FailureID);
                        //systemCodeList.add(data.SystemCode);
                        //failureNameWithCompCodeMap.put(data.FailureName,data.ComponentCode);
                        //componentCodeList.add(data.ComponentCode);
                    } 
                }

                else {
                    system.debug('jobEventTemp.Reason__c'+jobEventTemp[0].Reason__c);
                    if(jobEventTemp[0].Reason__c != null){
                        failureCodeDetails = (CSS_SRTComponentLookupResponseJ2A)JSON.deserializeStrict(jobEventTemp[0].Reason__c, CSS_SRTComponentLookupResponseJ2A.class);
                        system.debug('failureCodeDetails-->'+failureCodeDetails);
                    }
                    if(failureCodeDetails.DataArea !=null){
                        for(CSS_SRTComponentLookupResponseJ2A.DataArea det: failureCodeDetails.DataArea){
                            String strFN=det.FailureName;
                            if(!failureNameList.contains(strFN)){
                                failureNameList.add(det.FailureName);
                                failureNameWithFailureIdMap.put(det.FailureName,det.FailureID);
                                String strSC=det.SystemCode;
                                systemCodeList.add(det.SystemCode);
                                failureNameWithSystemCodeMap.put(strFN,strSC);
                                String strCC=det.ComponentCode;
                                //componentCodeList.add(det.ComponentCode);
                                componentCodeMap.put(strCC,strCC);
                                failureNameWithCompCodeMap.put(strFN,strCC);
                            }
                        }
                    }

                }

                failureNameList.add('Unlisted'); 
                system.debug('failureNameList'+failureNameList);

                if(failureNameList!=null && failureNameList.size()>0){
                    if(selectedFName != null && selectedFName != ''){
                        if(failureNameList.contains(selectedFName)){
                            invalidFailure=false;
                        }else{
                            invalidFailure = true;
                        }
                    }else{
                        invalidFailure = false;
                    }
                }

               /* if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
                    system.debug('TESTING 007');
                    String sysDesc;
                    String compDesc;
                    systemCodeList = new Set<string>();
                    for(CSS_JobEventTemporary__c lstjet : [select Attribute1__C,Attribute3__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null ] ){


                        string sysDesc1 = lstjet.Attribute1__C+'-'+lstjet.Attribute3__c;

                        sysDesc1 = sysDesc1.replace('\'','');
                        if(systemCodeList != null)  
                            systemCodeList.add(sysDesc1);

                    }

               
                   if(selectedSysCode!=null && selectedSysCode != '' && ((selectedCustFName =='' || selectedCustFName==null) || (selectedCustFName !='' && selectedCustFName!=null)))
                    {
                        system.debug('selectedSysCode>>>'+selectedSysCode);
                        componentCodeList = new Set<string>();
                        string[] selsyscode=selectedSysCode.split('-');
                        if(selsyscode!=null)
                        {
                            for(CSS_JobEventTemporary__c lstjet : [select Attribute4__c,Attribute5__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute1__C=:selsyscode[0] and Attribute4__c!=null and Attribute5__c!=null] )
                            {
                                string compDesc1 = lstjet.Attribute4__c+'-'+lstjet.Attribute5__c;
                                compDesc1 = compDesc1.replace('\'',''); 
                                componentCodeList.add(compDesc1);

                            }

                        }
                    }
                    //  if(selectedSysCode==null && selectedSysCode == '' ){//Excueting CustomFailure logic ,When selectedsystemcode logic null or empty
                    // custFailureNameList = new Set<string>();
                    custFailureNameList=new Map<String,String>();
                    for(CSS_JobEventTemporary__c lstjet : [select Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null and Attribute7__c!=null] ){


                        string custfailname = lstjet.Attribute7__c;

                        custfailname = custfailname.replace('\'','');
                        if(custFailureNameList != null && custFailureNameList.size()>0)  
                            custFailureNameList.put(custfailname,custfailname);

                    }


                    //    }


                    //end
                    system.debug('***failurenamelist****'+custFailureNameList);
                    system.debug('***componentCodeList****'+componentCodeList.size()+'Component list>>'+componentCodeList);
                    system.debug('selectedCustFName'+selectedCustFName);
                    invalidFailure=false;
                    if(custFailureNameList!=null && custFailureNameList.size()>0){
                        custFailureNameList.put('Unlisted','Unlisted');
                        if(selectedCustFName!=null && selectedCustFName!=''){
                            if(custFailureNameList.containskey(selectedCustFName)){
                                invalidCustFailure = false;
                            }else{
                                invalidCustFailure = true;
                            }
                        }else{
                            invalidCustFailure = false;
                        }
                    }
                    system.debug('invalidCustFailure---'+invalidCustFailure);
                    system.debug('systemCodeList---'+systemCodeList);
                    system.debug('selectedSysCode---'+selectedSysCode);
                    system.debug('selectedCustFName--'+selectedCustFName);

                    if(systemCodeList!=null && systemCodeList.size()>0){
                        if((selectedCustFName==null || selectedCustFName=='') && selectedSysCode!='' && selectedSysCode != null){
                            if(systemCodeList.contains(selectedSysCode)){
                                invalidSysCode = false;
                            }else{
                                invalidSysCode = true;
                            }
                        }else{
                            invalidSysCode = false;
                        }
                    }


                }*/

            } catch(Exception e){
                System.debug('Exception Calling getFailureCodesSRT :' + e.getLineNumber() + ' '+ e.getMessage());
            }
        }
    }

    public void checkCompCode(){
        system.debug('componentCodeMap---'+componentCodeMap);
        system.debug('selectedCompCode---'+selectedCompCode);
        if(componentCodeMap!=null && componentCodeMap.size()>0){
            if((selectedCustFName==null || selectedCustFName=='') && selectedCompCode!='' && selectedCompCode != null){
                if(componentCodeMap.containsKey(selectedCompCode)){
                    invalidCompCode = false;
                }else{
                    invalidCompCode = true;
                }
            }else{
                invalidCompCode = false;
            }

        }
    }

    public void checkFailMode(){
        system.debug('selectedCompCode---'+selectedCompCode);
        invalidFailMode=false;
        //if(componentCodeList!=null && componentCodeList.size()>0){
        for(CSS_JobEventTemporary__c jobTemp:[select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true]){
            string temp1;
            temp1 = jobTemp.Attribute1__c+'-'+jobTemp.Attribute3__c.replace('\'\\','');
            system.debug('temp1******'+temp1);
            system.debug('selectedFailMode>>>>'+selectedFailMode);
            if(selectedFailMode!='' && selectedFailMode != null){

                if(selectedFailMode==temp1){
                    invalidFailMode=false;
                    break;
                }
                else{
                    invalidFailMode = true;
                }
            }else{
                invalidFailMode=false;
            }
        }
        //}
        system.debug('invalidFailMode>>'+invalidFailMode);
    }

    public void changefailmode(){
        selectedFailModeValue=selectedFailMode;
    }

    public void changeSystemcode(){
        try{
            selectedCompCode = '';
            if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
                system.debug('selectedSysCode>>>'+selectedSysCode);
                system.debug('systemCodeList---'+systemCodeList);
                selectedSysCodeValue=selectedSysCode; //Need to analysis the selectedSysCodeValue value is required or not.
                system.debug('selectedSysCodeValue>>>'+selectedSysCodeValue);
                String selSysCodee;
                componentCodeMap = new map<string,string>();
               // componentCodeList= new set<string>();//Added for the defect#190380
                if(selectedSysCode.length()>2)
                    selSysCodee=selectedSysCode.substring(0,2);
                system.debug('selSysCodee>>>'+selSysCodee);
                //Limit 200 added below as part of the defect 191090
                //Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
                list<CSS_JobEventTemporary__c> jetSC = [select Attribute1__C,Attribute3__c, Attribute4__c,Attribute5__c,Active__c,Attribute13__C,Attribute7__c from CSS_JobEventTemporary__c
                                                        where key__c='FailCodes' and Attribute1__c != null and Attribute1__c =: selSysCodee and Active__c=true];

                system.debug('jetSC>>>'+jetSC);
                if(selSysCodee != null)
                {
                    selectedCompCode = '';
                   for(CSS_JobEventTemporary__c jetRec : jetSC)
                    {
                        if(jetRec.Attribute5__c!=null){
                            string compDesc1 = jetRec.Attribute4__c+'-'+jetRec.Attribute5__c;
                            compDesc1 = compDesc1.replace('\'',''); 
                            componentCodeMap.put(compDesc1, compDesc1);
                            //componentCodeList.add(compDesc1);
                        }
                    }
                   

                }
                if(systemCodeList!=null && systemCodeList.size()>0){
                    for(String fN:systemCodeList){
                        //system.debug('fN***'+fN);
                        system.debug('fn--'+fN);
                        if((selectedCustFName==null || selectedCustFName=='') && selectedSysCode!='' && selectedSysCode != null){
                            if(selectedSysCode==fN){
                                system.debug('Inside IF');
                                invalidSysCode=false;
                                break;
                            }
                            else{
                                invalidSysCode = true;
                            }
                        }
                    }
                }
                //jetSC = new list<CSS_JobEventTemporary__c>();

            }

        }
        catch(exception e){
            system.debug('Execption on changeSystemcode menthod'+e.getlinenumber()+ ' '+ e.getMessage());
        }


    }

    public void changeComponentCode(){
        if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
            selectedCompCodeValue=selectedCompCode;
        }
    }

    public void changeFailures(){
        try{
            custFailureNameList = new map<string,string>();
            custFailureNameSysCodeMap = new map<string,string>();
            custFailureNameCompCodeMap = new map<string,string>();
            system.debug('insidechangefailure*****');
            system.debug('selectedFName>>'+ selectedFName);
            selectedFNameValue=selectedFName;
            if(selectedFName==null || selectedFName==''){   /*Added as part of observation in design change*/
                selectedCustFName =   ''; 
                selectedCompCode = ''; 
                selectedSysCode = ''; 
                //selectedFailMode = ''; 
                invalidFailure = false;
                invalidCustFailure = false;
                invalidSysCode = false;
                invalidCompCode = false;
                invalidFailMode = false;
                invalidFaultCode = false;
            }
            if(selectedFName!=null &&  selectedFName.toLowerCase() != 'unlisted'){
                selectedSysCode =  failureNameWithSystemCodeMap.get(selectedFName) ;  
                selectedCompCode =  failureNameWithCompCodeMap.get(selectedFName); 
                selectedCustFName = '';
                system.debug('selectedSysCode>>'+ selectedSysCode);
                system.debug('selectedCompCode>>'+ selectedCompCode);
                if(selectedSysCode!= null && selectedCompCode!= null){
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                                
                    List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
                                                               from CSS_JobEventTemporary__c 
                                                               where key__c='FailCodes' and Active__c=true ];
                    system.debug('jobEvSCCC>>'+jobEvSCCC.size());
                    for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
                        if(selectedSysCode==jSCCC.Attribute1__c && selectedCompCode==jSCCC.Attribute4__c){ // // changed as per jungle book sprint story 167921
                            selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c; 
                            selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
                        }
                        //if(selectedCompCode==jSCCC.Attribute4__c){

                        //}
                    }
                }

            }
            if(failureNameList!=null && failureNameList.size()>0){
                for(String fN:failureNameList){
                    //system.debug('fN***'+fN);
                    if(selectedFName==fN){
                        invalidFailure=false;
                        break;
                    }
                    else{
                        invalidFailure = true;
                    }
                }
            }
            if(selectedFName !=null &&  selectedFName != '' && selectedFName.toLowerCase() == 'unlisted'){
                selectedSysCode =  '';  
                selectedCompCode =  ''; 
                //selectedFailureID = '';
                //unlistedFailure = true;
                systemCodeList = new set<string>();//Added for the defect#190380
                String sysDesc;
                String compDesc;
                //Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
                List<CSS_JobEventTemporary__c> jobEventTemp = [select id,Attribute1__C,Attribute3__c, Attribute5__c,Attribute4__c,Attribute7__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null and Active__c=true];//492
                system.debug('jobEventTemp>>'+jobEventTemp.size());
                if(jobEventTemp != null && jobEventTemp.size()>0){
                    integer i = 0;
                    integer templistsize = jobEventTemp.size();
                    while(i<templistsize)
                    {

                        if(jobEventTemp[i].Attribute7__c != null){
                            sysDesc = jobEventTemp[i].Attribute1__C+'-'+jobEventTemp[i].Attribute3__c;
                            sysDesc = sysDesc.replace('\'','');
                            systemCodeList.add(sysDesc);
                            systemCodeMap.put(sysDesc, sysDesc);
                            if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' ){
                                String temp = jobEventTemp[i].Attribute7__c.replace('\'','');
                                if(temp != null && temp != ''){
                                    custFailureNameList.put(temp,temp);}
                                else{
                                    custFailureNameList.put(jobEventTemp[i].Attribute7__c,jobEventTemp[i].Attribute7__c);   
                                }
                            }

                            if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' && jobEventTemp[i].Attribute1__C != null && jobEventTemp[i].Attribute1__C != '') {
                                custFailureNameSysCodeMap.put(jobEventTemp[i].Attribute7__c, jobEventTemp[i].Attribute1__C+'-'+(jobEventTemp[i].Attribute3__c != null ? jobEventTemp[i].Attribute3__c : ''));
                            }
                            if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' && jobEventTemp[i].Attribute4__c != null &&
                               jobEventTemp[i].Attribute4__c != '')
                                custFailureNameCompCodeMap.put(jobEventTemp[i].Attribute7__c, jobEventTemp[i].Attribute4__c+'-'+(jobEventTemp[i].Attribute5__c != null ? jobEventTemp[i].Attribute5__c : ''));

                        }
                        i++;
                    }

                }
            }
            //Getting List from Siebel
            /*if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
system.debug('TESTING 007');
String sysDesc;
String compDesc;
//List<CSS_JobEventTemporary__c> jobEventTemp = [select Attribute1__C,Attribute3__c,Attribute5__c, Attribute7__c,  Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes'];
//if(jobEventTemp != null && jobEventTemp.size()>0){
componentCodeList = new Set<string>();
systemCodeList = new Set<string>();
custFailureNameList=new Map<String,String>();
//sysCodeCompCodeCustFailureNameMap= new Map<String,String>();
/* start Map<String, CSS_JobEventTemporary__c> mapJET = new Map<String,CSS_JobEventTemporary__c>();

for(CSS_JobEventTemporary__c lstjet : [select Attribute1__C,Attribute3__c, Attribute7__c,Attribute5__c,  Attribute4__c,Active__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null and Attribute7__c!=null limit 1000] ){
string temp = lstjet.Attribute1__c+lstjet.Attribute4__c;
if(!mapJET.containsKey(temp)){
mapJET.put(temp,lstjet);
}
}
system.debug('TESTING 008');end 
List<CSS_JobEventTemporary__c> jobEventTemp = [select Attribute1__C,Attribute3__c, Attribute5__c,Attribute4__c,Attribute7__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' limit 999];
if(jobEventTemp != null && jobEventTemp.size()>0){



for(CSS_JobEventTemporary__c JET: jobEventTemp)
//for(CSS_JobEventTemporary__c JET: jobEventTemp)
//for(CSS_JobEventTemporary__c JET: [select Attribute1__C,Attribute3__c,Attribute5__c, Attribute7__c,  Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes'])
{

sysDesc = JET.Attribute1__C+'-'+JET.Attribute3__c;
compDesc = JET.Attribute4__c+'-'+JET.Attribute5__c;
sysDesc = sysDesc.replace('\'','');
compDesc = compDesc.replace('\'',''); 
system.debug('sysDesc'+sysDesc);
system.debug('compDesc'+compDesc);

//if(systemCodeList != null && systemCodeList.size() <1000)  
systemCodeList.add(sysDesc);
system.debug('sysDesc**'+sysDesc);
system.debug('selectedSysCode**'+selectedSysCode);
system.debug('selectedCustFName**'+selectedCustFName);
if(((selectedSysCode!=null && selectedSysCode != '' && selectedSysCode == sysDesc && (selectedCustFName =='' || selectedCustFName==null)) || (selectedCustFName !='' && selectedCustFName!=null)))  
componentCodeList.add(compDesc);


system.debug('systemCodeList'+systemCodeList);
system.debug('systemCodeList'+componentCodeList);

if(JET.Attribute7__c != null && JET.Attribute7__c != '' ){
System.debug('JET.Attribute7__c JET.Attribute7__c'+JET.Attribute7__c); 
String temp = JET.Attribute7__c.replace('\'','');
system.debug('temp'+temp); 
//custFailureNameList.add(JET.Attribute7__c);
if(temp != null && temp != ''){
custFailureNameList.put(temp,temp);}
else{
custFailureNameList.put(JET.Attribute7__c,JET.Attribute7__c);   
}


}
if(JET.Attribute7__c != null && JET.Attribute7__c != '' && JET.Attribute1__C != null &&
JET.Attribute1__C != '') {
custFailureNameSysCodeMap.put(JET.Attribute7__c, JET.Attribute1__C);
sysCodeCustFailureNameMap.put(JET.Attribute1__C, JET.Attribute7__c);
//system.debug('sysCodeCustFailureNameMap'+sysCodeCustFailureNameMap);


}
if(JET.Attribute7__c != null && JET.Attribute7__c != '' && JET.Attribute4__c != null &&
JET.Attribute4__c != '')
custFailureNameCompCodeMap.put(JET.Attribute7__c, JET.Attribute4__c);


/*if(JET.Attribute7__c != null && JET.Attribute7__c != '' && JET.Attribute4__c != null &&
JET.Attribute4__c != '' &&   JET.Attribute1__C != null &&
JET.Attribute1__C != ''){
String temp1 = JET.Attribute1__C+JET.Attribute4__c;
sysCodeCompCodeCustFailureNameMap.put(temp1, JET.Attribute7__c);
//system.debug('sysCodeCompCodeCustFailureNameMap'+sysCodeCompCodeCustFailureNameMap);
}

}

}
system.debug('***failurenamelist****'+custFailureNameList);
system.debug('***componentCodeList****'+componentCodeList.size()+'Component list>>'+componentCodeList);

}*/
        }
        catch(Exception e){
            System.debug('Exception Calling changeFailures :' + e.getLineNumber() + ' '+ e.getMessage());
        }

    }  

    public void changeCustFailures(){
        try{
            system.debug('selectedCustFName>>'+ selectedCustFName);
            selectedCustFNameValue=selectedCustFName;
            CustFailAllowflag=false; 
            //invalidCompCode=true;
            //invalidSysCode=true;
            //invalidCustFailure=true;
            //invalidFailure=false;
            /* start Testing and commented below code logic for populating system code and componentcode from custom failure name*/
            if(selectedCustFName!=null &&  selectedCustFName!= ''){
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020
                CSS_JobEventTemporary__c jSCCC =[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c,Attribute7__c
                                                 from CSS_JobEventTemporary__c 
                                                 where key__c='FailCodes' and Attribute1__c!=null and Attribute4__c!=null and Attribute7__c!=null and Attribute7__c=:selectedCustFName and Active__c=true limit 1];
                system.debug('jSCCC'+jSCCC);
                if(jSCCC!=null)
                {
                    /* Addded this code for save method*/
                    /*   custFailureNameSysCodeMap.put(jSCCC.Attribute7__c, jSCCC.Attribute1__C);
                    custFailureNameCompCodeMap.put(jSCCC.Attribute7__c, jSCCC.Attribute4__c);*/
                    /*end*/
                    /*Logic for system code*/
                    string sysDesc1 = jSCCC.Attribute1__C+'-'+jSCCC.Attribute3__c;
                    sysDesc1 = sysDesc1.replace('\'','');
                    selectedSysCode=sysDesc1;
                    /*end*/
                    /*Logic for component code*/ 
                    string compDesc1 = jSCCC.Attribute4__c+'-'+jSCCC.Attribute5__c;
                    compDesc1 = compDesc1.replace('\'',''); 
                    selectedCompCode=compDesc1;
                    /*end*/

                    /*Added flag logic for allowing save for unlisted value*/
                    if(selectedCompCode!='' && selectedSysCode!=''){
                        CustFailAllowflag=true; 
                        invalidCompCode=false;
                        invalidSysCode=false;
                        invalidCustFailure=false;
                    }
                    /*End*/
                    system.debug('selectedSysCode>>'+selectedSysCode);
                    system.debug('selectedCompCode>>'+selectedCompCode);


                }

                system.debug('selectedCustFName*****'+selectedCustFName);
                system.debug('custFailureNameList*****'+custFailureNameList);
                invalidFailure=false;
                if(custFailureNameList!=null && custFailureNameList.size()>0){
                    custFailureNameList.put('Unlisted','Unlisted');
                    if(selectedCustFName!=null && selectedCustFName!=''){
                        if(custFailureNameList.containskey(selectedCustFName)){
                            system.debug('insideif*****');
                            invalidCustFailure = false;
                        }else{
                            invalidCustFailure = true;
                            selectedSysCode = '';
                            selectedCompCode = '';
                        }
                    }else{
                        invalidCustFailure = false;
                    }
                }
            }
            else{
                invalidCustFailure=false;
            }
            /* end Testing and commented below code logic for populating system code and componentcode from custom failure name*/
            /*Commented below code for testing customfailure code population*/
            /*   if(selectedCustFName!=null &&  selectedCustFName!= ''){
selectedSysCode =  custFailureNameSysCodeMap.get(selectedCustFName) ;  
selectedCompCode =  custFailureNameCompCodeMap.get(selectedCustFName); 
system.debug('selectedSysCode>>'+ selectedSysCode);
system.debug('selectedCompCode>>'+ selectedCompCode);
if(selectedSysCode!= null && selectedCompCode!= null){
List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
from CSS_JobEventTemporary__c 
where key__c='FailCodes'];
for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
if(selectedSysCode==jSCCC.Attribute1__c && selectedCompCode==jSCCC.Attribute4__c){
selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c;
selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
}
// if(selectedCompCode==jSCCC.Attribute4__c){

// }
}
}

}*/
            /*Commented above code for testing customfailure code population*/
        }
        catch(Exception e){
            invalidCustFailure = true;
            System.debug('Exception Calling changeFailures :' + e.getLineNumber() + ' '+ e.getMessage());
        }
    }

    public Set<String> getfailurenames(){
        system.debug('getfailurenames'+failureNameList);
        return failureNameList;

    }
    
    //Commented below as part of the defect 191090
    /*public Set<String> getComponentCodes(){
        return componentCodeList;

    }*/
    
    //Added below as part of the defect 191090
    public Map<String, String> getComponentCodes(){
        return componentCodeMap;

    }
    
    //Commented below as part of the defect 191090
    /*public Set<String> getSystemCodes(){
        return systemCodeList;

    }*/
    
    //Added below as part of the defect 191090
    public Map<String, string> getSystemCodes(){
        return systemCodeMap;
    }

    public List<String> getFailModes() 
    { 
        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes' limit 1000];
        List<String> tempStr = new List<String>();
        for(CSS_JobEventTemporary__c lst : tempList){
            string temp1;
            temp1 = lst.Attribute3__c.replace('\'\\','');
            if(temp1 != null && temp1 != ''){
                tempStr.add(lst.Attribute1__c +'-'+temp1);
            }
        }
        return tempStr;
    }
    /*public set<String> getGsqcustFailurenameslist() { 

//List<String> tempStr = new List<String>();
//tempStr.add('Siebel failure');
return custFailureNameList;
}*/
    /*public Map<string,string> getGsqcustFailurenameslist() { 

        //List<String> tempStr = new List<String>();
        //tempStr.add('Siebel failure');
        return custFailureNameList;
    }*/
    public void cancelPopup(){
        selectedFName =   '';
        selectedCustFName =   '';
        selectedCompCode = ''; 
        selectedSysCode = ''; 
        selectedFailMode = ''; 
        invalidFailure = false;
        invalidCustFailure = false;
        invalidSysCode = false;
        invalidCompCode = false;
        invalidFailMode = false;
        invalidFaultCode = false;
        //componentCodeList = null;
        systemCodeList = null;
        componentCodeMap = null;
        

    }

    public pagereference popUpSave() {
        system.debug('Coming to popUpSave Method');
        PageReference ReturnPage;
        try{
            noSysCompCode=false;
            String selectedSysCodeDesc=selectedSysCode;
            String selectedCompCodeDesc=selectedCompCode;
            String selectedFailModeDesc=selectedFailMode;
            //String selectedFaultCodeDesc=selectedFaultCode;
            system.debug('***selectedFailModeValue***'+selectedFailModeValue);
            system.debug('****selectedFailMode***'+selectedFailMode);
            if(selectedFailModeValue!=null){
                selectedFailModeDesc=selectedFailModeValue;
                selectedFailMode=selectedFailModeValue;
            }

            if(selectedSysCodeValue!=null){
                selectedSysCodeDesc= selectedSysCodeValue;
                selectedSysCode=selectedSysCodeValue;
            }

            if(selectedCompCodeValue!=null){
                selectedCompCodeDesc= selectedCompCodeValue;
                selectedCompCode=selectedCompCodeValue;
            }
            if(selectedSysCode != null && selectedSysCode.length()>2)
                selectedSysCode = selectedSysCode.substring(0,2);
            if(selectedCompCode != null && selectedCompCode.length()>2)
                selectedCompCode = selectedCompCode.substring(0,2);
            if(selectedFailMode != null && selectedFailMode.length()>2)
                selectedFailMode=selectedFailMode.substring(0,2);

            CSS_Solution_Component__c solnComp = new CSS_Solution_Component__c();
            if(selectedFailMode != null)
                solnComp.Failure_Mode__c = selectedFailMode;
            if(selectedFailModeDesc != null)
                solnComp.FailMode_Desc__c = selectedFailModeDesc;
            if(selectedCompCodeDesc != null)
                solnComp.ComponentCode_Desc__c = selectedCompCodeDesc;
            if(selectedSysCodeDesc != null)
                solnComp.SystemCode_Desc__c = selectedSysCodeDesc;

            if(selectedSysCode != null)
                solnComp.System_Code__c = selectedSysCode;
            if(selectedCompCode != null)
                solnComp.Component_Code__c = selectedCompCode;

            solnComp.Service_Job__c = Ins_JobId;
            solnComp.Solutions__c=JobsolutionId;
            //Predifined failure name - selectedFName
            system.debug('Coming to popUpSave Method no:2 ' + solnComp);
            system.debug('selectedFName****' + selectedFName);
            system.debug('selectedCustFName****' + selectedCustFName);
            system.debug('selectedCustFNameValue****' + selectedCustFNameValue);
            if(selectedFName != null && selectedFName != '' && invalidFailure ==false && invalidCustFailure ==false && invalidSysCode ==false && invalidCompCode == false && invalidFailMode == false) {
                if(selectedFName.toLowerCase() != 'unlisted') {
                    system.debug('Coming to popUpSave Method USE CASE : 1');
                    //if we pass the failure name from predefined failure name then we can call the webservice first and
                    //fetch the GSQ parts, then inserting failures and then parts due to solve the error as Uncommitted pending.
                    //solnComp.Name = selectedFName;
                    solnComp.Name = selectedFNameValue;
                    system.debug('Coming to popUpSave Method USE CASE : 1.1' + failureNameWithFailureIdMap);
                    solnComp.Component_Id__c = failureNameWithFailureIdMap.get(selectedFName);
                    system.debug('Coming to popUpSave Method USE CASE : 1.2 WEB');
                    //Calling Webservice.
                    system.debug('solnComp.Component_Id__c----------->'+solnComp.Component_Id__c);
                    system.debug('selectedFName------------->'+selectedFName);
                    list<CSS_Parts_Options__c> GSQParts = CSS_FN_SRT.fetchGSQServiceParts(solnComp, serviceJob);
                    system.debug('Coming to popUpSave Method USE CASE : 1.3 AFTER WEB');
                    System.debug('GSQParts******'+GSQParts);
                    //Calling webservice.
                    insert solnComp;

                    for(CSS_Parts_Options__c GSQ : GSQParts){
                        GSQ.FailurepartId__c = solnComp.Id;
                        GSQ.Solutions__c=JobsolutionId;
                    }

                    if(GSQParts != null && GSQParts.size() >0)
                        insert GSQParts;
                } 
                //if we pass the failure name from Cust failure name 
                else if(selectedFName.toLowerCase() == 'unlisted') 
                {
                    system.debug('Insideunlist'+selectedCustFName+'$$'+selectedCustFNameValue);
                    //    if(selectedCustFName != null && selectedCustFName != '' && (selectedCustFNameValue == null || selectedCustFNameValue == '')){
                    if(selectedCustFName != null && selectedCustFName != '' && !CustFailAllowflag){  
                        return null;
                    }
                    else{
                        if(selectedCustFName != null && selectedCustFName != '') {
                            system.debug('Coming to popUpSave Method USE CASE : 2');
                            //system.debug('Coming to popUpSave Method USE CASE : 2'+selectedCustFNameValue);
                            //solnComp.Name = selectedCustFName;
                            if(selectedCustFNameValue!=null && selectedCustFNameValue!=''){
                                solnComp.Name = selectedCustFNameValue;
                                solnComp.CSS_Custom_Failure__c = selectedCustFName;//
                                //   solnComp.System_Code__c = custFailureNameSysCodeMap.get(selectedCustFName);
                                //  solnComp.Component_Code__c = custFailureNameCompCodeMap.get(selectedCustFName);
                            }
                            else
                            {
                                if(selectedSysCode != null && selectedSysCode != '' && selectedCompCode!=null && selectedCompCode!='') {
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                                                
                                    List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:selectedSysCode and Attribute4__c=:selectedCompCode and Active__c=true];
                                    if(tempList!=null && tempList.size()>0 )
                                        solnComp.Name=tempList[0].Attribute7__c;
                                    solnComp.System_Code__c = selectedSysCode;
                                    solnComp.Component_Code__c = selectedCompCode;
                                    system.debug('Coming to popUpSave Method USE CASE : 3'+solnComp.Name);
                                    //system.debug('Coming to popUpSave Method USE CASE : 3'+sysCodeCompCodeCustFailureNameMap.get(selectedSysCode+selectedCompCode));

                                }   
                            }
                            system.debug('Coming to popUpSave Method USE CASE : 4'+selectedSysCode);
                            system.debug('Coming to popUpSave Method USE CASE : 5'+selectedCompCode);

                            //Code for passing failureId incase of UNLISTED -- Start
                            String solCompName = solnComp.Name;
                            String updatedSolCompName = '';
                            if(solCompName != null && solCompName.length() > 0){
                                String[] splitPhrase = solCompName.trim().split(' ');

                                for(integer i = 0; i < splitPhrase.size(); i++){
                                    if(i == 0 || i == (splitPhrase.size()-1) ){
                                        updatedSolCompName += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                                    }else{
                                        updatedSolCompName += splitPhrase[i].toLowerCase()+' ';
                                    }
                                }
                            }
                            system.debug('updatedSolCompName****'+updatedSolCompName);
                            system.debug('failureNameWithFailureIdMap****'+failureNameWithFailureIdMap);
                            if(failureNameWithFailureIdMap!=null)
                                system.debug('****solComp.Name1***'+updatedSolCompName);
                            if(updatedSolCompName != null)
                                updatedSolCompName = updatedSolCompName.trim();
                            solnComp.Component_Id__c = failureNameWithFailureIdMap.get(updatedSolCompName);
                            system.debug('Inside popUpSave method...selectedFailureID2>>:'+solnComp.Component_Id__c);

                            //Code for passing failureId incase of UNLISTED -- End

                            insert solnComp;

                        } 
                        else{
                            system.debug('Coming to popUpSave Method USE CASE : 3');
                            system.debug('selectedCompCode****'+selectedSysCode);
                            system.debug('selectedCompCode***'+selectedCompCode);
                            system.debug('selectedSysCodeValue***'+selectedSysCodeValue);
                            system.debug('selectedCompCodeValue***'+selectedCompCodeValue);
                            // if(selectedSysCodeValue != null && selectedSysCodeValue != ''&& selectedCompCodeValue!=null && selectedCompCodeValue!='') {
                            if(selectedSysCode != null && selectedSysCode != ''&& selectedCompCode!=null && selectedCompCode!='') {
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                                            
                                List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:selectedSysCode and Attribute4__c=:selectedCompCode and Active__c=true];
                                if(tempList!=null && tempList.size()>0 && tempList[0].Attribute7__c !=null && tempList[0].Attribute7__c !=''){
                                    solnComp.Name=tempList[0].Attribute7__c;
                                }else
                                {
                                    system.debug('Insideelse'+selectedSysCode+selectedCompCode);
                                    //solnComp.Name='Unlisted';
                                    solnComp.Name=selectedSysCode+selectedCompCode;
                                    //solnComp.Name=sysCodeCustFailureNameMap.get(selectedSysCode); 
                                    system.debug('solnComp.Name-----'+solnComp.Name);
                                }

                                //Code for passing failureId incase of UNLISTED -- Start
                                String solCompName = solnComp.Name;
                                String updatedSolCompName = '';
                                if(solCompName != null && solCompName.length() > 0){
                                    String[] splitPhrase = solCompName.trim().split(' ');

                                    for(integer i = 0; i < splitPhrase.size(); i++){
                                        if(i == 0 || i == (splitPhrase.size()-1) ){
                                            updatedSolCompName += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                                        }else{
                                            updatedSolCompName += splitPhrase[i].toLowerCase()+' ';
                                        }
                                    }
                                }
                                system.debug('updatedSolCompName****'+updatedSolCompName);
                                system.debug('failureNameWithFailureIdMap****'+failureNameWithFailureIdMap);
                                if(failureNameWithFailureIdMap!=null)
                                    system.debug('****solComp.Name1***'+updatedSolCompName);
                                if(updatedSolCompName != null)
                                    updatedSolCompName = updatedSolCompName.trim();
                                solnComp.Component_Id__c = failureNameWithFailureIdMap.get(updatedSolCompName);
                                system.debug('Inside popUpSave method...selectedFailureID2>>:'+solnComp.Component_Id__c);

                                //Code for passing failureId incase of UNLISTED -- End

                                insert solnComp;
                            }
                            if(selectedSysCodeValue == null || selectedSysCodeValue == '' || selectedCompCodeValue ==null || selectedCompCodeValue=='' || selectedFailModeValue ==null || selectedFailModeValue ==''){
                                noSysCompCode=true;
                            }
                            else{
                                noSysCompCode=false;
                            }
                        }


                    }
                }
            }
        } catch(exception e) {
            system.debug('Entered into catch block of Update Fail Components method in CG_CL_AddFailure_GSQParts' + e.getmessage() + ' ' + e.getLineNumber());
        }
        system.debug('invalidFailure'+invalidFailure);
        system.debug('invalidCustFailure'+invalidCustFailure);
        system.debug('invalidSysCode'+invalidSysCode);
        system.debug('invalidCompCode'+invalidCompCode);
        system.debug('invalidFailMode'+invalidFailMode);

        if(invalidFailure ==false && invalidCustFailure ==false && invalidSysCode ==false && invalidCompCode == false && invalidFailMode == false ){
            system.debug('Enters into Popup save method>>');
            ReturnPage = ApexPages.currentPage(); 
            Id id = ReturnPage.getParameters().get('Id');
            Id symid= ReturnPage.getParameters().get('symid');
            Id fcid= ReturnPage.getParameters().get('fcid');
            String rank= srank;
            ReturnPage.getParameters().clear();
            ReturnPage.getParameters().put('Id', id);
            ReturnPage.getParameters().put('fcid', fcid);
            ReturnPage.getParameters().put('rank', rank);
            ReturnPage.getParameters().put('symid', symid);
            ReturnPage.setRedirect(true);
            /*if(noSysCompCode==true){
return null;
}else{
return ReturnPage ;
}*/
            system.debug('Ends into Popup save method>>');
        }
        else{
            system.debug('Enters into else>>');
            ReturnPage=null;
        }
        return ReturnPage ;

    }
}