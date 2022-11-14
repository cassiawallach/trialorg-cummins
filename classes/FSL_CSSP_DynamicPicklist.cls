public class FSL_CSSP_DynamicPicklist {
    /* To update the current language selection, sent from the UI */
    @AuraEnabled
    public static String updateUser(String userId, String langPref) {
        String error = '';
        try {
            System.debug('User:' + userId +', Status : '+ langPref);
            User u = new User();
            u.Id = userId;
            u.LanguageLocaleKey = langPref;
            Update u;
            System.debug('u* : ' + u);
        } catch(Exception e) {
            error = e.getMessage();
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }
        return error;
    }
}