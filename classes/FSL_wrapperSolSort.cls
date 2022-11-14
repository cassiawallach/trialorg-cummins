global class FSL_wrapperSolSort implements Comparable {
    @auraenabled global string karticle {get;set;}
    @auraenabled global string krepairs {get;set;}
    @auraenabled global string kvalidations {get;set;}
    @auraenabled global string solname {get;set;}
    @auraenabled global Id kurlName {get;set;}
    @auraEnabled global String urlName {get;set;}
    @auraenabled global string defsname {get;set;}
    @auraenabled global String solPos {get;set;}
    @auraenabled global String soldiagnostic {get;set;}
    @auraenabled global String solcomm {get;set;}
    @auraenabled global String parentUserStamp {get;set;}
    @auraenabled global String nestedSolVal {get;set;}
    @auraenabled global String srepair {get;set;}
    @auraenabled global String srepairnote {get;set;}
    @auraenabled global Decimal solPosDecimal {get;set;}
    @auraenabled global String selectedsolname {get;set;} //added by mallika to get the selected sol from perform repair,t&d
    @auraenabled global String cssSolId {get;set;}//added by Vinod Yellala-5-22
    @auraenabled global string repairSol{get;set;} //added by Sriprada - 07/18
    @auraenabled global string diagTargetTimeOrMsg{get;set;}
    @auraenabled global string stageName{get;set;} //Harsha for removing checkbox No Access SRT Required in Jobplan
    @auraenabled global Boolean isParent{get;set;} // Added by Murali for Road 106/107 11/29/2021
    // Updated by Murali for Road 106/107 11/29/2021 - Uncommenting the previous changes START
    global FSL_wrapperSolSort(String ssname,String solPos, String name, String article, Id kurlName, String UrlName,
                              String defSol, String solDiag, String solcomment,String srepair,String srepairnotes,
                              String puserStamp,String nestedVal,String cssSolId,string repair,string validation,
                              string repairSolDef,string diagTargetTimeOrMsg, Boolean isParent){
                                  this.selectedsolname=ssname;
                                  this.solname=name;
                                  this.karticle=article;
                                  this.kurlName=kurlName;
                                  this.urlName=UrlName;//updated by vinod yelala 5/10
                                  this.defsname=defSol;
                                  this.solPos = solPos;
                                  this.solPosDecimal = Decimal.valueOf(solPos);
                                  this.soldiagnostic=solDiag;
                                  this.solcomm=solcomment;
                                  this.srepair = srepair;
                                  this.srepairnote = srepairnotes;
                                  this.parentUserStamp=puserStamp;
                                  this.nestedSolVal=nestedVal;
                                  this.cssSolId=cssSolId;
                                  this.kvalidations=validation;
                                  this.krepairs=repair;
                                  this.repairSol=repairSolDef;
                                  this.diagTargetTimeOrMsg=diagTargetTimeOrMsg;
                                  this.isParent = isParent;
                              }
   
    global Integer compareTo(Object ObjToCompare) {
        System.debug('Here**'+solPosDecimal);
        string solPosString = string.valueOf(solPosDecimal);
        Integer posval=solPosString.charAt(0);
        if(posval !=null){
       return Integer.valueOf(solPosDecimal -((FSL_wrapperSolSort)objToCompare).solPosDecimal+1);
        }
        else{
            return solPos.CompareTo(((FSL_wrapperSolSort)ObjToCompare).solPos);
        }
    }
}