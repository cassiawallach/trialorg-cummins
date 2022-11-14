/******
Name:  OSM_WS_SubmitOrderInfo_REQ
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       16/10/2018     INITIAL DEVELOPMENT 
*******/
public with sharing class OSM_WS_SubmitOrderInfo_REQ{
    public class Sender {
        public String ServiceName{get;set;}
        public String SenderID{get;set;}
    }

    public class Target {
        public String TargetID{get;set;}
    }

    public class DataArea {
        public String LocationID{get;set;}
        public String CustomerCode{get;set;}
        public String Sender{get;set;}
        public List<FSDList> FSDList{get;set;}
        public List<TaxList> TaxList{get;set;}
        public List<ChargeList> ChargeList{get;set;}
        public List<R_PARTSLIST_SUBMIT> R_PARTSLIST_SUBMIT{get;set;}
        
        public String Attribute01{get;set;} 
        public String Attribute02{get;set;} 
        public String Attribute03{get;set;} 
    }

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public Sender Sender{get;set;}
        public Target Target{get;set;}
    }

    public class ChargeList {
        public String MISC_CHARGE{get;set;}
        public Decimal MISC_CHARGE_AMOUNT{get;set;}
        public Integer Attribute01{get;set;}
        public String Attribute02{get;set;}
    }

    public class TaxList {
        public String TAX_AUTHORITIES{get;set;}
        public String PRINT_GROUP{get;set;}
        public String SALES_CATEGORIES{get;set;}
        public Decimal TAX_AMOUNT{get;set;}
      //  public Integer TAX_AMOUNT{get;set;}
        public Decimal SALE_AMOUNT{get;set;}
        public Integer Attribute01{get;set;}
        public String Attribute02{get;set;}
        public String Attribute03{get;set;}
    }

    public class FSDList {
        public String VENDOR{get;set;}
        public String CUSTOMER_LOCATION_CODE {get;set;}
        public String SALES_ORDER_ID{get;set;}
        public String ORDER_SOURCE_TYPE{get;set;}
        public String TAX_DISTRICT{get;set;}
        public String PAYMENT_TYPE{get;set;}
        public String STATUS{get;set;}
        public String INVOICE_NUMBER{get;set;}
        public Date INVOICE_DATE{get;set;}
        public Double INVOICE_TOTAL{get;set;}
        public String BILL_TO_CUST_NUMBER{get;set;}
        public String BILL_TO_NAME{get;set;}
        public String SHIP_TO_NAME{get;set;}
        public String SHIP_TO_ADDRESS1{get;set;}
        
        public String SHIP_TO_ADDRESS2{get;set;}
        public String SHIP_TO_ADDRESS3{get;set;}
        public String SHIP_TO_COUNTRY{get;set;}
        
        public String SHIP_TO_CITY{get;set;}
        public String SHIP_TO_STATE{get;set;}
        public String SHIP_TO_POSTAL_CODE{get;set;}
        public String OE_COMMENT{get;set;}
        public String CUSTOMER_PO_NUMBER{get;set;}
        public Integer Attribute01{get;set;}
        public String Attribute02{get;set;}
        public String Attribute03{get;set;}
    }

    public class R_PARTSLIST_SUBMIT {
        public String ITEM_NUMBER{get;set;}
        public String PRODUCT{get;set;}
        public String DESCRIPTION{get;set;}
        public Integer QUANTITY{get;set;}
        public String UOM{get;set;}
        //public Integer SELLING_PRICE{get;set;}
        //public Integer ITEM_COST{get;set;}
        public Decimal SELLING_PRICE{get;set;}
        public Decimal ITEM_COST{get;set;}

        public String NONSTOCK_TYPE{get;set;}
        public String LINE_TYPE{get;set;}
        public Integer Attribute01{get;set;}
        public String Attribute02{get;set;}
        public String Attribute03{get;set;}
    }
    
    public static OSM_WS_SubmitOrderInfo_REQ parse(String json) {
        return (OSM_WS_SubmitOrderInfo_REQ) System.JSON.deserialize(json, OSM_WS_SubmitOrderInfo_REQ.class);
    }
}