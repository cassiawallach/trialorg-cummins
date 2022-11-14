public class OSM_GOMSInvoiceReqWrapper {
    public class INVOICE_ID {
       public INVOICE_ID(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'INVOICE_ID consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public List<INVOICE_DATA> INVOICE_DATA {get;set;} 

    public OSM_GOMSInvoiceReqWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'INVOICE_DATA') {
                        INVOICE_DATA = arrayOfINVOICE_DATA(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'GOMSInvoiceReqWrapper consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class INVOICE_DATA {
        public String TRANSACTION_ID {get;set;} 
        public String SHIP_TO_ABBR {get;set;} 
        public String INVOICE_ID {get;set;} 
        public String STATUS {get;set;} 
        public String MESSAGE {get;set;} 

        public INVOICE_DATA(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'TRANSACTION_ID') {
                            TRANSACTION_ID = parser.getText();
                        } else if (text == 'SHIP_TO_ABBR') {
                            SHIP_TO_ABBR = parser.getText();
                        } else if (text == 'INVOICE_ID') {
                            INVOICE_ID = parser.getText();
                        } else if (text == 'STATUS') {
                            STATUS = parser.getText();
                        } else if (text == 'MESSAGE') {
                            MESSAGE = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'INVOICE_DATA consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    public static OSM_GOMSInvoiceReqWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new OSM_GOMSInvoiceReqWrapper(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    private static List<INVOICE_DATA> arrayOfINVOICE_DATA(System.JSONParser p) {
        List<INVOICE_DATA> res = new List<INVOICE_DATA>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new INVOICE_DATA(p));
        }
        return res;
    }
    
    @testVisible
    private static List<INVOICE_ID> arrayOfINVOICE_ID(System.JSONParser p) {
        List<INVOICE_ID> res = new List<INVOICE_ID>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new INVOICE_ID(p));
        }
        return res;
    }

}