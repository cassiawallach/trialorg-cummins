@isTest(seealldata = false)
public class CG_CL_CustomerROCompClass_Test {
    
    static testmethod void testmethod_1() {
        CG_CL_IntakeRJ obj1 = new CG_CL_IntakeRJ();
        CG_CL_CustomerROCompClass obj = new CG_CL_CustomerROCompClass();
        obj.mainContrRJ = obj1;
        obj.nvIntakeCustomer();
        obj.PageName = 'test';
        Date dt_shopIn = system.today();
        string locale_formatted_date_time_value = 'dd MMM YYYY';
        obj.getDtShopIn();
        obj.getDtCreated();
    } 
}