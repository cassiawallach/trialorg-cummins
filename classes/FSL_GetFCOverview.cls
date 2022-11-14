public class FSL_GetFCOverview {
    @AuraEnabled
     Public static string getFCOverview(String workOrderId)
    {
        list<workOrder> listWo = new list<workOrder>();
       // list<FSL_Fault_Code__c> listFault = new list<FSL_Fault_Code__c>();
        list<CSS_Fault_Code__c> listFault = new list<CSS_Fault_Code__c>();
        FSL_FCOverview_Wrapper wrap = new FSL_FCOverview_Wrapper();
        string esnCode ;
        string faultName ;
        string jsonResponse ; 
        string FCName; 
        system.debug('workOrderId '+workOrderId);
        listWo = [select id,Service_Order_Extension__c, Service_Order_Extension__r.FaultCodeId__c,Asset.Name from workorder where id =:workOrderId];
        List<Service_Order_Extension__c> woExtList = new List<Service_Order_Extension__c>();
        woExtList = [Select Id, Service_Order_Id__c, FaultCodeId__c ,RecordTypeId from Service_Order_Extension__c where Service_Order_Id__c =: workOrderId];
        
     /*   if(listWo.size()>0)
        {
            esnCode = listWo[0].Asset.Name;
            if(listWo[0].FaultCodeId__c != null)
            {
                fc = [select id,Name from CSS_Fault_Code__c where Id=:listWo[0].FaultCodeId__c];
                FCName = fc[0].Name ;
                system.debug('FaultCode is:'+FCName);
            }
            if(FCName != null)
            {
                listFault = [select id,name,Fault_Code_Overview__c,LastModifiedById from FSL_Fault_Code__c where name=: FCName];        
            }
            if(listFault.size()>0)
            {
                String position = listFault[0].LastModifiedById;
              String subString = position.substringBefore(',');
                faultName = FCName;
                jsonResponse = listFault[0].Fault_Code_Overview__c ;
                
               // if(subString > ){}
                if(string.isNotBlank(esnCode) && string.isNotBlank(faultName) && string.isBlank(jsonResponse))
                {
                    wrap = FSL_CL_QSOLIntegrations.getOverViewCall(esnCode,faultName,'en');
                    jsonResponse = JSON.serialize(wrap);
                    listFault[0].Fault_Code_Overview__c = jsonResponse;
                    update listFault;
                }
            }
        } */
         if(listWo.size()>0 && woExtList.size() > 0)
        {
            esnCode = listWo[0].Asset.Name;
            if(woExtList[0].FaultCodeId__c != null)
            {
                listFault = [select id,name from CSS_Fault_Code__c where Id=:woExtList[0].FaultCodeId__c];        
                system.debug('FaultCodeID is:'+woExtList[0].FaultCodeId__c);
            }
            if(listFault.size()>0)
            {
                faultName = listFault[0].name;
            }
        }
        if(string.isNotBlank(esnCode) && string.isNotBlank(faultName))
        {
            //-----CT3-44 ----
            //Modified By: Dinesh Yadav, 24 Sept 2020 For QSOL launguage.
            System.debug(' ::::: ' + UserInfo.getLanguage()) ;
            CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
            system.debug('csAccountLang :: '+csAccountLang);
            string strCSS_QsolLanguage ='en';
            if(csAccountLang != null){
                if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                    strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
            }
            
            wrap = FSL_CL_QSOLIntegrations.getOverViewCall(esnCode,faultName,strCSS_QsolLanguage);
            /* ------------End * CT3-44 -----*/
        }
        System.debug('jsonResponse  :'+jsonResponse);        
        //return jsonResponse;
        return JSON.serialize(wrap);
    }
    @auraEnabled
    public Static Boolean logFSOverviewAuditEvent(Id woId)
    {
        //String woNo=[select WorkOrderNumber from workorder where id=:woId].WorkOrderNumber;
        Audit_Trail_Event__mdt auditEvent = [select Event_Type__c,Diagnostic_Audit_Trail__c,Event_Description__c from Audit_Trail_Event__mdt where DeveloperName='Event_04'];
        FSLAuditTrialEventLogger fat = new FSLAuditTrialEventLogger();
        return fat.logFCOverviewEvent(auditEvent, woId);           
    }
}