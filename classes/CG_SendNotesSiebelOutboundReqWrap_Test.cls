@isTest
public class CG_SendNotesSiebelOutboundReqWrap_Test {
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
		'    \"SiebelClaimNumber\": \"CSS-00044023\",'+
		'    \"ReqOperation\": \"56270\",'+
		'    \"NoteDetails\": ['+
		'  {'+
		'        \"Note\": \"Factoty\",'+
		'        \"ExtNoteId\": \"RLC DISCOUNT\",'+
		'        \"NoteType\":\"RLC DISCOUNT\"'+
		'      },'+
        '  {'+
		'        \"Note\": \"Factoty\",'+
		'        \"ExtNoteId\": \"RLC DISCOUNT\",'+
		'        \"NoteType\":\"RLC DISCOUNT\"'+
		'      }'+
		
		'    ]'+
		'  }'+
        '}';
           
            
       CG_SendNotesSiebelOutboundRequestWrapper obj = CG_SendNotesSiebelOutboundRequestWrapper.parse(json);     
         System.assert(obj != null);
          }
}