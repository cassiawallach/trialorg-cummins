@isTest
public class CSS_WPR_SBL_ApplnCategoryListReq_Test {
    
    
    static testmethod void testApplnCategoryListReqJSON(){
        
        String json = '{'+
            '	\"Header\": {'+
            '	\"Sender\": {'+
            '		\"SenderID\": \"S1234\",'+
            '		\"ServiceName\": \"Application category\",'+
            '		\"MessageID\": \"Message 045\",'+
            '		\"CreationDateTime\": \"23052017\"'+
            '	}'+
            '	}'+
            '}';
        CSS_WPR_SBL_ApplnCategoryListReqJSON obj = CSS_WPR_SBL_ApplnCategoryListReqJSON.parse(json);
		System.assert(obj != null);
        
        //Test.startTest();        
        //Test.stopTest();
    }

}