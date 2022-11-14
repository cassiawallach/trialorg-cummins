/**********************************************************************
Name:CG_CurrencyCoversionTrigger
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this trigger for versioning currency values
======================================================
======================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL  
1.0 -   Vignesh/Rajkumar 11/21/2019      Added code as part of user story GSSC-132
***********************************************************************/

trigger CG_CurrencyCoversionTrigger on Currency_Conversion__c (Before Insert) {
    List<Currency_Conversion__c> listCC = new List<Currency_Conversion__c>();
    listCC = [Select Id, Bolt_Version__c from Currency_Conversion__c order by Bolt_Version__c desc limit 1];
    decimal prevVersion = 0;
    if(listCC != null && listCC.size() > 0){
        prevVersion = listCC[0].Bolt_Version__c;
    }
    for(Currency_Conversion__c c : Trigger.new){
        c.Bolt_Version__c = prevVersion+1;
    }

}