/**********************************************************************
Name: CSS_CL_Invoice
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used as a controller to navigate to Functionality
            class by passing required parameters
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/05/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_CL_Invoice extends CG_BL_Invoice {

    
    //public String workJob { get; set; }

    
    public CG_CL_Invoice() {
       
       CG_BL_Invoice();
       
       system.debug('hello');
       
      }
      

    
}