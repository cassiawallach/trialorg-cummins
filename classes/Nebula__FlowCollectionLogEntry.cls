/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FlowCollectionLogEntry {
    @InvocableVariable(label='(Optional) Flow Fault Error Message' required=false)
    global String faultMessage;
    @InvocableVariable(label='Flow API Name' required=true)
    global String flowName;
    @InvocableVariable(label='(Optional) Logging Level' required=false)
    global String loggingLevelName;
    @InvocableVariable(label='Log Entry Message' required=true)
    global String message;
    @InvocableVariable(label='Records' required=false)
    global List<SObject> records;
    @InvocableVariable(label='(Optional) Save Log' required=false)
    global Boolean saveLog;
    @InvocableVariable(label='(Optional) Save Method' required=false)
    global String saveMethodName;
    @InvocableVariable(label='(Optional) Scenario' required=false)
    global String scenario;
    @InvocableVariable(label='(Optional) Tags (comma-separated)' required=false)
    global String tagsString;
    global FlowCollectionLogEntry() {

    }
    @InvocableMethod(label='Add Log Entry for an SObject Record Collection' description='Creates a log entry for a flow or process builder and stores the record list as JSON')
    global static List<String> addFlowCollectionEntries(List<Nebula.FlowCollectionLogEntry> flowCollectionLogEntries) {
        return null;
    }
}
