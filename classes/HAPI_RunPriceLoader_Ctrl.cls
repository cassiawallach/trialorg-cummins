/*
* Controller Class to run the HAPI Price Loader from Salesforce Object Tab - List View
* 
* @author : Juhi Krishnamurthy
* @created date : November 09, 2018 
* 
*/

public class HAPI_RunPriceLoader_Ctrl 
{
    public String version{get;set;}    
       
    public PageReference show()
    {
        HAPI_PricingLoader_Batch batch = new HAPI_PricingLoader_Batch(version);
        database.executeBatch(batch, 1);
       
        PageReference pageRef = new PageReference('/apex/HAPI_DataLoadCodeInititated_Pg');
        return pageRef;
    }
}