/**********************************************************************
Name:CSS_SRTAccessCheckListCL
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for getting/updating SRT details from
web service  in SRT chevron on Jobplan page.

======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR                    DATE                DETAIL                                 
1.0                                                     INITIAL DEVELOPMENT
2.0     - Rajesh Pasupuleti         02/15/2018          Added code as per NCIS story #84383 
3.0     - Miruthula Kanagaraj       04/17/2019          Added SRT fields & mapped to ECMFlag, PrivateFlag, Regions from response #179757
4.0     - Rajkumar BT               09/23/2019          Replaced getAccessSRT and SRTDetails services with getAllSRT as part of the story GSSC-18
*********************************************************************************************************************************/
public class CSS_SRTAccessCheckListCL {
    public String searchAcesscheklistvalue{get;set;}
    public String sHandleMsg{get;set;}
    public Boolean jobStatus{get;set;}
    public List<CSS_Job_Order__c> lstJob;
    public list<CSS_srt__c> lstDisplaySRT{get;set;}//Displays all the SRTs from WS
    public list<CSS_srt__c> lstDisplaySRT1{get;set;}//Added as part of GSSC-287
    public list<CSS_srt__c> lstSRT ;
    public List<CSS_JobEventTemporary__c> lstTempRec;
    public List<CSS_JobEventTemporary__c> lstOldRec; //Added as part of the story GSSC-18
    public String Wid;
    public String Sid;
    //RAJ-84383
    public String Compid;
    public String Typ;
    public String Quantity;
    public string pgName{get;set;}
    public string srtRecId{get;set;}
    public list<CSS_srt__c> lstSRTDupCheck ;
    public Boolean dupSRTFound{get;set;}
    public Boolean srtRecSelected{get;set;}
    public CSS_JobEventTemporary__c newResp; //Added as part of the story GSSC-18

    public Static Boolean serviceFailed{get;set;} //Added as part of the story GSSC-82

    public Static CSS_Integration_Error__c errorDetail{get;set;} //Added as part of the story GSSC-82

    //Constructor
    public CSS_SRTAccessCheckListCL(){
        try {
            errorDetail = new CSS_Integration_Error__c(); //Added as part of the story GSSC-82
            serviceFailed = false; //Added as part of the story GSSC-82
            system.debug('serviceFailed***'+serviceFailed);
            jobStatus=false;
            Wid=ApexPages.CurrentPage().getParameters().get('JobOrderId');
            Sid=ApexPages.CurrentPage().getParameters().get('solutionId');
            //RAJ-84383
            Compid=ApexPages.CurrentPage().getParameters().get('componentId');
            Typ=ApexPages.CurrentPage().getParameters().get('typ');
            pgName = ApexPages.CurrentPage().getParameters().get('pgName');
            //84383
            if (Typ== 'rep') {
                Typ = 'Repair Access';
            } else if(Typ== 'camp'){
                Typ = 'Field Action Access';
            }
            else{
                Typ = 'Diag Access';
            }
            lstDisplaySRT = new List<CSS_srt__c>();
            lstDisplaySRT1 = new List<CSS_srt__c>();
            system.debug('***typ***'+typ);

            String jsonResp; //Added as part of the story GSSC-18
            integer setSize; //Added as part of the story GSSC-18
            //if(Typ == 'Repair Access' || Typ == 'Diag Access'){  //Commented as part of the story GSSC-18
            if (Wid != '' && Wid != null && ((Sid != '' && Sid != null) || (Compid != '' && Compid != null))) {
                lstJob = [select id, Name, Equipment_ID__c, Qsol_Engine_Family_Code__c, Accesscode__c,
                          Service_Model__c, Status__c, Claim_No__c from css_job_order__c where id=: Wid LIMIT 1];
                system.debug('lstJob '+lstJob);
                if (lstJob.size() >0) {
                    //75670
                    if(lstJob[0].Status__c=='Closed' || lstJob[0].Status__c=='Canceled'){
                        jobStatus=true;
                    }
                    lstTempRec = [select id, Attribute1__c, Attribute2__c,
                                  Attribute3__c, Attribute4__c, Attribute5__c,
                                  Attribute6__c,Attribute7__c,Attribute8__c,
                                  Attribute9__c ,JobOrder__c,Service_Model_Name__c,Source__c,SRT_Access_Checklist__c, Reason__c
                                  from   CSS_JobEventTemporary__c
                                  where (Service_Model_Name__c =:lstJob[0].Service_Model__c 
                                         and attribute1__c=:lstJob[0].Qsol_Engine_Family_Code__c
                                         and attribute2__c=:lstJob[0].Equipment_ID__c
                                         and Source__c = 'SRT'
                                         and ExpireDateTime__c > :System.Now())
                                  and JobOrder__c = null]; //Removed "JobOrder__c =:Wid" WHERE clause as part of the story GSSC-18
                    system.debug('lstTempRec '+lstTempRec);
                    if(Typ == 'Repair Access' || Typ == 'Diag Access'){                    
                        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,step_id__c,
                                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                                  where Solution_Number__c = :Sid and Job_order__c=:Wid
                                  and Type__c = :Typ];
                    }
                    else if(Typ == 'Field Action Access'){
                        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c,Component_Id__c, Type__c,step_id__c,
                                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                                  where Component_Id__c =:Compid and Job_order__c=:Wid
                                  and Type__c = :Typ];
                    }

                    system.debug('Gyan** Values of lstTempRec:' + lstTempRec) ;
                    system.debug('Gyan******* Values of lstSRT:' + lstSRT) ;

                    if (lstTempRec.size() > 0) {//create a temporary SRT List using the temp records
                        sHandleMsg = 'TEMP';
                        system.debug('sHandleMsg1**'+sHandleMsg);
                        jsonResp = lstTempRec[0].Reason__c;  //Added as part of the story GSSC-18
                    } //Access Checklist Available in Temp Object
                    else { 
                        lstTempRec = new List<CSS_JobEventTemporary__c>();
                        if (lstJob[0].Equipment_ID__c == '' || lstJob[0].Equipment_ID__c == '' ||
                            lstJob[0].Service_Model__c == '' || lstJob[0].Service_Model__c == null ||
                            lstJob[0].Qsol_Engine_Family_Code__c == '' || lstJob[0].Qsol_Engine_Family_Code__c == null) {
                            // Displaying Nothing and Making No WebService Call.
                            sHandleMsg = 'Invalid Request';
                            system.debug('sHandleMsg2**'+sHandleMsg);
                        } else { //Make a WS call to get this Access Checklist
                            lstOldRec = new List<CSS_JobEventTemporary__c>();  //Added as part of the story GSSC-18
                            lstOldRec = [select id from CSS_JobEventTemporary__c where Service_Model_Name__c =:lstJob[0].Service_Model__c 
                                         and attribute1__c=:lstJob[0].Qsol_Engine_Family_Code__c
                                         and attribute2__c=:lstJob[0].Equipment_ID__c
                                         and Source__c = 'SRT' LIMIT 5000]; //Added as part of the story GSSC-18
                                         //Adding Limit 5000 for defect: GSSC-700.
                            //Commented below as part of the story GSSC-18
                            //lstTempRec = CSS_SRTAccessWebService.accessSRT(Sid,lstJob[0].Equipment_ID__c,lstJob[0].Service_Model__c,lstJob[0].Qsol_Engine_Family_Code__c);
                            //Added as part of the story GSSC-18 - START
                            CSS_getAllSRTResponseJ2A respRecs = CSS_WS_SRT.getAccessSRTs(Wid, lstJob[0].Name, lstJob[0].Service_Model__c, lstJob[0].Equipment_ID__c, lstJob[0].Qsol_Engine_Family_Code__c, lstJob[0].AccessCode__c, lstJob[0].Claim_No__c, 'Access');
                            System.debug('respRecs--->'+respRecs);
                            newResp = new CSS_JobEventTemporary__c();
                            newResp.attribute1__c = lstJob[0].Qsol_Engine_Family_Code__c;
                            newResp.attribute2__c = lstJob[0].Equipment_ID__c;
                            newResp.source__c = 'SRT';
                            newResp.ExpireDateTime__c = System.now() + 1;
                            newResp.Service_Model_Name__c = lstJob[0].Service_Model__c;
                            newResp.Reason__c = JSON.serialize(respRecs);
                            jsonResp = newResp.Reason__c;
                            //Added as part of the story GSSC-18 - END
                            if(newResp != null){ //Removed lstTempRec.size()>0 condition and added newResp != null condition as part of te story GSSC-18 
                                sHandleMsg = 'WEB';
                                system.debug('sHandleMsg3**'+sHandleMsg);
                            } 
                            else {
                                sHandleMsg = 'Invalid Request';
                                system.debug('sHandleMsg4**'+sHandleMsg);
                            }
                        }
                    } //Access Checklist obtained from WS
                    if (sHandleMsg == 'TEMP' || sHandleMsg == 'WEB') {
                        //Added as part of the story GSSC-18 - START
                        CSS_getAllSRTResponseJ2A respRecsNew =  (CSS_getAllSRTResponseJ2A)JSON.deserialize(jsonResp,CSS_getAllSRTResponseJ2A.class);
                        if (respRecsNew.DataArea != null )  {
                            System.debug('respRecsNew DA Size is>>'+respRecsNew.DataArea.size());
                            System.debug('respRecsNew DA is>>'+respRecsNew.DataArea);                
                            if (respRecsNew.DataArea.size() > 999){                
                                setSize = 999;                
                            }
                            else{
                                setSize = respRecsNew.DataArea.size();
                            }

                            for (integer i=0; i<setSize; i++){
                                CSS_srt__c recDiaRepSRT = new CSS_srt__c();
                                recDiaRepSRT.CSS_UniqueSRTValues__c = Sid + '-' + respRecsNew.DataArea[i].SRTNumber + '-' + Typ;
                                System.debug('SRT Unique Values --->'+ recDiaRepSRT.CSS_UniqueSRTValues__c );
                                recDiaRepSRT.SRT_Details__c = respRecsNew.DataArea[i].SRTNumber; 
                                recDiaRepSRT.Job_order__c = Wid;
                                if(Typ == 'Repair Access' || Typ == 'Diag Access'){
                                    recDiaRepSRT.Solution_Number__c = Sid;
                                }
                                else if(Typ == 'Field Action Access'){
                                    recDiaRepSRT.Component_Id__c = Compid;
                                }
                                recDiaRepSRT.Step_id__c = String.valueof(respRecsNew.DataArea[i].StepID);
                                recDiaRepSRT.SRT_Title__c = respRecsNew.DataArea[i].SRTTitle;
                                recDiaRepSRT.SRT_Type__c = respRecsNew.DataArea[i].SRTType;
                                //recDiaRepSRT.SRT_Category__c= respRecsNew.DataArea[i].SRTCategory ; //commented as part of defect 573
                                recDiaRepSRT.Access_Code_A__c =Double.valueof(respRecsNew.DataArea[i].ATime);
                                recDiaRepSRT.Access_Code_B__c =Double.valueof(respRecsNew.DataArea[i].BTime);
                                recDiaRepSRT.Access_Code_C__c =Double.valueof(respRecsNew.DataArea[i].CTime);
                                recDiaRepSRT.Access_Code_D__c =Double.valueof(respRecsNew.DataArea[i].DTime);
                                recDiaRepSRT.Access_Code_R__c =Double.valueof(respRecsNew.DataArea[i].RTime);
                                recDiaRepSRT.SRT_Id__c = String.valueof(respRecsNew.DataArea[i].SRTNumber);
                                recDiaRepSRT.SRT_Family__c = respRecsNew.DataArea[i].SRTFamily;
                                recDiaRepSRT.Component_Type__c = respRecsNew.DataArea[i].ComponentType;

                                //Update ECM Flag, Private Flag and Regions field
                                if(respRecsNew.DataArea[i].ECMFlag != null && respRecsNew.DataArea[i].ECMFlag != ''){
                                    if(respRecsNew.DataArea[i].ECMFlag == 'Y'){
                                        recDiaRepSRT.ECM_Flag__c = true;
                                    }
                                    else{
                                        recDiaRepSRT.ECM_Flag__c = false;
                                    }
                                }
                                if(respRecsNew.DataArea[i].PrivateFlag != null && respRecsNew.DataArea[i].PrivateFlag!=''){
                                    if(respRecsNew.DataArea[i].PrivateFlag == 'Y'){
                                        recDiaRepSRT.Private_Flag__c = true;
                                    }
                                    else{
                                        recDiaRepSRT.Private_Flag__c = false;
                                    }
                                }

                                //Story - GSSC - 24
                                if(respRecsNew.DataArea[i].FlexSRT != null && respRecsNew.DataArea[i].FlexSRT !=''){
                                    if(respRecsNew.DataArea[i].FlexSRT == 'Y'){
                                        recDiaRepSRT.Flex_Flag__c = true;
                                    }
                                    else{
                                        recDiaRepSRT.Flex_Flag__c = false;
                                    }
                                }
                                if(respRecsNew.DataArea[i].ECMFlag != null && respRecsNew.DataArea[i].ECMFlag !=''){
                                    if(respRecsNew.DataArea[i].ECMFlag == 'Y'){
                                        recDiaRepSRT.ECM_Flag__c = true;
                                    }
                                    else{
                                        recDiaRepSRT.ECM_Flag__c = false;
                                    }
                                }
                                //Story - GSSC - 24
                                //Story#172627
                                if(!string.isBlank(lstJob[0].AccessCode__c))
                                {
                                    recDiaRepSRT.SRT_Access_Code__c = lstJob[0].AccessCode__c;
                                }
                                if(recDiaRepSRT.Access_Code_A__c==0 && recDiaRepSRT.Access_Code_B__c==0 && recDiaRepSRT.Access_Code_C__c==0 && recDiaRepSRT.Access_Code_D__c==0 && recDiaRepSRT.Access_Code_R__c!=0)
                                {
                                    recDiaRepSRT.Access_Code__c='R';
                                }
                                else
                                {
                                    recDiaRepSRT.Access_Code__c = lstJob[0].AccessCode__c;
                                }
                                //End
                                recDiaRepSRT.SRT_Notes__c ='';
                                recDiaRepSRT.Regions__c = respRecsNew.DataArea[i].Regions;
                                recDiaRepSRT.Type__c = Typ;

                                if(lstJob[0].AccessCode__c =='A'){
                                    recDiaRepSRT.SRT_Time__c=Double.valueof(respRecsNew.DataArea[i].ATime);
                                }
                                else if(lstJob[0].AccessCode__c =='B'){
                                    recDiaRepSRT.SRT_Time__c=Double.valueof(respRecsNew.DataArea[i].BTime);
                                }
                                else if(lstJob[0].AccessCode__c =='C'){
                                    recDiaRepSRT.SRT_Time__c=Double.valueof(respRecsNew.DataArea[i].CTime);
                                }
                                else if(lstJob[0].AccessCode__c =='D'){
                                    recDiaRepSRT.SRT_Time__c=Double.valueof(respRecsNew.DataArea[i].DTime);
                                }
                                else if(lstJob[0].AccessCode__c =='R'){
                                    recDiaRepSRT.SRT_Time__c=Double.valueof(respRecsNew.DataArea[i].RTime);
                                }

                                if(lstSRT.size() > 0){
                                    for (Integer iCnt2=0; iCnt2<lstSRT.size(); iCnt2++) {
                                        if (respRecsNew.DataArea[i].StepID != null && string.valueof(respRecsNew.DataArea[i].StepID) == lstSRT[iCnt2].step_id__c) {
                                            recDiaRepSRT.SRT_AccessiblityCheck__c = lstSRT[iCnt2].SRT_AccessiblityCheck__c;
                                            recDiaRepSRT.SRT_Quantity__c = lstSRT[iCnt2].SRT_Quantity__c;
                                            system.debug('recTempSRT.SRT_AccessiblityCheck__c**'+recDiaRepSRT.SRT_AccessiblityCheck__c);
                                        }
                                    }
                                }
                                else{
                                    recDiaRepSRT.SRT_AccessiblityCheck__c = false;
                                }
                                lstDisplaySRT.add(recDiaRepSRT);
                                system.debug('lstDisplaySRT'+lstDisplaySRT[0].SRT_Quantity__c);
                            }
                            //Added as part of the defect # GSSC-210 - START
                            if(lstDisplaySRT != null && lstDisplaySRT.size() > 0){
                                Map<String, CSS_SRT__c> sortMap = new Map<String, CSS_SRT__c>();
                                for(CSS_SRT__c srtRec : lstDisplaySRT){
                                    sortMap.put(srtRec.SRT_Title__c, srtRec);
                                }
                                List<String> srtTitleSRT = new List<String>();
                                srtTitleSRT.addAll(sortMap.keyset());
                                srtTitleSRT.sort();
                                lstDisplaySRT.clear();
                                for(String srtTit : srtTitleSRT){
                                    CSS_SRT__c temp = new CSS_SRT__c();
                                    temp = sortMap.get(srtTit);
                                    lstDisplaySRT.add(temp);
                                }
                                lstDisplaySRT1.addAll(lstDisplaySRT);//Added as part of GSSC-287 
                            }
                            //Added as part of the defect # GSSC-210 - END
                            system.debug('FinaldataDiaRepSRTis '+lstDisplaySRT);
                            system.debug('FinaldataDiaRepSRTis '+lstDisplaySRT.size());
                            system.debug('lstDisplaySRT1*** '+lstDisplaySRT1);
                            system.debug('lstDisplaySRT1*** '+lstDisplaySRT1.size());

                        }
                        //Added as part of the story GSSC-18 - END
                        //Commented as part of the story GSSC-18 - START
                        /*for (Integer iCnt1=0; iCnt1<lstTempRec.size(); iCnt1++) {
                                CSS_srt__c recTempSRT = new CSS_srt__c();
                                //add rows to the temp
                                recTempSRT.Job_order__c = Wid;
                                recTempSRT.Solution_Number__c = Sid;
                                recTempSRT.srt_id__c = lstTempRec[iCnt1].Attribute3__c;// SRT Id
                                recTempSRT.Type__c = Typ;
                                recTempSRT.CSS_UniqueSRTValues__c = Sid + '-' + lstTempRec[iCnt1].Attribute5__c + '-' + Typ;
                                System.debug('SRT Unique Values --->'+iCnt1+'---->'+ recTempSRT.CSS_UniqueSRTValues__c );
                                recTempSRT.SRT_Title__c = lstTempRec[iCnt1].Attribute4__c; 
                                recTempSRT.SRT_Details__c = lstTempRec[iCnt1].Attribute5__c;
                                //Update ECM Flag, Private Flag and Regions field
                                if(lstTempRec[iCnt1].Attribute7__c != null && lstTempRec[iCnt1].Attribute7__c!=''){
                                    if(lstTempRec[iCnt1].Attribute7__c == 'Y'){
                                        recTempSRT.ECM_Flag__c = true;
                                    }
                                    else{
                                        recTempSRT.ECM_Flag__c = false;
                                    }
                                }
                                if(lstTempRec[iCnt1].Attribute8__c != null && lstTempRec[iCnt1].Attribute8__c!=''){
                                    if(lstTempRec[iCnt1].Attribute8__c == 'Y'){
                                        recTempSRT.Private_Flag__c = true;
                                    }
                                    else{
                                        recTempSRT.Private_Flag__c = false;
                                    }
                                }
                                recTempSRT.Regions__c = lstTempRec[iCnt1].Attribute9__c;

                                if (lstSRT.size() > 0) {
                                    for (Integer iCnt2=0; iCnt2<lstSRT.size(); iCnt2++) {
                                        system.debug('Anirudh lstTempRec[iCnt1].Attribute3__c>>>>>>>>>>>>>>'+lstTempRec[iCnt1].Attribute3__c + '>>>>>>>>'+lstSRT[iCnt2].step_id__c);
                                        if (lstTempRec[iCnt1].Attribute3__c == lstSRT[iCnt2].step_id__c) {
                                            recTempSRT.SRT_AccessiblityCheck__c = lstSRT[iCnt2].SRT_AccessiblityCheck__c;
                                            recTempSRT.SRT_Quantity__c = lstSRT[iCnt2].SRT_Quantity__c;
                                            system.debug('recTempSRT.SRT_AccessiblityCheck__c**'+recTempSRT.SRT_AccessiblityCheck__c);
                                        }
                                    }
                                }
                                else { recTempSRT.SRT_AccessiblityCheck__c = false;}
                                lstDisplaySRT.add(recTempSRT);
                                System.debug('lstDisplaySRT --->'+lstDisplaySRT );
                            }*/
                        //Commented as part of the story GSSC-18 - END 
                    }
                } else {
                    sHandleMsg = 'Invalid Request';
                    system.debug('sHandleMsg5**'+sHandleMsg);
                }
            }
            //} //Commented as part of the story GSSC-18 - START
            //Added else if as per NCIS story no #84383-RAJESH
            /*else if(Typ == 'Field Action Access'){
                system.debug('***fieldactionIF****');
                if (Wid != '' && Wid != null &&  Compid != '' && Compid != null) {
                    //84383  
                    system.debug('***InsideSecondIF****');             
                    lstJob = [select id, name ,Equipment_ID__c,Qsol_Engine_Family_Code__c,Service_Model__c,Status__c from css_job_order__c where id=: Wid LIMIT 1];
                    system.debug('***lstJob****'+lstJob);
                    if (lstJob.size() >0) {
                        system.debug('***InsidelstJobIF****'); 
                        //75670
                        if(lstJob[0].Status__c=='Closed' || lstJob[0].Status__c=='Canceled'){
                            jobStatus=true;
                        }
                        lstTempRec = [select id,Attribute1__c, Attribute2__c,
                                      Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c,Attribute7__c,Attribute8__c,Attribute9__c,
                                      JobOrder__c,Service_Model_Name__c,
                                      Source__c,SRT_Access_Checklist__c
                                      from   CSS_JobEventTemporary__c
                                      where (JobOrder__c =:Wid  
                                             and Service_Model_Name__c =:lstJob[0].Service_Model__c 
                                             and attribute1__c=:lstJob[0].Qsol_Engine_Family_Code__c
                                             and attribute2__c=:lstJob[0].Equipment_ID__c
                                             and Source__c = 'SRT'
                                             and ExpireDateTime__c > :System.Now())];
                        //84383
                        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c,Component_Id__c, Type__c,step_id__c,
                                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                                  where Component_Id__c =:Compid and Job_order__c=:Wid
                                  and Type__c = :Typ];

                        system.debug('Gyan** Values of lstTempRec:' + lstTempRec) ;
                        system.debug('Gyan******* Values of lstSRT:' + lstSRT) ;

                        if (lstTempRec.size() > 0) { //create a temporary SRT List using the temp records
                            sHandleMsg = 'TEMP';
                            system.debug('sHandleMsg1**'+sHandleMsg);
                            jsonResp = lstTempRec[0].Reason__c;  //Added as part of the story GSSC-18
                        } //Access Checklist Available in Temp Object
                        else { 
                            lstTempRec = new List<CSS_JobEventTemporary__c>();
                            if (lstJob[0].Equipment_ID__c == '' || lstJob[0].Equipment_ID__c == '' ||
                                lstJob[0].Service_Model__c == '' || lstJob[0].Service_Model__c == null ||
                                lstJob[0].Qsol_Engine_Family_Code__c == '' || lstJob[0].Qsol_Engine_Family_Code__c == null) {
                                // Displaying Nothing and Making No WebService Call.
                                sHandleMsg = 'Invalid Request';
                                system.debug('sHandleMsg2**'+sHandleMsg);
                            } else { //Make a WS call to get this Access Checklist
                                lstTempRec = CSS_SRTAccessWebService.accessSRT(Sid,lstJob[0].Equipment_ID__c,lstJob[0].Service_Model__c,lstJob[0].Qsol_Engine_Family_Code__c);
                                System.debug('lstTempRec');
                                if(lstTempRec.size()>0){
                                    sHandleMsg = 'WEB';
                                    system.debug('sHandleMsg3**'+sHandleMsg);
                                } 
                                else {
                                    sHandleMsg = 'Invalid Request';
                                    system.debug('sHandleMsg4**'+sHandleMsg);
                                }
                            }
                        } //Access Checklist obtained from WS
                        if (sHandleMsg == 'TEMP' || sHandleMsg == 'WEB') {
                            for (Integer iCnt1=0; iCnt1<lstTempRec.size(); iCnt1++) {
                                CSS_srt__c recTempSRT = new CSS_srt__c();
                                //add rows to the temp
                                recTempSRT.Job_order__c = Wid;
                                //84383
                                recTempSRT.Component_Id__c = Compid;
                                recTempSRT.srt_id__c = lstTempRec[iCnt1].Attribute3__c;
                                recTempSRT.Type__c = Typ;
                                recTempSRT.CSS_UniqueSRTValues__c = Sid + '-' + lstTempRec[iCnt1].Attribute5__c + '-' + Typ;
                                System.debug('SRT Unique Values --->'+iCnt1+'---->'+ recTempSRT.CSS_UniqueSRTValues__c );
                                recTempSRT.SRT_Title__c = lstTempRec[iCnt1].Attribute4__c; 
                                recTempSRT.SRT_Details__c = lstTempRec[iCnt1].Attribute5__c;
                                //Update ECM Flag, Private Flag and REgions field
                                if(lstTempRec[iCnt1].Attribute7__c != null && lstTempRec[iCnt1].Attribute7__c!=''){
                                    if(lstTempRec[iCnt1].Attribute7__c == 'Y'){
                                        recTempSRT.ECM_Flag__c = true;
                                    }
                                    else{
                                        recTempSRT.ECM_Flag__c = false;
                                    }
                                }
                                if(lstTempRec[iCnt1].Attribute8__c != null && lstTempRec[iCnt1].Attribute8__c!=''){
                                    if(lstTempRec[iCnt1].Attribute8__c == 'Y'){
                                        recTempSRT.Private_Flag__c = true;
                                    }
                                    else{
                                        recTempSRT.Private_Flag__c = false;
                                    }
                                }
                                recTempSRT.Regions__c = lstTempRec[iCnt1].Attribute9__c;

                                if (lstSRT.size() > 0) {
                                    for (Integer iCnt2=0; iCnt2<lstSRT.size(); iCnt2++) {
                                        system.debug('Anirudh lstTempRec[iCnt1].Attribute3__c>>>>>>>>>>>>>>'+lstTempRec[iCnt1].Attribute3__c + '>>>>>>>>'+lstSRT[iCnt2].step_id__c);
                                        if (lstTempRec[iCnt1].Attribute3__c == lstSRT[iCnt2].step_id__c) {
                                            recTempSRT.SRT_AccessiblityCheck__c = lstSRT[iCnt2].SRT_AccessiblityCheck__c;
                                            recTempSRT.SRT_Quantity__c = lstSRT[iCnt2].SRT_Quantity__c;
                                            system.debug('recTempSRT.SRT_AccessiblityCheck__c**'+recTempSRT.SRT_AccessiblityCheck__c);
                                        }
                                    }
                                }
                                else { recTempSRT.SRT_AccessiblityCheck__c = false;}
                                //System.debug('recTempSRT' + recTempSRT);
                                lstDisplaySRT.add(recTempSRT);
                                System.debug('lstDisplaySRT --->'+lstDisplaySRT );
                            }
                            //System.debug('lstDisplaySRT' + lstDisplaySRT);
                        }
                    } else {
                        sHandleMsg = 'Invalid Request';
                        system.debug('sHandleMsg5**'+sHandleMsg);
                    }
                }
            }*/
            //Commented as part of the story GSSC-18 - END
            else {
                sHandleMsg = 'Invalid Request';
                system.debug('sHandleMsg6**'+sHandleMsg);
            }
            system.debug('Gyan** Values of lstTempRec:' + lstTempRec) ;
            system.debug('Gyan** Values of lstSRT:' + lstSRT) ;
            system.debug('sHandleMsg**'+sHandleMsg);
        }
        Catch (Exception e)  {
            system.debug('Entered into catch block of css_srtaccesschecklist class' +e.getMessage() + e.getLineNumber());
        }
    }

    public void saveNClose(){
        try {
            Boolean blnFound;
            List<CSS_srt__c> lstInsSRT = new List<CSS_srt__c>();
            List<CSS_srt__c> lstUpdSRT = new List<CSS_srt__c>();
            List<CSS_srt__c> lstDelSRT = new List<CSS_srt__c>();
            List<CSS_srt__c> lstFinalInsSRT = new List<CSS_srt__c>();
            List<CSS_srt__c> lstFinalUpdSRT = new List<CSS_srt__c>();
            List<CSS_JobEventTemporary__c> lstFinalTempSRT = new List<CSS_JobEventTemporary__c>();
            System.debug('Gyan** lstDsiplayList1 :' + lstDisplaySRT);
            System.debug('Gyan** lstSRT :' + lstSRT);
            String SolType;
            //84383
            if(Typ == 'Diag Access'){
                SolType = 'Diagnosis';
            }
            else if(Typ == 'Field Action Access'){
                SolType = 'Field Action';
            }
            else {
                SolType = 'Repair';
            }

            //84383
            AggregateResult[] groupedResults;
            if(Typ == 'Repair Access' || Typ == 'Diag Access'){
                groupedResults= [SELECT MAX(SRT_Order__c) 
                                 FROM CSS_SRT__c 
                                 WHERE Job_Order__c = : Wid and Solution_Number__c = :Sid and (Type__c = : Typ OR Type__c = :SolType)];
            }else if(Typ == 'Field Action Access'){
                groupedResults= [SELECT MAX(SRT_Order__c) 
                                 FROM CSS_SRT__c 
                                 WHERE Job_Order__c = : Wid and Component_Id__c = :Compid and (Type__c = : Typ OR Type__c = :SolType)];
            }
            Decimal sortOrder = 0;
            system.debug('groupedResults>>>>>>'+groupedResults);
            if(groupedResults != null && groupedResults.size() > 0){
                sortOrder =(Decimal) groupedResults[0].get('expr0');
            }

            if(sortOrder==null)
                sortOrder = 0;

            system.debug('sortOrder --1'+sortOrder);
            system.debug('beforelstdisplaySRTIteration>>>>>>'+lstDisplaySRT);
            for (CSS_srt__c recInsSRT1: lstDisplaySRT) {
                blnFound = false;
                if (recInsSRT1.SRT_AccessiblityCheck__c) {
                    System.debug('SRT - code'+recInsSRT1.SRT_Details__c);
                    system.debug('Anirudh** Values of lstSRT:' + lstSRT) ;
                    if (lstSRT.size()>0) {

                        for (CSS_srt__c recInsSRT2: lstSRT) {
                            System.debug('SRT - code2'+recInsSRT2.SRT_Details__c);
                            // if (recInsSRT1.srt_id__c == recInsSRT2.srt_id__c) {
                            if (recInsSRT1.srt_Details__c == recInsSRT2.srt_Details__c) {
                                System.debug('SRT - ID'+ recInsSRT1.id +' '+ recInsSRT2.id);
                                system.debug('BeforerecInsSRT1**'+recInsSRT1);
                                recInsSRT1.Id = recInsSRT2.id;
                                //KAL:Story#109744:
                                recInsSRT1.SRT_Quantity__c = recInsSRT1.SRT_Quantity__c;//recInsSRT1.SRT_Quantity__c+recInsSRT2.SRT_Quantity__c; //KAL
                                //recInsSRT1.step_id__c = recInsSRT1.srt_id__c;
                                recInsSRT1.step_id__c = recInsSRT1.Step_id__c;
                                recInsSRT1.srt_id__c = recInsSRT2.SRT_Details__c;
                                system.debug('AfterrecInsSRT1**'+recInsSRT1);
                                lstUpdSRT.add(recInsSRT1);
                                blnFound = true;
                                break;
                            }
                        }
                        if (!blnFound) {
                            //KAL:Story#109744:
                            recInsSRT1.Id = recInsSRT1.id;
                            //recInsSRT1.step_id__c = recInsSRT1.srt_id__c;
                            recInsSRT1.step_id__c = recInsSRT1.Step_id__c;
                            recInsSRT1.SRT_Quantity__c = recInsSRT1.SRT_Quantity__c;
                            recInsSRT1.srt_id__c = recInsSRT1.SRT_Details__c;
                            sortOrder = sortOrder + 1;
                            recInsSRT1.srt_order__c = sortOrder;
                            lstInsSRT.add(recInsSRT1);
                            system.debug('blnfound**'+blnFound);
                        }
                        system.debug('BeforeElserecInsSRT1**'+recInsSRT1);
                    } else {
                        //KAL:Story#109744:
                        recInsSRT1.Id = recInsSRT1.id;
                        //recInsSRT1.step_id__c = recInsSRT1.srt_id__c;
                        recInsSRT1.step_id__c = recInsSRT1.Step_id__c;
                        recInsSRT1.SRT_Quantity__c = recInsSRT1.SRT_Quantity__c;
                        recInsSRT1.srt_id__c = recInsSRT1.SRT_Details__c;
                        system.debug('sortOrder --2'+sortOrder);
                        sortOrder = sortOrder + 1;
                        recInsSRT1.srt_order__c = sortOrder;
                        system.debug('AfterElserecInsSRT1**'+recInsSRT1);
                        lstInsSRT.add(recInsSRT1);
                    }
                } //if value check in VF
                else {
                    System.debug('SRT inserting list--->'+lstInsSRT);
                    for (CSS_srt__c recInsSRT3: lstSRT) {
                        System.debug('TEMpValue:-->'+recInsSRT1.srt_id__c+'srt List SRTID ---->'+recInsSRT3.srt_id__c);
                        //if (recInsSRT1.srt_id__c == recInsSRT3.srt_id__c) {//Anirudh commented to make it consistent with the above one
                        if (recInsSRT1.srt_Details__c == recInsSRT3.srt_Details__c) { 
                            system.debug('SRT DEL '+ recInsSRT1.srt_id__c + ' ' + recInsSRT3.srt_id__c);
                            lstDelSRT.add(recInsSRT3);
                        }
                    }
                } //if Value Unchecked in VF
            } // Lists Complete

            System.debug('Gyan** Values of lstInsSRT:' + lstInsSRT);
            //Commented as part of the story GSSC-18 - START
            /*if (lstInsSRT.size()>0){
                Decimal iRetSRTime;
                for (CSS_srt__c recWSSRT: lstInsSRT) {
                    System.debug('inside lstinsSRT');
                    //Below code added for the story#172627
                    CSS_J2AAccessStepDetails_SRT wo1 = CSS_SRTAccessWebService.accessSRTStepDetails_New(lstJob[0].Equipment_ID__c,recWSSRT.step_id__c);
                    if(wo1.DataArea.CaseResponse!=null){
                        for(integer a=0;a<wo1.DataArea.CaseResponse.size();a++){
                            recWSSRT.SRT_Time__c  = wo1.DataArea.CaseResponse[a].SRTTime;
                            recWSSRT.SRT_Access_Code__c =wo1.DataArea.CaseResponse[a].SRTAccessCode;
                            if(Typ == 'Diag Access'){
                                if(wo1.DataArea.CaseResponse[a].SRTAccessCode == 'R')
                                    recWSSRT.Access_Code__c =wo1.DataArea.CaseResponse[a].SRTAccessCode;
                                else
                                    recWSSRT.Access_Code__c = lstJob[0].Accesscode__c;
                            }
                            else
                                recWSSRT.Access_Code__c = wo1.DataArea.CaseResponse[a].SRTAccessCode;
                        }
                    }
                    else{
                        recWSSRT.SRT_Time__c=0;
                        recWSSRT.SRT_Access_Code__c='';
                    }

                    //if(recWSSRT.SRT_Time__c!=0 &&  recWSSRT.SRT_Access_Code__c!='') //commented 
                    if(recWSSRT.SRT_Access_Code__c!='')
                    {
                        if(recWSSRT.SRT_Access_Code__c=='A' || recWSSRT.Access_Code__c=='A')
                            recWSSRT.Access_Code_A__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='B' || recWSSRT.Access_Code__c=='B')
                            recWSSRT.Access_Code_B__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='C' || recWSSRT.Access_Code__c=='C')
                            recWSSRT.Access_Code_C__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='D' || recWSSRT.Access_Code__c=='D')
                            recWSSRT.Access_Code_D__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='R' || recWSSRT.Access_Code__c=='R')
                            recWSSRT.Access_Code_R__c=recWSSRT.SRT_Time__c;
                    }

                    //End
                    //recWSSRT.Additional_SRT_Calculated__c = iRetSRTime;
                    recWSSRT.Type__c = typ;
                    recWSSRT.SRT_Quantity__c = recWSSRT.SRT_Quantity__c ;
                    system.debug('SRT_Quantity__c>>>>>'+recWSSRT.SRT_Quantity__c);
                    lstFinalInsSRT.add(recWSSRT);
                }
            } //Got all SRT Times*/
            //Commented as part of the story GSSC-18 - END
            //below query added for story GSSC-Story#: GSSC-77

            if (lstUpdSRT.size()>0){
                //Decimal iRetSRTime;  ////Commented as part of the story GSSC-18
                for (CSS_srt__c recWSSRT: lstUpdSRT) {
                    // iRetSRTime = CSS_SRTAccessWebService.accessSRTStepDetails(lstJob[0].Equipment_ID__c,recWSSRT.SRT_id__c);
                    //  iRetSRTime = CSS_SRTAccessWebService.accessSRTStepDetails(lstJob[0].Equipment_ID__c,recWSSRT.step_id__c);
                    //  System.debug('SRT TIme List'+iRetSRTime);
                    //recWSSRT.Additional_SRT_Calculated__c = iRetSRTime;
                    //  recWSSRT.SRT_Time__c = iRetSRTime;
                    //Commented as part of the story GSSC-18 - START
                    /*CSS_J2AAccessStepDetails_SRT wo1 = CSS_SRTAccessWebService.accessSRTStepDetails_New(lstJob[0].Equipment_ID__c,recWSSRT.step_id__c);
                    if(wo1.DataArea.CaseResponse!=null){
                        for(integer a=0;a<wo1.DataArea.CaseResponse.size();a++){
                            recWSSRT.SRT_Time__c  = wo1.DataArea.CaseResponse[a].SRTTime;
                            recWSSRT.SRT_Access_Code__c =wo1.DataArea.CaseResponse[a].SRTAccessCode;
                            if(Typ == 'Diag Access'){
                                if(wo1.DataArea.CaseResponse[a].SRTAccessCode == 'R')
                                    recWSSRT.Access_Code__c =wo1.DataArea.CaseResponse[a].SRTAccessCode;
                                else
                                    recWSSRT.Access_Code__c = lstJob[0].Accesscode__c;
                            }
                            else
                                recWSSRT.Access_Code__c = wo1.DataArea.CaseResponse[a].SRTAccessCode;
                        }
                    }
                    else{
                        recWSSRT.SRT_Time__c=0;
                        recWSSRT.SRT_Access_Code__c='';
                    }

                    //if(recWSSRT.SRT_Time__c!=0 &&  recWSSRT.SRT_Access_Code__c!='') //commented
                    if(recWSSRT.SRT_Access_Code__c!='') 
                    {
                        if(recWSSRT.SRT_Access_Code__c=='A' || recWSSRT.Access_Code__c=='A')
                            recWSSRT.Access_Code_A__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='B' || recWSSRT.Access_Code__c=='B')
                            recWSSRT.Access_Code_B__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='C' || recWSSRT.Access_Code__c=='C')
                            recWSSRT.Access_Code_C__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='D' || recWSSRT.Access_Code__c=='D')
                            recWSSRT.Access_Code_D__c=recWSSRT.SRT_Time__c;
                        else if(recWSSRT.SRT_Access_Code__c=='R' || recWSSRT.Access_Code__c=='R')
                            recWSSRT.Access_Code_R__c=recWSSRT.SRT_Time__c;
                    }

                    //End*/
                    //Commented as part of the story GSSC-18 - END
                    recWSSRT.Type__c = typ;
                    recWSSRT.SRT_Quantity__c = recWSSRT.SRT_Quantity__c ;
                    recWSSRT.Id = recWSSRT.Id ;
                    system.debug('SRT_Quantity__c>>>>>'+recWSSRT.SRT_Quantity__c);
                    lstFinalUpdSRT.add(recWSSRT);
                }
                system.debug('SRT Update list: ' + lstFinalUpdSRT);
                update lstFinalUpdSRT;
            } //Got all SRT Times

            System.debug('Gyan** value of existing lstSRT :'+lstSRT);
            //Commented as part of the story GSSC-18 - START
            //JET records from WS to be inserted into the system
            /*for( Integer i=0;i<lstTempRec.size();i++){
                    CSS_JobEventTemporary__c recTempEvtSRT = new CSS_JobEventTemporary__c();
                    recTempEvtSRT.attribute1__c = lstJob[0].Qsol_Engine_Family_Code__c;
                    recTempEvtSRT.attribute2__c = lstJob[0].Equipment_ID__c;
                    recTempEvtSRT.attribute3__c = lstTempRec[i].attribute3__c;
                    recTempEvtSRT.attribute4__c = lstTempRec[i].attribute4__c;
                    recTempEvtSRT.attribute5__c = lstTempRec[i].attribute5__c;
                    recTempEvtSRT.source__c = 'SRT';
                    recTempEvtSRT.ExpireDateTime__c = System.now() + 7;
                    recTempEvtSRT.Service_Model_Name__c = lstJob[0].Service_Model__c;
                    recTempEvtSRT.JobOrder__c = Wid;
                    //Update ECM Flag, Private Flag and Regions field in JET object
                    recTempEvtSRT.Attribute7__c = lstTempRec[i].Attribute7__c;//ECM Flag
                    recTempEvtSRT.Attribute8__c = lstTempRec[i].Attribute8__c; //Private Flag
                    recTempEvtSRT.Attribute9__c = lstTempRec[i].Attribute9__c; // Regions
                    lstFinalTempSRT.add(recTempEvtSRT);
                }
                System.debug('Gyan** value in lstFinalInsSRT:' + lstFinalInsSRT);*/
            //Commented as part of the story GSSC-18 - END
            if (lstInsSRT.size()>0) {  //Replaced lstFinalInsSRT with lstInsSRT as part of the story GSSC-18
                System.debug('lstInsSRT----->'+lstInsSRT);
                upsert lstInsSRT;
            }
            System.debug('shandleMsg'+sHandleMsg+'=---'+lstFinalTempSRT.size());
            //Commented as part of the story GSSC-18 - START
            // Saving this to Temp object to avoid multiple calls to SRT
            /*if (lstFinalTempSRT.size()>0 && sHandleMsg =='WEB'){ 
                    System.debug('Entered IF shandleMsg'+sHandleMsg+'=---'+lstFinalTempSRT.size());
                    insert lstFinalTempSRT;
                }*/
            //Commented as part of the story GSSC-18 - END
            //Added as part of the story GSSC-18 - START
            if(lstOldRec != null && lstOldRec.size() > 0){
                delete lstOldRec;
            }
            if (newResp != null && sHandleMsg =='WEB'){ 
                System.debug('Entered IF shandleMsg'+sHandleMsg+'=---'+newResp);
                insert newResp;
            }
            //Added as part of the story GSSC-18 - END
            //Delete unwanted records
            if (lstDelSRT.size()>0) { 
                system.debug('DELETE SRTs');
                delete lstDelSRT;
            }

        } catch (Exception e) { 
            srtError(e.getMessage());
            System.debug('ERROR Message:-->:'+ e.getLineNumber() + '>>>>>>>' + e.getMessage());
        }     
    }

    public void srtError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='SRT';
        errObj.Error_Description__c = msg;
        insert errObj;
    }

    public void checkDuplicateSRTs(){
        System.debug('***inside srtRecSelected***'+srtRecSelected);
        System.debug('***inside checkDuplicateSRTs***'+srtRecId);
        lstSRTDupCheck=[select name,SRT_ID__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,IsDuplicateSRT__c,Solution_Title__c,Solution_Number__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c from CSS_SRT__c where CSS_Claims__c=null and SRT_ID__c != '' and SRT_ID__c != '0' and Job_Order__c =: Wid and (((Solution_Number__c != null and (Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' or Solution_Number__r.Diagnostic_Response__c = 'Not the solution') and (Type__c = 'Diagnosis' or Type__c = 'Diag Access' or Type__c = 'Repair Access' or (Component_Id__c != null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') and (Type__c='Repair')))) or (Solution_Number__c = null and (srt_category__c='AdditionalDiag' or srt_category__c='AdditionalRep'))) or (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED' and Component_Id__r.Type__c IN ('Campaign','TRP','ATC') and Component_Id__r.Performed_Review__c = true and Component_Id__r.Status__c='Approved' and ((Component_Id__r.Complete_Indicator__c=true and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=false))) or (Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true and srt_category__c IN ('Campaign','TRP','ATC')))];
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        String ESRTDCLValues = Label.CG_ExcludeSRTsDuplicateCheck;
        Set<String> SRTIDs=new Set<String>();
        if(ESRTDCLValues != null && ESRTDCLValues != '') {
            excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        }
        for(CSS_srt__c srtObj:lstSRTDupCheck){
            SRTIDs.add(srtObj.SRT_ID__c.LEFT(6));
        }
        if(lstSRTDupCheck!=null && lstSRTDupCheck.size()>0){
            system.debug('***size***'+lstSRTDupCheck.size());
            for (CSS_srt__c srtRec: lstDisplaySRT){
                if(SRTIDs != null && SRTIDs.contains(srtRec.SRT_Details__c.LEFT(6)) && srtRec.SRT_AccessiblityCheck__c== true && excludeSRTsDuplicateCheckList!= null && !(excludeSRTsDuplicateCheckList.contains(srtRec.SRT_Details__c.LEFT(6)))){
                    system.debug('**insideif***');
                    //dupSRTFound=true;
                    srtRec.IsDuplicateSRT__c=true;
                }
                else{
                    system.debug('**insideelse***');
                    srtRec.IsDuplicateSRT__c=false;
                    //dupSRTFound = false;
                }
            }
            for(CSS_srt__c srtRec: lstDisplaySRT){
                if(srtRec.IsDuplicateSRT__c==true){
                    dupSRTFound=true;
                    break;
                }
                else
                    dupSRTFound=false;
            }
            system.debug('*****dupSRTFound***'+dupSRTFound);
        }
    }

    public void Cancel(){

    }
    //Added as part of GSSC-287
    public boolean NoRecordsfound{get;set;}
    public void searchAccChklistSRTCodeAndDescription(){
        try{
            NoRecordsfound = false;
            system.debug('searchAcesscheklistvalue>>>>>'+searchAcesscheklistvalue);
            lstDisplaySRT = new list<CSS_srt__c>();
            system.debug('lstSRT****'+lstDisplaySRT1.size());
            system.debug('lstSRT****'+lstDisplaySRT1);
            for(css_srt__c srtObj: lstDisplaySRT1){
                if(string.isNotBlank(searchAcesscheklistvalue) && searchAcesscheklistvalue.length() >= 2){
                    system.debug('InsidethirdIF****');
                    if(srtObj.SRT_ID__c.containsIgnoreCase(searchAcesscheklistvalue) || srtObj.SRT_Title__c.containsIgnoreCase(searchAcesscheklistvalue)){
                        if(srtObj.SRT_AccessiblityCheck__c==false){
                            srtObj.SRT_Quantity__c =null;
                        }
                        lstDisplaySRT.add(srtObj);

                    }

                }
                else if(string.isBlank(searchAcesscheklistvalue)){
                    if(srtObj.SRT_AccessiblityCheck__c==false){
                        srtObj.SRT_Quantity__c =null;
                    }
                    lstDisplaySRT.add(srtObj);
                    system.debug('lstDisplaySRTLAST<><>'+lstDisplaySRT.size());
                }
                system.debug('ss****'+lstDisplaySRT.size());

            }
            system.debug('lstDisplaySRT****'+lstDisplaySRT+'size**'+lstDisplaySRT.size());
            if(lstDisplaySRT.size()==0){
                NoRecordsfound = true; 
                system.debug('insideerror'+NoRecordsfound);
            }
        }
        catch(exception e){
            System.debug('in catch of serach access checklist>>>>>>>>>>>>>>is :: '+e.getLineNumber()+' Exception Message>>>is:'+e.getMessage()); 

        }

    }
    //Added as part of the story GSSC-82
    public void getErrorDetails(){
        try{
            if(CSS_SRTAccessCheckListCL.serviceFailed){
                insert errorDetail;
            } 
        }catch(exception e){

        }

    }
}