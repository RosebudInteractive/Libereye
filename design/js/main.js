$(function() {
        $('#slides-container').cycle({
            //	speed:		0,
            //	timeout:	0,
			continueAuto: false,
            fx:			'scrollHorz',
            speed:		1000,
            timeout:	5000,
            'auto-height': 1,
            slides:     '> .slide',
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

    var page = 1;
    $('a.more-news').click(function(e) {
        e.preventDefault();
        var self = $(this);
        if (!self.hasClass('loading')) {
            self.addClass('loading');
            $.ajax({
                method: "POST",
                url: "/",
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
});
