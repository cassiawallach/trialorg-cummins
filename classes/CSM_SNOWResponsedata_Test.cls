@IsTest(SeeAllData=false)
public class CSM_SNOWResponsedata_Test {
	
	public static testMethod void testParse() {
        
    /* String json = '{'+
                '  \"result\": {'+
                '    \"IncidentNumber\": \"INC3558822\",'+
                '    \"Priority\": \"3\",'+
                '    \"Customer\": \"Email User\",'+
                '    \"CustomerWWID\": \"email.user\",'+
                '    \"ShortDescription\": \"Qapla. Dah tlhingan hol mu ghom a dalegh\",'+
                '    \"Category\": \"Application\",'+
                '    \"SubCategory\": \"Repair/Fix\",'+
                '    \"ConfigurationItem\": \"P360-Enterprise Product Data Hub\",'+
                '    \"State\": \"Closed\",'+
                '    \"AssignmentGroup\": \"Common Services - Data Services - MDM Application Support\",'+
                '    \"AssignedTo\": \"Kowsalya R\",'+
                '    \"AssignedToWWID\": \"sy674\",'+
                '    \"IncidentSysID\": \"7816687f1b41c550f1d9ed77624bcba3\",'+
                '    \"Thirdparty\": \"\",'+
                '    \"TicketNumber\": \"\",'+
                '    \"TicketURL\": \"\",'+
                '    \"URL\": \"https://cumminsdev.service-now.com/incident.do?sys_id=7816687f1b41c550f1d9ed77624bcba3\"'+
                '  }'+
                '}';
*/
        String json='{\"result\":{\"IncidentNumber\":\"INC3562892\",\"Priority\":\"2\",\"Customer\":\"ChevalierSpann\",\"CustomerWWID\":\"is519\",\"ShortDescription\":\"Qapla.Dahtlhinganholmughomadalegh\",\"Category\":\"Application\",\"SubCategory\":\"Repair/Fix\",\"ConfigurationItem\":\"CPGERP\",\"State\":\"Closed\",\"AssignmentGroup\":\"SupplyChainManagement-OracleAppsSupport-PSBU\",\"AssignedTo\":\"MohammadFaizanAmini\",\"AssignedToWWID\":\"mz433\",\"IncidentSysID\":\"4f4417b31b014550ba3bcb36624bcb8c\",\"Thirdparty\":\"\",\"TicketNumber\":\"\",\"TicketURL\":\"\",\"URL\":\"\"}}';
		CSM_SNOWResponsedata obj = CSM_SNOWResponsedata.parse(json);
		System.assert(obj != null);
	}
   //this comments use for deployment purpose.Apex class use for Production deployment only
}