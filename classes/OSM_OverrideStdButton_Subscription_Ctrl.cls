public class OSM_OverrideStdButton_Subscription_Ctrl {
  Public ccrz__E_Subscription__c invoice{get;set;}
    public boolean displayError {get; set;} 
    public  OSM_OverrideStdButton_Subscription_Ctrl(ApexPages.StandardController controller){
        this.invoice=new ccrz__E_Subscription__c();
        displayError=false;
        if(!test.isRunningTest())controller.addFields(new List<String>{'Name','ccrz__Storefront__c'});
        this.invoice = (ccrz__E_Subscription__c)controller.getRecord();
    }
    
    public PageReference deleteinvoice(){
        PageReference reference ;
        if(invoice.ccrz__Storefront__c!=null && invoice.ccrz__Storefront__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission')){
         displayError=true; 
            return null;
        }else{
            //delete invoice;
            Schema.DescribeSObjectResult destination = ccrz__E_Subscription__c.sObjectType.getDescribe();
            reference = new PageReference('/'+ destination.getKeyPrefix() );
            reference.setRedirect(true);
        }
        return reference;
    } 
}