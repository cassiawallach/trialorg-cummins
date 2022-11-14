public class CSS_Form {
    public list<CSS_JobForms__c> jobforms {set;get;}
    public ID Wid;

    public string sortform{set;get;}
    public List<formWrapper> lstformWrapper{get;set;}
    public string formdesc {set;get;}
    public Id JobId {
        get;
        set {
            JobId = value;
        }
    }
    public Id formId {
        get;
        set {
            formId = value;
        }
    }
    public CSS_Form(){
        Wid=ApexPages.CurrentPage().getParameters().get('Id');
        formdesc ='2';
        sortform();         
        jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, RecordType.Name FROM CSS_JobForms__c where service_job__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms'  or RecordType.Name='InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') limit 5];  //TSR Changes
        // jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where service_job__c =:Wid limit 5]; 
        // jobforms1 = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id =:'a1B2C0000008dGxUAI' ]; 

    }
    public List<SelectOption> getSortvalues1() {
        List<SelectOption> SortList = new List<SelectOption>(); 


        SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
        SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));

        return SortList;
    }
    public pagereference getform1(){ 
        PageReference pageRef = new pageReference('/apex/CSS_JSAForm?id='+wid+'&jformId='+formId); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void sortform(){
        try{
            system.debug('sortform---'+sortform);

            if(formdesc=='1')    
            {
                // jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid order by LastModifiedDate asc];  //TSR Story changes
                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, RecordType.Name, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name='InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate asc];
                system.debug('jobforms--->'+jobforms); 
                lstformWrapper=null;
                 String FormType;
				String PageName;
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
                                pageName = 'CG_InShopJSA';
                            }
                         else
                            if(c.RecordType.Name == 'FieldServiceJSA'){
                                FormType = 'Field Service JSA';
                                pageName = 'CG_FieldServiceJSA';
                            }
                        else
                            if(c.RecordType.Name == 'MarineJSA'){
                                FormType = 'Marine JSA';
                                pageName = 'CG_MarineJSA';
                            }
                        else
                            if(c.RecordType.Name == 'PowerGenJSA'){
                                FormType = 'Power Gen JSA';
                                pageName = 'CG_PowerGenJSA';
                            }

                        lstformWrapper.add(new formWrapper(c,c.JSA_File_Name__c,c.Id,Wid,FormType,pageName));
                        //lstformWrapper.add(new formWrapper(c,'string'));
                    }
                }
            }

            else if(formdesc=='2'){
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid order by LastModifiedDate desc];

                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, RecordType.Name, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name='InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate desc];  //TSR Story changes
                system.debug('jobforms--->'+jobforms);
                lstformWrapper=null;
                 String FormType;
				String PageName;
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
                                pageName = 'CG_InShopJSA';
                            }
                         else
                            if(c.RecordType.Name == 'FieldServiceJSA'){
                                FormType = 'Field Service JSA';
                                pageName = 'CG_FieldServiceJSA';
                            }
                        else
                            if(c.RecordType.Name == 'MarineJSA'){
                                FormType = 'Marine JSA';
                                pageName = 'CG_MarineJSA';
                            }
                        else
                            if(c.RecordType.Name == 'PowerGenJSA'){
                                FormType = 'Power Gen JSA';
                                pageName = 'CG_PowerGenJSA';
                            }

                        lstformWrapper.add(new formWrapper(c,c.JSA_File_Name__c,c.Id,Wid,FormType,pageName));
                        system.debug('shanthi CSS_JobForms__css2'+ lstformWrapper);
                        //lstformWrapper.add(new formWrapper(c,'string'));
                    }

                }
            }
        }
        catch(exception e){
            system.debug('Exception'+e.getMessage());
        } 
    }
    public class formWrapper{
        public CSS_JobForms__c jobforming {get;set;}
        public string fileName {get;set;}
        public id Wid {get;set;}
        public Id jformId {get;set;}
        public string Type {get; set;}
        public string pgName {get; set;}
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