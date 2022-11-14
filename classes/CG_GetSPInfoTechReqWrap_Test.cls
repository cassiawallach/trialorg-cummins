@isTest
public class CG_GetSPInfoTechReqWrap_Test {
static testMethod void CG_GetSPInfoTechReqWrapper() {
 string json =' {"Header": {"Target": {"TargetID": "SIEBEL"},"Sender": {"ServiceName": "GetSPInfo","SenderID": "CSS"}},"DataArea": {"LAST_PROCESSED_DATE": "2018-07-24"}}';
  CG_GetSPInfoTechReqWrap obj = CG_GetSPInfoTechReqWrap.parse(json);
		System.assert(obj != null);
	}
}