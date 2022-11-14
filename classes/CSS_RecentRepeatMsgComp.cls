/**********************************************************************
Name:CSS_RecentRepeatMsgComp
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Component Controller that displays Recent Records for a Job                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION    AUTHOR        DATE                    DETAIL                                
1.0        Gyan Pany    1/30/2016 8:29 PM        INITIAL DEVELOPMENT                                       
1.1        Anirudh      2/11/2016                Changes for Appropriate Message
***********************************************************************/
public class CSS_RecentRepeatMsgComp
{
    public static String curESN { get; set;}
    public static dateTime dtCreated { get; set { dtCreated=value; } } 
    public static List<CSS_Job_Order__c> getRepeatJobs()
        
    {
        List<CSS_Job_Order__c> RecJobs;
        try{
            DateTime lastDate1 = dtCreated.addDays(-30);
            RecJobs = [select Id, Name, CreatedDate from CSS_Job_Order__c 
                       where ESN__c=:curESN and createdDate >= :lastDate1 and createdDate < :dtCreated order by CreatedDate LIMIT 1];
        }
        catch(exception e){
            
        }   
        return RecJobs;
    } 
    
    public static List<CSS_Job_Order__c> getRecentJobs()
        
    {
        List<CSS_Job_Order__c> RecJobs;
        try{
            DateTime lastDate1 = dtCreated.addDays(-30); 
            RecJobs = [select Id, Name, CreatedDate from CSS_Job_Order__c 
                       where ESN__c=:curESN and createdDate >= :lastDate1 and createdDate < :dtCreated order by CreatedDate desc LIMIT 2];
            //  system.debug('inside lastDate' + lastDate);
            
        }
        catch(exception e){
            
        } 
        return RecJobs;
    }     
}