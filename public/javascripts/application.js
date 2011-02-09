// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


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

});
