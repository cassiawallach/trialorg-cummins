/*
Banner Carousel Component Stylesheet
Cummins UX Standards Template
(C)2015 Cummins Inc., Box 3005, Columbus, IN 47202-3005 U.S.A.
For questions, UI standards and more contact the Cummins UX Team
*/
.banner-carousel-component {
    background-color: #000000;
    position: relative;
}

.banner-carousel-component .container {
    padding-right: 0px;
    padding-left: 0px;
}

.bc-slider {
    list-style: none;
    position: relative;
    width: 1024px;
    height: 365px;
    margin: 0 auto;
    padding: 0;
    border-bottom: 3px solid #D02323;
}

.bc-slider img {
    max-width: 100%;
}

.bc-slider li {
    display: none;
    position: absolute;
    width: 100%;
    height: 100%;
    top: 0;
    left: 0;
    padding: 0;
    margin: 0;
}

/* Timebar */
.bc-slider_timer {
    background-color: #d02323;
    width: 0%;
    height: 3px;
    position: absolute;
    left: 0;
    bottom: 0;
    /*opacity: 0.5;
    -moz-box-shadow: 0px 2px 2px black;
    -webkit-box-shadow: 0px 2px 2px black;
    -o-box-shadow: 0px 2px 2px black;
    box-shadow: 0px 2px 2px black;*/
}

/* Progress bar preloader container */
.bc-slider_preloader {
    background: rgba(255, 255, 255, 0.5);
}

/* progress bar preloader */
.bc-slider_preloader .bc-slider_progress {
    width: 30%;
    height: 5px;
    margin: 0 auto;
    border-top: 1px solid #7c7c7c;
    border-bottom: 1px solid #f1f1f1;
    border-left: 1px solid #949494;
    border-right: 1px solid #949494;
    background: -webkit-gradient(linear, 50% 0%, 50% 100%, color-stop(0%, #9a9a9a), color-stop(100%, #b3b3b3));
    background: -webkit-linear-gradient(#9a9a9a, #b3b3b3);
    background: -moz-linear-gradient(#9a9a9a, #b3b3b3);
    background: -o-linear-gradient(#9a9a9a, #b3b3b3);
    background: -ms-linear-gradient(#9a9a9a, #b3b3b3);
    background: linear-gradient(#9a9a9a, #b3b3b3);
}

/* progress bar fill */
.bc-slider_preloader .bc-slider_progress span {
    display: block;
    height: 100%;
    background: #66cccc;
}


.bc-slider_layers {
    position: absolute;
    width: 60%;
    height: 100%;
    overflow: hidden;
    display: table;
    top: 0;
    bottom: 0;
    right: 0;
    left: 0;
}

.slide_bottom {
    display: table-cell !important;
    vertical-align: middle;
    padding-left: 115px;

}

.slide_bottom h1 {
    font-family: 'Helvetica Neue 95', Arial, sans-serif;
    font-weight: 900;
    font-size: 30px;
    line-height: 32px;
    text-transform: uppercase;
    color: #fff;
    margin-top: 0px;
}

.slide_bottom h2 {
    font-family: 'Helvetica Neue 55', Arial, sans-serif;
    font-weight: 300;
    font-size: 24px;
    line-height: 25px;
    color: #fff;
    margin-bottom: 30px !important; /*10px offset fix actual margin equals 20px */
}

/* Hand cursor over navigation elements */
.bc-slider_navigation {
    cursor: pointer;
}

/* Tooltip panel */
.bc-slider_caption {
    position: absolute;
    bottom: 10px;
    left: 0;
    font-family: "Helvetica neue", Helvetica, Verdana, sans-serif;
    text-shadow: black 0 1px 0;
    padding: 10px 0px;
    width: 100%;
    background-color: #373737;
    border-top: 1px solid #545454;
    border-bottom: 1px solid #545454;
    filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=80);
    opacity: 0.8;
    color: white;
    text-align: center;
    font-size: 13px;
}

/* play, pause, previous and next elements */
.bc-slider_pause, .bc-slider_play, .bc-slider_left, .bc-slider_right {
    text-indent: -119988px;
    overflow: hidden;
    text-align: left;
    position: absolute;
    display: block;
    border-radius: 50% !important;
    background: url("../../img/CMI-WebIcon-Sprite.png") no-repeat scroll #e6e6e6;
}

/* previous and next elements hover state */
.bc-slider_left:hover {
    background-color: white;
}

.bc-slider_right:hover {
    background-color: white;
}

/* previous and next elements */
.bc-slider_left, .bc-slider_right {
    width: 35px;
    height: 35px;
    margin-top: -32px;
    top: 50%;
}

/* previous */
.bc-slider_left {
    background-position: -1px -283px;
    left: 15px;
    -ms-transform: rotate(180deg); /* IE 9 */
    -webkit-transform: rotate(180deg); /* Chrome, Safari, Opera */
    transform: rotate(180deg);
}

/* next */
.bc-slider_right,
.bc-slider_right:hover {
    background-position: -1px -283px;
    right: 15px;
}

/* bullet indicator */
.bc-slider_indicator {
    position: absolute;
    bottom: 7px;
    left: 0;
    width: 100%;
    text-align: center;
    _text-align: right;
    *text-align: right;
}

.bc-slider_indicator a {
    text-indent: -119988px;
    overflow: hidden;
    text-align: left;
    display: -moz-inline-box;
    -moz-box-orient: vertical;
    display: inline-block;
    vertical-align: middle;
    *vertical-align: auto;
    cursor: pointer;
    margin: 3px;
    width: 11px;
    height: 11px;
    border-radius: 50% !important;
    background-position: 0 -238px;
}

.bc-slider_indicator a {
    *display: inline;
    background: none repeat scroll 0 0 transparent;
    border: 2px solid #fff;
    height: 12px;
    width: 12px;
    border-radius: 50% !important;
    margin-right: 15px;
}

.bc-slider_indicator a:hover {
    background: none repeat scroll 0 0 #D02323;
    border-radius: 50% !important;
    cursor: pointer;
    display: inline-block;
    height: 12px;
    width: 12px;
    margin: 3px;
    border: none;
    position: relative;
    margin-right: 15px;

}

.bc-slider_indicator_active:after {
    background: none repeat scroll 0 0 #fff;
    border-radius: 50% !important;
    content: "";
    height: 8px;
    left: 2px;
    position: absolute;
    top: 2px;
    width: 8px;
}

.bc-slider_indicator a.bc-slider_indicator_active {
    background: none repeat scroll 0 0 #fff;
    border-radius: 50% !important;
    cursor: pointer;
    display: inline-block;
    height: 12px;
    width: 12px;
    margin: 3px;
    position: relative;
    margin-right: 15px;
}

@media all and (max-width: 800px) {
    .slide_bottom {
        position: relative !important;
        vertical-align: middle;
    }

    .slide_bottom h1 {
        font-family: 'Helvetica Neue 95', Arial, sans-serif;
        font-weight: 900;
        font-size: 30px;
        line-height: 32px;
        font-size: 3.9vw;
        line-height: 3.9vw;
        text-transform: uppercase;
        color: #fff;
        margin-top: 0px;
    }

    .slide_bottom h2 {
        font-family: 'Helvetica Neue 55', Arial, sans-serif;
        font-weight: 300;
        font-size: 24px;
        line-height: 25px;
        font-size: 2.9vw;
        line-height: 2.9vw;
        color: #fff;
        margin-bottom: 9% !important;
        margin-top: 0px !important;
    }

    .slide_bottom .special-action-btn {
        font-family: 'Helvetica Neue 55', Arial, sans-serif;
        font-size: 15px;
        /*font-size:1.9vw;*/
        padding: 3% 2%;
        height: 35px;
    }

    .banner-close {
        display: none;
    }
}

@media all and (max-width: 320px) {
    .breadcrumb-component .container {
        padding-right: 15px;
        padding-left: 15px;
    }

    .slide_bottom {
        padding-left: 65px;
        top: 5%;

    }

    .slide_bottom h1 {
        font-family: 'Helvetica Neue 95', Arial, sans-serif;
        font-weight: 900;
        font-size: 14px;
        line-height: 15px;
        text-transform: uppercase;
        color: #fff;
        margin-top: 0px;
    }

    .slide_bottom h2 {
        font-family: 'Helvetica Neue 55', Arial, sans-serif;
        font-weight: 300;
        font-size: 12px;
        line-height: 13px;
        color: #fff;
        margin-bottom: 10px !important;
        margin-top: 10px;
        width: 215px;
    }

    .slide_bottom .special-action-btn {
        font-family: 'Helvetica Neue 55', Arial, sans-serif;
        font-size: 10px;
        padding: 5px 5px;
        height: 35px;
    }

    .bc-slider_indicator,
    .bc-slider_left,
    .bc-slider_right {
        display: none;
    }

    .banner-close {
        display: block;
        position: absolute;
        left: 90%;
        top: 2%;
        z-index: 99999;
    }

}
