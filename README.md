GiniVision SDK for iOS Example App
======================================

This is an example app for the GiniVision SDK for iOS. See
http://developer.gini.net/ginivision-ios/html/index.html for
further documentation.

Before You Can Run The App
--------------------------

In order to use the Gini SDK you have to edit the ``GiniDempoAppDelegate.m`` file and replace the values of ``your_gini_client_id`` and ``your_gini_client_secret`` in ``application:didFinishLaunchingWithOptions:`` with valid credentials. Please send an email to technical-support@gini.net if you haven't received credentials yet.

For the Gini Vision Library you have to enter valid credentials into the ``pod-install-example.sh`` file. Afterwards rename it to ``pod-install.sh``.

Build & Install the App
-----------------------

Go into the project directory and enter:

```
	$ sh pod-install-example.sh
```

This will install all dependencies.
If you haven't used CocoaPods before follow the guide on [cocoapods.org](https://cocoapods.org/).

After installing you can run the Gini Demo app.
