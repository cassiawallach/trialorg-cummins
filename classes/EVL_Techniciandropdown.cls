//adding comment for deployment
public without sharing class EVL_Techniciandropdown {
    
    
    @AuraEnabled
    public static List<CSS_UserLocation__c> getUsers(String wordorderId)
    {
        List<Workorder> wo =[select id,AccountId,Service_Location__c from Workorder where Id=:wordorderId Limit 1];
        List<CSS_UserLocation__c > lstUserloc = [SELECT UserId__r.Id,UserId__r.Name,UserId__r.FirstName,UserId__r.LastName FROM CSS_UserLocation__c Where Location_Name__c =:wo[0].Service_Location__c and isActive__c =true ORDER BY UserId__r.FirstName asc];
        List<CSS_UserLocation__c > lstUserlocFinal = new List<CSS_UserLocation__c >();
        set<Id> userlocIdSet = new set<Id>();
        for(CSS_UserLocation__c u : lstUserloc){
            if(!userlocIdSet.contains(u.UserId__r.Id)) {
                lstUserlocFinal.add(u);
                userlocIdSet.add(u.UserId__r.Id);
            }
        }
        system.debug('lstUserlocFinal '+lstUserlocFinal);
        //return userlocList1;
        
        return lstUserlocFinal;
    }
    
    @AuraEnabled
    public static string save(String Tech,String Workordernumber)
    {
        try{
            system.debug('kar'+Tech);
            Work_Order_Technicians__c newtech = new Work_Order_Technicians__c();
            List<User> usrs =  [Select name,FirstName,LastName From User where Id=: Tech]; 
            List<WorkOrder> woid =  [Select id,Caseid,OwnerId From WorkOrder where Id=: Workordernumber Limit: 1];
            //Validating duplicate technicians
            List<Work_Order_Technicians__c> woDupTechiciansRecords =[Select id,name From Work_Order_Technicians__c where Service_Order__c=: Workordernumber AND User__c =: Tech];
            if(woDupTechiciansRecords.size() > 0){
                return System.Label.EVL_DuplicateTech;
            }
            //get all user names using below for each loop
            if(usrs!=null && usrs.size()>0){
                //newtech.Name = usrs[0].name;
                string Uname = usrs[0].FirstName + ' ' + usrs[0].LastName;
                newtech.Name = Uname;
                
            }     
            
            newtech.Service_Order__c= Workordernumber;
            newtech.User__c = Tech;  //id 
            newtech.OwnerId = woid[0].OwnerId;
            
            system.debug('User__c'+newtech.User__c);
            
            system.debug('User__c'+newtech.User__c);
            insert newtech;
            // system.debug('ewtech.Name'+ newtech.User__c);
            // insert Tech;
            // return Tech;
            
            //added by Devon       
            // Priyanka - CT1-321 - for adding (Assign to) field to dealer List views
            List<Work_Order_Technicians__c> woTechiciansRecords=[Select id,name From Work_Order_Technicians__c where Service_Order__c=: Workordernumber];
            // List<Case> caseRecords=[Select id,Assigned_to__c  from Case where Id=:  woid[0].CaseId];
            if( woid[0].CaseId!=null){
                String assignedTo;
                for(Work_Order_Technicians__c wot :woTechiciansRecords){
                    if(assignedTo==null){
                        assignedTo=wot.name;
                    }else{
                        assignedTo=assignedTo+','+wot.Name;
                    }
                }
                Case caseRecord =new Case();
                caseRecord.id=woid[0].CaseId;
                caseRecord.Assigned_to__c=assignedTo;
                update caseRecord;
            }
            EVL_WorkOrderTechnicianHandler.WorkOrderTechnicianShare(Workordernumber, Tech ,  woid[0].CaseId);
            return 'Success';
        }
        catch(Exception ex) {
            system.debug(ex.getMessage());
            return ex.getMessage();
        }
    }
    
    //added new function
    public class UserbyRoleWrap{
        @AuraEnabled
        public string UserId;
        @AuraEnabled
        public string UserName;    
        @AuraEnabled
        public string UserLoc;
        @AuraEnabled
        public string UserCertSMN;
        
    }  
    
    //Added by sai as part of CT1-61
    @AuraEnabled
    public static List<UserbyRoleWrap> certUserLIst(string Workordernumber){
        //fectching details of service Order
        WorkOrder wkorder = [SELECT Id, FSL_SMN__r.Name,Service_Location__c,Account.Location__c from WorkOrder where Id =: Workordernumber Limit: 1];
        String certSMN = wkorder.FSL_SMN__r.Name;
        String jobLoc = wkorder.Account.Location__c;
        
        List<CSS_AccredUser__c> certifiedUserList = new List<CSS_AccredUser__c>(); 
        List<UserbyRoleWrap > ulstwrap = new List < UserbyRoleWrap > ();
        List <CSS_UserLocation__c> lstUser =  new List <CSS_UserLocation__c>();
        
        if(certSMN != '' && jobLoc != ''){       
            lstUser = [Select id,Name,UserId__r.Name,UserId__r.lastname,UserId__r.firstname,Location_code__c,Location_Name__c FROM CSS_UserLocation__c WHERE Location_code__c=:jobLoc and Location_Source__c != 'ARF' and IsActive__c =true and Location_Name__c!=null order by UserId__r.lastname asc];
            system.debug('lstUser user>>> :  '+lstUser);
            certifiedUserList = [select User_Login_ID__c,User__c,User__r.Name,Service_Model_Name__c from CSS_AccredUser__c where Location__c=:jobLoc and User__r.IsActive=: True and Service_Model_Name__c=:certSMN];
            system.debug('certifiedUserList: '+certifiedUserList);
        }
        
        string tempSMN;
        for (CSS_UserLocation__c b: lstUser) { 
            for(CSS_AccredUser__c accredUser :  certifiedUserList )
            {  
                tempSMN='';
                if(accredUser.User__c == b.UserId__c){     
                    UserbyRoleWrap uwrap = new UserbyRoleWrap();
                    uwrap.UserId = b.UserId__c;
                    uwrap.UserName = b.UserId__r.FirstName+' '+b.UserId__r.LastName;
                    uwrap.UserLoc = b.Location_Name__c;
                    tempSMN=accredUser.Service_Model_Name__c;
                    uwrap.UserCertSMN=tempSMN;
                    ulstwrap.add(uwrap);  
                } 
                
            }
            system.debug('ulstwrap '+ ulstwrap);
        } 
        return ulstwrap;
    }       
}