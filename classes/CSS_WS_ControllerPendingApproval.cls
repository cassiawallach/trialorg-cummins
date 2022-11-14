Public Class CSS_WS_ControllerPendingApproval{
    
    Public List<claimsList> claimsLists { get; set; }
    Public Integer index { get; set; }
    Public String Status { get; set; }
    Public String ClaimNumber { get; set; }
    Public String DRName { get; set; }
    Public String DealerName { get; set; }
    Public String CustomerName { get; set; }
    Public String ServiceModel { get; set; }
    Public String ModelSeries { get; set; }
    Public String FailureName { get; set; }
    Public Decimal QuotationAmount { get; set; }
    Public Decimal AuthorizedAmount { get; set; }
    Public String AssignedTo { get; set; }
    Public Id Identifier { get; set; }    
    Public List<CSS_WS_Warranty__c> Claims { get; set; } 
    Public CSS_WS_Warranty__c claimTemp { get; set; }
    Public Map<Id, String> map_user_list { get; set; } 
    Public String ApproverSel { get; set; } 
    
    Public CSS_WS_ControllerPendingApproval(ApexPages.StandardController stdController){
        System.debug('Inicio CSS_WS_ControllerPendingApproval ****** CSS_WS_ControllerPendingApproval');
        this.claimTemp = (CSS_WS_Warranty__c)stdController.getRecord();
        this.ClaimsLists = new List<claimsList>();
        this.Claims = new List<CSS_WS_Warranty__c>();
        this.getClaimsList();
    }
        
    Public Class claimsList{
        Public CSS_WS_Warranty__c Claim { get; set; }
        Public Integer Index { get; set; }
        Public String ClaimNumber { get; set; }
        Public String DRName { get; set; }
        Public String DealerName { get; set; }
        Public String CustomerName { get; set; }
        Public String ServiceModel { get; set; }
        Public String ModelSeries { get; set; }
        Public String FailureName { get; set; }
        Public Decimal QuotationAmount { get; set; }
        Public Decimal AuthorizedAmount { get; set; }
        //Public String Status { get; set; }
        Public String AssignedTo { get; set; }
        Public Id Identifier { get; set; }
        Public claimsList(Integer Index, String ClaimNumber, String DRName, String DealerName, String CustomerName, String ServiceModel, String ModelSeries, String FailureName, Decimal QuotationAmount, Decimal AuthorizedAmount, String Status, String AssignedTo, Id Identifier){
            this.Index = Index;
            this.ClaimNumber = ClaimNumber;
            this.DRName = DRName;
            this.DealerName = DealerName;
            this.CustomerName = CustomerName;
            this.ServiceModel = ServiceModel;
            this.ModelSeries = ModelSeries;
            this.FailureName = FailureName;
            this.QuotationAmount = QuotationAmount;
            this.AuthorizedAmount = AuthorizedAmount;
            //this.Status = Status;
            this.AssignedTo = AssignedTo;
            this.Identifier = Identifier;
                try {//Validate not nulls
                    Claim = new CSS_WS_Warranty__c(CSS_WS_Claim_Status__c = Status);
                } catch(Exception e){}
        }
    }
    
    Public Void getClaimsList(){
        Claims = new List<CSS_WS_Warranty__c>();
        ClaimsLists = new List<claimsList>();
    
        // Query to get all Approval Step Instances in an approval process(ProcessInstance) on which is pending and users has to perform some action next on it
        List<ProcessInstanceWorkitem> pending_approval_list = [SELECT Id, ActorId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending'];
                    
        // Create a map with all Approval Step Instances in an approval process(ProcessInstance); the Id is the key
        Map<String, ProcessInstanceWorkitem> map_pending_approval = new Map<String, ProcessInstanceWorkitem>();
        for(ProcessInstanceWorkitem temp_approval: pending_approval_list){
            map_pending_approval.put(temp_approval.ProcessInstance.TargetObjectId, temp_approval);
        }
        //system.debug(map_pending_approval);
        
        // Query to get users
        List<User> user_list = [SELECT Id, Name, LastName FROM User WHERE Profile.Name LIKE 'CSS_WS_%'];

        // Create a map with all Users
        Map<String, User> map_user = new Map<String, User>();
        for(User temp_user: user_list){
            map_user.put(temp_user.Id, temp_user);
        }
        //system.debug(map_user);

        // Query to get queues
        List<GroupMember> group_list = [SELECT GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue'];

        // Create a map with all Queues
        Map<String, GroupMember> map_group = new Map<String, GroupMember>();
        for(GroupMember temp_group: group_list){
            map_group.put(temp_group.GroupId, temp_group);
        }
        //system.debug(map_group);      
        
        // Query to get accounts
        List<Account> account_list = [SELECT Id, Name FROM Account WHERE type = 'Customer' AND RecordType.Name = 'CSS_WS_RT_Customer_Accounts'];

        // Create a map with all Account
        Map<String, Account> map_account = new Map<String, Account>();
        for(Account temp_account: account_list){
            map_account.put(temp_account.Id, temp_account);
        }
        //system.debug(map_account);
        
        try{
            Claims = [SELECT Id, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c,
            CSS_WS_Customer_Name_Internal__c, CSS_WS_Service_Model__c, CSS_WS_Model_Series__c, (SELECT CSS_WS_Failure_Name__c FROM CSS_WS_FailureW__r LIMIT 1),
            CSS_WS_Quotation_Total_Amount__c ,CSS_WS_Authorized_Amount__c FROM CSS_WS_Warranty__c WHERE CSS_WS_Claim_Status__c =: 'Pending TSM' ORDER BY Name DESC];
        } catch (Exception e){
            System.debug('Error '+ e.getMessage());
        }

        //System.debug(Claims);
        if(Claims != null){
            map_user_list = new Map<Id, String>();
            if(Claims.size() > 0){
                for(Integer i = 0; i < Claims.size(); i++){
                    //Account customer = [SELECT Name FROM Account WHERE id =: Claims[i].CSS_WS_Customer_Name_Internal__c LIMIT 1];
                    this.Index = i + 1;
                    this.ClaimNumber = Claims[i].Name;
                    this.DRName = Claims[i].CSS_WS_Service_Provider_Name_DR__c;
                    this.DealerName = Claims[i].CSS_WS_Service_Provider_Name_Dealer__c;
                    
                    // Get name of Customer from Account Object
                    Id customer_Id = Claims[i].CSS_WS_Customer_Name_Internal__c;
                    String customer_name = '';
                    if (map_account.containsKey(customer_Id)){ //If exist an user is assigned
                        Account account_assigned = map_account.get(customer_Id);
                        customer_name = account_assigned.Name;
                    }
                    this.CustomerName = customer_name;
                    
                    this.ServiceModel = Claims[i].CSS_WS_Service_Model__c;
                    this.ModelSeries = Claims[i].CSS_WS_Model_Series__c;
                    
                    // Get failure name of the claim
                    CSS_WS_Failure__c[] failure_list = claims[i].CSS_WS_FailureW__r;
                    if (failure_list.size() > 0){
                        this.FailureName = failure_list[0].CSS_WS_Failure_Name__c;
                    }
                    
                    this.QuotationAmount = Claims[i].CSS_WS_Quotation_Total_Amount__c; 
                    this.AuthorizedAmount = Claims[i].CSS_WS_Authorized_Amount__c;
                    this.Status = Claims[i].CSS_WS_Claim_Status__c;  
                    
                    //process to get name of assigned user or group
                    Id claim_id = Claims[i].Id;
                    String assigned_name = '';
                    if(map_pending_approval.containsKey(claim_id)){//If exist the approval process in progress
                        ProcessInstanceWorkitem pending_approval = map_pending_approval.get(claim_id);
                        Id actor_id = pending_approval.ActorId;
                        if (map_user.containsKey(actor_id)){ //If exist an user is assigned
                            User user_assigned = map_user.get(actor_id);
                            assigned_name = user_assigned.Name; // + ' ' + user_assigned.LastName;
                        } else if (map_group.containsKey(actor_id)){
                            GroupMember group_assigned = map_group.get(actor_id);
                            assigned_name = group_assigned.Group.Name;
                        }
                        map_user_list.put(actor_Id, assigned_name);
                    } 
                    this.AssignedTo = assigned_name;
                    this.Identifier = Claims[i].Id;
                    this.AddNewClaim();
                }
                //System.debug('List of claims ' + ClaimsLists);
                //System.debug('Mapa de usuarios: ' + map_user_list);
            }
        }
    }    
    
    Public Void getClaimsListApprover(){
        Claims = new List<CSS_WS_Warranty__c>();
        ClaimsLists = new List<claimsList>();
    
        // Query to get all Approval Step Instances in an approval process(ProcessInstance) on which is pending and users has to perform some action next on it
        List<ProcessInstanceWorkitem> pending_approval_list = [SELECT Id, ActorId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.Status = 'Pending'];
                    
        // Create a map with all Approval Step Instances in an approval process(ProcessInstance); the Id is the key
        Map<String, ProcessInstanceWorkitem> map_pending_approval = new Map<String, ProcessInstanceWorkitem>();
        for(ProcessInstanceWorkitem temp_approval: pending_approval_list){
            map_pending_approval.put(temp_approval.ProcessInstance.TargetObjectId, temp_approval);
        }
        //system.debug(map_pending_approval);
        
        // Query to get users
        List<User> user_list = [SELECT Id, Name, LastName FROM User WHERE Profile.Name LIKE 'CSS_WS_%'];

        // Create a map with all Users
        Map<String, User> map_user = new Map<String, User>();
        for(User temp_user: user_list){
            map_user.put(temp_user.Id, temp_user);
        }
        //system.debug(map_user);

        // Query to get queues
        List<GroupMember> group_list = [SELECT GroupId, Group.Name, UserOrGroupId FROM GroupMember WHERE Group.Type = 'Queue' AND Group.DeveloperName LIKE 'CSS_WS_%'];

        // Create a map with all Queues
        Map<String, GroupMember> map_group = new Map<String, GroupMember>();
        for(GroupMember temp_group: group_list){
            map_group.put(temp_group.GroupId, temp_group);
        }
        //system.debug(map_group);  
        
        // Query to get accounts
        List<Account> account_list = [SELECT Id, Name FROM Account WHERE type = 'Customer' AND RecordType.Name = 'CSS_WS_RT_Customer_Accounts'];

        // Create a map with all Account
        Map<String, Account> map_account = new Map<String, Account>();
        for(Account temp_account: account_list){
            map_account.put(temp_account.Id, temp_account);
        }
        //system.debug(map_account);      
        
        try{
            Claims = [SELECT Id, Name, CSS_WS_Claim_Status__c, CSS_WS_Service_Provider_Name_DR__c, CSS_WS_Service_Provider_Name_Dealer__c,
            CSS_WS_Customer_Name_Internal__c, CSS_WS_Service_Model__c, CSS_WS_Model_Series__c, (SELECT CSS_WS_Failure_Name__c FROM CSS_WS_FailureW__r LIMIT 1),
            CSS_WS_Quotation_Total_Amount__c , CSS_WS_Authorized_Amount__c FROM CSS_WS_Warranty__c WHERE CSS_WS_Claim_Status__c =: 'Pending TSM' ORDER BY Name DESC];
        } catch (Exception e){
            System.debug('Error '+ e.getMessage());
        }
        
        // If the "All Pending Aprovers" option is selected
        if (ApproverSel != 'All'){        
            //System.debug(Claims);
            if(Claims != null){
                if(Claims.size() > 0){           
                    integer cont = 0;
                    Id selected_approver = Id.valueOf(ApproverSel);
                    for(Integer i = 0; i < Claims.size(); i++){
                        Id claim_id = Claims[i].Id;
                        String assigned_name = '';
                        if (map_pending_approval.containsKey(claim_id)){
                            ProcessInstanceWorkitem pending_approval = map_pending_approval.get(claim_id);
                            if (pending_approval.ActorId == selected_approver){
                                Id actor_id = pending_approval.ActorId;
                                if (map_user.containsKey(actor_id)){ //If exist an user is assigned
                                    User user_assigned = map_user.get(actor_id);
                                    assigned_name = user_assigned.Name; // + ' ' + user_assigned.LastName;
                                } else if (map_group.containsKey(actor_id)){
                                    GroupMember group_assigned = map_group.get(actor_id);
                                    assigned_name = group_assigned.Group.Name;
                                }
                                
                                //Account customer = [SELECT Name FROM Account WHERE id =: Claims[i].CSS_WS_Customer_Name_Internal__c LIMIT 1];
                                this.Index = cont + 1;
                                this.ClaimNumber = Claims[i].Name;
                                this.DRName = Claims[i].CSS_WS_Service_Provider_Name_DR__c;
                                this.DealerName = Claims[i].CSS_WS_Service_Provider_Name_Dealer__c;
                                
                                // Get name of Customer from Account Object
                                Id customer_Id = Claims[i].CSS_WS_Customer_Name_Internal__c;
                                String customer_name = '';
                                if (map_account.containsKey(customer_Id)){ //If exist an user is assigned
                                    Account account_assigned = map_account.get(customer_Id);
                                    customer_name = account_assigned.Name;
                                }
                                this.CustomerName = customer_name;
                                
                                this.ServiceModel = Claims[i].CSS_WS_Service_Model__c;
                                this.ModelSeries = Claims[i].CSS_WS_Model_Series__c;
                                
                                // Get failure name of the claim
                                CSS_WS_Failure__c[] failure_list = claims[i].CSS_WS_FailureW__r;
                                if (failure_list.size() > 0){
                                    this.FailureName = failure_list[0].CSS_WS_Failure_Name__c;
                                }
                                 
                                this.QuotationAmount = Claims[i].CSS_WS_Quotation_Total_Amount__c; 
                                this.AuthorizedAmount = Claims[i].CSS_WS_Authorized_Amount__c;
                                this.Status = Claims[i].CSS_WS_Claim_Status__c; 
                                this.AssignedTo = assigned_name;
                                this.Identifier = Claims[i].Id;
                                this.AddNewClaim();
                                cont++;
                                
                            }
                        }
                    }
                    //System.debug('List of claims ' + ClaimsLists);
                }
            }          
            
        } else {            
            //System.debug(Claims);
            if(Claims != null){
                //map_user_list = new Map<Id, String>();
                if(Claims.size() > 0){
                    for(Integer i = 0; i < Claims.size(); i++){
                        //Account customer = [SELECT Name FROM Account WHERE id =: Claims[i].CSS_WS_Customer_Name_Internal__c LIMIT 1];
                        this.Index = i + 1;
                        this.ClaimNumber = Claims[i].Name;
                        this.DRName = Claims[i].CSS_WS_Service_Provider_Name_DR__c;
                        this.DealerName = Claims[i].CSS_WS_Service_Provider_Name_Dealer__c;
                        
                        // Get name of Customer from Account Object
                        Id customer_Id = Claims[i].CSS_WS_Customer_Name_Internal__c;
                        String customer_name = '';
                        if (map_account.containsKey(customer_Id)){ //If exist an user is assigned
                            Account account_assigned = map_account.get(customer_Id);
                            customer_name = account_assigned.Name;
                        }
                        this.CustomerName = customer_name;
                        
                        this.ServiceModel = Claims[i].CSS_WS_Service_Model__c;
                        this.ModelSeries = Claims[i].CSS_WS_Model_Series__c;
                        
                        // Get failure name of the claim
                        CSS_WS_Failure__c[] failure_list = claims[i].CSS_WS_FailureW__r;
                        if (failure_list.size() > 0){
                            this.FailureName = failure_list[0].CSS_WS_Failure_Name__c;
                        } 
                                                
                        this.QuotationAmount = Claims[i].CSS_WS_Quotation_Total_Amount__c; 
                        this.AuthorizedAmount = Claims[i].CSS_WS_Authorized_Amount__c;
                        this.Status = Claims[i].CSS_WS_Claim_Status__c;  
                        
                        //process to get name of assigned user or group
                        Id claim_id = Claims[i].Id;
                        String assigned_name = '';
                        if(map_pending_approval.containsKey(claim_id)){//If exist the approval process in progress
                            ProcessInstanceWorkitem pending_approval = map_pending_approval.get(claim_id);
                            Id actor_id = pending_approval.ActorId;
                            if (map_user.containsKey(actor_id)){ //If exist an user is assigned
                                User user_assigned = map_user.get(actor_id);
                                assigned_name = user_assigned.Name; // + ' ' + user_assigned.LastName;
                            } else if (map_group.containsKey(actor_id)){
                                GroupMember group_assigned = map_group.get(actor_id);
                                assigned_name = group_assigned.Group.Name;
                            }
                            map_user_list.put(actor_Id, assigned_name);
                        } 
                        this.AssignedTo = assigned_name;
                        this.Identifier = Claims[i].Id;
                        this.AddNewClaim();
                    }
                    //System.debug('List of claims ' + ClaimsLists);
                    //System.debug('Mapa de usuarios: ' + map_user_list);
                }
            }            
        }        
    }
    
    Public List<SelectOption> getApproversSelectList(){
        List<SelectOption> approvers = new List<SelectOption>();
        approvers.add(new SelectOption('All', Label.CSS_WS_Global_E012)); 
        
        List<Id> list_ids = new List<Id>();
        list_ids.addAll(map_user_list.keySet());
        list_ids.sort();
        for (Id list_id : list_ids){
            String name = map_user_list.get(list_id);
            approvers.add(new SelectOption(string.valueof(list_id), name));
        }  
        system.debug(approvers);      
        return approvers;
    }
    
    
    Public Void AddNewClaim(){
        try{
            claimsList ClaimToAdd = new claimsList(
                this.Index,
                this.ClaimNumber,
                this.DRName,
                this.DealerName,
                this.CustomerName,
                this.ServiceModel,
                this.ModelSeries,
                this.FailureName,
                this.QuotationAmount,
                this.AuthorizedAmount,
                this.Status,
                this.AssignedTo,
                this.Identifier);
            this.ClaimsLists.add(ClaimToAdd);
            //System.debug('Add Claim ' + this.Index);
        } catch(Exception e){
            System.debug('Error Adding ' + e.getMessage());
        }
    }
    
    Public PageReference exitClaimsUpdate(){
        PageReference claimPage = new ApexPages.StandardController(claimTemp).cancel(); 
        claimPage.setRedirect(true); 
        return claimPage;
    }
    
}