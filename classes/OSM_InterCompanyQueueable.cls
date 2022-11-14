public class OSM_InterCompanyQueueable implements Queueable, Database.AllowsCallouts {
    Set<Id> set_OrderId_Intercompany;
    public OSM_InterCompanyQueueable(Set<Id> set_OrderIntercompany) {
        set_OrderId_Intercompany = set_OrderIntercompany;
    }
    
    public void execute(QueueableContext context) {
        try{
            OSM_SW_IntercompanyOrderInvoice.createIntercompnayOrderAndInvoice(set_OrderId_Intercompany);
        } catch(Exception exc){
            system.debug('Exception >>>>   '+exc);
        }
    }
}