@isTest
public class dbu_Vertex_GeneralizedoutputWrapper_Test {

    static testmethod void testparse(){
        list<dbu_Vertex_GeneralizedoutputWrapper.Taxes> taxlst = new list<dbu_Vertex_GeneralizedoutputWrapper.Taxes>();
        
        dbu_Vertex_GeneralizedoutputWrapper.Taxes tax = new dbu_Vertex_GeneralizedoutputWrapper.Taxes();
        tax.CalculatedTax='213';
        tax.EffectiveRate='211';
        tax.impositionId='111';
        tax.impositionTypeId='31edwdqw';
        tax.ImpositionTypevalue='1212wqsq';
        tax.impositionValue='21112';
        tax.isService='y';
        tax.jurisdictionId='678767ihuiiy733';
        tax.jurisdictionLevel='w21121';
        tax.JurisdictionValue='111';
        tax.NonTaxable='230';
        tax.reasonCode='231';
        tax.situs='7890';
        tax.Taxable='0873';
        tax.taxCollectedFromParty='213';
        tax.taxResult='444';
        tax.TaxRuleId='3232e';
        tax.taxStructure='dfe';
        tax.taxType='eqaul';
        taxlst.add(tax); 
        
        list< dbu_Vertex_GeneralizedoutputWrapper.ProductList> ProductList = new list<dbu_Vertex_GeneralizedoutputWrapper.ProductList>();
        
        dbu_Vertex_GeneralizedoutputWrapper.ProductList product = new dbu_Vertex_GeneralizedoutputWrapper.ProductList();
        product.LineItemNumber=2;
        product.LineItemTotalTax=2.90;
        product.Product='gasket';
        product.ProductClassCode='32980';
        product.ProductCode='32980'; 
        product.Taxes=taxlst;
        ProductList.add(product);
        
        dbu_Vertex_GeneralizedoutputWrapper.Transaction_Z Transaction_Z = new dbu_Vertex_GeneralizedoutputWrapper.Transaction_Z();
        Transaction_Z.TransactionID='100000uyd839dbws8uh98wcuwe';
       
        dbu_Vertex_GeneralizedoutputWrapper.DataArea DataArea = new dbu_Vertex_GeneralizedoutputWrapper.DataArea();
        DataArea.ProductList=ProductList;
        DataArea.TotalTax=22.89;
        
        dbu_Vertex_GeneralizedoutputWrapper.Header Header = new dbu_Vertex_GeneralizedoutputWrapper.Header();
        Header.Transaction_Z =Transaction_Z;
        
        dbu_Vertex_GeneralizedoutputWrapper obj = new dbu_Vertex_GeneralizedoutputWrapper();
        obj.errorMsg='Unable';
        obj.DataArea= DataArea;
        obj.Header = Header;
        
    }
}
//UAT Deployment