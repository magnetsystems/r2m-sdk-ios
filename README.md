## rest2mobile SDK for iOS

The rest2mobile SDK for iOS is licensed under the terms of the [Magnet Software License Agreement](http://www.magnet.com/resources/tos.html).  Please see [LICENSE](./LICENSE) file for full details.

### System Requirements
1. Xcode 5.0.1
2. CocoaPods

### Import the rest2mobile SDK for iOS into your own iOS app

Install CocoaPods if not yet installed.

    $ sudo gem install cocoapods
    $ pod setup

Change to the directory of your Xcode project, and Create and Edit your Podfile and add rest2mobile:
    
    $ cd /path/to/MyProject
    $ touch Podfile
    $ open Podfile

Copy and paste the following commands into the Podfile.    

    platform :ios, '7.0'
    pod 'Rest2Mobile', '~> 1.0'
    
Install the SDK into your project by navigating to the project directory and executing the following command.
    
    $ pod install

Open your project in Xcode from the .xcworkspace file (not the usual project file).

**Note:** Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= 1.8.0 by executing git --version. You can get a full picture of the installation details by executing pod install --verbose.
    
