/**********************************************************************
Name:CG_CL_IntakeCustNoERP
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Business layer for Intake Pages
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/19/2017      INITIAL DEVELOPMENT 
1.0 - Surender M          12/19/2017      INITIAL DEVELOPMENT
***********************************************************************/
public class CG_BL_Intake {
    //Global Veriables


    //Global Veriables

    public CG_BL_Intake() {

    }

    //Fetch Account Id and Pass the vlaue.
    public static string FetchAccountId(string intakeLocation) {
        string aID = '';
        List<Account> accList = new List<Account>([Select Id, Name, Location__c from Account where Location__c=:intakeLocation]);
        //if(accList != null || accList.size()>0)
        if(accList != null && accList.size()>0) 
            aID = accList.get(0).Id;
        system.debug('aID**'+aID);
        return aID;
    }
    //Fetching User locations.
    public static void fetchUserLocation(Id wId, string creatorLocation) {
        List<Account> acList;
        String userLocation;
        try {
            //if(Cache.Session.get('UserERPSystem') == null){
            //if(Wid== null) {
            //User UserObject = [select User_Location__c from user where id=:UserInfo.getUserId() LIMIT 1];
            //userLocation = UserObject.User_Location__c;
            //userLocation = ((User) [select User_Location__c from user where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
            //} else {
            userLocation  = creatorLocation;
            //}
            system.debug('userLocation ' + userLocation);
            css_utility.setSessionVariables(userLocation);
            //}
            System.debug('ERP>>>:'+Cache.Session.get('UserERPSystem'));
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake fetchUserLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }

    //Fetch Multilocation values.
    public static list<CSS_UserLocation__c> fetchMultiLocation() {
        system.debug('Inside fetchMultiLocation Method');
        list<CSS_UserLocation__c> userLocationList;
        try {
            //query to get the user locations 
            userLocationList = [SELECT AccountId__c,isActive__c,isPrimary__c,Location_Name__c,BMSApplicationURL__c,
                                UserId__c,BMS_Enabled__c,Location_code__c
                                FROM CSS_UserLocation__c
                                WHERE UserId__c = : userInfo.getUserId() AND isActive__c = true AND Location_Source__c != 'ARF'
                                ORDER BY Location_Name__c asc];
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake fetchMultiLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        system.debug('userLocationList--'+userLocationList);
        return userLocationList;
    }

    //Fetch Selected Locations.
    public static string selectedLocation(list<CSS_UserLocation__c> userLocationList) {
        string selectLocation;
        try {
            if(userLocationList != null && userLocationList.size() >0) {
                for(CSS_UserLocation__c ul : userLocationList) {
                    if(ul.isPrimary__c)
                        selectLocation = ul.Location_code__c;
                }
            }
            system.debug('selectLocation****'+selectLocation);
        } 

        catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake selectedLocation method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return selectLocation;
    }

    //Fetching Location values.
    public List<SelectOption> fetchLocationName(list<CSS_UserLocation__c> lstUserLocations) {
        List<SelectOption> options = new List<SelectOption>();
        try {
            if(lstUserLocations != null && lstUserLocations.size()>0) {
                //for loop to build the alll locations name options list 
                for(CSS_UserLocation__c ul : lstUserLocations) {
                    if((ul.Location_code__c != null && ul.Location_code__c != '') && (ul.Location_Name__c != null && ul.Location_Name__c != '') ){
                        options.add(new SelectOption(ul.Location_code__c,ul.Location_Name__c));
                    } else {
                        options.add(new SelectOption('--None--','--None--'));
                    }
                }
            } else {
                options.add(new SelectOption('--None--','--None--'));
                system.debug('inside option else');
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_BL_Intake - fetchLoactionName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return options;
    }


    //Fetching Country Values.
    public List<SelectOption> getCountry() {
        List<SelectOption> CountryList = new List<SelectOption>(); 
        Transient List<AggregateResult> lcountry = new List<AggregateResult>();
        try {       
            string strCtryQuery='Select CountryName__c, CountryCode__c From CSS_CountryStateValues__c group by CountryName__c, CountryCode__c Order By CountryName__c asc LIMIT 999';
            lcountry=Database.query(strCtryQuery);

            CountryList = new List<SelectOption>();
            CountryList.add(new SelectOption('','----None----'));
            for(AggregateResult ctry: lcountry) {                    
                CountryList.add(new SelectOption((string)ctry.get('CountryCode__c'), (string)ctry.get('CountryName__c')));
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake - getCountry Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return CountryList;
    }


    //Fetching State Values.
    public List<SelectOption> getStates(string filterCountry){     
        List<SelectOption> StatesList = new List<SelectOption>();
        Transient List<CSS_CountryStateValues__c> lstate = new List<CSS_CountryStateValues__c>();
        try {
            system.debug('filterCountry ---> ' + filterCountry);
            string strQuery='Select StateName__c, StateCode__c From CSS_CountryStateValues__c where CountryCode__c=\''+ filterCountry +'\' Order By StateName__c asc LIMIT 999';
            system.debug('Rajesh-strQuery ---> ' + strQuery);
            lstate=Database.query(strQuery);
            system.debug('rajesh-lstate ---> ' + lstate);
            StatesList.add(new SelectOption('','----None----'));
            for(CSS_CountryStateValues__c st: lstate) {
                StatesList.add(new SelectOption(st.StateCode__c,st.StateName__c));
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake - getCountry Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return StatesList;
    }


    //Fetching Application Values.
    public static List<SelectOption> getApplication() {
        List<SelectOption> lstApplications ; 
        try {

            CSS_JobEventTemporary__c[] applicationCodes;

            applicationCodes = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'ApplicationCodes'];
            system.debug('applicationCodes>>>'+applicationCodes);
            string jsonResponse = applicationCodes[0].Reason__c;
            CSS_WPR_SBL_ApplicationResJSON resJSON;
            //jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resJSON = (CSS_WPR_SBL_ApplicationResJSON)JSON.deserialize(jsonResponse ,CSS_WPR_SBL_ApplicationResJSON.class);

            //create a map with code and description
            //mapDescriptionToCode = new map<string,string>();

            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','----None----'));

            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                        //populating description to code map 
                        //mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                    }
                }
            }

            system.debug('lstApplications>>>'+lstApplications);
            lstApplications.sort();
        }
        catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake - getApplication Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstApplications;
    }

    /*  public static List<List<CSS_CampTsbTrp__c>> getTSBsTemp_Existing(Id wId, String esn, String qsolLanguage) {
        List<CSS_CampTsbTrp__c> lstTSB;
        List<List<CSS_CampTsbTrp__c>> campaignsList = new List<List<CSS_CampTsbTrp__c>>();
        try{
            CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
            system.debug('Before get Connection');
            string sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;                    
            system.debug('After get Connection');
            List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();
            CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
            //Get Campaign Information from QSOL based on ESN
            lstTSB = new List<CSS_CampTsbTrp__c>();
            system.debug('qsol language'+qsolLanguage);
            rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,esn,'TSB',qsolLanguage);
            if(rQSOLDocs !=null){
                wCAMTSBTRB = rQSOLDocs.item;
                if(wCAMTSBTRB!=null){
                    for(integer i=0;i<wCAMTSBTRB.size();i++){
                        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                        ctt1.Name = 'TSB' ;
                        ctt1.Type__c = 'TSB' ;
                        ctt1.Job_Order__c = wId;
                        ctt1.ESN__c = esn;
                        ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                        ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                        ctt1.Cu_Language__c = qsolLanguage;
                        ctt1.URL__c = wCAMTSBTRB[i].url;
                        lstTSB .add(ctt1);
                    } // End TSB Method Call
                }
                campaignsList.add(lstTSB);
                return campaignsList;
            }

        }catch(exception e){
            system.debug('entered into catch block of getTSBsTemp method'+e.getLineNumber()+' '+e.getmessage());
        }
        return null;
    }*/

    public static List<List<CSS_CampTsbTrp__c>> getTSBsTemp(Id wId, String esn, String qsolLanguage) {
        return CG_SL_QSOL.getQSOLWarrantyDocs(wId,null,esn,qsolLanguage,new list<string>{'TSB'});
    }

    //Get Campaign Information from QSOL based on ESN
    /*public static List<List<CSS_CampTsbTrp__c>> getQSOLDocs_Existing(Id wId, String esn, String qsolLanguage) {
        List<List<CSS_CampTsbTrp__c>> campaignsList;
        List<CSS_CampTsbTrp__c> lstCAM;
        List<CSS_CampTsbTrp__c> lstTRP;
        List<CSS_CampTsbTrp__c> lstTSB;
        List<CSS_CampTsbTrp__c> lstATC;
        try {
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
            system.debug('Before get Connection');
            string sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;                    
            system.debug('After get Connection');
            List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();
            CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();                                    
            lstCAM = new List<CSS_CampTsbTrp__c>();
            system.debug('checking user lang:'+qsolLanguage);
            rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,esn,'CAM',qsolLanguage);
            system.debug('inside user lang'+qsolLanguage);
            if(rQSOLDocs !=null){                                
                wCAMTSBTRB = rQSOLDocs.item;
                if(wCAMTSBTRB!=null){
                    for(integer i=0;i<wCAMTSBTRB.size();i++){
                        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                        ctt1.Name = 'CAM' ;
                        ctt1.Type__c = 'CAM' ;
                        ctt1.Job_Order__c = wId;
                        ctt1.ESN__c = esn;
                        ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                        ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                        ctt1.URL__c = wCAMTSBTRB[i].url; 
                        ctt1.Cu_Language__c = qsolLanguage;
                        lstCAM .add(ctt1);
                    } // End CAM Method Call
                }
            }
            campaignsList.add(lstCAM);
            system.debug('lstCAM Value of LIST=='+ lstCAM);

            //Get Campaign Information from QSOL based on ESN
            lstTSB = new List<CSS_CampTsbTrp__c>();
            system.debug('qsol language'+qsolLanguage);
            rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,esn,'TSB',qsolLanguage);
            if(rQSOLDocs !=null){
                wCAMTSBTRB = rQSOLDocs.item;
                if(wCAMTSBTRB!=null){
                    for(integer i=0;i<wCAMTSBTRB.size();i++){
                        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                        ctt1.Name = 'TSB' ;
                        ctt1.Type__c = 'TSB' ;
                        ctt1.Job_Order__c = wId;
                        ctt1.ESN__c = esn;
                        ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                        ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                        ctt1.Cu_Language__c = qsolLanguage;
                        ctt1.URL__c = wCAMTSBTRB[i].url;
                        lstTSB .add(ctt1);
                    } // End TSB Method Call
                }
            }
            campaignsList.add(lstTSB);
            system.debug('lstTSB Value of LIST=='+ lstTSB);

            //Get Campaign Information from QSOL based on ESN
            lstTRP = new List<CSS_CampTsbTrp__c>();
            rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,esn,'TRP',qsolLanguage);
            if(rQSOLDocs !=null){
                wCAMTSBTRB = rQSOLDocs.item;
                if(wCAMTSBTRB!=null){
                    for(integer i=0;i<wCAMTSBTRB.size();i++){
                        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                        ctt1.Name = 'TRP' ;
                        ctt1.Type__c = 'TRP' ;
                        ctt1.Job_Order__c = wId;
                        ctt1.ESN__c = esn;
                        ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                        ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                        ctt1.URL__c = wCAMTSBTRB[i].url;
                        ctt1.Cu_Language__c = qsolLanguage;
                        lstTRP .add(ctt1);
                    } // End TRB Method Call
                }
            }
            campaignsList.add(lstTRP);
            system.debug('lstTRP Value of LIST=='+ lstTRP);

            //Get ATC Information from QSOL based on ESN
            lstATC = new List<CSS_CampTsbTrp__c>();
            rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,esn,'ATC',qsolLanguage);
            if(rQSOLDocs !=null){
                wCAMTSBTRB = rQSOLDocs.item;
                if(wCAMTSBTRB!=null){
                    for(integer i=0;i<wCAMTSBTRB.size();i++){
                        CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                        ctt1.Name = 'ATC' ;
                        ctt1.Type__c = 'ATC' ;
                        ctt1.Job_Order__c = wId;
                        ctt1.ESN__c = esn;
                        ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
                        ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
                        ctt1.URL__c = wCAMTSBTRB[i].url;
                        ctt1.Cu_Language__c = qsolLanguage;
                        lstATC.add(ctt1);
                    } // End ATC Method Call
                }
            }
            system.debug('lstATC Value of LIST=='+ lstATC);
            //End All CAM,ATC, TSB & TRB
            campaignsList.add(lstATC);
        }
        catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake - getQSOLDocs Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return campaignsList;
    }*/

    public static List<List<CSS_CampTsbTrp__c>> getQSOLDocs(Id wId, String esn, String qsolLanguage) {
        return CG_SL_QSOL.getQSOLWarrantyDocs(wId,null,esn,qsolLanguage,new list<string>{'CAMPAIGN','TSB','ATC','TRP'});
    }

    public static List<List<CSS_CampTsbTrp__c>> getQSOLClaimsDocs(Id wId, String esn, String qsolLanguage) {
        return CG_SL_QSOL.getQSOLWarrantyDocs(null,wId,esn,qsolLanguage,new list<string>{'CAMPAIGN','TSB','ATC','TRP'});
    }




    //This method is used for retrieving Siebel campaigns with QSOL links
    public static List<List<CSS_CampTsbTrp__c>> getSiebelQSOLCampaigns(Id workJobId, String esn, String qsolLanguage, String serviceModel, Date failureDate) {
        System.debug('in getSiebelQSOLCampaigns method....esn>>:'+esn);
        System.debug('Anirudh QsolLanguage>>:'+qsolLanguage);
        List<List<CSS_CampTsbTrp__c>> campaignsList;
        List<CSS_CampTsbTrp__c> lstCAM;
        List<CSS_CampTsbTrp__c> lstTRP;
        List<CSS_CampTsbTrp__c> lstTSB;
        List<CSS_CampTsbTrp__c> lstATC;
        try{
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>(); 
            List<CSS_Solution_Component__c> solCompCTTP;
            List<CSS_CampTsbTrp__c> lstQSOLDocs;

            if (workJobId !=null){ // added this condition to fix 143771

                solCompCTTP = new List<CSS_Solution_Component__c>([select Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :workJobId AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000]);
                //Get QSOL Docs for existing ESN
                lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                           Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                           Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                           where Job_Order__c = :workJobId and ESN__c = :esn
                                                           order by Performed_Review__c desc]);

            }
            system.debug('in getSiebelQSOLCampaigns lstSOLCOMPDocs++++++'+solCompCTTP);
            system.debug(' in getSiebelQSOLCampaigns lstQSOLDocs++++++'+lstQSOLDocs);
            if (lstQSOLDocs.size()>0) {
                for (CSS_CampTsbTrp__c recQSOLDocs : lstQSOLDocs ) {
                    //system.debug('**type***'+recQSOLDocs.Type__c);
                    if (recQSOLDocs.Type__c == 'CAM') { lstCAM.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'TSB') { lstTSB.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'TRP') { lstTRP.add(recQSOLDocs); }
                    if (recQSOLDocs.Type__c == 'ATC') { lstATC.add(recQSOLDocs); }
                }
            }
            //qsollanguage(); //is this method needed??? //Not Needed
            List<List<CSS_CampTsbTrp__c>> qsolList = getQSOLDocs(workJobId, esn, qsolLanguage);//Defect Fix TRPs were not showing up when there is no campaings etc.TRPs should be independent - Anirudh
            if(lstQSOLDocs.size()>0 && lstQSOLDocs[0].Cu_Language__c != null && qsolLanguage !=null && qsolLanguage.trim() !=''){
                List<List<CSS_CampTsbTrp__c>> qsolListTSB2 = getTSBsTemp(workJobId, esn, qsolLanguage);
                if(qsolListTSB2 !=null && qsolListTSB2.size()>0){
                    lstTSB = qsolListTSB2.get(1);
                    campaignsList.add(lstTSB);
                }

            }
            if(solCompCTTP != null && solCompCTTP.size()>0 && lstQSOLDocs !=null && lstQSOLDocs.size()>0){


                //checking here if language is changed from header menu
                if(lstQSOLDocs[0].Cu_Language__c != null && qsolLanguage !=null && qsolLanguage.trim() !='' && lstQSOLDocs[0].Cu_Language__c != qsolLanguage ){
                    //here call QSOL service to get campaigns

                    system.debug('qsolList>>>:'+qsolList);
                    if(qsolList !=null && qsolList.size()>0)
                        lstCAM = qsolList.get(0);
                    if(qsolList !=null && qsolList.size()>2)
                        lstTRP = qsolList.get(2);
                    if(qsolList !=null && qsolList.size()>3)
                        lstATC = qsolList.get(3);
                    System.debug('QSOL lstCAM>>>:'+lstCAM);
                    System.debug('QSOL lstTSB>>>:'+lstTSB);
                    System.debug('QSOL lstTRP>>>:'+lstTRP);
                    System.debug('QSOL lstATC>>>:'+lstATC);
                    //End QSOL CAM,ATC, TSB & TRB

                    //update QSOL links & language
                    List<CSS_CampTsbTrp__c> lstALL = new List<CSS_CampTsbTrp__c>();
                    lstALL.addAll(lstCAM);
                    lstALL.addAll(lstTSB);
                    lstALL.addAll(lstTRP);
                    lstALL.addAll(lstATC);
                    system.debug('lstALL >>>>> ' + lstALL);
                    for(CSS_CampTsbTrp__c qsolDbObj : lstQSOLDocs){
                        for(CSS_CampTsbTrp__c qsolObj : lstALL){
                            if(qsolDbObj.Doc_Num__c !=null && qsolObj.Doc_Num__c !=null && qsolDbObj.Doc_Num__c == qsolObj.Doc_Num__c && qsolDbObj.Type__c == qsolObj.Type__c){
                                qsolDbObj.Cu_Language__c = qsolLanguage;
                                qsolDbObj.URL__c = qsolObj.URL__c;
                            }
                        }
                    }
                    update lstQSOLDocs;
                    system.debug(' updated lstQSOLDocs >>>>>' + lstQSOLDocs);

                    //Here need to build save functionality for Qsol with changed/selected language
                    //insert campsTsbsTRPs;
                    //Delete existing saved QSOL campaigns for previous language
                    //delete lstQSOLDocs;
                }

                //Here adding QSOL links to SIEBEL list
                List<List<CSS_CampTsbTrp__c>> campaignsListTemp = addQSOLLinksToSiebelData(workjobId, solCompCTTP, lstCAM, lstTRP, lstATC);
                campaignsList.add(campaignsListTemp.get(0));  //CAM
                //campaignsList.add(lstTSB); //TSB
                campaignsList.add(campaignsListTemp.get(1)); //TRP
                campaignsList.add(campaignsListTemp.get(2)); //ATC
                system.debug('campaignsList>>>:'+campaignsList);
            }
            system.debug('campaignsList>>>:'+campaignsList);

        } catch(exception e) {
            system.debug('EXCEPTION of CG_BL_Intake getSiebelQSOLCampaigns method >>> '+e.getMessage() + e.getLineNumber());
        }
        return campaignsList;
    }

    public static List<List<CSS_CampTsbTrp__c>> getCampaigns(String esn, String sServiceModel, Date failureDate, String qsolLanguage, Id wId) {
        System.debug('$$$$$$$$$$$$$$$$$ in getCampaigns method of CG_BL_Intake $$$$$$$$$$$$$$$$$$$$$');
        List<List<CSS_CampTsbTrp__c>> campaignsList;
        Map<String,string> campNumAccCodeMap = new Map<String,string>();
        String selectedLocation;
        try {
            List<CSS_Job_Order__c> workJob = new List<CSS_Job_Order__c>();
            system.debug('wId'+wId);
            //workJob = [SELECT Id, Creator_Location__c,Account__r.Region__c,FieldActionWebServiceResult__c FROM CSS_Job_Order__c WHERE Id =: wId LIMIT 1];
            workJob = [SELECT Id, ESN__c, name, ReconEngineFlag__c, Account__r.Region__c,FieldActionWebServiceResult__c, Creator_Location__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: wId limit 1];
            //String selectedLocation = (String) Cache.Session.get('selectedLocation');
            List<CSS_PSN__c> psnRec = new List<CSS_PSN__c>();
            //  CSS_PSN__c psnRec = new CSS_PSN__c();
            psnRec = [SELECT Id,PSN__c, Failure_Date__c,Mileage_Measure__c,ApplicationCode__c,Warranty_Start_Date__c,Mileage__c,CSS_Claims__c, CSS_Claims__r.Location_Code__c,CSS_Claims__r.ReconEngineFlag__c,CSS_Claims__r.Name FROM CSS_PSN__c WHERE Id =: wId LIMIT 1];

            system.debug('workJob'+workJob);
            if(workJob != null && workJob.size() > 0 && workJob[0].Creator_Location__c != null && workJob[0].Creator_Location__c != '')
                selectedLocation = workJob[0].Creator_Location__c;
            else{
                selectedLocation = (String) Cache.Session.get('ManualClaimsSelectedLocation');
                if(selectedLocation == null || selectedLocation == ''){
                    //List<CSS_PSN__c> claimRec = new List<CSS_PSN__c>();
                    //claimRec = [SELECT Id, CSS_Claims__r.Location_Code__c FROM CSS_PSN__c WHERE Id =: wId LIMIT 1];
                    if(psnRec != null && psnRec.size() > 0 && psnRec[0].CSS_Claims__r.Location_Code__c != null && psnRec[0].CSS_Claims__r.Location_Code__c != '')
                        selectedLocation = psnRec[0].CSS_Claims__r.Location_Code__c;
                }
            }
            system.debug('selectedLocation'+selectedLocation);
            //system.debug('session variable'+(String) Cache.Session.get('selectedLocation'));
            if(selectedLocation==null || selectedLocation==''){
                selectedLocation = ([select Id,User_Location__c,FederationIdentifier,LanguageLocaleKey from User where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
            }
            system.debug('inside*$$$$'+sServiceModel+' selectedLocation>>>:'+selectedLocation+' failureDate>>>:'+failureDate);
            //Get SPCode from selectedLocation
            //String spCode = selectedLocation.split('-')[1]; //take last 5 digits here
            String spCode = selectedLocation.trim().right(5); //take last 5 digits here
            system.debug('first spCode>:'+spCode);   
            /*String[] arrExt;
if(selectedLocation != null && selectedLocation != ''){
arrExt = selectedLocation.split('-');
system.debug('arrExt size>:'+arrExt.size());
if(arrExt.size()>2){
spCode = arrExt[arrExt.size()-1];
system.debug('22 spCode>:'+spCode);   
}
}*/
            system.debug('spCode>:'+spCode);   
            spCode = spCode.trim();

            //calling SPData SIEBEL service here to get Region
            //prepare & pass failureDate format as 01-AUG-14 for SPData webservice input
            String failureDateStr = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('dd-MMM-YY');
            System.debug('failureDateStr>>>:'+failureDateStr+' spCode>>:'+spCode+' sServiceModel**'+sServiceModel+' esn**'+esn);
            /*CSS_GetServiceProviderResponse serviceProviderResponse = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr); //sServiceModel passing null bcz not needed here to pass
if(serviceProviderResponse !=null)
system.debug('serviceProviderResponse.DataArea $$$$$$$$$$$$$$$$$$$$$$$$$$$$$:'+serviceProviderResponse.DataArea);*/
            // system.debug('serviceProviderResponse.DataArea.Region**'+serviceProviderResponse.DataArea.Region);
            String region;
            if(workJob != null && workJob.size() > 0)
                region=workJob[0].Account__r.Region__c;
            else{
                List<CSS_PSN__c> claimRec = new List<CSS_PSN__c>();
                claimRec = [SELECT Id, CSS_Claims__r.Account__r.Region__c FROM CSS_PSN__c WHERE Id =: wId LIMIT 1];
                if(claimRec != null && claimRec.size() > 0)
                    region=claimRec[0].CSS_Claims__r.Account__r.Region__c;
            }
            /*if (serviceProviderResponse == null || serviceProviderResponse.DataArea ==null || serviceProviderResponse.DataArea.Region == null)
region = '';
else
region = serviceProviderResponse.DataArea.Region;*/
            System.debug('after getting from SPData ws Region>>>:'+region);

            //calling GetCampaigns SIEBEL service here
            System.debug('before calling CG_SL_Campaigns.callGetCampaignsWS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
            CG_OP_OAGWrapper resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDateStr, region, '', 'CSS','GetCampaign','UniqueID','CSSWarranty');
            CG_OP_CampaignsResJSON outputRes;
            system.debug('resWrapper.response****' + resWrapper.response);
            system.debug('workjob******' + workjob);
            system.debug('workjob******' + workjob.size());
            if(resWrapper.response!=null)
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            //for testing purpose below hard code res stmts
            //For Campaigns
            //String resBody = '{"DataArea":{"Details":[{"CampaignDesc":"ISX12 G REVISED PISTON AND PISTON RINGS","CampaignEndDate":"2020-03-09","CampaignStartDate":"2015-03-03","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"01-138-00","SrtDescription":"Piston - Remove and Install, Each Additional"}],"FailCode":"WBPR","FailMode":"GV","InShopSrtLimitFlag":"N","Status":"Approved","MultipleTimes":"N","BusinessUnit":"CMI","CampaignType":"Campaign","CompleteIndicator":"N","PartList":[{"PartQuantity":5,"PartNumber":437627100,"PartDescription":"KIT,ENGINE PISTON"},{"PartQuantity":5,"PartNumber":430917400,"PartDescription":"BEARING,CON ROD (STD)"}],"CampaignNumber":1461}]},"Header":{"Status":"Success"}}';
            //For ATCs
            //String resBody = '{"DataArea":{"Details":[{"CampaignDesc":"ISX12 G REVISED PISTON AND PISTON RINGS","CampaignEndDate":"2020-03-09","CampaignStartDate":"2015-03-03","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"01-138-00","SrtDescription":"Piston - Remove and Install, Each Additional"}],"FailCode":"WBPR","FailMode":"GV","InShopSrtLimitFlag":"N","Status":"Approved","MultipleTimes":"N","BusinessUnit":"CMI","CampaignType":"ATC","CompleteIndicator":"N","PartList":[{"PartQuantity":5,"PartNumber":437627100,"PartDescription":"KIT,ENGINE PISTON"},{"PartQuantity":5,"PartNumber":430917400,"PartDescription":"BEARING,CON ROD (STD)"}],"CampaignNumber":1538}]},"Header":{"Status":"Success"}}';
            //For TRPs
            //String resBody = '{"DataArea":{"Details":[{"CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST","CampaignEndDate":"2020-12-31","CampaignStartDate":"2015-02-27","SrtList":[{"SrtCode":"00-901-00","SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"},{"SrtCode":"01-138-00","SrtDescription":"Piston - Remove and Install, Each Additional"}],"FailCode":"WBPR","FailMode":"GV","InShopSrtLimitFlag":"N","Status":"Approved","MultipleTimes":"N","BusinessUnit":"CMI","CampaignType":"TRP","CompleteIndicator":"N","PartList":[{"PartQuantity":5,"PartNumber":437627100,"PartDescription":"KIT,ENGINE PISTON"},{"PartQuantity":1,"PartNumber":388639600,"PartDescription":"6.2 CALIBRATION FLT REG."}],"CampaignNumber":1609}]},"Header":{"Status":"Success"}}';
            //CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            //CG_OP_CampaignsResJSON outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resBody, CG_OP_CampaignsResJSON.class);
            //system.debug('CG_OP_CampaignsResJSON outputRes>>>:'+outputRes+' resWrapper.response.getBody>>>:'+resWrapper.response.getBody());
            system.debug('outputRes**'+outputRes);

            if(outputRes!=null && outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);

                /*CSS_Job_Order__c rJobOrd = new CSS_Job_Order__c();
system.debug('Testwid'+wId);
rJobOrd = [SELECT Id, ESN__c, ReconEngineFlag__c, Creator_Location__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: wId];
system.debug('rJobOrd**'+rJobOrd);*/


                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;
                    if(det.Status == 'Approved' ){
                        String tempSysCode;
                        String tempCompCode;
                        String tempComponentId;
                        if(det.CampaignNumber != null)
                            tempComponentId = string.valueof(det.CampaignNumber);

                        if(det.FailCode != null && det.FailCode != ''){
                            tempSysCode = (det.FailCode).substring(0,2);
                            tempCompCode = (det.FailCode).substring(2);
                        }

                        system.debug('FailureDate:'+workJob[0].Failure_Date__c+' Mileage:'+workJob[0].Mileage__c+' Measure:'+workJob[0].Mileage_Measure__c);
                        if(workJob[0].Failure_Date__c == null)
                            workJob[0].Failure_Date__c = Date.Today();
                        if(workJob[0].Mileage__c == null)
                            workJob[0].Mileage__c = 0;
                        if(workJob[0].Mileage_Measure__c == null)
                            workJob[0].Mileage_Measure__c = 'Miles';
                        
                        
                        //calling detail coverage as per story 184437 to check coverage before fieldaction insert
                        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                        if(workJob != null && workJob.size() > 0){
                            comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(esn,(workJob[0].Creator_Location__c).right(5),workJob[0].Failure_Date__c,string.valueof(workJob[0].Mileage__c),workJob[0].Mileage_Measure__c,workJob[0].ApplicationCode__c,workJob[0].Warranty_Start_Date__c,tempSysCode,tempCompcode,'','',null,false,tempComponentId,'','Second Call', workJob[0].ReconEngineFlag__c, false,workJob[0].Name);
                        }
                        else{
                            if(psnRec != null && psnRec.size() > 0){
                                comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(esn,(selectedLocation).right(5),psnRec[0].Failure_Date__c,String.valueof(psnRec[0].Mileage__c),psnRec[0].Mileage_Measure__c,psnRec[0].ApplicationCode__c,psnRec[0].Warranty_Start_Date__c,tempSysCode,tempCompcode,'','',null,false,tempComponentId,'','Second Call', psnRec[0].CSS_Claims__r.ReconEngineFlag__c,false,psnRec[0].CSS_Claims__r.Name);
                            }
                        }
                        System.debug('comp****' + comp);
                        system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                        if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                            campNumAccCodeMap.put(tempComponentId, comp.AccountCode__c);
                        }
                        system.debug('campNumAccCodeMap'+campNumAccCodeMap);
                    }
                }
            }           

            //here call QSOL service to get campaigns
            campaignsList = getQSOLDocs(wId, esn, qsolLanguage);
            system.debug('QSOL campaignsList***'+campaignsList);

            List<CSS_CampTsbTrp__c> lstCAM;
            List<CSS_CampTsbTrp__c> lstTRP;
            List<CSS_CampTsbTrp__c> lstTSB;
            List<CSS_CampTsbTrp__c> lstATC;
            List<CSS_CampTsbTrp__c> lstFARes = new List<CSS_CampTsbTrp__c>();
            if(campaignsList !=null && campaignsList.size()>0) //check here
                lstCAM = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>=1)
                lstTSB = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>=2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>=3)
                lstATC = campaignsList.get(3);
            System.debug('QSOL lstCAM>>>:'+lstCAM);
            System.debug('QSOL lstTSB>>>:'+lstTSB);
            System.debug('QSOL lstTRP>>>:'+lstTRP);
            System.debug('QSOL lstATC>>>:'+lstATC);
            //End All CAM,ATC, TSB & TRB

            //Here build logic for compare both Campaigns of QSOL & SIEBEL and prepare SIEBEL list by including QSOL URLs and include TSBs from QSOL 
            //since SIEBEL don't provide TSBs //i.e. take URL from QSOL and add to SIEBEL campaigns & finally prepare SIEBEL list 
            //build logic here //Kalpana

            list<CSS_CampTsbTrp__c> lstSBLCAM;
            list<CSS_CampTsbTrp__c> lstSBLTRP;
            list<CSS_CampTsbTrp__c> lstSBLATC;

            list<CSS_CampTsbTrp__c> finallstSBLCAM; 
            list<CSS_CampTsbTrp__c> finallstSBLTRP; 
            list<CSS_CampTsbTrp__c> finallstSBLATC; 

            if(outputRes!=null && outputRes.DataArea != null){
                lstSBLCAM = new list<CSS_CampTsbTrp__c>(); 
                lstSBLTRP = new list<CSS_CampTsbTrp__c>();
                lstSBLATC = new list<CSS_CampTsbTrp__c>();
                finallstSBLCAM = new list<CSS_CampTsbTrp__c>();
                finallstSBLTRP = new list<CSS_CampTsbTrp__c>();
                finallstSBLATC = new list<CSS_CampTsbTrp__c>(); 

                CSS_CampTsbTrp__c campaignComp;
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){

                    //Here check Siebel Campaigns are meeting required criteria
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                        continue;

                    campaignComp = new CSS_CampTsbTrp__c();
                    if(det.CampaignType == 'Campaign'){                        
                        campaignComp.Name = 'CAM' ;
                        campaignComp.Type__c = 'CAM' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        system.debug('det.CampaignNumber**'+det.CampaignNumber);
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLCAM.add(campaignComp);
                    }else if(det.CampaignType == 'TRP'){
                        campaignComp.Name = 'TRP' ;
                        campaignComp.Type__c = 'TRP' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLTRP.add(campaignComp);
                    }else if(det.CampaignType == 'ATC'){
                        campaignComp.Name = 'ATC' ;
                        campaignComp.Type__c = 'ATC' ;
                        campaignComp.Job_Order__c = wId;
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLATC.add(campaignComp);
                    }
                }
                System.debug('lstSBLCAM>>>:'+lstSBLCAM);
                System.debug('lstSBLTRP>>>:'+lstSBLTRP);
                System.debug('lstSBLATC>>>:'+lstSBLATC);
            }

            //compare SIEBEL & QSOL campaigns to get URLs
            //System.debug('Example After 3 chars>>:'+str.substring(3,str.length()));
            if(lstSBLCAM != null && lstSBLCAM.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLCAM){
                    system.debug('SBLREC*'+SblCampRec);
                    if(lstCAM != null && lstCAM.size()>0){
                        String tempAccCode;

                        if(campNumAccCodeMap != null){
                            tempAccCode = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                        }
                        system.debug('tempAccCode'+tempAccCode);
                        if(tempAccCode != null && tempAccCode != ''){
                            for(CSS_CampTsbTrp__c campRec: lstCAM){
                                system.debug('SblCampRec.DocNum2>>:'+SblCampRec.Doc_Num__c);
                                system.debug('QSOL campRec.DocNum2>>:'+campRec.Doc_Num__c);
                                system.debug('QSOL substing campRec.DocNum>>:'+campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()));
                                if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1){
                                    if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                        system.debug('Inside###');
                                        system.debug('campRec.URL__c###'+campRec.URL__c);
                                        SblCampRec.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }
                            }
                            finallstSBLCAM.add(SblCampRec);
                        }

                    }                    
                    system.debug('SblCampRecOutside**'+SblCampRec);
                }
            }
            system.debug('lstSBLTRP**'+lstSBLTRP);
            system.debug('lstSBLTRP**'+lstTRP);
            if(lstSBLTRP != null && lstSBLTRP.size()>0){
                system.debug('Inside If***');
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLTRP){
                    system.debug('Inside for***');
                    if(lstTRP != null && lstTRP.size()>0){
                        system.debug('Inside If2***');
                        string tempAccode1;
                        if(campNumAccCodeMap!=null){
                            tempAccode1 = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                        }
                        if(tempAccode1 !=null && tempAccode1 !=''){
                            for(CSS_CampTsbTrp__c campRec: lstTRP){
                                system.debug('Inside for2***');
                                if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1)
                                    //system.debug('campRec.DocNum*'+campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()));
                                    //system.debug('campRec.DocNum2*'+campRec.Doc_Num__c);
                                    //system.debug('SblCampRec.DocNum2*'+SblCampRec.Doc_Num__c);
                                    if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                        SblCampRec.URL__c = campRec.URL__c;
                                        break;
                                    }
                            }
                            finallstSBLTRP.add(SblCampRec);
                        }  
                        system.debug('FinalLst***'+finallstSBLTRP);
                    } 
                }
            }
            if(lstSBLATC != null && lstSBLATC.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLATC){
                    if(lstATC != null && lstATC.size()>0){
                        string tempAcccode2;
                        if(campNumAccCodeMap!=null){
                            tempAcccode2 = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                        }
                        if(tempAcccode2 !=null && tempAcccode2!=''){
                            for(CSS_CampTsbTrp__c campRec: lstATC){
                                if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>3)
                                    if(campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                        SblCampRec.URL__c = campRec.URL__c;
                                        break;
                                    }
                            }
                            finallstSBLATC.add(SblCampRec);
                        }

                    } 

                }
            }

            //adding final lists
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            System.debug('new campaignsList>>>:'+campaignsList);
            if(finallstSBLCAM !=null && finallstSBLCAM.size()>=0)
                campaignsList.add(finallstSBLCAM);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(lstTSB !=null && lstTSB.size()>=1)
                campaignsList.add(lstTSB);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLTRP !=null && finallstSBLTRP.size()>=0)
                campaignsList.add(finallstSBLTRP);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLATC !=null && finallstSBLATC.size()>=0)
                campaignsList.add(finallstSBLATC);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());

            String res;
            if(resWrapper.response==null)
                res='Error';
            else
                res='Success';
            List<CSS_CampTsbTrp__c> lstFAError;
            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Name = 'FAError' ;
            ctt1.Type__c = 'FAError' ;
            ctt1.Job_Order__c = wId;
            ctt1.ESN__c = esn;
            ctt1.Doc_Num__c = res;
            lstFARes .add(ctt1);
            campaignsList.add(lstFARes);

            System.debug('after spDataWrapper adding campaignsList>>>:'+campaignsList);
            system.debug('res123*' + res); 
            /*if(workjob.size()>0){
update workjob[0];
}*/

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - getCampaigns Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return campaignsList;
    }

    //method for comparing SIEBEL list with QSOL list to add URLs
    public static List<List<CSS_CampTsbTrp__c>> addQSOLLinksToSiebelData(Id workJobId, List<css_solution_component__c> solCompCTTP, List<CSS_CampTsbTrp__c> lstCAM, List<CSS_CampTsbTrp__c> lstTRP, List<CSS_CampTsbTrp__c> lstATC) {
        List<List<CSS_CampTsbTrp__c>> campaignsList;
        List<CSS_CampTsbTrp__c> lstSBLCAM;
        List<CSS_CampTsbTrp__c> lstSBLTRP;
        List<CSS_CampTsbTrp__c> lstSBLATC;

        List<CSS_CampTsbTrp__c> finallstSBLCAM; 
        List<CSS_CampTsbTrp__c> finallstSBLTRP; 
        List<CSS_CampTsbTrp__c> finallstSBLATC; 
        try {
            lstSBLCAM = new list<CSS_CampTsbTrp__c>(); 
            lstSBLTRP = new list<CSS_CampTsbTrp__c>();
            lstSBLATC = new list<CSS_CampTsbTrp__c>();
            finallstSBLCAM = new list<CSS_CampTsbTrp__c>();
            finallstSBLTRP = new list<CSS_CampTsbTrp__c>();
            finallstSBLATC = new list<CSS_CampTsbTrp__c>(); 

            CSS_CampTsbTrp__c campaignComp;
            for(css_solution_component__c solComp: solCompCTTP){
                campaignComp = new CSS_CampTsbTrp__c();
                if(solComp.Type__c == 'Campaign'){
                    campaignComp.Name = 'CAM' ;
                    campaignComp.Type__c = 'CAM' ;
                    campaignComp.Job_Order__c = workJobId;
                    //campaignComp.ESN__c = esn;
                    campaignComp.Doc_Num__c = solComp.Component_Id__c;
                    campaignComp.Doc_Title__c = solComp.Campaign_Description__c;
                    lstSBLCAM.add(campaignComp);  

                }else if(solComp.Type__c == 'TRP'){
                    campaignComp.Name = 'TRP' ;
                    campaignComp.Type__c = 'TRP' ;
                    campaignComp.Job_Order__c = workJobId;
                    //campaignComp.ESN__c = esn;
                    campaignComp.Doc_Num__c = solComp.Component_Id__c;
                    campaignComp.Doc_Title__c = solComp.Campaign_Description__c;
                    lstSBLTRP.add(campaignComp);
                }else if(solComp.Type__c == 'ATC'){
                    campaignComp.Name = 'ATC' ;
                    campaignComp.Type__c = 'ATC' ;
                    campaignComp.Job_Order__c = workJobId;
                    //campaignComp.ESN__c = esn;
                    campaignComp.Doc_Num__c = solComp.Component_Id__c;
                    campaignComp.Doc_Title__c = solComp.Campaign_Description__c;
                    lstSBLATC.add(campaignComp);
                }
            }
            System.debug('lstSBLCAM>>>:'+lstSBLCAM);
            System.debug('lstSBLTRP>>>:'+lstSBLTRP);
            System.debug('lstSBLATC>>>:'+lstSBLATC);

            if(lstSBLCAM != null && lstSBLCAM.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLCAM){
                    if(lstCAM != null && lstCAM.size()>0){
                        for(CSS_CampTsbTrp__c campRec: lstCAM){
                            system.debug('SblCampRec.DocNum2>>:'+SblCampRec.Doc_Num__c);
                            system.debug('QSOL campRec.DocNum2>>:'+campRec.Doc_Num__c);
                            system.debug('QSOL substing campRec.DocNum>>:'+campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()));
                            if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1)
                                if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                    //if(SblCampRec.Doc_Num__c == campRec.Doc_Num__c){
                                    SblCampRec.URL__c = campRec.URL__c;
                                    break;
                                }
                        }
                    }
                    finallstSBLCAM.add(SblCampRec);
                }
            }
            if(lstSBLTRP != null && lstSBLTRP.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLTRP){
                    if(lstTRP != null && lstTRP.size()>0){
                        for(CSS_CampTsbTrp__c campRec: lstTRP){
                            if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1)
                                if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                    //if(SblCampRec.Doc_Num__c == campRec.Doc_Num__c){
                                    SblCampRec.URL__c = campRec.URL__c;
                                    break;
                                }
                        }
                    }
                    finallstSBLTRP.add(SblCampRec);
                    system.debug('finallstSBLTRP**'+finallstSBLTRP);
                }
            }
            if(lstSBLATC != null && lstSBLATC.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLATC){
                    if(lstATC != null && lstATC.size()>0){
                        for(CSS_CampTsbTrp__c campRec: lstATC){
                            if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>3)
                                if(campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){ 
                                    //if(SblCampRec.Doc_Num__c == campRec.Doc_Num__c){
                                    SblCampRec.URL__c = campRec.URL__c;
                                    break;
                                }
                        }
                    }
                    finallstSBLATC.add(SblCampRec);
                }
            }

            //adding final lists
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            if(finallstSBLCAM !=null && finallstSBLCAM.size()>=0)
                campaignsList.add(finallstSBLCAM);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLTRP !=null && finallstSBLTRP.size()>=0)
                campaignsList.add(finallstSBLTRP);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLATC !=null && finallstSBLATC.size()>=0)
                campaignsList.add(finallstSBLATC);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            System.debug('new campaignsList>>>:'+campaignsList);

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - addQSOLLinksToSiebelData Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return campaignsList;
    }

    //method for comparing SIEBEL list with QSOL list to add URLs
    public static List<css_solution_component__c> addQSOLLinksToSiebelQueryList(List<css_solution_component__c> solCompCTTP, List<CSS_CampTsbTrp__c> lstQSOLDocs) {
        try {
            for(css_solution_component__c solComp: solCompCTTP){
                for(CSS_CampTsbTrp__c campRec: lstQSOLDocs){
                    if(solComp.Component_Id__c !=null && solComp.Component_Id__c.trim() !='' && campRec.Doc_Num__c !=null && campRec.Doc_Num__c.trim() !=''){
                        if(solComp.Type__c == 'CAMPAIGN'){
                            if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'CAM'){
                                solComp.URL__c = campRec.URL__c;
                                break;
                            }
                        }else if(solComp.Type__c == 'TRP'){
                            if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'TRP'){
                                solComp.URL__c = campRec.URL__c;
                                break;
                            }
                        }else if(solComp.Type__c == 'ATC'){
                            if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) && campRec.Type__c == 'ATC'){
                                solComp.URL__c = campRec.URL__c;
                                break;
                            }
                        }
                    }
                }
            }
            System.debug('after adding URLs solCompCTTP>>>:'+solCompCTTP);

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - addQSOLLinksToSiebelQueryList Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return solCompCTTP;
    }


    //For GSSC-409
    public static List<List<CSS_CampTsbTrp__c>> getCampaignsForUT(String esn, String sServiceModel, Date failureDate, String qsolLanguage, String region, String mileage, 
                                                                  String mileageMeasure,String applicationCode, Date warrantyStartDate, String reconEngineFlag) {
        System.debug('$$$$$$$$$$$$$$$$$ in getCampaignsForUT method of CG_BL_Intake $$$$$$$$$$$$$$$$$$$$$');
        List<List<CSS_CampTsbTrp__c>> campaignsList;
        Map<String,string> campNumAccCodeMap = new Map<String,string>();
        String selectedLocation;
        try {
            system.debug('selectedLocation'+selectedLocation);
            //system.debug('session variable'+(String) Cache.Session.get('selectedLocation'));
            if(selectedLocation==null || selectedLocation==''){
                selectedLocation = ([select Id,User_Location__c,FederationIdentifier,LanguageLocaleKey from User where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
            }
            system.debug('inside*$$$$'+sServiceModel+' selectedLocation>>>:'+selectedLocation+' failureDate>>>:'+failureDate);
            
            //prepare & pass failureDate format as 01-AUG-14 for SPData webservice input
            String failureDateStr = DateTime.newInstance(failureDate.year(),failureDate.month(),failureDate.day()).format('dd-MMM-YY');
            System.debug('failureDateStr>>>:'+failureDateStr+' Region>>:'+region+' sServiceModel**'+sServiceModel+' esn**'+esn);
            
            //calling GetCampaigns SIEBEL service here
            System.debug('before calling CG_SL_Campaigns.callGetCampaignsWS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
            CG_OP_OAGWrapper resWrapper = CG_SL_Campaigns.callGetCampaignsWS(esn, failureDateStr, region, '', 'CSS','GetCampaign','UniqueID','CSSWarranty');
            CG_OP_CampaignsResJSON outputRes;
            system.debug('resWrapper.response****' + resWrapper.response);
            if(resWrapper.response!=null)
                outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_CampaignsResJSON.class);
            system.debug('outputRes**'+outputRes);

            if(outputRes!=null && outputRes.DataArea != null){
                system.debug('outputRes.DataArea ' + outputRes.DataArea);
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                    if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') ) //temperarily commented
                        //if(det.Status != 'Approved' )
                        continue;
                    if(det.Status == 'Approved' ){
                        String tempSysCode;
                        String tempCompCode;
                        String tempComponentId;
                        if(det.CampaignNumber != null)
                            tempComponentId = string.valueof(det.CampaignNumber);

                        if(det.FailCode != null && det.FailCode != ''){
                            tempSysCode = (det.FailCode).substring(0,2);
                            tempCompCode = (det.FailCode).substring(2);
                        }

                        //calling detail coverage as per story 184437 to check coverage before fieldaction insert
                        system.debug('before calling getWarrantyDetailCoverage... det.Status:'+det.Status);
                        CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                        comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(esn,selectedLocation,failureDate,string.valueof(mileage),mileageMeasure,applicationCode,warrantyStartDate,tempSysCode,tempCompcode,'','',null,false,tempComponentId,'','Second Call', reconEngineFlag, false,'TestJob');
                        System.debug('comp****' + comp);
                        system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                        if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                            campNumAccCodeMap.put(tempComponentId, comp.AccountCode__c);
                        }
                        system.debug('campNumAccCodeMap'+campNumAccCodeMap);
                    }
                }
            }           

            //here call QSOL service to get campaigns
            //campaignsList = getQSOLDocs(wId, esn, qsolLanguage);
            campaignsList = getQSOLDocs(null, esn, qsolLanguage); //JobId is null
            system.debug('QSOL campaignsList***'+campaignsList);

            List<CSS_CampTsbTrp__c> lstCAM;
            List<CSS_CampTsbTrp__c> lstTRP;
            List<CSS_CampTsbTrp__c> lstTSB;
            List<CSS_CampTsbTrp__c> lstATC;
            List<CSS_CampTsbTrp__c> lstFARes = new List<CSS_CampTsbTrp__c>();
            if(campaignsList !=null && campaignsList.size()>0) //check here
                lstCAM = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>=1)
                lstTSB = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>=2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>=3)
                lstATC = campaignsList.get(3);
            System.debug('QSOL lstCAM>>>:'+lstCAM);
            System.debug('QSOL lstTSB>>>:'+lstTSB);
            System.debug('QSOL lstTRP>>>:'+lstTRP);
            System.debug('QSOL lstATC>>>:'+lstATC);
            //End All CAM,ATC, TSB & TRB

            //Here build logic for compare both Campaigns of QSOL & SIEBEL and prepare SIEBEL list by including QSOL URLs and include TSBs from QSOL 
            //since SIEBEL don't provide TSBs //i.e. take URL from QSOL and add to SIEBEL campaigns & finally prepare SIEBEL list 
            //build logic here

            list<CSS_CampTsbTrp__c> lstSBLCAM;
            list<CSS_CampTsbTrp__c> lstSBLTRP;
            list<CSS_CampTsbTrp__c> lstSBLATC;

            list<CSS_CampTsbTrp__c> finallstSBLCAM; 
            list<CSS_CampTsbTrp__c> finallstSBLTRP; 
            list<CSS_CampTsbTrp__c> finallstSBLATC; 

            if(outputRes!=null && outputRes.DataArea != null){
                lstSBLCAM = new list<CSS_CampTsbTrp__c>(); 
                lstSBLTRP = new list<CSS_CampTsbTrp__c>();
                lstSBLATC = new list<CSS_CampTsbTrp__c>();
                finallstSBLCAM = new list<CSS_CampTsbTrp__c>();
                finallstSBLTRP = new list<CSS_CampTsbTrp__c>();
                finallstSBLATC = new list<CSS_CampTsbTrp__c>(); 

                CSS_CampTsbTrp__c campaignComp;
                for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){

                    //Here check Siebel Campaigns are meeting required criteria
                    //if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') ) //temperarily commeted
                    if(det.Status != 'Approved' )
                        continue;

                    campaignComp = new CSS_CampTsbTrp__c();
                    if(det.CampaignType == 'Campaign'){                        
                        campaignComp.Name = 'CAM' ;
                        campaignComp.Type__c = 'CAM' ;
                        campaignComp.Job_Order__c = null; //wId
                        campaignComp.ESN__c = esn;
                        system.debug('det.CampaignNumber**'+det.CampaignNumber);
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLCAM.add(campaignComp);
                    }else if(det.CampaignType == 'TRP'){
                        campaignComp.Name = 'TRP' ;
                        campaignComp.Type__c = 'TRP' ;
                        campaignComp.Job_Order__c = null; //wId
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLTRP.add(campaignComp);
                    }else if(det.CampaignType == 'ATC'){
                        campaignComp.Name = 'ATC' ;
                        campaignComp.Type__c = 'ATC' ;
                        campaignComp.Job_Order__c = null; //wId;
                        campaignComp.ESN__c = esn;
                        campaignComp.Doc_Num__c = det.CampaignNumber;
                        campaignComp.Doc_Title__c = det.CampaignDesc;
                        campaignComp.Cu_Language__c = qsolLanguage;
                        lstSBLATC.add(campaignComp);
                    }
                }
                System.debug('lstSBLCAM>>>:'+lstSBLCAM);
                System.debug('lstSBLTRP>>>:'+lstSBLTRP);
                System.debug('lstSBLATC>>>:'+lstSBLATC);
            }

            //compare SIEBEL & QSOL campaigns to get URLs
            //System.debug('Example After 3 chars>>:'+str.substring(3,str.length()));
            if(lstSBLCAM != null && lstSBLCAM.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLCAM){
                    system.debug('SBLREC*'+SblCampRec);
                    String tempAccCode;
                    if(campNumAccCodeMap != null){
                        tempAccCode = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                    }
                    system.debug('tempAccCode'+tempAccCode);
                    if(tempAccCode !=null && tempAccCode !=''){
                        if(lstCAM != null && lstCAM.size()>0){
                            for(CSS_CampTsbTrp__c campRec: lstCAM){
                                system.debug('SblCampRec.DocNum2>>:'+SblCampRec.Doc_Num__c);
                                system.debug('QSOL campRec.DocNum2>>:'+campRec.Doc_Num__c);
                                system.debug('QSOL substing campRec.DocNum>>:'+campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()));
                                if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1){
                                    if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                        system.debug('Inside###');
                                        system.debug('campRec.URL__c###'+campRec.URL__c);
                                        SblCampRec.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }
                            }
                        }
                        finallstSBLCAM.add(SblCampRec);
                    }
                    system.debug('finallstSBLCAM:'+finallstSBLCAM);
                }
            }
            
            system.debug('lstSBLTRP**'+lstSBLTRP);
            system.debug('lstSBLTRP**'+lstTRP);
            if(lstSBLTRP != null && lstSBLTRP.size()>0){
                system.debug('Inside If***');
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLTRP){
                    system.debug('Inside for***');
                        system.debug('Inside If2***');
                        string tempAccode1;
                        if(campNumAccCodeMap!=null){
                            tempAccode1 = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                        }
                        system.debug('tempAccode1**'+tempAccode1);
                        if(tempAccode1 !=null && tempAccode1 !=''){
                            if(lstTRP != null && lstTRP.size()>0){
                                for(CSS_CampTsbTrp__c campRec: lstTRP){
                                    system.debug('Inside for2***');
                                    if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>1)
                                        //system.debug('campRec.DocNum*'+campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()));
                                        //system.debug('campRec.DocNum2*'+campRec.Doc_Num__c);
                                        //system.debug('SblCampRec.DocNum2*'+SblCampRec.Doc_Num__c);
                                        if(campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                            SblCampRec.URL__c = campRec.URL__c;
                                            break;
                                        }
                                }
                        }
                            finallstSBLTRP.add(SblCampRec);
                        }  
                        system.debug('finallstSBLTRP:'+finallstSBLTRP);
                }
            }
            
            if(lstSBLATC != null && lstSBLATC.size()>0){
                for(CSS_CampTsbTrp__c SblCampRec: lstSBLATC){
                        string tempAcccode2;
                        if(campNumAccCodeMap!=null){
                            tempAcccode2 = campNumAccCodeMap.get(SblCampRec.Doc_Num__c);
                        }
                        if(tempAcccode2 !=null && tempAcccode2!=''){
                            if(lstATC != null && lstATC.size()>0){
                                for(CSS_CampTsbTrp__c campRec: lstATC){
                                    if(campRec.Doc_Num__c !=null && campRec.Doc_Num__c.length()>3)
                                        if(campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) == SblCampRec.Doc_Num__c){
                                            SblCampRec.URL__c = campRec.URL__c;
                                            break;
                                        }
                                }
                            }
                            finallstSBLATC.add(SblCampRec);
                        }
system.debug('finallstSBLATC:'+finallstSBLTRP);
                }
            }

            //adding final lists
            campaignsList = new List<List<CSS_CampTsbTrp__c>>();
            System.debug('new campaignsList>>>:'+campaignsList);
            if(finallstSBLCAM !=null && finallstSBLCAM.size()>=0)
                campaignsList.add(finallstSBLCAM);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(lstTSB !=null && lstTSB.size()>=0)
                campaignsList.add(lstTSB);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLTRP !=null && finallstSBLTRP.size()>=0)
                campaignsList.add(finallstSBLTRP);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());
            if(finallstSBLATC !=null && finallstSBLATC.size()>=0)
                campaignsList.add(finallstSBLATC);
            else
                campaignsList.add(new List<CSS_CampTsbTrp__c>());

            String res;
            if(resWrapper.response==null){
               res='Error';
               //Insert Error Log
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  resWrapper.request.getBody();
                intEngError.Response_Body__c = resWrapper.response.getBody();
                intEngError.Service_Name__c = 'GetCampaign';
                intEngError.Source__c = 'SIEBEL';
                insert intEngError;
            }            
            else
                res='Success';

            List<CSS_CampTsbTrp__c> lstFAError;
            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
            ctt1.Name = 'FAError' ;
            ctt1.Type__c = 'FAError' ;
            ctt1.Job_Order__c = null; //wId;
            ctt1.ESN__c = esn;
            ctt1.Doc_Num__c = res;
            lstFARes .add(ctt1);
            campaignsList.add(lstFARes);

            System.debug('final campaignsList>>>:'+campaignsList);
            system.debug('res123*' + res); 
        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - getCampaignsForUT Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return campaignsList;
    }


    public static Map<string,String> getCertificationStatus(String serviceModelName, date failureDate, String Accnt, Boolean wrCertFlag, Boolean productCertification, String wrTrainingStatus, date certEndDate){
        List<Account> lstAccount ;
        List<CSS_Accreditation__c> lstAccreditation;
        Map<String,String> accFlags = new Map<String,String>();
        system.debug('***inside getCertificationStatus****' + serviceModelName);
        system.debug('Accnt'+Accnt);
        system.debug('productCertification'+productCertification);
        try{
            //Product Certification
            if(productCertification == false){
                accFlags.put('certStatus', 'NotAppble');
            }else{
                if(serviceModelName != ''){
                    if(Accnt != null && Accnt != ''){
                        lstAccreditation = [SELECT id,Certification_Status__c,Service_Model_Name__c,StartDate__c,EndDate__c
                                            FROM CSS_Accreditation__c
                                            WHERE Account__c =: Accnt and Service_Model_Name__c =: serviceModelName];

                        if(lstAccreditation != null && lstAccreditation.size() > 0){
                            for(CSS_Accreditation__c accred : lstAccreditation){
                                if(failureDate >= accred.StartDate__c && failureDate <= accred.EndDate__c){
                                    accFlags.put('certStatus', 'Certified');
                                    break;
                                }else{
                                    accFlags.put('certStatus', 'NotCert');
                                }
                            }
                        }
                        //Added Else condition as part of story 190097
                        else{
                            accFlags.put('certStatus', 'NotCert');
                        }
                    }else{
                        //first fetch the user location
                        user usr=css_utility.getUserAttributes(Userinfo.getUserId());
                        if (usr.User_Location__c !=null) {
                            lstAccount = [SELECT id,WR_Certfication_Flag__c FROM Account WHERE Location__c = : usr.User_Location__c limit 1];

                            if(!lstAccount.isEmpty()){
                                lstAccreditation = [SELECT id,Certification_Status__c,Service_Model_Name__c
                                                    FROM CSS_Accreditation__c
                                                    WHERE Account__c IN : lstAccount and Service_Model_Name__c =: serviceModelName];

                                if(lstAccreditation != null && lstAccreditation.size() > 0){
                                    for(CSS_Accreditation__c accred : lstAccreditation){
                                        if(failureDate >= accred.StartDate__c && failureDate <= accred.EndDate__c){
                                            accFlags.put('certStatus', 'Certified');
                                            break;
                                        }else{
                                            accFlags.put('certStatus', 'NotCert');
                                        }                    
                                    }
                                }
                                //Added Else condition as part of story 190097
                                else{
                                    accFlags.put('certStatus', 'NotCert');
                                }
                            }
                        }
                    }
                    system.debug('accFlags>>End>>' + accFlags);
                } 
            }
            //Warranty Authorization
            if(wrCertFlag == false){
                accFlags.put('warrCertFlag', 'Not Applicable');
            }else{
                if(wrTrainingStatus != null && wrTrainingStatus != '' && wrTrainingStatus != 'R'){
                    accFlags.put('warrCertFlag', 'Certified');
                }
                else{
                    date tempDate = certEndDate + 180;
                    if(failureDate > tempDate){
                        accFlags.put('warrCertFlag', 'Not Certified');
                    }
                    else{
                        accFlags.put('warrCertFlag', 'Certified');
                    }
                }
            }
        }
        catch(exception e){

        }
        return accFlags;
    }

    public static CSS_WPR_SBL_ApplicationResJSON getApplicationCodesWrapper() {
        CSS_WPR_SBL_ApplicationResJSON resJSON;
        try {

            CSS_JobEventTemporary__c[] applicationCodes = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'ApplicationCodes'];
            system.debug('applicationCodes>>>'+applicationCodes);
            string jsonResponse = applicationCodes[0].Reason__c;

            //jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resJSON = (CSS_WPR_SBL_ApplicationResJSON)JSON.deserialize(jsonResponse ,CSS_WPR_SBL_ApplicationResJSON.class);

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - getApplicationCodes Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return resJSON;
    }

    public static List<SelectOption> getMake(String sEngineFamilyCode, String filterApplication, String qsol_Engine_Family_Code) {
        List<SelectOption> makeList = new List<SelectOption>();
        List<AggregateResult> lmake = new List<AggregateResult>();
        try {
            String recordTypeIdSRT = [Select Id, Name from RecordType where Name = 'SRTData' limit 1].Id;
            system.debug('recordTypeIdSRT-->'+recordTypeIdSRT);
            //added Status__c = \'ACTIVE\' for the defect 135113 by Venkat 
            string strMKQuery='Select Make__c, count(UniqueKey__c) From CSS_Make_Model_Access__c where Status__c = \'ACTIVE\' and RecordTypeId=\''+recordTypeIdSRT+'\' ';
            string engFamilyCode;
            system.debug('in getMake filterApplication>>>>:'+filterApplication+' sEngineFamilyCode>>:'+sEngineFamilyCode);

            if (sEngineFamilyCode!=null){
                engFamilyCode=sEngineFamilyCode;
            }else{
                engFamilyCode=qsol_Engine_Family_Code;
            }
            system.debug('engFamilyCode>>>:'+engFamilyCode+' filterApplication>>>:'+filterApplication);

            if(engFamilyCode!=null && engFamilyCode!=''){
                strMKQuery=strMKQuery+ 'AND EngineFamilyCode__c=\''+ engFamilyCode+'\' ';
            }

            if(filterApplication != null && filterApplication !='' && filterApplication.contains('AUTOMOTIVE')){
                strMKQuery=strMKQuery+ 'AND ApplicationCategory__c in (\'A\', \'B\') ';
            }else  if(filterApplication != null && filterApplication !='' && filterApplication.contains('WORLDWIDE OFF-HIGHWAY')){
                strMKQuery=strMKQuery+ 'AND ApplicationCategory__c in (\'B\', \'I\') ';
            }

            strMKQuery=strMKQuery+ 'group by Make__c Order By Make__c asc LIMIT 999';
            system.debug('strMKQuery>>>>:'+strMKQuery);
            lmake=Database.query(strMKQuery);

            makeList = new List<SelectOption>();
            makeList.add(new SelectOption('','----None----'));
            for(AggregateResult mk: lmake)
            {  
                if(mk.get('Make__c')!=null && mk.get('Make__c')!='')
                    makeList.add(new SelectOption((string)mk.get('Make__c'), (string)mk.get('Make__c')));
            }
            /*if(mainContr.workJob.PSN_Not_Available__c == true){
filterMake = 'UNLISTED';
mainContr.workJob.Make__c = filterMake;  
//changes for story 86422 end
} */
        }
        catch(exception e)
        {
            system.debug('Catch Make exeption:'+ e.getLineNumber() + ' ' + e.getMessage());

        }
        return makeList;
    }

    public static List<SelectOption> getModel(String filterMake, String sEngineFamilyCode, String filterApplication, String qsol_Engine_Family_Code) {    
        System.debug('in getModel method...');
        List<SelectOption> modelList = new List<SelectOption>();
        List<CSS_Make_Model_Access__c> lmodel = new List<CSS_Make_Model_Access__c>();
        string engFamilyCode;
        try {
            String recordTypeIdSRT = [Select Id, Name from RecordType where Name = 'SRTData' limit 1].Id;
            //added Status__c = \'ACTIVE\' for the defect 135113 by venkat
            string strQuery='Select id,Model__c  From CSS_Make_Model_Access__c where Status__c = \'ACTIVE\' and RecordTypeId=\''+recordTypeIdSRT+'\' AND Make__c=\''+ filterMake+'\' ';
            if (sEngineFamilyCode!=null ){
                engFamilyCode=sEngineFamilyCode;
            }else{
                engFamilyCode=qsol_Engine_Family_Code;
            }
            if(engFamilyCode!=null && engFamilyCode!=''){
                strQuery=strQuery+ ' AND EngineFamilyCode__c=\''+engFamilyCode+'\' ';
            }

            if(filterApplication != null && filterApplication !='' && filterApplication.contains('AUTOMOTIVE')){
                strQuery=strQuery+ 'AND ApplicationCategory__c in (\'A\', \'B\') ';
            }else if(filterApplication != null && filterApplication !='' && filterApplication.contains('WORLDWIDE OFF-HIGHWAY')){
                strQuery=strQuery+ 'AND ApplicationCategory__c in (\'B\', \'I\') ';
            }
            strQuery=strQuery+ ' Order By Model__c asc LIMIT 999';

            system.debug('Model strQuery>>>>:'+strQuery);
            lmodel=Database.query(strQuery);
            system.debug('lmodel>>>:'+lmodel);
            modelList.add(new SelectOption('','----None----'));
            for(CSS_Make_Model_Access__c temp1: lmodel)
            {
                modelList.add(new SelectOption(temp1.Model__c,temp1.Model__c));
                //system.debug('Model strQuery'+ModelList);
            }
            //changes for story 86422 Ekta
            /* if(mainContr.workJob.PSN_Not_Available__c == true){
filterModel ='ALL';
workjob.Model__c=filterModel; 
//changes for story 86422 end
}*/
        }
        catch(exception e)
        { 
            system.debug('in catch Model exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return modelList;
    }

    public static List<SelectOption> getUnitType(Id wid, String creator_Location) {
        List<SelectOption> unitTypeList; 
        try {
            string strLoc;
            system.debug('***wid***'+wid);
            system.debug('***mainContr.workJob.Id***'+wid);
            if (wid == null){
                Id userId = UserInfo.getUserId();
                User usr = css_utility.getUserAttributes(userId);
                strLoc = usr.User_Location__c;  
                system.debug('strLoc***'+strLoc);
            }else{
                strLoc = creator_Location;
                system.debug('strLoc--'+strLoc);
            }
            CSS_JobEventTemporary__c[] lUnitType;
            system.debug('lUnitType***'+lUnitType);
            lUnitType=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='UnitTypes' and Key__c=:strLoc];
            system.debug('After+lUnitType***'+lUnitType);
            map<string, object> mpUnitType=(map<string, object>)JSON.deserializeUntyped(lUnitType[0].Reason__c);
            system.debug('Rajesh+mpUnitType-->'+mpUnitType); 

            unitTypeList = new List<SelectOption>();
            unitTypeList.add(new SelectOption('','----None----'));

            for(string ut: mpUnitType.keyset()){
                //system.debug('ss'+ut+ mpUnitType.get(ut));
                unitTypeList.add(new SelectOption(ut, (string)mpUnitType.get(ut)));
            }

            unitTypeList.sort();
        }
        catch(exception e)
        {}
        return unitTypeList;
    }

    public static List<SelectOption> getSubType(Id wid, String creator_Location) {
        List<SelectOption> subTypeList; 

        try {
            string strLoc;
            if (wid == null){
                Id userId = UserInfo.getUserId();
                User usr = css_utility.getUserAttributes(userId);
                strLoc = usr.User_Location__c;
            }else 
            {
                strLoc = creator_Location;
            }

            system.debug('lSubType Loc-->'+strLoc);
            CSS_JobEventTemporary__c[] lSubType;
            lSubType=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='SubType' and Key__c=:strLoc];

            map<string, object> mpSubType=(map<string, object>)JSON.deserializeUntyped(lSubType[0].Reason__c);
            system.debug('mpSubType-->'+mpSubType); 

            subTypeList = new List<SelectOption>();
            //SubTypeList.add(new SelectOption('','----None----'));
            String defaultValue;
            for(string st: mpSubType.keyset()){
                //system.debug('st'+st+ mpSubType.get(st));
                subTypeList.add(new SelectOption(st, st + ' - ' + (string)mpSubType.get(st)));
                defaultValue = st = ' - ' + (string)mpSubType.get(st);
                /*if(defaultValue == 'IS'){
mainContr.filterSubType = defaultValue;
}*/

            }
            system.debug('inside mpSubType-->' + subTypeList);
            subTypeList.sort();
        }
        catch(exception e)
        {
            system.debug('Sub Type error msg'+ e.getMessage());

        }
        return subTypeList;
    }

    public static String FormatDate(Date d){
        String FormattedDate;
        try{
            Integer Month = d.month();
            String strMon = '';
            if(Month == 1)
                strMon = 'JAN';
            else if(Month == 2)
                strMon = 'FEB';
            else if(Month == 3)
                strMon = 'MAR';
            else if(Month == 4)
                strMon = 'APR';
            else if(Month == 5)
                strMon = 'MAY';
            else if(Month == 6)
                strMon = 'JUN';
            else if(Month == 7)
                strMon = 'JUL';
            else if(Month == 8)
                strMon = 'AUG';
            else if(Month == 9)
                strMon = 'SEP';
            else if(Month == 10)
                strMon = 'OCT';
            else if(Month == 11)
                strMon = 'NOV';
            else 
                strMon = 'DEC';
            system.debug('Month**'+strMon);
            FormattedDate = d.day() + '-' + strMon + '-' + d.year();
        }catch(exception e){ 
            system.debug('in catch DateModel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return FormattedDate;
    }

    public static Date parseQSOLDate(String myDate) {
        Date d = null;
        try{
            String[] myDateOnly = myDate.split(' ');
            String sMonth = myDateOnly[1];
            String sMM='0';
            if (sMonth == 'Jan') { sMM = '1' ;}
            else if (sMonth == 'Feb') { sMM = '2' ;}
            else if (sMonth == 'Mar') { sMM = '3' ;}
            else if (sMonth == 'Apr') { sMM = '4' ;}
            else if (sMonth == 'May') { sMM = '5' ;}
            else if (sMonth == 'Jun') { sMM = '6' ;}
            else if (sMonth == 'Jul') { sMM = '7' ;}
            else if (sMonth == 'Aug') { sMM = '8' ;}
            else if (sMonth == 'Sep') { sMM = '9' ;}
            else if (sMonth == 'Oct') { sMM = '10' ;}
            else if (sMonth == 'Nov') { sMM = '11' ;}
            else { sMM = '12' ;}

            Integer myIntDate = integer.valueOf(myDateOnly[0]);
            Integer myIntMonth = integer.valueOf(sMM);
            Integer myIntYear = integer.valueOf(myDateOnly[2]);
            d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        }catch(exception e){ 
            system.debug('in catch Model exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return d;
    }


    public static CSS_Job_Order__c mapSPData(CSS_Job_Order__c workJob, CSS_Job_Order__c worecord) {
        try {
            worecord.CSS_Channel_Code__c = workJob.CSS_Channel_Code__c;
            worecord.CSS_Channel_Of_Distribution__c = workJob.CSS_Channel_Of_Distribution__c;
            worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
            worecord.CSS_Field_Service_Labor_Rate__c = workJob.CSS_Field_Service_Labor_Rate__c;
            worecord.Territory_Class__c = workJob.Territory_Class__c;
            worecord.Territory_Class_Name__c = workJob.Territory_Class_Name__c;
            worecord.SP_AccountStatus__c = workJob.SP_AccountStatus__c;  
            worecord.SP_BusinessUnit__c = workJob.SP_BusinessUnit__c;
            worecord.SP_CampaignTRP__c = workJob.SP_CampaignTRP__c;
            worecord.SP_ClaimAllowedDays__c =workJob.SP_ClaimAllowedDays__c;
            worecord.SP_CMISPExpirationDate__c = workJob.SP_CMISPExpirationDate__c;
            worecord.SP_CommunicationMethod__c = workJob.SP_CommunicationMethod__c;
            worecord.SP_CommunicationOccurrence__c = workJob.SP_CommunicationOccurrence__c;
            worecord.SP_CostEffectiveExclusion__c = workJob.SP_CostEffectiveExclusion__c;
            worecord.SP_CutOffClaimAmt__c = workJob.SP_CutOffClaimAmt__c;
            worecord.SP_DisableWebAccessFlag__c = workJob.SP_DisableWebAccessFlag__c;
            worecord.SP_DistributorHQCode__c = workJob.SP_DistributorHQCode__c;
            worecord.SP_DistributorHQName__c = workJob.SP_DistributorHQName__c;
            worecord.SP_DSID__c = workJob.SP_DSID__c;
            worecord.SP_DTNAFlag__c = workJob.SP_DTNAFlag__c;
            worecord.SP_FreezeSubmitButton__c = workJob.SP_FreezeSubmitButton__c;
            worecord.SP_GroupName__c = workJob.SP_GroupName__c;
            worecord.SP_LTAFlag__c = workJob.SP_LTAFlag__c;
            worecord.SP_MaxClaimAmt__c = workJob.SP_MaxClaimAmt__c;
            worecord.SP_NewOEM__c = workJob.SP_NewOEM__c;
            worecord.SP_OutfileAllClaims__c = workJob.SP_OutfileAllClaims__c;
            worecord.SP_PACCAR__c =workJob.SP_PACCAR__c;
            worecord.SP_PMUSplitPayment__c = workJob.SP_PMUSplitPayment__c;
            worecord.SP_Policy__c =workJob.SP_Policy__c; 
            worecord.SP_PrimaryOEMCode__c =workJob.SP_PrimaryOEMCode__c;
            worecord.SP_PrimaryOEMName__c=workJob.SP_PrimaryOEMName__c;
            worecord.SP_ProductCertification__c = workJob.SP_ProductCertification__c; 
            worecord.SP_PromotionId__c = workJob.SP_PromotionId__c; 
            worecord.SP_PSBUProductCertification__c = workJob.SP_PSBUProductCertification__c; 
            worecord.SP_Region__c = workJob.SP_Region__c; 
            worecord.SP_RepairLevel__c = workJob.SP_RepairLevel__c; 
            worecord.SP_SCMDeductiblePercentage__c =workJob.SP_SCMDeductiblePercentage__c; 
            worecord.SP_SCMDollarAmt__c =workJob.SP_SCMDollarAmt__c; 
            worecord.SP_State__c = workJob.SP_State__c; 
            worecord.SP_TechActualHoursRequired__c = workJob.SP_TechActualHoursRequired__c; 
            worecord.SP_ViewDollarAmount__c = workJob.SP_ViewDollarAmount__c; 
            worecord.SP_WarrantyCertificationEndDate__c = workJob.SP_WarrantyCertificationEndDate__c; 
            worecord.SP_WarrantyEmail__c = workJob.SP_WarrantyEmail__c; 
            worecord.SP_WarrantyFax__c = workJob.SP_WarrantyFax__c; 
            worecord.SP_WarrantyTrainingCertification__c = workJob.SP_WarrantyTrainingCertification__c; 
            worecord.SP_WarrantyTrainingStatus__c = workJob.SP_WarrantyTrainingStatus__c; 
            worecord.SP_WWSPSSPFlag__c = workJob.SP_WWSPSSPFlag__c;
            worecord.SP_Country__c = workJob.SP_Country__c;
            return worecord;
        } catch(exception e){ 
            system.debug('mapSPData exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
            return null;
        }
    }

    public static CG_cancelServiceJobWrapper cancel(CSS_Job_Order__c workJob, CSS_Job_Order__c worecord){        
        CG_OP_OAGWrapper oagWrapperObj = new CG_OP_OAGWrapper(); 
        CG_cancelServiceJobWrapper cancelSJWrapperObj = new CG_cancelServiceJobWrapper();

        try{
            if(workJob.Shop_Work_Order__c == null){
                system.debug('****insidenoSWO**');
                worecord.id = workJob.Id;
                worecord.Status__c = 'Canceled';
                //update worecord;
                cancelSJWrapperObj.errorFlag = false;
                cancelSJWrapperObj.serviceJob = worecord;
            }
            else{
                system.debug('insideelseSWO');
                if(workJob.name !=null && workJob.Creator_Location__c != null && workJob.Customer_Code__c != null && workJob.Shop_Work_Order__c !=null){
                    oagWrapperObj = CG_BL_BMS.DeleteBMSJob(workJob.name,workJob.Creator_Location__c,workJob.Customer_Code__c,'WO',workJob.Shop_Work_Order__c,'Cancelled');                
                }
                system.debug('responsebody*****'+oagWrapperObj);
                if(oagWrapperObj.response !=null && oagWrapperObj.exceptionFlag == false){
                    system.debug('responsebody*****'+oagWrapperObj.response.getbody());
                    system.debug('insideelseNoSWO***exceptionfalse');
                    if(!oagWrapperObj.response.getbody().contains('"Status":"ERROR"') && !oagWrapperObj.response.getbody().contains('Error')){
                        system.debug('insideelseNoSWO***notError');
                        worecord.id = workJob.Id;
                        worecord.Status__c = 'Canceled';
                        //update worecord;
                        cancelSJWrapperObj.errorFlag = false;
                        cancelSJWrapperObj.serviceJob = worecord;
                    }
                    else{
                        system.debug('insideelseNoSWO***Error');
                        cancelSJWrapperObj.serviceJob = worecord;
                        cancelSJWrapperObj.errorFlag = true;
                        cancelSJWrapperObj.errorMessage = 'Job Closure Failed! Try again later or contact Guidanz@cummins.com';
                    }
                }
                else if(oagWrapperObj.response !=null && oagWrapperObj.exceptionFlag == true){
                    system.debug('insideelseNoSWO***exceptiontrue');
                    cancelSJWrapperObj.serviceJob = worecord;
                    cancelSJWrapperObj.errorFlag = true;
                    cancelSJWrapperObj.errorMessage = 'Job Closure Failed! Try again later or contact Guidanz@cummins.com';                            
                }
                else if(oagWrapperObj.response ==null){
                    system.debug('insideelseNoSWO***exceptiontrue');
                    cancelSJWrapperObj.serviceJob = worecord;
                    //cancelSJWrapperObj.errorFlag = true; Commented by Rajesh N on 01-23-2019 to fix the defect 169428
                    cancelSJWrapperObj.errorFlag = false;
                    cancelSJWrapperObj.errorMessage = 'Job Closure Failed! Try again later or contact Guidanz@cummins.com';                            
                }

            }
            return cancelSJWrapperObj;
        }
        catch(exception e){ 
            system.debug('CG_BL_Intakecancel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
            cancelSJWrapperObj.serviceJob = worecord;
            cancelSJWrapperObj.errorFlag = true;
            cancelSJWrapperObj.errorMessage = 'Job Closure Failed! Try again later or contact Guidanz@cummins.com';
            return cancelSJWrapperObj;
        }

    }

    public static CG_cancelServiceJobWrapper closeServiceJob(CSS_Job_Order__c workJob){        
        CG_OP_OAGWrapper oagWrapperObj = new CG_OP_OAGWrapper(); 
        CG_cancelServiceJobWrapper cancelSJWrapperObj = new CG_cancelServiceJobWrapper();

        try{
            if(workJob.Shop_Work_Order__c == null){
                //update worecord;
                cancelSJWrapperObj.errorFlag = false;
                cancelSJWrapperObj.serviceJob = workJob;
            }
            else{
                system.debug('insideelseSWO');
                if(workJob.name !=null && workJob.Creator_Location__c != null && workJob.Customer_Code__c != null && workJob.Shop_Work_Order__c !=null){
                    oagWrapperObj = CG_BL_BMS.DeleteBMSJob(workJob.name,workJob.Creator_Location__c,workJob.Customer_Code__c,'WO',workJob.Shop_Work_Order__c,'Closed');                
                }
                //system.debug('responsebody*****'+oagWrapperObj.response.getbody());
                if(oagWrapperObj !=null && oagWrapperObj.exceptionFlag == false){
                    system.debug('responsebody*****'+oagWrapperObj.response.getbody());
                    system.debug('insideelseNoSWO***exceptionfalse');
                    if(!oagWrapperObj.response.getbody().contains('"Status":"ERROR"') && !oagWrapperObj.response.getbody().contains('Error')){
                        system.debug('insideelseNoSWO***notError');
                        //update worecord;
                        cancelSJWrapperObj.errorFlag = false;
                        cancelSJWrapperObj.serviceJob = workJob;
                    }
                    else{
                        system.debug('insideelseNoSWO***Error');
                        cancelSJWrapperObj.serviceJob = workJob;
                        cancelSJWrapperObj.errorFlag = true;
                        cancelSJWrapperObj.errorMessage = 'Job Closure Failed!  Try again later or contact Guidanz@cummins.com';
                    }
                }
                else if(oagWrapperObj !=null && oagWrapperObj.exceptionFlag == true){
                    system.debug('insideelseNoSWO***exceptiontrue');
                    cancelSJWrapperObj.serviceJob = workJob;
                    cancelSJWrapperObj.errorFlag = true;
                    cancelSJWrapperObj.errorMessage = 'Job Closure Failed!  Try again later or contact Guidanz@cummins.com';                            
                }

            }
            return cancelSJWrapperObj;
        }
        catch(exception e){ 
            system.debug('CG_BL_Intakecancel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
            return null;
        }

    }

    //////////////////////////////////////////////////// WEB SERVICES \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\       
    //Fetching BMS Customer Details.
    public static CG_OP_OAGWrapper fetchBMSCustomerDetails(String custName,String custCode,String Location) {
        return CG_BL_BMS.fetchBMSCustomerDetails(custName, custCode, Location);
    }

    //Create BMS Account.
    public static CG_OP_OAGWrapper createBMSAccount(String custName, String custAddr1, String custAddr2, String custAddr3, String AreaCode, String Phone, String city, String state, String postCode, String postalcodesuffix, String cusContact, String countryCd, String lang, String application, string location) {
        return CG_BL_BMS.createBMSAccount(custName, custAddr1, custAddr2, custAddr3, AreaCode, Phone, city, state, postCode, postalcodesuffix, cusContact, countryCd, lang, application, location);
    }

    //Fetching SP data.
    public static CSS_Job_Order__c fetchSPData(CSS_Job_Order__c workJob, string spCode, string serviceModel, Date failureDate, string JobId) {
        CSS_FN_SIEBEL CSS = new CSS_FN_SIEBEL();
        return CSS.getServiceProviderDataIntake(workJob, spCode, serviceModel, failureDate, JobId);
    }

    //Fetching BMS Customer Credit Messaages
    public static void getBMSCustomerCreditMsgs(String customerNo, String location) {
        try{
            //customerNo =  '67456';
            //location = '03520-02331';
            CG_OP_OAGWrapper resWrapper = CG_SL_BMS.getBMSCustomerCreditMsgs(customerNo, location);

            //insert logic below

        }catch(exception e){
            system.debug('EXCEPTION of CG_BL_Intake - getBMSCustomerCreditMsgs Method ErrorMessage>>>:'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
        }
    }

    //////////////////////////////////////////////////// WEB SERVICES \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\   

    // adding as the above method was overridden and thus casued compilation error for css_tnd_job class
    //method to get Certification location status --pass sServiceModel variable when u call this method
    public static Map<string,String> getCertificationStatus(String serviceModelName){
        List<Account> lstAccount ;
        List<CSS_Accreditation__c> lstAccreditation;
        //String sCertStatus = '';
        Map<String,String> accFlags = new Map<String,String>();
        system.debug('***inside getCertificationStatus****' + serviceModelName);
        try{ if (serviceModelName != '') {

            //first fetch the user location
            user usr=css_utility.getUserAttributes(Userinfo.getUserId());
            system.debug('usr>>>**'+usr);
            //query the account object based on user location (assumed for now every location there is one account)
            if (usr.User_Location__c !=null) {
                lstAccount = [SELECT id,WR_Certfication_Flag__c FROM Account WHERE Location__c = : usr.User_Location__c limit 1];
                system.debug('lstAccount>>>**'+lstAccount);
                //get all CSS_Accreditation__c for all lstAccount
                if(!lstAccount.isEmpty()){
                    lstAccreditation = [SELECT id,Certification_Status__c,Service_Model_Name__c
                                        FROM CSS_Accreditation__c
                                        WHERE Account__c IN : lstAccount];
                }

                for(CSS_Accreditation__c accred : lstAccreditation){
                    if(accred.Service_Model_Name__c == serviceModelName){
                        //sCertStatus =  accred.Certification_Status__c;
                        accFlags.put('certStatus', accred.Certification_Status__c);
                        break;
                    }
                }
                if(!lstAccount.isEmpty()){
                    for(Account a:lstAccount){
                        accFlags.put('warrCertFlag', a.WR_Certfication_Flag__c);
                        break;
                    }
                }
            }
        } 
           }
        catch(exception e){

        }
        //return sCertStatus;
        return accFlags;
    } 

    /*
    * This method is used to get Asset data based on ESN
    */
    public static CSS_getEngineDataResponseJ2A GetEngineDataPlateQSOL(String ESN){
        system.debug('enter inside GetEngineDataPlateQSOL');
        /*CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
reqWrapper.serviceName = 'GetEngineDataPlateQSOLREST';
CG_OP_OAGWrapper RespDataPlate = new CG_OP_OAGWrapper();
CG_CL_GetEngineDataPlateRespWrapper rDataPlate = new CG_CL_GetEngineDataPlateRespWrapper();

RespDataPlate = CG_WS_QSOL.calloutGenericforQSOLREST(reqWrapper);
rDataPlate = (CG_CL_GetEngineDataPlateRespWrapper)JSON.deserializeStrict(RespDataPlate.response.getBody(), CG_CL_GetEngineDataPlateRespWrapper.class);
system.debug('rDataPlate>>>:'+rDataPlate);*/
        try{
            /*CG_OP_OAGWrapper resWrapper;
            CG_OP_GetEngineDataPlateRespWrapper rDataPlate = new CG_OP_GetEngineDataPlateRespWrapper();
            CG_OP_GetEngineDataPlateRespWrapper.Data Data = new CG_OP_GetEngineDataPlateRespWrapper.Data();

            /*string serviceName = 'GetEngineDataPlateQSOLREST';
            resWrapper = CG_SL_QSOL.callGetQsolService(ESN,serviceName,'','','','','','');
            system.debug('StatusCode**'+resWrapper.response.getStatusCode());
            system.debug('resWrapper.response.getBody() '+resWrapper.response.getBody());
            if(resWrapper.response.getStatusCode() == 200){
                rDataPlate = (CG_OP_GetEngineDataPlateRespWrapper)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_GetEngineDataPlateRespWrapper.class);
                return rDataPlate;}
            else {
                return null;}*/
            /* List<Asset> lstAsset = new List<Asset>();
                lstAsset = [Select id,SerialNumber,vin__c,Make_Model__c,Model__c,Service_Model__c,Build_Date__c,Warranty_Start_Date__c,Equipment_Configuration__c,Engine_Family_Code__c,Customer_Code__c,
                Critical_Part_List_Number__c,MoveX_Phone_Number__c,Unit_Number__c,Unit_Type__c from Asset where SerialNumber = :ESN];
                if(lstAsset != null && lstAsset.size()>0){
                    rDataPlate.engineSerialNumber = lstAsset[0].SerialNumber;
                    Data.vin = lstAsset[0].vin__c;
                    Data.marketingEngineModel = '';
                    Data.serviceEngineModel = lstAsset[0].Service_Model__c;
                    Data.epaModelName = '';
                    Data.engineBuildPlant = '';
                    Data.engineBuildDate = string.valueof(lstAsset[0].Build_Date__c);
                    Data.warrantyStartDate = string.valueof(lstAsset[0].Warranty_Start_Date__c);
                    Data.ecmCode = '';
                    Data.fuelPumpPartNumber = '';
                    Data.fuelPumpCalibration = '';
                    Data.marketingConfig = '';
                    Data.technicalConfig = lstAsset[0].Equipment_Configuration__c;
                    Data.cplNumber = lstAsset[0].Critical_Part_List_Number__c;
                    Data.customerNumber = '';
                    Data.shopOrder = '';
                    Data.businessUnit = '';
                    //rDataPlate.Data[0] = Data;
                }
            rDataPlate.Data= new list<CG_OP_GetEngineDataPlateRespWrapper.Data>();
            System.debug('rdata value 1' + rDataPlate);
            //System.debug('rdata value 2' + rDataPlate.Data[0] + ' -- '+ Data);
                rDataPlate.Data.add(Data);
                return rDataPlate; */
            CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A();
            CSS_getEngineDataResponseJ2A.DataArea Data = new CSS_getEngineDataResponseJ2A.DataArea();
            List<Asset> lstAsset = new List<Asset>();
            //Rajesh Narra added Type_PSN__c to the where clause as per the defect GSSC-681
            lstAsset = [Select id,SerialNumber,vin__c,Make_Model__c,Model__c,Service_Model__c,Build_Date__c,Warranty_Start_Date__c,Equipment_Configuration__c,Engine_Family_Code__c,Customer_Code__c,
                        Critical_Part_List_Number__c,MoveX_Phone_Number__c,Unit_Number__c,Unit_Type__c,Automotive_Application_Flag__c,
                        ETO_Conversion_Date__c,Marine_Application_Flag__c,Engine_Bill_To_Code__c,Equipment_Id__c,Customer_Name__c,Make__c,
                        Product_Application_Code__c,Access_Code__c,Product_Application_Description__c,No_Warranty__c,OEM_SP_Code__c,Engine_Family_Name__c,
                        Design_Phase_Code__c,Paccar_Flag__c,Ship_Date__c,ETO_Old_PSN__c from Asset where SerialNumber = :ESN and Type_PSN__c Like '%Engines%'];
           	system.debug('** Testing'+lstAsset.size()+'ESN Info'+ESN);
            if(lstAsset != null && lstAsset.size()>0){
                Data.AutomotiveAppFlag = lstAsset[0].Automotive_Application_Flag__c;
                Data.Model = lstAsset[0].Model__c;
                Data.Esn = lstAsset[0].SerialNumber;
                Data.EtoConversionDate = string.valueof(lstAsset[0].ETO_Conversion_Date__c);
                Data.MarineAppFlag = lstAsset[0].Marine_Application_Flag__c;
                Data.EngineBillToCode = lstAsset[0].Engine_Bill_To_Code__c;
                Data.EquipmentId = lstAsset[0].Equipment_Id__c;
                Data.CustomerName = lstAsset[0].Customer_Name__c;
                Data.BuildDate = string.valueof(lstAsset[0].Build_Date__c);
                Data.Manufacturer = lstAsset[0].Make__c; // Correct?
                Data.EngineFamilyCode = lstAsset[0].Engine_Family_Code__c;
                Data.WarrantyStartDate = string.valueof(lstAsset[0].Warranty_Start_Date__c);
                Data.ProdAppCode = lstAsset[0].Product_Application_Code__c;
                Data.ServiceModelName = lstAsset[0].Service_Model__c;
                Data.AccessCode = lstAsset[0].Access_Code__c;
                Data.ProdAppDesc = lstAsset[0].Product_Application_Description__c;
                Data.EngineAppDesc = ''; //No field available
                Data.vin = lstAsset[0].VIN__c;
                Data.EquipmentConfiguration = lstAsset[0].Equipment_Configuration__c;
                if(lstAsset[0].No_Warranty__c != null && lstAsset[0].No_Warranty__c == true)
                    Data.NoWarranty = 'true';
                else 
                    Data.NoWarranty = 'false';
                Data.CriticalPartsListNumber = lstAsset[0].Critical_Part_List_Number__c;
                Data.OEMSPCode = lstAsset[0].OEM_SP_Code__c;
                Data.DesignPhaseCode = lstAsset[0].Design_Phase_Code__c;
                Data.EquipmentConfiguration = lstAsset[0].Equipment_Configuration__c;
                if(lstAsset[0].Paccar_Flag__c != null && lstAsset[0].Paccar_Flag__c == true)
                    Data.PACCARFlag = 'true';
                else 
                    Data.PACCARFlag = 'false';
                //Data.PACCARFlag = lstAsset[0].Paccar_Flag__c;
                Data.EngineFamilyName = lstAsset[0].Engine_Family_Name__c;
                Data.ShipDate = string.valueof(lstAsset[0].Ship_Date__c);
                Data.ETOOldPSN = lstAsset[0].ETO_Old_PSN__c;
                Data.ETOOldESN = lstAsset[0].ETO_Old_PSN__c; //Correct?
                rDataPlate.DataArea=Data;
            }
            else {rDataPlate = null;}
            return rDataPlate;
        }catch(Exception e){
            system.debug('exception in intake '+e.getMessage()+''+e.getLineNumber());
            return null;
        }

    }

    /*
    * This method is used for calling QSOL REST service to get EndgineData from QSOL REST
    */
    public static CG_OP_GetEngineDataPlateRespWrapper GetEngineDataPlateQSOLREST(String ESN){
        try{
            CG_OP_GetEngineDataPlateRespWrapper rDataPlate = new CG_OP_GetEngineDataPlateRespWrapper();
            CG_OP_GetEngineDataPlateRespWrapper.Data Data = new CG_OP_GetEngineDataPlateRespWrapper.Data();
            CG_OP_OAGWrapper resWrapper = CG_SL_QSOL.callGetQsolService(ESN,'GetEngineDataPlateQSOLREST','','','','','','');
            system.debug('StatusCode**'+resWrapper.response.getStatusCode());
            system.debug('resWrapper.response.getBody() '+resWrapper.response.getBody());
            if(resWrapper.response.getStatusCode() == 200){
                rDataPlate = (CG_OP_GetEngineDataPlateRespWrapper)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_GetEngineDataPlateRespWrapper.class);
                return rDataPlate;
            }
            else {
                return null;
            }
        }catch(Exception e){
            system.debug('exception in GetEngineDataPlateQSOLREST of CG_BL_Intake '+e.getMessage()+''+e.getLineNumber());
            return null;
        }

    }

}