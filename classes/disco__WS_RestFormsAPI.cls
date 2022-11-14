/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/SynapseForms/*')
global class WS_RestFormsAPI {
    global WS_RestFormsAPI() {

    }
    @HttpGet
    global static List<disco.Util_Forms.FullForm> queryAllMobileForms() {
        return null;
    }
    @HttpPost
    global static disco.Util_Forms.DatabaseResults saveAllAnswers(List<disco__Answer__c> allAnswers, List<String> answerIdsToNull, List<disco__Form__c> forms) {
        return null;
    }
}
