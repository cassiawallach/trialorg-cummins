/**********************************************************************
Name: CG_CL_PartsReturnEPRPDF
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  Controller for Parts To Return PDF page
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION      AUTHOR             DATE                DETAIL                                 
1.0      Rajkumar/Vignesh     09/13/2018      INITIAL DEVELOPMENT
***********************************************************************/
public class CG_CL_PartsReturnEPRPDF
{
    public List<CSS_Parts_Options__c> eprPartsLst{get;set;}
    public Id cId;
    public String failurePoint{get;set;}
    public List<CSS_PSN__c> primaryPSN{get;set;}
    public String psn{get;set;}
    public String spCode{get;set;}
    public String distiCode{get;set;}
    public List<String> warrantyClaimNumber{get;set;}
    public List<CSS_Claim_Submission__c> lstCS = new List<CSS_Claim_Submission__c>();
    public String printedOn{get;set;}
    public String printedBy{get;set;}
    public String claimCreateDate{get;set;}
    public String mileMeasure{get;set;}
    public CG_CL_PartsReturnEPRPDF()
    {
        cId = ApexPages.CurrentPage().getParameters().get('id');
        if(cId != null){
            eprPartsLst = [SELECT Id, Return_Instructions__c, Account_Code__c, CSS_Claims__r.Name, CSS_Claims__r.CreatedDate, Service_partnumber__c,
                           Part_Description__c, Quantity__c, Tracking_Number__c, RID__c, CSS_Claims__r.SiebelClaimNumber__c,
                           CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.Location_Code__c, Siebel_Claim_Number__c, Shipping_Address__c
                           FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: cId AND ReturnToFactory__c = 'Y' AND ReturnWaiver__c = false AND selected_part__c = true]; // Added selected_part__c = true condition as part of story 190053
            primaryPSN = [SELECT Id, Failure_Point__c, PSN__c, Mileage__c, CSS_Claims__r.CreatedDate, Product_Hours__c, Mileage_Measure__c FROM CSS_PSN__c WHERE CSS_Claims__c =: cId AND Primary__c = true];
            lstCS = [SELECT Id, Siebel_Claim_JSON__c, Siebel_Claim_Number__c FROM CSS_Claim_Submission__c WHERE CSS_Claims__c =: cId];
            if(primaryPSN != null && primaryPSN.size() > 0){
                //failurePoint = primaryPSN[0].Failure_Point__c;

                psn = primaryPSN[0].PSN__c;
                //   claimCreateDate = (css_utility.getFormattedDate(primaryPSN[0].CSS_Claims__r.CreatedDate)).ToUpperCase();
                if(primaryPSN[0].Product_Hours__c != null && primaryPSN[0].Product_Hours__c > 0){
                    failurePoint = string.valueof(primaryPSN[0].Product_Hours__c);
                    mileMeasure = 'Hours';
                }
                else{
                    if(primaryPSN[0].Mileage_Measure__c != null && primaryPSN[0].Mileage_Measure__c == 'Miles')
                        mileMeasure = 'MI';
                    else if(primaryPSN[0].Mileage_Measure__c != null && primaryPSN[0].Mileage_Measure__c == 'Kilometers')
                        mileMeasure = 'KMS';

                    if(primaryPSN[0].Mileage__c != null)
                        failurePoint = string.valueof(primaryPSN[0].Mileage__c);
                }
            }
            if(eprPartsLst != null && eprPartsLst.size() > 0){
                List<String> locSplit = new List<String>();
                locSplit = eprPartsLst[0].CSS_Claims__r.Location_Code__c.split('-');
                if(locSplit != null && locSplit.size() > 0)
                    distiCode = locSplit[0].Trim();
                if(locSplit != null && locSplit.size() > 1)
                    spCode = locSplit[1].Trim();
            }
            for(CSS_Parts_Options__c partLst : eprPartsLst){
                for(CSS_Claim_Submission__c cs : lstCS){
                    if(cs.Siebel_Claim_JSON__c.contains(partLst.Service_partnumber__c)){
                        partLst.Siebel_Claim_Number__c = cs.Siebel_Claim_Number__c;
                        break;
                    }
                }
            }
            printedOn = (css_utility.getFormattedDate(system.now())).ToUpperCase();
            printedBy = userInfo.getName();            
        }
    }
}