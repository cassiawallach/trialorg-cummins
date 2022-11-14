/** 
* @Class Name: dbu_Integration_ESNValidation    
* @Description      
- Constructor:  
* @Main Author: Saikomal Kattamudi    
* @Last Modified: 03/11/2020       
* @Open Points      /   
*/
public class dbu_ESNValidationResponse {

    public Boolean compatible;

	
	public static dbu_ESNValidationResponse parse(String json) {
		return (dbu_ESNValidationResponse) System.JSON.deserialize(json, dbu_ESNValidationResponse.class);
	}
}