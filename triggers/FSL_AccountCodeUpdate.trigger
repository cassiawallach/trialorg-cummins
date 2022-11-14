/**********************************************************************
Name:FSL_AccountCodeUpdate 
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: 
-----------------------------------------------------
This trigger is written for CSS_Solution_Component__c
======================================================
======================================================
History
-------
VERSION  AUTHOR                     DATE
1.0     Ravikanth Macherla         02/30/2020
2.0     Mallika Subhashini         12/15/2019
***********************************************************************/
trigger FSL_AccountCodeUpdate on CSS_Solution_Component__c (after update, after insert, before insert, before update, After Delete, before delete) {
    
    boolean guidanzClaaicFlag = false;
    if(!trigger.isdelete) {
        for(CSS_Solution_Component__c solcomp : Trigger.New) {
            system.debug('solcomp.CSS_Classic_SJId__c'+solcomp.CSS_Classic_SJId__c);
            system.debug('solcomp.CSS_Claims__c'+solcomp.CSS_Claims__c);
            // if((solcomp.CSS_Classic_SJId__c != null && solcomp.CSS_Classic_SJId__c != '') || (solcomp.CSS_Claims__c != null && solcomp.CSS_Claims__c != '')) {
            if(solcomp.CSS_Classic_SJId__c != null  || solcomp.CSS_Claims__c != null ) {
                guidanzClaaicFlag = true;
                break;
            }
        }  
    } else {
        for(CSS_Solution_Component__c solcomp : Trigger.Old) {
            if((solcomp.CSS_Classic_SJId__c != null && solcomp.CSS_Classic_SJId__c != '') || (solcomp.CSS_Claims__c != null && solcomp.CSS_Claims__c != '')) {
                guidanzClaaicFlag = true;
                break;
            }
        } 
    }
    
    if(!guidanzClaaicFlag) {
        If(trigger.isBefore) {
            if(Trigger.IsUpdate || Trigger.IsInsert) {
                FSL_solutionCompHelper.updateAccountCode(Trigger.new);
                FSL_solutionCompHelper.updateSMN(Trigger.new);
            }
        }
        
        // Added Ravikanth
        if(trigger.isAfter && trigger.isUpdate) {
            List<Id> solutionIdList = new List<Id>();
            List<Id> solutionIdRemList = new List<Id>();
            List<Id> idsToUpdate = new List<Id>();
            // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
            Set<Id> failModes = new Set<Id>();
             Set<Id> WoIds = new Set<Id>();
            for(CSS_Solution_Component__c cssSol : Trigger.New){
                failModes.add(cssSol.Fail_Mode__c);
                WoIds.add(cssSol.FSL_Service_Job__c);
            }
            Map<Id, FSL_Fail_Mode__c> failmodesmap = new Map<Id, FSL_Fail_Mode__c>([select id, name from FSL_Fail_Mode__c where id in :failModes]);
            Map<Id,CSS_Solution_Component__c> MapSRT = new Map<Id,CSS_Solution_Component__c>();
            for(CSS_Solution_Component__c objCSS : Trigger.new){
                if(!objCSS.Performed_Review__c && objCSS.Performed_Review__c != Trigger.oldMap.get(objCSS.Id).Performed_Review__c){
                    MapSRT.put(objCSS.id, objCSS);
                } 
        	}
             List<FSL_SRT__c> srtList = new List<FSL_SRT__c>();
           if(MapSRT!=null){
                srtList = [select id,Component_Id__c from FSL_SRT__c where Component_Id__c IN :MapSRT.keySet()];
           }
            
            Map<Id, WorkOrder> WoMap = new Map<Id, WorkOrder>([SELECT id, Type__c, EVL_DX_SONumber__c FROM WorkOrder WHERE id in :WoIds]);

            for(CSS_Solution_Component__c CSSComp:Trigger.New) {
                if(CSSComp.Performed_Review__c != Trigger.oldMap.get(CSSComp.Id).Performed_Review__c && CSSComp.Performed_Review__c) {
                    String strCSSComp = JSON.serialize(Trigger.new);
                    system.debug('WOType:::'+WoMap.get(CSSComp.FSL_Service_Job__c).Type__c );
                    if(WoMap.get(CSSComp.FSL_Service_Job__c) != null && WoMap.get(CSSComp.FSL_Service_Job__c).EVL_DX_SONumber__c ==  false){
                        system.debug('WoId::'+CSSComp.EVL_DX_Service_Order__c);
                        FSLFieldActionsServices.fieldactionsrt(strCSSComp);
                        system.debug('inside field update');
                        FSLFieldActionsServices.updatePerformed(Trigger.new);
                        FSL_getDetailCoverage.getSolutionCoverage(CSSComp.Id);
                    }
                    //Added For Dealer Data Exchange Service Orders
                    if(WoMap.get(CSSComp.FSL_Service_Job__c) != null && WoMap.get(CSSComp.FSL_Service_Job__c).EVL_DX_SONumber__c ==  true && WoMap.get(CSSComp.FSL_Service_Job__c).Type__c == 'Dealer' && !Test.isRunningTest()){
                        system.debug('WoId::'+CSSComp.EVL_DX_Service_Order__c);
                        idsToUpdate.add(CSSComp.id);
                       // System.enqueueJob( new EVL_DX_UpdateCampaigns(strCSSComp));

                      //System.enqueueJob( new EVL_DX_getDetailCoverage(CSSComp.id));

                    } 
                    
                } 
                else if(CSSComp.Performed_Review__c != Trigger.oldMap.get(CSSComp.Id).Performed_Review__c && CSSComp.Performed_Review__c == false) {
                    FSLFieldActionsServices.updatePerformed(Trigger.new);
                }
                // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
                FSL_solutionCompHelper.deleteSRTs(Trigger.new, Trigger.oldMap,MapSRT, srtList);
              
                
                //Added by vinod CT2-220 user story 10.30.2020
                // Refactoring the code for 101 SOQL issue the BY Priyanka VGRS2-242
                FSL_solutionCompHelper.logAudits(Trigger.New, Trigger.oldMap, failmodesmap);
                
                // Harsha started 07/16/20 added for 4cs correction notes
                // Bharat - removed Performed_Review__c related conditions as they are not needed
                if(CSSComp.Performed__c != Trigger.oldMap.get(CSSComp.Id).Performed__c && CSSComp.Performed__c) {
                    solutionIdList.add(CSSComp.Id);
                }
                if(Trigger.oldMap.get(CSSComp.Id).Performed__c && CSSComp.Performed__c == false) {
                    solutionIdRemList.add(CSSComp.Id);
                }
            }
            system.debug('idsToUpdate++++++'+idsToUpdate);
             if(idsToUpdate != null && idsToUpdate.size() > 0) {
                 System.enqueueJob( new EVL_DX_UpdateCampaigns(idsToUpdate));
                FSLFieldActionsServices.updatePerformed(Trigger.new);

            }
            if(solutionIdList != null && solutionIdList.size() > 0) {
                FSLFieldActionsServices.actionsfor4cs(solutionIdList);
            }
            if(solutionIdRemList != null && solutionIdRemList.size() > 0) {
                FSLFieldActionsServices.actionsfor4csforRemoval(solutionIdRemList);
            }
            // Harsha ended 07/16/20 
        }
    }
}