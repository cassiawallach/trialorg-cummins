public with Sharing class css_accessSrtCompOutTo_Eds{
    public ID Wid;
    public CSS_Job_Order__c workJob;
    public List<String> srtIdDetails {get;set;}
    List<css_srt__c> srtList;
    List<CSS_Solution_Component__c> compList;
    string dsidNum;
    
    public css_accessSrtCompOutTo_Eds(set<Id> solutionIds,string dsid){
        if(solutionIds != null){
            //System.debug('Solutions Found:'+solutionIds);
            srtList = [select id, SRT_ID__c,SRT_Details__c, CaseName__c,SRT_Title__c,Solution_Title__c,
                       SRT_AccessiblityCheck__c,Step_Id__c, Job_Order__c from css_srt__c 
                       where Solution_Number__c IN : solutionIds AND SRT_AccessiblityCheck__c = TRUE];
            
            compList = [select id , name ,Solutions__r.Name,Solutions__c,Selected_Component__c from CSS_Solution_Component__c
                        where Solutions__c IN : solutionIds AND Selected_Component__c = TRUE];
        }
        
        dsidNum = dsid;
        
    }
    
    public void accessSRTs(){
        CSS_ActionRequestWrapper actionReqWrap = new CSS_ActionRequestWrapper(srtList,dsidNum);
        CSS_EDSActionsUpdate.SelectAccessSRT(actionReqWrap);
    }
    
    public void solComponents(){
        CSS_ComponentRequestWrapper solCompRequest= new CSS_ComponentRequestWrapper(compList,dsidNum);
        CSS_EDSActionsUpdate.SelectComponents(solCompRequest);
        
    }
    public void outOfOrder(list<CSS_SOLUTIONS__c> outOfOrderSolList){ 
        System.debug('out of order list'+ outOfOrderSolList);
        CSS_EDSActionsUpdate.outOfOrderAck(outOfOrderSolList,dsidNum);      
    }  
    public void insiteFaultCodes(List<CSS_Fault_Code__c> faultCodes,string dsid){
      System.debug('faultCodes'+ faultCodes);
        //Added null condition for Defect 125418
        if(faultCodes!= null && !faultCodes.isEmpty() && faultCodes.size()>0){
            CSS_EDSActionsUpdate.insiteFaultCodes(faultCodes,dsid);
        }
    }
    
}