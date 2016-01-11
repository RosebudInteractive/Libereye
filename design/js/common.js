$(function() {

    // временная зона на клиенте
    if (!$.cookie('timezone') || $.cookie('timezone') != new Date().getTimezoneOffset()) {
        $.cookie('timezone', new Date().getTimezoneOffset());
        location.reload();
    }


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


    $('.shopper-form').each(function(){
        var form = $(this);
        var shopperId = $(this).data('shopper');
        form.find('.form-page-3 .error-block').hide();

        form.find('.meeting-confirm').off('click').click(function(e){
            e.preventDefault();
            var emailText = $(this).parents('.form-page').find('[name="email"]').val();
            var explainText = $(this).parents('.form-page').find('[name="info"]').val();
            var date = $(this).parents('.form-page').find('[name="date"]').val();
            var time = $(this).parents('.form-page').find('.time-text').html();
            var that = this;
            var errors = [];
            if (!validateEmail(emailText)) errors.push('Введите E-mail');
            if (!explainText.length) errors.push('Введите цель митинга');

            if (errors.length == 0) {

                $.ajax({
                    method: "POST",
                    url: document.location,
                    data: { act: "booking", seller: shopperId, date:date+' '+time+':00', email:emailText, description:explainText }
                })
                    .done(function( msg ) {
                        var results = JSON.parse(msg);
                        if (results.errors && results.errors.length != 0) {
                            var errorBlock = form.find('.form-page-3 .error-block');
                            errorBlock.html(results.errors.join('<br>'));
                            errorBlock.show();
                        } else {
                            form.find('.email-text').html(emailText);
                            form.find('.explain-text').html(explainText);
                            form.find('.form-page-3').hide();
                            form.find('.form-page-4').show();
                            $(that).parents('.shop-meetings-form').find('.tab-control.active .shopper-slots').addClass('done');
                        }
                    });
            } else {
                var errorBlock = form.find('.form-page-3 .error-block');
                errorBlock.html(errors.join('<br>'));
                errorBlock.show();
            }
        });
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

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

