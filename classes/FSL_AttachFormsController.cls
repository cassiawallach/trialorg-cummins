public class FSL_AttachFormsController {

    @AuraEnabled
    public static Boolean createForm_apex(String recordId){
        if(!String.isEmpty(recordId)){
            List<WorkOrder> woList = [SELECT Id, AccountId, Repair_Site_Address__c, ServiceTerritoryId, FSL_Sub_Type__c, WorkTypeId, FSL_SMN__c, CreatedById, Application__c, AssetId, Engine_Family_Code_Form__c, Make__c, Model__c, Repair_Location__c, Service_Type__c,
                                      (SELECT Id,OwnerId,Form_Template_Matrix__c,Form_Template_Matrix__r.One_Form_Dispatched_ServiceAppointment__c, Form_Template_Matrix__r.Repair_Location__c, Form_Template_Matrix__r.Service_Type__c, Service_Appointment__c FROM Forms__r),
                                      (SELECT Id,Status,Assigned_ServiceResource__r.RelatedRecordId,Assigned_ServiceResource__r.Is_a_Tech__c FROM ServiceAppointments WHERE Status = 'Dispatched' AND Is_a_Tech_Appointment__c = true)
                                      FROM WorkOrder
                                      WHERE Id = :recordId];
            if(!woList.isEmpty()){
                //Query the matrix record with matching criteria
                List<FSL_Form_Template_Matrix__c> formTemplateList = getMatrixRecords(woList[0]);
            
                if(formTemplateList.isEmpty()){
                    //If No Match is found in Matrix
                    AuraHandledException ex = new AuraHandledException(Label.FSL_AttachForm_NoMatch);
                    ex.setMessage(Label.FSL_AttachForm_NoMatch);
                    throw ex;
                } else { 
                    
                    Set<Id> TechnicianIdSet = new Set<Id>();
                    for(ServiceAppointment sa: woList[0].ServiceAppointments){
                        if(sa.Assigned_ServiceResource__r.RelatedRecordId != null && sa.Assigned_ServiceResource__r.Is_a_Tech__c){
                            TechnicianIdSet.add(sa.Assigned_ServiceResource__r.RelatedRecordId);
                        }
                    }
                    List<disco__Form__c> formToInsertList1 = new List<disco__Form__c>();
                    List<disco__Form__c> formToInsertList2 = new List<disco__Form__c>();
                    Map<Integer,List<disco__Mobile_Form_Share__c>> formShareToInsertMap = new Map<Integer,List<disco__Mobile_Form_Share__c>>();
                    Map<Integer,List<disco__Form__share>> standardFormShareToInsertMap = new Map<Integer,List<disco__Form__share>>();
                    Integer counterOFPSO = 0;
                    
                    //Create a Map Template Matrix Id and set of assigned service appointments
                    Set<Id> existingFormTemplateMatrixIds = new Set<Id>();
                    Map<Id,Set<Id>> existingFormMap = new Map<Id,Set<Id>>();
                    for(disco__Form__c form: woList[0].Forms__r){
                        existingFormTemplateMatrixIds.add(form.Form_Template_Matrix__c);
                        if(form.Form_Template_Matrix__r.One_Form_Dispatched_ServiceAppointment__c && form.Service_Appointment__c != null){
                            if(!existingFormMap.containsKey(form.Form_Template_Matrix__c)){
                                existingFormMap.put(form.Form_Template_Matrix__c, new Set<Id>());
                            }
                            existingFormMap.get(form.Form_Template_Matrix__c).add(form.Service_Appointment__c);
                        }
                    }
                    
                    for(FSL_Form_Template_Matrix__c formTemplateMatrix:formTemplateList){
                        System.debug('@@@ => Form Id: ' + formTemplateMatrix.Id);
                    
                        if(formTemplateMatrix.One_Form_Per_Service_Order__c){
                            //If Only One record per Service Order
                            if(existingFormTemplateMatrixIds.contains(formTemplateMatrix.Id)){
                                //Form already exists. 
                                continue;
                            }
                            //IF no form is attached then create a new Form
                            disco__Form__c formRecord = new disco__Form__c();
                            formRecord.Service_Order__c = recordId;
                            formRecord.disco__Form_Template__c = formTemplateMatrix.FSL_Form_Template__c;
                            formRecord.OwnerId = woList[0].CreatedById;
                            formRecord.Form_Template_Matrix__c = formTemplateMatrix.Id;
                            
                            if(TechnicianIdSet.size() == 1){
                                // If only one Tech Service Resource then assign him/her as the owner
                                for(Id theId: TechnicianIdSet){
                                    formRecord.ownerId = theId;   
                                }                                 
                            }
                            formToInsertList1.add(formRecord);
                            
                            if(TechnicianIdSet.size() > 1){
                                //If multiple Tech Service Resource then share the Form with all Service Resources
                                formShareToInsertMap.put(counterOFPSO, new List<disco__Mobile_Form_Share__c>());
                                standardFormShareToInsertMap.put(counterOFPSO, new List<disco__Form__share>());
                                for(Id theId: TechnicianIdSet){
                                    disco__Mobile_Form_Share__c formShareRecord = new disco__Mobile_Form_Share__c();
                                    formShareRecord.disco__User__c = theId;
                                    formShareToInsertMap.get(counterOFPSO).add(formShareRecord);

                                    disco__Form__share standardFormShareRecord = new disco__Form__share();
                                    standardFormShareRecord.UserOrGroupId = theId;
                                    standardFormShareRecord.AccessLevel = 'Edit';
                                    standardFormShareRecord.RowCause = Schema.disco__Form__share.RowCause.AllowMultipleResourcesToAccessOneForm__c;
                                    standardFormShareToInsertMap.get(counterOFPSO).add(standardFormShareRecord);
                                }
                            }
                            counterOFPSO++;
                        } else if(formTemplateMatrix.One_Form_Dispatched_ServiceAppointment__c){
                            //If One form per Service Appointement in Dispatched status
                            if(!existingFormTemplateMatrixIds.contains(formTemplateMatrix.Id) && (woList[0].ServiceAppointments == null || woList[0].ServiceAppointments.size() == 0)){
                                //If no dispatched Service Appointment and no existing form just create one form and owner should be running user
                                disco__Form__c formRecord = new disco__Form__c();
                                formRecord.Service_Order__c = recordId;
                                formRecord.disco__Form_Template__c = formTemplateMatrix.FSL_Form_Template__c;
                                formRecord.Form_Template_Matrix__c = formTemplateMatrix.Id;
                                formRecord.OwnerId = UserInfo.getUserId();
                                formToInsertList2.add(formRecord);    
                            } else {
                                for(ServiceAppointment sa: woList[0].ServiceAppointments){
                                    if(sa.Assigned_ServiceResource__r.RelatedRecordId != null && sa.Assigned_ServiceResource__r.Is_a_Tech__c){
                                        if(!(existingFormMap.containsKey(formTemplateMatrix.Id) && existingFormMap.get(formTemplateMatrix.Id).contains(sa.Id))){
                                            //form is NOT attached to this SA, create a new form
                                            disco__Form__c formRecord = new disco__Form__c();
                                            formRecord.Service_Order__c = recordId;
                                            formRecord.disco__Form_Template__c = formTemplateMatrix.FSL_Form_Template__c;
                                            formRecord.Form_Template_Matrix__c = formTemplateMatrix.Id;
                                            formRecord.OwnerId = sa.Assigned_ServiceResource__r.RelatedRecordId;
                                            formRecord.Service_Appointment__c = sa.Id;
                                            formToInsertList2.add(formRecord);
                                        } 
                                    }
                                }
                            }
                        }
                    }
                    List<disco__Form__c> allForms = new List<disco__Form__c>();
                    List<disco__Mobile_Form_Share__c> formShareToInsertList = new List<disco__Mobile_Form_Share__c>();
                    List<disco__Form__share> standardFormShareToInsertList = new List<disco__Form__share>();

                    allForms.addAll(formToInsertList1);
                    allForms.addAll(formToInsertList2);
                    if(!allForms.isEmpty()){
                        try{
                            insert allForms;
                            for(Integer index: formShareToInsertMap.keySet()){
                                List<disco__Mobile_Form_Share__c> formShareList = formShareToInsertMap.get(index);
                                for(disco__Mobile_Form_Share__c formshare: formShareList){
                                    formshare.disco__Form__c = allForms.get(index).Id;
                                    formShareToInsertList.add(formshare);
                                }
                                List<disco__Form__share> standardFormShareList = standardFormShareToInsertMap.get(index);
                                for(disco__Form__share standardFormshare: standardFormShareList){
                                    standardFormshare.parentId = allForms.get(index).Id;
                                    standardFormShareToInsertList.add(standardFormshare);
                                }

                            }
                            if(!formShareToInsertList.isEmpty()){
                                insert formShareToInsertList;
                            }
                            if(!standardFormShareToInsertList.isEmpty()){
                                insert standardFormShareToInsertList;
                            }
                        } catch(Exception e){
                            throw new AuraHandledException(e.getMessage());
                        }
                    } else{
                        throw new AuraHandledException(Label.FSL_AttachForm_FormAlreadyAttached);
                    }

                    //all good return true
                    return true;
                }    
            } else{
                throw new AuraHandledException('Service Order Record not Found.');
            }   
        } else{
            throw new AuraHandledException('Service Order Record Id is blank.');
        }
    }

    /*
    * @Desc: Find the matching Template Matrix Records by WorkOrder
    */
    
   //As part of FBI-133, Added by Harini
    public static List<FSL_Form_Template_Matrix__c> getMatrixRecords(WorkOrder wo){
        Set<Id> serviceTerritorySet = new Set<Id>();
        if(wo.ServiceTerritoryId !=null){
        	List<ServiceTerritory> serviceTerritoryList= [Select Id,ParentTerritoryId,ParentTerritory.ParentTerritoryId from ServiceTerritory where Id=:wo.ServiceTerritoryId];
            serviceTerritorySet.add(serviceTerritoryList[0].Id);
            if(serviceTerritoryList[0].ParentTerritoryId !=null){
                serviceTerritorySet.add(serviceTerritoryList[0].ParentTerritoryId);
            }
            if(serviceTerritoryList[0].ParentTerritory.ParentTerritoryId !=null){
                serviceTerritorySet.add(serviceTerritoryList[0].ParentTerritory.ParentTerritoryId);
            }
        }
        //End of FBI-133, Added by Harini
        //String subTypeName = wo.FSL_Sub_Type__r?.name;
        List<FSL_Form_Template_Matrix__c> formTemplateList = [SELECT Id, FSL_Form_Template__c, One_Form_Per_Service_Order__c,Repair_Location__c,Service_Type__c, One_Form_Dispatched_ServiceAppointment__c
                                                                      FROM FSL_Form_Template_Matrix__c
                                                                      WHERE (   FSL_Form_Template__r.FSL_Approval_Status__c = 'Approved'
                                                                                AND FSL_Form_Template__r.disco__Status__c = 'In Use'
                                                                                AND FSL_Query_Operator__c = 'AND'
                                                                                AND Active__c = true
                                                                                AND 
                                                                                (   
                                                                                    (FSL_Sub_Type__c = :wo.FSL_Sub_Type__c OR FSL_Sub_Type__c = null)
                                                                                    AND (FSL_Work_Type__c = :wo.WorkTypeId OR FSL_Work_Type__c = null)
                                                                                    AND (Repair_Site_Number__c = :wo.Repair_Site_Address__c OR Repair_Site_Number__c = null)
                                                                                    AND (Account__c = :wo.AccountId OR Account__c = null)
                                                                                    AND (Service_Territory__c IN:serviceTerritorySet OR Service_Territory__c = null)
                                                                                    AND (SMN__c = :wo.FSL_SMN__c OR SMN__c = null)
                                                                                    AND (Application__c = :wo.Application__c OR Application__c = null)
                                                                                    AND (Asset__c = :wo.AssetId OR Asset__c = null)
                                                                                    AND (Engine_Family_Code__c = :wo.Engine_Family_Code_Form__c OR Engine_Family_Code__c = null)
                                                                                    AND (Make_Model__r.Make__c = :wo.Make__c OR Make_Model__c = null)
                                                                                    AND (Make_Model__r.Model__c = :wo.Model__c OR Make_Model__c = null)
                                                                                    AND (Service_Type__c  = :wo.Service_Type__c  OR Service_Type__c = null)
                                                                                    AND (Repair_Location__c = :wo.Repair_Location__c OR Repair_Location__c = null)
                                                                                )
                                                                            ) 
                                                                            OR 
                                                                            (   FSL_Form_Template__r.FSL_Approval_Status__c = 'Approved'
                                                                                AND FSL_Form_Template__r.disco__Status__c = 'In Use'
                                                                                AND FSL_Query_Operator__c = 'OR'
                                                                                AND Active__c = true
                                                                                AND 
                                                                                (
                                                                                    (FSL_Sub_Type__c = :wo.FSL_Sub_Type__c AND FSL_Sub_Type__c != null)
                                                                                    OR (FSL_Work_Type__c = :wo.WorkTypeId AND FSL_Work_Type__c != null)
                                                                                    OR (Repair_Site_Number__c = :wo.Repair_Site_Address__c AND Repair_Site_Number__c != null)
                                                                                    OR (Account__c = :wo.AccountId AND Account__c != null)
                                                                                    OR (Service_Territory__c IN:serviceTerritorySet AND Service_Territory__c != null)
                                                                                    OR (SMN__c = :wo.FSL_SMN__c AND SMN__c != null)
                                                                                    OR (Application__c =:wo.Application__c AND Application__c != null)
                                                                                    OR (Asset__c = :wo.AssetId AND Asset__c != null)
                                                                                    OR (Engine_Family_Code__c = :wo.Engine_Family_Code_Form__c AND Engine_Family_Code__c != null)
                                                                                    OR (Make_Model__r.Make__c = :wo.Make__c AND Make_Model__c != null)
                                                                                    OR (Make_Model__r.Model__c = :wo.Model__c AND Make_Model__c != null)
                                                                                    OR (Service_Type__c  = :wo.Service_Type__c  AND Service_Type__c != null)
                                                                                    OR (Repair_Location__c = :wo.Repair_Location__c AND Repair_Location__c != null)
                                                                                )  
                                                                            )];
        return formTemplateList;
    }
}