//= require jquery
//= require jquery_ujs
//= require jquery-ui.min
//= require twitter/bootstrap
//= require jquery.wymeditor.js


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

  $('.toggle').live("click", function() {
    $('#'+this.getAttribute('rel')).slideToggle(300);
    return false;
  });

});


