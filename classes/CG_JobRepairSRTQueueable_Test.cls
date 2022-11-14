@istest
public class CG_JobRepairSRTQueueable_Test {
    
     static testmethod void method1(){
         list<string> lst = new list<string>();
   
    CG_JobRepairSRTQueueable obj = new CG_JobRepairSRTQueueable(lst);
         System.enqueueJob(obj);
         
    }

}