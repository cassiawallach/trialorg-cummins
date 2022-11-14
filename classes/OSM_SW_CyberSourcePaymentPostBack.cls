global  class OSM_SW_CyberSourcePaymentPostBack 
{
    public String result { get; set; }
    public Map<String, Object> parameters { get; set; }
 
    global OSM_SW_CyberSourcePaymentPostBack() 
    {
        System.debug('====Inside OSM_SW_CyberSourcePaymentPostBack====');
          ccrz.ccLog.log('===OSM_SW_CyberSourcePaymentPostBack===');
        this.result = '{}';

       this.parameters = new Map<String, Object>();

        Map<String, String> params = ApexPages.currentPage().getParameters();

      if (!params.isEmpty())
      {
       for(String key : params.keySet()) 
       {
           this.parameters.put(key, params.get(key));
       }
          this.result = JSON.serialize(parameters);
        }
        
        //ccrz.ccLog.log(System.LoggingLevel.DEBUG, 'RESULT IN POSTBACK', this.result);
    }

}