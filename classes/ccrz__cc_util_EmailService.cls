/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_util_EmailService implements Messaging.InboundEmailHandler {
    global static Integer DML_MAX_ROW_SIZE;
    global static Integer FILE_CHUNK_ROW_SIZE;
    global cc_util_EmailService() {

    }
    global static String getShippedStatusCode() {
        return null;
    }
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail x, Messaging.InboundEnvelope y) {
        return null;
    }
    global static Datetime parseDateTimeString(String x) {
        return null;
    }
    global static void parseShipmentCSV(String x) {

    }
    global static void processShipments(Map<String,ccrz.cc_util_EmailService.CC_Shipment> x) {

    }
global class CC_Shipment {
    global String carrierDesc {
        get;
        set;
    }
    global String contactEmail {
        get;
        set;
    }
    global String contactName {
        get;
        set;
    }
    global String description {
        get;
        set;
    }
    global String id {
        get;
        set;
    }
    global Datetime shipDate {
        get;
        set;
    }
    global String shipName {
        get;
        set;
    }
    global String webOrder {
        get;
        set;
    }
    global String zBiShipTrackNumbers {
        get;
        set;
    }
    global CC_Shipment() {

    }
}
}
