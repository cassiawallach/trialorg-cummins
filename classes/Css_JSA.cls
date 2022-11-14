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
1.0 -  
2.0 -    Rajesh         03/06/2017              Added Code for JSAForm audit trail       
*************************************************************************/
public class Css_JSA{
    
    public Css_JSA(){
        try{
            readOnly = true;
            jobForm = new CSS_JobForms__c();
            workJob = new CSS_Job_Order__c();
            Wid=ApexPages.CurrentPage().getParameters().get('id');
            inputJobformId=ApexPages.CurrentPage().getParameters().get('jformId');
            Copy = ApexPages.CurrentPage().getParameters().get('copybtn');
            system.debug('inputJobformId: '+inputJobformId);
            workJob = [Select Id,Status__c,Customer_Name__c,name,Unit_Number__c from CSS_Job_Order__c where ID =: Wid];        
            AggregateResult[] indexResults = [select  MAX(Index__c) Index from CSS_JobForms__c where Service_Job__c =:Wid];
            Object maxIndex = indexResults[0].get('Index');
            if(maxIndex!=null){
                index = Integer.valueOf(maxIndex)+1;
            }
            else{
                index = 1;
            }
            if(inputJobformId != null){            
                jobForm = [Select id,createddate,createdBy.UserName,CreatedById,Service_Job__c,JSA_Unit_Number__c,JSA_Clone__c,Service_Job__r.Customer_Name__c,Service_Job__r.Name,Service_Job__r.Unit_Number__c,FieldPowerGen_Task2__c, FieldPowerGen__c, FieldServiceEngine_Task1__c, FieldServiceEngine_Task2__c, JSA_NearMiss__c, JSA_Observation__c, JSA__c, Parts_Warehouse_Task1__c, Parts_Warehouse_Task2__c, PreJob__c, RebuildUpfit_Task1__c, RebuildUpfit_Task2__c, ShopService_Task1__c, ShopService_Task2__c,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c,LastModifiedDate  from CSS_JobForms__c where Id=:inputJobformId and Service_Job__c = :Wid limit 1 ];
                queryJobFormDetails(jobForm.Id);
                datetime last24Hours = System.now()-1;
                String loggedinUserId = UserInfo.getUserId();
                if(jobForm.CreatedDate > last24Hours && jobForm.CreatedById == loggedinUserId){
                    readOnly = false;//editable
                    readOnlySave = true;//non-editable
                    if(jobForm.JSA_Clone__c != null && jobForm.JSA_Clone__c != '')
                        readOnly = true;
                }else{
                    readOnly = true;//non-editable
                    readOnlySave = true;//Editable
                    if(jobForm.JSA_Clone__c != null && jobForm.JSA_Clone__c != '')
                        readOnly = false;
                }
                //Added for ROD:90365
                UnitNumber=jobForm.JSA_Unit_Number__c;
            }else{
                jobForm = new CSS_JobForms__c();
                jobForm.Service_Job__c = workJob.Id;
                readOnly = false;
                //Added for ROD:90365
                UnitNumber=workJob.Unit_Number__c;
            }
            //Commented for ROD:90365
            //UnitNumber=workJob.Unit_Number__c;
            getWorkPracticeValuess();
            getErgonomics();
            getTools();
            getPPE();
            getWorkProcedures();
            getCNG();
            Time();
        } catch(exception e){
            system.debug('Entered into Catch Block of Constructor in CSS_JSA Controller' +e.getMessage() + ' ' + e.getLineNumber());
        }
    }
    
    public CSS_JobForms__c jobForm {get;set;}
    public CSS_Job_Order__c workJob {get;set;}
    public string Copy {get;set;}
    public string Save {get;set;}
    public ID Wid {get;set;}
    public string inputJobformId;
    public string UnitNumber{get;set;}
    public Boolean displayPopup {get;set;} 
    public Boolean readOnly {get;set;}
    public Boolean readOnlySave {get;set;}
    public List<wrapWorkPracticeValues>  lstwrapWorkPracticeValues{get;set;}  
    public List<wrapErgonomicsValues>  lstwrapErgonomicsValues{get;set;}  
    public List<wrapToolsValues>  lstwrapToolsValues{get;set;}  
    public List<wrapPPEValues>  lstwrapPPEValues{get;set;}  
    public List<wrapWorkProceduresValues>  lstWorkProceduresValues{get;set;}  
    public List<wrapCNGValues>  lstwrapCNGValues{get;set;} 
    public integer index;
    public String currentTime{get;set;}
    public String currentDate{get;set;}
    public String UserName{get;set;}
    
    public void Time(){
        try{
            //added for defect 91493 by venkat
            if(inputJobformId == null || inputJobformId == ''){
                system.debug('Anirudh Entered if>>>>>>>>');
                assignTimeDate();
            }else{
                if(jobForm.JSA_CreatorName__c == null || jobForm.JSA_CreatorName__c == ''){
                    assignTimeDate();
                }else{
                    system.debug('Anirudh Entered Else'+jobForm.JSA_CreatorName__c);
                    UserName = jobForm.JSA_CreatorName__c;
                    if(jobForm.JSA_TimeZone__c != null){
                        String[] dateTimeZone = jobForm.JSA_TimeZone__c.split('-');
                        currentTime = dateTimeZone[0];
                        currentDate = dateTimeZone[1];
                    }
                }
            }
        }catch(exception e){
            system.debug('Entered into catch block of Time Method in CSS_JSA Controller' +e.getLineNumber() + ' ' +e.getMessage());
        }
    }
    
    public void assignTimeDate(){
        currentTime = System.now().format('hh:mma z');
        currentDate = System.now().format('MM/dd/YYYY');
        UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
    }
    
    public void showPopup() {
        displayPopup = true;
    }
    
    public void closePopup() {
        displayPopup = false;
    }
    public List<CSS_JobForm_Detail__c> lstformdetails{set;get;}
    public void queryJobFormDetails(Id jobFormId){
        try{        
            lstformdetails = [select Id,CSS_JobForms__c,JSA_WorkPractice_CriticalBehaviour__c,Form_Safe__c,JSA_Ergonomics_CriticalBehaviour__c,JSA_Tools_CriticalBehaviour__c,
                              JSA_PPE_CriticalBehaviour__c,JSA_CNG_CriticalBehaviour__c,JSA_WrkProcedures_CriticalBehaviour__c,Form_Closed_Ctrl__c,Form_NA__c,Form_AtRisk__c,Form_ReasonNotes__c from CSS_JobForm_Detail__c where CSS_JobForms__c = :jobFormId ];
            system.debug('lstformdetails: '+lstformdetails);
            lstwrapWorkPracticeValues  = new List<wrapWorkPracticeValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_WorkPractice_CriticalBehaviour__c != null){
                    wrapWorkPracticeValues wr1 = new wrapWorkPracticeValues(fordetail.JSA_WorkPractice_CriticalBehaviour__c);
                    wr1.formId = fordetail.Id;
                    wr1.criticalBehaviours = fordetail.JSA_WorkPractice_CriticalBehaviour__c;
                    wr1.safe = fordetail.Form_Safe__c;
                    wr1.notApplicable = fordetail.Form_NA__c;
                    wr1.closed = fordetail.Form_Closed_Ctrl__c;
                    wr1.risk = fordetail.Form_AtRisk__c;
                    wr1.closedComments = fordetail.Form_ReasonNotes__c;
                    lstwrapWorkPracticeValues.add(wr1);
                }
            }
            lstwrapErgonomicsValues=new List<wrapErgonomicsValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_Ergonomics_CriticalBehaviour__c != null){
                    wrapErgonomicsValues wr2 = new wrapErgonomicsValues(fordetail.JSA_Ergonomics_CriticalBehaviour__c);
                    wr2.formId = fordetail.Id;
                    wr2.criticalBehaviours = fordetail.JSA_Ergonomics_CriticalBehaviour__c;
                    wr2.safe = fordetail.Form_Safe__c;
                    wr2.notApplicable = fordetail.Form_NA__c;
                    wr2.closed = fordetail.Form_Closed_Ctrl__c; 
                    wr2.risk = fordetail.Form_AtRisk__c;
                    wr2.closedComments = fordetail.Form_ReasonNotes__c;
                    lstwrapErgonomicsValues.add(wr2);
                }
            }
            lstwrapToolsValues=new List<wrapToolsValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_Tools_CriticalBehaviour__c != null){
                    wrapToolsValues wr3 = new wrapToolsValues(fordetail.JSA_Tools_CriticalBehaviour__c);
                    wr3.formId = fordetail.Id;
                    wr3.criticalBehaviours = fordetail.JSA_Tools_CriticalBehaviour__c;
                    wr3.safe = fordetail.Form_Safe__c;
                    wr3.notApplicable = fordetail.Form_NA__c;
                    wr3.closed = fordetail.Form_Closed_Ctrl__c;
                    wr3.risk = fordetail.Form_AtRisk__c;
                    wr3.closedComments = fordetail.Form_ReasonNotes__c;
                    lstwrapToolsValues.add(wr3);
                }
            }
            lstwrapPPEValues=new List<wrapPPEValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_PPE_CriticalBehaviour__c != null){
                    wrapPPEValues wr4 = new wrapPPEValues(fordetail.JSA_PPE_CriticalBehaviour__c);
                    wr4.formId = fordetail.Id;
                    wr4.criticalBehaviours = fordetail.JSA_PPE_CriticalBehaviour__c;
                    wr4.safe = fordetail.Form_Safe__c;
                    wr4.notApplicable = fordetail.Form_NA__c;
                    wr4.closed = fordetail.Form_Closed_Ctrl__c;
                    wr4.risk = fordetail.Form_AtRisk__c;
                    wr4.closedComments = fordetail.Form_ReasonNotes__c;
                    lstwrapPPEValues.add(wr4);
                }
            }
            lstWorkProceduresValues =new List<wrapWorkProceduresValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_WrkProcedures_CriticalBehaviour__c != null){
                    wrapWorkProceduresValues wr5 = new wrapWorkProceduresValues(fordetail.JSA_WrkProcedures_CriticalBehaviour__c);
                    wr5.formId = fordetail.Id;
                    wr5.criticalBehaviours = fordetail.JSA_WrkProcedures_CriticalBehaviour__c;
                    wr5.safe = fordetail.Form_Safe__c;
                    wr5.notApplicable = fordetail.Form_NA__c;
                    wr5.closed = fordetail.Form_Closed_Ctrl__c;
                    wr5.risk = fordetail.Form_AtRisk__c;
                    wr5.closedComments = fordetail.Form_ReasonNotes__c;
                    lstWorkProceduresValues.add(wr5);
                }
            }
            lstwrapCNGValues=new List<wrapCNGValues>();                                                        
            for(CSS_JobForm_Detail__c fordetail : lstformdetails){
                if(fordetail.JSA_CNG_CriticalBehaviour__c != null){
                    wrapCNGValues wr6 = new wrapCNGValues(fordetail.JSA_CNG_CriticalBehaviour__c);
                    wr6.formId = fordetail.Id;
                    wr6.criticalBehaviours = fordetail.JSA_CNG_CriticalBehaviour__c;
                    wr6.safe = fordetail.Form_Safe__c;
                    wr6.notApplicable = fordetail.Form_NA__c;
                    wr6.closed = fordetail.Form_Closed_Ctrl__c;
                    wr6.risk = fordetail.Form_AtRisk__c;
                    wr6.closedComments = fordetail.Form_ReasonNotes__c;
                    lstwrapCNGValues.add(wr6);
                }
            }
            system.debug('lstwrapWorkPracticeValues: '+lstwrapWorkPracticeValues);
        } catch(exception e){
            system.debug('Entered into Catch Block of Quer Job form Method in CSS_JSA Controller' +e.getMessage() + ' ' + e.getLineNumber());
        }
    } 
    public void getWorkPracticeValuess(){
        try{
            if(lstwrapWorkPracticeValues==null){
                lstwrapWorkPracticeValues=new List<wrapWorkPracticeValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_WorkPractice_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstWorkPracticeValues = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>();
                
                for(Schema.PicklistEntry entry : lstWorkPracticeValues){
                    // picklstValue.add(entry.getValue());
                    //lstwrapWorkPracticeValues.add(new wrapWorkPracticeValues( entry.getValue(),false,false,null,null,null,null));
                    lstwrapWorkPracticeValues.add(new wrapWorkPracticeValues( entry.getValue()));
                    
                }
            }
        }catch(exception e){
            system.debug('Entered into Catch Block of WorkPracticeValuess Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public List<SelectOption> getriskvaluue(){
        try{
            List<SelectOption> options = new List<SelectOption>();        
            Schema.DescribeFieldResult fieldResult =
                CSS_JobForm_Detail__c.Form_AtRisk__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
            options.add(new selectoption('','--None--'));
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            system.debug('options>>>>>>>'+options);
            return options;
        }catch(exception e){
            system.debug('Entered into Catch Block of getriskvaluue Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }
    }
    
    public List<SelectOption> getclosedctrl(){
        try{
            List<SelectOption> options = new List<SelectOption>();        
            Schema.DescribeFieldResult fieldResult =
                CSS_JobForm_Detail__c.Form_Closed_Ctrl__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();  
            options.add(new selectoption('','--None--'));
            for( Schema.PicklistEntry f : ple)
            {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }       
            return options;
        } catch(exception e){
            system.debug('Entered into Catch Block of getclosedctrl Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }
    }
    
    Transient List<AggregateResult> ServiceEngine1List = new List<AggregateResult>();   
    
    
    public void getErgonomics(){
        try{
            if(lstwrapErgonomicsValues==null){
                lstwrapErgonomicsValues=new List<wrapErgonomicsValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_Ergonomics_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstErgonomics = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>();
                
                for(Schema.PicklistEntry entry : lstErgonomics){
                    //picklstValue.add(entry.getValue());
                    lstwrapErgonomicsValues.add(new wrapErgonomicsValues( entry.getValue()));
                }
                
            }
        } catch(exception e){
            system.debug('Entered into Catch Block of getErgonomics Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public void getTools(){
        try{
            if(lstwrapToolsValues==null){
                lstwrapToolsValues=new List<wrapToolsValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_Tools_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstTools = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>(); 
                for(Schema.PicklistEntry entry : lstTools){
                    //picklstValue.add(entry.getValue());
                    lstwrapToolsValues.add(new wrapToolsValues( entry.getValue()));
                }
                
            }
        }catch(exception e){
            system.debug('Entered into Catch Block of getTools Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    public void getPPE(){
        try{
            if(lstwrapPPEValues==null){
                lstwrapPPEValues=new List<wrapPPEValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_PPE_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstPPE = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>();
                
                //css_job_order__c c = new css_job_order__c();
                //lstAppValues = getPickLstValues(c,'application__c');
                
                for(Schema.PicklistEntry entry : lstPPE){
                    //picklstValue.add(entry.getValue());
                    lstwrapPPEValues.add(new wrapPPEValues( entry.getValue()));
                }
            }
        } catch(exception e){
            system.debug('Entered into Catch Block of getPPE Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        } 
    }
    
    public void getWorkProcedures(){
        try{
            if(lstWorkProceduresValues==null){
                lstWorkProceduresValues=new List<wrapWorkProceduresValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_WrkProcedures_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstWrkProcedures = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>();
                
                for(Schema.PicklistEntry entry : lstWrkProcedures){
                    //picklstValue.add(entry.getValue());
                    lstWorkProceduresValues.add(new wrapWorkProceduresValues( entry.getValue()));
                }
            }
        } catch(exception e){
            system.debug('Entered into Catch Block of getWorkProcedures Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    
    public void getCNG(){
        try{
            if(lstwrapCNGValues==null){
                lstwrapCNGValues=new List<wrapCNGValues>();
                Schema.DescribeFieldResult fieldResult = CSS_JobForm_Detail__c.JSA_CNG_CriticalBehaviour__c.getDescribe();
                List<Schema.PicklistEntry> lstCNG = fieldResult.getPicklistValues();
                List<String> picklstValue = new List<String>();
                
                for(Schema.PicklistEntry entry : lstCNG){
                    //picklstValue.add(entry.getValue());
                    lstwrapCNGValues.add(new wrapCNGValues( entry.getValue()));
                }
            }
        } catch(exception e){
            system.debug('Entered into Catch Block of getCNG Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }
    public PageReference formSave()
    {
        try{
            CSS_JobForms__c jsaForm = new CSS_JobForms__c();    
            jsaForm.Service_Job__c = Wid;
            if(jobForm.Id != null)
                jsaForm.Id =jobForm.Id;
            jsaForm.JSA__c =jobForm.JSA__c;
            jsaForm.JSA_NearMiss__c =jobForm.JSA_NearMiss__c;
            jsaForm.JSA_Observation__c =jobForm.JSA_Observation__c;
            jsaForm.PreJob__c =jobForm.PreJob__c;
            jsaForm.FieldPowerGen__c =jobForm.FieldPowerGen__c;
            jsaForm.FieldPowerGen_Task2__c =jobForm.FieldPowerGen_Task2__c;
            jsaForm.FieldServiceEngine_Task1__c =jobForm.FieldServiceEngine_Task1__c;
            jsaForm.FieldServiceEngine_Task2__c =jobForm.FieldServiceEngine_Task2__c;
            jsaForm.RebuildUpfit_Task1__c =jobForm.RebuildUpfit_Task1__c;
            jsaForm.RebuildUpfit_Task2__c =jobForm.RebuildUpfit_Task2__c;
            jsaForm.ShopService_Task1__c =jobForm.ShopService_Task1__c;
            jsaForm.ShopService_Task2__c =jobForm.ShopService_Task2__c;
            jsaForm.Parts_Warehouse_Task1__c =jobForm.Parts_Warehouse_Task1__c;
            jsaForm.Parts_Warehouse_Task2__c =jobForm.Parts_Warehouse_Task2__c;
            jsaForm.JSA_File_Name__c = UserInfo.getFirstName()+UserInfo.getLastName()+'_'+ System.now().format('MMddYYYY_hh:mma z');
            jsaForm.Index__c = index;
            //Added for ROD:90365
            jsaForm.JSA_Unit_Number__c=UnitNumber;
            jsaForm.JSA_CreatorName__c = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
            jsaForm.JSA_TimeZone__c = System.now().format('hh:mma z') + '-' + System.now().format('MM/dd/YYYY');
            upsert jsaForm;
            //Commented for ROD:90365
            //workJob.Unit_Number__c = UnitNumber;
            workJob.Id = Wid;
            update workJob;
            
            List<CSS_JobForm_Detail__c> lstformdetails = new List<CSS_JobForm_Detail__c>();
            for(wrapWorkPracticeValues wrapperobj : lstwrapWorkPracticeValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_WorkPractice_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  }
                
            }
            for(wrapErgonomicsValues wrapperobj : lstwrapErgonomicsValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_Ergonomics_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  }  
                
            }
            for(wrapToolsValues wrapperobj : lstwrapToolsValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_Tools_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  } 
                
            }
            for(wrapPPEValues wrapperobj : lstwrapPPEValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_PPE_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  } 
                
            }
            for(wrapWorkProceduresValues wrapperobj : lstWorkProceduresValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_WrkProcedures_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  }  
                
            }
            for(wrapCNGValues wrapperobj : lstwrapCNGValues){
                CSS_JobForm_Detail__c formdetails = new CSS_JobForm_Detail__c();
                formdetails.CSS_JobForms__c=jsaForm.Id;
                formdetails.Id=wrapperobj.formId;
                formdetails.JSA_CNG_CriticalBehaviour__c=wrapperobj.criticalBehaviours;
                formdetails.Form_Safe__c=wrapperobj.safe;
                formdetails.Form_NA__c=wrapperobj.notApplicable;
                formdetails.Form_Closed_Ctrl__c=wrapperobj.closed;
                formdetails.Form_AtRisk__c=wrapperobj.risk;
                formdetails.Form_ReasonNotes__c=wrapperobj.closedComments;
                if(wrapperobj.safe==false && wrapperobj.notApplicable== false && wrapperobj.risk=='--None--' && wrapperobj.closed=='--None--' && (wrapperobj.closedComments=='' ||wrapperobj.closedComments==null)){}
                else{
                    lstformdetails.add(formdetails);  }  
                
            }
            upsert lstformdetails;
            //Rajesh Added Code for JSAForm audit trail 
            //Id Uid=UserInfo.getUserId();   
            // User u= [SELECT Id, firstname,LastModifiedDate FROM user where id =:UserInfo.getUserId() limit 1]; 
            /*System.debug('UserId===>'+u.id);
Database.SaveResult resultHist;
CSS_JobHistory__c InsertHistRec = new CSS_JobHistory__c();
InsertHistRec.CSS_Object_Name__c = 'css_JSAForm';
InsertHistRec.CSS_Field_Name__c = 'Copy';
InsertHistRec.CSS_Old_Value__c = 'Added JSA form';
InsertHistRec.CSS_New_Value__c = UserInfo.getFirstName()+UserInfo.getLastName()+'_'+ u.LastModifiedDate.format('MMddYYYY_hh:mma z');
InsertHistRec.CSS_Job_Id__c =wid;
if (InsertHistRec != null)
{
resultHist = Database.insert(InsertHistRec);                
System.debug('resultHist--->'+resultHist);
}
//Rajesh Code End */
            //PageReference pageRef = new pageReference('/apex/CSS_JSAForm?id='+Wid+'&jformId'+jsaForm.Id); 
            PageReference pageRef = Page.CSS_JSAForm;
            system.debug('jsaForm.Id: '+jsaForm.Id);
            pageRef.getParameters().put('id',Wid);
            pageRef.getParameters().put('jformId',jsaForm.Id);
            pageRef.getParameters().put('copybtn','false');
            pageRef.setRedirect(true);
            return pageRef;
            //return null;
        } catch(exception e){
            system.debug('Entered into Catch Block of formSave Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }
    }
    public PageReference cloneForm(){
        try{
            if(jobForm == null && jobForm.Id == null){            
                return null;
            }
            CSS_JobForms__c cloneForm = new CSS_JobForms__c();            
            cloneForm = jobForm.clone(false);
            cloneForm.Service_Job__c = Wid;
            cloneForm.JSA_Clone__c = jobForm.Id;
            insert cloneForm;
            List<CSS_JobForm_Detail__c> cloneJobDetforms = new List<CSS_JobForm_Detail__c>();
            for(CSS_JobForm_Detail__c fordetail:lstformdetails){
                CSS_JobForm_Detail__c cloneFormDet = new CSS_JobForm_Detail__c();
                cloneFormDet = fordetail.clone(false);
                cloneFormDet.CSS_JobForms__c = cloneForm.Id;
                cloneJobDetforms.add(cloneFormDet);
            }
            if(!cloneJobDetforms.isEmpty())
                insert cloneJobDetforms;
            PageReference pageRef = Page.CSS_JSAForm;
            system.debug('jsaForm.Id: '+cloneForm.Id);
            pageRef.getParameters().put('id',Wid);
            pageRef.getParameters().put('jformId',cloneForm.Id);
            pageRef.getParameters().put('Copybtn','false');
            pageRef.setRedirect(true);
            return pageRef; 
        }  catch(exception e){
            system.debug('Entered into Catch Block of cloneForm Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }
    }
    //Wrapper of WorkPractice
    public class wrapWorkPracticeValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapWorkPracticeValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    //Wrapper of Ergonomics
    public class wrapErgonomicsValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapErgonomicsValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    //Wrapper of Tools
    public class wrapToolsValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapToolsValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    //Wrapper of PPE
    public class wrapPPEValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapPPEValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    //Wrapper of WorkProcedures
    public class wrapWorkProceduresValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapWorkProceduresValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    //Wrapper of CNG
    public class wrapCNGValues{
        public Id formId {get;set;}
        public string criticalBehaviours {get;set;}
        public Boolean safe {get;set;}
        public Boolean notApplicable {get;set;}
        public string risk {get;set;}
        public string closed {get;set;}
        public string closedComments {get;set;}
        public wrapCNGValues(string cb){
            criticalBehaviours=cb;
            safe=false;
            notApplicable=false;
            risk=null;
            closed=null;
            closedComments=null;           
        }
    }
    
    
}