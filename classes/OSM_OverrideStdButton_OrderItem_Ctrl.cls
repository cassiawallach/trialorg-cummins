public without sharing class OSM_OverrideStdButton_OrderItem_Ctrl {
    
    Public ccrz__E_OrderItem__c invoice{get;set;}
    public boolean displayError {get; set;} 
    public  OSM_OverrideStdButton_OrderItem_Ctrl(ApexPages.StandardController controller){
        this.invoice=new ccrz__E_OrderItem__c();
        displayError=false;
        if(!test.isRunningTest())controller.addFields(new List<String>{'Name','ccrz__StoreId__c'});
        this.invoice = (ccrz__E_OrderItem__c)controller.getRecord();
    }
    
    public PageReference deleteinvoice(){
        PageReference reference ;
        if(invoice.ccrz__StoreId__c!=null && invoice.ccrz__StoreId__c=='SoftwareStore' && !FeatureManagement.checkPermission('OSM_Can_Delete_Records_Permission')){
         displayError=true; 
            return null;
        }else{
            //delete invoice;
            Schema.DescribeSObjectResult destination = ccrz__E_Invoice__c.sObjectType.getDescribe();
            reference = new PageReference('/'+ destination.getKeyPrefix() );
            reference.setRedirect(true);
        }
        return reference;
    }   
}