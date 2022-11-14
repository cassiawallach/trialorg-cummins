//Added for code coverage 
@istest
public class FSL_CL_SOWrapper_Test {
    public static testmethod void method1(){
  
        String json = '{"Header":{"Sender":{"ServiceName":"PMWO","SenderID":"BMS"},"Target":"CSS","LocationCode":"02850-02651"},"DataArea":[{"ERPWorkOrder":"ztest","CustomerCode":"0001","PaymentType":"test","Prepaid":"0997899","SiteId":"909899000","SiteLocation":"test","SiteRating":"test","SiteContactId":"688886867","ERPContractNumber":"878788787","Type":"test","PSN":"test","Complaint":"test","SupervisorFirstName":"test","SupervisorLastName":"test","Cause":"","Correction":"","ScheduledDate":"","PromisedDate":"","TransactionType":"","ServiceType":"","SubType":"test","StandardService":"test","NumberOfTechnicians":"test","PreferredTechnician":"test","StatusNotes":"test","EngineFamily":"test","ServiceModelName":"tewedt","UnitNumber":"123","Parts":[{"PartLineNumber":"898493","PartLineType":"PM","PartNumber":"32798404","ProductCode":"32798404","PartDescription":"Test Part1 Description","PartLocation":"IND","PartQuantityOrdered":"3","PartQuantityUsed":"2","EPRFlag":"true"}],"EPRFlag":"","WorkOrderNotes":"","TotalDuration":"","SRTs":[{"SRTGroup":"Group1","SRTProcedure":"Procedure1","PartNumber":"32798404","SRTDescription":"SRT1 Description","SRTTime":"0.6","SRTQuantity":"2","TotalDuration":"10"}],"InvoiceDate":"10/10/2021","TaskGroup":"TaskGroup","LaborMultiplier":"LaborMultiplier"}]}';
        FSL_CL_SOWrapper obj = FSL_CL_SOWrapper.parse(json);
      /*  FSL_CL_SOWrapper Sow = new FSL_CL_SOWrapper.parse();
        FSL_CL_SOWrapper.Header h = new FSL_CL_SOWrapper.Header();
        FSL_CL_SOWrapper.DataArea d = new FSL_CL_SOWrapper.DataArea();
        FSL_CL_SOWrapper.Sender s = new FSL_CL_SOWrapper.Sender();
        FSL_CL_SOWrapper.SRTs sr = new FSL_CL_SOWrapper.SRTs();
        FSL_CL_SOWrapper.Parts p = new FSL_CL_SOWrapper.Parts();
        FSL_CL_SOWrapper.FSL_CL_PMOrderwraperResult PM = new FSL_CL_SOWrapper.FSL_CL_PMOrderwraperResult();
        */
        
        
    }
}