public class CSS_JobReadOnlyUEController
{
    public Id jobId{get;set;}
    public DateTime dt_WarrantyDt { get; set; }
    public DateTime WarrantyStart { get; set; }
    public DateTime dt_FailureDt { get; set; }
    
    
    public CSS_JobReadOnlyUEController()
    {
 
    }
    
    public String getWarrantyDate() {
        String locale_formatted_date_time_value='';
        if(dt_WarrantyDt != null){
            locale_formatted_date_time_value = dt_WarrantyDt.format('dd MMM YYYY', 'GMT'); 
        }
     return locale_formatted_date_time_value; 
    }
    
    
    public String getFailureDt() {
        String locale_formatted_date_time_value='';
        if(dt_FailureDt != null){
            locale_formatted_date_time_value = dt_FailureDt.format('dd MMM YYYY', 'GMT'); 
        }
        return locale_formatted_date_time_value; 
    }   
    
      public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.css_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        //options.add(new SelectOption('Hours',system.Label.css_hours)); 
        return options;
    }
}