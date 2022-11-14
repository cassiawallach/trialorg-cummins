/******
Name: OSM_WS_SubmitOrderInfo_Helper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       23/10/2018     INITIAL DEVELOPMENT 
*******/

public class OSM_WS_SubmitOrderInfo_Helper{
    public static OSM_WS_GeneralizedSubmitOrdrInpWrapper populateRequestObjData(OSM_WS_GeneralizedSubmitOrdrInpWrapper inputWrapperObj){
        String Sender_ID = Label.BMS_SenderID;
        String Target_ID ='BMS';
        String ServiceName='SubmitOrder';
        
        OSM_WS_GeneralizedSubmitOrdrInpWrapper reqObj = new OSM_WS_GeneralizedSubmitOrdrInpWrapper();
        reqObj.header=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Header();
        reqObj.header.sender =new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Sender();
        reqObj.header.target=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.Target();        
        reqObj.dataArea=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.DataArea();
        reqObj.dataArea.headerList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList>();
        OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList fsdList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList();
        reqObj.dataArea.TaxList =new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList>();
        OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList taxList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList();
        reqObj.dataArea.chargeList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList>();
        OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList chargeList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList();
        reqObj.dataArea.partList=new List<OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList>();
        OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList partList=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList();
        
        reqObj.header.sender.serviceName=ServiceName;
        if(inputWrapperObj.header.target.targetId == 'BMS')
            reqObj.header.sender.senderId=Sender_ID;
        else
            reqObj.header.sender.senderId = 'Marketplace';
        reqObj.header.sender.messageId='';
        reqObj.header.target.targetId=inputWrapperObj.header.target.targetId;
        reqObj.dataArea.locationId = inputWrapperObj.dataArea.locationId;
        reqObj.dataArea.customerCode = inputWrapperObj.dataArea.customerCode;
        reqObj.dataArea.sender =Sender_ID;
        
        reqObj.dataArea.orderReferenceNumber = inputWrapperObj.dataArea.orderReferenceNumber;
        if(inputWrapperObj.header.target.targetId == 'WINLIMS'){
            reqObj.dataArea.emailAddress = inputWrapperObj.dataArea.EmailAddress;
            reqObj.dataArea.phoneNumber = inputWrapperObj.dataArea.PhoneNumber;
        } 
        
        for(OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList objFsd:inputWrapperObj.dataArea.headerList){
            OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList objFSDrequest=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.FSDList();
            objFSDrequest.vendor =objFsd.vendor;
            objFSDrequest.customerLocationCode = OSM_Generic_Utility.fieldSizeRestriction(objFsd.customerLocationCode, 5, 'front');
            objFSDrequest.salesOrderId =objFsd.salesOrderID;
            objFSDrequest.orderSourceType =objFsd.orderSourceType;
            objFSDrequest.taxDistrict =objFsd.taxDistrict;
            objFSDrequest.paymentType =objFsd.paymentType;        
            objFSDrequest.status ='';
            objFSDrequest.invoiceNumber =OSM_Generic_Utility.fieldSizeRestriction(objFsd.invoiceNumber, 9, 'back');
            objFSDrequest.invoiceDate =objFsd.invoiceDate;
            objFSDrequest.invoiceTotal =objFsd.invoiceTotal;
            objFSDrequest.billToCustomerNumber =objFsd.billToCustomerNumber;
            objFSDrequest.billToName =OSM_Generic_Utility.fieldSizeRestriction(objFsd.billToName, 30, 'front');
            objFSDrequest.shipToName =OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToName, 30, 'front');
            objFSDrequest.shipToAddress1 =OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToAddress1, 25, 'front');
            
            if(null != objFsd.shipToAddress2)
                objFSDrequest.shipToAddress2 = objFsd.shipToAddress2;
            if(null != objFsd.shipToAddress3)
                objFSDrequest.shipToAddress3 = objFsd.shipToAddress3;
            if(null != objFsd.shipToCountry)
                objFSDrequest.shipToCountry = OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToCountry, 5, 'front');
             
            objFSDrequest.shipToCity = OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToCity, 60, 'front');
            objFSDrequest.shipToState = OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToState, 25, 'front');
            objFSDrequest.shipToPostalCode = OSM_Generic_Utility.fieldSizeRestriction(objFsd.shipToPostalCode, 10, 'front');
            objFSDrequest.orderComments = objFsd.orderComments;
            objFSDrequest.customerPONumber = OSM_Generic_Utility.fieldSizeRestriction(objFsd.customerPONumber, 25, 'front');
            /*objFSDrequest.attribute01 = 0;
            objFSDrequest.attribute02 = '';
            objFSDrequest.attribute03 = '';*/
            reqObj.dataArea.headerList.add(objFSDrequest);
        }
      

        for(OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList objTax : inputWrapperObj.dataArea.taxList){
            OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList objTaxRequest=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.TaxList();
            objTaxRequest.taxAuthorities =objTax.taxAuthorities;
            objTaxRequest.printGroup =objTax.printGroup;
            objTaxRequest.salesCategories =objTax.salesCategories;
            objTaxRequest.taxAmount =objTax.taxAmount;
            objTaxRequest.saleAmount =objTax.saleAmount;
            /*objTaxRequest.attribute01=objTax.attribute01;
            objTaxRequest.attribute02=objTax.attribute02;
            objTaxRequest.attribute03=objTax.attribute03;*/    
            reqObj.dataArea.taxList.add(objTaxRequest);         
        }
        
        for(OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList objCharge : inputWrapperObj.dataArea.chargeList){
            OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList objChargeRequest=new OSM_WS_GeneralizedSubmitOrdrInpWrapper.ChargeList();
            objChargeRequest.discountType ='Discount';
            objChargeRequest.totalDiscount =ObjCharge.totalDiscount;
            /*objChargeRequest.attribute01=ObjCharge.attribute01;
            objChargeRequest.attribute02=ObjCharge.attribute02;*/
            reqObj.dataArea.chargeList.add(objChargeRequest);
        }
        
        for(OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList objPartList : inputWrapperObj.dataArea.partList){
            OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList objPartListRequest = new OSM_WS_GeneralizedSubmitOrdrInpWrapper.PartList();
            objPartListRequest.itemNumber=OSM_Generic_Utility.fieldSizeRestriction(objPartList.itemNumber, 20, 'front');
            objPartListRequest.product =OSM_Generic_Utility.fieldSizeRestriction(objPartList.product, 40, 'front');
            objPartListRequest.description =OSM_Generic_Utility.fieldSizeRestriction(objPartList.description, 20, 'front');
            objPartListRequest.quantity =objPartList.quantity;
            objPartListRequest.unitOfMeasurement =objPartList.unitOfMeasurement;
            objPartListRequest.sellingPrice =objPartList.sellingPrice;
            objPartListRequest.itemCost =objPartList.itemCost;
            objPartListRequest.nonstockType =objPartList.nonstockType;
            objPartListRequest.lineType=objPartList.lineType;
            /*objPartListRequest.attribute01=0;
            objPartListRequest.attribute02='';
            objPartListRequest.attribute03='';*/
            reqObj.dataArea.partList.add(objPartListRequest); 
        }
        System.debug('reqObj____'+reqObj);           
        return reqObj;
        
    }
	
	/*
	public static OSM_WS_SubmitOrderInfo_REQ populateRequestObjectData(OSM_WS_GeneralizedSubmitOrderInputWrap inputWrapperObj){
        // Defining variable whose values will come through custom label(Static)
        String Sender_ID = Label.BMS_SenderID;
        String Target_ID ='BMS';
        String ServiceName='SubmitOrder';
        
        //Intializing request object
        OSM_WS_SubmitOrderInfo_REQ reqObj = new OSM_WS_SubmitOrderInfo_REQ();
        reqObj.Header=new OSM_WS_SubmitOrderInfo_REQ.Header();
        reqObj.Header.Sender=new OSM_WS_SubmitOrderInfo_REQ.Sender();
        reqObj.Header.Target=new OSM_WS_SubmitOrderInfo_REQ.Target();        
        reqObj.DataArea=new OSM_WS_SubmitOrderInfo_REQ.DataArea();
        reqObj.DataArea.FSDList=new List<OSM_WS_SubmitOrderInfo_REQ.FSDList>();
        OSM_WS_SubmitOrderInfo_REQ.FSDList fsdList=new OSM_WS_SubmitOrderInfo_REQ.FSDList();
        reqObj.DataArea.TaxList =new List<OSM_WS_SubmitOrderInfo_REQ.TaxList>();
        OSM_WS_SubmitOrderInfo_REQ.TaxList taxList=new OSM_WS_SubmitOrderInfo_REQ.TaxList();
        reqObj.DataArea.ChargeList=new List<OSM_WS_SubmitOrderInfo_REQ.ChargeList>();
        OSM_WS_SubmitOrderInfo_REQ.ChargeList chargeList=new OSM_WS_SubmitOrderInfo_REQ.ChargeList();
        reqObj.DataArea.R_PARTSLIST_SUBMIT=new List<OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT>();
        OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT partList=new OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT();
        
        reqObj.Header.Sender.ServiceName=ServiceName;
        reqObj.Header.Sender.SenderID=Sender_ID;
        reqObj.Header.Target.TargetID=Target_ID;
        reqObj.DataArea.LocationID=inputWrapperObj.DataArea.LocationID;
        reqObj.DataArea.CustomerCode=inputWrapperObj.DataArea.CustomerCode;
        reqObj.DataArea.Sender=Sender_ID;
        
        // Start : Changes - Juhi - Feb 27 - Addition of Attribute01 field when Refund 
        reqObj.DataArea.Attribute01 = inputWrapperObj.DataArea.Attribute01;
        reqObj.DataArea.Attribute02 = inputWrapperObj.DataArea.Attribute02;
        reqObj.DataArea.Attribute03 = inputWrapperObj.DataArea.Attribute03; 
        // End : Changes - Juhi - Feb 27 - Addition of Attribute01 field when Refund 
        
        for(OSM_WS_GeneralizedSubmitOrderInputWrap.FSDList objFsd:inputWrapperObj.DataArea.FSDList){
            OSM_WS_SubmitOrderInfo_REQ.FSDList objFSDrequest=new OSM_WS_SubmitOrderInfo_REQ.FSDList();
            objFSDrequest.VENDOR=objFsd.VENDOR;
            // Start - Changes Made : Juhi : Jan 15 2019 : Addition of a field Customer Location Code in Account Object to Json Request for Submit Order
            objFSDrequest.CUSTOMER_LOCATION_CODE = OSM_Generic_Utility.fieldSizeRestriction(objFsd.CUSTOMER_LOCATION_CODE, 5, 'front');
            // End - Changes Made : Juhi : Jan 15 2019
            objFSDrequest.SALES_ORDER_ID=objFsd.SALES_ORDER_ID;
            objFSDrequest.ORDER_SOURCE_TYPE=objFsd.ORDER_SOURCE_TYPE;
            objFSDrequest.TAX_DISTRICT=objFsd.TAX_DISTRICT;
            objFSDrequest.PAYMENT_TYPE=objFsd.PAYMENT_TYPE;        
            objFSDrequest.STATUS='';
            objFSDrequest.INVOICE_NUMBER=OSM_Generic_Utility.fieldSizeRestriction(objFsd.INVOICE_NUMBER, 9, 'back');
            objFSDrequest.INVOICE_DATE=objFsd.INVOICE_DATE;
            objFSDrequest.INVOICE_TOTAL=objFsd.INVOICE_TOTAL;
            objFSDrequest.BILL_TO_CUST_NUMBER=objFsd.BILL_TO_CUST_NUMBER;
            objFSDrequest.BILL_TO_NAME=OSM_Generic_Utility.fieldSizeRestriction(objFsd.BILL_TO_NAME, 30, 'front');
            objFSDrequest.SHIP_TO_NAME=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_NAME, 30, 'front');
            objFSDrequest.SHIP_TO_ADDRESS1=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_ADDRESS1, 25, 'front');
            
            // RTC_181176 Start : Mar 11, 2019 - Juhi - Addition of 3 fields for address in Submit Order request
            if(null != objFsd.SHIP_TO_ADDRESS2)
                objFSDrequest.SHIP_TO_ADDRESS2=objFsd.SHIP_TO_ADDRESS2;
            if(null != objFsd.SHIP_TO_ADDRESS3)
                objFSDrequest.SHIP_TO_ADDRESS3=objFsd.SHIP_TO_ADDRESS3;
            if(null != objFsd.SHIP_TO_COUNTRY)
                objFSDrequest.SHIP_TO_COUNTRY=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_COUNTRY, 5, 'front');
            // RTC_181176 End : Mar 11, 2019 - Juhi - Addition of 3 fields for address in Submit Order request
             
            objFSDrequest.SHIP_TO_CITY=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_CITY, 60, 'front');
            objFSDrequest.SHIP_TO_STATE=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_STATE, 25, 'front');
            objFSDrequest.SHIP_TO_POSTAL_CODE=OSM_Generic_Utility.fieldSizeRestriction(objFsd.SHIP_TO_POSTAL_CODE, 10, 'front');
            objFSDrequest.OE_COMMENT=objFsd.OE_COMMENT;
            objFSDrequest.CUSTOMER_PO_NUMBER=OSM_Generic_Utility.fieldSizeRestriction(objFsd.CUSTOMER_PO_NUMBER, 25, 'front');
            objFSDrequest.Attribute01=0;
           objFSDrequest.Attribute02='';
           objFSDrequest.Attribute03='';
           reqObj.DataArea.FSDList.add(objFSDrequest);

        }
      

          for(OSM_WS_GeneralizedSubmitOrderInputWrap.TaxList objTax:inputWrapperObj.DataArea.TaxList){
          OSM_WS_SubmitOrderInfo_REQ.TaxList objTaxRequest=new OSM_WS_SubmitOrderInfo_REQ.TaxList();
          objTaxRequest.TAX_AUTHORITIES=objTax.TAX_AUTHORITIES;
          objTaxRequest.PRINT_GROUP=objTax.PRINT_GROUP;
          objTaxRequest.SALES_CATEGORIES=objTax.SALES_CATEGORIES;
          objTaxRequest.TAX_AMOUNT=objTax.TAX_AMOUNT;
          objTaxRequest.SALE_AMOUNT=objTax.SALE_AMOUNT;
          objTaxRequest.Attribute01=objTax.Attribute01;
          objTaxRequest.Attribute02=objTax.Attribute02;
          objTaxRequest.Attribute03=objTax.Attribute03;     
          reqObj.DataArea.TaxList.add(objTaxRequest);
   
        }
           for(OSM_WS_GeneralizedSubmitOrderInputWrap.ChargeList objCharge:inputWrapperObj.DataArea.ChargeList){
            OSM_WS_SubmitOrderInfo_REQ.ChargeList objChargeRequest=new OSM_WS_SubmitOrderInfo_REQ.ChargeList();
            objChargeRequest.MISC_CHARGE='Discount';
            objChargeRequest.MISC_CHARGE_AMOUNT=ObjCharge.MISC_CHARGE_AMOUNT;
            objChargeRequest.Attribute01=ObjCharge.Attribute01;
            objChargeRequest.Attribute02=ObjCharge.Attribute02;
            reqObj.DataArea.ChargeList.add(objChargeRequest);

        }
          for(OSM_WS_GeneralizedSubmitOrderInputWrap.R_PARTSLIST_SUBMIT objPartList:inputWrapperObj.DataArea.R_PARTSLIST_SUBMIT){
          OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT objPartListRequest=new OSM_WS_SubmitOrderInfo_REQ.R_PARTSLIST_SUBMIT();
            objPartListRequest.ITEM_NUMBER=OSM_Generic_Utility.fieldSizeRestriction(objPartList.ITEM_NUMBER, 20, 'front');
            objPartListRequest.PRODUCT=OSM_Generic_Utility.fieldSizeRestriction(objPartList.PRODUCT, 40, 'front');
            objPartListRequest.DESCRIPTION=OSM_Generic_Utility.fieldSizeRestriction(objPartList.DESCRIPTION, 20, 'front');
            objPartListRequest.QUANTITY=objPartList.QUANTITY;
            objPartListRequest.UOM=objPartList.UOM;
            objPartListRequest.SELLING_PRICE=objPartList.SELLING_PRICE;
            objPartListRequest.ITEM_COST=objPartList.ITEM_COST;
            objPartListRequest.NONSTOCK_TYPE=objPartList.NONSTOCK_TYPE;
            objPartListRequest.LINE_TYPE=objPartList.LINE_TYPE;
            objPartListRequest.Attribute01=0;
            objPartListRequest.Attribute02='';
            objPartListRequest.Attribute03='';
            reqObj.DataArea.R_PARTSLIST_SUBMIT.add(objPartListRequest); 
        }
        System.debug('reqObj____'+reqObj);           
        return reqObj;        
    }
	*/
}