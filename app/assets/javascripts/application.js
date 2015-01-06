//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.remotipart
//= require bootstrap-sprockets
//= require jcrop/jquery.Jcrop.min


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
    window.location = this.value;
  });

  $('.toggle').on("click", function() {
    $('#'+this.getAttribute('rel')).slideToggle(300);
    return false;
  });

  $('.carousel').carousel();
  $('[rel=tooltip]').tooltip();
  $('[data-toggle="tooltip"]').tooltip();

});