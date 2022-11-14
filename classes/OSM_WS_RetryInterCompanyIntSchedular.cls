global class OSM_WS_RetryInterCompanyIntSchedular implements Schedulable{
    public static String cron_exp = label.OSM_INTERCOMPANY_RETRY_CRON;  //Every hour
    
    
        global  void execute(System.SchedulableContext SC){
        OSM_WS_RetryInterCompanyInvoiceInt bjobs = new OSM_WS_RetryInterCompanyInvoiceInt();
        Database.executeBatch(bjobs,1);     
        OSM_WS_RetryInterCompanyDistInvoiceInt distJobs=new OSM_WS_RetryInterCompanyDistInvoiceInt();
        Database.executeBatch(distJobs,1); 
    }


}