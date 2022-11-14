@isTest
public class dbu_NotifyMeEmailScheduller_Test {
	
    @isTest
    static void executeTest(){
        
        SchedulableContext sc = null;
        dbu_NotifyMeEmailScheduller eachscheduller = new dbu_NotifyMeEmailScheduller();
        eachscheduller.execute(sc);
    }
    
}