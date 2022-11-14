/* Class name: OldIntegrationLogsDeleterSchedule
 * Author: Shirisha
 * Dated:11/17/2021
 * Description: This class will schedule the job 
 * */
public class OldIntegrationLogsDeleterSchedule implements Schedulable {
  public void execute(SchedulableContext  sc) {
        OldIntegrationLogsDeleter sb=new OldIntegrationLogsDeleter();
      database.executeBatch(sb,200);
    }
}