public class FSLSolCompWrappers {
    public class CSSCompsWrp
    {
        @auraEnabled public List<CSSCompPartOptionsWrp> cssSoldOpts{get;set;}   
        @auraEnabled public String compName{get;set;}
        @auraEnabled public String compId{get;set;}
        @auraEnabled public Boolean selectedComp{get;set;}
        @auraEnabled public Boolean isPartsIntegrationPassed{get;set;} //added by sruthi 02/22 VGRS2-339
        public CSSCompsWrp()
        {
            cssSoldOpts = new List<CSSCompPartOptionsWrp>();
            isPartsIntegrationPassed = TRUE;  //added by sruthi 02/22 VGRS2-339
        }
    }
    public class CSSCompPartOptionsWrp
    {
        @auraEnabled public String partName{get;set;}
        @auraEnabled public String replReason{get;set;}
        @auraEnabled public Decimal defQty{get;set;}
        @auraEnabled public Id partOptId{get;set;}//added by vinod yella - for repair radio buttons
        @auraEnabled public Boolean selectedPart{get;set;} 
        @auraEnabled public string Assignment{get;set;}//trupthi-8/10-NIN-481
        public CSSCompPartOptionsWrp(String partName, String replReason, Decimal defQty, string Assignment)
        {
            this.partName=partName;
            this.replReason=replReason;
            this.defQty=defQty;
            this.Assignment=Assignment;//trupthi-8/10-NIN-481
            
        }
        
        //added below constructor to pass part option id
        public CSSCompPartOptionsWrp(String partName, String replReason, Decimal defQty, Id partOptId,Boolean selectedPart, string Assignment ) //  added by trupthi-8/10-added Assignment-NIN-481
        {
            this.partName=partName;
            this.replReason=replReason;
            this.defQty=defQty;
            this.partOptId=partOptId;
            this.selectedPart=selectedPart;
            this.Assignment=Assignment;//trupthi-8/10-NIN-481
        }
        public CSSCompPartOptionsWrp(){}
    }
}