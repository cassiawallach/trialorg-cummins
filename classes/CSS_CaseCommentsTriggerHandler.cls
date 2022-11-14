/**********************************************************************
Name:CSS_CaseCommentTrigger
Copyright Â© 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    Shanthi     22/05/2017      INITIAL DEVELOPMENT                    
***********************************************************************/

public class CSS_CaseCommentsTriggerHandler
{
    
    
    //Method to throw error message for advising the user to reassign the case owner if the caseowner not same as loggedin user
    public static void caseErrorMessage(list<CaseComment> lstCasesComment){
        map<id,CaseComment> mapCaseComment = new map<id,CaseComment>();
        map<id,Case> mapCases;
        for(CaseComment comment : lstCasesComment){
          
            mapCaseComment.put(comment.ParentId ,comment);
        }
        
        if(mapCaseComment != null  && mapCaseComment.keySet().size() > 0){
            mapCases = new map<id,Case>([select id,ownerId,Username_WWID__c,Job__c, CreatedById from Case 
                                         where id in : mapCaseComment.keySet()]); //CT3-184
       }
        
        if(mapCases != null){
            for(CaseComment cseCmt : lstCasesComment){
                system.debug('cseCmt.ParentId).OwnerId '+ mapCases.get(cseCmt.ParentId).OwnerId + ' mapCases.get(cseCmt.ParentId).CreatedById '+ mapCases.get(cseCmt.ParentId).CreatedById + ' UserInfo.getUserId() ' + UserInfo.getUserId());//CT3-184
                if(mapCases.get(cseCmt.ParentId).OwnerId != UserInfo.getUserId() && mapCases.get(cseCmt.ParentId).CreatedById != UserInfo.getUserId()&&mapCases.get(cseCmt.ParentId).Job__c ==''){
                    system.debug('Inside if Condition');     
                    cseCmt.adderror('You have to be the Case Owner to modify the case');
                }
             }   
            }
            
    }
    
    
    //Method to change the statue of Case from "New" to "Submitted" if the caseowner not same as loggedin user
    public static void updateCase(list<CaseComment> lstCasesComment){
        map<id,CaseComment> mapCaseComment = new map<id,CaseComment>();
        map<id,Case> mapCases;
        Set<Id> casesIds = new Set<Id>();
        List<Case> caseslst = new List<Case>();
        for(CaseComment comment : lstCasesComment){
          
            mapCaseComment.put(comment.ParentId ,comment);
        }
        
        if(mapCaseComment != null  && mapCaseComment.keySet().size() > 0){
            mapCases = new map<id,Case>([select id,ownerId,Status,CreatedById from Case 
                                         where id in : mapCaseComment.keySet()]);
       }
        
        if(mapCases != null){
            for(CaseComment cseCmt : lstCasesComment){
                if(mapCases.get(cseCmt.ParentId).Status == 'New' && mapCases.get(cseCmt.ParentId).CreatedById != UserInfo.getUserId()){
                     casesIds.add(mapCases.get(cseCmt.ParentId).Id);    
                }
             }   
            }
        
        
        if(casesIds.size() > 0) {
            caseslst=[Select id,Status from Case where id IN : casesIds];
            
            for(Case c : caseslst){
                c.Status='Submitted';
                
            
            }
             update caseslst;
        }
            
    }

    
}