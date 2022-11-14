global class FSL_NightlyComm_ScheduleBatchJobs{
    
    global void schedule_Send_Communication_Nightly_BMS(){
        String cron_exp = '0 0 3 * * ? *';
        
        FSL_Send_Com_Nightly_BMS_Schedular sc = new FSL_Send_Com_Nightly_BMS_Schedular();
        system.schedule('schedule_Send_Communication_Nightly_BMS', cron_exp, sc);
    }
    global void schedule_Send_Communication_Nightly_MOVEX(){
        String cron_exp = '0 0 13 * * ? *';
        
        FSL_Send_Com_Nightly_MOVEX_Schedular sc = new FSL_Send_Com_Nightly_MOVEX_Schedular();
        system.schedule('schedule_Send_Communication_Nightly_MOVEX', cron_exp, sc);
    }
    global void schedule_Send_Communication_Nightly_MOVEXMYD(){
        String cron_exp = '0 0 13 * * ? *';
        
        FSL_Send_Com_Nightly_MOVEXMYD_Schedular  sc = new FSL_Send_Com_Nightly_MOVEXMYD_Schedular();
        system.schedule('schedule_Send_Communication_Nightly_MOVEXMYD', cron_exp, sc);
    }  
    global void schedule_Send_Communication_Nightly_MOVEXUK(){
        String cron_exp = '0 0 23 * * ? *';
        
        FSL_Send_Com_Nightly_MOVEXUK_Schedular  sc = new FSL_Send_Com_Nightly_MOVEXUK_Schedular();
        system.schedule('schedule_Send_Communication_Nightly_MOVEXUK', cron_exp, sc);
    }
}