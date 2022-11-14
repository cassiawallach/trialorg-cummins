@istest
public class FSL_LaborMultiplierController_Test {
    @istest
    Public static void testLaborMultiplierCreation(){
        FSL_Labor_Multiplier__c laborMultiplier = new FSL_Labor_Multiplier__c();
        laborMultiplier.Description__c = 'HD IND. (AG, CONST, FORESTRY, FIRE) 11-15 L, PG 251-999 KW, PG RENTALS 0-999 KW, MIXED ACCESS SITES';
        laborMultiplier.Multiplier_Values__c = 1.08;
        try{
            if(laborMultiplier != null) insert laborMultiplier;
        }catch(exception Ex){
            system.debug('exception'+Ex.getMessage());
        }
        FSL_LaborMultiplierController.getLaborMultiplierDetails(); 
    }
}