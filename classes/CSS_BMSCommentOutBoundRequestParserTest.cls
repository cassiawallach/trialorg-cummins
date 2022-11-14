@IsTest
public class CSS_BMSCommentOutBoundRequestParserTest {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSComments\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"CSS-00001234\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"OrderSourceType\": \"WO/WOQT\",'+
		'		\"CommentType\": \"COVERAGE\",'+
		'		\"ServiceComment\": \"MW to merge the SERVICE_COMMENT if there are multiple line items in the order of serv_comment_seq_no\",'+
		'		\"CreateUser\": \"WWID\",'+
		'		\"CreateDate\": \"Date\",'+
		'		\"ChangeUser\": \"WWID\",'+
		'		\"ChangeDate\": \"Date\"'+
		'	}'+
		'}';
		CSS_BMSCommentOutBoundRequestParser obj = CSS_BMSCommentOutBoundRequestParser.parse(json);
		System.assert(obj != null);
	}
}