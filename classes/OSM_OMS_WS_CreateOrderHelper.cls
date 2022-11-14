public class OSM_OMS_WS_CreateOrderHelper 
{
    public static OSM_OMS_WS_CreateOrderReq populateRequestObjectDataForCreateOrder(OSM_OMS_CreateOrderGeneral_IP_Wrapper generalizedInputWrapper)
    {
        OSM_OMS_WS_CreateOrderReq createOrderReq = new OSM_OMS_WS_CreateOrderReq();
        
        createOrderReq.Header = new OSM_OMS_WS_CreateOrderReq.Header();
        
        createOrderReq.Header.Sender = new OSM_OMS_WS_CreateOrderReq.Sender();
        createOrderReq.Header.Sender.ServiceName = 'CreateOrder';
        createOrderReq.Header.Sender.SenderID = 'Mrktplc';
        
        createOrderReq.Header.Target = new OSM_OMS_WS_CreateOrderReq.Target();
        createOrderReq.Header.Target.TargetID = 'OMS';
        
        createOrderReq.Header.Message = new OSM_OMS_WS_CreateOrderReq.Message();
        createOrderReq.Header.Message.MessageID = generalizedInputWrapper.orderName;
        createOrderReq.Header.Message.Timestamp = generalizedInputWrapper.timestamp;
        
        createOrderReq.CreateOrderInput = new OSM_OMS_WS_CreateOrderReq.CreateOrderInput();
        createOrderReq.CreateOrderInput.ToolName = 'INSITE';
        createOrderReq.CreateOrderInput.RequesterId = OSM_Generic_Utility.truncateRequesterId(generalizedInputWrapper.requesterId); //OSM_Generic_Utility.truncateRequesterId added by Pooja story 1054
            
        createOrderReq.CreateOrderInput.LicenseInfoList = new OSM_OMS_WS_CreateOrderReq.LicenseInfoList();
        createOrderReq.CreateOrderInput.LicenseInfoList.LicenseInfo = new List<OSM_OMS_WS_CreateOrderReq.LicenseInfo>();
        
        for(OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails orderItemDetails : generalizedInputWrapper.orderItemDetailsList)
        {
            OSM_OMS_WS_CreateOrderReq.LicenseInfo licenseInfo = new OSM_OMS_WS_CreateOrderReq.LicenseInfo();
            licenseInfo.AdminId = orderItemDetails.adminId;
            licenseInfo.LicenseName = orderItemDetails.licenseName;
            licenseInfo.TotalCopies = orderItemDetails.totalCopies;
            licenseInfo.CountsPerCopy = orderItemDetails.countsPerCopy;
            licenseInfo.Duration = orderItemDetails.duration;
            licenseInfo.StartDate = orderItemDetails.startDate;
            
            licenseInfo.LicAttributes = new OSM_OMS_WS_CreateOrderReq.LicAttributes();
            licenseInfo.LicAttributes.Features = new OSM_OMS_WS_CreateOrderReq.Features();
            licenseInfo.LicAttributes.Features.Feature = orderItemDetails.feature;
            
            licenseInfo.LicAttributes.FeatureGroups = new OSM_OMS_WS_CreateOrderReq.FeatureGroups();
            licenseInfo.LicAttributes.FeatureGroups.FeatureGroup = orderItemDetails.featureGroup;
            
            licenseInfo.LicAttributes.Products = new OSM_OMS_WS_CreateOrderReq.Products();
             //start  Mar-1220
            String tempName;
             for(String str : Label.OSM_Special_Char.split(',')){
              if(orderItemDetails.productName.contains(str))
                  {
                      tempName=orderItemDetails.productName.replace(str,'');
                  }
             }
             if(tempName != '' && tempName != null)
                 licenseInfo.LicAttributes.Products.Product = tempName;
             else
                 licenseInfo.LicAttributes.Products.Product = orderItemDetails.productName;
           /* if(orderItemDetails.productName.contains('INSITE™')) { String tempName=orderItemDetails.productName.replace('INSITE™','INSITE');
             licenseInfo.LicAttributes.Products.Product = tempName; }
            else 
             licenseInfo.LicAttributes.Products.Product = orderItemDetails.productName; */
             // end Mar-1220
            licenseInfo.LicAttributes.ProductGroups = new List<OSM_OMS_WS_CreateOrderReq.ProductGroups>();
            
            System.debug('Product Groups : ' + orderItemDetails.productGroup);
            
            OSM_OMS_WS_CreateOrderReq.ProductGroups productGroups = new OSM_OMS_WS_CreateOrderReq.ProductGroups();
            productGroups.ProductGroup = new List<String>();
            
            if(orderItemDetails.productGroup == 'LD MR HD HHP Komatsu')
            {
                productGroups.ProductGroup.add('LD');
                productGroups.ProductGroup.add('MR');
                productGroups.ProductGroup.add('HD');
                productGroups.ProductGroup.add('HHP');
                productGroups.ProductGroup.add('Komatsu');
            }
            else if(orderItemDetails.productGroup == 'SIR,RMI')
            {
                productGroups.ProductGroup.add('SIR');
                productGroups.ProductGroup.add('RMI');
            }
            else
            {
                productGroups.ProductGroup.add(orderItemDetails.productGroup);
            }
            
            licenseInfo.LicAttributes.ProductGroups.add(productGroups);
            
            licenseInfo.LicPolicy = new OSM_OMS_WS_CreateOrderReq.LicPolicy();
            licenseInfo.LicPolicy.NumberOfRehosts =Label.NumberOfRehosts;
            licenseInfo.LicPolicy.NumberOfRepairs = Label.NumberOfRepairs;
            licenseInfo.LicPolicy.NumberOfReinstalls = orderItemDetails.numberOfReinstalls;
            
            if('Basic' == orderItemDetails.featureGroup)
            {
                licenseInfo.LicPolicy.RevalidationPeriod = Label.RevalidationPeriodBasic;
            }
            else
            {
                licenseInfo.LicPolicy.RevalidationPeriod = Label.RevalidationPeriod;
            }
            
            createOrderReq.CreateOrderInput.LicenseInfoList.LicenseInfo.add(licenseInfo);
            
        } 
        
        return createOrderReq;
    }
}