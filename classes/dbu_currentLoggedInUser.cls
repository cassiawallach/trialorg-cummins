public class dbu_currentLoggedInUser {
	@AuraEnabled(cacheable=true)
    public static User getUserDetails(String recId) {
        return  [Select Id,Name,Email from User where Id =:recId];
    }
}