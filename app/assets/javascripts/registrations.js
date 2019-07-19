// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function () {

  var processing = false;

  function errorAlert(text) {
    $('.alert').remove()
    $('<div/>').addClass('alert')
               .addClass('alert-danger')
               .html(text)
               .appendTo('#page-header')
  }

  function stripeResponseHandler(status, response) {
    // Grab the form:
    var $form = $('form.edit_registration');

    if (response.error) { // Problem!

      // Show the errors on the form:
      errorAlert(response.error.message);
      processing = false;
      $form.find(':submit').prop('disabled', false); // Re-enable submission

    } else { // Token was created!

      // Get the token ID:
      var token = response.id;

      var payload = {
        credit_card: {
          brand: response.card.brand,
          country: response.card.country,
          exp_month: response.card.exp_month,
          exp_year: response.card.exp_year,
          funding: response.card.funding,
          last4: response.card.last4,
          token_id: response.id
        }
      };

      $.post('/credit_cards', payload).then(
        function(credit_card) {
          var template = [
            '<span class="radio">',
              '<label for="registration_credit_card_id_' + credit_card.id + '">',
                '<input class="radio_buttons optional" type="radio" value="' + credit_card.id + '" name="registration[credit_card_id]" id="registration_credit_card_id_' + credit_card.id + '">',
                  credit_card.brand.toUpperCase() + 'ending with ' + credit_card.last4 + ', expiring ' + credit_card.exp_month + '/' + credit_card.exp_year,
              '</label>',
            '</span>'].join('');
          $('#new-form')
          $('.radio').first().before(template);
          $('.radio input').first().prop('checked', true);
          // Submit the form:
          $form.get(0).submit();
        },
        function(error) {
          var json = error.responseJSON;
          processing = false;
          errorAlert(json.message);
          $form.find(':submit').prop('disabled', false);
        }
      );


    }
  };
  $(function() {
    var $form = $('form.edit_registration');
    $form.submit(function(event) {
      $form.find(':submit').prop('disabled', true);
      var newCard = $('.radio input').last().prop('checked');
      if(newCard && !processing) {
        processing = true
        try {
          Stripe.card.createToken($form, stripeResponseHandler);
        }
        catch (exc) {
          console.log(exc);
          alert('Darn!  Something went wrong...');
        }
        return false
      }
    });

    var radios = $('.registration_credit_card_id input');

    if(radios.length == 1) {
      $(radios).prop("checked", false);
      $(radios[0]).prop("checked", 'checked');
    }
    if(radios.length > 1) {
      $('#new-card').hide();
    }
    $(radios).change(function() {
      if($(radios).last().prop("checked")) {
        $('#new-card').slideDown();
      } else {
        $('#new-card').slideUp();
      }
    })

  });

})();
