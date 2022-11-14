public without sharing class dbu_validateproductwithstore {
    @AuraEnabled
    public static Map<string,object> getdata(string countrycode, string productid) {
        system.debug('countrycode > ' + countrycode);
        system.debug('productid > ' + productid);
        if(countrycode == 'null' && countrycode == '' && countrycode == 'undefined'){
            countrycode = null;
        }
        string CountryRequested = countrycode;
        string CountryReturned;
        boolean Countryssimilar = false;
        system.debug('CountryRequested > ' + CountryRequested);
        //perform query to product
        ccrz__E_Product__c productInfo = [select id, name, DBU_Product_Location__c from ccrz__E_Product__c where id=: productid];
        //ccrz__E_Product__c info = [select id, name, DBU_Product_Location__c from ccrz__E_Product__c where id = 'a2w3C000000EsvE'];
        
        system.debug('productInfo > ' + productInfo);
        if((productInfo.DBU_Product_Location__c).contains(CountryRequested)){
            system.debug('uzbek');
            CountryReturned = CountryRequested;
            Countryssimilar = true;
        }else{
            system.debug('vladivostok');
            list<string> er = new list<string>();
            er = (productInfo.DBU_Product_Location__c).split(';');
            system.debug('er > ' + er);
            CountryReturned = er[0];
            Countryssimilar = false;
        }         
        /*
        methodWrapper eachwrap = new methodWrapper();
        eachwrap.productid = productInfo.id;
        eachwrap.productName = productInfo.name; 
        eachwrap.samecountrycode = Countryssimilar;
        eachwrap.countryrequested = CountryRequested;
        eachwrap.countryreturned = CountryReturned;
        system.debug('KAZAN > ' + eachwrap);
        */
        Map<string,object> eachwrap = new Map<string,object>();
        eachwrap.put('productid', productInfo.id);
        eachwrap.put('productName', productInfo.name);
        eachwrap.put('samecountrycode', Countryssimilar);
        eachwrap.put('countryrequested', CountryRequested);
        eachwrap.put('countryreturned', CountryReturned);

        return eachwrap;        
    }
    
    public class methodWrapper{
        public string productid;
        public string productName;
        public boolean samecountrycode;
        public string countryrequested;
        public string countryreturned;
    }
}