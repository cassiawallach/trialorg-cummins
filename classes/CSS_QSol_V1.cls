public class CSS_QSol_V1 {

    List<CSS_CampTsbTrp__c> qsolCTT;
    public String myBase64String {get;set;}
    Transient List<CSS_CampTsbTrp__c> qsolCTT1;
    List<CSS_CampTsbTrp__c> qsol = new list<CSS_CampTsbTrp__c>();
    List<CSS_CampTsbTrp__c> qsolTrp = new list<CSS_CampTsbTrp__c>();
    Transient List<CSS_CampTsbTrp__c> qsolTsb = new list<CSS_CampTsbTrp__c>();
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public string jobSModel{get;set;}
    public Date JobFailDate{get;set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    public List<List<CSS_CampTsbTrp__c>> campaignsList;

    public ID JobID {get;set;} 
    public id Wid {get;set;}

    public string JobESN;
    public string getJobESN(){ return JobESN;}
    public void setJobESN(string e){
        JobESN=e;
        //JobESN=mainContrRJ.workJob.ESN__c;
        System.debug('The esn is!!!!'+JobESN);
        if(JobESN != null && JobESN != ''){
            try {
                qsolCTT1 = [select Doc_Num__c,URL__c,Type__c,Doc_Title__c ,Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__r.esn__c=:JobESN and Job_Order__c = :Wid LIMIT 1000];
                qsol = new list<CSS_CampTsbTrp__c>();
                qsolTrp = new list<CSS_CampTsbTrp__c>();
                qsolTsb = new list<CSS_CampTsbTrp__c>();
                sort1(qsolCTT1);
                //getCampTRPATCs(); //Anvesh Commented as part of defect fix 191060 


            }
            catch(Exception exp){} 
        }
    }  

    public CSS_QSol_V1(){
        Wid=ApexPages.CurrentPage().getParameters().get('id');


    }
    public List<CSS_CampTsbTrp__c> lstCAM;
    public List<CSS_CampTsbTrp__c> lstTRP;
    public List<CSS_CampTsbTrp__c> lstTSB;
    public List<CSS_CampTsbTrp__c> lstATC;
    public void getCampTRPATCs(){

        try{
            User userObj;
            if(userObj == null){
                userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            }
            accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey);
            system.debug('accountlang**'+accountlang);
            system.debug('accountlang*'+accountlang.CSS_QsolLanguage__c);
            List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstTSB = new List<CSS_CampTsbTrp__c>();
            List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(Wid, JobESN, accountlang.CSS_QsolLanguage__c, jobSModel, JobFailDate);
            system.debug('campaignsList--->'+campaignsList);
            system.debug('campaignsList--->'+campaignsList.size());
            if(campaignsList !=null && !(campaignsList.isempty()) && campaignsList.size()>0)
                lstTSB = campaignsList.get(0);
            if(campaignsList !=null && !(campaignsList.isempty()) && campaignsList.size()>1)
                lstCAM = campaignsList.get(1);
            if(campaignsList !=null && !(campaignsList.isempty()) && campaignsList.size()>2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && !(campaignsList.isempty()) && campaignsList.size()>3)
                lstATC = campaignsList.get(3);
            system.debug('campaignsList>>>:'+campaignsList);
        }
        catch(Exception ex){
            system.debug('Entered getCampTRPATCs method' + ex.getLineNumber() +' '+ ex.getMessage());
        }
    }


    //method for Sorting
    //
    public void sort1(list<CSS_CampTsbTrp__c> campTsbList){
        System.debug('Hello 123');
        if(campTsbList != null && !campTsbList.isEmpty()){
            for(integer i=0;i<campTsbList.size();i++){
                CSS_CampTsbTrp__c campTsTr = campTsbList[i];

                if(campTsTr.Type__c.equalsIgnoreCase('CAM')){
                    System.debug('The campaign is'+campTsTr.Type__c);
                    if(campTsTr.Performed__c || campTsTr.Performed_Review__c || campTsTr.Reviewed__c){
                        System.debug('The campaign inside varun is'+campTsTr.Type__c);
                        qsol.add(campTsTr);
                        campTsbList.remove(i);
                        system.debug('@@@@@@@ CAM'+qsol);
                    }
                }
                if(campTsTr.Type__c.equalsIgnoreCase('TRP')){
                    if(campTsTr.Performed__c || campTsTr.Performed_Review__c|| campTsTr.Reviewed__c){
                        qsolTrp.add(campTsTr);
                        campTsbList.remove(i);
                        system.debug('@@@@@@@ TRP'+qsolTrp);
                    }
                }
                if(campTsTr.Type__c.equalsIgnoreCase('TSB')){
                    if(campTsTr.Performed__c || campTsTr.Performed_Review__c|| campTsTr.Reviewed__c){
                        qsolTsb.add(campTsTr);
                        campTsbList.remove(i);
                        //system.debug('@@@@@@@ TSB'+qsolTsb);
                    }
                }
            }//end of for.
        }//end of campList null and empty check.

        if(campTsbList != null && !campTsbList.isEmpty()){
            for(integer i=0;i<campTsbList.size();i++){
                CSS_CampTsbTrp__c campTsTr = campTsbList[i];
                if(campTsTr.Type__c.equalsIgnoreCase('CAM')){
                    System.debug('The campaign inside is'+campTsTr.Type__c+' ABCD '+campTsTR.Doc_Num__c);
                    if(campTsTr.Performed__c != true || campTsTr.Performed_Review__c != true || campTsTr.Reviewed__c != true){
                        System.debug('The campaign inside is#@!#!@'+campTsTr.Type__c);
                        qsol.add(campTsTr);
                        //   campTsbList.remove(i);
                        system.debug('@@@@@@@ CAM INSIDE'+qsol);

                    }
                }
                if(campTsTr.Type__c.equalsIgnoreCase('TRP')){
                    if(campTsTr.Performed__c != true || campTsTr.Performed_Review__c != true || campTsTr.Reviewed__c != true){ 
                        qsolTrp.add(campTsTr);

                        system.debug('@@@@@@@ TRP INSIDE'+qsolTrp);
                    }   
                }
                if(campTsTr.Type__c.equalsIgnoreCase('TSB')){
                    if(campTsTr.Performed__c != true || campTsTr.Performed_Review__c != true || campTsTr.Reviewed__c != true){

                        qsolTsb.add(campTsTr);
                        //system.debug('@@@@@@@ TSB'+qsolTsb);
                    }  
                }
            }//end of for.
        }//end of campList null and empty check.

    }//end of Sort Method.

    public List<CSS_CampTsbTrp__c> getCampRecords(){
        List<CSS_CampTsbTrp__c> qsol1 = new  List<CSS_CampTsbTrp__c>();
        try{
            //  if(!qsol.isEmpty()){
            //qsol1.add(qsol.get(0));
            //.add(qsol.get(1));
            //  }
            //qsol1.add(campaignsList.get(0));
            system.debug('FinalDocs**'+campaignsList);
            if(campaignsList !=null && campaignsList.size()>0){
                system.debug('lstCAM**'+campaignsList.get(0));
                return campaignsList.get(0);
            }else 
                return new  List<CSS_CampTsbTrp__c>();

        }catch(exception e){}
        //return qsol1;
        return campaignsList.get(0);
    }
    public List<CSS_CampTsbTrp__c> getCampaignsRecords(){
        List<CSS_CampTsbTrp__c> qsol2 = new  List<CSS_CampTsbTrp__c>();
        try{  
            //  if(!qsol.isEmpty()){
            qsol2.addAll(qsol);
            qsol2.remove(0);
            qsol2.remove(0);
        }
        // }
        catch(exception e){}
        return qsol2;
    }
    public integer getCampaignsCount(){

        return qsol.size();
    }

    public List<CSS_CampTsbTrp__c> getTrpsRecords(){
        List<CSS_CampTsbTrp__c> qsol3 = new  List<CSS_CampTsbTrp__c>();

        if(!qsolTrp.isEmpty()){
            qsol3.add(qsolTrp[0]);
            qsol3.add(qsolTrp[1]);
        }

        return qsol3;
    }
    public List<CSS_CampTsbTrp__c> getTrpRecords(){
        List<CSS_CampTsbTrp__c> qsol4 = new  List<CSS_CampTsbTrp__c>();

        if(!qsolTrp.isEmpty()){
            qsol4.addAll(qsolTrp);
            qsol4.remove(0);
            qsol4.remove(0);
        }
        return qsol4;
    }
    public integer getTrpsCount(){

        return qsolTrp.size();
    }
    public List<CSS_CampTsbTrp__c> getTsbsRecords(){
        List<CSS_CampTsbTrp__c> qsol5 = new  List<CSS_CampTsbTrp__c>();
        try{
            qsol5.add(qsolTsb[0]);
            qsol5.add(qsolTsb[1]);

        }
        catch(exception e){

        }
        return qsol5;
    }
    integer x ;
    public integer getTsbsCount(){
        if(qsolTsb != null){

            x = qsolTsb.size();
        }
        return x;
    }
    Public List<CSS_CampTsbTrp__c> getTsbRecords(){
        List<CSS_CampTsbTrp__c> qsol6 = new  List<CSS_CampTsbTrp__c>();
        try{

            qsol6.addAll(qsolTsb);
            qsol6.remove(0);
            qsol6.remove(0);


        }
        catch(exception e){

        }
        return qsol6;
    }


    public List<CSS_CampTsbTrp__c> getALLRecords(){
        List<CSS_CampTsbTrp__c> CTT = new  List<CSS_CampTsbTrp__c>();

        qsolCTT = [select Type__c, Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__r.esn__c=:JobESN and Job_Order__c= :JobID order by Type__c LIMIT 1000];

        return qsolCTT;
    }

    public void savectt(){
        system.debug(''); 
    } 

    public string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
}