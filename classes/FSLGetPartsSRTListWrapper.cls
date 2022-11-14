public class FSLGetPartsSRTListWrapper {
    @auraEnabled public List<DataArea> dataArea{get;set;}
    public class DataArea{
        @auraEnabled public String Assignment{get;set;}
        @auraEnabled public String PartNumberService{get;set;}
        @auraEnabled public String OEM{get;set;}
        @auraEnabled public String FailureName{get;set;}
        @auraEnabled public String Qty{get;set;}
        @auraEnabled public String OptionNumber{get;set;}
        @auraEnabled public String PartNumberMfg{get;set;}
        @auraEnabled public String PartSize{get;set;}
        @auraEnabled public String PartNameService{get;set;}
        @auraEnabled public String FailureID{get;set;}
        @auraEnabled public String Notes{get;set;}
    }    
}