/******
Name:  OSM_WS_GeneralizedSubmitOrderInputWrap
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       23/10/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_WS_GeneralizedSubmitOrderInputWrap{ 
    public Header Header{get;set;}
    public DataArea DataArea{get;set;}
    public class Header{
        public Sender Sender{get;set;}
        public Target Target{get;set;}
        }
    public class Sender{
        public String ServiceName{get;set;}
        public String SenderID{get;set;}
    }
    public class Target{
        public String TargetID{get;set;}
    }
    public class DataArea {
        public String LocationID{get;set;}   
        public String CustomerCode{get;set;} 
        public String Sender{get;set;}   //Mrktplc
        public List<FSDList> FSDList{get;set;}
        public List<TaxList> TaxList{get;set;}
        public List<ChargeList> ChargeList{get;set;}
        public List<R_PARTSLIST_SUBMIT> R_PARTSLIST_SUBMIT{get;set;}
        
        public String Attribute01{get;set;} 
        public String Attribute02{get;set;} 
        public String Attribute03{get;set;} 
    }
    public class FSDList {
        public String VENDOR{get;set;}   //Mrktplc
        public String CUSTOMER_LOCATION_CODE {get;set;} // WWSPS Service Provider Code
        public String SALES_ORDER_ID{get;set;}  //701
        public String ORDER_SOURCE_TYPE{get;set;}    //OESD
        public String TAX_DISTRICT{get;set;} //47201-IN
        public String PAYMENT_TYPE{get;set;} //CHARGE
        public String STATUS{get;set;}   //Order Submitted
        public String INVOICE_NUMBER{get;set;}   //I-0000000135
        public Date INVOICE_DATE{get;set;} //10/17/2018
        public Double INVOICE_TOTAL{get;set;}    //350.56
        public String BILL_TO_CUST_NUMBER{get;set;}  //1234
        public String BILL_TO_NAME{get;set;} //Test
        public String SHIP_TO_NAME{get;set;} //Test
        public String SHIP_TO_ADDRESS1{get;set;} //3270 Wint ln
        
        public String SHIP_TO_ADDRESS2{get;set;}
        public String SHIP_TO_ADDRESS3{get;set;}
        public String SHIP_TO_COUNTRY{get;set;}
        
        public String SHIP_TO_CITY{get;set;} //COLUMBUS
        public String SHIP_TO_STATE{get;set;}    //IN
        public String SHIP_TO_POSTAL_CODE{get;set;}  //47201
        public String OE_COMMENT{get;set;}   //Test Order
        public String CUSTOMER_PO_NUMBER{get;set;}   //222222
        public Integer Attribute01{get;set;}  //Test
        public String Attribute02{get;set;}  // 
        public String Attribute03{get;set;}  // 
    }
    public class TaxList {
        public String TAX_AUTHORITIES{get;set;}  //58801-ND-28085
        public String PRINT_GROUP{get;set;}  //Test
        public String SALES_CATEGORIES{get;set;} //Test
        public Decimal TAX_AMOUNT{get;set;}   //2.5
       // public Integer TAX_AMOUNT{get;set;}
        public Decimal SALE_AMOUNT{get;set;} //100
        public Integer Attribute01{get;set;}  //Test
        public String Attribute02{get;set;}  //Test
        public String Attribute03{get;set;}  //Test
    }
    public class ChargeList {
        public String MISC_CHARGE{get;set;}  //CHARGE
        public Decimal MISC_CHARGE_AMOUNT{get;set;}  //10
        public Integer Attribute01{get;set;}  //Test
        public String Attribute02{get;set;}  //Test
    }
    public class R_PARTSLIST_SUBMIT {
        public String ITEM_NUMBER{get;set;}  //Test-SES-SKU-1
        public String PRODUCT{get;set;}  //Mrktplc
        public String DESCRIPTION{get;set;}  //Test
        public Integer QUANTITY{get;set;}    //1
        public String UOM{get;set;}  //EA
        //public Integer SELLING_PRICE{get;set;}
        //public Integer ITEM_COST{get;set;}
        public Decimal SELLING_PRICE{get;set;}
        public Decimal ITEM_COST{get;set;}  //200
        public String NONSTOCK_TYPE{get;set;}    //Test
        public String LINE_TYPE{get;set;}    //Test
        public Integer Attribute01{get;set;}  //Test 
        public String Attribute02{get;set;}  //Test
        public String Attribute03{get;set;}  //Test
    }

    
}