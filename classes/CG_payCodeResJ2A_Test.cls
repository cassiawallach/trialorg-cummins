@isTest
public class CG_payCodeResJ2A_Test {
    static testmethod void CG_payCodeResJ2ATest() {
       
       // string json='{CG_payCodeResJ2A:{"PAYCODEDESCRIPTION":"PAYCODEDESCRIPTION","PAYCODE":"PAYCODE"}}';   
       // string json='{ "CG_payCodeResJ2A": [ { "PAYCODEDESCRIPTION": "PAYCODEDESCRIPTION", "PAYCODE": "PAYCODE" }, { "PAYCODEDESCRIPTION": "PAYCODEDESCRIPTION", "PAYCODE": "PAYCODE" } ] }';
        string json ='[{ "CG_payCodeResJ2A": { "PAYCODEDESCRIPTION": "PAYCODEDESCRIPTION", "PAYCODE": "PAYCODE" } }]';
        CG_payCodeResJ2A.parse(json);

    }

}