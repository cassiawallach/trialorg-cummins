public class CSS_serviceJobRecentVisit {
    public void assignToSharing(CSS_Job_Order__c[] triggernew,Map<Id,CSS_Job_Order__c> oldMap){
        try{
            
            List<CSS_Job_Order__c> newList = new List<CSS_Job_Order__c>();
            List<CSS_Job_Order__c> oldList = new List<CSS_Job_Order__c>();
            List<CSS_Job_Order__c> newNullList = new List<CSS_Job_Order__c>();
            List<CSS_Job_Order__c> oldNullList = new List<CSS_Job_Order__c>();
            List<CSS_Job_Order__c> recentVisitList = new List<CSS_Job_Order__c>();
            List<string> esnList = new List<string>();
            for(integer i=0;i<triggernew.size();i++){
                if(oldMap!=null){
                    if(triggernew[i].ESN__c!=null && triggernew[i].esn__c!=oldMap.get(triggernew[i].id).esn__c){
                        System.debug('The id is>>>>>'+triggernew[i].id);
                        newList.add(triggernew[i]);
                        // oldList.add(triggerold[i]);
                        esnList.add(triggernew[i].ESN__c);
                    }
                    else if(triggernew[i].ESN__c==null){
                        newNullList.add(triggernew[i]);
                        
                        // oldNullList.add(trigger.old[i]);
                    }
                }else
                {
                    System.debug('Inside service job');
                    newList.add(triggernew[i]);
                    esnList.add(triggernew[i].ESN__c);
                }
            }
            
            for(CSS_Job_Order__c njo:newNullList){
                njo.RecentVisit__c=false;
            }
            if(newList.size()>0){
                // System.debug('The esn is!#@!@'+esnList);
                recentVisitList = [select id,Recent_Visit__c,CreatedDate,esn__c from CSS_Job_Order__c where ESN__c IN : esnList AND CreatedDate>= LAST_N_DAYS:30 and ESN__c!=null];
                for(integer i=0;i<newList.size();i++){
                    System.debug('Hello');
                    //System.debug('The esn of newLIst is@!#!@'+newList[0].esn__c);
                    //System.debug('The esn of newLIst is@!#!@'+recentVisitList[0].esn__c);
                    if(recentVisitList.size()>0){
                        System.debug('Hello 1');
                        for(integer j =0;j<recentVisitList.size();j++){
                            if(newList[i].esn__c== recentVisitList[j].esn__c){
                                // newList[i].Recent_Visit__c='True';
                                newList[i].RecentVisit__c=true;
                                break;
                            }
                            else
                            {
                                newList[i].RecentVisit__c=false;
                                // newList[i].Recent_Visit__c='';
                            }
                        }
                    }
                    else
                    {
                        newList[i].RecentVisit__c=false;
                        // newList[i].Recent_Visit__c='';
                    }
                }
            }
            // update newList;
        }
        catch (DmlException e) {
            system.debug('Catch' + e.getMessage() + ' ' + e.getLineNumber());
        }
    }
}