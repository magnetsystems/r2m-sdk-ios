[![Build Status](https://travis-ci.org/magnetsystems/r2m-sdk-ios.svg?branch=master)](https://travis-ci.org/magnetsystems/r2m-sdk-ios)
# rest2mobile SDK for iOS

## System Requirements
1. Xcode 5.0.1
2. CocoaPods

## How To Get Started

### Installation with CocoaPods

To add Rest2Mobile to your application, follow these steps:

Install CocoaPods if not yet installed.

    $ sudo gem install cocoapods
    $ pod setup

Change to the directory of your Xcode project, and Create and Edit your Podfile and add rest2mobile:

    $ cd /path/to/MyProject
    $ touch Podfile
    $ open Podfile

Copy and paste the following commands into the Podfile.

```ruby
platform :ios, '7.0'
pod 'Rest2Mobile', '~> 1.1'

# Add Kiwi as an exclusive dependency for the AmazingAppTests target
target :AmazingAppTests, :exclusive => true do
  pod 'Kiwi'
end
```

Install the SDK into your project by navigating to the project directory and executing the following command.

    $ pod install

Open your project in Xcode from the .xcworkspace file (not the usual project file).

**Note:** Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= 1.8.0 by executing git --version. You can get a full picture of the installation details by executing pod install --verbose.

## Unit Tests

To build Rest2Mobile from source and run the tests, follow these steps:

Rest2Mobile includes a suite of unit tests within the Tests subdirectory. In order to run the unit tests, you must install the testing dependencies via [CocoaPods](http://cocoapods.org/):

    $ git clone https://github.com/magnetsystems/r2m-sdk-ios.git
    $ cd r2m-sdk-ios/Tests
    $ pod install

Once testing dependencies are installed, you can execute the test suite via the 'iOS Tests' scheme within Xcode.

### Running Tests from the Command Line

Tests can also be run from the command line or within a continuous integration environment. The [`xcpretty`](https://github.com/mneorr/xcpretty) utility needs to be installed before running the tests from the command line:

    $ gem install xcpretty

Once `xcpretty` is installed, you can execute the suite via `rake test`.

## Credits

- AFNetworking: https://github.com/AFNetworking/AFNetworking
- Mantle: https://github.com/Mantle/Mantle
- CocoaLumberjack: https://github.com/CocoaLumberjack/CocoaLumberjack

### License

Licensed under the **[Apache License, Version 2.0] [license]** (the "License");
you may not use this software except in compliance with the License.

## Copyright

Copyright © 2014 Magnet Systems, Inc. All rights reserved.

[license]: http://www.apache.org/licenses/LICENSE-2.0
