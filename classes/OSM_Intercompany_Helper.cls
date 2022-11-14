/******
Name:  OSM_Intercompany_Helper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Mehta       19/12/2018     INITIAL DEVELOPMENT 
*******/
public class OSM_Intercompany_Helper{
     public static OSM_Intercompany_REQ populateRequestObjectData(OSM_Intercompany_Generalized_REQ inputWrapperObj){
       String Sender_ID =Label.BMS_SenderID;
        String Target_ID ='BMS';
        String ServiceName='IntercompanyRequest';
       //Intializing request object
        OSM_Intercompany_REQ reqObj = new OSM_Intercompany_REQ();
        reqObj.Header=new OSM_Intercompany_REQ.Header();
        reqObj.Header.Sender=new OSM_Intercompany_REQ.Sender();
        reqObj.Header.Target=new OSM_Intercompany_REQ.Target();        
        reqObj.DataArea=new OSM_Intercompany_REQ.DataArea();
        reqObj.CInvoice_Header=new List<OSM_Intercompany_REQ.CInvoice_Header>();
        reqObj.ChargeList=new List<OSM_Intercompany_REQ.ChargeList>();
        reqObj.R_PARTSLIST_SUBMIT=new List<OSM_Intercompany_REQ.R_PARTSLIST_SUBMIT>();
        OSM_Intercompany_REQ.CInvoice_Header CInvoice_Header=new OSM_Intercompany_REQ.CInvoice_Header();
        reqObj.Header.Sender.ServiceName=ServiceName;
        reqObj.Header.Sender.SenderID=Sender_ID;
        reqObj.Header.Target.TargetID=Target_ID;
        reqObj.DataArea.LocationID=inputWrapperObj.DataArea.LocationID;
        reqObj.DataArea.CustomerCode=inputWrapperObj.DataArea.CustomerCode;
        reqObj.DataArea.Attribute01=0;
        reqObj.DataArea.Attribute02='';
        reqObj.DataArea.Attribute03='';
        //reqObj.DataArea.Sender=Sender_ID;
        for(OSM_Intercompany_Generalized_REQ.CInvoice_Header objInvoice:inputWrapperObj.CInvoice_Header){
            OSM_Intercompany_REQ.CInvoice_Header objInvoiceRequest=new OSM_Intercompany_REQ.CInvoice_Header();
            objInvoiceRequest.BMS_OE_REFERENCE=objInvoice.BMS_OE_REFERENCE;
            objInvoiceRequest.BRANCH_LOCATION=objInvoice.BRANCH_LOCATION;
            objInvoiceRequest.BMS_INVOICE_NUMBER=objInvoice.BMS_INVOICE_NUMBER;
            objInvoiceRequest.BMS_PO_NUMBER=objInvoice.BMS_PO_NUMBER;
            objInvoiceRequest.ORDER_SOURCE_TYPE=objInvoice.ORDER_SOURCE_TYPE;
            objInvoiceRequest.ICInvoice_Number=OSM_Generic_Utility.fieldSizeRestriction(objInvoice.ICInvoice_Number, 9, 'back');
            objInvoiceRequest.ICInvoice_Date = objInvoice.ICInvoice_Date;
            objInvoiceRequest.Attribute01=0;
            objInvoiceRequest.Attribute02='';
            objInvoiceRequest.Attribute03='';
            objInvoiceRequest.PO_Vendor=objInvoice.PO_Vendor;
            objInvoiceRequest.INVOICE_TOTAL=objInvoice.INVOICE_TOTAL;
            objInvoiceRequest.CREDIT_MEMO=objInvoice.CREDIT_MEMO;
            reqObj.CInvoice_Header.add(objInvoiceRequest);
            }
            for(OSM_Intercompany_Generalized_REQ.ChargeList objInvoiceCharge:inputWrapperObj.ChargeList){
            OSM_Intercompany_REQ.ChargeList objInvoiceRequest=new OSM_Intercompany_REQ.ChargeList();
            objInvoiceRequest.MISC_CHARGE_AMOUNT=objInvoiceCharge.MISC_CHARGE_AMOUNT;
            objInvoiceRequest.MISC_CHARGE=objInvoiceCharge.MISC_CHARGE;
            objInvoiceRequest.Attribute02=objInvoiceCharge.Attribute02;
            objInvoiceRequest.Attribute01=objInvoiceCharge.Attribute01;
            reqObj.ChargeList.add(objInvoiceRequest);
            }
            for(OSM_Intercompany_Generalized_REQ.R_PARTSLIST_SUBMIT objInvoiceParts:inputWrapperObj.R_PARTSLIST_SUBMIT){
            OSM_Intercompany_REQ.R_PARTSLIST_SUBMIT objInvoiceRequest=new OSM_Intercompany_REQ.R_PARTSLIST_SUBMIT();
            objInvoiceRequest.NONSTOCK_TYPE=objInvoiceParts.NONSTOCK_TYPE;
            objInvoiceRequest.LINE_TYPE=objInvoiceParts.LINE_TYPE;
            objInvoiceRequest.Attribute01=objInvoiceParts.Attribute01;
            objInvoiceRequest.Attribute02=objInvoiceParts.Attribute02;
            objInvoiceRequest.Attribute03=objInvoiceParts.Attribute03;
            objInvoiceRequest.CUSTOMER_PO_NUMBER=objInvoiceParts.CUSTOMER_PO_NUMBER;
            objInvoiceRequest.ITEM_COST=objInvoiceParts.ITEM_COST;
            objInvoiceRequest.SELLING_PRICE=objInvoiceParts.SELLING_PRICE;
            objInvoiceRequest.UOM=objInvoiceParts.UOM;
            objInvoiceRequest.QUANTITY=objInvoiceParts.QUANTITY;
            objInvoiceRequest.DESCRIPTION=objInvoiceParts.DESCRIPTION;
            objInvoiceRequest.ITEM_NUMBER=objInvoiceParts.ITEM_NUMBER;
            objInvoiceRequest.product=objInvoiceParts.product;
            reqObj.R_PARTSLIST_SUBMIT.add(objInvoiceRequest);
            }
     return reqObj;
     }
}