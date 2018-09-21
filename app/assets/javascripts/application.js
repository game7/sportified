//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.remotipart
//= require bootstrap-sprockets
//= require jcrop/jquery.Jcrop.min
//= require bootstrap-datetimepicker
//= require cocoon
//= require admin/chromecasts

function bindSelect(observerId, observedId, urlOrOptions, optionKey, optionValue, selected) {
  var $observer = $(observerId);
  var $observed = $(observedId);
  var optionTag = '<option></option>';

  function bind() {
    var val = $observed.val();
    $observer.empty().append($(optionTag).val('').text(''));
    if (val && val !== '') {
      $observer.attr('disabled', true);
      if (typeof urlOrOptions == 'string') {
        var url = urlOrOptions;
        var ok = true;
        $observed.each(function(i, item) {
          var $obj = $(item);
          if ($obj.val() === '') {
            ok = false;
          }
          url = url.replace('::' + $obj.attr('id') + '::', $obj.val());
        });
        if (ok) {
          return $.getJSON(url, function(data) {
            var rows = data
            $.each(rows, function(i, object) {
              $observer.append($(optionTag).val(object[optionKey]).text(object[optionValue]));
            });
            $observer.attr('disabled', false);
          })
        } else {
          $observer.attr('disabled', false);
        }
      } else {
        var options = urlOrOptions[val] || [];
        $.each(options, function(i, object) {
          $observer.append($(optionTag).val(object[optionKey]).text(object[optionValue]));
        });
        $observer.attr('disabled', false);
      }
    }
    return $.when();
  }

  $observed.change(function() {
    bind();
  });

  bind().then(function() {
    if(selected && Array.isArray(selected)) {
      for(var i = 0; i < selected.length; i++) {
        $($observer[i]).val(selected[i]);
      }
    } else {
      $observer.val(selected);
    }
  });



}

function rgbAsHexString(rgbInt) {
  var color = parseInt(rgbInt).toString(16);
  return color.length == 1 ? '0'+color : color;
}

function colorToHex(color) {
    if (color.substr(0, 1) === '#') {
        return color;
    }
    var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);

    var red = rgbAsHexString(digits[2]);
    var green = rgbAsHexString(digits[3]);
    var blue = rgbAsHexString(digits[4]);
    //alert(('#' + red + '|' + green + '|' + blue).toUpperCase());
    return ('#' + red + green + blue).toUpperCase();
};

function clearForm(form) {
  $(':input', form).each(function() {
    var type = this.type;
    var tag = this.tagName.toLowerCase();
    if (type == 'text' || type == 'password' || tag == 'textarea')
      this.value = "";
    else if (type == 'checkbox' || type == 'radio')
      this.checked = false;
    else if (tag == 'select')
      this.selectedIndex = -1;
  });
};

$(document).ready(function() {

  $('select.redirect_to').change(function() {
    if (this.value && this.value !== '') { window.location = this.value; }
  });

  $('.toggle').on("click", function() {
    $('#'+this.getAttribute('rel')).slideToggle(300);
    return false;
  });

  var $carousel = $('.carousel');
  if ($carousel.carousel) { $carousel.carousel(); }

  var $tooltip = $('[rel=tooltip], [data-toggle="tooltip"]');
  if ($tooltip.tooltip) { $tooltip.tooltip(); }

});

$(function(){

    function setCookie(name, value, days) {
        var expires;

        if (days) {
            var date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
    }

    function getCookie(name) {
        var nameEQ = encodeURIComponent(name) + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) === ' ')
                c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0)
                return decodeURIComponent(c.substring(nameEQ.length, c.length));
        }
        return null;
    }

    $('#sidebar-toggle').on('click', function() {
        var $sidebar = $('#sidebar');
        var state = !$sidebar.hasClass('active')
        $sidebar.toggleClass('active', state);
        setCookie('sidebar-active', state, 365);
    });

})



//= require react
//= require react_ujs
//= require components
