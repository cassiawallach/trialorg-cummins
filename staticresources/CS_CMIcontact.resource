/*
Contact Form Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
Questions or comments: karen.falkner@cummins.com
*/

#contact-form .contact-form-main {
    padding-left: 30px;
    padding-right: 30px;
}

#contact-form .contact-form-info {
    padding-left: 30px;
    padding-right: 30px;
}

#contact-form h1 {
    border-bottom: 2px solid #006666;
    color: #000000;
    margin-top: 0;
}

#contact-form .dropdown .btn {
    padding: 3px 10px;
    border-radius: 3px;
    border-color: #cccccc;
    text-align: left;
    color: #666;
   
    font-size: 12px;
    font-style: italic;
    font-weight: 400;
    line-height: 15px;
    padding-top: 6px;
    padding-bottom: 6px;
}

#contact-form .dropdown .btn:focus {
    font-style: normal;
    box-shadow: 0 0 5px #007c7c;
}

#contact-form .dropdown .btn:hover,
#contact-form .dropdown .btn:active {
    background-color: #fff;
}

#contact-form .contact-form-left {
    margin-left: 0px;
}

#contact-form .contact-form-left .form-group,
#contact-form .contact-form-right .form-group {
    margin-bottom: 20px;
    padding: 0px;
}

#contact-form .contact-form-left,
#contact-form .contact-form-right,
#contact-form .contact-form-bottom {
    border: 1px solid black;
    background-clip: content-box;
    padding: 0px;
}

#contact-form .form-group div {
    margin-left: 0px;
    padding-left: 0px;
}

#contact-form .form-group label {
    top: 5px;
    margin-right: 0px;
    padding-right: 0px;
    text-align: right;
}

#contact-form .details {
    margin-bottom: 30px;
}

#contact-form .radio-title,
#contact-form .checkbox-title,
#contact-form .details label {
   
    font-size: 13px;
    line-height: 15px;
    margin-top: 10px;
    padding-left: 0px;
    padding-right: 0px;
    white-space: nowrap;
    text-align: right;
}

#contact-form .radio-buttons .required,
#contact-form .checkboxes .required,
#contact-form .details .required {
   
    font-weight: 400;
    font-size: 13px;
    color: #D02323;
    padding-top: 10px;
    text-align: center;
    padding-left: 0px;
    padding-right: 0px;

}

#contact-form .radio-buttons .radio-holder,
#contact-form .checkboxes .checkbox-holder {
    padding-left: 0px;
}

#contact-form .details .details-input {
    padding-left: 0px;
}


#contact-form .form-group .required {
   
    font-weight: 400;
    font-size: 14px;
    color: #D02323;
    padding-right: 0px;
    top: 5px;
}

#contact-form input {
    
    font-weight: 400;
    font-size: 12px;
    font-style: normal;
    line-height: 15px;
    color: #333333;
}

#contact-form input[type="text"] {
    
    font-size: 12px;
    line-height: 15px;
    color: #333333;

}

button[aria-expanded="false"]{
    font-style:normal!important;
    color:#333333!important;
}
::-webkit-input-placeholder {
    color: #666;
    font-style: italic;
} /*Chrome */

:-moz-placeholder {
    color: #666;
    font-style: italic;
} /*ff*/

:-ms-input-placeholder {
    color: #666;
    font-style: italic;
} /*ie latest */

#contact-form input[type="text"]:focus {
   
    font-size: 12px;
    line-height: 15px;
    color: #000000;
    font-style: normal;
}

#contact-form .form-control:focus {
    box-shadow: 0 0 5px #007c7c;
}

#contact-form .dropdown .btn .caret {
    position: absolute;
    right: 23px;
    top: 12px;
}
#contact-form .dropdown button[aria-selected="false"] {
    font-style:normal!important;
}
contact-form @font-face {
	    font-family: 'proxima-nova' !important;
	    src: url('proximanova-light-webfont.eot') !important;
	    src: url('proximanova-light-webfont.eot?#iefix') format('embedded-opentype'),
	         url('proximanova-light-webfont.woff2') format('woff2'),
	         url('proximanova-light-webfont.woff') format('woff'),
        	 url('proximanova-light-webfont.ttf') format('truetype'),
	         url('proximanova-light-webfont.svg#proxima_novalight') format('svg') !important;
		 url('proximanova-light.otf') !important;
	    font-weight: normal !important;
	    font-style: normal !important;
	}

}

contact-form @font-face {
	    font-family: 'Proxima Nova';
	    src: url('proximanova-light-webfont.eot');
	    src: url('proximanova-light-webfont.eot?#iefix') format('embedded-opentype'),
	         url('proximanova-light-webfont.woff2') format('woff2'),
	         url('proximanova-light-webfont.woff') format('woff'),
        	 url('proximanova-light-webfont.ttf') format('truetype'),
	         url('proximanova-light-webfont.svg#proxima_novalight') format('svg');
		 url('proximanova-light.otf');
	    font-weight: normal;
	    font-style: normal;
	}

}


#contact-form label {
    
    font-weight: 400;
    font-size: 13px;
    line-height: 15px;
    color: #333333;
}

#contact-form option:hover {
    background-color: #007C7C;
    color: #fff;
}

#contact-form span.fieldset-label {
    
    font-weight: 500;
    font-size: 18px;
    line-height: 20px;
    color: black;
    background-color: white;
    position: relative;
    left: 10px;
    bottom: 13px;
    padding: 5px;
}

label.radio-label,
label.checkbox-label {
    display: inline-block;
    cursor: pointer;
    position: relative;
    padding-left: 25px;
    margin-right: 15px;
    font-size: 13px;
}

.radio input[type=radio] {
    display: none;
}

label.radio-label:before,
label.checkbox-label:before {
    content: "";
    display: inline-block;
    width: 16px;
    height: 16px;
    margin-right: 10px;
    position: absolute;
    left: 0;
    top: 2px;
    background-color: #fff;
    box-shadow: inset 0px 2px 3px 0px rgba(0, 0, 0, .3), 0px 1px 0px 0px rgba(255, 255, 255, .8);
}

label.radio-label:before {
    border-radius: 8px;
}

.radio input[type=radio]:checked + label.radio-label:before {
    content: "\2022";
    color: #007c7c;
    font-size: 30px;
    text-align: center;
    line-height: 18px;
}

#contact-form .radio-buttons li,
#contact-form .checkboxes li {
    display: inline-block;
}

#contact-form .radio-buttons label,
#contact-form .checkboxes label {
    line-height: 22px;
    margin-right: 20px;
}

.checkbox input[type=checkbox] {
    display: none;
}

.checkbox label:before {
    border-radius: 3px;
}

input[type=checkbox]:checked + label:before {
    background: url("../../img/CMI-WebIcon-Sprite.png") no-repeat scroll -101px -4192px;
    text-shadow: 1px 1px 1px rgba(0, 0, 0, .2);
    font-size: 15px;
    color: #007c7c;
    text-align: center;
    line-height: 15px;
}

#contact-form .required-text {
    text-align: right;
    margin-top: 10px;
    margin-right: 20px;
    margin-bottom: 10px;
}

#contact-form .required-text span {
   
    font-weight: 400;
    font-size: 14px;
    color: #D02323;
}

.contact-form-wrapper {
    background: white;
    background-clip: content-box;
    padding-left: 10px;
    padding-right: 10px;
}

.contact-form-left-wrap {
    padding-right: 10px;
    padding-bottom: 10px;
}

.contact-form-right-wrap {
    padding-left: 10px;
    padding-bottom: 10px;
}

.contact-form-bottom-wrap {
    padding-top: 10px;
}

.contact-form-left-wrap,
.contact-form-right-wrap,
.contact-form-bottom-wrap {
    margin-top: 20px;
}

.contact-form-bottom-buttons {
    margin-top: 20px;
    margin-bottom: 20px;
}

.primary-cta {
    background: #666;
    background-image: -webkit-linear-gradient(top, #666, #000000);
    background-image: -moz-linear-gradient(top, #666, #000000);
    background-image: -ms-linear-gradient(top, #666, #000000);
    background-image: -o-linear-gradient(top, #666, #000000);
    background-image: linear-gradient(to bottom, #666, #000000);
    -webkit-border-radius: 5;
    -moz-border-radius: 5;
    border-radius: 5px;
    font-family:Proxima Nova Regular;
    font-weight: 400;
    font-size: 13px;
    color: #fff;
    padding: 10px 10px 10px 10px;
    text-decoration: none;
    margin: 0px 10px;
}

.primary-cta:hover,
.primary-cta:focus {
    background: #333333;
    text-decoration: none;
    color: #fff;
}

.primary-cta:first-child {
    margin-left: 0px;
}

.secondary-cta {
    background: #666;
    background-image: -webkit-linear-gradient(top, #fff, #cccccc);
    background-image: -moz-linear-gradient(top, #fff, #cccccc);
    background-image: -ms-linear-gradient(top, #fff, #cccccc);
    background-image: -o-linear-gradient(top, #fff, #cccccc);
    background-image: linear-gradient(to bottom, #fff, #cccccc);
    -webkit-border-radius: 5;
    -moz-border-radius: 5;
    border-radius: 5px;
   
    font-weight: 400;
    font-size: 13px;
    color: #000000;
    padding: 10px 10px 10px 10px;
    text-decoration: none;
    margin: 0px 10px;
}

.secondary-cta:hover,
.secondary-cta:focus {
    background: #fff;
    text-decoration: none;
    color: #000000;
}

.secondary-cta:first-child {
    margin-left: 0px;
}

@media (max-width: 800px) {
    #contact-form .form-group div {
        padding-left: 15px;
    }

    #contact-form .phone div:first-child {
        padding-left: 15px;
    }

    #contact-form .phone div:last-child {
        padding-right: 15px;
    }

    #contact-form .phone div {
        padding-left: 0px;
    }
}

@media (max-width: 750px) {
    .primary-cta:first-child {
        margin-bottom: 10px;
    }

    .secondary-cta {
        margin-left: 0px;
        margin-right: 0px;

    }

    #contact-form .radio-title,
    #contact-form .checkbox-title,
    #contact-form .details label {
        text-align: left;
    }

    #contact-form .details label {
        min-width: 35px;
    }
}

@media (max-width: 638px) {
    #contact-form .radio-buttons .radio-holder,
    #contact-form .checkboxes .checkbox-holder,
    #contact-form .details .details-input {
        padding-left: 5px;
    }

    #contact-form .radio-buttons .required,
    #contact-form .checkboxes .required,
    #contact-form .details .required {
        padding-left: 10px;
    }
}

@media (max-width: 540px) {
    #contact-form .longer-title {
        width: 60px;
    }
}

@media (max-width: 320px) {

    #contact-form .contact-form-main,
    #contact-form .contact-form-info,
    #contact-form .contact-form-wrapper,
    #contact-form .contact-form-bottom .details {
        padding-left: 0px;
        padding-right: 0px;
    }

    #contact-form .radio-buttons,
    #contact-form .checkboxes {
        margin-left: 0px;
    }

    #contact-form .radio-buttons li,
    #contact-form .checkboxes li {
        display: block;
    }

    #contact-form .form-group .required {
        padding-left: 5px;
    }

    #contact-form .contact-form-bottom-buttons button {
        margin-bottom: 10px;
    }

}
