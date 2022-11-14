/**********************************************************************
Name:CSS_SRTAccessCheckListClosedCntrl
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose: 
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR                    DATE                DETAIL                                 
1.0                                                     INITIAL DEVELOPMENT
2.0     - Rajesh Pasupuleti         02/15/2018          Added code as per NCIS story #84383 
***********************************************************************/
public class CSS_SRTAccessCheckListClosedCntrl {
    public String sHandleMsg{get;set;}
    public Boolean jobStatus{get;set;}
    public List<CSS_Job_Order__c> lstJob;
    public list<CSS_srt__c> lstDisplaySRT{get;set;}
    public list<CSS_srt__c> lstSRT ;
    public String Wid;
    public String Sid;
    //RAJ-84383
    public String Compid;
    public String Typ;
    public String Quantity;
    public void Cancel()
    {

    }

    public CSS_SRTAccessCheckListClosedCntrl() {
        try {
            jobStatus=false;
            Wid=ApexPages.CurrentPage().getParameters().get('JobOrderId');
            Sid=ApexPages.CurrentPage().getParameters().get('solutionId');
            //RAJ-84383
            Compid=ApexPages.CurrentPage().getParameters().get('componentId');
            Typ=ApexPages.CurrentPage().getParameters().get('typ');
            /*if (Typ== 'rep') {
                Typ = 'Repair Access';
            } else {
                Typ = 'Diag Access';
            }*/
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
            if (Wid != '' && Wid != null && Sid != '' && Sid != null) {
                lstJob = [select id, name ,Equipment_ID__c,Qsol_Engine_Family_Code__c,
                          Service_Model__c,Status__c from css_job_order__c where id=: Wid LIMIT 1];
                if (lstJob.size() >0) {
                    //75670
                    if(lstJob[0].Status__c=='Closed' || lstJob[0].Status__c=='Canceled'){
                        jobStatus=true;
                    }

                    lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c, Type__c,
                              SRT_Title__c,SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                              where Job_order__c=:Wid
                              and Type__c = :Typ and Solution_Number__c = :Sid ];
                    system.debug('Gyan** Values of lstSRT:' + lstSRT) ;

                    if (lstSRT.size() > 0) {
                        for (Integer iCnt1=0; iCnt1<lstSRT.size(); iCnt1++) {
                            CSS_srt__c recTempSRT = new CSS_srt__c();
                            //add rows to the temp
                            recTempSRT.Job_order__c = Wid;
                            recTempSRT.Solution_Number__c = Sid;
                            recTempSRT.Type__c = Typ;
                            recTempSRT.SRT_AccessiblityCheck__c = lstSRT[iCnt1].SRT_AccessiblityCheck__c;
                            recTempSRT.SRT_Quantity__c = lstSRT[iCnt1].SRT_Quantity__c;
                            recTempSRT.SRT_Details__c = lstSRT[iCnt1].SRT_Details__c;
                            recTempSRT.SRT_Title__c= lstSRT[iCnt1].SRT_Title__c;
                            lstDisplaySRT.add(recTempSRT);
                        }
                        sHandleMsg = 'Valid Request';
                    }
                    //System.debug('lstDisplaySRT' + lstDisplaySRT);
                    else {
                        sHandleMsg = 'Invalid Request';
                    }

                } 

                else {
                    sHandleMsg = 'Invalid Request';
                }
            }
            //Added else if as per NCIS story no #84383-RAJESH
            else if(Typ == 'Field Action Access'){
                system.debug('***fieldactionIF****');
                if (Wid != '' && Wid != null &&  Compid != '' && Compid != null) {
                //84383  
                    system.debug('***InsideSecondIF****');             
                    lstJob = [select id, name ,Equipment_ID__c,Qsol_Engine_Family_Code__c,
                              Service_Model__c,Status__c from css_job_order__c where id=: Wid LIMIT 1];
                    system.debug('***lstJob****'+lstJob);
                    if (lstJob.size() >0) {
                    system.debug('***InsidelstJobIF****'); 
                    //75670
                            if(lstJob[0].Status__c=='Closed' || lstJob[0].Status__c=='Canceled'){
                            jobStatus=true;
                            }
                        //84383
                        lstSRT = [Select Id,Job_order__c,srt_id__c,Solution_Number__c,Component_Id__c, Type__c,step_id__c,
                                  SRT_Title__c, SRT_Details__c,SRT_Quantity__c ,SRT_AccessiblityCheck__c from CSS_srt__c 
                                  where Component_Id__c =:Compid and Job_order__c=:Wid
                                  and Type__c = :Typ];                                 
                        
                        
                         system.debug('Gyan******* Values of lstSRT:' + lstSRT) ;                        
                        
                        if (lstSRT.size() > 0) {
                        for (Integer iCnt1=0; iCnt1<lstSRT.size(); iCnt1++) {
                            CSS_srt__c recTempSRT = new CSS_srt__c();
                            //add rows to the temp
                            recTempSRT.Job_order__c = Wid;
                            recTempSRT.Solution_Number__c = Sid;
                            recTempSRT.Type__c = Typ;
                            recTempSRT.SRT_AccessiblityCheck__c = lstSRT[iCnt1].SRT_AccessiblityCheck__c;
                            recTempSRT.SRT_Quantity__c = lstSRT[iCnt1].SRT_Quantity__c;
                            recTempSRT.SRT_Details__c = lstSRT[iCnt1].SRT_Details__c;
                            recTempSRT.SRT_Title__c= lstSRT[iCnt1].SRT_Title__c;
                            lstDisplaySRT.add(recTempSRT);
                        }
                        sHandleMsg = 'Valid Request';
                    } //Access Checklist Available in Temp Object
                    } else {
                        sHandleMsg = 'Invalid Request';
                        system.debug('sHandleMsg5**'+sHandleMsg);
                    }
                }
            }
            else {
                sHandleMsg = 'Invalid Request';
            }           
        }
        Catch (Exception e)  {
            system.debug('Exception from SRT Access Check List Closed/Canceled' + e.getLineNumber() + e.getMessage()) ;
        }

    }

}