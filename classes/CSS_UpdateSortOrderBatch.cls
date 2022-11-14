/*
 * Description : Batch class to order all SRT's 
 * Author      : Rakesh Kumar
 */
global class CSS_UpdateSortOrderBatch implements Database.Batchable<sObject>{
    global final String Query;
    global CSS_UpdateSortOrderBatch(String q){
        if(q != null){
            Query=q;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_Job_Order__c> lstServiceJob){
   		set<id> setJobId = new set<id>();
        list<CSS_Solutions__c> lstSolutions = new list<CSS_Solutions__c>();
        map<id,list<CSS_Solutions__c>> mapJobToSolution = new map<id,list<CSS_Solutions__c>>();
        list<CSS_SRT__c> lstUpdateSrt = new list<CSS_SRT__c>();
        list<CSS_Job_Order__c> lstJobForAddSrt = new list<CSS_Job_Order__c>();
        //creation of job ids set .
        for(CSS_Job_Order__c sjob : lstServiceJob){
            setJobId.add(sjob.id);
        }
        //query for solution and additional SRT
        if(setJobId != null && setJobId.size() > 0){
            lstSolutions = [select id,Service_Job__c,(Select id,name,SRT_Order__c 
                                       from CSS_SRTs__r 
                                       where type__c ='Diagnosis' or type__c ='Diag Access') 
                            from CSS_Solutions__c 
                            where Service_Job__c in : setJobId];
            system.debug('lstSolutions--->'+lstSolutions);
           lstJobForAddSrt = [select id,(SELECT id,name,SRT_Order__c 
                                       	 FROM CSS_SRTs__r 
                                         WHERE Solution_Number__c= null)
                              from CSS_Job_Order__c
                              where id in : setJobId] ;
        }
        //building jobs solution map
        if(lstSolutions != null && lstSolutions.size() > 0){
            for(CSS_Solutions__c sol :lstSolutions){
                if(mapJobToSolution != null && !mapJobToSolution.containsKey(sol.Service_Job__c)){
                    mapJobToSolution.put(sol.Service_Job__c, new list<CSS_Solutions__c>());
                }
                mapJobToSolution.get(sol.Service_Job__c).add(sol);
        	}
        }
        system.debug('mapJobToSolution---->'+mapJobToSolution);
        //Numbering the sort order for a job and within a solution
        if(mapJobToSolution != null && mapJobToSolution.size() > 0){
            //iterating jobs
            for(id jobId : mapJobToSolution.keySet()){
                //iterating all solution for that job
                for(CSS_Solutions__c sol : mapJobToSolution.get(jobId)){
                    //iterating SRT for each solution and ordering them
                    if(sol.CSS_SRTs__r != null && sol.CSS_SRTs__r.size()>0){
                        decimal count = 0 ;
                        for(CSS_SRT__c srt : sol.CSS_SRTs__r){
                            srt.SRT_Order__c = count + 1;
                            count = srt.SRT_Order__c;
                            lstUpdateSrt.add(srt);
                        }//eof srt iteration
                    }
                }//eof solution iteration
            }//eof job iteration
        }
        system.debug('lstUpdateSrt-->'+lstUpdateSrt);
        //Ordering Additional SRT's
        if(lstJobForAddSrt != null && lstJobForAddSrt.size() > 0){
            for(CSS_Job_Order__c jobOrder : lstJobForAddSrt){
                if(jobOrder.CSS_SRTs__r != null && jobOrder.CSS_SRTs__r.size() > 0){
                    decimal addSrtCount = 0 ;
                    for( CSS_SRT__c addSrt : jobOrder.CSS_SRTs__r){
                        addSrt.SRT_Order__c = addSrtCount + 1;
                            addSrtCount = addSrt.SRT_Order__c;
                            lstUpdateSrt.add(addSrt);
                    }
                }
            }
        }
        
        
        if(lstUpdateSrt != null && lstUpdateSrt.size() >0){
            update lstUpdateSrt;
        }
        
      
    }
 
   global void finish(Database.BatchableContext BC){}
}