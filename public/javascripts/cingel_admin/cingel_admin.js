// Put functions that you want to fire onload (onready) here
$(function() {
  CingelAdmin.observeFlashMessages();
  CingelAdmin.observeAjaxErrors();
  CingelAdmin.observeAjaxPagination();
  CingelAdmin.focusOnLoad();
});

// We will put all functions under CingelAdmin namespace
var CingelAdmin = {};

// Ajax Errors
CingelAdmin.observeAjaxErrors = function() {
  $(document).ajaxError(function(e, xhr, settings, exception) {
    if (!settings.error) {
      if (xhr.status==0) {
        alert('You are offline!!\n Please Check Your Network.');
      } else if (xhr.status==404) {
        alert('Tražena adresa nije pronađena.');
      } else if (xhr.status==500) {
        alert('Greška na serveru.');
			} else if (exception=='parsererror') {
			  alert('Error.\nParsing JSON Request failed.');
			} else if (exception=='timeout') {
			  alert('Request Time out.');
			} else {
			  alert(xhr.statusText);
			}
    }
  });
}

// Flash Messages
CingelAdmin.observeFlashMessages = function() {
  var flash = $('.flash_msg');
  if (flash.length) {
    flash.click(function() {
      flash.slideUp('fast');
    });
    if (!flash.hasClass('flash_msg_error') && !flash.hasClass('flash_msg_alert')) {
      flash.delay(3000).fadeOut("fast");
    }
  }
};

// Ajax pagination (https://github.com/mislav/will_paginate/wiki/Ajax-pagination)
CingelAdmin.observeAjaxPagination = function() {
  $('.ajax_pagination a').live('click', function (){
    $(this).parents('.ajax_pagination').append('<img src="/images/cingel_admin/loader.gif" />');
    $.getScript(this.href);  
  	return false;
  });
};

// Focus first field with focus_on_load class
CingelAdmin.focusOnLoad = function() {
  $(".focus_on_load").first().focus();
};