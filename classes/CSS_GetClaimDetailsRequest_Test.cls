@Istest
public class CSS_GetClaimDetailsRequest_Test {
    static testMethod void testParse(){
        String json='{'+ 
             '  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"473\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendMiscCharges\",'+
		'      \"SenderID\": \"CSS\"'+
		'    }'+
		
		'  },'+
        '  \"DataArea\": {'+
		'    \"SiebelClaimNumber\": \"CSS-00044023\"'+
		
		
		'  }'+
        '}';
           
            
       CSS_GetClaimDetailsRequest obj = CSS_GetClaimDetailsRequest.parse(json);     
         System.assert(obj != null);
          }

}