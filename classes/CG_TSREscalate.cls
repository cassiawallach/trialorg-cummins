public class CG_TSREscalate{

    //Public String JobId{get;set{JobId=value;}}
    Public Id sJobId {get;set;}
    Public String JobNum {get;set;}
     
    public CG_TSREscalate(){
        sJobId=ApexPages.CurrentPage().getParameters().get('id');
        TSRAction();
    }
    
    public void TSRAction(){

    }
    public static pageReference EscalateAction(){
        system.debug('JobId**kal');
        Id sJobId=ApexPages.CurrentPage().getParameters().get('id');
        CG_BL_TSR.performTSRBusinessLogic();
        
        String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
        PageReference pageRef = new PageReference(sDestURL+'id='+ sJobId); 
        pageRef.setRedirect(true);
        return PageRef; 
        
    }
}