/*
Cummins Global Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/

/*** Global Resets ***/
p {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-weight: 400;
    font-size: 13px;
    line-height: 20px;
    color: #333;
}

a {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-weight: 400;
    font-size: 13px;
    line-height: 20px;
    color: #007c7c;
}

a:hover {
    color: #003333;
    text-decoration: none;
}

/* Remove the dotted line from IE link Elements */
a:focus {
    outline: none;
}

/*** Header Styles ***/
h1 {
    font-family: 'Helvetica Neue 85', Arial, sans-serif;
    font-weight: 800;
    font-size: 30px;
    line-height: 32px;
}

h2 {
    font-family: 'Helvetica Neue 85', Arial, sans-serif;
    font-weight: 800;
    font-size: 23px;
    line-height: 24px;
}

h3 {
    font-family: 'Helvetica Neue 85', Arial, sans-serif;
    font-weight: 800;
    font-size: 18px;
    line-height: 20px;
}

h4 {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-weight: 300;
    font-size: 18px;
    line-height: 20px;
}

/*** Font Declarations ***/
/*** Global Button Styles ***/
.special-action-btn {
    background: #d02323;
    background-image: -webkit-linear-gradient(top, #d02323, #840909);
    background-image: -moz-linear-gradient(top, #d02323, #840909);
    background-image: -ms-linear-gradient(top, #d02323, #840909);
    background-image: -o-linear-gradient(top, #d02323, #840909);
    background-image: linear-gradient(to bottom, #d02323, #840909);
    -webkit-border-radius: 5;
    -moz-border-radius: 5;
    border-radius: 5px;
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    color: #fff;
    font-size: 13px;
    padding: 13px 10px 13px 10px;
    text-decoration: none;
    height: 35px;
}

.special-action-btn:hover {
    background: #d02323;
    color: #fff;
    text-decoration: none;
}

a.special-action-btn,
a.special-action-btn:visited {
    text-decoration: none;
    color: #fff;
}

/*** Global Dropdown / Button Styles ***/
.btn {
    border-radius: 5px;
    border: 1px solid #999999;
}

.btn:active {
    -webkit-box-shadow: none;
    -moz-box-shadow: none;
    box-shadow: none;
}

.btn:focus, .btn:active:focus, .btn.active:focus, .btn.focus, .btn:active.focus, .btn.active.focus {
    outline: none;
}

.open > .dropdown-toggle.btn-default,
.btn-default:hover,
.btn-default:focus {
    background-color: #fff;
}

.dropdown-menu {
    left: auto; /*** Bootstrap Override **/
    right: auto;
    min-width: 93%;
    border-top: 1px solid #cccccc;
    border-right: 1px solid #cccccc;
    border-bottom: 2px solid #666;
    border-left: 1px solid #cccccc;
    -webkit-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    -moz-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    /*** (rgba(0, 0, 0, 0.35) sets black at 35% opacity ***/

}

.dropdown-menu li {
    border-bottom: 1px solid #cccccc;
}

.dropdown-menu li:last-child {
    border-bottom: 0px;
}

.dropdown-menu li a {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-size: 12px;
    line-height: 15px;
    padding: 10px;
}

.dropdown-menu li a:hover,
.dropdown-menu li a:focus {
    color: #fff;
    background-color: #007c7c;
}

/*** Global Form Element Styles ***/
.input-sm, .form-group-sm .form-control {
    font-family: 'Helvetica Neue 56', Arial, sans-serif;
    font-style: italic;
    font-size: 12px;
    line-height: 15px;
    color: #666;
}

.input-sm, .form-group-sm .form-control:focus {
    border-color: #007c7c;
}

/*** Global Header Styles ***/

/*** Banner Masthead Styles ***/

/*** Footer Styles ***/
.footer {
    background-color: #000;
    margin-top: 30px;
    position: relative;
}

@media (max-width: 320px) {
    .mobile-padding-removal {
        padding-left: 0px !important;
        padding-right: 0px !important;
    }

    .footer {
        margin-top: 15px;
    }
}