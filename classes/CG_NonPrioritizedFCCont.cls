public class CG_NonPrioritizedFCCont{
    
    public String JobId{get;set;}
    
    public CG_NonPrioritizedFCCont(){
        JobId=ApexPages.CurrentPage().getParameters().get('id');
        system.debug('JobId--'+JobId);
    }
}