/*
 * Block comments with details of changes
 */
public class CSS_AutoAddAdminSRT { 
   //public string Wid{get;set;}  
    public CSS_AutoAddAdminSRT()
    {
    //Wid=ApexPages.CurrentPage().getParameters().get('JobOrderId');
    }
    
        @InvocableMethod(label='admin' description='sample')
    public static void getAdminSRTs(List<string> Input){
        
        List<CSS_srt__c> lstDisplaySRT;
        List<CSS_srt__c> lstFilteredSRT;
        
            //system.debug('JobId*'+Wid);
            // css_job_order__c jo = [select name,Claim_No__c,Service_Model__c,Equipment_ID__c,Qsol_Engine_Family_Code__c,AccessCode__c,repair_location__c from css_job_order__c where Id=:Wid[0] limit 1];
          // SRTCalloutAndInsert(Wid[0],jo.Repair_Location__c,jo.Application__c);
        //if(Input[0]=='InsiteUpdate'){SRTCalloutAndInsertInsiteAdminSRT(Input[0]);}
        //else {
          List<String> LstInpunt = new List<String>();
       LstInpunt = Input[0].split(';;');
        system.debug('TesstInput*'+LstInpunt);
        
        if(Input[0].contains(';;')){ 
        //system.debug('TesstInput*'+LstInpunt);
        
        system.debug('input1'+LstInpunt[0]);
        system.debug('input2'+LstInpunt[1]);
        
        system.debug('input3'+LstInpunt[2]);
            SRTCalloutAndInsert(LstInpunt[0],LstInpunt[1],LstInpunt[2]);}
        else {SRTCalloutAndInsertInsiteAdminSRT(Input[0]);}
        //}
        
        
            
}
    @future(callout=true)
    public static void SRTCalloutAndInsert(string JobId, string repairlocation, string Application){
       try{ List<css_srt__c> lstDisplaySRT = new List<css_srt__c>();
        List<css_srt__c> lstInsertSRT = new List<css_srt__c>();
        css_srt__c recAdminSRT = new css_srt__c();
        css_srt__c recAdminSRT1 = new css_srt__c();
        css_srt__c recAdminSRT2 = new css_srt__c();
        lstDisplaySRT = CSS_WS_SRT.getAllDigRepSRTs(JobId,'Admin');
        system.debug('lstDisplaySRT**'+JobId);
        for(integer i=0;i<lstDisplaySRT.size();i++){
        if(lstDisplaySRT[i].SRT_Id__c == '00-901-00')
        {
        if(repairlocation=='In Shop'){
                 recAdminSRT.srt_notes__c =lstDisplaySRT[i].srt_notes__c;
            recAdminSRT.job_order__c =JobId;
                    recAdminSRT.srt_title__c =lstDisplaySRT[i].srt_title__c;
            recAdminSRT.SRT_Id__c = lstDisplaySRT[i].SRT_Id__c;
            recAdminSRT.Type__c = lstDisplaySRT[i].srt_type__c;
                    recAdminSRT.srt_Type__c =lstDisplaySRT[i].srt_type__c;
                    system.debug('recSavDiagSRT.srt_type__c -->'+lstDisplaySRT[i].srt_type__c);
                    recAdminSRT.isPerformed__c=true;
                    recAdminSRT.Access_Code_A__c =lstDisplaySRT[i].Access_Code_A__c;
                    recAdminSRT.Access_Code_B__c=lstDisplaySRT[i].Access_Code_B__c;
                    recAdminSRT.Access_Code_C__c=lstDisplaySRT[i].Access_Code_C__c;
                    recAdminSRT.Access_Code_D__c=lstDisplaySRT[i].Access_Code_D__c;
                    recAdminSRT.Access_Code_R__c=lstDisplaySRT[i].Access_Code_R__c;
                    recAdminSRT.SRT_Quantity__c=1;
                    recAdminSRT.SRT_Time__c =lstDisplaySRT[i].SRT_Time__c;
            recAdminSRT.srt_category__c = 'AdditionalDiag';

                    recAdminSRT.CSS_UniqueSRTValues__c = JobId+lstDisplaySRT[i].srt_id__c;
        }
                       
        }
        
             
        if(lstDisplaySRT[i].SRT_Id__c == '00-902-00')
        {//insertvar = true;
        //break;
        if(repairlocation=='Mobile'){
                    recAdminSRT.srt_notes__c =lstDisplaySRT[i].srt_notes__c;
                    recAdminSRT1.srt_title__c =lstDisplaySRT[i].srt_title__c;
            recAdminSRT1.Type__c = lstDisplaySRT[i].srt_type__c;
                    recAdminSRT1.srt_Type__c =lstDisplaySRT[i].srt_type__c;
            recAdminSRT.job_order__c =JobId;
                    system.debug('recSavDiagSRT.srt_type__c -->'+lstDisplaySRT[i].srt_type__c);
                    recAdminSRT1.isPerformed__c=true;
            recAdminSRT1.SRT_Id__c = lstDisplaySRT[i].SRT_Id__c;
                    recAdminSRT1.Access_Code_A__c =lstDisplaySRT[i].Access_Code_A__c;
                    recAdminSRT1.Access_Code_B__c=lstDisplaySRT[i].Access_Code_B__c;
                    recAdminSRT1.Access_Code_C__c=lstDisplaySRT[i].Access_Code_C__c;
                    recAdminSRT1.Access_Code_D__c=lstDisplaySRT[i].Access_Code_D__c;
                    recAdminSRT1.Access_Code_R__c=lstDisplaySRT[i].Access_Code_R__c;
                    recAdminSRT1.SRT_Quantity__c=1;
                    recAdminSRT1.SRT_Time__c =lstDisplaySRT[i].SRT_Time__c;
recAdminSRT1.srt_category__c = 'AdditionalDiag';
                    recAdminSRT1.CSS_UniqueSRTValues__c = JobId+lstDisplaySRT[i].srt_id__c;
        }
                       
        }
        if(lstDisplaySRT[i].SRT_Id__c == '00-904-00')
        {
        if(Application =='310 – Recreational Vehicle' || Application =='320 – Recreational Vehicle AD'){
                recAdminSRT2.srt_notes__c =lstDisplaySRT[i].srt_notes__c;
                    recAdminSRT2.srt_title__c =lstDisplaySRT[i].srt_title__c;
            recAdminSRT2.Type__c = lstDisplaySRT[i].srt_type__c;
                    recAdminSRT2.srt_Type__c =lstDisplaySRT[i].srt_type__c;
            recAdminSRT2.SRT_Id__c = lstDisplaySRT[i].SRT_Id__c;
            recAdminSRT.job_order__c =JobId;
                    system.debug('recSavDiagSRT.srt_type__c -->'+lstDisplaySRT[i].srt_type__c);
                    recAdminSRT2.isPerformed__c=true;
                    recAdminSRT2.Access_Code_A__c =lstDisplaySRT[i].Access_Code_A__c;
                    recAdminSRT2.Access_Code_B__c=lstDisplaySRT[i].Access_Code_B__c;
                    recAdminSRT2.Access_Code_C__c=lstDisplaySRT[i].Access_Code_C__c;
                    recAdminSRT2.Access_Code_D__c=lstDisplaySRT[i].Access_Code_D__c;
                    recAdminSRT2.Access_Code_R__c=lstDisplaySRT[i].Access_Code_R__c;
                    recAdminSRT2.SRT_Quantity__c=1;
                    recAdminSRT2.SRT_Time__c =lstDisplaySRT[i].SRT_Time__c;
            recAdminSRT2.srt_category__c = 'AdditionalDiag';

                    recAdminSRT2.CSS_UniqueSRTValues__c = JobId+lstDisplaySRT[i].srt_id__c;
        }
                       
        }
   
        }
        lstInsertSRT.add(recAdminSRT);
        lstInsertSRT.add(recAdminSRT1);
        lstInsertSRT.add(recAdminSRT2);
        system.debug('lstInsertSRT>>>>>'+lstInsertSRT);
        insert lstInsertSRT;
           system.debug('After Insert>>>>>>>'+lstInsertSRT);
          }catch(exception e){ 
       system.debug('entered into catch block of auto add admin srts on dsid creation'+e.getMessage() + ' ' + e.getLineNumber());
       }
    } 
    
    @future(callout=true)
    public static void SRTCalloutAndInsertInsiteAdminSRT(string JobId) {
        try{
        List<css_srt__c> lstDisplaySRT1 = new List<css_srt__c>();
        List<css_srt__c> lstInsertSRT1 = new List<css_srt__c>();
        
        
        lstDisplaySRT1 = CSS_WS_SRT.getAllDigRepSRTs(JobId,'Admin');
        system.debug('lstDisplaySRT1**'+lstDisplaySRT1);
        for(integer i=0;i<lstDisplaySRT1.size();i++){
            
        if(lstDisplaySRT1[i].SRT_Id__c == '00-724-00')
        { 
            css_srt__c recInsiteAdminSRT = new css_srt__c();
            recInsiteAdminSRT.job_order__c =JobId;
            
                    recInsiteAdminSRT.srt_notes__c =lstDisplaySRT1[i].srt_notes__c;
                    recInsiteAdminSRT.srt_title__c =lstDisplaySRT1[i].srt_title__c;
                    recInsiteAdminSRT.srt_Type__c =lstDisplaySRT1[i].srt_type__c;
            recInsiteAdminSRT.Type__c = lstDisplaySRT1[i].srt_type__c;
            recInsiteAdminSRT.SRT_Id__c = lstDisplaySRT1[i].SRT_Id__c;
                    system.debug('recSavDiagSRT.srt_type__c -->'+lstDisplaySRT1[i].srt_type__c);
                    recInsiteAdminSRT.isPerformed__c=true;
                    recInsiteAdminSRT.Access_Code_A__c =lstDisplaySRT1[i].Access_Code_A__c;
                    recInsiteAdminSRT.Access_Code_B__c=lstDisplaySRT1[i].Access_Code_B__c;
                    recInsiteAdminSRT.Access_Code_C__c=lstDisplaySRT1[i].Access_Code_C__c;
                    recInsiteAdminSRT.Access_Code_D__c=lstDisplaySRT1[i].Access_Code_D__c;
                    recInsiteAdminSRT.Access_Code_R__c=lstDisplaySRT1[i].Access_Code_R__c;
                    recInsiteAdminSRT.SRT_Quantity__c=1;
                    recInsiteAdminSRT.SRT_Time__c =lstDisplaySRT1[i].SRT_Time__c;
            recInsiteAdminSRT.srt_category__c = 'AdditionalDiag';

                    recInsiteAdminSRT.CSS_UniqueSRTValues__c = JobId+lstDisplaySRT1[i].srt_id__c;
             lstInsertSRT1.add(recInsiteAdminSRT);
            break; 
        }
            
           
            
        }
        insert lstInsertSRT1;
        }catch(exception e){ 
       system.debug('entered into catch block of auto add admin srts on dsid creation'+e.getMessage() + ' ' + e.getLineNumber());
       }
    }   
}