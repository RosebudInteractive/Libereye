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
