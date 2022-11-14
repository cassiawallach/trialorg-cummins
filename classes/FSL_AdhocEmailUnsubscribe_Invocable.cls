public class FSL_AdhocEmailUnsubscribe_Invocable {
    @InvocableMethod(label='UnSubscribeAdhocEmailCommunication' description='unsubscribe email' category='WorkOrder')
    public static void deleteAdhocEmailAddress(List<id> caseThreadid){
        System.debug('FSL_AdhocEmailUnsubscribe_Invocable lass');
        
        
        list<case> cl = new List <case>();
        Map<Id, string> serviceJobIdVsEmail = new Map<Id, String>();
        list<string> adhocemail=new list<string>();
        try{  
            if(caseThreadid!=null){
            for(case c :[SELECT Id,ServiceJob__c,FSL_Adhco_Email__c,ServiceJob__r.FSL_Additional_Email_Notifications__c
                         FROM Case where id =: caseThreadid]){
                             if(c.FSL_Adhco_Email__c!=null){
                             serviceJobIdVsEmail.put(c.serviceJob__c,c.FSL_Adhco_Email__c);
                             System.debug('case query'+c); 
                             System.debug('FSL_Adhco_Email__c'+c.FSL_Adhco_Email__c);
                             }
                             if(c!=null){
                                 System.debug('Inside If');
                                 
                                 cl.add(c);
                             }         
                         }
            update cl;
            System.debug('Adhoc email ' + cl);
            List<WorkOrder> wl=new List<WorkOrder>();
            if(serviceJobIdVsEmail.keyset().size() > 0){
                List<WorkOrder> servicejobList = [Select id, FSL_Additional_Email_Notifications__c from WorkOrder where id in: serviceJobIdVsEmail.keyset()];
                for(WorkOrder sJob: servicejobList){
                    
                    if(sJob.FSL_Additional_Email_Notifications__c!=null){
                    string s=sJob.FSL_Additional_Email_Notifications__c;
                    if(s.contains(serviceJobIdVsEmail.get(sJob.id)+';')){
                        string s1=serviceJobIdVsEmail.get(sJob.id);
                        s1=s1+';';
                        s= s.remove(s1);
                        }
                    else if(s.contains(serviceJobIdVsEmail.get(sJob.id))){
                        
                        s= s.remove(serviceJobIdVsEmail.get(sJob.id));}
                    /*if(s.contains(serviceJobIdVsEmail.get(sJob.id))){
                        
                        s= s.remove(serviceJobIdVsEmail.get(sJob.id));
                        // s=s.replace(';;',';');
                    }else if(s.contains(serviceJobIdVsEmail.get(sJob.id) +';')){
                        s= s.remove(serviceJobIdVsEmail.get(sJob.id)+';');
                    }*/
                   
                    sJob.FSL_Additional_Email_Notifications__c=s;
                    wl.add(sJob);
                }}
                update wl;
                
            }  
            }
        }
        
        
        
        catch (System.QueryException e) {
            System.debug('Case Query Issue: ' + e);
        } 
        
    }
                               
}