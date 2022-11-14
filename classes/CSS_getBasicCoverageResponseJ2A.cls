public class CSS_getBasicCoverageResponseJ2A {
    
    /* public class ListOfCoverageDedutibles {
public List<CoverageDedutibles> CoverageDedutibles;
}

public class ListOfCoverageDetails {
public List<CoverageDetails> CoverageDetails;
}

public class DataArea {
public ListOfCoverageDetails ListOfCoverageDetails;
public ListOfExtendedCoverageDetails ListOfExtendedCoverageDetails;
}

public Header Header;
public DataArea DataArea;

public class ListOfExtCoverageDedutibles {
public List<ExtendedCoverageDedutibles> ExtendedCoverageDedutibles;
}

public class ExtendedCoverageDedutibles {
public String CoverageDefTypeCode;
public String ProgramID;
public String ConstantDecutibleAmt;
public String BeginHours;
public String BeginMiles;
public String BeginMonths;
public String BeginMegawattHours;
}

public class Header {
public String MessageIdentifier;
public String ReturnCode;
public String ReturnCodeDescription;
public String Status;
}

public class CoverageDetails {
public String CoverageType;
public ListOfCoverageComponentList ListOfCoverageComponentList;
public ListOfCoverageDedutibles ListOfCoverageDedutibles;
}

public class ExtendedCoverageDetails {
public String CoverageID;
public String CertificateNumber;
public String ProgramID;
public String StartDate;
public String EndDate;
public String BeginMiles;
public String EndMiles;
public String BeginHours;
public String EndHours;
public String Months;
public ListOfExtCoverageDedutibles ListOfExtCoverageDedutibles;
}

public class ListOfExtendedCoverageDetails {
public List<ExtendedCoverageDetails> ExtendedCoverageDetails;
}

public class CoverageComponentList {
public String CoverageDefenitionType;
public String CoverageComponentTypeCode;
public String CoverageMinMonths;
public String CoverageMaxMonths;
public String CoverageMiles;
public String CoverageHours;
public String MegawattHours;
}

public class ListOfCoverageComponentList {
public List<CoverageComponentList> CoverageComponentList;
}

public class CoverageDedutibles {
public String CoverageDefTypeCode;
public String ConstantDecutibleAmt;
public String BeginHours;
public String BeginMiles;
public String BeginMonths;
public String BeginMegawattHours;
}


public static CSS_getBasicCoverageResponseJ2A parse(String json) {
return (CSS_getBasicCoverageResponseJ2A) System.JSON.deserialize(json, CSS_getBasicCoverageResponseJ2A.class);
}*/
    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT || 
                curr == JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == JSONToken.END_OBJECT ||
                           curr == JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    public class ListOfCoverageDedutibles {
        public List<CoverageDedutibles> CoverageDedutibles {get;set;} 
        
        public ListOfCoverageDedutibles(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'CoverageDedutibles') {
                            CoverageDedutibles = new List<CoverageDedutibles>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                CoverageDedutibles.add(new CoverageDedutibles(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ListOfCoverageDedutibles consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ListOfCoverageDetails {
        public List<CoverageDetails> CoverageDetails {get;set;} 
        
        public ListOfCoverageDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'CoverageDetails') {
                            CoverageDetails = new List<CoverageDetails>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                CoverageDetails.add(new CoverageDetails(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ListOfCoverageDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Header Header {get;set;} 
    public BasicCoverageResponseHeader BasicCoverageResponseHeader {get;set;} 
    
    public CSS_getBasicCoverageResponseJ2A(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'Header') {
                        Header = new Header(parser);
                    } else if (text == 'BasicCoverageResponseHeader') {
                        BasicCoverageResponseHeader = new BasicCoverageResponseHeader(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class ExtendedCoverageDedutibles { //added by vamshi S-205
        public String CoverageDefTypeCode;
        public String ProgramID;
        public String ConstantDecutibleAmt;
        public String BeginHours;
        public String BeginMiles;
        public String BeginMonths;
        public String BeginMegawattHours;
        
        public ExtendedCoverageDedutibles(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
        	if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
        		String text = parser.getText();
        		if (parser.nextToken() != JSONToken.VALUE_NULL) {
        			{
        				consumeObject(parser);
        			}
        		}
        	}
        }
      } 
    }  //S-205
    
    public class ListOfExtCoverageDedutibles {
        public List<CoverageDedutibles> ExtendedCoverageDedutibles {get;set;} 
        public String CoverageDefTypeCode;
        public String ProgramID;
        public String ConstantDecutibleAmt;
        public String BeginHours;
        public String BeginMiles;
        public String BeginMonths;
        public String BeginMegawattHours; 
        
        public ListOfExtCoverageDedutibles(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ExtendedCoverageDedutibles') {
                            ExtendedCoverageDedutibles = new List<CoverageDedutibles>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                ExtendedCoverageDedutibles.add(new CoverageDedutibles(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ListOfExtCoverageDedutibles consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BasicCoverageResponseHeader {
        public Response Response {get;set;} 
        
        public BasicCoverageResponseHeader(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'Response') {
                            Response = new Response(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'BasicCoverageResponseHeader consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Response {
        public ListOfCoverageDetails ListOfCoverageDetails {get;set;} 
        public ListOfExtendedCoverageDetails ListOfExtendedCoverageDetails {get;set;} 
        
        public Response(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ListOfCoverageDetails') {
                            ListOfCoverageDetails = new ListOfCoverageDetails(parser);
                        } else if (text == 'ListOfExtendedCoverageDetails') {
                            ListOfExtendedCoverageDetails = new ListOfExtendedCoverageDetails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Response consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Header {
        public String ReturnCodeDescription {get;set;} 
        public String Status {get;set;} 
        //Added for defect 134966
        public String Remaining {get;set;} 
        public Header(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ReturnCodeDescription') {
                            ReturnCodeDescription = parser.getText();
                        } else if (text == 'Status') {
                            Status = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Header consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CoverageDetails {
        public ListOfCoverageComponentList ListOfCoverageComponentList {get;set;} 
        public String WarrantyManualURL {get;set;} 
        public String CoverageType {get;set;} 
        public ListOfCoverageDedutibles ListOfCoverageDedutibles {get;set;} 
        public String ProcedureNumber {get;set;} 
        public String status { get; set;}//#85179    
        public String WarrantyEndDate { get; set;}//#85179
        
        public CoverageDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ListOfCoverageComponentList') {
                            ListOfCoverageComponentList = new ListOfCoverageComponentList(parser);
                        } else if (text == 'WarrantyManualURL') {
                            WarrantyManualURL = parser.getText();
                        } else if (text == 'Status') {//#85179
                            status = parser.getText();
                        } else if (text == 'WarrantyEndDate') {//#85179
                            WarrantyEndDate = parser.getText();
                        } else if (text == 'CoverageType') {
                            CoverageType = parser.getText();
                        } else if (text == 'ListOfCoverageDedutibles') {
                            ListOfCoverageDedutibles = new ListOfCoverageDedutibles(parser);
                        } else if (text == 'ProcedureNumber') {
                            ProcedureNumber = parser.getText();
                        } else if (text == 'WarrantyManualURL') {
                            WarrantyManualURL = parser.getText();
                        } 
                        
                        else {
                            System.debug(LoggingLevel.WARN, 'CoverageDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ExtendedCoverageDetails {
        public ListOfExtCoverageDedutibles ListOfExtCoverageDedutibles {get;set;} 
        public String WarrantyManualURL {get;set;} 
        public String BeginMiles {get;set;} 
        public String EndMiles {get;set;} 
        public String ProcedureNumber {get;set;} 
        public String CertificateNumber {get;set;} 
        public String ProgramID {get;set;} 
        public String BeginHours {get;set;} 
        public String EndHours {get;set;} 
        public String EndDate {get;set;} 
        public String StartDate {get;set;} 
        public String Months {get;set;} 
        public String CAPCoverageID {get;set;} 
        public String status {get;set;}//#85179
        public String remaining { get; set;} //custom field
        
        public ExtendedCoverageDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ListOfExtCoverageDedutibles') {
                            ListOfExtCoverageDedutibles = new ListOfExtCoverageDedutibles(parser);
                        } else if (text == 'WarrantyManualURL') {
                            WarrantyManualURL = parser.getText();
                        } else if (text == 'Status') {//#85179
                            status = parser.getText();
                        } else if (text == 'BeginMiles') {
                            BeginMiles = parser.getText();
                        } else if (text == 'EndMiles') {
                            EndMiles = parser.getText();
                        } else if (text == 'ProcedureNumber') {
                            ProcedureNumber = parser.getText();
                        } else if (text == 'CertificateNumber') {
                            CertificateNumber = parser.getText();
                        } else if (text == 'ProgramID') {
                            ProgramID = parser.getText();
                        } else if (text == 'BeginHours') {
                            BeginHours = parser.getText();
                        } else if (text == 'EndHours') {
                            EndHours = parser.getText();
                        } else if (text == 'EndDate') {
                            EndDate = parser.getText();
                        } else if (text == 'StartDate') {
                            StartDate = parser.getText();
                        } else if (text == 'Months') {
                            Months = parser.getText();
                        } else if (text == 'CAPCoverageID') {
                            CAPCoverageID = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'ExtendedCoverageDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ListOfExtendedCoverageDetails {
        public List<ExtendedCoverageDetails> ExtendedCoverageDetails {get;set;} 
        
        public ListOfExtendedCoverageDetails(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'ExtendedCoverageDetails') {
                            ExtendedCoverageDetails = new List<ExtendedCoverageDetails>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                ExtendedCoverageDetails.add(new ExtendedCoverageDetails(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ListOfExtendedCoverageDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class CoverageComponentList {
        public String MegawattHours {get;set;} 
        public String CoverageMaxMonths {get;set;} 
        public String CoverageComponentTypeCode {get;set;} 
        public String CoverageMinMonths {get;set;} 
        public String CoverageHours {get;set;} 
        public String CoverageDefenitionType {get;set;} 
        public String CoverageMiles {get;set;} 
        public String status { get; set;}//#85179
        public String WarrantyEndDate { get; set;}//#85179
        public String WarrantyManualURL { get; set;}
        public String remaining { get; set;} //custom field
        
        public CoverageComponentList(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'MegawattHours') {
                            MegawattHours = parser.getText();
                        } else if (text == 'CoverageMaxMonths') {
                            CoverageMaxMonths = parser.getText();
                        } else if (text == 'CoverageComponentTypeCode') {
                            CoverageComponentTypeCode = parser.getText();
                        } else if (text == 'CoverageMinMonths') {
                            CoverageMinMonths = parser.getText();
                        } else if (text == 'CoverageHours') {
                            CoverageHours = parser.getText();
                        } else if (text == 'CoverageDefenitionType') {
                            CoverageDefenitionType = parser.getText();
                        } else if (text == 'CoverageMiles') {
                            CoverageMiles = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'CoverageComponentList consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class ListOfCoverageComponentList {
        public List<CoverageComponentList> CoverageComponentList {get;set;} 
        
        public ListOfCoverageComponentList(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'CoverageComponentList') {
                            CoverageComponentList = new List<CoverageComponentList>();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                CoverageComponentList.add(new CoverageComponentList(parser));
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'ListOfCoverageComponentList consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
 /*   public class CoverageDedutibles {
        public String CoverageDefTypeCode;
        public String ConstantDecutibleAmt;
        public String BeginHours;
        public String BeginMiles;
        public String BeginMonths;
        public String BeginMegawattHours;
        public String SubsequentVisitAmt;
        public String FirstVisitAmt;
        public String ProgramID;
    } */
    
    public class CoverageDedutibles {
        public String CoverageDefTypeCode; // added as part of story 205
        public String ConstantDecutibleAmt;
        public String BeginHours;
        public String BeginMiles;
        public String BeginMonths;
        public String BeginMegawattHours;
        public String SubsequentVisitAmt;
        public String FirstVisitAmt;
        public String ProgramID;
        
        public CoverageDedutibles(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        {
                            System.debug(LoggingLevel.WARN, 'CoverageDedutibles consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    } 
    
    
    public static CSS_getBasicCoverageResponseJ2A parse(String json) {
        return new CSS_getBasicCoverageResponseJ2A(System.JSON.createParser(json));
    }
    
    public CSS_getBasicCoverageResponseJ2A(){}
}