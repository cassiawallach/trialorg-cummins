@isTest
public class CG_NonPrioritizedFCCont_Test
{
    static testMethod void CG_NonPrioritizedFCCont_Test()
    {
        
       CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
    

        String JobID = ApexPages.CurrentPage().getParameters().put('id',JO.Id);
        CG_NonPrioritizedFCCont nonPri = new CG_NonPrioritizedFCCont();
    }
}