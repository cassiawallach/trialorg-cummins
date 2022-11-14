/**********************************************************************
Name: FSLFaultCode_Test
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This test class is a test coverage class for FSLFaultCodeService
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/24/2019                         
***********************************************************************/
@isTest
private class FSLFaultCode_Test {
    
    @isTest static void testBatch() {  
        Test.setMock(HttpCalloutMock.class, new FSLFaultCodeMock());
        FSLFaultCodeWrapper fslcwrapp = new FSLFaultCodeWrapper();
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CDSgetToken14602';
        csInt.ApplicationName__c='CDS';
        // csInt.End_Point__c='https://cdsfaultcodes-stg.cummins.com/api/GetToken';
        csInt.End_Point__c='https://cdsfaultcodes-stg.cummins.com/api/J14602AppACoreII?cdsID=true';
        csInt.AuthEnv__c='nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        csInt.Method_Type__c='GET';
        csInt.Timeout__c=120000;
        csInt.Username__c= '562e164f-f255-4eff-9c29-3ceed139c0dd';
        csInt.IsActive__c=true;
        insert csint;
        
        FSL_Fault_Code__c faultCode = new FSL_Fault_Code__c();
        faultCode.Name = '145';
        faultCode.CDS_ID__c = 'fdc78990-23494-fuif900kl3';
        faultCode.LanguageKey__c = 'en';
        faultCode.Revision__c = '145';
        insert faultCode;
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        FSLFaultCodeService FslFaultCodecls1 = new FSLFaultCodeService();
        List<FSLFaultCodeWrapper> res = FslFaultCodecls1.getFaultCodes();
        
        FSLFaultCodeWrapper wrap = new FSLFaultCodeWrapper();
        wrap.Cummins_Fault_Code = '145';
        
        FSLFaultCodeRespIterable fslIterable = new FSLFaultCodeRespIterable();
        fslIterable.Iterator();
        
        FSLFaultCodeBatchProcess fslBatch = new FSLFaultCodeBatchProcess();
        Database.executebatch(fslBatch);
        
        SchedulableContext sc = null;
        FSLfaultcodesc tsc = new FSLfaultcodesc();
        tsc.execute(sc);
    }
}