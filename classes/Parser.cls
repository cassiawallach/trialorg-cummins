Public class Parser{

public  Static String parse(String toParse) {
System.debug('Function is called');
    
    //For Decryption of SAML Assertion
    Blob afterblob = EncodingUtil.base64Decode(toParse);
    HttpRequest tmp = new HttpRequest();
    tmp.setBodyAsBlob(afterblob);
    String Saml= tmp.getBody(); //this seem to be a valid utf-8 string
   // System.debug('value'+Saml);
    //Decryption ends
    
  DOM.Document doc = new DOM.Document();      
  try {
    doc.load(Saml);    
    DOM.XMLNode root = doc.getRootElement();
     
    System.debug('Printing walkthrough');
    return walkThrough(root);
    
  } catch (System.XMLException e) {  // invalid XML
    System.debug('Printing Exceptin'+e.getmessage());
    return e.getMessage();
    
  }
}

private static String walkThrough(DOM.XMLNode node) {
  String result = '\n';
  
  if (node.getNodeType() == DOM.XMLNodeType.ELEMENT ) {
      if(node.getName()=='AttributeValue' && node.getText().trim().ContainsIgnoreCase('ou=Application')){
    //result += 'Element: ' + node.getName();
    
    
    if (node.getText().trim() != '' ) {
      result +=node.getText().trim()+',';
    }
   }
  
    for (Dom.XMLNode child: node.getChildElements()) {
        
        
      result += walkThrough(child);
    }
    //System.debug('Printing string list '+result.trim().split(','));
    return result.trim();
  }
  return '';  //should never reach here 
}
}