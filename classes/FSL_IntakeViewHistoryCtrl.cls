/**********************************************************************
Name:FSL_IntakeViewHistoryCtrl
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this controller for view history.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                DATE                DETAIL                                 
1.0 -   SRIPRADA SESHAM       12/19/2018        INITIAL DEVELOPMENT 
2.0     Shirisha Pedditi      08/09/2022        Advanced user with Multi Location Check
***********************************************************************/
global class FSL_IntakeViewHistoryCtrl {
    global string assetName {get;set;}
    global DateTime createdDate {get;set;}
    global String jobId {get;set;}
    global String jobNum {get;set;}
    global String sLocation {get;set;}
    global String sLocationCode {get;set;}
    global List<String> sLocationTerritory {get;set;} //added by Naveen, PHOEN-209
    global WorkOrder workOrderRecord;
    public Id workOrderId;
    global FSL_IntakeViewHistoryCtrl() {
        system.debug('kkkkk');
        sLocationTerritory = new List<String>(); //added by Naveen, PHOEN-209
        workOrderId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('workOrderId . :: '+workOrderId);
        workOrderRecord = new WorkOrder();
        workOrderRecord = [SELECT Id, Asset.Name,WorkOrderNumber, Account.Name, Service_Location_Code__c, Type__c,ServiceTerritory.Name, ServiceTerritory.Location_Code__c, CreatedDate 
                           FROM WorkOrder WHERE Id = :workOrderId]; //AssetId
        if(workOrderRecord!=null) {
            assetName = workOrderRecord.Asset.Name;
            createdDate = workOrderRecord.CreatedDate;
            jobId = workOrderRecord.id;
            jobNum = workOrderRecord.WorkOrderNumber;
            //added by Sriprada as part of CT1-303
            
            List<FSL__User_Territory__c> UT = new List<FSL__User_Territory__c>();//Added by Shirisha ROAD-536 08/09/2022
            sLocationTerritory = new List<String>();//Added by Shirisha ROAD-536 08/09/2022 
            if(workOrderRecord.Type__c != 'Dealer'){
                sLocation = workOrderRecord.ServiceTerritory.Name;
                sLocationCode = workOrderRecord.ServiceTerritory.Location_Code__c;
               //Added by Shirisha ROAD-536 08/09/2022
                UT = [SELECT id,FSL__ServiceTerritory__c,FSL__User__c FROM FSL__User_Territory__c WHERE FSL__User__c = :UserInfo.getUserId()];
                system.debug('UT==>'+UT);
                if(UT.size() > 0){
                    set<string> STids = new set<string>();
                    for(FSL__User_Territory__c utr : UT){
                        if(utr.FSL__ServiceTerritory__c != null){
                            STids.add(utr.FSL__ServiceTerritory__c);
                        }
                    }
                    List<ServiceTerritory> STname =new List<ServiceTerritory>( [SELECT id,name,FSL_Service_Territory_Code__c ,Location_Code__c,ParentTerritoryId FROM ServiceTerritory WHERE (Id IN :STids OR  ParentTerritoryId IN :STids OR ParentTerritory.ParentTerritoryId IN :STids) AND Type__c = 'DISTRIBUTOR-BRANCH']);
                    system.debug('STname==>'+STname);  
                    if(STname.size() > 0){
                        set<string> setofST = new set<string>();
                        for(ServiceTerritory st : STname){
                            setofST.add(st.name);
                            sLocationTerritory.add(st.name);
                        }
                    }
                    
                }// end
            }else{
                sLocation = workOrderRecord.Account.Name;
                sLocationCode = workOrderRecord.Service_Location_Code__c;
                //sLocationTerritory.add(workOrderRecord.Account.Name); //added by Naveen, PHOEN-209 
                
            }
        }
        system.debug('check debug'+workOrderRecord);
    }
}