/*
 * Block comments with details of changes
 */
public class CG_CL_CustomerROCompClass
{

    public CG_CL_IntakeRJ mainContrRJ{get;set;}
    public Id Wid;
    public String PageName {get;set;}
    public CG_CL_CustomerROCompClass()
    {
Wid=ApexPages.CurrentPage().getParameters().get('id');
    }
    
  public DateTime dt_shopIn { get; set; }
    //Prida Added below Code (19/03)
   public DateTime dt_created { get; set; }
    
    //Prida Added below Code (19/03)  	
 public String getDtShopIn() {
        //css_utility cUtil = new css_utility();
     system.debug('dt_shopIn--'+dt_shopIn);
    // String locale_formatted_date_time_value = css_utility.getFormattedDate(dt_shopIn); //Get formatted String from Utility Class
     String locale_formatted_date_time_value ='';
     if(dt_shopIn != null){
         locale_formatted_date_time_value = dt_shopIn.format('dd MMM YYYY', 'GMT');
     }
     system.debug('locale_formatted_date_time_value--'+locale_formatted_date_time_value);
        return locale_formatted_date_time_value; //return the string
    }
   //Prida Added below Code (19/03)    
 public String getDtCreated() {		
	        //css_utility cUtil = new css_utility();		
	        String locale_formatted_date_time_value='';		
	     if(dt_created!=null){		
	        locale_formatted_date_time_value = css_utility.getFormattedDate(dt_created); //Get formatted String from Utility Class		
	     }		
	         return locale_formatted_date_time_value; //return the string		
	    }
    public PageReference nvIntakeCustomer(){

        PageReference pageRef;

        if(Wid==null){
            pageRef = new pageReference('/apex/CG_IntakeCustomer'); 
        }else{
            pageRef = new pageReference('/apex/CG_IntakeCustomer?id='+Wid); 
        }
        return pageRef;
    }
}