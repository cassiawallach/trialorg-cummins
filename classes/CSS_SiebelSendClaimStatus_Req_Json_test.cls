/**********************************************************************
Name:CSS_SiebelSendClaimStatus_Req_Json_Test
Copyright © 2018  Cummins
=======================================================================
=======================================================================
                                               
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR                DATE                 DETAIL                                 
1.0 -   Abhishek Rajput      21/06/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
@isTest

public class CSS_SiebelSendClaimStatus_Req_Json_test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"CSS\",'+
		'      \"SourceEnvironment\": \"CGCDWTST\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendClaimStatus\",'+
		'      \"SenderID\": \"SIEBEL\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"SiebelClaimNumber\": \"044023\",'+
		'    \"GuidanzClaimNumber\": \"C00044023\",'+
		'    \"ClaimStatus\": \"In Review\",'+
		'    \"NoteDetails\": ['+
		'      {'+
		'      \"Note\":\"Parts have been removed\",'+
		'      \"NoteType\": \"Parts\",'+
		'      \"RowId\":\"SBL928734\",'+
		'      \"LastUpdateDate\":\"2010-03-19T16:18:59\",'+
		'      \"CreatedDate\":\"2010-03-19T16:18:59\"'+
		'      },'+
		'      {'+
		'      \"Note\":\"Review SRTs times\",'+
		'      \"NoteType\": \"General\",'+
		'      \"RowId\":\"SBL928734\",'+
		'      \"LastUpdateDate\":\"2010-03-19T16:18:59\",'+
		'      \"CreatedDate\":\"2010-03-19T16:18:59\"'+
		'      }'+
		'      ]'+
		'  }'+
		'}';
		CSS_SiebelSendClaimStatus_Req_Json obj = CSS_SiebelSendClaimStatus_Req_Json.parse(json);
		System.assert(obj != null);
	}
}