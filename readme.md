# WeAttendance
> Attendance app using estimote ibeacons for the UVM Wellness Environment

## Release History
* 0.1.0
* Added in app beacon status, if in range, beacon status gets updated instantly, out of range takes few seconds but still fast!
* Check Mark to indicate in range, X mark to indicate out of range.
* All other screens/tabs are added as well as most of the UI.

* 0.0.6
* Went back to using beaconManager because MonitoringV2Manager is difficult to test with.

* 0.0.5
* Nuked project, starting over again with the base app to test beacon functionalities.

* 0.0.2
* Working on:
*  We are currently working on designing the database we will be using to store the attendance data for the class.
*  Added a temporary App Icon just to distinguish the app from other WE app on the phone. Once we create an actual App Icon, we will add those and all supporting sizes.
* Added the third viewController from our wireframe. This screen will display the attendance data of the last 7 days. Also added a loading screen (should update this in future just like the app icon)
* Removed Firebase and FirebaseDatabase pods and everything in the code relating to it to prepare for new database.

* 0.0.1
* Base app that sends data to a firebase database when the user is within range of a beacon, whether the app is open or fully closed.

