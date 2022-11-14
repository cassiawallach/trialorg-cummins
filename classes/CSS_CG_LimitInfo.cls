/*This class is written because its static function will be called from the trigger CSS_Job_Order__c to find the limits invloved during Intake.*/
public class CSS_CG_LimitInfo
{
   public static void limitsfunc()
   {
   
   system.debug('**********Total No of Aggregate Query limits***********'+limits.getLimitAggregateQueries());
   system.debug('**********Total No of Aggregate Queries Called***********'+limits.getAggregateQueries());
   system.debug('**********Remaining Aggregate queries that can be called***********'+(limits.getLimitAggregateQueries()-limits.getAggregateQueries()));
        
   system.debug('**********Total number of Web service statements that can be processed***********'+limits.getLimitCallouts());
   system.debug('**********Total number of Web service statements that can be processed***********'+limits.getCallouts());
   system.debug('**********Remaining number of Web service statements that can be processed***********'+(limits.getLimitCallouts()-limits.getCallouts()));
        
   system.debug('**********Total number of SOQL queries that can be issued***********'+limits.getLimitQueries());
   system.debug('**********Total number of SOQL queries that have been issued***********'+limits.getLimitQueries());
   system.debug('**********Remaining number of SOQL queries that can been issued***********'+(limits.getLimitQueries()-limits.getQueries()));
   
   system.debug('**********Returns the total amount of memory (in bytes) that can be used for the heap.***********'+limits.getLimitHeapSize());
   system.debug('**********Returns the approximate amount of memory (in bytes) that has been used for the heap.***********'+limits.getHeapSize());
   system.debug('**********Remaining amount of memory (in bytes) for the heap***********'+(limits.getLimitHeapSize()-limits.getHeapSize()));
   
   system.debug('**********Total number of records that can be processed with any statement that counts against DML***********'+limits.getLimitDMLRows());
   system.debug('**********Total number of records that have been processed with any statement that counts against DML***********'+limits.getDMLRows());
   system.debug('**********Remaining number of records that can be processed ahead***********'+(limits.getLimitDMLRows()-limits.getDMLRows()));
   
       
   system.debug('**********Total number of records that can be processed with any statement that counts against DML***********'+limits.getLimitDMLRows());
   system.debug('**********Total number of records that have been processed with any statement that counts against DML***********'+limits.getDMLRows());
   system.debug('**********Remaining number of records that can be processed ahead***********'+(limits.getLimitDMLRows()-limits.getDMLRows()));
   
   
   }

}