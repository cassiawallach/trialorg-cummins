@isTest
public class CG_GetSPTechServModreqwrap_Test {
static testMethod void CG_GetSPTechServModreqwrapmethod1() {
 string json =' {"Header": {"Target": {"TargetID": "SIEBEL"},"Sender": {"ServiceName": "GetSPInfo","SenderID": "CSS"}},"DataArea": {"LAST_PROCESSED_DATE": "2018-07-24"}}';
  CG_GetSPTechServModreqwrap obj = CG_GetSPTechServModreqwrap.parse(json);
		System.assert(obj != null);
	}
}