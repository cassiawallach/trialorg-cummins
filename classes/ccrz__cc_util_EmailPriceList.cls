/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_util_EmailPriceList implements Messaging.InboundEmailHandler {
    global static Integer DML_MAX_ROW_SIZE;
    global static Integer FILE_CHUNK_ROW_SIZE;
    global cc_util_EmailPriceList() {

    }
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope env) {
        return null;
    }
    global static void parseProductPriceCSV(String x) {

    }
global class CC_ProductPrice {
    global String description {
        get;
        set;
    }
    global String description2 {
        get;
        set;
    }
    global String partNo {
        get;
        set;
    }
    global String productCode {
        get;
        set;
    }
    global Decimal zUSPrice {
        get;
        set;
    }
    global CC_ProductPrice() {

    }
}
}
