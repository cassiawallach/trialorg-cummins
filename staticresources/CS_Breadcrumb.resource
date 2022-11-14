/*
Breadcrumb Component Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/

.breadcrumb-component {
    background-color: #eeeeee;
    margin-bottom: 30px;
}

.breadcrumb-component .btn-default {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-weight: 300;
    color: #007c7c;
    border-bottom: 1px solid #C3C3C3 !important;
    background-color: #eeeeee;
}

.breadcrumb-component .btn-group a div {
    border-bottom: 1px solid #C3C3C3;

}

.breadcrumb-component .btn-group a:last-child {
    color: #666;
}

.breadcrumb-component .btn-group a:last-child div {
    border-bottom: 0px;
}

.breadcrumb-component .btn-group .btn > div {
    margin-left: 5px;
}

.breadcrumb-component .btn-group .active div {
    border-bottom: 0px !important;
}

.breadcrumb-component .active {
    color: #666;
    box-shadow: none;
}

.breadcrumb-component .row .btn-group > .btn:hover {
    z-index: inherit !important;
}

.btn-breadcrumb .btn:not(:last-child):after {
    content: " ";
    display: block;
    border: 0;
    width: 0;
    height: 0;
    position: absolute;
    top: 50%;
    margin-top: -17px;
    left: 100%;
    z-index: 3;
}

.btn-breadcrumb .home:before {
    content: " ";
}

.btn-breadcrumb .btn:not(:last-child):before {
    content: url("  ");
    background: url("{!$Resource.Icon}") no-repeat scroll -44px -4160px;
    display: block;
    width: 20px;
    height: 20px;
    border: 0;
    position: absolute;
    left: 100%;
    z-index: 3;
}

.btn-breadcrumb .btn {
    padding: 10px;
    border: 0px !important;
    border-radius: 0px !important;
}

.btn-breadcrumb .btn:hover {
    color: black;
}

.btn-breadcrumb .btn:first-child {
    padding-left: 0px;
}

.btn-breadcrumb .btn {
    margin-left: 5px;
}

.breadcrumb-component .btn-group > .btn:first-child {
    margin-left: 30px;
}

.breadcrumb-component .btn-group .home div {
    margin-left: 0px;
}

/** Default button **/
.btn-breadcrumb .btn.btn-default:not(:last-child):after {
    border: 0;
}

.btn-breadcrumb .btn.btn-default:not(:last-child):before {
    border: 0;
}

.btn-breadcrumb .btn.btn-default:hover:not(:last-child):after {
    border: 0;
}

.btn-breadcrumb .btn.btn-default:hover:not(:last-child):before {
    border: 0;
}

/* The responsive part */

.btn-breadcrumb > * > div {
    /* With less: .text-overflow(); */
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;

}

.btn-breadcrumb > *:nth-child {
    display: none;
}

.btn-breadcrumb > *:nth-child(n+1) {
    display: none;
}

/* Make last Breadcrumb INACTIVE link */
.not-active {
    pointer-events: none;
    cursor: default;
}

/* === For phones =================================== */
@media (max-width: 320px) {
    .breadcrumb-component {
        margin-bottom: 20px;
    }

    .breadcrumb-component .container {
        padding-left: 0px;
    }

    .breadcrumb-component .btn-group > .btn:first-child {
        margin-left: 0px;
    }

}

@media (max-width: 767px) {
    .btn-breadcrumb > *:nth-last-child(-n+2) {
        display: block;
    }

    .btn-breadcrumb > * div {
        max-width: 60px;
    }

    .btn-breadcrumb > *:nth-child(2):not(:last-child) div:before {
        content: "...";
        float: left;
    }
}

/* === For tablets ================================== */
@media (min-width: 768px) and (max-width: 991px) {
    .btn-breadcrumb > *:nth-last-child(-n+4) {
        display: block;
    }

    .btn-breadcrumb > * div {
        max-width: 200px;
    }
}

/* === For desktops ================================== */
@media (min-width: 992px) {
    .btn-breadcrumb > *:nth-last-child(-n+3) {
        display: block;
    }

    .btn-breadcrumb > * div {
        max-width: 200px;
    }
}
