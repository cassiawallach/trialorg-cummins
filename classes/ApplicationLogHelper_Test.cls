@isTest
public class ApplicationLogHelper_Test {
	@isTest
    public static void logException_test1(){
        try{
        	integer i = 1/0;
        } catch(Exception ex){
        	ApplicationLogHelper.logException('ApplicationLogHelper_Test','Class', 'testLog', 'log','logAsssign', ex);
        }
    }
    
    @isTest
    public static void logException_test2(){
        try{
        	integer i = 1/0;
        } catch(Exception ex){
        	ApplicationLogHelper.logException('default','ApplicationLogHelper_Test','logException_test2', ex);
            ApplicationLogHelper.logException('default','ApplicationLogHelper_Test','logException_test2', ex);
            
        }
    }
    
    @isTest
    public static void logDMlException_test(){
       
        	Account acc = new Account();
            Database.SaveResult sr = Database.insert(acc, false);
            if(!sr.isSuccess()){
            	ApplicationLogHelper.logDMLException('default','ApplicationLogHelper_Test','logDMlException_test', sr.getErrors()[0]);
                
            }
            
        
    }
}