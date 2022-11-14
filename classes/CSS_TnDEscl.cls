public class CSS_TnDEscl {
    public string JobNumber {get; set;}
    
    public CSS_TnDEscl() {
			        JobNumber=ApexPages.CurrentPage().getParameters().get('jobNum');        
    }
    
    public void showPopup1() {
        system.debug ('Before:: inside ShowPopup1:' + displayPopup1);
        displayPopup1 = true;
        system.debug ('After:: inside ShowPopup1:' + displayPopup1);
    }
    public void closePopup1() {
        displayPopup1 = false;
             
    }
    public Boolean displayPopup1 {get;set;}

}