public class CSS_JobReadOnlyCustomerController
{
    public Id jobId{get;set;}
    public static dateTime DT{get;set;}
    public static string Formatteddate{get;set;}
    
    public CSS_JobReadOnlyCustomerController()
    {
 
    }
    
    public static string getDates(){
        
        String timeZone = UserInfo.getTimeZone().getID();
        Datetime dateGMT = DT;
        Datetime dateNew = Datetime.valueOf(dateGMT);
        Formatteddate = dateNew.format();  
        System.debug('Formatteddate-->'+Formatteddate);
        return Formatteddate;
    }
}