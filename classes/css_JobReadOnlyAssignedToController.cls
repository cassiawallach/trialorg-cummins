public class css_JobReadOnlyAssignedToController
{
    public Id jobId{get;set;}
    public String[] LocArray;
    Public string Locationcod{get;set;}
    public boolean certifiedSelected {get; set;}
    public boolean certifiedSelected1 {get; set;}
    public boolean certifiedSelected2 {get; set;}
    public boolean certifiedSelected3 {get; set;}
    public boolean certifiedSelected4 {get; set;}
    public boolean certifiedSelected5 {get; set;}
    public boolean certifiedSelected6 {get; set;}
    public boolean certifiedSelected7 {get; set;}
    public boolean certifiedSelected8 {get; set;}
    public boolean certifiedSelected9 {get; set;}
    
    
    public css_JobReadOnlyAssignedToController()
    {
    }
    
    public String getLocaCode() {
        
        if(Locationcod !=null && Locationcod !='')
        { 
            if(Locationcod.contains('-')){
                LocArray = Locationcod.split('-');
            }
        }
        if(LocArray != null && LocArray.size()>0)
            Locationcod = LocArray[1];
            return Locationcod;
            
    }
    
    
}