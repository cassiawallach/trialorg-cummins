/**********************************************************************
Name: FSLProductRangeWrapper
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
public class FSLProductRangeWrapper {

	public String PRODUCT_TYPE;
	public String PRODUCT_RANGE;
	public String MARKET_APPLICATION;

	
	public static List<FSLProductRangeWrapper> parse(String json) {
		return (List<FSLProductRangeWrapper>) System.JSON.deserialize(json, List<FSLProductRangeWrapper>.class);
	}
}