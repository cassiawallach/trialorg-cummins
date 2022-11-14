@isTest
public class CG_CL_UserToolsHR_Test {
    
    Public static testmethod void startRequestMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.enteredPSN = '73806085';
        usrTool.startRequest(); //new commit
        Test.stopTest();
    }
    
    Public static testmethod void gettokenMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.startRequest();
        usrTool.gettoken();
        Test.stopTest();
    }    
    
    Public static testmethod void getPartsMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.getParts();
        Test.stopTest();
    } 
    
    Public static testmethod void getServiceMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.getService();
        Test.stopTest();
    } 
    
    Public static testmethod void getDataPlateMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.getDataPlate();
        Test.stopTest();
    } 
    
     Public static testmethod void getSpnFmiMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.getSpnFmi();
        Test.stopTest();
    } 
    
     Public static testmethod void ECM_CalibrationRevisionHistoryMethod(){
        Test.startTest();
        CG_CL_UserToolsHR usrTool = new CG_CL_UserToolsHR();
        usrTool.ECM_CalibrationRevisionHistory();
        Test.stopTest();
    } 
}