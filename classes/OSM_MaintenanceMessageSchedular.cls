global class OSM_MaintenanceMessageSchedular implements Schedulable
{
 
    global void execute(SchedulableContext SC){
        OSMMaintenanceMessageBatch bjobs = new OSMMaintenanceMessageBatch();
        Database.executeBatch(bjobs,1);       
    }
}