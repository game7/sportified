// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function() {

    function initialize() {

        var castAway = window.castAway = new CastAway({
            applicationID: '3C00FF56',
            namespace: "urn:x-cast:json"
        });

        castAway.on('receivers:available', function(a, b, c) {
            console.log('receivers available');
            return $('#cast, #chromecast_name').on('click', function(e) {
                e.preventDefault();
                return castAway.requestSession(function(err, session) {
                    if (err) {
                        $('#chromecast_name').val('')
                        return console.log("Error getting session", err);
                    }
                    $('#chromecast_name').val(session.session.receiver.friendlyName)
                    window.session = session;
                    return true;
                })
            })
        })

        castAway.on('existingMediaFound', function(session) {
            debugger;
            window.session = session;
            session
        });

        castAway.initialize(function(err, data) {
            if (err) {
                return console.log("error initialized", err);
            } else {
                return console.log("initialized", data);
            }
        });
    }

    window.sportified = window.sportified || {};
    window.sportified.chromecast = {
        initialize: initialize
    }

})();
