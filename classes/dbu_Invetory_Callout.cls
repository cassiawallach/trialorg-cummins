public class dbu_Invetory_Callout {
    
    @AuraEnabled
    public static List<Dbu_InventoryWrapper>  getInventory(String partNumber, String location){
        try{
           List<Dbu_InventoryWrapper> resp = new List<Dbu_InventoryWrapper>();
        	HttpRequest req = new HttpRequest();
    		req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSIsImtpZCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9kYnMtYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsImlhdCI6MTU4NDY1MjE4NCwibmJmIjoxNTg0NjUyMTg0LCJleHAiOjE1ODQ2NTYwODQsImFpbyI6IjQyTmdZUGpCUDYzcnp5ZHpOdlpOWHErZis2d3NCUUE9IiwiYXBwaWQiOiJmOTY1ODUyNi1lZTU5LTRlZWEtYTA2Mi0zZTNlZGE1M2QyYWIiLCJhcHBpZGFjciI6IjEiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwib2lkIjoiZTcxMDgzODAtZjY3NS00ODE0LWI2MmItZGVjMDA2N2M1YmE2Iiwic3ViIjoiZTcxMDgzODAtZjY3NS00ODE0LWI2MmItZGVjMDA2N2M1YmE2IiwidGlkIjoiYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkIiwidXRpIjoiU1N2d19YSHlERVdubXJPTUkyWV9BQSIsInZlciI6IjEuMCJ9.LdCokr9mIUQ3aXdzO4QOmQHagIVkK3MaoPRSsRvr7E0ZHugHsXIxBTNM6wkIWX1Igx0-gIAqcgdtMr-NY7wk5DEKZg-FnxGWPp3D-EthU86AqrBXwqIyjC162QlU-v2SGWDAOzxvVUE2ERYZI0uUTd4s5kCL2f7AY2dWyJB1kYk-HvSkaphTwh11Vnef8F2h66dPG-p-Y9aN3HnAkzKPdReCMenuoeDPbwEGVPOhJ-Ay1J7gk9zZHRwj9JxZdyvF-G2uOAApS--CMPRkd-PZve7oq6NwDTSq6d7dNstRuDTckFvoejE8bqe5GJgkZgn7Dk8GNuQqsPqJv_pOjWIxnA');
    		req.setMethod('GET');
    		req.setEndpoint('https://api-ue-devnf3-aw-ex.cummins.com/cmi/om/v1/inventories/availablity?partNumber='+ partNumber + '&location='+ location);
            req.setTimeout(40000);
    		Http http = new Http();
    		HTTPResponse res = http.send(req);
            System.debug('Inventory Response=>\t'+res);
            if (res.getStatusCode() == 200) {
                System.debug('res.getbody()===>'+res.getbody());
               if(String.isNotBlank(res.getbody())){
                   try{
                        resp = (List<Dbu_InventoryWrapper>)JSON.deserialize(res.getbody(), List<Dbu_InventoryWrapper>.class);
                   }catch(Exception ex){
                        system.debug('Exception in dbu_Invetory_Callout JSON.deserialize=='+ex.getMessage()+'LineNumber='+ex.getLineNumber());
                        return null;
                   } 
               }
                system.debug('response ' + res.getBody());
                system.debug('inventory ' + resp);
                return resp;
        } else {
            return resp;
        }                        
        }catch(CallOutException ce){
            //throw ce;
            system.debug('Exception in dbu_Invetory_Callout=='+ce.getMessage()+'LineNumber='+ce.getLineNumber());
            return null;
        }      
    }
    
   /* public class Item {
        @AuraEnabled
		public String availableQuantity;
        @AuraEnabled
		public String partNumber;
        @AuraEnabled
		public String warehouse;
	}

	public class Items {
        @AuraEnabled
		public List<Item> item;
	}

	public class Inventory {
        @AuraEnabled
		public Items items;
	}*/

}