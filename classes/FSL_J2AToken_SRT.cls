/**********************************************************************
Name: FSL_WO_Comment_Inbound_Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: Test class for FSL_WO_Comment_Inbound class
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0       Harsha            19-Feb-2020   INITIAL DEVELOPMENT  
***********************************************************************/
public class FSL_J2AToken_SRT {
    
    public String access_token;
	public String token_type;
	public Integer expires_in;
	public String refresh_token;
	public String scope;
  
	public static FSL_J2AToken_SRT parse(String json) {
		return (FSL_J2AToken_SRT) System.JSON.deserialize(json, FSL_J2AToken_SRT.class);
	}

}