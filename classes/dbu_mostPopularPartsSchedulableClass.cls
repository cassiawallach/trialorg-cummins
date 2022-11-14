global class dbu_mostPopularPartsSchedulableClass implements Schedulable
{
    //@ReadOnly 
    global void execute (SchedulableContext ctx)
    {
        dbu_mostPopularPartsBatch objmpp = new dbu_mostPopularPartsBatch(); 
        Database.executeBatch(objmpp); 
    } 
}