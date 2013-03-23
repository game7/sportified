//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require jquery.remotipart
//= require twitter/bootstrap
//= require jcrop/jquery.Jcrop.min

function colorToHex(color) {
    if (color.substr(0, 1) === '#') {
        return color;
    }
    var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);
    
    var red = parseInt(digits[2]);
    var green = parseInt(digits[3]);
    var blue = parseInt(digits[4]);
    
    var rgb = blue | (green << 8) | (red << 16);
    return digits[1] + '#' + rgb.toString(16).toUpperCase();
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

});


