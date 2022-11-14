public without Sharing class IAM_Relay_Values{
 public static string GetValueFromParam(string ParamKey)
    {
        string toReturn='';
        if(ApexPages.currentPage().getParameters().containsKey(ParamKey))
        {            
            toReturn=ApexPages.currentPage().getParameters().get(ParamKey);
            //toReturn=ApexUtil.GetCleanString(toReturn);        
        }
        return toReturn;
    } 
 }