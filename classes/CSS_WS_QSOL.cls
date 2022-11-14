/**********************************************************************
Name: CSS_WS_QSOL
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This class contains methods of webservice 
calls of QSOL app
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/03/2016     INITIAL DEVELOPMENT  
2.0     Surender M        10/31/2019     Migrating QSOL service from SOAP to REST 
***********************************************************************/

global with sharing class CSS_WS_QSOL {
    
    /*
    * This method is used for returning SMN from QSOL app
    **/
    global static string getSMNFromQSOL(String esn, String source){
        String smn;
        try{
            CG_OP_GetEngineDataPlateRespWrapper qsolWrapper = CG_BL_Intake.GetEngineDataPlateQSOLREST(esn);
            if(qsolWrapper !=null && qsolWrapper.data !=null && qsolWrapper.data.size()>0){
            	List<CG_OP_GetEngineDataPlateRespWrapper.data> qsolDataList = qsolWrapper.data;
                CG_OP_GetEngineDataPlateRespWrapper.data qsolDataRec = qsolDataList.get(0);
            	smn = qsolDataRec.serviceEngineModel;
            }
            System.debug('QSOL SMN>>>>>>>>>>>>>:'+smn);
        }catch(Exception ex){
            css_utility.LogOutIntError('QSOL REST Webservice Request', ex.getMessage()+':'+ex.getLineNumber(), 'CSS05-Exception occured while calling QSOL SMN webservice', source);
            System.debug('in catch of getQSOLData of CSS_WS_QSOL >>>>>>>>>>>>>>> Line No:'+ex.getLineNumber()+' Exception Msg:'+ex.getMessage());
        }
        return smn;
    }
    
    /*
    * This method is used for returning SMN from QSOL app
    **/
    /*global static string getSMNFromQSOL_Old(String esn, String source){
        String smn;
        String key;
        try{
            if(!Test.isRunningTest()){
                key = ((CSS_Integration_Details__c) CSS_getConnnectionDetails.getConnection('QSOL')).Key__c;
            }else{
                key = '1234';
                esn = '79464646';
            }
            
            CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
            CSS_quickserveCumminsComWebservices.ModelName qsolMN = new CSS_quickserveCumminsComWebservices.ModelName();
            qccw.timeout_x=120000;
            qsolMN = qccw.getEngineDataplate(key,esn);
            smn = qsolMN.serviceModel;
            System.debug('QSOL SMN>>>>>>>>>>>>>:'+smn+' The QSOL object is>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+qsolMN);
            
        }catch(Exception ex){
            css_utility.LogOutIntError('SOAP Webservice Request', ex.getMessage()+':'+ex.getLineNumber(), 'CSS05-Exception occured while calling QSOL SMN webservice', source);
            System.debug('in catch of getQSOLData of CSS_WS_QSOL >>>>>>>>>>>>>>>is :: '+ex.getLineNumber());
            System.debug('in catch of getQSOLData of CSS_WS_QSOL >>>>>>>>>>>>>>>is :: '+ex.getMessage());
        }
        return smn;
    }*/
    
}