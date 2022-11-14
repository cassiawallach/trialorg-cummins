/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class ccPaymentProcessor {
    global ccPaymentProcessor() {

    }
    global virtual Map<String,Object> postProcess(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> preProcess(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> process(Map<String,Object> inputData) {
        return null;
    }
global class failOnPreProcessProcessor extends ccrz.ccPaymentProcessor {
    global failOnPreProcessProcessor() {

    }
    global override Map<String,Object> postProcess(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> preProcess(Map<String,Object> inputData) {
        return null;
    }
}
global class failOnProcessProcessor extends ccrz.ccPaymentProcessor {
    global failOnProcessProcessor() {

    }
    global override Map<String,Object> postProcess(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> preProcess(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> process(Map<String,Object> inputData) {
        return null;
    }
}
global class loggingProcessor extends ccrz.ccPaymentProcessor {
    global loggingProcessor() {

    }
    global override Map<String,Object> postProcess(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> preProcess(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> process(Map<String,Object> inputData) {
        return null;
    }
}
}
