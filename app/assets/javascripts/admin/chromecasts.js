// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function() {

    var session = null;

    function initialize() {

        var castAway = window.castAway = new CastAway({
            applicationID: '3C00FF56',
            namespace: "urn:x-cast:json"
        });

        // cast.framework.CastContext.getInstance().setOptions({
        //     receiverApplicationId: '556F3FBE',
        //     autoJoinPolicy: chrome.cast.AutoJoinPolicy.ORIGIN_SCOPED
        // })
        //
        // debugger;
        //
        // var context = cast.framework.CastContext.getInstance();
        // context.addEventListener(cast.framework.CastContextEventType.CAST_STATE_CHANGED, function(event) {
        //     if(event.castState == cast.framework.CastState.NOT_CONNECTED) {
        //         debugger;
        //         context.requestSession(function(errr, session) {
        //             debugger;
        //         })
        //     }
        // })

        castAway.on('receivers:available', function(a, b, c) {
            console.log('receivers available');
            return $('#cast, #chromecast_name').on('click', function(e) {
                e.preventDefault();
                return castAway.requestSession(function(err, newSession) {
                    if (err) {
                        $('#chromecast_name').val('')
                        $('#debug').text(JSON.stringify(err, null, 2))
                        return console.log("Error getting session", err);
                    }
                    session = newSession;
                    $('#chromecast_name').val(session.session.receiver.friendlyName)
                    return true;
                })
            })
        })

        castAway.on('existingMediaFound', function(session) {
            _session = session;
        });

        castAway.initialize(function(err, data) {
            if (err) {
                return console.log("error initialized", err);
            } else {
                return console.log("initialized", data);
            }
        });
    }

    function setChromecastId(id) {
        if (!session) return;
        session.send('setChromecastId', id, function() {

        });
    }

    window.sportified = window.sportified || {};
    window.sportified.chromecast = {
        initialize: initialize,
        setChromecastId: setChromecastId
    }

})();
