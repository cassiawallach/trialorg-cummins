public class FSL_FormsClass {
    public transient list<CSS_JobForms__c> jobforms {set;get;}
    public transient Boolean Region {get;set;}
    public transient ID Wid;
    public transient string sortform{set;get;}
    public transient string formdesc {set;get;}
    public transient List<formWrapper> lstformWrapper{get;set;}  
    public transient Id JobId {
        get;
        set {
            JobId = value;
        }
    }
    public transient Id formId {
        get;
        set {
            formId = value; 
        }
    }
    public FSL_FormsClass() {   
        try{
            system.debug('inside formsclass constructor');
            Wid=ApexPages.CurrentPage().getParameters().get('Id');
            system.debug('*****'+Wid);
            Region = false;
            formdesc ='2';
            sortform();
            //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id in( 'a1B2C0000008dGxUAI' , 'a1B2C0000008dGiUAI') limit 5 ]; 
            //jobforms = [SELECT Id, CreatedBy.firstname,ShopService_Task1__c,RebuildUpfit_Task1__c,FieldPowerGen__c,FieldServiceEngine_Task1__c, CreatedBy.lastname, LastModifiedDate,Service_Job__r.Creator_Location__c FROM CSS_JobForms__c where service_job__c =:Wid limit 5];
            jobforms = [SELECT Id, CreatedBy.firstname, ShopService_Task1__c, RebuildUpfit_Task1__c, FieldPowerGen__c, FieldServiceEngine_Task1__c, CreatedBy.LastName, LastModifiedDate, ServiceJob__r.ServiceTerritory.Location_Code__c, RecordType.Name, ServiceJob__r.Account.Region__c, ServiceJob__r.Account.Type FROM CSS_JobForms__c WHERE ServiceJob__c =:Wid AND (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') limit 5]; //TSR Changes
            system.debug('jobforms>>'+jobforms);
            /*if(jobforms.size()>0){
                system.debug('*jobforms[0].ServiceJob__r.Account.Region__c****'+jobforms[0].ServiceJob__r.Accountid);
                if(jobforms[0].ServiceJob__r.Account.Region__c!=null && jobforms[0].ServiceJob__r.Account.Region__c != ''){
                    system.debug('*jobforms[0].ServiceJob__r.Account.Type****'+jobforms[0].ServiceJob__r.Account.Type);
                    if(jobforms[0].ServiceJob__r.Account.Type != null && jobforms[0].ServiceJob__r.Account.Type != '' && jobforms[0].ServiceJob__r.Account.Type =='Distributor Account')
                        Region = true;
                }
            }
            else{
                transient Account Regionterritory = css_utility.getRegionTerritory('');
                system.debug('*Regionterritory.Region__c****'+Regionterritory.Region__c);
                if(Regionterritory!=null && Regionterritory.Region__c != null && Regionterritory.Region__c != ''){
                    // if((Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA' || Regionterritory.Region__c.toUpperCase() == 'AUSTRALIA/ NEW ZEALAND') && Regionterritory.Type =='Distributor Account')
                    // Modified below as per story 120795
                     system.debug('*Regionterritory.Region__cRegionterritory.Type****'+Regionterritory.Type);
                    if(Regionterritory.Type =='Distributor Account'){
                    	Region = true;    
                    }
                        
                }
            }*/
            Region = true;	
        }catch(exception e){
            system.debug('Entered into catch of constructor method in CSS_FormsClass>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }

    public List<SelectOption> getSortvalues() {
        try{
            transient List<SelectOption> SortList = new List<SelectOption>(); 


            SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
            SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));

            return SortList;
        }

        catch(exception e){
            return null;
        }

    }
  /*  public pagereference getform(){
        PageReference pageRef = new pageReference('/apex/CSS_JSAForm?id='+wid+'&jformId='+formId+'&copybtn=true'); 
        pageRef.setRedirect(true);
        return pageRef;
    } */

    public void sortform(){
        try{
            system.debug('sortform---'+sortform);

            if(formdesc=='1')    
            {
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id in( 'a1B2C0000008dGxUAI' , 'a1B2C0000008dGiUAI') order by CreatedDate asc];
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid order by LastModifiedDate asc limit 5];
                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c, RecordType.Name FROM CSS_JobForms__c where servicejob__c =:Wid  and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate asc limit 5]; // TSR changes
                system.debug('jobforms--->'+jobforms); 
                String FormType;
                String PageName;
                lstformWrapper=null;

                if(lstformWrapper == null) {
                    lstformWrapper = new List<formWrapper>();    

                    for(CSS_JobForms__c c: jobforms){
                        system.debug('shanthi CSS_JobForms__c1'+c);

                        if(c.RecordType.Name == 'JSAForms' || c.RecordType.Name == ''){
                            FormType = 'JSA';
                            pageName = 'CSS_JSAForm';
                        }
                        else
                            if(c.RecordType.Name == 'InShopJSA'){
                                FormType = 'In-Shop JSA';
                                pageName = 'FSL_InShopJSA';
                            }
                        else
                            if(c.RecordType.Name == 'FieldServiceJSA'){
                                FormType = 'Field Service JSA';
                                pageName = 'FSL_FieldServiceJSA';
                            }
                        else
                            if(c.RecordType.Name == 'MarineJSA'){
                                FormType = 'Marine JSA';
                                pageName = 'FSL_MarineJSA';
                            }
                        else
                            if(c.RecordType.Name == 'PowerGenJSA'){
                                FormType = 'Power Gen JSA';
                                pageName = 'FSL_PowerGenJSA';
                            }

                        lstformWrapper.add(new formWrapper(c,c.JSA_File_Name__c,c.Id,Wid,FormType,pageName));
                        system.debug('shanthi CSS_JobForms__css1'+ lstformWrapper);
                        //lstformWrapper.add(new formWrapper(c,'string'));
                    }
                }
            }

            else if(formdesc=='2'){
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id in( 'a1B2C0000008dGxUAI' , 'a1B2C0000008dGiUAI') order by CreatedDate desc];
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid order by LastModifiedDate desc limit 5];
                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c, RecordType.Name FROM CSS_JobForms__c where servicejob__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate desc limit 5];
                system.debug('jobforms--->'+jobforms); 

                //  system.debug('jobforms.RecordType.Name>>>>' + jobforms.RecordType.Name);

                String FormType;
                String PageName;

                lstformWrapper=null;
                if(lstformWrapper == null) {
                    lstformWrapper = new List<formWrapper>(); 

                    for(CSS_JobForms__c c: jobforms){
                        system.debug('shanthi CSS_JobForms__c2'+c);

                        if(c.RecordType.Name == 'JSAForms' || c.RecordType.Name == ''){
                            FormType = 'JSA';
                            pageName = 'CSS_JSAForm';
                        }
                        else
                            if(c.RecordType.Name == 'InShopJSA'){
                                FormType = 'In-Shop JSA';
                                pageName = 'FSL_InShopJSA';
                            }
                        
                        else
                            if(c.RecordType.Name == 'FieldServiceJSA'){
                                FormType = 'Field Service JSA';
                                pageName = 'FSL_FieldServiceJSA';
                            }
                        else
                            if(c.RecordType.Name == 'MarineJSA'){
                                FormType = 'Marine JSA';
                                pageName = 'FSL_MarineJSA';
                            }
                        else
                            if(c.RecordType.Name == 'PowerGenJSA'){
                                FormType = 'Power Gen JSA';
                                pageName = 'FSL_PowerGenJSA';
                            }
                        system.debug('FormType >>>>'+ FormType + 'pageName>>>>>' + pageName);    
                        lstformWrapper.add(new formWrapper(c,c.JSA_File_Name__c,c.Id,Wid,FormType,pageName));
                        system.debug('shanthi CSS_JobForms__css2'+ lstformWrapper);           
                    }

                }           
            }

        }
        catch(exception e){
            system.debug('Exception'+e.getMessage());
        } 
    }
    public class formWrapper{
        public transient CSS_JobForms__c jobforming {get;set;}
        public transient string fileName {get;set;}
        public transient id Wid {get;set;}
        public transient Id jformId {get;set;}
        public transient string Type {get; set;}
        public transient string pgName {get; set;}
        public formWrapper(CSS_JobForms__c jobfor,String JSAFileName,Id formId,Id JobId, string FType, string FpgName){ //
            jobforming=jobfor;
            fileName=JSAFileName;
            Wid = JobId;
            jformId = formId;
            Type = FType;
            pgName =FpgName;
        }
    }
}