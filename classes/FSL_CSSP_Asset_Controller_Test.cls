@isTest
public class FSL_CSSP_Asset_Controller_Test {
    public static testMethod void testAssetController() {

        WorkOrder objWorkOrder = new WorkOrder();
        //objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Application__c = '130 - AUTOMOTIVE';
        //objWorkOrder.AccountId = objAccount.Id;
        //objWorkOrder.WorkTypeId = objWorkType.Id;
        //objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
        
        FSL_Coverage_Details__c fCoverageDetail = new FSL_Coverage_Details__c();
        Insert fCoverageDetail;
        
        Fsl_Certificate_Details__c fCertificateDetail = new Fsl_Certificate_Details__c();
        Insert fCertificateDetail;
        
        //FSL_CSSP_Asset_Controller assetController = new FSL_CSSP_Asset_Controller();
        FSL_CSSP_Asset_Controller.getAssetId(objWorkOrder.Id);
        FSL_CSSP_Asset_Controller.fetchCoverages(fCoverageDetail.Id);
        FSL_CSSP_Asset_Controller.fetchCertificates(fCertificateDetail.Id);
    }
}