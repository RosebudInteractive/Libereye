/**
 * Object for manage grid
 */
define([], function(){

    function _refresh(grid, url) {
        grid.clearSelection();
        grid.clearAll();
        grid.load(url);
    }

    return {
        refresh:_refresh
    }
});