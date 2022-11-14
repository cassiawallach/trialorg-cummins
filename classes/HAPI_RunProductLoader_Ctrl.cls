/*
* Controller Class to run the HAPI Product Loader from Salesforce Object Tab - List View
* 
* @author : Juhi Krishnamurthy
* @created date : November 09, 2018 
* 
*/

public class HAPI_RunProductLoader_Ctrl 
{
    public String version{get;set;}    
       
    public PageReference show()
    {
        HAPI_ProductLoader.loadProductData(version);
       
        PageReference pageRef = new PageReference('/apex/HAPI_DataLoadCodeInititated_Pg');
        return pageRef;
    }
}