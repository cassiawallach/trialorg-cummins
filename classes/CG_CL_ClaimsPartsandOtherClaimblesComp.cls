public class CG_CL_ClaimsPartsandOtherClaimblesComp {
    
    
    public List<claimablesWrapperClass> listpartWrapper {get;set;} 
     public List<claimablesWrapperClass> listpartWrapper2 {get;set;} 
    public Set<claimablesWrapperClass> setpartWrapper {get;set;}
    public Integer assignedParts{get;set;}
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public boolean ErrorMessage1 {get; set;}
    public boolean ErrorMessage {get; set;}
     public CG_CL_ClaimsPartsandOtherClaimblesComp(){
         ErrorMessage1 = false;
         ErrorMessage = false;
         getallCustomPartsData();
     
     }
     
     public void getallCustomPartsData(){
         
        
        listpartWrapper = new List<claimablesWrapperClass>();
        setpartWrapper = new Set<claimablesWrapperClass>();
        for(integer i=0;i<5;i++){
            CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
            partsoption.Item__c = 'Select One';
            partsoption.Part_Description__c='N/A';
            partsoption.Quantity__c = null;
            partsoption.amount__c = null;
            //partsoption.Quantity__c ='';
            partsoption.Covered__c =null ;
            partsoption.Fail_Code__c = '';
            partsoption.Account_Code__c = '';
            
            setpartWrapper.add(new claimablesWrapperClass(i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,
                                                          String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c));
        }

        system.debug('setpartWrapper else>>>>>>>>>>:'+setpartWrapper);
        if(setpartWrapper.size()>0){

            listpartWrapper.addAll(setpartWrapper);
            system.debug('listpartWrapper>>>>>>>'+listpartWrapper.size());
        }
       
     }
     
      public void AddRow(){
        try{
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();

            listpartWrapper2.add(new claimablesWrapperClass(listpartWrapper2.size(),null,null,'N/A',null,null,null,null,null));
            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
            system.debug('listpartWrapper data--->'+listpartWrapper);
            system.debug('listpartWrapper size--->'+listpartWrapper.size());
            //listpartWrapper2 = null;
        }catch(Exception ex) {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
     
     public void removingRow(){
        System.debug('in removingRow GSQ Parts:6');
        System.debug('listpartWrapper IN REMOVE ROW'+listpartWrapper);
        try{
            listpartWrapper2=listpartWrapper.clone();
            listpartWrapper.clear();
            for(Integer i=0;i<listpartWrapper2.size();i++){
                if(listpartWrapper2[i].counting==assignedParts){
                    System.debug('assignedParts '+assignedParts);
                    System.debug('listpartWrapper[i].counting '+listpartWrapper2[i].counting);
                    listpartWrapper2[i].quantity='';
                    listpartWrapper2[i].PartDescription='N/A';
                    listpartWrapper2[i].Item='';
                    listpartWrapper2[i].amount=null;
                    listpartWrapper2[i].coveredPercent='';
                    listpartWrapper2[i].failCode='';
                    listpartWrapper2[i].accountCode='';

                    if(listpartWrapper2[i].ids != null && String.valueOf(listpartWrapper2[i].ids).trim() !=''){
                        removeIdsMap.put(listpartWrapper2[i].ids, String.valueOf(listpartWrapper2[i].ids));
                    }
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                }
            }

            listpartWrapper=listpartWrapper2.clone();
            listpartWrapper2.clear();
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
     
     
      public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        //options.add( new SelectOption('','Select'));
        Schema.DescribeFieldResult fieldResult =  CSS_Parts_Options__c.Item__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(),f.getLabel()));
        }       
        return options;
    }
    
    
    //Method for display the fail codes from UI side as per #105558 (RAJESH)
    public List<SelectOption> getfailcodeDropDown()    
    {    
        List<SelectOption> options =  new List<SelectOption>(); 
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();

        //List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        //solsComp= [SELECT Id, FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:Wid and FailCode_Formula__c!=null and Solutions__r.Diagnostic_Response__c='Most likely the solution' and Selected_Component__c= true];
        options.add(new SelectOption('Select One','Select One'));
        //system.debug('Test+solsComp'+solsComp);
        /*if(solsComp.size()>0){
            for(CSS_Solution_Component__c f:solsComp)  {
                if(f.FailCode_Formula__c!='Select One')
                    sortableSet.add(f.FailCode_Formula__c);

                system.debug('sortableSet  ' +  sortableSet);


            }
       // }*/
        //if(sortableSet.size()>0){
            //sortable.AddAll(sortableSet);}
        /*sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                options.add(new selectOption(s,s));                    
            }   
        }
        */
        return Options;    
    }
    //END
     
    public List<SelectOption> getAccountCodeDropDown() {
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        system.debug('Inside method');
         List<SelectOption> accCodes =new List<SelectOption>(); 
        /*
        try{
            lstAccountCodes = new list<String>();

            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            workJob=[Select Id,Name,AccessCode__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Shop_Work_Order__c, Application__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                     Service_Model__c, VIN__c, Customer_Code__c,Status__c, Model__c,Creator_Location__c,ESN__c 
                     from CSS_Job_Order__c where id= :Wid];
            List<CSS_Solution_Component__c> SolCmps = [SELECT  Id, FailCode_Formula__c,Fail_Code_Editable__c,AccountCode__c,AccountCodeEdit__c ,CoveredPartsQty__c,Fail_Code__c, CSS_Account_Formula__c from CSS_Solution_Component__c where Service_Job__c =:Wid];
            system.debug('Creator_Location__c'+workJob.Creator_Location__c);
            Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;

            system.debug('orgtype--->'+orgtype);
            //system.debug('Regionterritory--->'+Regionterritory.Region__c);
            system.debug('userRole--->'+userRole);

            if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE')) 
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{ 
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }

            if(jobEventTemp.size() > 0){
                system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                system.debug('jobEventTempData-->'+jobEventTemp);
                accCodes = new List<SelectOption>();
                accCodes.add(new SelectOption('Select One','Select One'));
                for(CSS_JobEventTemporary__c j : jobEventTemp){
                    string s = j.Attribute2__c+' '+ j.Attribute3__c;

                    sortableSet.add(s); //Ed
                    // accCodes.add(new SelectOption(s,s));
                    //lstAccountCodes.add(j.Attribute2__c);
                    //  lstAccountCodes.add(s);
                }
            }
            for(CSS_Solution_Component__c solcmp : SolCmps){
                /*    if(solcmp.AccountCode__c !=null &&  solcmp.AccountCode__c != '')
                     sortableSet.add(solcmp.AccountCode__c);
                if(solcmp.AccountCodeEdit__c !=null &&  solcmp.AccountCodeEdit__c != '')
                    sortableSet.add(solcmp.AccountCodeEdit__c); */
          /*      if(solcmp.CSS_Account_Formula__c !=null)
                    sortableSet.add(solcmp.CSS_Account_Formula__c);
            }
            system.debug('sortableSet'+ sortableSet);
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);}
            sortable.sort();
            if (sortable.size()>0){
                for(String s:sortable)    
                {accCodes.add(new selectOption(s,s));  }   
            }
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }
        */
        accCodes.add(new SelectOption('Select One','Select One'));
        return accCodes;       

    }
    
    
     
     public void saveOtherClaimables(){
         
     }
     
      public class claimablesWrapperClass {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String item {get;set;}
        public String PartDescription {get;set;}
        public String quantity {get;set;}
        public Decimal amount {get;set;}
        public String coveredPercent {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}

        public claimablesWrapperClass(Integer counting,Id ids,String item,string PartDescription,String Quantity,Decimal amount,String coveredPercent,String failCode,String accountCode) {
            this.counting = counting;
            this.ids = ids;

            this.idStr = ids;
            this.item = item;
            this.PartDescription=PartDescription;
            this.quantity = quantity;
            this.amount = amount;
            this.coveredPercent = coveredPercent;
            this.failCode = failCode;
            this.accountCode = accountCode;

        }        
    }
     

}