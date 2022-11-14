/*
Fat Footer Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/
.large-padding div:last-child {
    padding-right: 20px;
}

.large-padding div:first-child {
    padding-left: 30px;
    padding-bottom: 15px;
}

.ff-column {
    padding-left: 10px;
    padding-right: 10px;
}

.fat-footer h4 {
    font-family: 'Helvetica Neue 75', Arial, sans-serif;
    font-weight: 700;
    border-bottom: 2px solid #fff;
    font-size: 16px;
    line-height: 18px;
    margin: 0;
    padding: 60px 0 10px 0;
    color: #fff;
    /* white-space: nowrap; */
}

.fat-footer a {
    display: block;
}

.fat-footer a:hover {
    color: #fff;
}

.fat-footer .dl-horizontal {
    list-style-type: none;
    padding: 0;
    margin-bottom: 0px;
}

.fat-footer .dl-horizontal li {
    font-family: 'Helvetica Neue 65', Arial, sans-serif;
    font-weight: 500;
    font-size: 13px;
    line-height: 15px;
    color: #fff;
    border-bottom: 1px solid #fff;
}

.fat-footer .dl-horizontal li:hover,
.fat-footer .dl-horizontal a:hover {
    background-color: #333;
    text-decoration: none;
}

.fat-footer .dl-horizontal li a {
    color: #fff;
    text-decoration: none;
    padding: 10px 10px;
    line-height: 15px;
}

/** Mobile Footer Styling **/
.fat-footer .panel-group .panel-default {
    border: none;
    box-shadow: none;
}

.fat-footer .panel-group .panel {
    background-color: #000000;
    border: none;
    box-shadow: none;
    margin-top: 0px;
}

.fat-footer .panel-group .panel .panel-collapse .panel-body {
    padding: 0px 20px;
}

.fat-footer .panel-group .panel .panel-heading {
    background-color: #000000;
    border: none !important;
}

.fat-footer .panel-group .panel .panel-collapse .panel-body {
    border: none !important;
}

.fat-footer .panel-group .panel .panel-heading {
    padding: 0px 0px;
}

.fat-footer .panel-group .panel .panel-heading .panel-title:hover {
    background-color: #333;
}

.fat-footer .panel-group .panel .panel-heading h4 {
    padding: 10px 0px;
}

.fat-footer .panel-group .panel .panel-heading .panel-title a:hover {
    text-decoration: none;
}

.panel-heading .accordion-toggle:focus {
    /*remove underline in IE*/
    text-decoration: none;
}

.panel-heading .accordion-toggle:after {
    /* symbol for "opening" panels */
    content: ""; /*adjust as needed, taken from bootstrap.css */
    background:  url("{!$Resource.Icon}") no-repeat scroll; background-size: 167px 2854px;
    background-repeat: no-repeat;
    float: left; /* adjust as needed */
    padding-right: 25px;
    width: 15px;
    height: 17px;
}

.panel-heading .accordion-toggle.collapsed:after {
    background-position: -45px -192px;
    -ms-transform: rotate(0deg); /* IE 9 */
    -webkit-transform: rotate(0deg); /* Chrome, Safari, Opera */
    transform: rotate(0deg);
	margin-top:0;
}

.panel-heading .accordion-toggle:after {
    background-position: -45px -192px;
    -ms-transform: rotate(90deg); /* IE 9 */
    -webkit-transform: rotate(90deg); /* Chrome, Safari, Opera */
    transform: rotate(90deg);
	margin-top:5px;
}

@media only screen and (max-width: 750px) {
    .fat-footer .dl-horizontal li a {
        color: #fff;
        text-decoration: none;
        display: block;
        width: 100%;
        height: 100%;
        padding: 10px 10px 10px 25px;
    }
}

@media only screen and (max-width: 800px) {
    .fat-footer a:hover {
        text-decoration: none;
    }

    .fat-footer {
        padding-top: 30px;
    }

    .fat-footer #accordion {
        margin-left: 20px;
        margin-right: 20px;
    }

    .fat-footer h4 {
        padding: 50px 0 10px 0;
    }

    .panel-body {
        padding: 0px;
    }

    .fat-footer .panel-group .panel .panel-collapse .panel-body {
        padding: 0px 0px;
    }
}