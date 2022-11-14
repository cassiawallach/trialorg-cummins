@isTest
public class CSS_BMS_SRTReq_Test {
    static testMethod void testBMSSRT() {
        CSS_BMS_SRTReq x = new CSS_BMS_SRTReq();
        CSS_BMS_SRTReq.Header hdr = new CSS_BMS_SRTReq.Header();

        CSS_BMS_SRTReq.Sender snd = new CSS_BMS_SRTReq.Sender();
        snd.SenderID = 'CSS';
        snd.ServiceName = 'SRT';

        hdr.Sender = snd;

        CSS_BMS_SRTReq.Target tgt = new CSS_BMS_SRTReq.Target();
        tgt.TargetID = 'abc';
        hdr.Target = tgt;

        CSS_BMS_SRTReq.Location lct = new CSS_BMS_SRTReq.Location();
        lct.LocationID = '0037-4745';
        hdr.Location = lct;

        x.Header = hdr;

        CSS_BMS_SRTReq.DataArea dt2 = new CSS_BMS_SRTReq.DataArea();

        dt2.CSSJobID = 'CSS-000';
        dt2.Location = '000';
        dt2.OrderType = 'as';
        dt2.ShopWOnumber = 'aa';
        dt2.Accesscode = 'aaa';
        dt2.Model = 'snan';
        dt2.SRTgroupnum = 'sss';
        dt2.Procedureno = 'sfg';
        dt2.Stepnumber = 'tfds';
        dt2.SRTquantity = 'yufyugf';
        dt2.Bill = 'ftf';
        dt2.SRTTime = 'hjghg';
        dt2.ServiceModelName = 'SMN TEST 12345';
        dt2.Note = 'TestNotes';
        dt2.WarrantyAllocation = 'TestAllocation';
        dt2.AccountCode = 'TestAccountCode';
        dt2.ClaimType = 'TestClaimType';
        dt2.CreateUser = 'TestCreateUser';
        dt2.ChangeUser = 'TestChangeUser';


        String json = '{"Header":{"Target":{"TargetID":"SRT"},"Status":"200","Sender":{"ServiceName":"GetOverlapSRT","SenderID":"CSS"},"ReturnCodeDescription":"002","Location":{"LocationID":"t00"}},"DataArea":[{"VIN":"test","UnitNumber":"test","UnitDescription":"test","State":"test","ServiceModelName":"test","Postalcode2":"test","Postalcode1":"test","PhoneNumber":null,"PaymentType":"test","Model":"test","Make":"test","LocationAddressline3":"test","LocationAddressline2":"test","LocationAddressline1":"test","ESN":"test","EngineFamily":"test","CustomerName":"test","CustomerCode":"test","Country":"test","City":"test","AreaCode":"test","ApplicationCode":"test"}]}';
        CSS_BMS_SRTReq obj = CSS_BMS_SRTReq.parse(json);

        obj.DataArea.add(dt2);


    }

}