/**********************************************************************
Name:CG_CL_ClaimsPartsFromBMS
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this Component Controller for Claims parts from BMS accordion under Parts and Other Claimables.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Shreerath Nair     3/20/2018      Added for UserRequested Popoup   
1.0 -   Arpita Sarangee    4/2/2018      Added code as part of user story 137880
***********************************************************************/
public class CG_CL_ClaimsPartsFromBMS{

    public Id Cid{get; set;}
    public Id Wid{get; set;}
    
    public Id recTypeIdpart;
    public integer singleRun=0;
    public Set<partWrapperClass> setpartWrapper {get;set;}
    public List<partWrapperClass> listpartWrapper {get;set;}
    public list<CSS_Parts_Options__c> customPartlstUI{get; set;}
    public CSS_Claims__c bmsUser{get;set;}
    

    public CG_CL_ClaimsPartsfromBMS(){
        singleRun = 1;
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        getallPartsfromBMS();
       
    }    

    public void getallPartsfromBMS(){

        customPartlstUI = new list<CSS_Parts_Options__c>();

        try{
            system.debug('Wid--'+Wid);
            if(wid != null) {
                recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'BMS Parts');
                system.debug('***recTypeIdpart***'+recTypeIdpart +'-----------> ' +  Wid);
                customPartlstUI = [select Id, Name, Quantity__c, Quantity_Used__c,Part_Description__c,Part_Name__c,Sell_Price__c, Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c,Parts_Return__c,Covered__c,Comments__c,Warranty_Allocation__c from CSS_Parts_Options__c where CSS_Claims__c =:Wid and RecordTypeId=:recTypeIdpart];
                bmsUser = [select Id,CSS_Job__C,Account__r.ERP_System__c,Account__r.Region__C from CSS_Claims__c where Id =:Wid];
                system.debug('customPartlstUI size>>>:'+customPartlstUI.size()+'customPartlstUI querry>>>>>>>>>>:'+customPartlstUI);

                if(customPartlstUI != null && customPartlstUI.size()>0){ 
                    listpartWrapper = new List<partWrapperClass>();
                    setpartWrapper = new Set<partWrapperClass>();
                    for(integer i=0;i<customPartlstUI.size();i++){
                        setpartWrapper.add(new partWrapperClass(i,customPartlstUI[i].Id,String.valueof(customPartlstUI[i].Quantity__c),customPartlstUI[i].Service_partnumber__c,customPartlstUI[i].Part_Name__c,String.Valueof(customPartlstUI[i].Sell_Price__c * customPartlstUI[i].Quantity__c) ,customPartlstUI[i].Replacement_Reason__c,customPartlstUI[i].Notes__c,customPartlstUI[i].OEM__c,customPartlstUI[i].Selected_part__c,customPartlstUI[i].ReturnToFactory__c,String.valueof(customPartlstUI[i].Covered__c),customPartlstUI[i].Fail_Code__c,customPartlstUI[i].Account_Code__c));
                    }
                   
                    listpartWrapper = new List<partWrapperClass>();
                    setpartWrapper = new Set<partWrapperClass>();
                    for(integer i=0;i<5;i++){
                        CSS_Parts_Options__c  partsoption =  new CSS_Parts_Options__c();
                        partsoption.Notes__c = '';
                        partsoption.OEM__c = '';
                        partsoption.Selected_part__c = false;
                        partsoption.Part_Name__c = '';
                        partsoption.ReturnToFactory__c = '';
                        partsoption.Fail_Code__c = '';
                        partsoption.Account_Code__c = '';
                        partsoption.Replacement_Reason__c='Select One';
                        partsoption.Service_partnumber__c = '';
                        partsoption.Parts_Type__c='Custom';
                        setpartWrapper.add(new partWrapperClass(i,null,'',partsoption.Service_partnumber__c,partsoption.Part_Name__c,null,partsoption.Replacement_Reason__c,partsoption.Notes__c,partsoption.OEM__c,partsoption.Selected_part__c,partsoption.ReturnToFactory__c,'',partsoption.Fail_Code__c,partsoption.Account_Code__c));
                    }

                    
            }
            }
        }catch(Exception ex){
            System.debug('in catch of getallPartsData:: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        if(setpartWrapper != null && setpartWrapper.size()>0){

            listpartWrapper.addAll(setpartWrapper);
        }
        
        system.debug('listpartWrapper--'+listpartWrapper);

    }

    public class partWrapperClass {
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String idStr {get;set;}
        public String quantity {get;set;}
        public String servPartNumber {get;set;}
        public String partName {get;set;}
        public String totalprice {get;set;}
        public String returnToFactory {get;set;}
        public String coveredPercent {get;set;}
        public String failCode {get;set;}
        public String accountCode {get;set;}
        public String replacementReasson {get;set;}
        public String notes {get;set;}
        public String oem {get;set;}
        public Boolean selectedPart {get;set;}
        public list<SelectOption> lstAccountCodes{get;set;}

        public partWrapperClass(Integer counting,Id ids,String quantity,String servPartNumber,String partName,String totalprice,String replacementReasson,String notes,String oem,Boolean selectedPart,String returnToFactory,String coveredPercent,String failCode,String accountCode) {
            this.counting = counting;
            this.ids = ids;
            this.idStr = ids;
            this.quantity = quantity;
            this.servPartNumber = servPartNumber;
            this.partName = partName;
            this.totalprice=totalprice;
            this.replacementReasson = replacementReasson;
            this.notes = notes;
            this.oem = oem;
            this.selectedPart = selectedPart;
            this.returnToFactory = returnToFactory;
            this.coveredPercent = coveredPercent;
            this.failCode = failCode;
            this.accountCode = accountCode;
            this.lstAccountCodes = lstAccountCodes;

            //   lstAccountCodes = new list<SelectOption>();
        }        
    }

}