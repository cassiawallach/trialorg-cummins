/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ccApi {
    global static String API_VERSION;
    global static String CACHE_DATA;
    global static String CACHE_ENTITYNAME;
    global static String CACHE_INP;
    global static String CACHE_KEY;
    global static String CACHE_KEYMAP;
    global static String CACHE_TTL;
    global static Integer CURRENT_VERSION;
    global static String MESSAGES;
    global static Integer MINIMUM_VERSION;
    global static String SIZING;
    global static String SKIP_OWNERID;
    global static String SUCCESS;
    global static String SZ_ASSC;
    global static String SZ_DATA;
    global static Map<String,Object> SZ_DIR;
    global static String SZ_GROUPBY;
    global static String SZ_L;
    global static String SZ_M;
    global static String SZ_NOCACHE;
    global static String SZ_REFETCH;
    global static String SZ_REL;
    global static String SZ_S;
    global static String SZ_SKIPFLTCK;
    global static String SZ_SKIPTRZ;
    global static String SZ_XL;
    global static String SZ_XS;
    global static String VERSIONUNAVAILABLE;
    global ccApi() {

    }
    global static Map<String,Object> checkSizing(Map<String,Object> inputData) {
        return null;
    }
    global static Integer checkVersion(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> flushCache(Map<String,Object> inpData) {
        return null;
    }
    global static Object lookUpSz(Map<String,Object> inputData, String entityName, String sizingKey) {
        return null;
    }
    global static Map<String,Object> registerLogic(Map<String,Object> svcReg) {
        return null;
    }
    global static Map<String,Object> registerService(Map<String,Object> svcReg) {
        return null;
    }
    global static Map<String,Object> unregisterLogic(Map<String,Object> svcReg) {
        return null;
    }
    global static Map<String,Object> unregisterService(Map<String,Object> svcReg) {
        return null;
    }
global class BelowMinAPIVersionException extends Exception {
}
global class ExceedsMaxAPIVersionException extends Exception {
}
global class MissingInputException extends Exception {
    global List<String> errorMessages {
        get;
        set;
    }
    global MissingInputException(List<String> errorMessages) {

    }
}
global class NoApiVersionException extends Exception {
}
global class NoWhereClauseException extends Exception {
}
global class UnregisterServiceException extends Exception {
}
}
