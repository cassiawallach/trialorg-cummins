/* 
    Requires a <div id="custom-modal-container"/> on the page.
    data = {
        headerString: 'The text that goes in the modal header.', // Optional
        bodyStringArray: [ // required
            'The text that goes in the body.',
            'Each new item in the array is a new paragraph.'
        ],
        showCancelButton:  false, // Optional, defaults to false
        cancelButtonString: 'Cancel', // Optional, defaults to 'Cancel'
        confirmButtonString: 'Ok' // Optional, defaults to 'Ok'
    }
*/
function genModalHTML(data) {
    const bodyStringArray = data.bodyStringArray || [];
    return `<div>
                <style>
                    /* ~~~ Vars ~~~ */
                    :root {
                        --border-radius: 6px;
                        --border-radius-small: 4px;
                        --border-width: 1px;
                        --border-width-large: 2px;
                        --modal-width: 800px;
                        --outer-box-shadow: 0 3px 9px rgba(0,0,0,.5);
                        --box-shadow: 0 2px 3px 0 rgba(0, 0, 0, 0.16);
                        --border-color: rgb(221, 219, 218);
                        --bg-color: #ffffff;
                        --backdrop-z-index: 10000;
                        --padding-large: 16px;
                        --padding-medium: 12px;
                        --padding-small: 10px;
                    }


                    /* ~~~ Backdrop ~~~ */
                    .custom-backdrop {
                        position: fixed;
                        top: 0;
                        right: 0;
                        bottom: 0;
                        left: 0;
                        background-color: rgba(255, 255, 255, 0.75);
                        visibility: visible;
                        opacity: 1;
                        transition: opacity .2s ease,visibility 0s;
                        transition-delay: 0s, 0s;
                        transition-delay: 0s,.3s;
                        z-index: var(--backdrop-z-index);
                        text-align: center;
                    }


                    /* ~~~ Modal ~~~ */
                    .custom-backdrop .custom-modal-content {
                        position: fixed;
                        background-color: var(--bg-color);
                        background-clip: padding-box;
                        border: var(--border-width) solid #999;
                        border: var(--border-width) solid rgba(0,0,0,.2);
                        border-radius: var(--border-radius);
                        -webkit-box-shadow: var(--outer-box-shadow);
                        box-shadow: var(--outer-box-shadow);
                        outline: 0;
                        transition: transform .3s ease-out,-webkit-transform .3s ease-out,-o-transform .3s ease-out;
                        width: var(--modal-width);
                        left: calc(50% - var(--modal-width)/2);
                        top: 100px;
                        text-align: left;
                    }


                    /* ~~~ Header ~~~ */
                    .custom-backdrop .custom-modal-content h3.custom-modal-header {
                        position: relative;
                        border-top-right-radius: var(--border-radius);
                        border-top-left-radius: var(--border-radius);
                        border-bottom-width: var(--border-width-large);
                        border-bottom-style: solid;
                        border-bottom-color: var(--border-color);
                        background-color: var(--bg-color);
                        padding: var(--padding-small);
                        text-align: center;
                        font-size: 16px;
                        line-height: 20px;
                    }


                    /* ~~~ Body ~~~ */
                    .custom-backdrop .custom-modal-content .custom-modal-body {
                        border-top-right-radius: var(--border-radius);
                        border-top-left-radius: var(--border-radius);
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-body {
                        -webkit-box-shadow: var(--box-shadow);
                        box-shadow: var(--box-shadow);
                        padding: var(--padding-large);
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-body p {
                        margin: 4px 0;
                    }


                    /* ~~~ Footer ~~~ */
                    .custom-backdrop .custom-modal-content .custom-modal-footer {
                        border-bottom-right-radius: var(--border-radius);
                        border-bottom-left-radius: var(--border-radius);
                        border-top-width: var(--border-width-large);
                        border-top-style: solid;
                        border-top-color: var(--border-color);
                        background-color: rgb(243, 242, 242);
                        padding: var(--padding-medium) var(--padding-large);
                        text-align: right;
                        -webkit-box-shadow: var(--box-shadow);
                        box-shadow: var(--box-shadow);
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-footer button {
                        position: relative;
                        display: inline-flex;
                        align-items: center;
                        padding: 0 var(--padding-large);
                        background: none;
                        background-clip: border-box;
                        border-style: solid;
                        border-width: var(--border-width);
                        border-radius: var(--border-radius-small);
                        line-height: 30px;
                        text-decoration: none;
                        color: rgba(1, 118, 211, 1);
                        -webkit-appearance: none;
                        white-space: normal;
                        user-select: none;
                        cursor: pointer;
                        text-align: center;
                        vertical-align: middle;
                        justify-content: center;
                        transition: border .15s linear;
                        min-width: 76px;
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-confirm {
                        background-color: #0070d2;
                        border-color: #0070d2;
                        color: var(--bg-color);
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-confirm:focus,
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-confirm:hover {
                        background-color: #005fb2;
                        border-color: #005fb2;
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-cancel {
                        background-color: var(--bg-color);
                        border-color: #dddbda;
                        color: #005fb2;
                    }
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-cancel:focus,
                    .custom-backdrop .custom-modal-content .custom-modal-footer button#custom-modal-cancel:hover {
                        background-color: #f4f6f9;
                    }
                </style>
                <div class="js-custom-backdrop custom-backdrop">
                    <div class="custom-modal-content">
                        ${genHeaderHTML(data)}
                        <div class="custom-modal-body">
                            ${
                                bodyStringArray.map( text => {
                                    return `<p>${text}</p>`;
                                }).join(' ')
                            }
                        </div>
                        <div class="custom-modal-footer">
                            <div>
                                ${genCancelHTML(data)}
                                <button id="custom-modal-confirm" type="button">
                                    ${data.confirmButtonString || 'OK'}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>`;
}
function genHeaderHTML(data){
    if (!data.headerString) {
        return '';
    } else {
        return `<h3 class="custom-modal-header">${data.headerString}</h3>`;
    }
}

function genCancelHTML(data){
    if (!data.showCancelButton) {
        return '';
    } else {
        return `<button id="custom-modal-cancel" type="button">
                    ${data.cancelButtonString || 'Cancel'}
                </button>`;
    }
}


window.openCustomModal = data => {
    document.getElementById('custom-modal-container').innerHTML = genModalHTML(data);
    return new Promise((resolve,reject) => {
        const modalCancel = document.getElementById('custom-modal-cancel');
        if (modalCancel) {
            modalCancel.addEventListener('click', () => {
                reject();
                closeCustomModal();
            },{
                once: true // make sure it cleans itself up
            });
        }

        const modalConfirm = document.getElementById('custom-modal-confirm');
        modalConfirm.addEventListener('click', () => {
            resolve();
            closeCustomModal();
        },{
            once: true // make sure it cleans itself up
        });
    });
};

// Leave this on the window in case it needs to be closed programatically elsewhere
window.closeCustomModal = () => {
    document.getElementById('custom-modal-container').replaceChildren();
};

