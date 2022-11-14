/**********************************************************************
Name:  OSM_AccounGroupScheduler
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
This is schedule class to update account groups and runs daily 3 AM EST

=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            				DATE              DETAIL                                
1.0 -   Saikomal Kattmudi            14/03/2020     INITIAL DEVELOPMENT          
*************************************************************/
global class OSM_AccounGroupScheduler implements Schedulable{
    public static String cron_exp = '0 0 3 * * ?';
    
    
    global  void execute(System.SchedulableContext SC){
        OSM_AutopopulateAccountGroups  obj = new OSM_AutopopulateAccountGroups ();
        Database.executeBatch(obj,1);
    }
}