/**********************************************************************
Name:  OSM_SW_ProdDetail_Ctrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to render DA/SES page                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Vineet            3/12/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_ProdDetail_Ctrl {
	
global static String isDAorSES {get;set;}

/*----------------------------------------------------------------------------------
1. Constructor check for product based on sku & send string as DA/SES

------------------------------------------------------------------------------------*/

public OSM_SW_ProdDetail_Ctrl()
{
    Map<String,String> paramLst = Apexpages.currentPage().getParameters();
    for(String str : paramLst.keyset())
    {
        System.debug('=====key===='+str);
        System.debug('=====value.paramLst'+paramLst.get(str));
    }
      String sku =  Apexpages.currentPage().getParameters().get('sku');
      system.debug('sku=====>'+sku);
       ccrz__E_Product__c eProd = OSM_SW_ProdDetailUtils_Ctrl.getEProduct(sku)[0];
       isDAorSES = eProd.Group_Name__c;
    }
    
}