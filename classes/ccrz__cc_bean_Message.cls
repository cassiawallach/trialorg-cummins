/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_Message {
    global String classToAppend {
        get;
        set;
    }
    global String displayClass {
        get;
        set;
    }
    global Boolean isCustomized {
        get;
        set;
    }
    global String labelId {
        get;
        set;
    }
    global String message {
        get;
        set;
    }
    global String messageId {
        get;
        set;
    }
    global Id refersTo {
        get;
        set;
    }
    global ccrz.cc_bean_Message.MessageSeverity severity {
        get;
        set;
    }
    global ccrz.cc_bean_Message.MessageType type {
        get;
        set;
    }
    global cc_bean_Message() {

    }
    global cc_bean_Message(String message) {

    }
    global cc_bean_Message(String message, ccrz.cc_bean_Message.MessageSeverity severity) {

    }
    global cc_bean_Message(String message, ccrz.cc_bean_Message.MessageType type) {

    }
global enum MessageSeverity {CRITICAL, ERROR, INFO, SUCCESS, WARN}
global enum MessageType {ALERT, CUSTOM, STANDARD}
}
