public class css_locale_formatted_datetime {
    
    public transient DateTime dt_created { get; set; } //property that reads the datetime value from the component attribute tag
    public transient DateTime dt_shopIn { get; set; } //property that reads the datetime value from the component attribute tag
    public transient DateTime dt_modify { get; set; } //property that reads the datetime value from the component attribute tag
    public transient String JobLocation { get; set; }
    public transient String JobOrderId { get; set; }
    public transient String JobStatusvalue {get;set;}
    //public String CreaLocaCode { get; set; } 
        public transient String jobOrdNumber { get; set; } 
       
    
    //returns the properly formatted datetime value
    public String getDtCreated() {
        //css_utility cUtil = new css_utility();
        transient String locale_formatted_date_time_value = css_utility.getFormattedDate(dt_created); //Get formatted String from Utility Class
        return locale_formatted_date_time_value; //return the string
    }
    public String getDtShopIn() {
        //css_utility cUtil = new css_utility();
        transient String locale_formatted_date_time_value = css_utility.getFormattedDate(dt_shopIn); //Get formatted String from Utility Class
        return locale_formatted_date_time_value; //return the string
    }
    public String getDtModify() {
        //css_utility cUtil = new css_utility();
        transient String locale_formatted_date_time_value = css_utility.getFormattedDate(dt_modify); //Get formatted String from Utility Class
        return locale_formatted_date_time_value; //return the string
    } 
    //---Added location code from  71790 And 71204 documents--->
   public String getLocCode() {
       transient String CreatorLocation; 
       if(jobOrdNumber!=null && jobOrdNumber!='')
       {CreatorLocation = [select creator_Location__c from css_job_order__c where name = :jobOrdNumber].Creator_Location__c;}
       else{
           transient User user = css_utility.getUserAttributes(userInfo.getUserId());
           CreatorLocation = user.User_Location__c;  
       }   
       transient String LocCode;
       if(CreatorLocation!=null && CreatorLocation!= ''){ 
               system.debug('CreaLocaCode***'+CreatorLocation);
            transient Integer JobLocLength = CreatorLocation.Length();
        transient Integer Index = JobLocLength-5;
         system.debug('JobLocLength***'+JobLocLength);
        system.debug('Index***'+Index);
           LocCode = CreatorLocation.substring(Index,CreatorLocation.Length());
        system.debug('JobLocCode***'+LocCode);
       }                         

       return LocCode; 
              
    } 
}