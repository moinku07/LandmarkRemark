# LandmarkRemark

Software development process: BDD. 
Software design pattern: MVVM.

Implicit requirements:

A login screen, which ensure note are being added by an user.

To display the notes list, I could have used a tab bar to show a map in one tab and note list in another tab. 
However, I used a collection view with horizontal scrolling at the bottom of the mapview for the note list.
I did not write any unit tests for the ListViewController because I believe this is a nice to have feature for the technical test.


Setup:

This project was created using Xcode 10.3 and tested on both simulators and real device. However, to install/test the app on a real device
you will require a Provisioning profile, a different bundle identifier and firebase configuration. Whereas, you do not need to change any settings to test on a simulator.

For simulators, set a simulated location from Simulator menu Features -> Location -> Custom location.