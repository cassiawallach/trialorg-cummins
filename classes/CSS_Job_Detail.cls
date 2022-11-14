/**********************************************************************
Name:CSS_Job_Detail
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 - Gyan Pany          1/8/2016       INITIAL DEVELOPMENT                     
2.0 - Satish             2/9/2016       UDAC WIRE FRAME CHANGES                
3.0 - Anirudh            2/11/2016      Coding Standards
***********************************************************************/

public with sharing class CSS_Job_Detail {
    
    public CSS_Job_Detail() 
    {
       // System.debug('satish >>>>>>> ');
    }
    
    public PageReference redirect(){
        String vVFPage;
        String vId;
        String vTarget = 'HOME';
        String jobStatus;
        Id JoId=ApexPages.CurrentPage().getParameters().get('id');
        String sTarget=ApexPages.CurrentPage().getParameters().get('nto');
        String sReadOnlyPage=ApexPages.CurrentPage().getParameters().get('fEdit');
        string jobPrevStatus='';
        string jobChevron='';
        string jobChevValues = System.label.CSS_Chevron_Values;
        List<String> SplitchevValues = jobChevValues.split(',');
            
        if (sTarget== null) {
            vTarget = 'HOME';
        }
        else {
            if (sTarget=='DET') {
                vTarget = 'DETAIL';
            }
            
            else {
                vTarget = sTarget;
            }
        }
        
        System.debug('satish >>>>>>> 1 '+sTarget+JoId+vTarget+sReadOnlyPage);
        
        if (sReadOnlyPage=='Previous')
        {
            //vVFPage = 'CSS_StdHeaderFooter';
            vVFPage = 'CSS_Job_Detail_RO';
            //vId = 'MAP';
            vId = JoId;
        }
        else{   
        List<Profile> profRec = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String ProfName = profRec[0].Name;
        System.debug('satish >>>>>>> 44 '+vTarget+ProfName);
        List<css_job_detail__c> listPages = new List<css_job_detail__c>();
            System.debug('JoId >>>>>>>'+JoId);
        try{
            System.debug('JoId >>>>>>>'+JoId);
            if (JoId == null)
            {
                vVFPage = 'CSS_Page_Map';
                vId = 'NULL';
                
                if (sTarget== 'HOME') {
                    vTarget = 'HOME';
                    listPages = [select DetailPage__c from css_job_detail__c where UserProfile__c = :ProfName 
                                 and Navigate_to__c= :vTarget Limit 1];    
                } else if(sTarget== 'NEWJOB') {
                    vTarget = 'NEWJOB';
                listPages = [select DetailPage__c from css_job_detail__c where UserProfile__c = :ProfName 
                                 and Navigate_to__c= :vTarget Limit 1];
                     //System.debug('satish >>>>>>> 3 '+vTarget+ProfName);
                }
                else if(sTarget== 'NEWCLAIM') {
                    vTarget = 'NEWCLAIM';
                listPages = [select DetailPage__c from css_job_detail__c where UserProfile__c = :ProfName 
                                 and Navigate_to__c= :vTarget Limit 1];
                     //System.debug('satish >>>>>>> 3 '+vTarget+ProfName);
                }
 
            }
            else
            {
                List<css_job_order__c>workJob = [Select Id, Status__c, Previous_status__c,chevron_page__c from CSS_Job_Order__c where id= :JoId];
                
                if (workJob.isEmpty())
                {
                    vVFPage = 'CSS_Page_Map';
                    vId = 'INVALID';
                    
                    if (sTarget== 'HOME') {
                        vTarget = 'HOME';
                        listPages = [select DetailPage__c from css_job_detail__c where UserProfile__c = :ProfName 
                                     and Navigate_to__c= :vTarget Limit 1];
                    }
                }
                else
                {
        
                    jobPrevStatus=workJob[0].Previous_status__c;
        
                    jobChevron=workJob[0].chevron_page__c;
                    
                    jobStatus = workJob[0].Status__c;
                    
                    if (jobStatus=='Review') {
                        
                    jobStatus =workJob[0].Previous_status__c;
                        System.debug('Inside Review>>>>>>> ' +ProfName+ +jobStatus+vVFPage + vTarget );
                        
                    } 
                    
                    if (jobStatus == null || jobStatus =='')
                    {
                        jobStatus='Intake';
                    }
                    
                    //System.debug('satish >>>>>>> 4' +ProfName+ +jobStatus+vVFPage + vTarget );
                    
                    if (vTarget == 'HOME') {
                        listPages = [select DetailPage__c from css_job_detail__c where UserProfile__c = :ProfName 
                                     and Navigate_to__c= :vTarget Limit 1];
                    }
                    else {
                        listPages = [select DetailPage__c from css_job_detail__c where JobStatus__c = :jobStatus and UserProfile__c = :ProfName 
                                     and Navigate_to__c= :vTarget Limit 1];
                    }
                    
                    
                }
                
            }
        } catch(Exception e) {
        }
        
        
        if (!listPages.isEmpty())
        {
            vVFPage = listPages[0].DetailPage__c;
            vId = JoId;
/*           
            if(sTarget== 'NEWJOB'){
              vVFPage = listPages[0].DetailPage__c;  
            } */
        }
//Story# 115059 To land on New Claim Page         
            /*if(sTarget=='NEWCLAIM')
            {vVFPage = 'cg_claimsIntake';
             vId = JoId;
            }*/
            
        else
        {
            //vVFPage = 'CSS_Page_Map';
            //vVFPage = 'CSS_StdHeaderFooter';
            //vId = 'MAP';
            vVFPage = 'CSS_Job_Detail_RO';
            vId = JoId;
        }
            
            if( jobStatus=='Repair' && jobChevron=='rj' || (jobPrevStatus=='Repair' && jobStatus=='Review' && jobChevron=='rj') ){
                
                vVFPage=vVFPage+'RJ';
            }
        
    } 
        PageReference pageRef;    
        //System.debug('satish >>>>>>> 2' +userinfo.getProfileId()+ vVFPage + vTarget+vId );
                if (vId == '' || vId == null){          
         pageRef = new pageReference('/apex/'+ vVFPage);   
        }else if((jobPrevStatus=='Repair' && jobStatus=='Repair' && SplitchevValues.contains(jobChevron)) || ((jobPrevStatus=='Triage & Diagnosis Complete' || jobPrevStatus=='Review')  && jobStatus=='Triage & Diagnosis Complete' && SplitchevValues.contains(jobChevron))){// Rajesh Narra
            pageRef = new pageReference('/apex/'+ vVFPage + '?id='+vId+'&nto=DET'); // Rajesh Narra
        }else{
            pageRef = new pageReference('/apex/'+ vVFPage + '?id='+vId); //+'&nto=DET'
        }
        SYSTEM.DEBUG('sTargetGGGG'+sTarget);
        SYSTEM.DEBUG('sTargetGGGGHHHHH'+pageRef);
        pageRef.setRedirect(true);
        return pageRef;       
    }
}