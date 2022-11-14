/*
Banner Navigation Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/
body {
    background: none repeat scroll 0 0 #fff;
    margin: 0;
    padding: 0;
}

.header {
    background: linear-gradient(to bottom, #dc2028 0%, #af0d1f 100%);
    font-size: 13px;
}

.navbar-header {
    float: none;
    max-height: 40px;
}

.logo {
    display: inline-block;
    padding-left: 0px;
    padding-right: 0px;
}

.logo a:hover .sub-brand h2 {
    text-shadow: 3px 3px 5px rgba(0, 0, 0, 0.35);
}

.logo a:hover .logo_img img {
    -webkit-filter: drop-shadow(3px 3px 5px rgba(0, 0, 0, 0.35));
    filter: drop-shadow(3px 3px 5px rgba(0, 0, 0, 0.35));
}

.logo_img {
    display: inline-block;
    padding:  10px 30px 10px 44px;
    float: left;
}

.sub-brand h2 {
    color: #fff;
    margin: 0;
    font-size: 24px;
    line-height: 23px;
}

.sub-brand {
    padding: 12px 0px 0px 0px;
    width: 155px;
    display: inline-block;
}

.main_menu {
    display: inline-block;
    font-family: sans-serif;
    position: relative;
    right: -25%;
    bottom: 28px;
    z-index: 99;
}

.main_menu > ul {
    margin-bottom: 0;
    margin-left: 0;
}

#nav {
    display: inline-block;
}

#nav li {
    float: left;
    list-style: outside none none;
    position: relative;
}

#nav > li > a {
    color: #fff;

    padding: 10px 20px;
    text-decoration: none;
    text-transform: capitalize;
    transition: all 0.3s ease 0s;
}

#nav > li:hover > a {
    background: none repeat scroll 0 0 #840909;
}

#nav > li:last-child {
    border: 0px;
}

#nav img {
    width: 11px;
}

#nav li > ul {
    background: none repeat scroll 0 0 #fff;
    box-shadow: 6px 6px 5px -4px #666;
    display: none;
    padding: 0;
    position: absolute;
    top: 27px;
}

#nav li:hover ul {
    display: block;
}

#nav li ul li {
    border: 1px solid #cccccc;
}

#nav li ul li a {
    color: #333;
    display: table;
    padding: 10px 26px 10px 10px;
    text-decoration: none;
    width: 165px;
}

#nav li ul li:hover a {
    background: #007C7C;
    color: #fff;
}

#nav .divider {
    border-right: 1px solid #e48f92;
    height: 20px;
}

#nav .divider.border-hidden {
    border-right: 1px solid transparent;
}

#nav li a span.caret1 {
    display: none;
    position: absolute;
    left: 5px;
    width: 10px;
    height: 16px;
    background: url("{!$Resource.Icon}") no-repeat scroll -35px -1791px; background-size: 125px 2130px;
}

#nav li a span.caret1 img {
    width: 7px;
}

#nav li a span.banner-caret-down {
    display: inline !Important;
}

.nav-active {
    background-color: #840909;
}

#nav li.no-right-border {
    border-right: 1px solid transparent;
}

/** Search Styles **/

.search-container,
.responsive-search-container {
    width: 40px;
    height: 35px;
    float: right;
}

.search-btn {
    position: relative;
    top: -7px;
    right: 27px;
}

.search-container .search,
.responsive-search-container .search {
    background: #840909;
    color: #fff;
    cursor: pointer;
    display: inline-block;
    height: 35px;
    line-height: 35px;
    padding: 8px 14px 10px;
    position: absolute;
    text-decoration: none;
    bottom: 16px;
    height: 35px;
    width: 40px;
    display: inline-block;
    margin-bottom: -8px;
}

/*#searchSite input:focus + .results {
    display: block;
}*/
#searchSite .results {
    display: none;
    list-style-type: none;
    position: absolute;
    top: 29px;
    left: 0;
    right: 0;
    z-index: 10;
    padding: 0;
    margin: 0;
    border-width: 1px 1px 2px;
    border-style: solid;
    border-color: #cccccc #cccccc #666;
    border-radius: 3px;
    background-color: #fff;
    -webkit-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    -moz-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    -ms-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    -o-box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
    box-shadow: 6px 6px 5px -4px rgba(0, 0, 0, 0.35);
}

#searchSite .results li {
    border-bottom: 1px solid #cccccc;
    margin: 0px;
    padding: 0px;
    width: 100%;
}

#searchSite .results li:hover,
#searchSite .results li:hover a {
    background-color: #007c7c;
    color: #fff;
}

#searchSite .results li a {
    color: #333;
    text-decoration: none;
    font-family: "Helvetica Neue 55", Arial, sans-serif;
    font-size: 13px;
    display: block;
    line-height: 15px;
    width: 100%;
    height: 100%;
    padding: 10px;
}

#searchSite .results li a:hover {
    color: #fff;
}

.search_icon {
    background: none repeat scroll 0 0 #840909;
    color: #fff;
    cursor: pointer;
    display: table;
    padding: 7px 13px;
    right: 54px;
    top: -6px;
}

.search-open {
    right: 0;
    top: 27px;
    display: none;
    padding: 0;
    position: absolute;
    border-top: 0;
    z-index: 99999;
    zoom: 1;
}

.search-open form {
    background-color: #840909;
    padding: 4px;
    border-radius: 3px !important;
}

.search-open input {
    background-color: #fff;
    border: 0;
    border-radius: 3px !important;
    color: #000000;
    margin: 0;
}

.icon-search {
    background:url("{!$Resource.Icon}") no-repeat scroll -63px -2145px;
    display: inline-block;
    height: 34px;
    margin: 0px 0px 10px 10px;
    position: relative;
    float: left;
    width: 35px;
}

.searchicon input {
    padding-left: 10px;
    padding-right: 25px;
    padding-top: 3px;
}

.searchicon:before {
    right: 12px;
    top: 6px;
    content: "";
    width: 15px;
    height: 16px;
    display: -webkit-box;
    -webkit-box-pack: center;
    -webkit-box-align: center;
    position: absolute;
    background: url("{!$Resource.Icon}") no-repeat scroll -25px -1438px; background-size: 167px 2854px;
    background-repeat: no-repeat;
    pointer-events: none;
    -webkit-font-smoothing: antialiased;
}

.icon-remove:before {
    content: "";
}

.icon-remove {
    background: url("{!$Resource.Icon}") no-repeat scroll -68px -48px;
    display: inline-block;
    height: 25px;
    float: left;
    width: 25px;
    font-family: inherit;
    position: absolute;
    top: auto !important;
    left: auto !important;
    bottom: 5px;
    right: 7px!important;

}

}
/** Mobile responsive menu style **/

/** Responsive Menu CSS **/
.rmm ul li ul {
    background: #fff;
    display: none !important;
}

/* TJG MODIFIED
.rmm ul li:hover ul {
    display: block !important;
}
.rmm li ul li:hover a {
    background: #007C7C;
    color: #fff;
}
*/
.rmm ul li.open ul {
    display: block !important;
}

.rmm li ul li.open a {
    background: #007C7C;
    color: #fff;
}

/* END TJG MODIFIED */
.rmm li ul li a {
    color: #333;
    display: table;
    padding: 10px 26px;
    text-decoration: none;
    width: 165px;
}

.rmm li ul li:hover a {
    background: #007C7C;
    color: #fff;
}

.rmm li li:last-child {
    border-bottom: 2px solid #666;
}

.rmm {
    display: block;
    line-height: 19px !important;
    margin: auto auto auto 341px;
    padding: 0;
    text-align: center;
    width: 165px;
    position: absolute;
    top: 0;
}

.rmm * {
    -webkit-tap-highlight-color: transparent !important;
    font-family: 'Helvetica Neue 65', Arial, sans-serif;
    font-weight: 500;

}

.rmm a {
    color: #ebebeb;
    text-decoration: none;
}

.rmm .rmm-main-list, .rmm .rmm-main-list li {
    margin: 0px;
    padding: 0px;
}

.rmm ul {
    display: block;
    width: 166px !important;
    /*width:auto!important;*/
    margin: 0 auto !important;
    overflow: hidden;
    list-style: none;
    background: none repeat scroll 0 0 #d02323;
    border-left: 1px solid #cccccc;
    border-right: 1px solid #cccccc;
}

.box-shadow {
    position: absolute;
    margin: 100px;
    -webkit-box-shadow: 6px 6px 5px -4px #666;
    -moz-box-shadow: 6px 6px 5px -4px #666;
    box-shadow: 6px 6px 5px -4px #666;
}

.rmm .rmm-main-list li {
    display: inline;
    padding: padding: 0px;
    margin: 0px !important;
}

.rmm-toggled {
    display: none;
    overflow: hidden;
    margin: 0 auto !important;
}

.rmm-button:hover {
    cursor: pointer;
}

.rmm .rmm-toggled ul {
    display: none;
    margin: 0px !important;
    padding: 0px !important;
}

.rmm .rmm-toggled ul li {
    display: block;
}

.rmm .rmm-toggled ul li ul li a:hover {
    display: block;
    background-color: #007c7c;
    color: #fff;
}

/** Minimal Style **/

.rmm.minimal a {
    color: #333;
}

.rmm.minimal a:hover {
    background-color: #840909;
}

.rmm.minimal .rmm-main-list li a {
    display: inline-block;
    padding: 8px 30px 8px 30px;
    margin: 0px -3px 0px -3px;
    font-size: 15px;
}

.rmm.minimal .rmm-toggled {
    min-height: 36px;
}

.rmm.minimal .rmm-toggled-controls {
    display: block;
    height: 36px;
    color: #333;
    text-align: left;
}

.rmm.minimal .rmm-toggled-title {
    position: relative;
    top: 9px;
    left: 9px;
    font-size: 16px;
    color: #33333;
}

.rmm.minimal .rmm-button {
    background:url("{!$Resource.Icon}") no-repeat scroll -60px -2203px #840909;
    display: block;
    padding: 6px 8px;
    position: absolute;

}

.rmm.minimal .rmm-button span {
    display: block;
    margin: 4px 0px 4px 0px;
    height: 2px;
    background: #fff;
    width: 25px;
}

.rmm.minimal .rmm-toggled ul li a {
    font-family: 'Helvetica Neue 65', Arial, sans-serif;
    font-weight: 500;
    font-size: 13px;
    line-height: 15px;
    color: #fff;
    display: block;
    width: 100%;
    text-align: left;
    padding: 10px 10px 10px 10px;
    border-bottom: 2px solid #666;
}

.sub-cat li a {
    padding: 10px 20px !important;
}

/* Media Queries */

@media all and (max-width: 1027px) {
    .main_menu {
        margin-left: -31px;
        top: 47px;
    }

    #nav > li > a {
        margin-left: 0;
        margin-right: 0;

    }
}

@media all and (min-width: 1024px) {
    .mobile_menu {
        display: none;
    }

    .rmm {
        display: none !important;
    }
}

@media all and (max-width: 1023px) {
    .main_menu #nav {
        display: none;
    }

    .search_icon {
        left: 665px;
        top: 51px;
        position: absolute;
    }

    .search-open {
        margin-right: 0px;
    }

    .responsive-search-container {
        position: absolute;
        top: 82px;
        right: 20px;
        display: block !important;
    }

    .search-btn {
        top: -6px;
        right: 22px;
    }

    #nav li {
        border-right: 1px solid #fdf6f6;
        float: none;
        list-style: outside none none;
        position: relative;
    }

    .rmm {
        display: block !important;
    }

    .rmm.minimal .rmm-toggled-controls {
        height: 74px !important;
    }

    .rmm-button {
        top: 39px;
        right: 0;
        width: 40px;
        height: 35px;

    }

    .has-subnav .sub-cat {
        background: none repeat scroll 0 0 #fff;
    }

    .minimal {
        position: absolute;
        right: 70px;
        z-index: 99;
    }

    .search-mobile {
        position: absolute;
    }

    .rmm.minimal .rmm-toggled-title {
        display: none;
    }

    .rmm.minimal .rmm-toggled ul > li > a {
        color: #fff;
    }

    .rmm.minimal .rmm-toggled ul ul li a {
        color: #666;
    }
}

@media all and (max-width: 750px) {
    .navbar-header {
        max-height: 75px;
    }
}

@media all and (max-width: 727px) {

    .search_icon {
        left: 574px !important;
    }
}

@media all and (max-width: 620px) {
    .rmm {
        margin: auto auto auto 88px !important;
    }

    .search_icon {
        left: 432px !important;
    }

}

@media all and (max-width: 473px) {
    .rmm {
        margin: auto auto auto 67px !important;
    }

    .search_icon {
        left: 358px !important;
    }

}

@media all and (max-width: 400px) {
    .sub-brand {
        width: 135px;
    }

    .rmm-button {
        top: 39px;
        right: 0;
        width: 40px;
        height: 35px;

    }

    .minimal {
        position: absolute;
        right: 70px;
    }

    .search-container {
        position: absolute;
        top: 47px;
        right: 20px;
    }

    .logo_img {
        display: inline-block;
        padding: 10px 30px 10px 2px;
        float: left;
    }

    .logo_text {
        width: 139px !important;
    }

    .search_icon {
        left: 269px !important;
    }
}

@media (min-width: 971px) and (max-width: 992px) {
    #nav > li > a:not(.search) {
        padding-left: 0.44em;
        padding-right: 0.44em;
        font-size: 1em;
    }
}

@media (min-width: 801px) and (max-width: 970px) {
    #nav {
        min-width: 495px;
    }

    .main_menu {
        padding-left: 0px;
        padding-right: 0px;

    }

    #nav > li > a:not(.search) {
        padding-left: 0.25em;
        padding-right: 0.25em;
        font-size: 1em;
    }
}

@media (max-width: 320px) {
    .logo_img {
        padding-left: 0px;
        padding-right: 5px;
    }

    .sub-brand {
        width: 115px;
    }

    .sub-brand h2 {
        font-size: 17px;
        line-height: 19px;
    }

}