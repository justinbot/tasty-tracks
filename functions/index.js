const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.placeBet = functions.https.onRequest((request, response) => {
    // trackId, wager

    // Verify user has balance for wager
    // TODO

    // Get Track data from Spotify
    // TODO

    // Place bet with wager and current popularity
    // TODO
});

exports.cancelBet = functions.https.onRequest((request, response) => {
    // betId

    // Get bet

    // Get Track data from Spotify
    // TODO

    // Calculate outcome with wager and current popularity
    // TODO

    // Delete bet and add outcome to balance
});

exports.getBetOutcome = functions.https.onRequest((request, response) => {
    // betId

    // Get bet

    // Get Track data from Spotify
    // TODO

    // Calculate outcome with wager and current popularity
    // TODO
});

