/**********************************************************************
Name:CSS_Formsclass 
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -    Venkat         02/03/2017      INITIAL DEVELOPMENT         
*************************************************************************/

public class CSS_Formsclass {
    public list<CSS_JobForms__c> jobforms {set;get;}
    public Boolean Region {get;set;}
    public ID Wid;
    public transient string sortform{set;get;}
    public transient string formdesc {set;get;}

   /* public String formdesc {
        get;
        set {
            formdesc = value;
        }
    }*/
    public List<formWrapper> lstformWrapper{get;set;}  

    public transient  Id JobId {
        get;
        set {
            JobId = value;
           // sortform();
        }
    }
    public transient Id formId {
        get;
        set {
            formId = value; 
        }
    }
    public CSS_Formsclass(){   
        try{
            
            system.debug('inside formsclass constructor');
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Wid--'+Wid);
            Region = false;
            formdesc ='2';
            sortform();
            //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id in( 'a1B2C0000008dGxUAI' , 'a1B2C0000008dGiUAI') limit 5 ]; 
            //jobforms = [SELECT Id, CreatedBy.firstname,ShopService_Task1__c,RebuildUpfit_Task1__c,FieldPowerGen__c,FieldServiceEngine_Task1__c, CreatedBy.lastname, LastModifiedDate,Service_Job__r.Creator_Location__c FROM CSS_JobForms__c where service_job__c =:Wid limit 5]; 
            jobforms = [SELECT Id, CreatedBy.firstname,ShopService_Task1__c,RebuildUpfit_Task1__c,FieldPowerGen__c,FieldServiceEngine_Task1__c, CreatedBy.lastname, LastModifiedDate,Service_Job__r.Creator_Location__c,RecordType.Name,Service_Job__r.Account__r.Region__c,Service_Job__r.Account__r.Type FROM CSS_JobForms__c where service_job__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') limit 5]; //TSR Changes
            system.debug('jobforms>>'+jobforms);
            if(jobforms.size()>0){
                boolean DealerTypeFlag = CSS_utility.getAccounttype(jobforms[0].Service_Job__r.Account__r.Type); 
                //Account Regionterritory = css_utility.getRegionTerritory(jobforms[0].Service_Job__r.Creator_Location__c);
                if(jobforms[0].Service_Job__r.Account__r.Region__c!=null && jobforms[0].Service_Job__r.Account__r.Region__c != ''){
                    //if((Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA' || Regionterritory.Region__c.toUpperCase() == 'AUSTRALIA/ NEW ZEALAND') && Regionterritory.Type =='Distributor Account')
                    // Modified below as per story 120795
                    //if(jobforms[0].Service_Job__r.Account__r.Type != null && jobforms[0].Service_Job__r.Account__r.Type != '' && jobforms[0].Service_Job__r.Account__r.Type =='Distributor Account' || jobforms[0].Service_Job__r.Account__r.Type =='Distributor Branch Account')
                      if(DealerTypeFlag!=true)
                        Region = true;
                }
            }
            else{
                transient Account Regionterritory = css_utility.getRegionTerritory('');
                if(Regionterritory!=null && Regionterritory.Region__c != null && Regionterritory.Region__c != ''){
                    // if((Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA' || Regionterritory.Region__c.toUpperCase() == 'AUSTRALIA/ NEW ZEALAND') && Regionterritory.Type =='Distributor Account')
                    // Modified below as per story 120795
                    if(Regionterritory.Type =='Distributor Account' || Regionterritory.Type =='Distributor Branch Account')
                        Region = true;
                }
            }
        }catch(exception e){
            system.debug('Entered into catch of constructor method in CSS_FormsClass>>>>>>>'+e.getMessage() + ' ' + e.getLineNumber());
        }
    }

    public List<SelectOption> getSortvalues() {
        try{
            system.debug('**enter into getSortvalues method**');
            transient List<SelectOption> SortList = new List<SelectOption>(); 
           // List<SelectOption> SortList = new List<SelectOption>(); 

            SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
            SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));
            return SortList;
        }

        catch(exception e){
            system.debug('**enter into catch method**');
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
                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c, RecordType.Name FROM CSS_JobForms__c where service_job__c =:Wid  and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate asc limit 5]; // TSR changes
                system.debug('jobforms Sortform--->'+jobforms); 
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
                    system.debug('shanthi CSS_JobForms__css1'+ lstformWrapper);
                }
            }

             else if(formdesc=='2'){
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate FROM CSS_JobForms__c where id in( 'a1B2C0000008dGxUAI' , 'a1B2C0000008dGiUAI') order by CreatedDate desc];
                //jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c FROM CSS_JobForms__c where service_job__c =:Wid order by LastModifiedDate desc limit 5];
                jobforms = [SELECT Id, CreatedBy.firstname, CreatedBy.lastname, LastModifiedDate, JSA_File_Name__c, RecordType.Name FROM CSS_JobForms__c where service_job__c =:Wid and (RecordType.Name = '' or RecordType.Name = 'JSAForms' or RecordType.Name = 'InShopJSA' or  RecordType.Name = 'FieldServiceJSA' or RecordType.Name = 'MarineJSA' or RecordType.Name = 'PowerGenJSA') order by LastModifiedDate desc limit 5];
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