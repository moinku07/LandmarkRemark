# LandmarkRemark

Software development process: **BDD**.
Software design pattern: **MVVM**.

## Implicit requirements:

A login screen, which ensure note are being added by a user.

To display the notes list, I could have used a tab bar to show a map in one tab and note list in another tab. 
However, I used a collection view with horizontal scrolling at the bottom of the mapview for the note list.

I chose not to write unit tests for the Login and NoteCollectionViewController to complete the test sooner.

I used Parse in past but never used Firestore before. However, I used Firebase MLKit before. 
It took me a while to learn and integrate Firebase Firestore.
Since this is my first Firestore integration, I may have not followed the standards here. 

I was unable to do partial (contain/like) text match. It only supports =, >, <, >=, <=. It also does not support **OR**. I could be wrong.


## Setup:

This project was created using Xcode 10.3 and tested on both simulators and real device. To install/test the app on a real device
you will require a Provisioning profile, a different bundle identifier and firebase configuration. Whereas, you do not need to change any settings to test on a simulator.

For simulators, set a simulated location from Simulator menu Features/Debug -> Location -> Custom location.

On terminal, navigate to project folder and run the following command
```
pod install
```

Open "LandmarkRemark.xcworkspace" on Xcode 10.3 or later.

Press Command + U. It will start the Unit, UI and Acceptance tests.

### Login
The login page serves both Login and Registration. If the username and password do not match, app will create a new user and log the user in. 

## Feedback
Please let me know your feedback. I want to know what I did wrong and what I could have done better. So, I can know improve in those areas.

