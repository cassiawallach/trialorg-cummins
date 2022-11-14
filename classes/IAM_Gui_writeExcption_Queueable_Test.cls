/************************************************************
Name:  IAM_Gui_writeExcption_Queueable_Test
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test Class for IAM_Guidanz_writeException_Queueable  
class.                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Anupam Adhikari       21/02/2022        INITIAL DEVELOPMENT       
*****************************************************/
@isTest
public class IAM_Gui_writeExcption_Queueable_Test {
    
    @isTest
    public static void guihandleExceptionMethod(){
        Map<Id, String> mapUserIdRole = new Map<Id, String>(); 
        Map<Id, String> mapUserIdAppRole = new Map<Id, String>();
        Map<Id, String> mapUserIdAppGrp = new Map<Id, String>();
        List<String> errorListRec = new List<String>();
        Boolean sFlagData = False;
        
        String sErrorDesc = 'Test Guidanz Error';
        errorListRec.add(sErrorDesc);
        
        IAM_Guidanz_writeException_Queueable iam= new IAM_Guidanz_writeException_Queueable(mapUserIdRole,mapUserIdAppRole,mapUserIdAppGrp,errorListRec,sFlagData);
        Test.StartTest();
        System.enqueueJob(iam);
        Test.StopTest();       
    }
}