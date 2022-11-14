public class FSL_ServiceAppointmentHelper {

    public static void populateResourceDetails(Map<Id, ServiceAppointment> newSaMap, Map<Id, ServiceAppointment> oldSaMap) {

        set<Id> saId = new set<Id>();
        set<Id> woId = new set<Id>();
        list<ServiceAppointment> saList=new list<ServiceAppointment>();
        List<AssignedResource> arList = new List<AssignedResource>();
        List<WorkOrder> woList = new List<WorkOrder>();
        List<WorkOrder> upwoList = new List<WorkOrder>();
        Map<string,string> saMap = new  Map<string,string>();
        Map<id,ServiceAppointment> SaMapValues=new Map<id,ServiceAppointment>();
        if(!test.isRunningTest()){
        if(Trigger.isDelete){
            SaMapValues = oldSaMap;
        }
        else if(Trigger.isInsert || Trigger.isUpdate){
            SaMapValues = newSaMap;
        }
        }
        for(ServiceAppointment sa:SaMapValues.values()){
            //saId.add(sa.Id);
           if(String.valueof(sa.ParentRecordId).startsWith('0WO')) {
                woId.add(sa.ParentRecordId);
            }
        }
        system.debug('****woId'+ woId);
        //to fetch related SA's of a WO
        saList = [SELECT Id, ParentRecordId, Status, DueDate, EarliestStartTime, SchedStartTime, SchedEndTime
                  FROM ServiceAppointment
                  WHERE ParentRecordId IN:woId];
        system.debug('**saList**'+saList);
        for(ServiceAppointment sa:saList){
            said.add(sa.id);
            System.debug('sa.id *** ' + sa.id);
            System.debug('SA Status**'+ saList[0].Status);
        }
       
        // to fetch resource name
        arList = [SELECT Id, ServiceAppointment.AppointmentNumber, ServiceResource.Name
                  FROM AssignedResource
                  WHERE ServiceAppointmentId IN:saId];
        system.debug('****arList'+ arList);
       
        for(AssignedResource ar:arList) {
             saMap.put(ar.ServiceAppointment.AppointmentNumber, ar.ServiceResource.Name);
        }
       
        system.debug('****saMap'+ saMap);
        // to fetch WO field to be update
        woList = [SELECT Id, Status, Process_Step__c, AssignedResource__c, Scheduled__c, recordTypeId  // CT2-1195
                  FROM WorkOrder
                  WHERE Id IN:woId];
        Id woInternalRTId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId(); // CT2-1195
        system.debug('****woList'+ woList);
        for(WorkOrder wo:woList) {
            wo.AssignedResource__c = string.valueof(saMap);
            system.debug('wo.AssignedResource__c' + string.valueof(saMap));
            system.debug('wo.AssignedResource__c.length()' + wo.AssignedResource__c.length());
            /* GFSLFM-1228 : Status  will be updated to 'Scheduled' after successful assign of a resource */
            if((wo.Process_Step__c == 'Intake' || wo.Process_Step__c == 'Schedule') && wo.recordTypeId != woInternalRTId) {  // CT2-1195 Restricting update on Internal WO
                if(wo.AssignedResource__c.length() > 2) {
                    system.debug('status update to scheduled');
                    wo.Status = 'Scheduled';
                    wo.Scheduled__c = true;
                    // Bharat - 101, moved the checkResource false set outside if
                    // RecursiveTriggerHandler.checkResource = false; //Added by Ravi for bug CT2-507
                }
            }
            RecursiveTriggerHandler.checkResource = false;
            upwoList.add(wo);
        }
        update upwoList;  
    }
    /* GFSLFM-1228 : Below trigger is to update  
       
    */
    public static void populateTechnicianDispatchStatus(Map<Id,ServiceAppointment> newMap,Map<Id,ServiceAppointment> oldMap){
        Set<Id> objListWorkOrder  = new Set<Id>();
        Map<Id,ServiceAppointment> objSerAppNewMapValues = new Map<Id,ServiceAppointment>();
        List<WorkOrder> listNewWorkOrder = new List<WorkOrder>();
        Map<String,Id> mapWorkOrderRecordType = new Map<String,Id>();
        system.debug('newMap'+ newMap);
        if(trigger.isInsert || trigger.isUpdate){
            objSerAppNewMapValues = newMap;
        }
       
        List<RecordType> listRT = [SELECT Id,Name
                                   FROM RecordType
                                   WHERE SobjectType='WorkOrder'];
       
        for(RecordType rt : listRT){
            mapWorkOrderRecordType.put(rt.Name,rt.Id);
        }
        system.debug('mapWorkOrderRecordType'+mapWorkOrderRecordType);
        System.debug('objSerAppNewMapValues'+ objSerAppNewMapValues);
       
    for(ServiceAppointment value :objSerAppNewMapValues.values() ){
            if( String.valueof(value.ParentRecordId).startsWith('0WO')){
                objListWorkOrder.add(value.ParentRecordId);  
            }
        }
 
        System.debug('objListWorkOrder'+ objListWorkOrder);
        List<ServiceAppointment> objListSerApp =   [SELECT Id,Status,ParentRecordId
                                                    FROM ServiceAppointment
                                                    WHERE Status ='Dispatched'
                                                    AND ParentRecordId IN :objListWorkOrder];
       
        System.debug('objListSerApp '+ objListSerApp);
        Map<Id,List<String>> mapListServiceAppointment = new Map<Id,List<String>>();
        for(ServiceAppointment objSP : objListSerApp){
            System.debug('SP Object'+objSP);
            List<String> lstStatus = new List<String>();
            if(mapListServiceAppointment.containsKey(objSP.ParentRecordId))
                lstStatus = mapListServiceAppointment.get(objSP.ParentRecordId);
            lstStatus.add(objSP.Status);
            System.debug('lstStatus'+ lstStatus);
            mapListServiceAppointment.put(objSP.ParentRecordId,lstStatus);
        }
        system.debug('mapListServiceAppointment'+mapListServiceAppointment);
        List<WorkOrder> objListWO =    [SELECT Id,Status,Type__c,Process_Step__c,recordTypeId, IAS_Number__c, Service_Order_Extension__r.FSL_ABRFlag__c
                                        FROM WorkOrder
                                        WHERE Id IN : mapListServiceAppointment.keySet()];
        system.debug('objListWO'+ objListWO);
        for(WorkOrder objWorkOrder : objListWO ){
            system.debug('******** Work order list'+ mapListServiceAppointment.get(objWorkOrder.Id).contains('Dispatched'));
            system.debug('objWorkOrder.recordTypeId'+objWorkOrder.recordTypeId);
            system.debug('mapWorkOrderRecordType'+mapWorkOrderRecordType.get('Internal'));
            /*---Added Additional Condition objWorkOrder.Type__c !='Internal' by DivyaSri for bug-TW-51-----*/
            //Road-473 Start - Rajender
            if(objWorkOrder.recordTypeId != mapWorkOrderRecordType.get('Internal') && objWorkOrder.Type__c !='Internal'&& mapListServiceAppointment.get(objWorkOrder.Id).contains('Dispatched') && (objWorkOrder.Process_Step__c =='Schedule' || objWorkOrder.Process_Step__c =='Job Plan') && objWorkOrder.Service_Order_Extension__r.FSL_ABRFlag__c == True){
 				system.debug('objWorkOrder.Process_Step__c>>>>> '+ objWorkOrder.Process_Step__c);
                objWorkOrder.Is_Tech_Dispatched__c = TRUE;
                objWorkOrder.Process_Step__c = 'Job Plan';
                objWorkOrder.Status = 'Job Plan';
                objWorkOrder.Sub_Status__c = '';
                objWorkOrder.RecordTypeId = mapWorkOrderRecordType.get('Job Plan');
             //Road-473 End - Rajender
            } else if(objWorkOrder.recordTypeId != mapWorkOrderRecordType.get('Internal') && objWorkOrder.Type__c !='Internal'&& mapListServiceAppointment.get(objWorkOrder.Id).contains('Dispatched') && (objWorkOrder.Process_Step__c =='Schedule' || objWorkOrder.Process_Step__c =='Job Plan')){
 				system.debug('objWorkOrder.Process_Step__c'+ objWorkOrder.Process_Step__c);
                objWorkOrder.Is_Tech_Dispatched__c = TRUE;
                objWorkOrder.Process_Step__c = 'Triage & Diagnosis';
                objWorkOrder.Status = 'Triage & Diagnosis';
                objWorkOrder.RecordTypeId = mapWorkOrderRecordType.get('T&D');
            }
            listNewWorkOrder.add(objWorkOrder);
        }
        system.debug('listNewWorkOrder'+ listNewWorkOrder);
        if(listNewWorkOrder.size()>0){
            update listNewWorkOrder;
        }
    }

    @future
    public static void createForms(Set<Id> saIdSet){
        List<ServiceAppointment> saList = [SELECT ID, ParentRecordId
                                           FROM ServiceAppointment
                                           WHERE ID IN :saIdSet];
        Map<Id,List<ServiceAppointment>> woIdSAMap = new Map<Id,List<ServiceAppointment>>();
        for(ServiceAppointment sa:saList){
            if(!woIdSAMap.containsKey(sa.ParentRecordId)){
                woIdSAMap.put(sa.ParentRecordId, new List<ServiceAppointment>());
            }
            woIdSAMap.get(sa.ParentRecordId).add(sa);
        }
        system.debug('***mapKeySet***'+woIdSAMap.keySet());
        List<WorkOrder> woList = [SELECT Id, AccountId, Repair_Site_Address__c, ServiceTerritoryId, FSL_Sub_Type__c, WorkTypeId, FSL_SMN__c, CreatedById, Application__c, AssetId, Engine_Family_Code_Form__c, Make__c, Model__c,Service_Type__c,Repair_Location__c,
                                  (SELECT Id,OwnerId,disco__Form_Template__c,Form_Template_Matrix__c,Form_Template_Matrix__r.One_Form_Per_Service_Order__c,Form_Template_Matrix__r.One_Form_Dispatched_ServiceAppointment__c,Service_Appointment__c FROM Forms__r),
                                  (SELECT Id,Status,Assigned_ServiceResource__r.RelatedRecordId,Assigned_ServiceResource__r.Is_a_Tech__c FROM ServiceAppointments WHERE Id IN :saIdSet AND Status = 'Dispatched' AND Is_a_Tech_Appointment__c = true)
                                  FROM WorkOrder
                                  WHERE Id = :woIdSAMap.keySet()];
       
        List<disco__Mobile_Form_Share__c> formShareList = [SELECT ID,disco__Form__c,disco__User__c
                                                           FROM disco__Mobile_Form_Share__c
                                                           WHERE disco__Form__r.Service_Order__c IN :woIdSAMap.keySet()];
        system.debug('***formShareList***'+formShareList);
        Set<String> formIdWithUserIdSet = new Set<String>();
        for(disco__Mobile_Form_Share__c formShare: formShareList){
            String key;
            key = formShare.disco__Form__c + ':' + formShare.disco__User__c;
            formIdWithUserIdSet.add(key);
        }
        List<disco__Mobile_Form_Share__c> formShareListToInsert = new List<disco__Mobile_Form_Share__c>();
        List<disco__Form__c> formsToUpsert = new List<disco__Form__c>();
        Map<String,List<disco__Mobile_Form_Share__c>> mapOfWoTemplateIdAndFormShareList = new Map<String,List<disco__Mobile_Form_Share__c>>();
        Map<String,List<disco__Form__share>> mapOfWoTemplateIdAndStandardFormShareList = new Map<String,List<disco__Form__share>>();
        List<disco__Form__share> standardFormShareList = new List<disco__Form__share>();
        //check for every workorder
        system.debug('***woList***'+woList);
        for(WorkOrder wo :woList){
           
            Map<Id,disco__Form__c> templateIdFormMap = new Map<Id,disco__Form__c>();
            for(disco__Form__c form: wo.Forms__r){
                if(form.Form_Template_Matrix__r.One_Form_Per_Service_Order__c){
                    templateIdFormMap.put(form.Form_Template_Matrix__c,form);
                } else if(form.Form_Template_Matrix__r.One_Form_Dispatched_ServiceAppointment__c && form.Service_Appointment__c == null){
                    templateIdFormMap.put(form.Form_Template_Matrix__c,form);
                }
            }
           
            List<FSL_Form_Template_Matrix__c> formTemplateList = FSL_AttachFormsController.getMatrixRecords(wo);
            system.debug('***formTemplateList***'+formTemplateList);
            //check for every template match found
            for(FSL_Form_Template_Matrix__c formTemplate: formTemplateList) {
                disco__Form__c existingForm;
                if(templateIdFormMap.containsKey(formTemplate.Id)){
                    existingForm = templateIdFormMap.get(formTemplate.Id);
                }
                if(formTemplate.One_Form_Per_Service_Order__c){
                    if(existingForm != null){
                        //one form already exists on WorkOrder
                        //Create a sharing record for the Tech Resource with whom the Form is not shared
                        for(ServiceAppointment sa: wo.ServiceAppointments){
                            String key = existingForm.Id + ':' + sa.Assigned_ServiceResource__r.RelatedRecordId;
                            if(sa.Assigned_ServiceResource__r.RelatedRecordId != null && sa.Assigned_ServiceResource__r.Is_a_Tech__c && !formIdWithUserIdSet.contains(key)){
                                system.debug('***205****');
                                disco__Mobile_Form_Share__c formShareRecord = new disco__Mobile_Form_Share__c();
                                formShareRecord.disco__Form__c = existingForm.Id;
                                formShareRecord.disco__User__c = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                formShareListToInsert.add(formShareRecord);
                                formIdWithUserIdSet.add(key);
                               
                                //Create standard apex managed sharing records
                                disco__Form__share standardFormShareRecord = new disco__Form__share();
                                standardFormShareRecord.ParentId = existingForm.Id;
                                standardFormShareRecord.UserOrGroupId = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                standardFormShareRecord.AccessLevel = 'Edit';
                                standardFormShareRecord.RowCause = Schema.disco__Form__share.RowCause.AllowMultipleResourcesToAccessOneForm__c;
                                standardFormShareList.add(standardFormShareRecord);
                            }    
                        }
                    } else{
                        //create a new form
                        //and Form share Records
                        system.debug('***224****');
                        disco__Form__c formRecord = new disco__Form__c();
                        formRecord.Service_Order__c = wo.Id;
                        formRecord.disco__Form_Template__c = formTemplate.FSL_Form_Template__c;
                        formRecord.Form_Template_Matrix__c = formTemplate.Id;
                        formRecord.OwnerId = wo.createdById;
                        formsToUpsert.add(formRecord);
                        String key = wo.Id + ':' + formTemplate.Id;
                        mapOfWoTemplateIdAndFormShareList.put(key, new List<disco__Mobile_Form_Share__c>());
                        mapOfWoTemplateIdAndStandardFormShareList.put(key, new List<disco__Form__share>());
                        for(ServiceAppointment sa: wo.ServiceAppointments){
                            if(sa.Assigned_ServiceResource__r.RelatedRecordId != null && sa.Assigned_ServiceResource__r.Is_a_Tech__c){
                                disco__Mobile_Form_Share__c formShareRecord = new disco__Mobile_Form_Share__c();
                                formShareRecord.disco__User__c = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                mapOfWoTemplateIdAndFormShareList.get(key).add(formShareRecord);

                                disco__Form__share standardFormShareRecord = new disco__Form__share();
                                standardFormShareRecord.UserOrGroupId = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                standardFormShareRecord.AccessLevel = 'Edit';
                                standardFormShareRecord.RowCause = Schema.disco__Form__share.RowCause.AllowMultipleResourcesToAccessOneForm__c;
                                mapOfWoTemplateIdAndStandardFormShareList.get(key).add(standardFormShareRecord);
                            }    
                        }
                    }
                } else {
                    system.debug('***250****');
                    //Need one form per Service Appointment
                    Boolean assignedExisting = false;
                    for(ServiceAppointment sa: wo.ServiceAppointments){
                        if(sa.Assigned_ServiceResource__r.RelatedRecordId != null && sa.Assigned_ServiceResource__r.Is_a_Tech__c){
                            if(existingForm != null && !assignedExisting){
                                assignedExisting = true;
                                disco__Form__c formRecord = new disco__Form__c();
                                formRecord.Id = existingForm.Id;
                                formRecord.OwnerId = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                formRecord.Service_Appointment__c = sa.Id;
                                formsToUpsert.add(formRecord);
                            } else{
                                disco__Form__c formRecord = new disco__Form__c();
                                formRecord.Service_Order__c = wo.Id;
                                formRecord.disco__Form_Template__c = formTemplate.FSL_Form_Template__c;
                                formRecord.Form_Template_Matrix__c = formTemplate.Id;
                                formRecord.OwnerId = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                formRecord.Service_Appointment__c = sa.Id;
                                formsToUpsert.add(formRecord);
                            }
                           
                        }    
                    }
                }  
            }
        }
system.debug('****formsToUpsert****'+formsToUpsert);
        if(!formsToUpsert.isEmpty()){
            upsert formsToUpsert;
        }
        if(mapOfWoTemplateIdAndFormShareList.size()>0){
            for(disco__Form__c form: formsToUpsert){
                String key = form.Service_Order__c + ':' + form.Form_Template_Matrix__c;
                if(mapOfWoTemplateIdAndFormShareList.containsKey(key)){
                    for(disco__Mobile_Form_Share__c formShareRecord: mapOfWoTemplateIdAndFormShareList.get(key)){
                        formShareRecord.disco__Form__c = form.Id;
                        formShareListToInsert.add(formShareRecord);
                    }
                    for(disco__Form__share standardFormShareRecord: mapOfWoTemplateIdAndStandardFormShareList.get(key)){
                        standardFormShareRecord.parentId = form.Id;
                        standardFormShareList.add(standardFormShareRecord);
                    }
                   
                }
            }    
        }
        if(!formShareListToInsert.isEmpty()){
            insert formShareListToInsert;
        }
        if(!standardFormShareList.isEmpty()){
            insert standardFormShareList;
        }
    }
}