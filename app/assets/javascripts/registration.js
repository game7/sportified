
(function () {

  Stripe.setPublishableKey('#{stripe_public_api_key}');

  function stripeResponseHandler(status, response) {
    // Grab the form:
    var $form = $('#payment-form');

    console.log(status);
    console.log(response);

    $('.debug').html(JSON.stringify(response, null, 2));


    if (response.error) { // Problem!

      // Show the errors on the form:
      $form.find('.payment-errors').text(response.error.message);
      $form.find('.submit').prop('disabled', false); // Re-enable submission

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
          console.log(credit_card);
        },
        function(errors) {
          console.log(errors);
        }
      );

      // Submit the form:
      //$form.get(0).submit();
    }
  };
  $(function() {
    var $form = $('#new_registration');
    $form.submit(function(event) {
      $form.find('.submit').prop('disabled', true);
      Stripe.card.createToken($form, stripeResponseHandler);
      return false;
    });
  });

})();
