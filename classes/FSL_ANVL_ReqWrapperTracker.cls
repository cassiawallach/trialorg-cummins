/*
* CT3-198: Test class for class FSL_ANVL_ReqWrapper .
* @Author: Dinesh Yadav, Created Date: 26 Nov 2020.
*/
@isTest
public class FSL_ANVL_ReqWrapperTracker {
     static testMethod void testParse(){
        String json = '{"Header":{"Target":{"TargetID":"ANVL"},"Sender":{"SenderID":"CSS"}},"DataArea":{"workOrders":[{"updatedAt":"2020-12-03T10:41:10.0500Z","type":"In Shop","serial":"79661008","model":"ISX15 CM2350 X101","location":"04977-I - GULF - San Antonio - In Shop","id":"00004337","description":"","customer":{"name":"Guidanz_CustomerTest","id":"1"},"createdAt":"2020-12-03T10:37:08.0500Z","category":"testing.... - 130 - AUTOMOTIVE","assigned":["ms448"]}],"transactionId":"GZEVLDEV-2020123381012649"}}';
        FSL_ANVL_ReqWrapper obj = FSL_ANVL_ReqWrapper.parse(json);
        System.assert(obj != null);
    }
}