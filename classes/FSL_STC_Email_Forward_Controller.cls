public with sharing class FSL_STC_Email_Forward_Controller {
    public Id stcId {get; set;}  
    public EmailMessage stc {get; set;}
    public EmailMessage getmessage (){
     
        return  [Select id, HtmlBody from EmailMessage  where id = :stcId limit 1  ];
        
    }
    
   /* public FSL_STC_Email_Forward_Controller()
    {
        system.debug('stcId++++'+stcId);
        if(stcId != null){
            stc =  [SELECT id,HtmlBody FROM EmailMessage where id = :stcId limit 1 ];
            //list<workOrder> body=[SELECT Id,(select id,(select HtmlBody from EmailMessages) from cases)  FROM WorkOrderwhere STC_Emil_Message_id__c = : conId];
            //return stc;
            system.debug('stc++++'+stc);
        }
    } */
}