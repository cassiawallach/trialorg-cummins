/****************************************************************************************************
Name: FSL_CL_NotesTriggerHandler 
Description: Note Trigger Handler class.

Version                 Date                    Author                      Summary Of Change
-----------------------------------------------------------------------------------------------------
1.0                                             Cummins                       Class created          
****************************************************************************************************/
public class FSL_CL_NotesTriggerHandler {
    
    @TestVisible static Boolean isTheme4t = (UserInfo.getUiThemeDisplayed() == 'Theme4t');
    public static void BeforeInsert(List<Note> newList) {
        
        for(Note n: newList) {
            // system.debug('---- getUiThemeDisplayed for FSL App: ' + UserInfo.getUiThemeDisplayed());
            // system.debug('---- isTheme4t for FSL App: ' + isTheme4t);
            if(isTheme4t) {
                n.Title = 'TECHNICIANNOTES';
            }
        }
    }
    
    /* public static void BeforeUpdate(List<Note> newList, Map<Id, Note> oldMap){
		// To-Do
	} */
}