/**********************************************************************
    Name:CG_GetWarrantyDetailesHelper
    Copyright Â© 2019  Cummins
    ======================================================
    ======================================================
    Purpose:                                                            
    -------  
    This class is used for calling the getWarrantyDetailes service on change of few fields from Service job and PSN 
    ======================================================
    ======================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR             DATE              DETAIL                                 
    1.0      Rajesh Pasupuleti  22/07/2019        INITIAL DEVELOPMENT                    
**************************************************************************/
public class CG_GetWarrantyDetailesHelper {
    //Below Method for getting service call on changes of Mileage__c,Mileage_Measure__c,Product_Hours__c and ApplicationCode__c from Service Job Object
    @future(callout=true)
    public static void getWarrantyDetailesForJob(set<id> serviceJobId){
      //  Set<Id> serviceJobId = new Set<Id>();
        Set<string> applicationCodes = new Set<string>{'130','210','220','310','320','410'};
        List<CSS_Solution_Component__c> lstsolutionComp = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> solCompUpdateList = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> solCompDeleteList = new List<CSS_Solution_Component__c>();
        if(serviceJobId.size()>0){
            lstsolutionComp =[Select id,System_Code__c,Component_Code__c,Type__c,Component_Id__c,Service_Job__c,Service_Job__r.ESN__c,
                              Service_Job__r.Creator_Location__c,Service_Job__r.Failure_Date__c,Service_Job__r.Mileage__c,
                              Service_Job__r.Mileage_Measure__c,Service_Job__r.ApplicationCode__c,Service_Job__r.Warranty_Start_Date__c,
                              Service_Job__r.ReconEngineFlag__c,Service_Job__r.name,Service_Job__r.CSS_Hours__c
                              from CSS_Solution_Component__c 
                              where Service_Job__c in : serviceJobId AND Type__c IN ('CAMPAIGN','TRP','ATC')];
            system.debug('**lstsolutionComp**'+lstsolutionComp+'**lstsolutionComp size**'+lstsolutionComp.size());
            if(lstsolutionComp.size()>0){
                string creatorLocation ;
                string name;
                for(integer i=0;i<lstsolutionComp.size();i++){ 
                     CSS_Job_Order__c jobRec = new CSS_Job_Order__c();
                     CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                     CSS_Solution_Component__c compResult = new CSS_Solution_Component__c();
                         //solComp.Id                    = lstsolutionComp[i].id;
                         solComp.System_Code__c        = lstsolutionComp[i].System_Code__c;
                    	 solComp.Component_Code__c     = lstsolutionComp[i].Component_Code__c;
                   	     solComp.Component_Id__c       = lstsolutionComp[i].Component_Id__c;
                   	     solComp.Service_Job__c        = lstsolutionComp[i].Service_Job__c;
                   	     solComp.Type__c               = lstsolutionComp[i].Type__c;
                   	     solComp.name                  = lstsolutionComp[i].Type__c+ lstsolutionComp[i].Component_Id__c;
                         jobRec.ESN__c                 = lstsolutionComp[i].Service_Job__r.ESN__c;
                         creatorLocation               = lstsolutionComp[i].Service_Job__r.Creator_Location__c;
                         jobRec.Failure_Date__c        = lstsolutionComp[i].Service_Job__r.Failure_Date__c;
                         jobRec.ApplicationCode__c     = lstsolutionComp[i].Service_Job__r.ApplicationCode__c;
                         system.debug('**lstsolutionComp[i].Service_Job__r.ApplicationCode__c**'+lstsolutionComp[i].Service_Job__r.ApplicationCode__c);
                         if(applicationCodes.contains(jobRec.ApplicationCode__c)){
                            system.debug('**Application code is Available**');
                            jobRec.Mileage__c          = lstsolutionComp[i].Service_Job__r.Mileage__c;
                            jobRec.Mileage_Measure__c  = lstsolutionComp[i].Service_Job__r.Mileage_Measure__c;
                         }
                         else{
                            system.debug('**Application code is not Available **');
                            jobRec.Mileage__c          = lstsolutionComp[i].Service_Job__r.CSS_Hours__c;
                            jobRec.Mileage_Measure__c  = 'Hours';//lstsolutionComp[i].Service_Job__r.Mileage_Measure__c
                         }
                         
                         jobRec.Warranty_Start_Date__c = lstsolutionComp[i].Service_Job__r.Warranty_Start_Date__c;
                         jobRec.ReconEngineFlag__c     = lstsolutionComp[i].Service_Job__r.ReconEngineFlag__c;
                         name                          = lstsolutionComp[i].Service_Job__r.name;
                //calling getWarrantyDetailes method 
                compResult=CSS_FN_SIEBEL.getWarrantyDetailCoverage(jobRec.ESN__c,creatorLocation.right(5),jobRec.Failure_Date__c,string.valueof(jobRec.Mileage__c),jobRec.Mileage_Measure__c,jobRec.ApplicationCode__c,jobRec.Warranty_Start_Date__c,solComp.System_Code__c,solComp.Component_Code__c,'','',null,false,solComp.Component_Id__c,'','Second Call', jobRec.ReconEngineFlag__c, false,jobRec.Name);
                System.debug('**compResult****' + compResult);
                    if(compResult!=null){
                        system.debug('compResult.AccountCode__c'+compResult.AccountCode__c);
                            if(compResult.AccountCode__c!=null && compResult.AccountCode__c!=''){
                                system.debug('**solComp** ' + solComp);
                                system.debug('**compResult** ' + compResult);
                                //solCompList.add(solComp);
                                solCompUpdateList.add(compResult);
                            }
                            else{
                                system.debug('**Not covered records from Solution component**');
                                solCompDeleteList.add(compResult);
                            }
                    }
                }
            }
        }
        //Delete not covered solution comp Records for the job
        if(solCompDeleteList !=null && solCompDeleteList.size()>0){
            delete solCompDeleteList;
            system.debug('**After deleted Records**'+solCompDeleteList);
        }
        //Update covered solution comp Records for the job    
        if(solCompUpdateList !=null && solCompUpdateList.size() > 0){
            system.debug('**finaly update solCompList**'+solCompUpdateList);
            //insert solCompList;
            update solCompUpdateList;
        }
    }
    //Below Method for getting service call on changes of Mileage__c,Mileage_Measure__c,Product_Hours__c and ApplicationCode__c from PSN Object
    @future(callout=true)
     public static void getWarrantyDetailesForPSN(set<id> claimRecIds){
        Set<string> applicationCodes = new Set<string>{'130','210','220','310','320','410'};
        List<CSS_Claims__c> lstClaimPSNSolCom = new List<CSS_Claims__c>();
        List<CSS_Solution_Component__c> solCompUpdateList = new List<CSS_Solution_Component__c>();
        List<CSS_Solution_Component__c> solCompDeleteList = new List<CSS_Solution_Component__c>();
        
        if(claimRecIds.size()>0){
            lstClaimPSNSolCom=[select id,name,ReconEngineFlag__c,Location_Code__c,
                               (select id,ApplicationCode__c,Mileage__c,Mileage_Measure__c,Product_Hours__c,CSS_Claims__c,PSN__c,Failure_Date__c,Warranty_Start_Date__c from CSS_PSNs__r),
                               (Select id,System_Code__c,Component_Code__c,Type__c,Component_Id__c,Service_Job__c from CSS_Solution_Components__r where Type__c IN ('CAMPAIGN','TRP','ATC'))
                                from CSS_Claims__c
                                where id in : claimRecIds];

            system.debug('**lstClaimPSNSolCom**'+lstClaimPSNSolCom+'**lstClaimPSNSolCom size**'+lstClaimPSNSolCom.size());
            if(lstClaimPSNSolCom.size()>0){
                string creatorLocation ;
                string name;
                for(CSS_Claims__c lstClaim :lstClaimPSNSolCom){
                    for(CSS_PSN__c lstPSN :lstClaim.CSS_PSNs__r){
                        for(CSS_Solution_Component__c lstSolCom :lstClaim.CSS_Solution_Components__r){
                            CSS_PSN__c psnRec = new CSS_PSN__c();
                            CSS_Solution_Component__c solCompRec = new CSS_Solution_Component__c();
                            CSS_Solution_Component__c compResult = new CSS_Solution_Component__c();
                            CSS_Claims__c claimRec = new CSS_Claims__c();
                            //solCompRec.Id                    = lstSolCom.id;
                            solCompRec.System_Code__c        = lstSolCom.System_Code__c;
                            solCompRec.Component_Code__c     = lstSolCom.Component_Code__c;
                            solCompRec.Component_Id__c       = lstSolCom.Component_Id__c;
                            solCompRec.Type__c               = lstsolCom.Type__c;
                            solCompRec.CSS_Claims__c         = lstClaim.Id;
                            solCompRec.name                  = lstsolCom.Type__c+ lstSolCom.Component_Id__c;
                            psnRec.PSN__c                    = lstPSN.PSN__c;
                            creatorLocation                  = lstClaim.Location_Code__c;
                            psnRec.Failure_Date__c           = lstPSN.Failure_Date__c;
                            psnRec.ApplicationCode__c        = lstPSN.ApplicationCode__c;
                            if(applicationCodes.contains(psnRec.ApplicationCode__c)){
                              psnRec.Mileage__c              = lstPSN.Mileage__c;
                              psnRec.Mileage_Measure__c      = lstPSN.Mileage_Measure__c;
                            }
                            else{
                              psnRec.Mileage__c              = lstPSN.Product_Hours__c;
                              psnRec.Mileage_Measure__c      = 'Hours';
                            }
                            psnRec.Warranty_Start_Date__c    = lstPSN.Warranty_Start_Date__c;
                            claimRec.ReconEngineFlag__c      = lstClaim.ReconEngineFlag__c;
                            name                             = lstClaim.name;
                            //calling getWarrantyDetailes method 
                            compResult=CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,creatorLocation.right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,solCompRec.System_Code__c,solCompRec.Component_Code__c,'','',null,false,solCompRec.Component_Id__c,'','Second Call', claimRec.ReconEngineFlag__c, false,name);
                            System.debug('**compResult****' + compResult);
                            if(compResult!=null){
                                compResult.id = lstSolCom.id;
                                system.debug('compResult.AccountCode__c'+compResult.AccountCode__c);
                                if(compResult.AccountCode__c!=null && compResult.AccountCode__c!=''){
                                    system.debug('**compResult** ' + compResult);
                                    solCompUpdateList.add(compResult);
                                }
                                else{
                                    solCompDeleteList.add(compResult);
                                }
                            }
                        }
                    }
                }
            }
        }
        //Delete Not covered solution comp Records for the claim
        if(solCompDeleteList !=null && solCompDeleteList.size()>0){
            delete solCompDeleteList;
            system.debug('**After deleted Records**'+solCompDeleteList);
        }
       //Update covered solution comp Records from the for the claim     
        if(solCompUpdateList !=null && solCompUpdateList.size() > 0){
            system.debug('**finaly update solCompUpdateList**'+solCompUpdateList);
            update solCompUpdateList;
        }
    }
}