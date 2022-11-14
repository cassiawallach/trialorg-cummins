/*
 * Block comments with details of changes
 */
public class CSS_UserAddedPartsController {
    public Id pgId{get;set;}
    public id Wid; 
    public string  serviceJobNumber {get;set;}
    public list<CSS_Parts_Options__c> newPartList{get; set;}// added as part of 101 SOQL Fix
    public list<CSS_Parts_Options__c> existPartList{get; set;}
    public CSS_Job_Order__c serviceJob = new CSS_Job_Order__c();
    public list<CSS_Parts_Options__c> eprPartList{get; set;}
    public transient list<CSS_Parts_Options__c> partsList{get; set;}
    public Boolean DealerTypeFlag{get;set;}
    public CSS_UserAddedPartsController(){
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        //GSSC-442, commented as it is not used in the component.
        // css_job_order__c jobData = [select Id,Account__r.Type,CSS_Travel_Rate__c, Account__c from css_job_order__c where Id = : Wid];
        //DealerTypeFlag = CSS_utility.getAccounttype(jobData.Account__r.Type);//Venkat
    }

    public void getUserAddedParts(){
        newPartList = [select Id, Name, Notes__c, OEM__c, Quantity__c, Replacement_Reason__c, Part_Name__c,Assignment__c, Part_Description__c, Option_Number__c, 
                         Part_size__c,Selected_part__c, Covered__c,FailurepartId__c, Service_partnumber__c, Account_Code__c, Get_Fail_Code_Formula__c,Fail_Code__c, Service_Job__c, ReturnToFactory__c from CSS_Parts_Options__c where  Service_Job__c =: pgId AND Parts_Type__c = 'Custom'];
        
        //Commented below query as part of 101 SOQL Fix
        //partsList = [select Id, Name, Selected_part__c, FailurepartId__c, Service_partnumber__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c from CSS_Parts_Options__c where Service_Job__c =: pgId AND Parts_Type__c = 'Custom' AND ReturnToFactory__c = ''];
        partsList = new list<CSS_Parts_Options__c>();
        existPartList = new list<CSS_Parts_Options__c>();
        if(newPartList != null && newPartList.size()>0){
            for(CSS_Parts_Options__c p : newPartList){
                if(p.ReturnToFactory__c ==''){
                    partsList.add(p);
                }
                existPartList.add(p);
            }
        }
        system.debug('partsList--'+partsList);
        if(partsList.size() > 0) {
            eprPartList = CSS_FN_SIEBEL.getPartsReturn(partsList);
         if(eprPartList.size() > 0)
                update eprPartList;
              }
        
        
        //commented below query as part of 101 SOQL fix
        //existPartList = [SELECT Id, Notes__c, OEM__c, Quantity__c, Selected_part__c, Replacement_Reason__c, Part_Name__c, 
                         //Service_partnumber__c, Service_Job__c, Assignment__c, Part_Description__c, Option_Number__c, 
                         //Part_size__c, ReturnToFactory__c, Get_Fail_Code_Formula__c, Fail_Code__c, Account_Code__c, Covered__c
                         //FROM CSS_Parts_Options__c WHERE Service_Job__c =: pgId AND Parts_Type__c = 'Custom'];
    }

    public PageReference saveUserAddedParts(){
        system.debug('inside saveUserAddedParts');
        try{
            if(existPartList!= null && !existPartList.isEmpty()){ 
                update existPartList;                
            }
        }catch(exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        pageReference ReturnPage = ApexPages.currentPage(); 
        return ReturnPage;
    }
}