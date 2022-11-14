/*
Global Header Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/
body > .top {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background-color: #000;
    padding: 0px 0 7px;
    height: 35px;
}

.top .container {
    padding-right: 15px;
}

#global-buttons {
    padding-right: 5px;
}

.global-container {
    max-width: 1024px;
}

.navbar-right .global-btn {
    border: 0px;
    background: none;
    padding: 6px 0;
    border-radius: 0;
}

.navbar-right .global-btn:hover,
.navbar-right .global-btn:active {
    background: #333;
}

.navbar-right .global-btn:hover a .icon-globe,
.navbar-right .open .global-btn a .icon-globe{
    background:  url("{!$Resource.Icon}") no-repeat scroll -70px -1910px rgba(0, 0, 0, 0) !important;
}

.navbar-right .global-btn:hover a .icon-phone {
    background:  url("{!$Resource.Icon}") no-repeat scroll -70px -1130px rgba(0, 0, 0, 0) !important;
}

.navbar-right .global-btn:hover a .icon-community,
.navbar-right .open .global-btn a .icon-community {
    background:  url("{!$Resource.Icon}") no-repeat scroll -70px -2571px rgba(0, 0, 0, 0) !important;
}

.navbar-right .open {
    background: #333;
}

.navbar-right .global-btn a {
    color: #fff;
    padding: 10px 10px;
    text-transform: uppercase;
    text-decoration: none;
    font-size: 10px;
}

.navbar-right .global-btn .icon-phone {
    color: #999999;
    padding: 10px 10px 10px 0px;
    font-size: 16px;
    text-transform: uppercase;
    vertical-align: middle;
}

.navbar-right .global-btn .icon-phone {
    background:  url("{!$Resource.Icon}") no-repeat scroll -40px -1130px rgba(0, 0, 0, 0);
    display: inline-block;
    height: 20px;
    margin: 1px 0px 10px 10px;
    position: relative;
    float: left;
    width: 22px;
}
.navbar-right .global-btn .icon-globe {
    background: url("{!$Resource.Icon}") no-repeat scroll -40px -1910px rgba(0, 0, 0, 0);
    display: inline-block;
    height: 20px;
    margin: 1px 0px 10px 10px;
    position: relative;
    float: left;
    width: 22px;
}

.navbar-right .global-btn .icon-community {
    background:  url("{!$Resource.Icon}") no-repeat scroll -40px -2571px rgba(0, 0, 0, 0);
    display: inline-block;
    height: 20px;
    margin: 1px 0px 10px 10px;
    position: relative;
    float: left;
    width: 22px;
}

.navbar-right .phone-btn,
.navbar-right .globe-btn,
.navbar-right .community-btn {
    height: 35px;
    padding-right: 10px;
}

.navbar-right .dropdown-menu {
    min-width: 110px;
    box-shadow: 5px 5px 5px rgba(0, 0, 0, 0.3);
}

.navbar-right .dropdown-menu li {
    background-color: #fff;
    border-bottom: solid 1px #ccc;
}

.navbar-right .dropdown-menu li:hover {
    background-color: #007c7c;
}

.navbar-right .dropdown-menu li a {
    padding: 10px;
    text-align: left;
    color: #666;
    font-size: 13px/15px;
}

.navbar-right .dropdown-menu li a:hover {
    color: #fff;
    background-color: #007c7c;
}

.navbar-right .dropdown-menu li:last-child {
    border-bottom: solid 2px #666;
}

body {
    background-color: #d02323;
}

.navbar-right .btn-group .dropdown-menu {
    right: 0;
    left: inherit;
}

@media only screen and (max-width: 750px) {
    .navbar-right {
        float: right !important;
    }

    .navbar-right .global-btn .icon-community,
    .navbar-right .global-btn .icon-globe,
    .navbar-right .global-btn .icon-phone {
        padding: 10px 0px;
    }

    .navbar-right .community-btn {
        padding-right: 0px;
    }
    .navbar-right .phone-btn a,
    .navbar-right .globe-btn a,
    .navbar-right .community-btn a {
        padding-right: 0px;
    }
    .navbar-right .phone-btn a,
    .navbar-right .globe-btn a {
        padding-left:0px;
    }
}
