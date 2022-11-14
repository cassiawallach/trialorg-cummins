/**********************************************************************
Name: CSS_BL_Invoice
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of Invoice functionalities
            to handle Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/05/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public virtual class CG_BL_Invoice extends CG_GL_Invoice {

    public void CG_BL_Invoice(){
        CG_GL_Invoice();
        System.debug('in CSS_BL_Invoice constructor...');
    }
    
}