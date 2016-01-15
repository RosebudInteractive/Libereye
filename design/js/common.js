$(function() {

    //$.cookie('timezone', 0);

    // временная зона на клиенте
    var timezone = getTimezones();
    if (!$.cookie('timezone') || $.cookie('timezone') != timezone) {
        $.cookie('timezone', timezone);
        if ($.cookie('timezone') == timezone)
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


    var formData = {}; // данные для повторного письма
    $('.shopper-form').each(function(){
        var form = $(this);
        var shopperId = $(this).data('shopper');
        form.find('.form-page-3 .error-block').hide();

        form.find('.form-page-4 .not-get-mail').off('click').click(function(e){
            e.preventDefault();
            formData.act = 'resend';
            $.ajax({
                method: "POST",
                data: formData
            })
                .done(function( msg ) {
                    var results = JSON.parse(msg);
                    if (results.errors && results.errors.length != 0) {
                        form.find('.form-page-4 .success-block').hide();
                        form.find('.form-page-4 .error-block').html(results.errors.join('<br>')).show();
                    } else {
                        form.find('.form-page-4 .error-block').hide();
                        form.find('.form-page-4 .success-block').html(results.message).show();
                    }
                });
        });

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
                formData = {seller: shopperId, date:date+' '+time+':00', email:emailText, description:explainText};
                formData.act = 'booking';
                $.ajax({
                    method: "POST",
                    url: document.location.pathname,
                    data: formData
                })
                    .done(function( msg ) {
                        var results = JSON.parse(msg);
                        if (results.errors && results.errors.length != 0) {
                            var errorBlock = form.find('.form-page-3 .error-block');
                            errorBlock.html(results.errors.join('<br>'));
                            errorBlock.show();
                        } else {
                            formData.id = results.id;
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

function getTimezones() {
    var dates = [];
    var currTime = (new Date()).getTime();
    for(var i=currTime; i<currTime+7*86400000; i+=86400000) {
        var date = new Date(i);
        dates.push(moment(date).format('YYYY-MM-DD')+':'+date.getTimezoneOffset());
    }
    return dates.join(';');
}

function fbQuery(action) {
    FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
            var accessToken = response.authResponse.accessToken;
            tryLogin({act:'facebook_'+action, token:accessToken});
        } else {
            // the user isn't logged in to Facebook.
            FB.login(function(response) {
                if (response.authResponse) {
                    var accessToken = response.authResponse.accessToken;
                    tryLogin({act:'facebook_'+action, token:accessToken});
                }
            },{scope: 'email'});
        }
    });
    return false;
}

function vkQuery(action) {
    VK.Auth.getLoginStatus(function(response) {
        if (response.session) {
            /* Авторизованный в Open API пользователь */
            var data = {act:'vk_'+action, session:response.session};
            tryLogin(data);
        } else {
            /* Неавторизованный в Open API пользователь */
            VK.Auth.login(function(response) {
                if (response.session) {
                    /* Пользователь успешно авторизовался */
                    var data = {act:'vk_'+action, session:response.session};
                    tryLogin(data);
                } else {
                    /* Пользователь нажал кнопку Отмена в окне авторизации */
                }
            }, 4194304);
        }
    });
    return false;
}

function tryLogin(data) {
    $.ajax({
        method: "POST",
        url: '/'+LANGUAGE+'/register/',
        data: data
    })
        .done(function( msg ) {
            var results = JSON.parse(msg);
            if (results.errors && results.errors.length != 0) {
                $('.overlay-content .error-block').html(results.errors.join('<br>')).show();
            } else {
                location.reload();
            }
        });
}

function isValidDate(d) {
    if ( Object.prototype.toString.call(d) !== "[object Date]" )
        return false;
    return !isNaN(d.getTime());
}

// =========================== Facebook init ========================
window.fbAsyncInit = function() {
    FB.init({
        appId      : apiConfigJson.facebook_app_id, //'554808964685579',
        xfbml      : true,
        version    : 'v2.5'
    });
};

(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
// =========================== Facebook init ========================

// =========================== VK init ==============================
VK.init({
    apiId: apiConfigJson.vk_app_id // 5227859
});
// =========================== VK init ==============================

// =========================== google init ==============================

function googleQuery(action) {
    var clientId = apiConfigJson.google_client_id; //'958156450156-vq1irfc7amfeb240r4bspfd0b3pguhaj.apps.googleusercontent.com';
    var scopes = ['https://www.googleapis.com/auth/userinfo.email','https://www.googleapis.com/auth/userinfo.profile'];
    gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, function(authResult1){
        if (authResult1 && !authResult1.error) {
            var data = {act:'google_'+action, session:authResult1};
            tryLogin(data);
        } else {
            gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, function(authResult2){
                if (authResult2 && !authResult2.error) {
                    var data = {act:'google_'+action, session:authResult2};
                    tryLogin(data);
                }
            });
        }
    });
    return false;
}

// Use a button to handle authentication the first time.
function handleClientLoad() {
    var apiKey = apiConfigJson.google_app_id;//'AIzaSyBxofvhjTDmlxHcXFzAGvHyS0kjMRthd_A';
    gapi.client.setApiKey(apiKey);
}

// Load the API and make an API call.  Display the results on the screen.
function makeApiCall() {
    gapi.client.load('plus', 'v1', function() {
        var request = gapi.client.plus.people.get({
            'userId': 'me'
        });
        request.execute(function(resp) {
            var heading = document.createElement('h4');
            var image = document.createElement('img');
            image.src = resp.image.url;
            heading.appendChild(image);
            heading.appendChild(document.createTextNode(resp.displayName));

            document.getElementById('content').appendChild(heading);
        });
    });
}
// =========================== google init ==============================