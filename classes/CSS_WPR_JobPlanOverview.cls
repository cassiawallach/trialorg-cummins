global class CSS_WPR_JobPlanOverview {
    public string name{get;set;}
    public List<string> relatedName{get;set;}
    public List<solWrapper> solList{get;set;}
    public string diagTime{get;set;}
    public string repTime{get;set;}
    public string failcode{get;set;}
    public List<string> partsList{get;set;}
    public Integer allCompCountForFC {get;set;}
    public CSS_WPR_JobPlanOverview(){
        relatedName = new List<string>();
        solList = new List<solWrapper>(); 
        partsList = new List<string>();
    }

    public class solWrapper{
        public string solNumber{get;set;}
        public string solTitle{get;set;}
        public string solResponse{get;set;}
        public boolean outOfOrder{get;set;}
        public boolean hasComponent{get;set;}
        public List<string> failcodelst{get;set;}
        public List<solCompWrapper> solCompWrap{get;set;}
        public List<string> partsListCount{get;set;}
        public Integer allCompCountForSol {get;set;}
        public Id solutionid{get;set;}
        public Id SymptomId{get;set;} //Kalpana stroy#117210
        public String ParentSolName {get;set;}
        public solWrapper(){
            this.solNumber = solNumber;
            this.solTitle = solTitle;
            this.solResponse = solResponse;
            this.outOfOrder = outOfOrder;
            this.failcodelst = failcodelst;
            this.hasComponent = hasComponent;
            this.solCompWrap = solCompWrap;
            this.partsListCount=partsListCount;
            this.solutionid=solutionid;
            this.SymptomId=SymptomId;
            this.ParentSolName=ParentSolName;
        }
    }     
    
    public class solCompWrapper{
        public list<SelectOption> lstConcatenatedFailcodes{get;set;}
        public list<SelectOption> lstAccountCodes{get;set;}
        public Id compId {get;set;}
        public string compName {get;set;}
        public string failcodelist{get;set;}
        public string failcodeEditable{get;set;}
        public string accountCodeEditable{get;set;}
        public boolean selectedcomp{get;set;}
        public string accountCode{get;set;}
        public string accountCodeType{get;set;}
        public String isAuthorized{get;set;}
        public String failmode{get;set;}
        public String failmodedesc{get;set;}
        public String claimtype{get;set;}
        public Boolean JPORootCause {get; set;} // Added as part of GSSC-385 story 2
        public solCompWrapper(){//list<SelectOption> lstConcatenatedFailcodes,list<SelectOption> lstAccountCodes,Id compId,string compName,string failcodelist,string failcodeEditable,string accountCodeEditable,boolean selectedcomp,string accountCode,string accountCodeType){
            
            //lstAccountCodes.add(new SelectOption('Select One','Select One'));
            this.lstConcatenatedFailcodes = lstConcatenatedFailcodes;
            lstAccountCodes = new list<SelectOption>();
            this.compId = compId;
            this.compName=compName;
            this.failcodelist = failcodelist;
            this.failcodeEditable = failcodeEditable;
            this.accountCodeEditable = accountCodeEditable;
            this.selectedcomp=selectedcomp;
            this.accountCode = accountCode;
            this.accountCodeType = accountCodeType;
            this.isAuthorized = isAuthorized;
            this.failmode = failmode;
            this.claimtype = claimtype;
            this.JPORootCause =JPORootCause; // Added as part of GSSC-385 story 2
        }
    }
}