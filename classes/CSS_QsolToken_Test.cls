@isTest
public class CSS_QsolToken_Test {
    @isTest static void testQsolToken(){
        CSS_QsolToken qsolRef = new CSS_QsolToken();
        qsolRef.myBase64String = 'Q1NTfDE0Nzg4MDk1NjAwMTc'; //commit
        qsolRef.setsESN('1234');
        qsolRef.gettoken();
        qsolRef.getDataPlate();
        qsolRef.getParts();
        qsolRef.getService();
        qsolRef.getsESN();
        qsolRef.getSpnFmi();
        qsolRef.getSouthPacificForms();
        qsolRef.getCustomerComplntPromptSheet();
        qsolRef.ECM_CalibrationRevisionHistory(); 
        qsolRef.Policy_Resource_System();
        qsolRef.wizardSpreadSheet();
    }

}