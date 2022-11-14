@RestResource(urlMapping='/IAM_Fleetguard_ChangePassword/*')
Global with sharing class IAM_Fleetgaurd_ChangePassword
{   
    @HttpPost
    Global static void doPost(String username, String newPassword)
    {       
        
        String jsonResponse = '';        
        //String userFormat = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        RestRequest req = RestContext.request;
        RestResponse response = RestContext.response; 
        response.addHeader('Content-Type','applicatin/json');
        String ContentType = RestContext.request.headers.get('Content-Type');   
       //User user;      
        
        if(username != null && username != '' && newPassword != null && newPassword != ''){   
         
       // if(Pattern.matches(userFormat, username)){            
            List<User>  user = [SELECT Id, Name FROM User WHERE (UserName =:username OR IAM_UID__c=:UserName) AND isActive=True LIMIT 1 ];          
       // }        
        
        if(user.isEmpty()){
            response.statusCode = 200;
            //jsonResponse='{"\nstatus": "Success","response": "User doesnot exist!"}';
            jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ErrorCode":"User does not exist",\n"Message": "Please give the correct username"}}';
            response.responseBody = blob.valueOf(jsonResponse);                   
        } else {
            if(String.isNotBlank(newPassword)){
                try {
                    response.statusCode = 200;
                    jsonResponse = '{"response": {\n"status": "Success",\n"isSuccess":"True" ,\n"errorCode":"Nothing", \n"Message": "Password reset done",\n"Username":"'+username+'"}}';
                    response.responseBody = blob.valueOf(jsonResponse);
                    System.setPassword(user[0].Id, newPassword);
                }catch (Exception ce) {                   
                    response.statusCode = 200;                                   
                    //jsonResponse = '{"response": {\n"Status": "Failure",\n"isSuccess":"False" , \n"ErrorCode":"Invalid Password",\n"Message": "'+ce.getMessage()+'",\n"Username":"'+username+'"}}';
                    jsonResponse = '{"response": {\n"Status": "Failure",\n"isSuccess":"False" , \n"ErrorCode":"Invalid Password",\n"Message": " You cannot use old password and Your password must include numbers, uppercase and lowercase letters, and at least one special characters and must be 8 characters long",\n"Username":"'+username+'"}}';
                    response.responseBody = blob.valueOf(jsonResponse);                   
                }    
            }     
        }
        }
        else{
          if(username == null || username == '')
          {
            response.statusCode = 200;
            jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ErrorCode":"Username cannot be blank",\n"Message": "Username cannot be blank"}}';
            response.responseBody = blob.valueOf(jsonResponse); 
            }
            else{
            response.statusCode = 200;
            jsonResponse = '{"response": {\n"Status": "Failure", \n"isSuccess":"False" , \n"ErrorCode":"New password cannot be blank",\n"Message": "Password cannot be blank"}}';
            response.responseBody = blob.valueOf(jsonResponse); 
            }
            
    }
  }
}