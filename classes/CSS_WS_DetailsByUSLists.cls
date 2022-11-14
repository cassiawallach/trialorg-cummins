Public Class CSS_WS_DetailsByUSLists{

    Public CSS_WS_Warranty__c claim { get; set; }
    Public List<CSS_WS_US_Details__c> srts {get; set;} 
    Public List<CSS_WS_US_Details__c> parts {get; set;} 
    Public List<CSS_WS_US_Details__c> ocs {get; set;} 
    Public Boolean srtsEnabled {get; set;} 
    Public Boolean partsEnabled {get; set;} 
    Public Boolean ocsEnabled {get; set;} 
    
    Public CSS_WS_DetailsByUSLists(ApexPages.StandardController stdController){
        srtsEnabled = false;
        partsEnabled = false;
        ocsEnabled = false;
        if(!test.isRunningTest()){
            this.claim = (CSS_WS_Warranty__c)stdController.getRecord();            
        }
        getSRTs();
        getParts();
        getOCs();
    }
    
    Public List<CSS_WS_US_Details__c> getSRTs(){
        if(srts == null){
            try{
                srts = [SELECT Id, CSS_WS_SRT_Code__c, CSS_WS_Quantity__c, CSS_WS_SRT_Hours__c,  CSS_WS_SRT_Access_Code__c, CSS_WS_SRT_Adjustment_Reason__c, CSS_WS_SRT_Adjustment_Percentage__c
                FROM CSS_WS_US_Details__c WHERE CSS_WS_Claim__c =:this.claim.Id AND CSS_WS_Type_Section__c = 'SRTs' ORDER BY CSS_WS_SRT_Code__c ASC];
                if(srts != null && srts.size() != 0){
                    srtsEnabled = true;
                }
                System.debug(srts);
            } catch (Exception e){
                System.debug('Error: '+e.getMessage());
            }
        }
        return srts;
    }
    
    Public List<CSS_WS_US_Details__c> getParts(){
        if(parts == null){
            try{
                parts = [SELECT Id, CSS_WS_Part_Number__c, CSS_WS_Quantity__c, CSS_WS_Part_Adjustment_Reason__c, 
                CSS_WS_Part_Adjustment_Percentage__c, CSS_WS_Price__c, CSS_WS_Total_Price__c FROM CSS_WS_US_Details__c 
                WHERE CSS_WS_Claim__c =:this.claim.Id AND CSS_WS_Type_Section__c = 'Parts' ORDER BY CSS_WS_Part_Number__c ASC];
                if(parts != null && parts.size() != 0){
                    partsEnabled = true;
                }
                System.debug(parts);
            } catch (Exception e){
                System.debug('Error: '+e.getMessage());
            }
        }
        return parts;
    }
    
    Public List<CSS_WS_US_Details__c> getOCs(){
        if(ocs == null){
            try{
                ocs = [SELECT Id, CSS_WS_Description__c, CSS_WS_OC_Adjustment_Reason__c, CSS_WS_OC_Approved_Amount__c
                FROM CSS_WS_US_Details__c WHERE CSS_WS_Claim__c =:this.claim.Id AND CSS_WS_Type_Section__c = 'Other Claimables' ORDER BY CSS_WS_Description__c ASC];
                if(ocs != null && ocs.size() != 0){
                    ocsEnabled = true;
                }
                System.debug(ocs);
            } catch (Exception e){
                System.debug('Error: '+e.getMessage());
            }
        }
        return ocs;
    }
}