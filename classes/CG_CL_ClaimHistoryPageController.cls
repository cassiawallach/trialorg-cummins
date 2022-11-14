/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimHistoryPageController
{
    public static String claimID {get; set;}
    public static List<CSS_JobEventTemporary__c> claimList{get;set;}
    
    //  public static String selectedPSN { get; set; }
    //public List<ClaimHistoryWrapper> ClaimHistoryWrapperList{get;set;}

    public class ClaimHistoryWrapper {
        public string newsFailure_date;
        public string sFailure_date;
        public string sWarranty_Start_Date;
        public decimal sFailure_Pointc; 
        public string sRoot_Cause;    
        public string sRepair_Location;
        public string sClaim;
        public string sDistributor_s_Invoice_Paid;
        public string sFailure_Measure; //Added as part of story# 161394

        public ClaimHistoryWrapper() {
            newsFailure_date = '';
            sFailure_date = '';
            sWarranty_Start_Date = '';
            sFailure_Pointc = 0;
            sRoot_Cause = '';
            sRepair_Location = '';
            sClaim = '';
            sDistributor_s_Invoice_Paid = '';
            sFailure_Measure = '';
        }
    }  
    public class NotesWrapper {

        public string sNote;
        public string sNote_Type;
        public date sCreated_Date; 

        public NotesWrapper() {
            sNote = '';
            sNote_Type = '';
            sCreated_Date = null;
        }
    }  
    /* public class NoteWiseNotesWrapper {
    public  List<NotesWrapper> lstCompNoteWrapper;
        public  List<NotesWrapper> lstCauseNoteWrapper;
        public NoteWiseNotesWrapper() {
        lstCompNoteWrapper = null;
            lstCauseNoteWrapper = null;
        }
    }*/
    public class NoteWiseNotesWrapper {
        public  String sComplaint;
        public  String sCause;
        public  String sCorrection;
        public  String sReason;
        public  String sNarrative;
        public NoteWiseNotesWrapper() {
            sComplaint = '';
            sCause = '';
            sCorrection = '';
            sReason = '';
            sNarrative = '';
        }
    }


    @RemoteAction
    public static string SearchClaimHistory(String selectedPSN){
        system.debug('ESN**'+selectedPSN);
        List<ClaimHistoryWrapper> ClaimHistoryWrapperList = new List<ClaimHistoryWrapper>();
        List<ClaimHistoryWrapper> ClaimHistoryWrapperListDesc = new List<ClaimHistoryWrapper>();
        claimList = new List<CSS_JobEventTemporary__c>();
        try{
            claimList=CG_BL_Claims.performClaimHistoryBusinessLogic(selectedPSN); 
            system.debug('claimList**'+ claimList + ' claimList.size' + claimList.size());
            if(claimList != null && claimList.size()<=500){
                for(CSS_JobEventTemporary__c tempClaims : claimList) {
                    if(tempClaims.Attribute9__c=='Paid' || tempClaims.Attribute9__c=='Denied' || tempClaims.Attribute9__c=='Info Only'){
                        ClaimHistoryWrapper wrapper = new ClaimHistoryWrapper();
                        string sfailureDate = tempClaims.Attribute1__c;
                        String sfailDateLocale = '';
                        datetime failDate;
                        datetime SfailDateTime;
                        If(sfailureDate != null && sfailureDate != '') {
                            system.debug('sfailureDate0 ' + sfailureDate);
                            if(sfailureDate.contains('T')) 
                                sfailureDate = sfailureDate.replace('T', ' ');
                            
                            system.debug('sfailureDate1 ' + sfailureDate);
                            failDate = datetime.valueof(sfailureDate);
                            system.debug('failDate2 **'+failDate);
                            sfailDateLocale = css_utility.getFormattedDate(failDate); //Get formatted String from Utility Class
                            system.debug('sfailDateLocale2 **'+sfailDateLocale);
                        }
                        wrapper.newsFailure_date = failDate.format('yyyy MM dd HH:mm a z');
                        wrapper.sFailure_date = sfailDateLocale;
                        wrapper.sFailure_Pointc = Decimal.valueOf(tempClaims.Attribute4__c);
                        wrapper.sRoot_Cause = (tempClaims.Attribute5__c == null ? '' : tempClaims.Attribute5__c) +' '+'-'+' '+(tempClaims.Circuit_Description__c == null ? '' : tempClaims.Circuit_Description__c); 
                        wrapper.sRepair_Location = (tempClaims.Attribute2__c == null ? '' :  tempClaims.Attribute2__c) + ' ' + (tempClaims.Attribute3__c == null ? '' : tempClaims.Attribute3__c); //Attribute2 added as part of story# 161394
                        wrapper.sFailure_Measure = tempClaims.Attribute6__c == null ? '' : tempClaims.Attribute6__c; 
                        wrapper.sClaim = tempClaims.Attribute8__c;
                        ClaimHistoryWrapperList.add(wrapper);
                    }
                }
            }
            
         /*   for(Integer i=ClaimHistoryWrapperList.size()-1;i>=0;i--){
                 ClaimHistoryWrapperListDesc.add(ClaimHistoryWrapperList.get(i));
             }
            
            System.debug('ClaimHistoryWrapperListDesc  '+ClaimHistoryWrapperListDesc); // This should be in descending order*/

            system.debug('ClaimHistoryWrapperList**'+ClaimHistoryWrapperList);
            system.debug('JSON.serialize(ClaimHistoryWrapperList) ' + JSON.serialize(ClaimHistoryWrapperList));
            String claimHistory = JSON.serialize(ClaimHistoryWrapperList);
            return claimHistory;
        }
        catch(Exception e){
            system.debug('EXCEPTION of SearchClaimHistory Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            return null;
        }
        //return JSON.serialize(ClaimHistoryWrapperList);

    }
    @RemoteAction
    public static string SPClaimDetails(String claimNum){
        system.debug('claimNum**'+claimNum);
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();
        List<NotesWrapper> NotesWrapperList = new List<NotesWrapper>();
        //List<NotesWrapper> CompWrapperList = new List<NotesWrapper>();
        //List<NotesWrapper> CauseWrapperList = new List<NotesWrapper>();
        List<NoteWiseNotesWrapper> NoteWiseNotesWrapperList = new List<NoteWiseNotesWrapper>();
        list<date> lstCreateDate = new list<date>();
        set<date> setCreatedDates = new set<date>();
        list<date> NewCD = new list<date>();
        //set<date> lstCreateDate = new set<date>();
        cresWrap = CSS_FN_Siebel.CallGetClaimDetails(claimNum);
        system.debug('cresWrap**'+cresWrap);
        // List<cresWrap.Notes> nd = new List<cresWrap.Notes>();
        if(cresWrap.DataArea!=null){
            //Preparing NotesWrapper list
            for(CSS_GetClaimDetailsResponse.DataArea det : cresWrap.DataArea){
                system.debug('det**'+det.Notes);

                for(CSS_GetClaimDetailsResponse.Notes Note : det.Notes){
                    NotesWrapper Wrap = new NotesWrapper();
                    system.debug('Note**'+Note);
                    Wrap.sNote = Note.Note;
                    Wrap.sNote_Type = Note.NoteType;
                    //Wrap.sCreated_Date = string.valueof(Note.CreatedDate);
                    Wrap.sCreated_Date = date.parse(Note.CreatedDate);
                    NotesWrapperList.add(Wrap);
                    system.debug('Wrap**'+Wrap);
                    system.debug('NotesWrapperList**'+NotesWrapperList);
                }

            }
            //Collecting all Dates into a list
            if(NotesWrapperList!=null && NotesWrapperList.size()>0){

                for(integer k= 0; k<NotesWrapperList.size();k++){
                    lstCreateDate.add(NotesWrapperList[k].sCreated_Date);
                }
            }
            system.debug('lstCreateDates**'+lstCreateDate);
            if(lstCreateDate!=null && lstCreateDate.size()>0)
                lstCreateDate.sort();
            system.debug('lstCreateDate.sort()' + '     ' + lstCreateDate);
            setCreatedDates.addAll(lstCreateDate);
             system.debug('setCreatedDates**'+setCreatedDates);
            NewCD.addAll(setCreatedDates);
               system.debug('NewCD**'+NewCD); 
            //Preparing final wrapper, sorty  by created date
            NoteWiseNotesWrapper compWrap = new NoteWiseNotesWrapper();
            for(integer m=0;m<NewCD.size();m++){
                for(integer n=0;n<NotesWrapperList.size();n++){
                    system.debug('NewCD[m]**'+NewCD[m]);
                    system.debug('NotesWrapperList[n]'+NotesWrapperList[n]);
                    if(NewCD[m] == NotesWrapperList[n].sCreated_Date){
                       
                        if(NotesWrapperList[n].sNote_Type=='Complaint'){
                            if( compWrap.sComplaint!=null &&  compWrap.sComplaint!='')
                                compWrap.sComplaint =compWrap.sComplaint+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sComplaint =NotesWrapperList[n].sNote;

                        }
                        // compWrap.sComplaint += '<br/>';
                        if(NotesWrapperList[n].sNote_Type=='Cause'){
                            if(compWrap.sCause!=null &&  compWrap.sCause!='')
                            compWrap.sCause = compWrap.sCause+'\n'+NotesWrapperList[n].sNote;
                             else
                                compWrap.sCause =NotesWrapperList[n].sNote;
                        }
                        if(NotesWrapperList[n].sNote_Type=='Correction'){
                            if(compWrap.sCorrection!=null &&  compWrap.sCorrection!='')
                            compWrap.sCorrection = compWrap.sCorrection+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sCorrection =NotesWrapperList[n].sNote;
                        }
                        if(NotesWrapperList[n].sNote_Type=='Reject Reason'){
                            if(compWrap.sReason!=null &&  compWrap.sReason!='')
                            compWrap.sReason = compWrap.sReason+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sReason =NotesWrapperList[n].sNote;
                        } 
                        if(NotesWrapperList[n].sNote_Type=='Narrative'){
                             if(compWrap.sNarrative!=null &&  compWrap.sNarrative!='')
                            compWrap.sNarrative = compWrap.sNarrative+'\n'+NotesWrapperList[n].sNote;
                            else
                                compWrap.sNarrative =NotesWrapperList[n].sNote;
                        }
                        system.debug('compWrap Inside**'+compWrap);
                        //NoteWiseNotesWrapperList.add(compWrap);
                        //break;  
                    }
                    // break;     
                }

            }
            NoteWiseNotesWrapperList.add(compWrap);
            system.debug('NoteWiseNotesWrapperList**'+NoteWiseNotesWrapperList);
            //return JSON.serialize(NotesWrapperList);
        }
        return JSON.serialize(NoteWiseNotesWrapperList);
    }
}