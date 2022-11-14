/*
 * Block comments with details of changes
 */
public class CSS_GetServiceProviderRequest {
	public Header Header;
	public DataArea DataArea;
	public class Sender {
		public String MessageID;
		public String ServiceName;
		public String SenderID;
	}

	public class DataArea {
		public String SPCode;
		public String ServiceModelName;
		public String FailureDate;
	}

	public class Header {
		public Sender Sender;
		public String Target;
	}

	public static CSS_GetServiceProviderRequest parse(String json) {
		return (CSS_GetServiceProviderRequest) System.JSON.deserialize(json, CSS_GetServiceProviderRequest.class);
	}
}