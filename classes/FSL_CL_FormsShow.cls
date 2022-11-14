//P
public class FSL_CL_FormsShow {
    public string jobid{get;set;}
    public FSL_CL_FormsShow(){
        jobid = ApexPages.currentPage().getparameters().get('ID'); 
     }
    public pagereference navigateSames(){
        PageReference demoPage = new PageReference('/apex/FSL_FormsShowPage?id='+jobid);
        demoPage.setRedirect(true);
        return demoPage;
    }
}