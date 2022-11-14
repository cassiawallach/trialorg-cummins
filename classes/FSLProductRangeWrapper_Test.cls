/**********************************************************************
Name: FSLProductRangeWrapper_Test
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    Test Class for FSLSPProductRangeScheduler
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         04/16/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
@IsTest
public class FSLProductRangeWrapper_Test {
	static testMethod void testParse() {
		String json = '[{\"PRODUCT_TYPE\": \"Engine\",\"PRODUCT_RANGE\": \"Mid-Range\",\"MARKET_APPLICATION\": \"AUTOMOTIVE\"},{\"PRODUCT_TYPE\": \"Engine\",\"PRODUCT_RANGE\": \"Mid-Range\",\"MARKET_APPLICATION\": \"AUTOMOTIVE\"}]';
		List<FSLProductRangeWrapper> obj = FSLProductRangeWrapper.parse(json);
		System.assert(obj != null);
	}
}