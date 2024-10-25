const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.calculateFinalScore = functions.firestore.document('Responses/{docID}').onCreate(async (snapshot, context) => {
    let manualCheckRequired = false;
    let finalMarks = 0;

    const data = snapshot.data();
    const responses = data?.Responses;
    const userID = data?.UserID;
    const submissionTime = data?.submissionTime;
    const testName = data?.testName;

    if (!responses) {
        console.error("No responses found in the document.");
        return;
    }

    for (const [questionID, response] of Object.entries(responses)) {
        try {
            const questionDoc = await admin.firestore().doc(`Questions/${questionID}`).get();

            if (!questionDoc.exists) {
                console.log(`Question ${questionID} not found! Skipping...`);
                continue;
            }

            const questionData = questionDoc.data();

            if (questionData.descriptionRequired === true) {
                manualCheckRequired = true;
                continue; 
            }

            const correctOption = questionData.correctOption;
            if (correctOption == response.selectedOption) {
                finalMarks += questionData.marks;
            } else if (!response.selectedOption) {
                finalMarks += 0;
            } else {
                finalMarks -= questionData.negativeMarks; 
            }

        } catch (error) {
            console.error(`Error fetching question ${questionID}:`, error);
        }
    }

    await admin.firestore().collection('Final_Scores').doc(userID).set({
        UserID: userID,
        testName: testName,
        finalScore: finalMarks,
        manualCheckRequired: manualCheckRequired,
        submissionTime: submissionTime
    }, { merge: true });

    console.log(`Final score for candidate ${userID} in test ${testName} is ${finalMarks}, manual check required: ${manualCheckRequired}`);
});
