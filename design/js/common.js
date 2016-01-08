$(function() {
    // загрузка новостей
    var page = 1;
    $('a.more-news').click(function(e) {
        e.preventDefault();
        var self = $(this);
        if (!self.hasClass('loading')) {
            self.addClass('loading');
            $.ajax({
                method: "POST",
                url: document.location,
                data: { act: "getNews", page: ++page }
            })
                .done(function( msg ) {
                    self.removeClass('loading');
                    var row = $('<div class="news-list row"/>');
                    row.append(msg);
                    $('.news-list').last().after(row);
                });
        }
        return false;
    });

    // часы
    var timezones = ['Europe/London', 'Europe/Paris'];
    $('.clock').each(function(i){
        var self = $(this);
        self.prepend('<ul><li class="hour"></li><li class="min"></li></ul><span class="time"></span>');
        var $hour = self.find('.hour');
        var $min = self.find('.min');
        var $time = self.find('.time');
        setInterval( function() {
            var date = moment().tz(timezones[i]);
            var hours = date.hours();
            var mins = date.minutes();
            var hdegree = hours * 30 + (mins / 2);
            var hrotate = "rotate(" + hdegree + "deg)";
            $hour.css({"-moz-transform" : hrotate, "-webkit-transform" : hrotate});
            var mdegree = mins * 6;
            var mrotate = "rotate(" + mdegree + "deg)";
            $min.css({"-moz-transform" : mrotate, "-webkit-transform" : mrotate});
            $time.html(date.format('hh:mm'));
        }, 1000);
    });

    // Search
    var brandInput = $('#brand-input');
    brandInput.off('keyup').on('keyup', function(){
        if ($(this).val().length > 0) {
            var searchWrap = $('.search-result-wrap');
            var that = this;
            // Make ajax request if needed
            $.ajax({
                method: "POST",
                url: "/visitor/index.php/part_ajax/sect_getbrands/",
                data: { q: $(this).val(), lang: LANGUAGE }
            })
                .done(function( msg ) {
                    var results = JSON.parse(msg);
                    var resultsCount = results.length;
                    var $result = searchWrap.find('.search-result');
                    $result.empty();
                    for(var i in results) {
                        var span = $('<a class="search-item"/>').html(results[i]);
                        $result.append(span);
                    }
                    // On success attach items with class "search-item" to $('.search-input-wrap .search-result')
                    if (resultsCount > 0) {
                        searchWrap.removeClass('empty').slideDown(200, function() { $result.jScrollPane({autoReinitialise: true})});
                    } else {
                        searchWrap.addClass('empty').slideDown(200, function() { $result.jScrollPane({autoReinitialise: true})});
                    }
                });
        }
    });
    brandInput.off('blur').on('blur', function(){
        setTimeout(function(){ $('.search-result-wrap').slideUp(200); }, 500);
    });

});

// описание магазина
function showFull(link, obj) {
    if ($(obj).is(':visible')) {
        $(obj).css('display', 'none');
        $('#shop-description').css('max-height', '200px');
    } else {
        $(obj).css('display', 'inline');
        $('#shop-description').css('max-height', null);
    }
    return false;
}
