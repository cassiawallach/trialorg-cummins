/*
 * Block comments with details of changes
 */
public class CSS_JobPlanCampaignsTrpController
    {
    public Id Wid {get;set;}
    public  String  headerdata{get;set;}
    public string urls {get;set;}
    //public string ESN {get;set;}
    public String jobOrdNumber { get; set; }
    public List<SelectOption> cltype{get;set;}//CSS_Solution_Component__c also has a field type Claim_Type__c
    public List<SolCompWrapper> listSolCompWrapper {get; set;}
    public String SelClaimtype{get;set;}//Selected Claim
    public CSS_Job_Order__c bmsUser{get;set;}
    public CSS_JobPlanCampaignsTrpController()
    {
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        headerdata= ApexPages.currentPage().getHeaders().get('Host');
        urls='https://' + headerdata;
        bmsUser = [select Account__r.ERP_System__c from CSS_Job_Order__c where Id =:Wid];
        system.debug('BMS User ' + bmsUser.Account__r.ERP_System__c);
        getAllRecords();
        fetchclaimtypes();
    }
    // Transient map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>();
    public List<CSS_CampTsbTrp__c> CTA = new  List<CSS_CampTsbTrp__c>();
    public list<CSS_Solution_Component__c> SolCompCampTRP = new list<CSS_Solution_Component__c>(); 
    public list<CSS_Solution_Component__c> ListUpdateSolCompCampTRP{get;set;}
    public integer PartsCount {get;set;}
    public decimal srtTotal;
    public Map<Id,Decimal> srtTotalMap{get;set;}
        
    public List<SelectOption> fetchclaimtypes()
    {
        cltype = new List<SelectOption>();
        //03520-04892 location has data valueo
        cltype=CG_BL_Claims.getClaimType(Wid,'03520-04892','JobPlan');
        //cltype=CG_BL_Intake.getClaimType(Wid,CreatorLocation);
    return cltype;
    }
    public List<CSS_Solution_Component__c> getALLRecords()
    {    
         cltype = new List<SelectOption>();
         listSolcompWrapper = new List<SolcompWrapper>();
        //public void getALLRecords(){
        try{
            //get ESN from the Job.
            String ESN = [Select id,ESN__C from css_job_order__C where id = :Wid limit 1].ESN__C;
            //Querying Campaigns from Solution Component(REsult of FieldAction Service-Warranty System/SIEBEL)
            SolCompCampTRP = [select Type__C, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,Selected_Claim_Type__c,CampaignLaborPercentage__c,
                           (select id, SRT_Time__c,SRT_Select__c from CSS_SRTs__r where SRT_Select__c = true and Type__c = 'Field Action'), CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,
                             (select Id,FailurepartId__c,selected_part__c,FailurepartId__r.AccountCode__c,Service_partnumber__c,OEM__c,Part_Name__c,ReturnToFactory__c,FailurepartId__r.Fail_Code__c,Replacement_Reason__c,Quantity__c,Notes__c,Service_Job__c 
                              from CSS_Parts_Options__r where Service_Job__c != null),AccountCode__c,AccountCodeEdit__c                              
            from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC')  and Service_Job__c =:Wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            
            
            CTA = [select Type__c,URL__c, Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Wid AND ESN__c = :ESN  AND Type__c !='TSB'
                                                                               order by Performed_Review__c desc LIMIT 1000];
            system.debug('SolCompRecords**'+SolCompCampTRP);
            system.debug('CampTSBTRPRecords**'+CTA);
            
            //SelClaimtype=SolCompCampTRP.Selected_Claim_Type__c;
            ListUpdateSolCompCampTRP = new list<css_solution_component__c>();
            srtTotalMap = new Map<Id,Decimal>();
            if((SolCompCampTRP != null && SolCompCampTRP.size()>0) && (CTA != null || CTA.size()>0))
            {
                //pr added
                cltype = fetchclaimtypes();
            //PartsCount = 0;
            for(css_solution_component__c SolComp: SolCompCampTRP)
            {
            for(CSS_CampTsbTrp__c campRec : CTA)
            {
                system.debug('**Inside Second For Loop **');
               // if(SolComp.Component_Id__c == campRec.Doc_Num__c)campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length())
                         if(solComp.Component_Id__c !=null && solComp.Component_Id__c.trim() !='' && campRec.Doc_Num__c !=null && campRec.Doc_Num__c.trim() !='')
                         {
                                if(solComp.Type__c == 'CAMPAIGN')
                                {
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'CAM')
                                    {
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }
                             else if(solComp.Type__c == 'TRP')
                                {
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(1,campRec.Doc_Num__c.length()) && campRec.Type__c == 'TRP')
                                    {
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }
                             else if(solComp.Type__c == 'ATC')
                                {
                                    if(solComp.Component_Id__c == campRec.Doc_Num__c.substring(3,campRec.Doc_Num__c.length()) && campRec.Type__c == 'ATC')
                                    {
                                        solComp.URL__c = campRec.URL__c;
                                        break;
                                    }
                                }

                        }
            }
                PartsCount = 0;
                for(css_parts_options__c parts: solcomp.CSS_Parts_Options__r)
                {
                    PartsCount = PartsCount+1;
                }
                SolComp.Approval_Code__c = String.valueof(PartsCount);
                system.debug('SolComp**'+SolComp);
                system.debug('SolComp.CSS_SRTs__r**'+SolComp.CSS_SRTs__r);
            srtTotal = 0;
            for(CSS_SRT__c srtObj : SolComp.CSS_SRTs__r)
            {
                srtTotal = srtTotal+srtObj.SRT_Time__c;
            }
           system.debug('srtTotal**'+srtTotal);
           srtTotalMap.put(SolComp.Id,srtTotal);
           
            ListUpdateSolCompCampTRP.add(SolComp);
                
            //Mapping the solution coomponent fields to SolCompWrapper 
            listSolCompWrapper.add(new SolCompWrapper(SolComp.id,SolComp.URL__c,SolComp.Type__c+'-'+SolComp.Campaign_Description__c,
                                                          SolComp.Component_id__c,SolComp.Approval_Code__c,SolComp.Fail_Code__c,Solcomp.AccountCodeEdit__C,
                                                          Solcomp.Selected_Claim_Type__c,cltype));
            system.debug('listSolCompWrapper++'+listSolCompWrapper);
        }
            }
            system.debug('ListUpdateSolCompCampTRP**'+ListUpdateSolCompCampTRP);
            system.debug('srtTotalMap**'+srtTotalMap); 
            
        }
        catch(exception e)
        {

        }
        return SolCompCampTRP;
    }
    //Function to Update Claim Type
    public void UpdateSolComWithClaimType()
    {
/*Please do not delete the commented code below*/
        /*if(ListUpdateSolCompCampTRP!=null && ListUpdateSolCompCampTRP.size()>0)
            for(CSS_Solution_Component__c claim : ListUpdateSolCompCampTRP)
            {
                claim.Selected_Claim_Type__c = SelClaimtype;
            }
        update ListUpdateSolCompCampTRP;
        system.debug('Claim Type Saved'+ListUpdateSolCompCampTRP);
        */
        /*The above is commented as there can be more records in the Campaigns, TRPs, and ATCs then it wll not work*/
        
        //Rupesh Orginal Code 
        /*List<CSS_Solution_Component__c>  savesolcomlist = new list<CSS_Solution_Component__c>();//This will be saved to the solution component object
        for(SolCompWrapper scw:listSolCompWrapper)
        {
        CSS_Solution_Component__c  solcomp =  new CSS_Solution_Component__c();
        solcomp.Selected_Claim_Type__c=scw.Selectedclaimtype;
        savesolcomlist.add(solcomp);  
        }*/
        //save method
        //Prabhar's Changes
        try
        {
            List<CSS_Solution_Component__c> lstSolCompToBeUpdated = new List<CSS_Solution_Component__c>();
            if(listSolcompWrapper != null && listSolcompWrapper.size()>0)
            {
                for(SolCompWrapper fcw : listSolcompWrapper)
                {
                    CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                    solComp.Id = fcw.SolCompId;//To update the solution component you need the ID..
                    //solComp.Selected_Component__c = fcw.SelectedComp;
                    solComp.Selected_Claim_Type__c = fcw.Selectedclaimtype;
                    lstSolCompToBeUpdated.add(solComp);
                }
                if(lstSolCompToBeUpdated != null && lstSolCompToBeUpdated.size()>0)
                {
                    update lstSolCompToBeUpdated;
                }
            }
        }catch(Exception e)  
        {
            system.debug('EXCEPTION of saveClaimData method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }  
        
    }
   
    public class SolCompWrapper
    {
        public Id SolCompId {get;set;}
        //public Boolean SelectedComp {get;set;}
        public string QsolURL{get;set;}
        public string FieldAction {get;set;}
        public string FieldActNum {get;set;}
        //public string SrtTotal{get;set;}
        public string Parts{get;set;}
        public string FailCode{get;set;}
        public string AccountCode{get;set;}               
        public string Selectedclaimtype{get;set;}
        public List<SelectOption> ClaimType {get;set;}
        public SolCompWrapper(Id SolCompId,string QsolURL,string FieldAction, string FieldActNum,
                              string Parts,string FailCode, string AccountCode, string Selectedclaimtype, List<SelectOption> ClaimType)
        {
            this.SolCompId = SolCompId;
            //this.SelectedComp = SelectedComp;
            this.FieldAction = FieldAction;
            this.FieldActNum = FieldActNum;
            this.FailCode = FailCode;
            this.AccountCode = AccountCode;
            //this.SrtTotal = SrtTotal;
            this.Parts = Parts;
            this.Selectedclaimtype = Selectedclaimtype;
            this.ClaimType = ClaimType;
            this.QsolURL = QsolURL;
        }
    }

    
    
    
    
    
}