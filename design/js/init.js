$(function(){
	
	$('#loginForm').on('click', function(e){$(this).hide();});
	$('#loginForm .login-icons').on('click', function(e){e.stopPropagation();});
	$(window).click(function(){$('.popuppee').hide();})
	$('.leave-comment-submit').on('click', function(e){
		commentSend(this);
		return false;
	});
	$('.leave-comment-input').on('keydown', function(e){
		return commentLimit(this);
	});
	$('.comments-list .comment-delete-link').on('click', commentDel);
});

function showLogin(){
	$('#loginForm').show();
	return false;
}

function viewPopup(e, obj, id){
	e.stopPropagation();
	var popup = $('#'+id);
	
	if (popup.is(':visible')) {
		popup.hide();
		return false;
	}
	$('.popuppee').hide();
	popup.show();
	popup.click(function(e){e.stopPropagation();});
	popup.position({of:obj,my:"left bottom-30",at: 'left',
		using:function(pos, obj){
		console.log(pos, obj)
		var topOffset = $( this ).css( pos ).offset().top;
		if ( topOffset < 0 ) {
			$( this ).css( "top", pos.top - topOffset );
		}
		if (obj.horizontal=="left")
			popup.find('.popuppee-tip-container').css({'left':'19.5px','right':'initial'});
		else
			popup.find('.popuppee-tip-container').css({'right':'19.5px','left':'initial'});
			
	}});
	return false;
}

function commentSend(obj){
	obj = $(obj);
	var error = $('.comment-error');
	var comment = $('.leave-comment-input');
	var commentVal = $('.leave-comment-input').val();
	if (commentVal=="") {
		if (error.length>0)
			error.html('Обязательное поле.').show();
		else 
			obj.after('<div class="comment-error" data-code="400">Обязательное поле.</div>');
		return false;
	} else {
		error.hide();
	}
	
	$('.leave-comment-submit').prop('disabled', true);
	$.ajax({
		type: "POST",
		url: "/comment/",
		data: $( '.leave-comment' ).serialize()
	}).done(function( data ) {
		if (!data.error) {
			comment.val('');
			commentLimit($('.leave-comment-input'));
			var comm = $('<div class="comment comment-response delete-item">\
					<div class="comment-content">\
							<div class="comment-profile"><span class="comment-profile-link"><img src="/design/pic/default-avatar.png" class="comment-profile-image"></span></div>\
							<header class="comment-header">\
								<div class="comment-author"><span class="comment-author-link"></span>,</div>\
								<time class="comment-date"><a href="#" class="comment-date-link"></a></time>\
							</header>\
							<div class="comment-description"><div class="comment-message"></div></div>\
					</div>\
				</div>');
			comm.attr('data-id', data.comment.comment_id)
			comm.attr('id', 'comment-'+data.comment.comment_id)
			comm.find('.comment-author-link').html(data.comment.fname);
			comm.find('.comment-date').attr('title', data.comment.cdate_text);
			comm.find('.comment-date-link').attr('href', '#comment-'+data.comment.comment_id).html(data.comment.cdate_text);
			comm.find('.comment-message').html(data.comment.comment);
			$('.comments-list').prepend(comm);
			$('.leave-comment-submit').prop('disabled', false);
		} else {
			commentError(data.error);
		}
	});
	
	
	return true;
}
function commentLimit(obj){
	obj = $(obj);
	var error = $('.comment-error');
	var symbols = $('.leave-comment-symbols-left');
	var commentVal = obj.val();
	symbols.html(1000-commentVal.length);
	
	obj.height(64); // min-height
    obj.height(obj.get(0).scrollHeight+14);
    
	if (1000-commentVal.length < 0) {
		symbols.addClass('exceeded');
		$('.leave-comment-submit').prop('disabled', true);
		return false;
	} else {
		symbols.removeClass('exceeded');
		$('.leave-comment-submit').prop('disabled', false);
	}
	return true;
}

function commentError(error, hide) {
	var error = $('.comment-error');
	if (error.length>0) {
		if (hide)
			error.hide();
		else
			error.html(error).show();
	} else {
		if (!hide)
			$('.leave-comment-submit').after('<div class="comment-error" data-code="400">'+error+'</div>');
	}
}

function commentDel(e) {
	var link = $(this);
	var linkSpan = link.find('span');
	var id = parseInt(link.attr('id').replace('comment-delete-link-', ''));
	
	if (linkSpan.html()=='Удалить') {
		linkSpan.html('Точно удалить?');
		return false;
	}
	
	$.ajax({
		type: "POST",
		url: "/comment/",
		data: {act:'del', id:id}
	}).done(function( data ) {
		if (!data.error) {
			$('#comment-'+id).remove();
		} 
	});
	
	return false;
}