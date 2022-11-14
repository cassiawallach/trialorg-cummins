public class ABO_Azure_Service
{
    public List<Object> getCountries()
    {
     List<SelectOption> options = new List<SelectOption>();

        options.add(new SelectOption('','--SELECT COUNTRY--'));
        HttpRequest req=new HttpRequest();
        req.setEndPoint(System.label.ABO_Azure_Country_URL+'GetCountry');
        String authorizationHeader='Basic QXp1cmVXZWJBcGk6QVBJQDIwMTY=';
        req.setHeader('Authorization',authorizationHeader);
        req.setMethod('GET');
        req.setHeader('Content-Type','application/json');
        // req.setBody(str);
        req.setTimeOut(120000);
        Http http=new Http();
        //Map<String,object> mapFields = new Map<String,object>();
        // mapFields.put('inputdata',str);
        //String JSONString = JSON.serialize(mapFields);
        // req.setBody(JSONString);
        // System.debug('::::'+JSONString);
        req.setTimeout(120000);
        HTTPResponse res;
        try{
            res=http.send(req);
        }
        Catch(Exception e){
            System.debug(':::::'+e);
        }
        String postBody=res.getBody();
        System.debug(':::res body length'+res.getBody().length());
        System.debug(':::res body'+res.getBody());
        List<Object> countryList;
        if(postBody!=null && postBody!='{}'){
            countryList=(List<Object>) JSON.deserializeUntyped(postBody);
        }
        system.debug('+++++++++++++++++++++'+countryList);
        return countryList;
    }
    public List<Object> getStates(String str)
    {
        HttpRequest req=new HttpRequest();
        req.setEndPoint(System.label.ABO_Azure_Country_URL+'GetState');
        String authorizationHeader='Basic QXp1cmVXZWJBcGk6QVBJQDIwMTY=';
        req.setHeader('Authorization',authorizationHeader);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        // req.setBody(str);
        req.setTimeOut(120000);
        Http http=new Http();
        Map<String,object> mapFields = new Map<String,object>();
        mapFields.put('inputdata',str);
        String JSONString = JSON.serialize(mapFields);
        req.setBody(JSONString);
        System.debug('::::'+JSONString);
        req.setTimeout(120000);
        HTTPResponse res;
        try{
            res=http.send(req);
        }
        Catch(Exception e){
            System.debug(':::::'+e);
        }
        String postBody=res.getBody();
        System.debug(':::res body length'+res.getBody().length());
        System.debug(':::res body'+res.getBody());
        List<Object> stateList;
        if(postBody!=null && postBody!='{}'){
            stateList=(List<Object>) JSON.deserializeUntyped(postBody);
        }
        system.debug('+++++++++++++++++++++'+stateList);
        return stateList;
    }
    public List<Object> getDistricts(String str,string str2)
    {
        HttpRequest req1=new HttpRequest();
        req1.setEndPoint(System.label.ABO_Azure_Country_URL+'GetDistrict');
        String authorizationHeader='Basic QXp1cmVXZWJBcGk6QVBJQDIwMTY=';
        req1.setHeader('Authorization',authorizationHeader);
        req1.setMethod('POST');
        req1.setHeader('Content-Type','application/json');
        // req1.setBody(str);
        req1.setTimeOut(120000);
        Http http1=new Http();
        Map<String,object> mapFields1 = new Map<String,object>();
        mapFields1.put('InputCountryData',str);
        mapFields1.put('InputStateData',str2);
        String JSONString1 = JSON.serialize(mapFields1);
        req1.setBody(JSONString1);
        System.debug('::::'+JSONString1);
        req1.setTimeout(120000);
        HTTPResponse res;
        try{
            res=http1.send(req1);
        }
        Catch(Exception e){
            System.debug(':::::'+e);
        }
        String postBody1=res.getBody();
        System.debug(':::res body length'+res.getBody().length());
        System.debug(':::res body'+res.getBody());
        List<Object> districtList;
        if(postBody1!=null && postBody1!='{}'){
            districtList=(List<Object>) JSON.deserializeUntyped(postBody1);
        }
        system.debug('+++++++++++++++++++++'+districtList);
        return districtList;
    }
    public List<Object> getCity(String str,String str2,String str3)
    {
        HttpRequest req1=new HttpRequest();
        req1.setEndPoint(System.label.ABO_Azure_Country_URL+'GetCity');
        String authorizationHeader='Basic QXp1cmVXZWJBcGk6QVBJQDIwMTY=';
        req1.setHeader('Authorization',authorizationHeader);
        req1.setMethod('POST');
        req1.setHeader('Content-Type','application/json');
        // req1.setBody(str);
        req1.setTimeOut(120000);
        Http http1=new Http();
        Map<String,object> mapFields1 = new Map<String,object>();
        mapFields1.put('InputCountryData',str);
        mapFields1.put('InputStateData',str2);
        mapFields1.put('InputDistrictData',str3);
        String JSONString1 = JSON.serialize(mapFields1);
        req1.setBody(JSONString1);
        System.debug('::::'+JSONString1);
        req1.setTimeout(120000);
        HTTPResponse res;
        try{
            res=http1.send(req1);
        }
        Catch(Exception e){
            System.debug(':::::'+e);
        }
        String postBody1=res.getBody();
        System.debug(':::res body length'+res.getBody().length());
        System.debug(':::res body'+res.getBody());
        List<Object> cityList;
        if(postBody1!=null && postBody1!='{}'){
            cityList=(List<Object>) JSON.deserializeUntyped(postBody1);
        }
        system.debug('+++++++++++++++++++++'+cityList);
        return cityList;
    }
}