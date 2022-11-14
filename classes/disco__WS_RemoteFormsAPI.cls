/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class WS_RemoteFormsAPI {
    global WS_RemoteFormsAPI() {

    }
    @RemoteAction
    global static Id addDocument(String docTitle, String pathOnClient, Id answerID, Id formID, String docData) {
        return null;
    }
    @RemoteAction
    global static String addSFFileFromPublicSite(String docTitle, String pathOnClient, String externalFileId, Id answerID, Id formID, String docData) {
        return null;
    }
    @RemoteAction
    global static String addSFFileRelatedRecords(String versionID, String externalFileId, String answerID, Id formID) {
        return null;
    }
    @RemoteAction
    global static String deleteDocument(String versionID) {
        return null;
    }
    @RemoteAction
    global static List<SObject> filterValues(String objectName, String fldToGet, Map<String,String> fldsSoFar, String whereCondition, Boolean includeId) {
        return null;
    }
    @RemoteAction
    global static List<disco.Util_Forms.MockObject> findMatchingRecordsWithAdditonalFields(String objectName, String searchName, String whereCondition, String additionalFields) {
        return null;
    }
    global static List<SObject> findMatchingRecords(String objectName, String searchName, String whereCondition) {
        return null;
    }
    @RemoteAction
    global static List<SObject> findMatchingRecords(String objectName, String searchName, String whereCondition, String additionalFields) {
        return null;
    }
    @RemoteAction
    global static List<disco.Util_Forms.FullForm> queryAllForms(List<disco__Form__c> allForms) {
        return null;
    }
    @RemoteAction
    global static disco.Util_Files.SalesforceFiles retrieveAnswerSFFiles(String formID) {
        return null;
    }
    @RemoteAction
    global static List<disco.Util_Forms.FormulaFieldData> retrieveFieldValues(List<disco.Util_Forms.FormulaFieldData> formulaFieldDatasets) {
        return null;
    }
    @RemoteAction
    global static List<String> retrieveTemplateImages(List<String> documentIds) {
        return null;
    }
    @RemoteAction
    global static disco.Util_Forms.DatabaseResults saveAllAnswers(List<disco__Answer__c> answersToSave, List<String> answerIdsToNull, List<disco__Form__c> forms) {
        return null;
    }
    @RemoteAction
    global static disco.Util_Forms.DatabaseResults saveAllPhotos(List<disco.Util_Forms.FullAttachment> photos) {
        return null;
    }
    @RemoteAction
    global static disco.Util_Forms.DatabaseResults saveAnswers(List<disco__Answer__c> answersToSave, List<disco__Answer__c> answersToDelete, List<String> answerIdsToNull, List<disco__Form__c> forms, String browser, String oS) {
        return null;
    }
    global static disco.Util_Forms.DatabaseResults updateAllAnswers(List<disco__Answer__c> answersToSave, List<disco__Answer__c> answersToDelete, List<String> answerIdsToNull, List<disco__Form__c> forms) {
        return null;
    }
    global static disco.Util_Forms.DatabaseResults updateAllAnswers(List<disco__Answer__c> answersToSave, List<disco__Answer__c> answersToDelete, List<String> answerIdsToNull, List<disco__Form__c> forms, String browser, String oS) {
        return null;
    }
}
