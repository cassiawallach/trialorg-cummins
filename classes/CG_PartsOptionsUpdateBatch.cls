global class CG_PartsOptionsUpdateBatch implements Database.Batchable <sObject>{

   
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String partId = '01261000000kuJ7';
        String ttmlId = '01261000000j1TE';
        String oCId='01261000000MHed';
        String query = 'SELECT Id, Exchange_Rate__c, CSS_Claims__c, RecordTypeId, Unit_Price_Local_Currency__c, Sell_Price__c,Amount_Local_Currency__c, Amount__c, Exchange_Rate_Version__c, Currency_Type__c, Unit_Price__c, ExpenseTotal__c FROM CSS_Parts_Options__c WHERE Exchange_Rate__c = null and (RecordTypeId =: partId  OR RecordTypeId =: ttmlId  OR RecordTypeId =: oCId)';
        system.debug('query '+query );
            return Database.getQueryLocator(query);
    }
    
    
     global void execute(Database.BatchableContext BC, List<CSS_Parts_Options__c > Scope){   
        try {
            Id recTypeIdPart = '01261000000MHedAAG';
            //css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
            Id recTypeIdOC = '01261000000kuJ7AAI';
            //css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
            Id recTypeIdTTML = '01261000000j1TEAAY';
            //css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
            List<CSS_Parts_Options__c> partsLst = new List<CSS_Parts_Options__c>();
            
            system.debug('Inside execute');
            
            for(CSS_Parts_Options__c parts : Scope){
    if(parts.Exchange_Rate__c == null){ 
        if(parts.CSS_Claims__c == null){
        system.debug('Inside Claims'+parts.RecordTypeId + 'rec id'+recTypeIdOC + 'sell price'+parts.Sell_Price__c+'unit price'+parts.Unit_Price__c+'rec'+recTypeIdTTML);
            if(parts.RecordTypeId == recTypeIdOC && parts.Sell_Price__c != null){  //OC - Job
            system.debug('Inside Id');
                parts.Exchange_Rate__c = 1;
                parts.Unit_Price_Local_Currency__c = parts.Sell_Price__c;
                parts.Amount_Local_Currency__c = parts.Amount__c;
                parts.Exchange_Rate_Version__c = 6;
                parts.Currency_Type__c = 'USD';
                partsLst.add(parts);
            }
             //system.debug('Inside Claims'+parts.RecordTypeId + 'rec id'+recTypeIdTTML + 'price'+parts.Unit_Price__c );
            else if(parts.RecordTypeId == recTypeIdTTML && parts.Unit_Price__c != null){  //TTML - Job
             system.debug('Inside Id1');
                parts.Exchange_Rate__c = 1;
                parts.Unit_Price_Local_Currency__c = decimal.valueof(parts.Unit_Price__c);
                parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                parts.Exchange_Rate_Version__c = 6;
                parts.Currency_Type__c = 'USD';
                partsLst.add(parts);
            }
        }
        else if(parts.CSS_Claims__c != null){
        system.debug('Inside Claims'+parts.RecordTypeId + 'rec id'+recTypeIdPart + 'price'+parts.Unit_Price__c );
            if(parts.RecordTypeId == recTypeIdPart && parts.Unit_Price__c != null){ //GSQ Parts, Field Action Parts and URP - Claims
               system.debug('Inside Id1');
                parts.Exchange_Rate__c = 1;
                parts.Unit_Price_Local_Currency__c = decimal.valueof(parts.Unit_Price__c);
                parts.Exchange_Rate_Version__c = 6;
                parts.Currency_Type__c = 'USD';
                partsLst.add(parts);
            }
            system.debug('Inside Claims'+parts.RecordTypeId + 'rec id'+recTypeIdOC  );
            if(parts.RecordTypeId == recTypeIdOC || parts.RecordTypeId == recTypeIdTTML){  //OC, TTML - Claims
                system.debug('Inside Id1');
                parts.Exchange_Rate__c = 1;
                parts.Unit_Price_Local_Currency__c = (parts.Unit_Price__c != null && parts.Unit_Price__c != '') ? decimal.valueof(parts.Unit_Price__c) : null;
                parts.Amount_Local_Currency__c = parts.ExpenseTotal__c;
                parts.Exchange_Rate_Version__c = 6;
                parts.Currency_Type__c = 'USD';
                partsLst.add(parts);
        }
    }
}
}
            system.debug('output count-->'+partsLst.size());
            system.debug('Parts Data'+partsLst);
        if(partsLst != null && partsLst.size() > 0){
            update partsLst;
        }
            
            
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_populateNoWarrantyFlagClass execute >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
}   
    global void finish(Database.BatchableContext BC){
    
     system.debug('Finished population of CG_populateNoWarrantyFlag');
     
    }

}