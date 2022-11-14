/**********************************************************************
Name:FSL_CL_qsolRedirect
Copyright Â© 2019  Cummins
=================================================================================================
=================================================================================================
Purpose:                                                            
-------  
This class is to open QSOL Links from Solution
==================================================================================================
==================================================================================================
History                                                             
-------                                                            
VERSION     AUTHOR                     DATE         DETAILS                          
1.0       SRIPRADA SESHAM      04/16/2019      Initial Devlopment(reference from Gudianz CSS)                 
***************************************************************************************************/
public class FSL_CL_qsolRedirect {
    Public String documentId{Set;get;}
    Public String docType{Set;get;}
    Public String busUnit{Set;get;}
    Public String qsolResp {set;get;}
    Public String srlNo {set;get;}
    Public String serviceOrder {set;get;}
    
    public FSL_CL_qsolRedirect(){
        documentId = ApexPages.CurrentPage().getParameters().get('docid');
        docType = ApexPages.CurrentPage().getParameters().get('doctype');
        busUnit = ApexPages.CurrentPage().getParameters().get('pgroup');
        String[] splitArray = ApexPages.CurrentPage().getParameters().get('serialNumber').split('-');
        srlNo = splitArray[0];
        serviceOrder =splitArray[1];
    }
    public PageReference redirect(){
        PageReference pageRef = null;
        try{
            if(string.isNotBlank(documentId) && string.isNotBlank(docType) && string.isNotBlank(busUnit) && string.isNotBlank(srlNo))
            {
                //-----CT3-44 ----
                //Modified By: Dinesh Yadav, 28 Sept 2020 For QSOL launguage.
                System.debug(' ::::: ' + UserInfo.getLanguage()) ;
                CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
                system.debug('csAccountLang :: '+csAccountLang);
                string strCSS_QsolLanguage ='en';
                if(csAccountLang != null){
                    if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                        strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
                }
                qsolResp = FSL_CL_QSOLIntegrations.CallForProcedureLink(documentId,srlNo,busUnit,docType, strCSS_QsolLanguage);
        /* ------------End * CT3-44 -----*/
                
                system.debug('checking the link'+qsolResp);
                pageRef = new PageReference(qsolResp); 
                pageRef.setRedirect(true);
                String des = 'Viewed '+documentId+ ' Procedure details';
                //Added By Rajasheakr to record procedure details in Audit Trail
                FSL_CumminsUtilities.auditTrailInsert('Event-10',serviceOrder,des,'','','');
                
            }   
            
        }
        catch(Exception e)
        {  
            system.debug('Exception Message'+e.getMessage()+' '+e.getLineNumber());
        }
        return pageRef;
    }
    
}