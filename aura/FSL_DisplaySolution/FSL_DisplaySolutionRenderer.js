({
    afterRender: function (component, helper) {
        this.superAfterRender();
        console.log('after rerender');
        // interact with the DOM here
    }
    
})