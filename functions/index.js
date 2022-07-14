const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.paymentCallback = functions.https.onRequest(async (req, res) => {

  const callbackData = req.body.Body.stkCallback;
  const responseCode = callbackData.ResultCode;
  console.log(responseCode);
  const mCheckoutRequestID = callbackData.CheckoutRequestID;
  console.log(mCheckoutRequestID);

  if (responseCode === 0) {
    const details = callbackData.CallbackMetadata.Item

    var mAmountPaid = details[0]['Value'];
    var mReceipt = details[1]['Value'];
    var mPhonePaidFrom = details[4]['Value'];
    console.log(details);


    var currentUser = admin.firestore().collection('bills').where('phone', '==', mPhonePaidFrom);
    const queryResults = await currentUser.get();

    if (!queryResults.empty) {
      console.log('User found in bills');
      var userid = queryResults.docs[0].data().userid;
      var username = queryResults.docs[0].data().name;
    }
    else {
      console.log('user not found in bills');
      var currentUserTwo = admin.firestore().collection('invoices').where('phone', '==', mPhonePaidFrom.toString());
      const queryResultsTwo = await currentUserTwo.get();

      if (!queryResultsTwo.empty) {

        console.log('User found in invoices');

        var userid = queryResultsTwo.docs[0].data().userid;
        var username = queryResultsTwo.docs[0].data().name;
      } else {
        console.log('User that paid was not found in bills or invoices');
      }

    }



    let year = new Date().getFullYear();

    const de = new Date();
    let day = de.getDate();

    const currentMonth = new Date().getMonth() + 1;

    let combineddate = (day + '/' + currentMonth + '/' + year)

    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    var d = new Date();
    var monthName = months[d.getMonth()];


    const { id } = await admin.firestore().collection('payments').add({
      checkoutid: mCheckoutRequestID,
      amount: mAmountPaid,
      paymentref: mReceipt,
      date: combineddate,
      phone: mPhonePaidFrom,
      allocation: 'unallocated',
      year: year,
      userid: userid,
      month: monthName,
      name: username,
    });

    await admin.firestore().collection('payments').doc(id).update({
      docid: id
    }
    );

    res.json(
      {
        'result': 'Payment for ${mCheckoutRequestID} response received.'
      }
    );
  }
}
);