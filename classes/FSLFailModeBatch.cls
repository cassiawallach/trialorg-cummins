/**********************************************************************
Name: FSLFailModeBatch
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This Batch process is used to populate the custom failure names, system code, component code and Fail mode from
Siebel warranty system
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         5/03/2019                         
***********************************************************************/
global class FSLFailModeBatch implements Database.batchable<FSLFailModeWrapper>,Database.AllowsCallouts,Database.Stateful {
    
    //Adam changing form public to private as part of NIN-471 Salesforce Health ASsesment Changes
    private list<FSL_Fail_Mode__c> lstFmode = new list<FSL_Fail_Mode__c>();
    
    public Iterable<FSLFailModeWrapper> start(Database.BatchableContext BC){ 
        return new FSLfailmodeRespIterable();
    }
    
    
    // VGRS2-27 failmode duplicate issue fix by Priyanka 10/17/2021
    // Everytime batch load it is loading the same data into FSL_Fail_Mode__c object. 
    // So taking the Unique value of code+desc and comparing the value with existing data 
    // Changes for VGRS-214
    public void execute(Database.BatchableContext info, List < FSLFailModeWrapper > scope) {
        system.debug('check---->' + scope);
        
        List < string > listWithUniqueValues = new List < string > ();
        Map < string, List < FSL_Fail_Mode__c >> mapUniqeValueWithFailMode = new Map < string, List < FSL_Fail_Mode__c >> ();
        List < FSL_Fail_Mode__c > initailList = new List < FSL_Fail_Mode__c > ();
        
        for (FSLFailModeWrapper fsr: scope) {
            if (fsr != null && fsr.DataArea != null && fsr.DataArea.Details.size() > 0) {
                for (FSLFailModeWrapper.Details objWrapper: fsr.DataArea.Details) {  
                    FSL_Fail_Mode__c objmode = new FSL_Fail_Mode__c();
                    if((objWrapper.FailModeCode+' - '+ objWrapper.Description).length() > 80)
                    {
                        objmode.Name = (objWrapper.FailModeCode+' - '+ objWrapper.Description).substring(0, 80);
                        system.debug('testdesctption***'+objWrapper.Description);
                    }
                    else
                    {
                        system.debug('testdesctption123***'+objWrapper.Description);
                        objmode.Name = (objWrapper.FailModeCode+' - '+ objWrapper.Description);
                    }
                    objmode.Business_Unit__c = objWrapper.BusinessUnit;
                    objmode.Description__c = objWrapper.Description;
                    objmode.Active__c = objWrapper.Active;
                    initailList.add(objmode);
                    system.debug('desctest**' +objmode.Name + '**' ); 
                    listWithUniqueValues.add(objmode.Name.trim());
                    
                }
            }
        }
                    /*  List<FormulaRecalcResult> results = Formula.recalculateFormulas(initailList);
            if(results[0].isSuccess()){
            system.debug('****test');
            for (FSL_Fail_Mode__c fmRec: initailList) {
            system.debug('****testpriya12' +fmRec.Uniquevalue__c);
            listWithUniqueValues.add(fmRec.Uniquevalue__c);
            }
            } */
        system.debug('****test123' +listWithUniqueValues);
        List < FSL_Fail_Mode__c > insertedList = new List < FSL_Fail_Mode__c > ();
        insertedList = [select id,Name, description__C from FSL_Fail_Mode__c where Name IN: listWithUniqueValues];
        System.debug('**test789**'+ insertedList);
        for (FSL_Fail_Mode__c fmRec: insertedList) {
            system.debug('testfm++++' + fmRec);
            if (!mapUniqeValueWithFailMode.containskey(fmRec.Name))
            {
                system.debug('testfmtest++++' + fmRec);
                mapUniqeValueWithFailMode.put(fmRec.Name, new List < FSL_Fail_Mode__c > ());
                
            }
            mapUniqeValueWithFailMode.get(fmRec.Name).add(fmRec);
            
            /*  if(mapUniqeValueWithFailMode.get(fmRec.Name).size()<1)
            {
            
            mapUniqeValueWithFailMode.get(fmRec.Name).add(fmRec);
            } */
        }
        
        system.debug('Map:::'+mapUniqeValueWithFailMode);
           
        for (FSL_Fail_Mode__c fmRec: initailList) {   
            try{ 
                if (mapUniqeValueWithFailMode.containskey(fmRec.Name.trim())) {
                    for (FSL_Fail_Mode__c objmode: mapUniqeValueWithFailMode.get(fmRec.Name.trim())) {                                                   
                        objmode.Name = fmRec.Name;
                        objmode.Business_Unit__c = fmRec.Business_Unit__c;
                        objmode.Description__c = fmRec.Description__c;
                        objmode.Active__c = fmRec.Active__c;
                        lstFmode.add(objmode);
                    }
                } 
            
            
            else {
                FSL_Fail_Mode__c objmode = new FSL_Fail_Mode__c();
                objmode.Name = fmRec.Name;
                objmode.Business_Unit__c = fmRec.Business_Unit__c;
                objmode.Description__c = fmRec.Description__c;
                objmode.Active__c = fmRec.Active__c;
                lstFmode.add(objmode);
                
            }
            }
            catch(Exception ex) {
                System.debug('::: Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
                System.debug('::: Execption Stack :: '+ex.getStackTraceString()+''+fmRec.Name);
                // results = '{"Header":{"Status": "ERROR", "ReturnCodeDescription": "Record Failed to Update:::"}}';
                //results = '{"Status":"'+ex.getStackTraceString()+'"}';
            }
        }
        
        if (lstFmode.size() > 0) {
            Database.upsert(lstFmode, false);
        }
        
        system.debug('kkkkkkk---->' + lstFmode);
    }
    @TestVisible
    public void finish(Database.BatchableContext info){
        
    }    
}