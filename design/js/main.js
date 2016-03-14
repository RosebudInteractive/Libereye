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
        //console.log(links);
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
    var dayDate = '';
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

            // if not logged
            if (!LOGGEDIN) {$('.login-init').click();return;}

            var clicked = $(this);
            dayText = clicked.data('daytext');
            dayDate = clicked.data('daydate');

            generateTimes(clicked, form);
            bindDayShiftEvents(clicked, form);


            form.find('.day-text').html(dayText + ' '+PHRASES['at']);
            form.find('[name="date"]').val(dayDate);
            form.find('.controls .day-text').html(dayText);
            form.find('.form-page-1').hide();
            form.find('.form-page-2').show();
        });

        form.on('click', '.times .time', function(){
            selectedTime = $(this).data('value');

            form.find('.time-text').html(selectedTime);
            form.find('.form-page-2').hide();
            form.find('.form-page-3 .error-block').hide();
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

            // Don't forget to get shopper ID.

        });

        form.on('click', 'a.time-toggle', function(e){
            e.preventDefault();
            var visible = $(this).closest('.form-page').find('.times:visible');
            var hidden = $(this).closest('.form-page').find('.times:hidden');
            visible.hide(); hidden.show();
        });


    });

    /**
     * @param clicked jQuery element .pie-text in this case
     * @param form jQuery element parent form
     */
    function generateTimes(clicked, form) {
        var dayText = clicked.data('daytext');

        // find out what time of day have been clicked: day or morning
        var clickedTOD = clicked.parents('tr').data('tod');
        var otherTOD = clickedTOD == 'morning' ? 'day' : 'morning';

        // Hide other TOD block
        var timesBlockClicked = form.find('.times.'+clickedTOD);
        timesBlockClicked.show();
        var timesBlockOther = form.find('.times.'+otherTOD);
        timesBlockOther.hide();

        // Generate times for clicked TOD
        var timesClicked = clicked.data('times');
        if (timesClicked.length == 0)
            timesClicked = [];
        else
            timesClicked = timesClicked.split(";");

        timesBlockClicked.empty();
        for (var x in timesClicked) {
            timesBlockClicked.append('<div class="time" data-value="'+timesClicked[x]+'">'+timesClicked[x]+'</div>')
        }

        // Generate times for other TOD
        var timesOther = clicked.closest('table').find('tr[data-tod="'+otherTOD+'"] .pie-text[data-daytext="'+dayText+'"]').data('times');

        if (timesOther.length == 0)
            timesOther = [];
        else
            timesOther = timesOther.split(";");

        timesBlockOther.empty();
        for (var i in timesOther) {
            timesBlockOther.append('<div class="time" data-value="'+timesOther[i]+'">'+timesOther[i]+'</div>')
        }

        // Some actions if times are booked

        if (timesClicked.length == 0 && timesOther.length == 0) {
            // both are empty
            // find next not empty date
            var countTimes = 0;
            var foundNoDates = false;
            var t = 0;
            var nextClicked = clicked;
            while (countTimes == 0 && t < 7) {
                countTimes = 0;

                nextClicked = nextClicked.closest('td').next('td').find('.pie-text');
                if (nextClicked.length == 0) {
                    foundNoDates = true;
                    break;
                }

                var toggleTOD = nextClicked.parents('tr').data('tod') == 'morning' ? 'day' : 'morning';

                // Find times for previously clicked row
                var foundTimes = nextClicked.data('times');
                if (foundTimes.length == 0)
                    foundTimes = [];
                else
                    foundTimes = foundTimes.split(";");

                countTimes += foundTimes.length;

                // Find times on other row
                foundTimes = nextClicked.closest('table').find('tr[data-tod="'+toggleTOD+'"] .pie-text[data-daytext="'+nextClicked.data('daytext')+'"]').data('times');
                if (foundTimes.length == 0)
                    foundTimes = [];
                else
                    foundTimes = foundTimes.split(";");

                countTimes += foundTimes.length;


                // emergency
                t++;
            }

            if (foundNoDates) {
                timesBlockClicked.empty();
                $('#meeting-form-no-time-at-all-title').tmpl().appendTo(timesBlockClicked);
            } else {
                timesBlockClicked.empty();
                $('#meeting-form-no-time-title').tmpl({"dayText": nextClicked.data('daytext')}).appendTo(timesBlockClicked);

                // append click event
                form.on('click', '.jump-to-date', function(e){
                    e.preventDefault();

                    generateTimes(nextClicked, form);
                    form.find('.day-text').html(nextClicked.data('daytext'));
                    form.find('.form-page-1').hide();
                    form.find('.form-page-2').show();
                });

                //
            }
        } else if (timesClicked.length > 0 && timesOther.length == 0) {
            // if clicked has times and other is empty
            // do nothing
        } else if (timesClicked.length == 0 && timesOther.length > 0) {
            // if clicked is empty and other has times
            timesBlockClicked.empty();
            $('#meeting-form-no-time-title-'+clickedTOD).tmpl().prependTo(timesBlockOther);
            timesBlockOther.show();
        } else {
            // both has times
            var todText = {"day": PHRASES['View daylight hours'], "morning": PHRASES['View morning']};
            timesBlockClicked.append('<a href="#" class="time-toggle">'+todText[otherTOD]+' ('+timesOther.length+')</a>')
            timesBlockOther.append('<a href="#" class="time-toggle">'+todText[clickedTOD]+' ('+timesClicked.length+')</a>')
        }

    }

    function findDay(day, direction) {

        if (direction == 'next')
            return day.closest('td').next('td').find('.pie-text');
        else if (direction == 'prev')
            return day.closest('td').prev('td').find('.pie-text');
        else
            return [];
    }

    function bindDayShiftEvents(currentDay, form) {

        var dayBackLink = form.find('a.prev-day');
        var dayForwardLink = form.find('a.next-day');

        // off click event
        form.off('click', 'a.prev-day');
        form.off('click', 'a.next-day');


        // find prev and next day
        var nextDay = findDay(currentDay, 'next');
        var prevDay = findDay(currentDay, 'prev');

        // set this data to elements
        dayBackLink.data('day-to', prevDay);
        dayForwardLink.data('day-to', nextDay);


        if (nextDay.length > 0) {
            dayForwardLink.show();
        } else
            form.find('a.next-day').hide();

        if (prevDay.length > 0) {
            dayBackLink.show();
        } else
            form.find('a.prev-day').hide();

        form.on('click', 'a.prev-day', function(e){
            e.preventDefault();
            if (typeof $(this).data('day-to') != "undefined")
                prevDay = $(this).data('day-to');
            else
                prevDay = findDay(findDay(nextDay, 'prev'), 'prev');

            generateTimes(prevDay, form);
            form.find('.day-text').html(prevDay.data('daytext') + ' '+PHRASES['at']);
            form.find('.controls .day-text').html(prevDay.data('daytext'));

            nextDay = findDay(prevDay, 'next');
            prevDay = findDay(prevDay, 'prev');
            if (prevDay.length == 0) {
                $(this).hide();
            } else {
                $(this).show();
                $(this).data('day-to', prevDay);
            }

            if (nextDay.length == 0) {
                dayForwardLink.hide()
            } else {
                dayForwardLink.show();
                dayForwardLink.data('day-to', nextDay);

                //console.log(nextDay);
            }
        });

        form.on('click', 'a.next-day', function(e){
            e.preventDefault();
            if (typeof $(this).data('day-to') != "undefined")
                nextDay = $(this).data('day-to');
            else
                nextDay = findDay(findDay(prevDay, 'next'), 'next');

            generateTimes(nextDay, form);
            form.find('.day-text').html(nextDay.data('daytext') + ' '+PHRASES['at']);
            form.find('.controls .day-text').html(nextDay.data('daytext'));

            prevDay = findDay(nextDay, 'prev');
            nextDay = findDay(nextDay, 'next');
            if (nextDay.length == 0) {
                $(this).hide();
            } else {
                $(this).show();
                $(this).data('day-to', nextDay);
            }

            if (prevDay.length == 0) {
                dayBackLink.hide()
            } else {
                dayBackLink.show();
                dayBackLink.data('day-to', prevDay);

                //console.log(prevDay);
            }
        });
    }


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
    var brandInput = $('#brand-input');
    brandInput.on('keyup', function(){
        if ($(this).val().length > 2) {
            var searchWrap = $('.search-result-wrap');

            // Make ajax request if needed

            var resultsCount = 2;
            // On success attach items with class "search-item" to $('.search-input-wrap .search-result')
            if (resultsCount > 0) {
                searchWrap.slideDown(200, function() { $(this).find('.search-result').jScrollPane({autoReinitialise: true})});
            } else {
                searchWrap.addClass('empty').slideDown(200, function() { $(this).find('.search-result').jScrollPane({autoReinitialise: true})});
            }
        }
    });
    brandInput.on('blur', function(){
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
                //console.log(departmentsData[departmentId][x]);
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


    var slider = $('.left-column .left-slider'), maxLeftScroll = 0;
    var setMaxLeftScroll = function() {
        maxLeftScroll = $(document).height() - $('.container.footer').height() - $('.container.footer-bottom').height() - slider.height() - 360;
    }
    var scrollLeft = function(){
        if (window.innerWidth < 950) {
            slider.css({'position':'static'});
        } else {
            var scrolled = $(window).scrollTop();
            if (scrolled >= maxLeftScroll)
                scrolled = maxLeftScroll;
            slider.css({'position': 'relative'/*, 'top': scrolled + 'px'*/}).stop().animate({top: scrolled + 'px'}, 300);
        }
    };
    $(window).scroll(scrollLeft);
    $(window).resize(function(){
        setMaxLeftScroll();
        scrollLeft();
    });
    setTimeout(setMaxLeftScroll, 20);
   // scrollLeft();

    var gallery = $('.gallery .images');
    gallery.jScrollPane({autoReinitialise: true});


    $('.login-init').click(function(e){
        e.preventDefault();
        showOverlay();

        $('#login-init').tmpl().appendTo('.overlay-content');

        $('#login').submit(function(e) {
            e.preventDefault();
            var errors = [];
            var form = $(this);
            var errorBlock = form.find('.error-block');
            errorBlock.html('');

            // Validate data
            var validation = true;
            $.each($(this).serializeArray(), function(){
                var inputBlock = form.find('input[name="'+this.name+'"]').parents('.input');
                if (this.name == 'email') {
                    // Add more conditions if needed
                    if (!validateEmail(this.value)) {
                        validation = false;
                        errors["name_empty"] = "Проверьте E-mail";
                        inputBlock.addClass('failed');
                        if (inputBlock.find('.input-error').length == 0) {
                            inputBlock.append('<div class="input-error">'+errors["name_empty"]+'</div>');
                        }
                        errorBlock.append(errors["name_empty"]+'<br/>');
                    } else {
                        inputBlock.removeClass('failed').addClass('success');
                    }
                }
                if (this.name == 'password') {
                    // Add more conditions if needed
                    if (this.value.length < 6) {
                        validation = false;
                        errors["password_empty"] = PHRASES['Enter the password'];
                        inputBlock.addClass('failed');
                        if (inputBlock.find('.input-error').length == 0) {
                            inputBlock.append('<div class="input-error">'+errors["password_empty"]+'</div>');
                        }
                        errorBlock.append(errors["password_empty"]+'<br/>');
                    } else {
                        inputBlock.removeClass('failed').addClass('success');
                    }
                }
            });

            if (validation == true) {
                // Make login
                var data = {act:'login', ajax:1};
                data.email = $('#inEmail').val();
                data.pass = $('#inPass').val();
                data.remember = $('#inRemember').is(':checked')?1:0;
                $.ajax({
                    method: "POST",
                    url: '/'+LANGUAGE+'/login/',
                    data: data
                })
                    .done(function( msg ) {
                        var results = JSON.parse(msg);
                        if (results.errors && results.errors.length != 0) {
                            $('.overlay-content .error-block').empty().html(results.errors.join('<br>')).show();
                        } else {
                            location.reload();
                        }
                    });
            } else {
                // show errors
            }

        });

        $('.overlay-submit input').click(function(e){
            e.preventDefault();
            $(this).parents('form').submit();
        });

        $('.overlay-content .overlay-login-href').click(function(){
            e.preventDefault();
            $('.registration-init').click();
        });

        setMargin($('.overlay-content'), 90);
    });

    $('.registration-init').click(function(e){
        e.preventDefault();
        showOverlay();

        $('#registration-init').tmpl().appendTo('.overlay-content');

        $('#email-registration').click(function(){
            e.preventDefault();
            showOverlay();

            $('#registration-form').tmpl().appendTo('.overlay-content');

            // добавляем года
            var currYear = (new Date()).getFullYear(), yearSelect = $('#inYear'), years='';
            for(var i=currYear; i>=currYear-100; i--) {
                years += '<option value="'+i+'">'+i+'</option>';
            }
            yearSelect.append(years);

            $('#registration').submit(function(e) {
                e.preventDefault();
                var errors = [];
                var form = $(this);
                var errorBlock = form.find('.error-block');
                errorBlock.html('');

                // Validate data
                var validation = true;
                $.each($(this).serializeArray(), function(){
                    //console.log(this);
                    var inputBlock = form.find('input[name="'+this.name+'"]').parents('.input');
                    if (this.name == 'name') {
                        // Add more conditions if needed
                        if (this.value.length == 0) {
                            validation = false;
                            errors["name_empty"] = PHRASES["Enter name"];
                            inputBlock.addClass('failed');
                            if (inputBlock.find('.input-error').length == 0) {
                                inputBlock.append('<div class="input-error">'+errors["name_empty"]+'</div>');
                            }
                            errorBlock.append(errors["name_empty"]+'<br/>');
                        } else {
                            inputBlock.removeClass('failed').addClass('success');
                        }
                    }
                    if (this.name == 'email') {
                        // Add more conditions if needed
                        if (!validateEmail(this.value)) {
                            validation = false;
                            errors["email_empty"] = PHRASES["Check Email"];
                            inputBlock.addClass('failed');
                            if (inputBlock.find('.input-error').length == 0) {
                                inputBlock.append('<div class="input-error">'+errors["email_empty"]+'</div>');
                            }
                            errorBlock.append(errors["email_empty"]+'<br/>');
                        } else {
                            inputBlock.removeClass('failed').addClass('success');
                        }
                    }
                    if (this.name == 'password') {
                        if (this.value.length < 6) {
                            validation = false;
                            errors["password_empty"] = PHRASES['Enter the password'];
                            inputBlock.addClass('failed');
                            if (inputBlock.find('.input-error').length == 0) {
                                inputBlock.append('<div class="input-error">'+errors["password_empty"]+'</div>');
                            }
                            errorBlock.append(errors["password_empty"]+'<br/>');
                        } else {
                            inputBlock.removeClass('failed').addClass('success');
                        }
                    }
                    if (this.name == 'password-check') {
                        if (this.value.length < 6) {
                            validation = false;
                            errors["password-check_empty"] = PHRASES["Enter password again"];
                            inputBlock.addClass('failed');
                            if (inputBlock.find('.input-error').length == 0) {
                                inputBlock.append('<div class="input-error">'+errors["password-check_empty"]+'</div>');
                            }
                            errorBlock.append(errors["password-check_empty"]+'<br/>');
                        } else {
                            if (this.value != $('#inPass').val()) {
                                validation = false;
                                errors["password-check_empty"] = PHRASES["Passwords do not match"];
                                inputBlock.addClass('failed');
                                if (inputBlock.find('.input-error').length == 0) {
                                    inputBlock.append('<div class="input-error">'+errors["password-check_empty"]+'</div>');
                                }
                                errorBlock.append(errors["password-check_empty"]+'<br/>');
                            } else {
                                inputBlock.removeClass('failed').addClass('success');
                            }
                        }
                    }
                });

                if (validation == true) {
                    var data = {act:'register', ajax:1};
                    data.fname = $('#inName').val();
                    data.email = $('#inEmail').val();
                    data.pass = $('#inPass').val();
                    data.pass_confirm = $('#inPass').val();
                    data.birthday = $('#inYear').val()+'-'+$('#inMonth').val()+'-'+$('#inDay').val();
                    $.ajax({
                        method: "POST",
                        url: '/'+LANGUAGE+'/register/',
                        data: data
                    })
                        .done(function( msg ) {
                            var results = JSON.parse(msg);
                            if (results.errors && results.errors.length != 0) {
                                $('.overlay-content .error-block').empty().html(results.errors.join('<br>')).show();
                            } else {
                                showOverlay();
                                $('#registration-success').tmpl({"email": form.find('input[name="email"]').val()}).appendTo('.overlay-content');
                            }
                        });
                } else {
                    // show errors
                }

            });

            $('.overlay-submit input').click(function(e){
                e.preventDefault();
                $(this).parents('form').submit();
            });

            setMargin($('.overlay-content'), 90);
        });

        $('.overlay-content .overlay-login-href').click(function(){
            e.preventDefault();
            $('.login-init').click();
        });

        setMargin($('.overlay-content'), 90);
    });



    function showOverlay () {
        var overlay = $('body .overlay');
        if (overlay.length == 0)
            $('body').append('<div class="overlay"><div class="overlay-fade"></div><div class="overlay-content form-standart"><a href="#" class="overlay-close"></a></div></div>');
        else
            $('body .overlay').find('.overlay-content').empty().append('<a href="#" class="overlay-close"></a>');

        overlay.show();

        $('.overlay .overlay-close, .overlay .overlay-fade').click(function(e){
            e.stopPropagation();
            e.preventDefault();
            $('body .overlay').fadeOut(400, function() {$(this).hide()});
        });
    }

    function setMargin(elem, margin) {
        var ocHeight = (elem.height()-0) + margin;
        elem.css({'margin-top': -ocHeight/2 + 'px'});
    }

    // basket functions ------------------------

    if (typeof jQuery.fn.select2 == 'function') {
        var $selects = $('.form-standart .select select');
        $selects.select2({minimumResultsForSearch: Infinity});

        /*$selects.on("select2:open", function (e) { console.log("select2:open", e);
         setTimeout(function(){
         var pane = $('ul.select2-results__options');
         pane.jScrollPane();
         },10);

         });
         $selects.on("select2:closing", function (e) {
         var pane = $('ul.select2-results__options');
         pane.data('jsp').destroy();
         });*/

        $(window).bind('resize',function(){
            $('.form-standart .select select').select2({minimumResultsForSearch: Infinity});
        });
    }

    $('.cart .hide-btn a').parents('.cart').click(function(e){
        e.preventDefault();
        if ($(e.target).hasClass('btn'))
            return;
        var cart = $(this)/*.parents('.cart')*/;
        var cartContent = cart.next('.cart-content');

        if (cart.hasClass('active')) {
            cartContent.slideUp(function(){
                cart.removeClass('active');
            });
        } else {
            cart.addClass('active');
            cartContent.slideDown();
        }
    });

    $('.cart-item-delete-link').click(function(e){
        e.preventDefault();
        var that = this, productId = $(this).data('product');
        $.ajax({
            method: "POST",
            data: {act:'delproduct', product:productId}
        })
            .done(function( msg ) {
                var results = JSON.parse(msg);
                if (results.errors && results.errors.length != 0) {
                    alert(results.errors.join("\n"));
                } else {
                    var item = $(that).parents('.cart-item');
                    var itemClone = item.clone(true);
                    item.html('').addClass('deleted');
                    $('#cart-item-deleted').tmpl({"name": item.data('name')}).appendTo(item);
                    item.find('.cart-item-restore').click(function(e){
                        e.preventDefault();
                        var that = this;
                        $.ajax({
                            method: "POST",
                            data: {act:'restoreproduct', product:productId}
                        })
                            .done(function( msg ) {
                                var results = JSON.parse(msg);
                                if (results.errors && results.errors.length != 0) {
                                    alert(results.errors.join("\n"));
                                } else {
                                    item.after(itemClone).remove();
                                }
                            });
                    })
                }
            });

    });

    $('.payment-type-select input').click(function(e){
        $('.payment-type-pages').hide();
        var page = $(this).data('page');
        $('#payment-type-page-' + page).show();
    });


    /*var widthToSet = $('.cart-list .cart').eq(0).width();
    $('.cart-content').width(widthToSet-30*2);
    $(window).bind('resize',function(){
        var widthToSet = $('.cart-list .cart').eq(0).width();
        $('.cart-content').width(widthToSet-30*2);
    });*/

    $('.cart-content').hover(function(){$(this).prev().addClass('hovered');},function(){$(this).prev().removeClass('hovered');})

    var $bpp = $('.basket-payment-page');
    var basketCheckoutPage = 1;
    if ($bpp.length) {
       // $bpp.not(':eq(0)').hide();

        // links handlers
        $('.basket-payment-goto').click(function(e){
            e.preventDefault();
            var toPage = $(this).data('page');
            var $stages = $('.payment-navigation');
            if (toPage.toString().length) {
                $bpp.hide();
                $('#basket-payment-page-' + toPage).show();
                $stages.find('.stage').removeClass('active');
                $stages.find('.stage-'+toPage).addClass('active');
                basketCheckoutPageChanged(toPage);
            }
        });

        function basketCheckoutPageChanged(toPage) {
            var $c = $('.content');
            //console.log(parseInt(toPage));
            if (isNaN(parseInt(toPage)))
                return false;

            $c.find('.co-stage-' + (toPage-1)).hide();
            $c.find('.co-stage-'+(toPage)).show();
        }

        $('.basket-payment-checkout').click(function(e){
            e.preventDefault();
          /*  alert('And here goes pleasant moment of client payment.' +
            'Page will be changed to the next just for test - insert here your code to provide payment.');*/

            // Сохраняем данные по доставке и переходим на оплату
            $.ajax({
                method: "POST",
                url: document.location.href+'?act=pay',
                data: $('.basket-payment').serialize()
            })
                .done(function( msg ) {
                    var results = JSON.parse(msg);
                    if (results.errors && results.errors.length != 0) {
                        $('.ajax.error-block').empty().html(results.errors.join('<br>')).show();
                    } else {
                        location.href = results.paypalUrl;
                    }
                });

            /*var toPage = 3;
            var $stages = $('.payment-navigation');
            if (toPage.toString().length) {
                $bpp.hide();
                $('#basket-payment-page-' + toPage).show();
                $stages.find('.stage').removeClass('active');
                $stages.find('.stage-'+toPage).addClass('active');
                basketCheckoutPageChanged(toPage);
            }*/
        });
    }
    // basket functions ------------------------


    var $cLinks = $('.meeting a.cancel-meeting');
    if ($cLinks.length) {
        $cLinks.hover(function(){
            if(!$(this).parent().find('.meeting-cancel-hint').length) {
                $('#meeting-cancel-hint').tmpl({"time": $(this).data('cancel-time')}).appendTo($(this).parent());
            }
            var $hint = $(this).parent().find('.meeting-cancel-hint');
            $hint.css({'top':($(this).position().top + 35) + 'px'}).stop().fadeIn(200)

        }, function(){
            var $hint = $(this).parent().find('.meeting-cancel-hint');
            setTimeout(function(){
                $hint.stop().fadeOut(200);
            }, 800);

        }).click(function(e){
            e.preventDefault();
            var that = this;
            if ($(this).data('cancel-time') != '0') {
                $.ajax({
                    method: "POST",
                    url: '/'+LANGUAGE+'/shopper/meetings/',
                    data: {id:$(this).data('slot-id'), act:'canceled'}
                })
                    .done(function( msg ) {
                        var results = JSON.parse(msg);
                        if (results.errors && results.errors.length != 0) {
                            alert(results.errors.join("\n"));
                        } else {
                            var $meeting = $(that).closest('.meeting');
                            $meeting.addClass('deleted');
                        }
                    });

            }
        });

        $('.meeting a.missed-meeting').click(function(e){
            e.preventDefault();
            var that = this;
            $.ajax({
                method: "POST",
                url: '/'+LANGUAGE+'/shopper/meetings/',
                data: {id:$(this).data('slot-id'), act:'missed'}
            })
                .done(function( msg ) {
                    var results = JSON.parse(msg);
                    if (results.errors && results.errors.length != 0) {
                        alert(results.errors.join("\n"));
                    } else {
                        var $meeting = $(that).closest('.meeting');
                        $meeting.addClass('deleted');
                    }
                });
        });

        $('.action-description-missed a, .action-description-deleted a').click(function(e){
            e.preventDefault();
            var that = this;
            $.ajax({
                method: "POST",
                url: '/'+LANGUAGE+'/shopper/meetings/',
                data: {id:$(this).data('slot-id'), act:'restore'}
            })
                .done(function( msg ) {
                    var results = JSON.parse(msg);
                    if (results.errors && results.errors.length != 0) {
                        alert(results.errors.join("\n"));
                    } else {
                        $(that).closest('.meeting').removeClass('deleted missed');
                    }
                });
        });
        $('.meeting').on('mouseenter', '.meeting-cancel-hint', function(){
            $(this).stop().addClass('visible');
        });
        $('.meeting').on('mouseleave', '.meeting-cancel-hint', function(){
            var $hint = $(this);
            setTimeout(function(){
                $hint.stop().css('display','block').removeClass('visible').fadeOut(200);
            }, 800);
        })
    }

    $('a.btn-disabled').click(function(e){e.preventDefault();});

    $('.basket-new-good').click(function(e){
        e.preventDefault();
        $("html, body").animate({ scrollTop: 0 }, 300);

        var $basketContent = $('#basket-content-wrapper');
        var $formContent = $('#new-good-form');
        var searchVal = $basketContent.find('.search-input input').val();

        if (searchVal.length > 0) {
            $formContent.find('input[name="name"]').val(searchVal)
        }

        $basketContent.animate({opacity: 0},{step: function(now){
            $formContent.css({'opacity': (1-now), 'display':'block'});
        },
            complete: function(){
                $formContent.find('select').select2({minimumResultsForSearch: Infinity});
            },
            duration: 300
        })
    });

    $('#new-good-form').find('.basket-new-good-save').click(function(e){
        e.preventDefault();

        var $basketContent = $('#basket-content-wrapper');
        var $formContent = $('#new-good-form');
        $basketContent.find('.basket-empty').remove();
        $('#submit-basket').removeClass('btn-disabled').unbind('click').bind('click', sendNewBasket);

        var formRes = getValues($(this));

        // отправляем через iframe
        $('#productform').submit();

        $("#postiframe").load(function () {
            var results =  $.parseJSON(this.contentWindow.document.body.innerHTML);
            console.log(results);

            // get image path after upload and save data to server
            $('#cart-item').tmpl({
                "id": results.product.id,
                "name": results.product.product,
                "img": results.product.image,
                "brand": results.product.brand,
                "color": results.product.color,
                "price": results.product.price,
                "sign": results.product.sign
            }).appendTo($basketContent.find('.cart-content-main'));
            $basketContent.animate({opacity: 1},{step: function(now){
                $formContent.css({'opacity': (1-now), 'display':'block'});
            },
                complete: function(){
                    $formContent.css({'display':'none'})
                },
                duration: 300
            });

        });
        return false;



    });

    function getValues($form) {
        var result = {};
        var fields = $form.serializeArray();
        jQuery.each( fields, function( i, field ) {
            result[field.name] = field.value;
        });
        return result;
    }

    function sendNewBasket(e) {
        e.preventDefault();
        alert ('Sending basket');
    }

    $('#basket-content-wrapper').find('.search-input input').keyup(function(){
        var value = $(this).val();
        $('.basket-new-good strong').html(value);

        if (value.length >= 2) {
            $.post(
                '',
                { q: value, act:'getproducts' },
                function(res) {
                    var elems = $.parseJSON(res).products;
                    var $searchResult = $('#search-result');
                    var $basketContent = $('#basket-content-wrapper').find('.cart-content-main');

                    $searchResult.find('> div').css({'opacity': 0});

                    $searchResult.html('');
                    if (!isNaN(parseInt(elems.length)) && parseInt(elems.length) != 0) {
                        for (var x in elems) {
                            $('#cart-item-search').tmpl(elems[x]).appendTo($searchResult);
                        }
                    } else {
                        $('#cart-item-search-empty').tmpl().appendTo($searchResult)
                    }

                    $basketContent.animate({opacity: 0}, {
                        complete: function(){
                            $basketContent.css({'display':'none'});
                            $searchResult.css({'display':'block'}).animate({'opacity': 1}, {complete: function() {

                                var i = 0;
                                $searchResult.find('> div').stop().each(function(){
                                    var item = $(this);
                                    item.animate({'opacity': 1}, 300 + i);
                                    i += 200;
                                })
                            }}, 250);
                        },
                        duration: 250
                    })
                }
            )
        }
    }).blur(function(){
        var $searchResult = $('#search-result');
        var $basketContent = $('#basket-content-wrapper').find('.cart-content-main');

        $searchResult.animate({opacity: 0}, {
            complete: function(){
                $searchResult.css({'display':'none'});
                $basketContent.css({'display':'block'}).animate({'opacity': 1}, 250);
            },
            duration: 250
        })
    });

    $('#search-result').on('click', '.cart-item-add-link', function(e){
        e.preventDefault();
        var $basketContent = $('#basket-content-wrapper');
        var formRes = $(this).data('item-info').split(';;');
        var item = {
            "name": formRes[1],
            "img": formRes[2],
            "brand": formRes[0],
            "color": formRes[3],
            "price": formRes[4],
            "id": formRes[5]
        };

        $.ajax({
            method: "POST",
            data: {act:'addproduct', product:item.id}
        })
            .done(function( msg ) {
                var results = JSON.parse(msg);
                if (results.errors && results.errors.length != 0) {
                    alert(results.errors.join("\n"));
                } else {
                    $('#cart-item').tmpl(item).appendTo($basketContent.find('.cart-content-main'));
                }
            });

    });

    // upload products
    /*$("#productform").click(function () {
        $('#postiframe').remove();
        var iframe = $('<iframe name="postiframe" id="postiframe" style="display: none"></iframe>');
        $("body").append(iframe);
        $(this).submit();
        $("#postiframe").load(function () {
            var iframeContents = this.contentWindow.document.body.innerHTML;
            console.log(iframeContents);
        });
        return false;
    });*/


    // отмена митингов
    $('.meetings-list .account-cancel-meeting').click(function(e){
        e.preventDefault();
        var that = this;
        $.ajax({
            method: "POST",
            url: '/'+LANGUAGE+'/account/meetings/',
            data: {id:$(this).data('slot-id'), act:'canceled'}
        })
            .done(function( msg ) {
                var results = JSON.parse(msg);
                if (results.errors && results.errors.length != 0) {
                    alert(results.errors.join("\n"));
                } else {
                    var $meeting = $(that).closest('.meeting');
                    $meeting.addClass('deleted');
                }
            });
    });
    $('.meetings-list  .action-description-deleted a').click(function(e){
        e.preventDefault();
        var that = this;
        $.ajax({
            method: "POST",
            url: '/'+LANGUAGE+'/account/meetings/',
            data: {id:$(this).data('slot-id'), act:'restore'}
        })
            .done(function( msg ) {
                var results = JSON.parse(msg);
                if (results.errors && results.errors.length != 0) {
                    alert(results.errors.join("\n"));
                } else {
                    $(that).closest('.meeting').removeClass('deleted missed');
                }
            });
    });

});
