/**********************************************************************
Name: CSS_WPR_BMS_WOQTOutboundQuoteReqJSON
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper class
            of WOQT Outbound Quote PDF of BMS Rest Service
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/14/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_WPR_BMS_WOQTOutboundQuoteReqJSON {
    public DataArea DataArea;
	public Header Header;
    
	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String QuoteTotal;
		public String MiscWarranty;
		public String ItemGrossSell;
		public String BranchCode;
		public String LaborWarranty;
		public String TransactionType;
		public String MiscBillable;
		public String Surcharge;
		public String ItemBillable;
		public String MiscGrossSell;
		public String Taxes;
		public String DistributorCode;
		public String CustomerNumber;
		public String LaborBillable;
		public String LaborGrossSell;
		public String ItemWarranty;
		public String OrderReference;
		public String GrandTotal;
		public String DiagnosticCharges;
		public String CSSJobID;
        public QuoteDoc QuoteDoc;
	}

	public class Header {
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public class RealBlobValue {
		public String asByteArray;
	}

	public class Body {
		public RealBlobValue realBlobValue;
	}

	public class QuoteDoc {
		public Body Body;
		public String ContentType;
	}

	public class Location {
		public String LocationID;
	}
	
	public static CSS_WPR_BMS_WOQTOutboundQuoteReqJSON parse(String json) {
		return (CSS_WPR_BMS_WOQTOutboundQuoteReqJSON) System.JSON.deserialize(json, CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.class);
	}
}