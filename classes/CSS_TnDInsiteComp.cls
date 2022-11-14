/**********************************************************************
Name:CSS_TnDInsiteComp
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Component Controller that displays fault Code from INSITE                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                
1.0 - Gyan Pany    1/30/2016 8:29 PM      INITIAL DEVELOPMENT                      
2.0 - Varun Sinha  2/11/2016 12:18 PM     UDAC WIRE FRAME CHANGES                  
3.0 - Anirudh      2/11/2016              Coding Standards
3.1 - Gyan Pany		3/4/2016			Defect Fix  - 50087 & 50304
***********************************************************************/
public class CSS_TnDInsiteComp
{
    public Id Ins_JobId {
        get;
        set {
            Ins_JobId = value;
            if ( value != null) {
                rJobOrd =[Select Id, ESN__c,ESN_Insite__c,INSITE_UpdateTimeStamp__c,INSITE_ESN_Choice__c
                          from CSS_Job_Order__c where id= :value];
                if (rJobOrd.INSITE_UpdateTimeStamp__c !=null && rJobOrd.INSITE_ESN_Choice__c == 'Not Selected' && rJobOrd.ESN__c!= rJobOrd.ESN_Insite__c && displayINPop!=false) {
                    showINPopup();
                }
                else {
                    closeINPopup();
                }
                if (rJobOrd.INSITE_UpdateTimeStamp__c !=null) {
                    sftdDate = rJobOrd.INSITE_UpdateTimeStamp__c.format('dd MMM yyyy - hh:mm a z');
                }
            }
        }
    }
    public css_job_order__c rJobOrd {get;set;}
    public String sftdDate {get;set;}
    public Boolean displayINPop {get;set;}
    public Boolean displayINncPop {get;set;}
    public Boolean isPrioritized {get;set;}
    public CSS_TnDInsiteComp() {
        String QId = ApexPages.CurrentPage().getParameters().get('DSID');
        system.debug('Gyan**-'+QId);
        if (QId == 'NC') {
            showINncPopup();
        }
    }
    public PageReference pgChInsiteESN()
    {
        css_job_order__c woInESN= new css_job_order__c();
        
        woInESN.INSITE_ESN_Choice__c='Overwrite ESN';
        woInESN.ESN__c=rJobOrd.ESN_Insite__c;
        woInESN.id=rJobOrd.id;
        update woInESN;
        closeINPopup();
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference pgChJoESN()
    {
        css_job_order__c woTyESN= new css_job_order__c();
        
        woTyESN.INSITE_ESN_Choice__c='Keep Typed ESN';
        woTyESN.id=rJobOrd.id;
        update woTyESN;
        closeINPopup();
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
        pageRef.setRedirect(true);
        return pageRef;
    } 
    public PageReference pgCancelClose()
    {
        closeINPopup();
        closeINncPopup();
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference pgFCRefresh()
    {
        List<CSS_Fault_Code__c> fcCodes = getFaultCodes();
        /* BEGIN - Defect Fix - 50087 - Two popup's were being shown */
        List<CSS_Fault_Code__c> fcUpCodes = getUnprioritizedFaultCodes();
        Boolean blnFcCodeAvl = false;
        if ((fcCodes.size() > 0) || (fcUpCodes.size() > 0))
        {
        	blnFcCodeAvl = true;
        }
        /* END - Defect Fix - 50087 - Two popup's were being shown */
        /* BEGIN - Defect Fix - 50304 - Dont Show Popup for same ESN */
        if (blnFcCodeAvl) {
	        if (rJobOrd.ESN__c!= rJobOrd.ESN_Insite__c){
	        /* END - Defect Fix - 50304 - Dont Show Popup for same ESN */
	            showINPopup();
	        }
            system.debug('Gyan*Method*displayINncPop=' + displayINncPop);
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=FC'); 
            pageRef.setRedirect(true);
            return pageRef;
        } 
        else {
            showINncPopup();
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            PageReference pageRef = new PageReference(sDestURL+'id='+Ins_JobId+'&DSID=NC'); 
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    public void showINPopup() {
        displayINPop = true;
    }
    
    public void showINncPopup() {
        displayINncPop = true;
    }  
    public void closeINPopup() {
        displayINPop = false;
    }    
    public void closeINncPopup() {
        displayINncPop = false;
    }
    public List<CSS_Fault_Code__c> getFaultCodes()
    {
        List<CSS_Fault_Code__c> faultCodes;
        AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
        if(fc.size()>0){
            integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
            faultCodes = [select Primary_Fault_Code__c, FaultCode__c, Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c from CSS_Fault_Code__c 
                          where Job_Order__c=:Ins_JobId and Sequence__c=:maxSeq and (NOT  FaultCode__c LIKE 'a0%') and Fault_Code__c !=Null  and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD')];
        }
        return faultCodes;      
    }
    public List<CSS_Fault_Code__c> getUnprioritizedFaultCodes()
    {
        List<CSS_Fault_Code__c> unPrioritizedFaultCodes;
        AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Ins_JobId];
        if(fc.size()>0){
            integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
            unPrioritizedFaultCodes = [select Primary_Fault_Code__c, FaultCode__c,RelatedFaultCode__c, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c 
                                       where Job_Order__c=:Ins_JobId and Sequence__c=:maxSeq and (NOT  FaultCode__c LIKE 'a0%') and Fault_Code__c !=Null and Fault_Code_Type__c NOT IN ('APD-P','APD-R','BPD')];
        }
        return unPrioritizedFaultCodes;      
    }
}