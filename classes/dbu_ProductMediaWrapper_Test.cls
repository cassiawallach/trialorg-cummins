@isTest
public class dbu_ProductMediaWrapper_Test {
        public static testMethod void testAddress() {
            dbu_ProductMediaWrapper wrapperData = new dbu_ProductMediaWrapper();
            wrapperData.enabled = true;
            wrapperData.endDate = null;
            wrapperData.EProductMediasS = 'media link';
            wrapperData.locale = 'en-US';
            wrapperData.mediaType ='product';
            wrapperData.product='';
            wrapperData.productMediaSource='';
            wrapperData.sequence=3;
            wrapperData.sfdcCurrencyISOCode='USD';
            wrapperData.startDate = null;
            wrapperData.URI=null;
        }
    
}