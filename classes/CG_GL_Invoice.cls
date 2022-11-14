/**********************************************************************
Name: CSS_GL_Invoice
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a global class of Invoice module to 
            reuse the methods, variables
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        12/05/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public virtual class CG_GL_Invoice extends CG_GL_Generic {

    public void CG_GL_Invoice(){
        CG_GL_Generic();
        System.debug('in CSS_GL_Invoice constructor...');
    }
    
    
    
}