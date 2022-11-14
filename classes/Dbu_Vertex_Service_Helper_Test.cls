@isTest
public class Dbu_Vertex_Service_Helper_Test {

    
    static testmethod void testparse(){
         // dbu_Vertex_GeneralizedInputWrapper objGeneralInputWrp ;
        list<dbu_Vertex_GeneralizedInputWrapper.ProductList> prodlst = new list<dbu_Vertex_GeneralizedInputWrapper.ProductList>();
        
        dbu_Vertex_GeneralizedInputWrapper.ProductList ProductList = new dbu_Vertex_GeneralizedInputWrapper.ProductList();
        ProductList.BC='';
        ProductList.CustomerName='';
        ProductList.DiscountAmount='';
        ProductList.DiscountPercentage='';
        ProductList.ExtendedPrice='';
        ProductList.LineItemNumber='';
        ProductList.ProductClassCode='';
        ProductList.ProductCode='';
        ProductList.Quantity='';
        ProductList.RC='';
        ProductList.UnitOfMeasure='';
        prodlst.add(ProductList);
        
        dbu_Vertex_GeneralizedInputWrapper.Administrive_Destination Administrive_Destination = new dbu_Vertex_GeneralizedInputWrapper.Administrive_Destination();
        Administrive_Destination.AddressLine1='';
        Administrive_Destination.AddressLine2='';
        Administrive_Destination.City='';
        Administrive_Destination.Country='';
        Administrive_Destination.Postal_Code='';
        Administrive_Destination.State='';
        

        
        dbu_Vertex_GeneralizedInputWrapper.Physical_Origin Physical_Origin = new dbu_Vertex_GeneralizedInputWrapper.Physical_Origin();
        Physical_Origin.AddressLine1='';
        Physical_Origin.AddressLine2='';
        Physical_Origin.City='';
        Physical_Origin.Country='';
        Physical_Origin.Postal_Code='';
        Physical_Origin.State='';
        
         dbu_Vertex_GeneralizedInputWrapper.Seller Seller = new dbu_Vertex_GeneralizedInputWrapper.Seller();
        Seller.Company_Code='';
        Seller.Division_Code='';
        Seller.Physical_Origin=Physical_Origin;
        Seller.AdministrativeOrigin =Physical_Origin;
        
        dbu_Vertex_GeneralizedInputWrapper.Customer Customer= new dbu_Vertex_GeneralizedInputWrapper.Customer();
        Customer.Customer_Code='';
        Customer.Administrive_Destination =Administrive_Destination;
        Customer.Destination_Addesss=Physical_Origin;
        
                
        dbu_Vertex_GeneralizedInputWrapper.DataArea DataArea = new dbu_Vertex_GeneralizedInputWrapper.DataArea();
        DataArea.Customer=Customer;
        DataArea.DiscountAmount='';
        DataArea.ProductList=prodlst;
        DataArea.Seller=Seller;
        
        dbu_Vertex_GeneralizedInputWrapper objGeneralInputWrp = new dbu_Vertex_GeneralizedInputWrapper();
        objGeneralInputWrp.isForQuote=true;
        objGeneralInputWrp.isRefundInvoiceReq=true;
        objGeneralInputWrp.orderPlacementDate='';
        objGeneralInputWrp.recordId='';
        objGeneralInputWrp.QuotationRequestDocumentNumber='';
        objGeneralInputWrp.InvoiceRequestDocumentNumber='';
        objGeneralInputWrp.DataArea=DataArea;
        Dbu_Vertex_Service_Helper obj =new Dbu_Vertex_Service_Helper();
     
        //= dbu_Vertex_GeneralizedoutputWrapper;
        Dbu_Vertex_Service_Helper.populateDynamicData(objGeneralInputWrp);
       // dbu_Vertex_GeneralizedoutputWrapper inputparam;
        
       // obj.populateDynamicData(inputparam);
    }
}
//UAT Deployment