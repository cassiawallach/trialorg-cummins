public class FSL_ServiceOrderCommunicationUtil {

    static final String FAILED = 'Failed: Insufficient Contact Data';
    //Below methods is to insert records into Communication Object based on the service order contacts
    
    @InvocableMethod(label='SendEmailCommunication' description='sends email' category='WorkOrder')
    public static void insertCommunicationRecords_New(List<String> Wids){
        system.debug('****wids'+wids);
        
        List<String> woInfo = Wids[0].Split(';');
        String woId = woInfo[0];
        String woCommName = woInfo[1];
        system.debug('****woCommName'+woCommName);
        List<ServiceOrderContact__c> servOrderCont = new List<ServiceOrderContact__c>();
        List<Service_Order_Communication__c> servOrderCommList = new List<Service_Order_Communication__c>();
        List<FSL_Nightly_Communications__c> servOrderNightlyComList = new List<FSL_Nightly_Communications__c>();
        Map<String,List<ServiceOrderContact__c>> socMap = new Map<String,List<ServiceOrderContact__c>>();
        List<WorkOrder> woList= new List<WorkOrder>();
        List<FSL_Communication_Language__mdt> commLangmdt;
        List<Work_Order_Communication__mdt> woComm = new List<Work_Order_Communication__mdt>();
        List<Case> updateCaseList = new List<Case>();
        Set<Id> woIds = new Set<Id>();
        List<String> woAdhocEmails = new List<String>();
        Boolean serOrderCommInsertionFlag = false;
        List<WorkOrder> woUpdateList = new List<WorkOrder>();
        if(Wids != null){
           /* for(Id i : Wids){
                woIds.add(i);
            }*/
        /*woList=[select id, Status,ContactId,Contact.Language_Preferences__c, Account.Language_Preference__c,Account.Lang_Pref_Code__c,ESN__c,Asset.Name,Asset.Unit_Number__c,Asset.VIN__c,CaseId,Service_Team_Contact__c,Service_Team_Contact__r.email, ServiceTerritory.Street,ServiceTerritory.city,ServiceTerritory.state,ServiceTerritory.postalcode,ServiceTerritory.Phone__c,ServiceTerritory.Country, Unit_Type__c, Fault_Code_Communication_Trigger__c, Make__c, Model__c, Payer__c,Payer__r.ERP_System__c,Payer__r.Language_Preference__c, Payer_ContactID__c,FSL_Additional_Email_Notifications__c from workorder where id =: Id.valueOf(woId)]; */
        woList = [SELECT id, Status,ContactId,Contact.Language_Preferences__c,Contact.Authorize_work_started__c,Contact.Troubleshooting_started__c, Contact.Service_Work_Completed__c,Contact.Equipment_available__c,Contact.Invoice_ready__c, Account.Language_Preference__c,
                    Account.Lang_Pref_Code__c,ESN__c,Asset.Name,Asset.Unit_Number__c,Asset.VIN__c,CaseId,Service_Team_Contact__c,
                    Service_Team_Contact__r.email, ServiceTerritory.Street,ServiceTerritory.city,ServiceTerritory.state,
                    ServiceTerritory.postalcode,ServiceTerritory.Phone__c,ServiceTerritory.Country, Unit_Type__c, 
                    Fault_Code_Communication_Trigger__c, Make__c, Model__c, Payer__c,Payer__r.ERP_System__c,
                    Payer__r.Language_Preference__c, Payer_ContactID__c,FSL_Additional_Email_Notifications__c,
                    Account.Troubleshooting_Started__c, Account.Authorize_Work_Started__c, Account.Service_Work_Completed__c, 
                    Account.Invoice_Ready__c, Account.Equipment_Available__c, CustomMessage__c,Communication_Type__c,
                    Account.Communication_Triggers__c,Contact.FSL_Comm_Triggers__c
                    FROM Workorder 
                    WHERE Id =: Id.valueOf(woId)];
        }
        
        if(WOList != null && WOList.size() > 0){
            if(WOList[0].FSL_Additional_Email_Notifications__c != null && WOList[0].FSL_Additional_Email_Notifications__c != ''){
                String woAdEmail = WOList[0].FSL_Additional_Email_Notifications__c;
                woAdhocEmails = woAdEmail.split(';');
            }
            
        }
        
        
        if(WOList!=null && WOList.size()>0){
            servOrderCont=[select id ,Payer_Contact__r.FSL_Comm_Triggers__c,Createddate, Service_Order__c,Payer_Contact__r.Lang_Pref_Code__c, Service_order__r.Communication_Type__c,Payer_Contact__r.Invoice_Ready__c,Payer_Contact__r.Equipment_Available__c,Payer_Contact__r.Authorize_work_started__c,Payer_Contact__r.Service_Work_Completed__c,Payer_Contact__r.Troubleshooting_started__c,Account_Contact__r.Language_Preferences__c,Service_Order__r.CustomMessage__c,Service_Order__r.Asset.Name,Service_order__r.Asset.Unit_Number__c, service_order__r.serviceTerritory.Name, Service_order__r.Asset.VIN__c,Service_order__r.ServiceTerritory.Street,Service_order__r.ServiceTerritory.State,Service_order__r.ServiceTerritory.city,Service_order__r.ServiceTerritory.country,Service_Order__r.ServiceTerritory.postalcode, Service_Order__r.ServiceTerritory.Phone__c, Payer_Contact__r.MailingAddress,Payer_Contact__r.Email, Language_Preferences__c,Service_Order__r.CaseId,Service_Order__r.Make__c,Service_Order__r.Model__c,Service_Order__r.Vehicle_Identification_Number__c,service_order__r.Service_Team_Contact__c,  Mobile_Phone__c, Service_Order__r.Unit_Type__c, Service_Order__r.ESN__c,Email_Notification_Frequency__c, Text_SMS_Notification_Frequency__c, Payer_Account__c, Payer_Account__r.ERP_System__c, Email__c, Opt_In__c, Service_Order__r.Status, Service_Order__r.Sub_Status__c 
                        ,Payer_Contact__r.Account.National_Account__c  FROM ServiceOrderContact__c 
                           WHERE Service_Order__c=: WOList[0].id];
        }
         woComm = [SELECT Id,DeveloperName,Event_Name__c,Email_Communication__c,Text_Communication__c FROM Work_Order_Communication__mdt WHERE DeveloperName =: woCommName ];

        system.debug('****servOrderCont'+servOrderCont);
         system.debug('****servOrderCont'+WOList);
        if(servOrderCont !=null && servOrderCont.size()>0){            
            List<ServiceOrderContact__c> emailtempList = new List<ServiceOrderContact__c>();
            List<ServiceOrderContact__c> texttempList = new List<ServiceOrderContact__c>();
            List<String> commTriggers = new List<String>();
            for(ServiceOrderContact__c soc :servOrderCont ){
                if(soc.Opt_In__c == True){
                    system.debug('*******-----********'+soc.Payer_Contact__r.FSL_Comm_Triggers__c);
                    system.debug('soc.Opt_In__c == '+ soc.Opt_In__c);
                    if(soc.Email_Notification_Frequency__c != '' || soc.Email_Notification_Frequency__c != null) {
                        emailtempList.add(soc);
                        system.debug('Email_Notification_Frequency__c::'+soc.Email_Notification_Frequency__c);
                    }
                    /**if((soc.Text_SMS_Notification_Frequency__c == 'Real-Time') &&
                    ((soc.Payer_Contact__r.Troubleshooting_started__c && woComm[0].Event_Name__c == 'Troubleshooting Started') ||
                        (soc.Payer_Contact__r.Authorize_Work_Started__c && woComm[0].Event_Name__c == 'Authorized Work Started')  ||
                        (soc.Payer_Contact__r.Service_Work_Completed__c && woComm[0].Event_Name__c == 'Service Work Completed')   ||
                        (soc.Payer_Contact__r.Equipment_Available__c && woComm[0].Event_Name__c == 'Equipment available')         ||
                        (soc.Payer_Contact__r.Invoice_Ready__c && woComm[0].Event_Name__c == 'Invoice Ready')))
                    { */
                    commTriggers = new List<String>();
                    if(soc.Payer_Contact__r.FSL_Comm_Triggers__c !=null){
                    commTriggers = soc.Payer_Contact__r.FSL_Comm_Triggers__c.Split(';');
                        system.debug('commTriggers___ '+commTriggers);
                    }
                    if((soc.Text_SMS_Notification_Frequency__c == 'Real-Time') &&
                    (commTriggers !=null && (commTriggers.contains(Label.FSL_CommTrigger_Troubleshooting_Started) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Troubleshooting_Started) ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Authorized_Work_Started  ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Authorized_Work_Started)  ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Service_Work_Completed ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Service_Work_Completed)   ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Equipment_Available) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_Available)         ||
                    // CT4-573, CT4-664 - Manual Communication - Trigger Toggles// Start
                     (commTriggers.contains(Label.FSL_CommTrigger_Equipment_ready_for_pickup) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_ready_for_pickup)         ||
                     (commTriggers.contains(Label.FSL_Service_work_Proceeding) && woComm[0].Event_Name__c == Label.FSL_Service_work_Proceeding)         ||
                       // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// End
                        (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Invoice_Ready)))
                    { 
                            System.debug('soc.Text_SMS_Notification_Frequency__c::'+ soc.Text_SMS_Notification_Frequency__c);
                            texttempList.add(soc);
                    }
                }                    
            }
            system.debug('****emailtempList'+servOrderCont+'***'+emailtempList.size());
            system.debug('****texttempList'+servOrderCont+'***'+texttempList.size());
            
            List<ServiceOrderContact__c> tempList;
            for(ServiceOrderContact__c soc :texttempList ){                
                if(socMap.containsKey(soc.Language_Preferences__c)){
                    tempList = socMap.get(soc.Language_Preferences__c);
                    tempList.add(soc);
                    socMap.put(soc.Language_Preferences__c, tempList);
                }
                else{
                    tempList = new List<ServiceOrderContact__c>();
                    tempList.add(soc);
                    socMap.put(soc.Language_Preferences__c, tempList);
                }
            }
            system.debug('****socMap'+socMap);
            commLangmdt = [select id,Language__c,Language_Code__c from FSL_Communication_Language__mdt];
            system.debug('===woCommName==='+woCommName);
          // woComm = [SELECT Id,DeveloperName,Event_Name__c,Email_Communication__c,Text_Communication__c FROM Work_Order_Communication__mdt WHERE DeveloperName =: woCommName ];
            system.debug('===woComm==='+woComm);
            Map<String,String> langCodeMap = new Map<String,string>();
            if(commLangmdt != null){
                for(FSL_Communication_Language__mdt cL : commLangmdt){
                    langCodeMap.put(cL.Language__c,cL.Language_Code__c);
                }
            }
            
            system.debug('****emailtempList'+emailtempList);
            if(emailtempList != null && emailtempList.size()>0){
                for(ServiceOrderContact__c soc :emailtempList ){
                    commTriggers = new List<String>();
                    if(soc.Payer_Contact__r.FSL_Comm_Triggers__c !=null){
                        commTriggers = soc.Payer_Contact__r.FSL_Comm_Triggers__c.Split(';');
                    }
                    system.debug('****soc'+soc);
                    //code for nightly communication : start
                    // Added by Madhavi P -- CT4-217 - to stop the Nightly Email communications Once the status is Closed or Work Completed. 
                    //if(soc.Email_Notification_Frequency__c == 'Nightly' || ( soc.service_order__r.status != 'Closed' && (soc.service_order__r.status != 'Repair' && soc.service_order__r.Sub_Status__c != 'Repair Complete' ) ) ) {
                    
                    /**if((soc.Email_Notification_Frequency__c == 'Nightly' ) &&
                    ((soc.Payer_Contact__r.Troubleshooting_started__c && woComm[0].Event_Name__c == 'Troubleshooting Started') ||
                        (soc.Payer_Contact__r.Authorize_Work_Started__c && woComm[0].Event_Name__c == 'Authorized Work Started')  ||
                        (soc.Payer_Contact__r.Service_Work_Completed__c && woComm[0].Event_Name__c == 'Service Work Completed')   ||
                        (soc.Payer_Contact__r.Equipment_Available__c && woComm[0].Event_Name__c == 'Equipment available')         ||
                        (soc.Payer_Contact__r.Invoice_Ready__c && woComm[0].Event_Name__c == 'Invoice Ready')))
                    
                    {*/
                    
                    if((soc.Email_Notification_Frequency__c == 'Nightly' ) &&
                    (commTriggers !=null && (commTriggers.contains(Label.FSL_CommTrigger_Troubleshooting_Started) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Troubleshooting_Started) ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Authorized_Work_Started ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Authorized_Work_Started)  ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Service_Work_Completed ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Service_Work_Completed)   ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Equipment_Available ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_Available)         ||
                     // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// Start
                     (commTriggers.contains(Label.FSL_CommTrigger_Equipment_ready_for_pickup) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_ready_for_pickup)         ||
                     (commTriggers.contains(Label.FSL_Service_work_Proceeding) && woComm[0].Event_Name__c == Label.FSL_Service_work_Proceeding)         ||
                   // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// End
                   (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Invoice_Ready)))
                    
                    {
                         
                             
                   FSL_Nightly_Communications__c ncobj= new FSL_Nightly_Communications__c();
                     String userTimeZone = UserInfo.getTimeZone().getDisplayName(); //CT4-897 Equipment Available date

                        ncobj.Active__c = true;
                        ncobj.Service_Request__c= soc.Service_Order__r.CaseId;
                        system.debug('****soc.Service_Order__r.CaseId'+soc);
                        ncobj.Language_Preference__c=soc.Language_Preferences__c;
                        ncobj.Service_Order__c=soc.Service_Order__c;
                        ncobj.Event__c=woComm[0].Event_Name__c;
                        //CT4-897 Start - Equipment Available date
                        if(userTimeZone.contains('Australia')) {
                            ncobj.User_date__c = Date.ValueOf(System.now().format('yyyy-MM-dd', 'Australia/Melbourne'));
                        } else if (userTimeZone.contains('Europe')) {
                            ncobj.User_date__c = Date.ValueOf(System.now().format('yyyy-MM-dd', 'Europe/London'));
                        } else if (userTimeZone.contains('Asia')) {
                            ncobj.User_date__c = Date.ValueOf(System.now().format('yyyy-MM-dd', 'Asia/Kuala_Lumpur'));
                        } else {
                            ncobj.User_date__c = Date.ValueOf(System.now().format('yyyy-MM-dd', 'America/Newyork'));                          
                        }                           
                        //CT4-897 End -Equipment Available date
                        ncobj.Asset__c=soc.Service_Order__r.Asset.Name;
                        ncobj.Sent_From__c = 'DONOTREPLY@cummins.com';
                        String territoryCity = soc.Service_Order__r.ServiceTerritory.city;
                        String territoryState = soc.Service_Order__r.ServiceTerritory.state;
                        ncobj.Nightly_Service_Teritory__c = territoryCity + ', '+territoryState;
                        ncobj.Teritory_Branch_Phone__c = soc.Service_Order__r.ServiceTerritory.Phone__c;
                        ncObj.Service_Team_Contact__c = soc.Service_Order__r.Service_Team_Contact__c;
                        ncobj.Service_Status__c=woComm[0].Email_Communication__c;
                        // CT4-573 - Manual Communication - Custom Message// Start
                        if(soc.Service_Order__r.Communication_Type__c == 'Manual Communication')
                        {
                        ncobj.Custom_Message__c = soc.Service_Order__r.CustomMessage__c;
                        }
                        // CT4-573 - Manual Communication - Custom Message// End
                        DateTime d = ncobj.User_date__c;
                        String dateStr =  d.formatGmt('MM/dd/yyyy');
                        if(woCommName=='Equipment_available'){
                           ncobj.Service_Status__c = ncobj.Service_Status__c +' '+dateStr;
                        }
                        ncobj.VIN__c=soc.Service_Order__r.Asset.VIN__c;
                        ncobj.Unit_Number__c= soc.Service_Order__r.Asset.Unit_Number__c;
                        ncobj.Model__c=soc.Service_Order__r.Model__c;
                        ncobj.Make__c=soc.Service_Order__r.Make__c;
                        ncobj.Target_Email_Address__c=soc.Payer_Contact__r.Email;
                        //CT4-689
                        ncobj.National_Account__c = soc.Payer_Contact__r.Account.National_Account__c;
                        //CT4-689
                        ncobj.Contact__c=soc.Payer_Contact__r.id;
                        servOrderNightlyComList.add(ncobj);
                        system.debug('****servOrderNightlyComList'  +servOrderNightlyComList);
                        //code for nightly communication : End
                             }   
                    /**else if((soc.Email_Notification_Frequency__c == 'Real-Time') && 
                            ((soc.Payer_Contact__r.Troubleshooting_started__c && woComm[0].Event_Name__c == 'Troubleshooting Started') ||
                             (soc.Payer_Contact__r.Authorize_Work_Started__c && woComm[0].Event_Name__c == 'Authorized Work Started')  ||
                             (soc.Payer_Contact__r.Service_Work_Completed__c && woComm[0].Event_Name__c == 'Service Work Completed')   ||
                             (soc.Payer_Contact__r.Equipment_Available__c && woComm[0].Event_Name__c == 'Equipment available')         ||
                             (soc.Payer_Contact__r.Invoice_Ready__c && woComm[0].Event_Name__c == 'Invoice Ready')))
                    {  */         
                    else if((soc.Email_Notification_Frequency__c == 'Real-Time') && 
                        (commTriggers !=null && (commTriggers.contains(Label.FSL_CommTrigger_Troubleshooting_Started ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Troubleshooting_Started) ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Authorized_Work_Started) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Authorized_Work_Started)  ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Service_Work_Completed) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Service_Work_Completed)   ||
                        (commTriggers.contains(Label.FSL_CommTrigger_Equipment_Available) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_Available)         ||
                        // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// Start
                         (commTriggers.contains(Label.FSL_CommTrigger_Equipment_ready_for_pickup) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_ready_for_pickup)         ||
                         (commTriggers.contains(Label.FSL_Service_work_Proceeding) && woComm[0].Event_Name__c == Label.FSL_Service_work_Proceeding)         ||
                        // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// End
                         (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Invoice_Ready)))
                            /*(!soc.Authorize_Work_Started__c && woComm[0].Event_Name__c == 'Authorized Work Started' ||
                             !soc.Equipment_available__c && woComm[0].Event_Name__c == 'Equipment available'||
                             !soc.Troubleshooting_started__c && woComm[0].Event_Name__c == 'Troubleshooting Started'||
                             !soc.Equipment_Available__c ||
                             !soc.Service_Work_Completed__c && woComm[0].Event_Name__c == 'Service Work Completed' ||
                             !soc.Invoice_Ready__c
                            ) */
                      
                            
                    {
                        system.debug('========211======');  
                        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        socObj.Action__c = 'email';
                        socObj.Contact__c=soc.Payer_Contact__r.id;
                        socObj.Service_Order__c = soc.Service_Order__c;
                        socObj.Communication_Trigger_Name__c = woComm[0].Event_Name__c;//Need to check on the mapping
                        String City = soc.Service_Order__r.ServiceTerritory.city;
                        //String Street = soc.Service_Order__r.ServiceTerritory.street;
                        String State = soc.Service_Order__r.ServiceTerritory.state;
                        //String Country = soc.Service_Order__r.ServiceTerritory.country;
                        //String postCode = soc.Service_Order__r.ServiceTerritory.postalcode;                    
                        //String address = ((City != null && City != '')?City:'')+((Street != null && Street != '')?street:'')+((State != null && State != '')?State:'')+((Country != null && Country != '')?Country:'')+((postCode != null && postCode != '')?postCode:'');
                        socObj.Address__c = City + ' '+State;
                        socObj.ERP__c = soc.Payer_Account__r.ERP_System__c;
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        // CT4-573 - Manual Communication -Custom Message// Start
                        if(soc.Service_Order__r.Communication_Type__c == 'Manual Communication')
                        {
                        socObj.Custom_Message__c = soc.Service_Order__r.CustomMessage__c;
                        }
                        
                        // CT4-573 - Manual Communication - Custom Message// End
                        if(langCodeMap != null){
                            socObj.Language__c = langCodeMap.get(soc.Language_Preferences__c);
                            socObj.Communication_Language__c = soc.Language_Preferences__c;
                            socObj.Lang_Pref_Codes__c = soc.Payer_Contact__r.Lang_Pref_Code__c;
                        }
                            
                        socObj.Make__c = soc.Service_Order__r.Make__c;
                        socObj.Model__c = soc.Service_Order__r.Model__c;
                        socObj.Phone_Number__c = soc.Service_Order__r.ServiceTerritory.Phone__c; 
                        socObj.Product_Serial_Number__c = soc.Service_Order__r.Asset.Name;
                        socObj.VIN__c =  soc.Service_Order__r.Asset.VIN__c;
                        socObj.Unit__c = soc.Service_Order__r.Asset.Unit_Number__c;
                        socObj.Service_Request__c = soc.Service_Order__r.CaseId;
                        socObj.Service_Status__c =woComm[0].Email_Communication__c;
                        DateTime d = Date.Today() ;
                        String dateStr =  d.formatGmt('MM/dd/yyyy');
                        if(woCommName=='Equipment_available'){
                           socObj.Service_Status__c = socObj.Service_Status__c +' '+dateStr;
                        }
                        socObj.Target_Email_Address__c = soc.Payer_Contact__r.Email;
                        socObj.Forward_An_Email_To_STC__c=woList[0].Service_Team_Contact__r.email;
                        socObj.Target_Email_Cc_Address__c = soc.Payer_Contact__r.Email;//Need to check the mapping here
                        socObj.Target_Phone_Number__c = soc.Mobile_Phone__c;//Need to check the mapping here
                        socObj.Service_Request__c = soc.Service_Order__r.caseId;
                        socObj.Recipient__c = soc.Payer_Contact__r.Email;
                        socObj.Sender_App_Name__c = 'Guidanz';
                        // socObj.Status__c = 'Sent';
                        //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                        socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                        //CT4-689
                        socObj.National_Account__c = soc.Payer_Contact__r.Account.National_Account__c;
                        //CT4-689
                        servOrderCommList.add(socObj);
                    }    
                                    
                }
            }
            system.debug('====servOrderCommList====='+servOrderCommList);
            // This logic is for Adhoc Email communication
           // Boolean StcForwardEmailFlag=true;
            system.debug('====== woAdhocEmails ===='+woAdhocEmails);
            system.debug(woList[0].Account.Troubleshooting_Started__c+'******====*******'+woComm[0].Event_Name__c);
            if(woAdhocEmails != null && woAdhocEmails.size() > 0){
               List<String> accCommTriggers = new List<String>();
               for(String woEmailInfo : woAdhocEmails){
                   accCommTriggers = new List<String>();
                   if(woList[0].Account.Communication_Triggers__c !=null)
                   accCommTriggers = woList[0].Account.Communication_Triggers__c.split(';');
                    //if any of the conditions are met, skip it from insertion for story CT4-272
                   /**
                    if(!woList[0].Account.Troubleshooting_Started__c && woComm[0].Event_Name__c == 'Troubleshooting Started' ||
                    !woList[0].Account.Authorize_Work_Started__c && woComm[0].Event_Name__c == 'Authorized Work Started' || 
                    !woList[0].Account.Equipment_Available__c && woComm[0].Event_Name__c == 'Equipment Available' ||
                    !woList[0].Account.Service_Work_Completed__c && woComm[0].Event_Name__c == 'Service Work Completed'|| 
                    !woList[0].Account.Invoice_Ready__c && woComm[0].Event_Name__c == 'Invoice Ready') 
                    */
                    if(accCommTriggers !=null && (!accCommTriggers.contains(Label.FSL_CommTrigger_Troubleshooting_Started) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Troubleshooting_Started ||
                       !accCommTriggers.contains(Label.FSL_CommTrigger_Authorized_Work_Started ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Authorized_Work_Started || 
                       !accCommTriggers.contains(Label.FSL_CommTrigger_Equipment_Available ) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_Available ||
                       !accCommTriggers.contains(Label.FSL_CommTrigger_Service_Work_Completed) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Service_Work_Completed|| 
                      // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// Start
                       !accCommTriggers.contains(Label.FSL_CommTrigger_Equipment_ready_for_pickup) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Equipment_ready_for_pickup        ||    
                       !accCommTriggers.contains(Label.FSL_Service_work_Proceeding) && woComm[0].Event_Name__c == Label.FSL_Service_work_Proceeding       ||
                      // CT4-573,CT4-664 - Manual Communication - Trigger Toggles// End
                       !accCommTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready) && woComm[0].Event_Name__c == Label.FSL_CommTrigger_Invoice_Ready)) 
                        continue;
                   Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                   socObj.Action__c = 'email';
                   socObj.Service_Order__c = woList[0].Id;
                   socObj.Communication_Trigger_Name__c = woComm[0].Event_Name__c;//Need to check on the mapping
                   String City = woList[0].ServiceTerritory.city;
                  // String Street = woList[0].ServiceTerritory.street;
                   String State = woList[0].ServiceTerritory.state;
                  // String Country = woList[0].ServiceTerritory.country;
                  // String postCode = woList[0].ServiceTerritory.postalcode;                    
                  // String address = ((City != null && City != '')?City:'')+((Street != null && Street != '')?street:'')+((State != null && State != '')?State:'')+((Country != null && Country != '')?Country:'')+((postCode != null && postCode != '')?postCode:'');
                   socObj.Address__c = City + ' '+State;
                   socObj.ERP__c = woList[0].Payer__r.ERP_System__c;
                   socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                   socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                   socObj.Language__c = woList[0].Account.Language_Preference__c;
                    socObj.Communication_Language__c = woList[0].Account.Language_Preference__c;
                    socObj.Lang_Pref_Codes__c = woList[0].Account.Lang_Pref_Code__c;
                   //socObj.Language__c = (woList[0].Account.Language_Preference__c != null && woList[0].Account.Language_Preference__c != '') ? woList[0].Account.Language_Preference__c : 'English';
                   //socObj.Communication_Language__c = (woList[0].Account.Language_Preference__c != null && woList[0].Account.Language_Preference__c != '') ? woList[0].Account.Language_Preference__c : 'English';
                    
                    socObj.Make__c = woList[0].Make__c;
                    socObj.Model__c = woList[0].Model__c;
                    socObj.Phone_Number__c = woList[0].ServiceTerritory.Phone__c; 
                    socObj.Product_Serial_Number__c = woList[0].Asset.Name;
                    socObj.VIN__c =  woList[0].Asset.VIN__c;
                    socObj.Unit__c = woList[0].Asset.Unit_Number__c;
                    socObj.Service_Request__c = woList[0].CaseId;
                    socObj.Service_Status__c =woComm[0].Email_Communication__c;
                   DateTime d = Date.Today() ;
                        String dateStr =  d.formatGmt('MM/dd/yyyy');
                        if(woCommName=='Equipment_available'){
                           socObj.Service_Status__c = socObj.Service_Status__c +' '+dateStr;
                        }
                    socObj.Target_Email_Address__c = woEmailInfo;
                    socObj.Recipient__c = woEmailInfo;
                    socObj.Target_Email_Cc_Address__c = woEmailInfo;//Need to check the mapping here
                    //socObj.Target_Phone_Number__c = woList[0].Mobile_Phone__c;//Need to check the mapping here
                    socObj.Service_Request__c = woList[0].caseId;
                    socObj.Sender_App_Name__c = 'Guidanz';
                    // socObj.Status__c = 'Sent';
                    //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                    socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                    socObj.Custom_Message__c = woList[0].CustomMessage__c;
                    servOrderCommList.add(socObj);
                }
                
            }
                        
            
            system.debug('****servOrderCommList1111111'+servOrderCommList);
            if(socMap != null){
                system.debug('**inside socMap');
                List<ServiceOrderContact__c> tmpList;
                for(String s :socMap.keySet()){
                    tmpList=socMap.get(s);
                    if(tmpList.size()==1){
                        system.debug('**tmpListsize1***'+tmpList);
                        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        String phoneNos;
                        system.debug('**inside else socMap'+tmpList);
                        for(ServiceOrderContact__c soc: tmpList){
                            if(phoneNos != '' && phoneNos !=null){
                                phoneNos= phoneNos+','+soc.Mobile_Phone__c;
                            }else{
                               phoneNos= soc.Mobile_Phone__c;
                            }
                        }
                        socObj.Action__c = 'sms';
                        socObj.Service_Order__c = tmpList[0].Service_Order__c;
                        socObj.Communication_Trigger_Name__c = woComm[0].Event_Name__c;//Need to check on the mapping
                       
                        String addressForSms = tempList[0].Service_Order__r.ServiceTerritory.city+' ,'+tempList[0].Service_Order__r.ServiceTerritory.State;
                        socObj.Recipient__c  = phoneNos;
                        socObj.Address__c = addressForSms;
                        socObj.ERP__c = tmpList[0].Payer_Account__r.ERP_System__c;
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        
                        if(langCodeMap != null){
                             socObj.Language__c = langCodeMap.get(tmpList[0].Language_Preferences__c);
                            socObj.Communication_Language__c = tmpList[0].Language_Preferences__c;
                        }
                           
                        
                        socObj.Make__c = tmpList[0].Service_Order__r.Make__c;
                        socObj.Model__c = tmpList[0].Service_Order__r.Model__c;
                        //socObj.Phone_Number__c = tmpList[0].Mobile_Phone__c;
                        socObj.Phone_Number__c = tmpList[0].Service_Order__r.ServiceTerritory.Phone__c;
                        socObj.Product_Serial_Number__c = tmpList[0].Service_Order__r.Asset.Name;
                        socObj.VIN__c = tmpList[0].Service_Order__r.Asset.VIN__c;
                        socObj.Unit__c = tmpList[0].Service_Order__r.Asset.Unit_Number__c;
                        socObj.Service_Request__c = tmpList[0].Service_Order__r.CaseId;
                        
                        socObj.Service_Status__c =woComm[0].Text_Communication__c;
                        //As part of CT4-766 - Start;
                        DateTime d = Datetime.now() ;
                        String dateStr = (d.day())+' '+d.format('MMMM')+' '+(d.year());
                        if(woCommName=='Equipment_available'){
                           socObj.Service_Status__c = socObj.Service_Status__c +' '+dateStr;
                        }
                        socObj.Target_Email_Address__c = tmpList[0].Payer_Contact__r.Email;
                        socObj.Target_Email_Cc_Address__c = tmpList[0].Payer_Contact__r.Email;//Need to check the mapping here
                        socObj.Target_Phone_Number__c = tmpList[0].Mobile_Phone__c;//Need to check the mapping here
                        socObj.Sender_App_Name__c = 'Guidanz';
                        // socObj.Status__c = 'Sent';
                        //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                        socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                        servOrderCommList.add(socObj);                            
                    }   
                    else{
                        String phoneNos;
                        system.debug('**inside else socMap'+tmpList);
                        for(ServiceOrderContact__c soc: tmpList){
                            if(phoneNos != '' && phoneNos !=null){
                                phoneNos= phoneNos+','+soc.Mobile_Phone__c;
                            }else{
                               phoneNos= soc.Mobile_Phone__c;
                            }
                        }
                        system.debug('**phoneNos'+phoneNos);
                        Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                        socObj.Action__c = 'sms';
                        socObj.Service_Order__c = tmpList[0].Service_Order__c;
                        socObj.Communication_Trigger_Name__c = woComm[0].Event_Name__c;//Need to check on the mapping
                        
                        String addressForSms = tempList[0].Service_Order__r.ServiceTerritory.city+' ,'+tempList[0].Service_Order__r.ServiceTerritory.State;
                        socObj.Address__c = addressForSms;
                        socObj.ERP__c = tmpList[0].Payer_Account__r.ERP_System__c;
                        socObj.Event_Type__c = 'Service_Status_Change';//Need to check on the mapping
                        socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                        
                        if(langCodeMap != null){
                            socObj.Language__c = langCodeMap.get(tmpList[0].Language_Preferences__c);
                            socObj.Communication_Language__c = tmpList[0].Language_Preferences__c;
                        }
                            
                        
                        socObj.Make__c = tmpList[0].Service_Order__r.Make__c;
                        socObj.Model__c = tmpList[0].Service_Order__r.Model__c;
                        //socObj.Phone_Number__c = phoneNos;
                        socObj.Phone_Number__c = tmpList[0].Service_Order__r.ServiceTerritory.Phone__c;
                        socObj.Product_Serial_Number__c = tmpList[0].Service_Order__r.Asset.Name;
                        socObj.VIN__c = tmpList[0].Service_Order__r.Asset.VIN__c;
                        socObj.Unit__c = tmpList[0].Service_Order__r.Asset.Unit_Number__c;
                        socObj.Service_Request__c = tmpList[0].Service_Order__r.CaseId;
                        socObj.Service_Status__c =woComm[0].Text_Communication__c;
                        //As part of CT4-766 - Start;
                        DateTime d = Datetime.now() ;
                        String dateStr = (d.day())+' '+d.format('MMMM')+' '+(d.year());
                        if(woCommName=='Equipment_available'){
                           socObj.Service_Status__c = socObj.Service_Status__c +' '+dateStr;
                        }
                        socObj.Target_Email_Address__c = tmpList[0].Payer_Contact__r.Email;
                        socObj.Target_Email_Cc_Address__c = tmpList[0].Payer_Contact__r.Email;//Need to check the mapping here
                        socObj.Target_Phone_Number__c = phoneNos;//Need to check the mapping here
                        socObj.Sender_App_Name__c = 'Guidanz';
                        // socObj.Status__c = 'Sent';
                        //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                        socObj.Recipient__c  = phoneNos; 
                        socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                        servOrderCommList.add(socObj);
                    }
                }
            }            
        

        //code for nightly communication : start
        if(servOrderNightlyComList != null && servOrderNightlyComList.size() > 0) {
            Database.SaveResult[] srList = Database.Insert(servOrderNightlyComList,false);
            System.debug('-------------------------srList' +srList);
            for(Database.SaveResult sr : srList){
                if (sr.isSuccess()) {
                     serOrderCommInsertionFlag = true;                     
                }else {
                    for(Database.Error err : sr.getErrors()){
                         System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
        //code for nightly communication : End
        
       ///start story ---- CT4-218------ 
       
      /* List<FSL_Nightly_Communications__c>  nigtlycomm1 = new List<FSL_Nightly_Communications__c>();
        List<FSL_Nightly_Communications__c> Listsnigtlycomm1 = new List<FSL_Nightly_Communications__c>();
        if(WOList!=null && WOList.size()>0){
            nigtlycomm1=[select id ,Active__c,Service_Order__c,Service_Order__r.Sub_Status__c,Service_Order__r.Status from FSL_Nightly_Communications__c where Service_Order__c=: WOList[0].id AND (Event__c='Authorized Work Started' OR Event__c='Troubleshooting Started' OR Event__c='Equipment available' Event__c='Service Work Completed') ];
        }
        if(woCommName == 'Equipment_ready_for_pickup') {
            for(FSL_Nightly_Communications__c lstsoc :nigtlycomm1){
                lstsoc.Active__c=false;
                Listsnigtlycomm1.add(lstsoc);
            }
        }
        update Listsnigtlycomm1;
        

        List<FSL_Nightly_Communications__c> ListNigtlyComm = new List<FSL_Nightly_Communications__c>();
        List<FSL_Nightly_Communications__c> ListtoUpdateNigtlycomm = new List<FSL_Nightly_Communications__c>();
        if(WOList!=null && WOList.size()>0){
            ListNigtlyComm=[select id ,Active__c,Service_Order__c,Service_Order__r.Sub_Status__c,Service_Order__r.Status from FSL_Nightly_Communications__c where Service_Order__c=: WOList[0].id ];
        }
        if(ListNigtlyComm != null && ListNigtlyComm.size() > 0){
             if(woCommName == 'Authorized_Work_Started') {
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                        lstsoc.Active__c=false;
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }
                else if(woCommName == 'Service_Work_Completed') {
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                        lstsoc.Active__c=false;
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }*/
                /*else if(woCommName == 'Equipment_ready_for_pickup') {
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                        lstsoc.Active__c=false;
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }*/
                /*else if(woCommName == 'Troubleshooting_Started') {
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                        lstsoc.Active__c=false;
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }
                else if(woCommName == 'Equipment_available') {
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                        lstsoc.Active__c=false;
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }
        }
        
        if(ListtoUpdateNigtlycomm.size()>0)
                update ListtoUpdateNigtlycomm;*/
            
        List<FSL_Nightly_Communications__c> ListNigtlyComm = new List<FSL_Nightly_Communications__c>();
        List<FSL_Nightly_Communications__c> ListNigtlyComm1 = new List<FSL_Nightly_Communications__c>();
        List<FSL_Nightly_Communications__c> ListtoUpdateNigtlycomm = new List<FSL_Nightly_Communications__c>();
            if(WOList!=null && WOList.size()>0){
                ListNigtlyComm =[select id ,Active__c,Service_Order__c,Service_Order__r.Sub_Status__c,Service_Order__r.Status, Event__c,CreatedDate  from FSL_Nightly_Communications__c where Service_Order__c=: WOList[0].id ORDER BY CreatedDate DESC];
                
                if(ListNigtlyComm .size() > 0){
                    boolean skiptheflow = false;
                    // ListNigtlyComm.remove(0);
                    for(FSL_Nightly_Communications__c lstsoc :ListNigtlyComm){
                       // String statusValue =  ListNigtlyComm[0].Event__c;
                        if(lstsoc.Event__c == ListNigtlyComm[0].Event__c && !skiptheflow ){
                            lstsoc.Active__c = true;
                        }
                        else {
                            skiptheflow = true;
                            lstsoc.Active__c=false;
                        }
                        
                        ListtoUpdateNigtlycomm.add(lstsoc);
                    }
                }
            }

            System.debug('ListNigtlyComm***  '+ListNigtlyComm);
               
            if(ListtoUpdateNigtlycomm.size()>0)
              update ListtoUpdateNigtlycomm;
       
       ///End story ---- CT4-218------ 
    
        
         System.debug('servOrderCommList: ' + servOrderCommList);

        if(servOrderCommList != null && servOrderCommList.size()>0){
            Database.SaveResult[] srList = Database.Insert(servOrderCommList,false);
            for(Database.SaveResult sr : srList){
                if (sr.isSuccess()) {
                     serOrderCommInsertionFlag = true;                     
                }else{
                    for(Database.Error err : sr.getErrors()){
                         System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
            
        }
        if(woList.size() > 0 && serOrderCommInsertionFlag == true){
            WorkOrder woUpdate = new WorkOrder();
            woUpdate.Id = woList[0].Id;
            if(woCommName == 'Troubleshooting_Started') {
               woUpdate.Fault_Code_Communication_Trigger__c = true;
            }else if(woCommName == 'Service_Work_Completed'){
               woUpdate.Service_Work_Completed__c = true;
            }else if(woCommName == 'Authorized_Work_Started') { 
                   woUpdate.Authorized_Work_Started__c = true;
            }else if(woCommName == 'Equipment_available') { 
                   woUpdate.Equipment_available__c = true;
            }
            
          // woUpdate.STC_Email_Value__c = woList[0].Service_Team_Contact__r.email;
            //System.debug('woUpdate.STC_Email_Value__c  '+woUpdate.STC_Email_Value__c );
            
            woUpdateList.add(woUpdate);
            
            if(woUpdateList.size()>0)
                update woUpdateList;
        }
    }
    
}
    
    
    public static void insertCommunicationRecordsFromBMS(Set<String> conIds, String refNumber){
    
       List<Service_Order_Communication__c> socList = new  List<Service_Order_Communication__c>();
       List<FSL_Nightly_Communications__c>  ncList = new  List<FSL_Nightly_Communications__c>(); 
       List<FSL_Nightly_Communications__c>  updatencList = new  List<FSL_Nightly_Communications__c>();
       Set<id> contactIds = new Set<id>();
       List<FSL_Communication_Language__mdt> commLangmdtText;
       String  woComm = [SELECT Id,DeveloperName,Event_Name__c,Email_Communication__c,Text_Communication__c FROM Work_Order_Communication__mdt WHERE DeveloperName = 'Invoice_Ready' ].Email_Communication__c;       
       WorkOrder serviceorder = [SELECT Id, Service_Team_Contact__c,
                    Service_Team_Contact__r.email,AssetId, Asset.Name, Make__c, Model__c, Contact.Lang_Pref_Code__c,Asset.Unit_Number__c, Asset.VIN__c, Case.Id,Payer_ContactID__r.Email,ServiceTerritory.Phone__c,ServiceTerritory.city,ServiceTerritory.state, Invoice_Generated__c FROM WorkOrder where Shop_Work_Order__c =: refNumber Limit 1];
       Map<String,List<Contact>> conMap = new Map<String,List<Contact>>();
       Map<String,String> mobilePhoneMap = new Map<String,String>();
       List<Contact> tempList;
        
        For(Contact  conList : [SELECT Id, MobilePhone,FSL_Comm_Triggers__c,Invoice_Ready__c, Text_SMS_Notification_Frequency__c, Email,Email_Notification_Frequency__c,FSL_Contact_Id__c,Language_Preferences__c,Lang_Pref_Code__c  FROM Contact WHERE FSL_Contact_Id__c IN : conIds ]){
            
            System.debug('contact list  '+conList );
            contactIds.add(conList.id);
            List<String> commTriggers = new List<String>();
            if(conList.FSL_Comm_Triggers__c !=null){
                commTriggers = conList.FSL_Comm_Triggers__c.Split(';');
            }
            
            if(((conList.Email_Notification_Frequency__c == 'Real-Time') && (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready)))  || Test.isRunningTest()){            
            
                Service_Order_Communication__c socObj = new Service_Order_Communication__c(); 
                               
                socObj.Communication_Trigger_Name__c = 'Invoice Ready';                
                socObj.Service_Status__c = woComm;               
                socObj.Service_Order__c = serviceorder.Id;
                socObj.Product_Serial_Number__c = serviceorder.Asset.Name;
                socObj.Make__c = serviceorder.Make__c;
                socObj.Model__c = serviceorder.Model__c;
                socObj.Contact__c=conList.id;
                socObj.Unit__c = serviceorder.Asset.Unit_Number__c;  
                socObj.VIN__c =  serviceorder.Asset.VIN__c;
                socObj.Service_Request__c = serviceorder.Case.Id;           
                socObj.Recipient__c = conList.Email;
                socObj.Sender_App_Name__c = 'Guidanz';
                // socObj.Status__c = 'Sent'; 
                //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                socObj.ERP__c = refNumber;
                socObj.Target_Email_Address__c = conList.Email;
                socObj.Forward_An_Email_To_STC__c=serviceorder.Service_Team_Contact__r.email;
                socObj.Communication_Language__c = conList.Language_Preferences__c;
                //socObj.Lang_Pref_Codes__c = serviceorder.Contact.Lang_Pref_Code__c;
                socObj.Lang_Pref_Codes__c = conList.Lang_Pref_Code__c;
                socObj.Phone_Number__c = serviceorder.ServiceTerritory.Phone__c;
                socObj.Action__c = 'email';
                String City = serviceorder.ServiceTerritory.city;
                String State = serviceorder.ServiceTerritory.state;
                socObj.Address__c = City + ' '+State;
                
                 
                socList.add(socObj);
                
            }
            
            if(((conList.Text_SMS_Notification_Frequency__c == 'Real-Time') && (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready))) || Test.isRunningTest()){ 
 
                if(conMap.containsKey(conList.Language_Preferences__c)){
                    tempList = conMap.get(conList.Language_Preferences__c);
                    tempList.add(conList);
                    conMap.put(conList.Language_Preferences__c, tempList);
                }
                else{
                    tempList = new List<Contact>();
                    tempList.add(conList);
                    conMap.put(conList.Language_Preferences__c, tempList);
                }
          
            system.debug('****conMap '+conMap );
                        
           }     
           
                     
            
            if((conList.Email_Notification_Frequency__c == 'Nightly') && (commTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready))) {            
            
                FSL_Nightly_Communications__c ncObj = new FSL_Nightly_Communications__c();
                
                ncObj.Service_Order__c = serviceorder.Id;                
                ncObj.Service_Request__c = serviceorder.Case.Id;                 
                ncObj.Contact__c = conList.Id;
                ncObj.Active__c = true;              
                ncObj.Make__c = serviceorder.Make__c;
                ncObj.Model__c = serviceorder.Model__c;
                ncObj.VIN__c =  serviceorder.Asset.VIN__c;                
                ncObj.Unit_Number__c = serviceorder.Asset.Unit_Number__c;  
                ncObj.Asset__c = serviceorder.Asset.Name;
                ncObj.Event__c = 'Invoice Ready';
                ncObj.Service_Status__c = woComm;
                ncObj.Sent_From__c = 'DoNotReply@cummins.com';
                ncObj.Target_Email_Address__c = conList.Email;
                //ncObj.Forward_An_Email_To_STC__c=serviceorder.Service_Team_Contact__r.email;
                ncObj.Service_Team_Contact__c = serviceorder.Service_Team_Contact__c;
                ncList.add(ncObj);
                
            }
        } 
        
        
          List<Contact> tmpList;
                for(String s :conMap.keySet()){
                    tmpList=conMap.get(s);
                 
                        system.debug('**tmpListsize1***'+tmpList);
                        String phoneNos;
                        
                        for(Contact soc: tmpList){
                            if(phoneNos != '' && phoneNos !=null){
                                phoneNos= phoneNos+','+soc.MobilePhone;
                            }else{
                               phoneNos= soc.MobilePhone;
                            }
                        }
                        
              System.debug('@@@ phone number '+phoneNos); 
                       
              if(mobilePhoneMap.containsKey(s)){
                   
                    mobilePhoneMap.put(s, phoneNos);
                }
                else{
                    mobilePhoneMap.put(s, phoneNos);
                }   
        }
        
        
         System.debug('@@@mobilephonemap'+mobilePhoneMap); 
        
        commLangmdtText = [select id,Language__c,Language_Code__c from FSL_Communication_Language__mdt];
        Map<String,String> langCodeMapText = new Map<String,string>();
        if(commLangmdtText != null){
            for(FSL_Communication_Language__mdt cL : commLangmdtText){
                langCodeMapText.put(cL.Language__c,cL.Language_Code__c);
            }
        }
        
               
        for(String s :mobilePhoneMap.keySet()){
        
                    
                Service_Order_Communication__c socObj = new Service_Order_Communication__c(); 
                               
                socObj.Communication_Trigger_Name__c = 'Invoice Ready';                
                socObj.Service_Status__c = woComm;               
                socObj.Service_Order__c = serviceorder.Id;
                socObj.Product_Serial_Number__c = serviceorder.Asset.Name;
                socObj.Make__c = serviceorder.Make__c;
                socObj.Model__c = serviceorder.Model__c;
                socObj.Unit__c = serviceorder.Asset.Unit_Number__c;  
                socObj.VIN__c =  serviceorder.Asset.VIN__c;
                socObj.Service_Request__c = serviceorder.Case.Id;           
                socObj.Recipient__c = mobilePhoneMap.get(s);
                socObj.Sender_App_Name__c = 'Guidanz';
                //socObj.Contact__c=conList.id;
                // socObj.Status__c = 'Sent'; 
                //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                socObj.ERP__c = refNumber;
                //socObj.Target_Email_Address__c = conList.Email;
                socObj.Target_Phone_Number__c =  mobilePhoneMap.get(s);
                socObj.Communication_Language__c = s;
                socObj.Language__c = langCodeMapText.get(socObj.Communication_Language__c);
                socObj.Phone_Number__c = serviceorder.ServiceTerritory.Phone__c;
                socObj.Action__c = 'sms';
                socObj.Event_Type__c = 'Service_Status_Change';
                String City = serviceorder.ServiceTerritory.city;
                String State = serviceorder.ServiceTerritory.state;
                socObj.Address__c = City + ' '+State;
                 
                socList.add(socObj);
        
        }             
        
         If(!socList.isEmpty()){
             
             System.debug('@@@: List of Records   '+socList);   
             Insert socList; 
             System.debug('@@@: after insert of communication records   '+socList[0].id);   
             
        }
       
       /* For(FSL_Nightly_Communications__c fnc: [SELECT Id,Active__c,Contact__c,Service_Order__c FROM FSL_Nightly_Communications__c WHERE Contact__c IN: contactIds AND Service_Order__c =: serviceorder.id ]){
            
                System.debug('@@@: FNCCC   '+fnc);        
                fnc.Active__c = false;
                updatencList.add(fnc);
           
        }
        
       System.debug('@@@: update list before if  '+updatencList); 
       If(!updatencList.isEmpty()){  
             System.debug('@@@: update list   '+updatencList);
             Update updatencList; 
                        
        } */

         If(!ncList.isEmpty()){            
             Insert ncList; 
             System.debug('@@@: after insert of communication records   '+ncList[0].id);           
        }  
        //serviceorder.Invoice_Generated__c = true;
        serviceorder.Invoice_Ready_Text_Communication__c=true;
        update serviceorder;
        
    }
    ///start story ---- CT4-211------
   // public static void insertCommunicationRecordsFromBMS_Adhoc(Set<String> conIds, String refNumber, String InvoiceAdhocEmails){
     public static void insertCommunicationRecordsFromBMS_Adhoc(String refNumber, String InvoiceAdhocEmails){
        Boolean serOrderCommInsertionFlag = false;
        List<WorkOrder> woUpdateList = new List<WorkOrder>();
        List<String> woAdhocEmails = new List<String>();
        woAdhocEmails = InvoiceAdhocEmails.split(';');

       List<Service_Order_Communication__c> socList = new  List<Service_Order_Communication__c>();
       List<FSL_Nightly_Communications__c>  ncList = new  List<FSL_Nightly_Communications__c>(); 
       List<FSL_Nightly_Communications__c>  updatencList = new  List<FSL_Nightly_Communications__c>();
       Set<id> contactIds = new Set<id>();
       List<Work_Order_Communication__mdt>  woComm = [SELECT Id,DeveloperName,Event_Name__c,Email_Communication__c,Text_Communication__c 
                                                        FROM Work_Order_Communication__mdt
                                                        WHERE DeveloperName = 'Invoice_Ready' ];       
       WorkOrder serviceorder = [SELECT Id, Service_Team_Contact__c,Service_Team_Contact__r.Email,AssetId, Account.Invoice_Ready__c, Account.Lang_Pref_Code__c,Account.Language_Preference__c,
                                    Asset.Name, Make__c, Model__c, Asset.Unit_Number__c, Asset.VIN__c, Case.Id,Payer_ContactID__r.Email,
                                    ServiceTerritory.Phone__c,ServiceTerritory.city,ServiceTerritory.state, 
                                    Account.Communication_Triggers__c FROM WorkOrder 
                                    where Shop_Work_Order__c =: refNumber Limit 1];
        
         
        if(woAdhocEmails != null && woAdhocEmails.size() > 0){
            for(String woEmailInfo : woAdhocEmails){
                List<String> accCommTriggers = new List<String>();
                if(serviceorder.Account.Communication_Triggers__c !=null){
                    accCommTriggers = serviceorder.Account.Communication_Triggers__c.split(';');
                }
                if(!accCommTriggers.contains(Label.FSL_CommTrigger_Invoice_Ready) && woComm[0].Event_Name__c == 'Invoice Ready')
                    continue;
                Service_Order_Communication__c socObj = new Service_Order_Communication__c();
                    socObj.Communication_Trigger_Name__c = 'Invoice Ready';                
                    socObj.Service_Status__c = woComm[0].Email_Communication__c;            
                    socObj.Service_Order__c = serviceorder.Id;
                    socObj.Product_Serial_Number__c = serviceorder.Asset.Name;
                    socObj.Make__c = serviceorder.Make__c;
                    socObj.Model__c = serviceorder.Model__c;
                    socObj.Unit__c = serviceorder.Asset.Unit_Number__c;  
                    socObj.VIN__c =  serviceorder.Asset.VIN__c;
                    socObj.Service_Request__c = serviceorder.Case.Id;           
                    socObj.Recipient__c = woEmailInfo;
                    socObj.Target_Email_Cc_Address__c = woEmailInfo;
                    socObj.Sender_App_Name__c = 'Guidanz';
                    // socObj.Status__c = 'Sent'; 
                    //CT4-643: Mark Status as 'Failed' if Recipient is empty, else make it 'Sent'
                    socObj.Status__c = (socObj.Recipient__c == null || socObj.Recipient__c == '') ? FSL_ServiceOrderCommunicationUtil.FAILED : 'Sent';
                    socObj.ERP__c = refNumber;
                    socObj.Event_Type__c = 'Service_Status_Change';
                    socObj.From_Address__c = 'DONOTREPLY@cummins.com';
                    socObj.Language__c = serviceorder.Account.Language_Preference__c;
                    socObj.Communication_Language__c = serviceorder.Account.Language_Preference__c;
                    socObj.Lang_Pref_Codes__c = serviceorder.Account.Lang_Pref_Code__c;
                    //socObj.Language__c = (serviceorder.Account.Language_Preference__c != null && serviceorder.Account.Language_Preference__c != '') ? serviceorder.Account.Language_Preference__c : 'English';
                    //socObj.Communication_Language__c = (serviceorder.Account.Language_Preference__c != null && serviceorder.Account.Language_Preference__c != '') ? serviceorder.Account.Language_Preference__c : 'English';
                    socObj.Target_Email_Address__c = woEmailInfo;
                    //socObj.Forward_An_Email_To_STC__c=serviceorder.Service_Team_Contact__r.email;
                    socObj.Phone_Number__c = serviceorder.ServiceTerritory.Phone__c;
                    socObj.Action__c = 'email';
                    String City = serviceorder.ServiceTerritory.city;
                    String State = serviceorder.ServiceTerritory.state;
                    socObj.Address__c = City + ' '+State;                    
                    socList.add(socObj);
            }
        }
        If(!socList.isEmpty()){            
             Insert socList; 
             System.debug('@@@: after insert of communication records   '+socList[0].id);   
             
        }
       /*if(serOrderCommInsertionFlag == true){
            WorkOrder woUpdate = new WorkOrder();
            woUpdate.Id = serviceorder.Id;
            
               woUpdate.Is_Invoice_Log__c = true;

            woUpdateList.add(woUpdate);
            
            if(woUpdateList.size()>0)
                update woUpdateList;
        }*/
    }
    ///End story ---- CT4-211------
    }