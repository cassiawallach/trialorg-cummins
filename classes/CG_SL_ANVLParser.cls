/**********************************************************************
Name:CG_SL_ANVL
Copyright © 2011  Cummins
======================================================================
======================================================================
Purpose:                                                            
This class is used to prepare Request JSON for ANVL Service.
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                           
1.0 - Anirudh Reddy    11/28/2018       Initial Development
***********************************************************************/
public class CG_SL_ANVLParser {
    
    public static CG_ANVL_ReqWrapper prepareReqWrapper(CSS_Job_Order__c ServiceJob){
        CG_ANVL_ReqWrapper ANVLReq = new CG_ANVL_ReqWrapper();
        
        try{
            
            ANVLReq.transactionId = System.Label.Source_Environment_Type + ' - ' + String.valueOf(Datetime.now().format('YYYYMMDDHHMMSS'));
            
            //prepare workorders i.e assigned technicians list with fed ID's.
            
            List<CG_ANVL_ReqWrapper.cls_workOrders> workOrders = new List<CG_ANVL_ReqWrapper.cls_workOrders>();
            
            CG_ANVL_ReqWrapper.cls_workOrders WO = new CG_ANVL_ReqWrapper.cls_workOrders();
            WO.id = ServiceJob.Name;
            WO.description = prepareCategoryComplaintTypeString(ServiceJob);//ServiceJob.Category_Desc__c + ' - ' + ServiceJob.Complaint_Type_Desc__c;
            WO.serial = ServiceJob.ESN__c;
            WO.model = ServiceJob.Service_Model__c;
            WO.category = ServiceJob.ApplicationCode__c + ' - ' + ServiceJob.Application_Desc__c;
            WO.type = ServiceJob.Repair_Location__c;
            
            system.debug('jRec>>>>'+ServiceJob.CreatedDate);
            datetime createdDate= ServiceJob.CreatedDate;
            string crtdDate = createdDate.format('YYYY-MM-dd')+ 'T';
            string crtdDate2 = createdDate.format('hh:mm:ssZ')+ 'Z';
            crtdDate2 = crtdDate2.replace('-','.');
            system.debug('currDate>>>>'+crtdDate + crtdDate2);
            WO.createdAt = crtdDate + crtdDate2;
            
             system.debug('jRec>>>>'+ServiceJob.LastModifiedDate);
            datetime lastModifiedDate= ServiceJob.LastModifiedDate;
            string lmdDate = lastModifiedDate.format('YYYY-MM-dd')+ 'T';
            string lmdDate2 = lastModifiedDate.format('hh:mm:ssZ')+ 'Z';
            lmdDate2 = lmdDate2.replace('-','.');
            system.debug('currDate>>>>'+lmdDate + lmdDate2);
            WO.updatedAt = lmdDate + lmdDate2;
            WO.location = ServiceJob.Account__r.CSS_DBCode__c + ' - ' + ServiceJob.Account__r.Name;
            
            CG_ANVL_ReqWrapper.cls_customer custDetails = new CG_ANVL_ReqWrapper.cls_customer();
            custDetails.name = ServiceJob.Customer_Name__c;
            custDetails.id = ServiceJob.Customer_Code__c;
            
            WO.customer = custDetails;
            
            //call assignedUsers method to get list of assigned Users.
            list<string> lstAssignedUsers = new list<string>();
            lstAssignedUsers = assignedUsers(serviceJob);
            
             if(lstAssignedUsers != null && lstAssignedUsers.size()>0) {
                WO.assigned = lstAssignedUsers;
             }else{
                 return null;
             }
            
             if(WO != null) {
                workOrders.add(WO);
            }
            
            ANVLReq.workOrders = workOrders;
            
            return ANVLReq;
            
         }catch(exception e){
            system.debug('Entered into catch block of prepareReqWrapper method in CG_SL_ANVLParser class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }  
        return null;
    }
    
    public static string prepareCategoryComplaintTypeString(CSS_Job_Order__c ServiceJob){
        transient string strCatCompType;
        try{
            strCatCompType =(ServiceJob.Complaint_Type_Desc__c != null && ServiceJob.Complaint_Type_Desc__c != '' ? ServiceJob.Category_Desc__c + ' - ' + ServiceJob.Complaint_Type_Desc__c : 
                             ServiceJob.Complaint_Type2_Desc__c != null && ServiceJob.Complaint_Type2_Desc__c != '' ? ServiceJob.Category2_Desc__c + ' - ' + ServiceJob.Complaint_Type2_Desc__c :
                             ServiceJob.Complaint_Type3_Desc__c != null && ServiceJob.Complaint_Type3_Desc__c != '' ? ServiceJob.Category3_Desc__c + ' - ' + ServiceJob.Complaint_Type3_Desc__c : 
                             ServiceJob.Complaint_Type4_Desc__c != null && ServiceJob.Complaint_Type4_Desc__c != '' ? ServiceJob.Category4_Desc__c + ' - ' + ServiceJob.Complaint_Type4_Desc__c : 
                             ServiceJob.Complaint_Type5_Desc__c != null && ServiceJob.Complaint_Type5_Desc__c != '' ? ServiceJob.Category5_Desc__c + ' - ' + ServiceJob.Complaint_Type5_Desc__c : '');
            
            return strCatCompType;
        }catch(exception e){
            system.debug('Entered into catch block of prepareCategoryComplaintTypeString method in CG_SL_ANVLParser class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        }  
        return '';  
    }
    
    public static list<string> assignedUsers(CSS_Job_Order__c cssJO){
        
        List<String> lstAssignedUsers = new List<String>();
        
        try{
            system.debug('cssJO.Assigned_to__c**'+cssJO.Assigned_to__c);
            system.debug('cssJO.Assigned_to__r.FederationIdentifier**'+cssJO.Assigned_to__r.FederationIdentifier);
            system.debug('Additional_Tech1__c**'+cssJO.Additional_Tech1__c);
            system.debug('cssJO.Additional_Tech1__r.FederationIdentifier**'+cssJO.Additional_Tech1__r.FederationIdentifier);
            system.debug('Additional_Tech2__c**'+cssJO.Additional_Tech2__c);
            system.debug('cssJO.Additional_Tech2__r.FederationIdentifier**'+cssJO.Additional_Tech2__r.FederationIdentifier);
            system.debug('Additional_Tech3__c**'+cssJO.Additional_Tech3__c);
        if(cssJO.Assigned_to__c != null && cssJO.Assigned_to__r.FederationIdentifier != null && cssJO.Assigned_to__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Assigned_To__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech1__c != null && cssJO.Additional_Tech1__r.FederationIdentifier != null && cssJO.Additional_Tech1__r.FederationIdentifier != '') {    
            lstAssignedUsers.add(cssJO.Additional_Tech1__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech2__c != null && cssJO.Additional_Tech2__r.FederationIdentifier != null && cssJO.Additional_Tech2__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech2__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech3__c != null && cssJO.Additional_Tech3__r.FederationIdentifier != null && cssJO.Additional_Tech3__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech3__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech4__c != null && cssJO.Additional_Tech4__r.FederationIdentifier != null && cssJO.Additional_Tech4__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech4__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech5__c != null && cssJO.Additional_Tech5__r.FederationIdentifier != null && cssJO.Additional_Tech5__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech5__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech6__c != null && cssJO.Additional_Tech6__r.FederationIdentifier != null && cssJO.Additional_Tech6__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech6__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech7__c != null && cssJO.Additional_Tech7__r.FederationIdentifier != null && cssJO.Additional_Tech7__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech7__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech8__c != null && cssJO.Additional_Tech8__r.FederationIdentifier != null && cssJO.Additional_Tech8__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech8__r.FederationIdentifier);
        }
        if(cssJO.Additional_Tech9__c != null && cssJO.Additional_Tech9__r.FederationIdentifier != null && cssJO.Additional_Tech9__r.FederationIdentifier != '') {
            lstAssignedUsers.add(cssJO.Additional_Tech9__r.FederationIdentifier);
        }
            
            return lstAssignedUsers;
        }catch(exception e){
            system.debug('Entered into catch block of assignedUsers method in CG_SL_ANVLParser class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
        } 
        return null;
    }

}