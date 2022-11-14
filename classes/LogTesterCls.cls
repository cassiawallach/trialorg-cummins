public class LogTesterCls {
    //Test Platform Event: LogTesterCls.testPlafFormEventLog(); 
    //Test Normal Log: LogTesterCls.testLog();
    public static void testLog(){
        try{
            List<contact> lstCon = new List<contact> ();
            for(contact objCon:[Select Id from contact Limit 1]){
                objCon.LastName = 'test1';
                lstCon.add(objCon);             
            }
            system.debug('lstCon[5].LastName==> '+lstCon[5].LastName);                        
        }catch(Exception ex){
            ApplicationLogHelper.logException('LogTesterCls','Class', 'testLog', 'log','logAsssign', ex);
        }
        
    }
      public static void testPlafFormEventLog(){
        try{
            List<contact> lstCon = new List<contact> ();
            for(contact objCon:[Select Id from contact Limit 1]){
                objCon.LastName = 'test1';
                lstCon.add(objCon);             
            }
            system.debug('lstCon[5].LastName==> '+lstCon[5].LastName);                        
        }catch(Exception ex){
            nebula__LogEntryEvent__e objLog = new nebula__LogEntryEvent__e();
            objLog.Nebula__ComponentType__c  = 'Apex Method:testPlafFormEventLog';
            objLog.Nebula__Message__c  = 'Testing Plaform Event by Nebl logger';
            objLog.Nebula__ExceptionMessage__c   = 'Testing Plaform Event by Nebl logger';
            ApplicationLogHelper.createLog(objLog);
        }        
    }
}