({
    init : function(component, event, helper) {
        document.title = "Your Title";
        var pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__User_Tools'
            }
        };
        component.set("v.pageReference", pageReference);
        document.title = 'Custom Trainer Title';
    },
    
    handleClick: function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var navService = component.find("navService");
        workspaceAPI
        .isConsoleNavigation()
        .then(function(isConsole) {
            if (isConsole) {
                // in a console app - generate a URL and then open a subtab of the currently focused parent tab
                workspaceAPI.openTab({
                    pageReference: {
                        type: 'standard__component',
                        attributes: {
                            componentName: 'c__FSL_User_Tools'
                        }
                    },
                    focus: true
                }).then(function(response) {
                    console.log('::: response - '+response);
                    workspaceAPI.setTabLabel({
                        tabId: response ? response : 'User Tools',
                        label: 'User Tools'
                    })
                }) 
            } else {
                // this is standard navigation, use the navigate method to open the component
                navService.navigate(pageReference, false);
            }
        });
    },
    
    
    openTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/apex/User_Tools',
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
                console.log("The recordId for this tab is: " + tabInfo.recordId);
            });
        }).catch(function(error) {
            console.log('$$$$$'+error);
        });
    }
    
})