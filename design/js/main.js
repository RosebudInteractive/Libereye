$(function() {
        $('#slides-container').cycle({
            //	speed:		0,
            //	timeout:	0,
            fx:			'scrollHorz',
            speed:		1000,
            timeout:	5000,
            'auto-height': 1,
            slides:     '> .slide',
			continueAuto: false,
            //	pause:		1,
            pager:		'#pages',
            pagerAnchorBuilder: function(idx, slide) {
                return '<li><a href="#">' + ++idx + '</a></li>';
            }
        }).css('visibility','visible');
        //$('video').get(0).play()

    // Modal open
    $('a.menu-activator').click(function(e){
        e.preventDefault();
        var body = $('body');
        var header = $('.header');
        // Change activator
        $('.menu-activator').hide(0, function(){
            $('a.close-menu').show();
        });


        if ($('.modal-overlay').length == 0)
            body.append('<div class="modal-overlay"><div class="overlay-menu"></div></div>');

        body.addClass('modal-open');
        var started = false;
        $('.modal-overlay').animate(
            {
                opacity: 1
            },
            {
                duration: 450,
                step: function(now, elem) {
                    if (now > 0.95) {
                        header.css({'z-index': 122});
                        showMenu(started);
                        started = true;
                    }

                },
                complete: function(){
                    // menu open
                }
            }
        );

    });

    var showMenu = function(started) {
        if (started)
            return;

        var links = [];
        $('.main-menu a').each(function(){
            links.push($(this)[0].outerHTML);
        });
        var overlayMenu = $('.overlay-menu');
        if (overlayMenu.length > 0) {
            var i = 0;
            for (var x in links) {
                var link = $('<div class="overlay-link-wrap">'+links[x]+'</div>');
                console.log(link);
                link.find('a').css({'opacity':0}).append('<span/>');
                link.appendTo(overlayMenu);

                link.find('a').delay(120 * i).animate(
                    {
                        opacity:1
                    },
                    {
                        start: function(){
                            $(this).parent().animate({top:'4px'},{duration:360});
                        },
                        complete: function(){
                            $(this).parent().find('span').animate({opacity:'.37'},{duration:210})
                        },
                        duration: 360,
                        easing: 'linear'
                    }
                );
                i++;
            }
        }
        console.log(links);
    };

    $('a.close-menu').click(function(e) {
        e.preventDefault();
        var body = $('body');
        var header = $('.header');
        header.css({'z-index':120});
        // Change activator
        $('.close-menu').hide(0, function () {
            $('a.menu-activator').show();
        });

        $('.modal-overlay').animate({
                opacity: 0
            },
            {
                duration: 450,
                complete: function(){
                    $(this).remove();
                    body.removeClass('modal-open');
                }
            }
        );
    });

    $('span.pie').peity('pie', {radius: 30, fill: ["#e6e6e6", "#ffffff", "#00ff00"]});
    var filledPies = $('circle[fill="#e6e6e6"]').parent();
    filledPies.next('.pie-text').css({'color':'#fff'});
    filledPies.parent().addClass('filled');

    // tabs
    var tabsContainer = $('.tabs-container');
    tabsContainer.find('.tabs > div').hide();
    var tabToOpen = tabsContainer.find('.tab-control.active').data('tab');
    tabsContainer.find(tabToOpen).show();
    $('.tab-control').click(function(e){
        e.preventDefault();

        $('.tab-control').removeClass('active');
        $(this).addClass('active');

        var tabToOpen = $(this).data('tab');
        $(this).parents('.tabs-container').find('.tabs > div').hide();
        $(this).parents('.tabs-container').find(tabToOpen).show();

    });


    // meeting form
    var dayText = '';
    var selectedTime = '';
    var shopperId = 0;
    var explainText = '';
    var emailText = '';
    $('.shopper-form .form-page').hide();
        // init
    $('.shopper-form').each(function(){
        var form = $(this);
        shopperId = $(this).data('shopper');

        form.find('.form-page-1').show();

        // events
        form.find('.pie-wrap').not('.filled').find('.pie-text').click(function(){
            dayText = $(this).data('text');
            form.find('.day-text').html(dayText);
            form.find('.form-page-1').hide();
            form.find('.form-page-2').show();
        });

        form.find('.times .time').click(function(){
            selectedTime = $(this).data('value');

            form.find('.time-text').html(selectedTime);
            form.find('.form-page-2').hide();
            form.find('.form-page-3').show();
        });

        form.find('.meeting-confirm').click(function(e){
            e.preventDefault();
            emailText = $(this).parents('.form-page').find('[name="email"]').val();
            explainText = $(this).parents('.form-page').find('[name="info"]').val();

            form.find('.email-text').html(emailText);
            form.find('.explain-text').html(explainText);

            form.find('.form-page-3').hide();
            form.find('.form-page-4').show();

            $(this).parents('.shop-meetings-form').find('.tab-control.active .shopper-slots').addClass('done');


            // collect data and submit form

        });
    });
    $('.controls .prev a').click(function(e){
        e.preventDefault();
        var pageTo = $(this).data('page');
        var form = $(this).parents('.shopper-form');

        $(this).parents('.form-page').hide();
        form.find('.form-page-' + pageTo).show();
    });
    $('.controls .cancel a').click(function(e){
        e.preventDefault();
        var form = $(this).parents('.shopper-form');

        $(this).parents('.form-page').hide();
        form.find('.form-page-1').show();
    });

    // Search
    $('#brand-input').on('keyup', function(){
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
    $('#brand-input').on('blur', function(){
        setTimeout(function(){ $('.search-result-wrap').slideUp(200); }, 500);
    });

        // Departments
    $('.departments-list a').click(function(e){
        e.preventDefault();

        var name = $(this).find('span').clone();
        var img = $(this).find('img').clone();
        var departmentId = $(this).data('department');

        var selectedDepartment = $('.shop-departments .selected-department');
        selectedDepartment.find('.department-title').append(img).append(name);

        var list = $('<ul/>');
        if (typeof departmentId != "undefined" && typeof departmentsData != "undefined") {
            for (var x in departmentsData[departmentId]) {
                console.log(departmentsData[departmentId][x]);
                list.append('<li>'+departmentsData[departmentId][x]+'</li>');
            }
        }
        selectedDepartment.find('.department-list').append(list);
        selectedDepartment.show();
    });
    $('a.close-department').click(function(e){
        e.preventDefault();
        var selectedDepartment = $('.shop-departments .selected-department');
        selectedDepartment.hide();
        selectedDepartment.find('.department-title').html('');
        selectedDepartment.find('.department-list').html('');
    });


    var slider = $('.left-column .left-slider');
    $(window).bind('resize scroll',function(){
        if (window.innerWidth < 950) {
            slider.css({'position':'static'});
        } else if ($(this).scrollTop() + slider.height() + 124 < ($(document).height() - ($('.container.footer').height() + $('.container.footer-bottom').height() + 115 + 33))) {
            var scrolled = $(window).scrollTop();
            slider.css({'position': 'relative'/*, 'top': scrolled + 'px'*/}).stop().animate({top: scrolled + 'px'});
        }
    });

    var gallery = $('.gallery .images');
    gallery.jScrollPane({autoReinitialise: true});

});
