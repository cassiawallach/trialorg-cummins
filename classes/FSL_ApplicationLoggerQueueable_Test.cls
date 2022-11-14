@isTest
public class FSL_ApplicationLoggerQueueable_Test{ 
  
  
   static testmethod  void testApplicationLogger(){
             
        
        FSL_ApplicationLoggerQueueable FslApplctnLogger= new FSL_ApplicationLoggerQueueable('test','test',Null,Null,'','OK','Code','toolid','',Null,'');
        Test.starttest();
        system.enqueueJob(FslApplctnLogger);
        Test.stoptest();
    }
    
    
   static testmethod  void testApplicationLogger2(){
             
        
        FSL_ApplicationLoggerQueueable FslApplctnLogger= new FSL_ApplicationLoggerQueueable(Null,'test',Null,Null,'','test','Code','toolid','',Null,'');
        Test.starttest();
        system.enqueueJob(FslApplctnLogger);
        Test.stoptest();
    }
}