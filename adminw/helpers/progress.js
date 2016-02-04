/**
 * Object for progress
 */
define([], function(){

    var inits  = {};

    function _init(id) {
        if (!inits[id]) {
            inits[id] = webix.extend($$(id), webix.ProgressBar);
        }
    }

    function _showProgress(id){
        if (!inits.id) _init(id);
        $$(id).disable();
        $$(id).showProgress({
            type:"icon",
            delay:3000
        });
    }
    function _hideProgress(id){
        $$(id).enable();
        $$(id).hideProgress();
    }

    return {
        show:_showProgress,
        hide:_hideProgress
    }
});