@isTest
public class FSL_CL_qsolRedirect_Test {
    static PageReference pref;
    public static testMethod void testqsolRedirect(){       
        
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;
        
         
        WorkOrder wo = NEW WorkOrder();        
        //job.ESN__c = '79464646';
        wo.Status = 'Intake';
        wo.Customer_Name__c = 'CumminsTnD';
        wo.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        insert wo;    
        
        String Referer = '?docid=1234&id='+wo.Id+'&rank=0';    
        ApexPages.CurrentPage().getParameters().put('docid','1234');
        ApexPages.CurrentPage().getParameters().put('doctype','Text');
        ApexPages.CurrentPage().getParameters().put('pgroup','pgroup');
        ApexPages.currentPage().getHeaders().put('Referer',Referer); 
        ApexPages.CurrentPage().getParameters().put('serialNumber','79788868-001234');
        
        FSL_CL_qsolRedirect controller = new FSL_CL_qsolRedirect();
        controller.qsolResp = 'z';
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_LinkMgmt_Test());  
        controller.redirect();
        
        String Referer0 = '  &id='+wo.Id+'&rank=0';
        ApexPages.currentPage().getHeaders().put('Referer',Referer0); 
        controller.redirect();
        
        String Referer1 = '  ?id='+wo.Id+'&rank=0';
        ApexPages.currentPage().getHeaders().put('Referer',Referer1); 
        controller.redirect();
        
        String Referer2 = '  ?id='+wo.Id;
        ApexPages.currentPage().getHeaders().put('Referer',Referer2); 
        controller.redirect();
        
        String Referer3 = '  &id='+wo.Id;
        ApexPages.currentPage().getHeaders().put('Referer',Referer3); 
        controller.redirect();
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();  
        conDetails3.name= 'FSL_MOVEXMROMessages';
        conDetails3.End_Point__c= 'https://test.Com/MROMessages';
        conDetails3.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails3.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails3.IsActive__c = true;
        conDetails3.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';     
        insert conDetails3;
        Test.stopTest();   
    }
}