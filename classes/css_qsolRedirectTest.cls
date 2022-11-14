@isTest
public class css_qsolRedirectTest {
    static PageReference pref;
    public static testMethod void testqsolRedirect(){       
        
        CSS_Job_Order__c job = NEW CSS_Job_Order__c();        
        //job.ESN__c = '79464646';
        job.Status__c = 'Created/Not Assigned';
        job.Customer_Name__c = 'CumminsTnD';
        insert job;    
        //pref = new PageReference('/'+job.id);
        //pref.getParameters().put('id',job.id);
       // Test.setCurrentPage('https://cumminscss--cssbrkfx--c.cs59.visual.force.com/apex/CSS_SymRepairPage?id=a052C000000GM98QAG&rank=0&symid=a0s2C0000004V4cQAE');
        String Referer = '?docid=1234&id='+job.Id+'&rank=0';    
        ApexPages.CurrentPage().getParameters().put('docid','1234');
        ApexPages.CurrentPage().getParameters().put('doctype','Text');
        ApexPages.CurrentPage().getParameters().put('pgroup','pgroup');
        ApexPages.currentPage().getHeaders().put('Referer',Referer); 
        
        css_qsolRedirect controller = new css_qsolRedirect();
        controller.qsolResp = 'z';
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CSS_LinkMgmt_Test());  
        controller.redirect();
        
        String Referer0 = '  &id='+job.Id+'&rank=0';
        ApexPages.currentPage().getHeaders().put('Referer',Referer0); 
        controller.redirect();
        
        String Referer1 = '  ?id='+job.Id+'&rank=0';
        ApexPages.currentPage().getHeaders().put('Referer',Referer1); 
        controller.redirect();
        
        String Referer2 = '  ?id='+job.Id;
        ApexPages.currentPage().getHeaders().put('Referer',Referer2); 
        controller.redirect();
        
        String Referer3 = '  &id='+job.Id;
        ApexPages.currentPage().getHeaders().put('Referer',Referer3); 
        controller.redirect();
        
        
        
        
        Test.stopTest();   
    }
}