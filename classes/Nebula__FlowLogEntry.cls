/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FlowLogEntry {
    @InvocableVariable(label='(Optional) Flow Fault Error Message' required=false)
    global String faultMessage;
    @InvocableVariable(label='Flow API Name' required=true)
    global String flowName;
    @InvocableVariable(label='(Optional) Logging Level' required=false)
    global String loggingLevelName;
    @InvocableVariable(label='Log Entry Message' required=true)
    global String message;
    @InvocableVariable(label='(Optional) Record ID' required=false)
    global Id recordId;
    @InvocableVariable(label='(Optional) Save Log' required=false)
    global Boolean saveLog;
    @InvocableVariable(label='(Optional) Save Method' required=false)
    global String saveMethodName;
    @InvocableVariable(label='(Optional) Scenario' required=false)
    global String scenario;
    @InvocableVariable(label='(Optional) Tags (comma-separated)' required=false)
    global String tagsString;
    global FlowLogEntry() {

    }
    @InvocableMethod(label='Add Log Entry' description='Creates a log entry for a flow or process builder')
    global static List<String> addFlowEntries(List<Nebula.FlowLogEntry> flowLogEntries) {
        return null;
    }
}
