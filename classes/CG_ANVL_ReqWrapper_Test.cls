@isTest
public class CG_ANVL_ReqWrapper_Test {
    static testMethod void testParse() {
         String json = '{"transactionId":"CSSTEST - 20181110123750","workOrders":[{"id":"CSS-00021420","location":"04892 - Cummins NPower","description":"Leak - COMPRESSION LEAK","serial":"79855048","model":"ISX15 CM2350 X101","category":"130 - AUTOMOTIVE","type":"In Shop","customer":{"name":"CUMMINS POWER SOUTH","id":"12345"},"assigned":["AB123","CD456"],"createdAt":"2018-05-10T10:25:22.210Z","updatedAt":"2018-05-10T10:25:22.210Z"}]}';
        CG_ANVL_ReqWrapper obj = CG_ANVL_ReqWrapper.parse(json);
       System.assert(obj != null);
    }
}