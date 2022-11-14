@istest
public class OSM_Intercompany_Helper_Test {

    static testMethod void testMethod1(){
         string json = '{"Header": {"Sender": {"ServiceName":"test","SenderID":"test"},"Target": {"TargetID":"test"} }}';
         OSM_Intercompany_Generalized_REQ req = OSM_Intercompany_Generalized_REQ.parse(json);
     }
}