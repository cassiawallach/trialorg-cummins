/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_MenuItem implements System.Comparable {
    global List<ccrz.cc_bean_MenuItem> children {
        get;
        set;
    }
    global String displayName {
        get;
        set;
    }
    global String friendlyUrl {
        get;
        set;
    }
    global String linkURL {
        get;
        set;
    }
    global String menuId {
        get;
        set;
    }
    global String mType {
        get;
        set;
    }
    global Boolean openInNewWindow {
        get;
        set;
    }
    global Integer sequence {
        get;
        set;
    }
    global String sfid {
        get;
        set;
    }
    global cc_bean_MenuItem() {

    }
    global cc_bean_MenuItem(String displayName, String linkURL, Boolean openInNewWindow) {

    }
    global cc_bean_MenuItem(String sfid, String displayName, String linkURL, Boolean openInNewWindow) {

    }
    global cc_bean_MenuItem(String displayName, String linkURL, Boolean openInNewWindow, String type, Decimal sequence) {

    }
    global cc_bean_MenuItem(String sfid, String displayName, String linkURL, Boolean openInNewWindow, String menuId) {

    }
    global cc_bean_MenuItem(String sfid, String displayName, String linkURL, Boolean openInNewWindow, String type, Decimal sequence) {

    }
    global cc_bean_MenuItem(String sfid, String displayName, String linkURL, Boolean openInNewWindow, String type, Decimal sequence, String menuId) {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
}
