![Pendo Logo](https://www.pendo.io/_themes/bold-pink/img/pendo-main-logo-pink-black.svg)
# Pendo Mobile iOS SDK

## Requirements

* Xcode 8 or higher
* iOS 9.0 or higher

## SDK Installation

### Step 1: Integrate Pendo Mobile Framework

You have two options to add the Pendo Mobile framework. Via [CocoaPods](https://cocoapods.org/) or manually:

#### Add Pendo Mobile Framework via CocoaPods

Open your [Podfile](https://guides.cocoapods.org/syntax/podfile.html) and add the following lines:

```ruby
platform:ios, '9.0'
use_frameworks!
# other pod statements

target 'MyApp' do
  pod 'Pendo', '~> 2.0'
end
```

##### Build Settings

Under **Build Settings | Build Options** verify that the flag  **Enable Bitcode** is set to **No**.

<details>
<summary>**Manual Integration**</summary>

1. Download Pendo Mobile framework from the repository URL provided in the dashboard.
2. Drag **Pendo.framework** into your project. When prompted, check the option to **"Copy items if needed"**.
3. Under **Build Phases | Link Binaries With Libraries** verify that **Pendo.framework** is listed.
4. Under **General | Embedded Binaries** press the **+** sign and add **Pendo.framework**.
5. Under **Build Settings | Build Options** verify that the flag **Enable Bitcode** is set to **No**.
6. Under **General | Deployment Target** verify that your deployment target is set for **9.0** or later.

</details>

### Step 2: Set a URL Scheme

1. Under **Info | URL Types** create a new URL by pressing the **+** sign.

2. Set the **URL Schemes** according to the scheme in the dashboard.

3. Set the **URL Identifier** to any name of your choosing (or leave empty).

### Step 3: Initialization Code

#### Objective-C

In your **AppDelegate** file add:

```objc
@import Pendo;
```

Add or modify the function:

```objc
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  if ([[url scheme] hasPrefix:@"pendo"]) {
      [[PendoManager sharedManager] initWithUrl:url];
      return YES;
  }
  //  your code here ...
  return YES;
}
```

Under `didFinishLaunchingWithOptions` add the following line of code:
```objc
[[PendoManager sharedManager] initSDK:@"your app key" initParams:nil];
```

#### Swift

To use the Pendo Mobile framework you will need to add a “Bridging header” and include the framework header:

```objc
@import Pendo; // imports Pendo Mobile framework header.
```

In your **AppDelegate** file add or modify the function:


```swift
func application(_ app: UIApplication,
              open url: URL,
               options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    if url?.host?.hasPrefix("pendo") {
      PendoManager.shared().initWithUrl(url)
      return true
    }
    // your code here...
    return true
}
```

Under `didFinishLaunchingWithOptions` add the following line of code:
```swift
PendoManager.shared().initSDK("your app key", initParams: nil)
```

### Step 4: Test your changes

#### Test using Xcode

Run the app while attached to Xcode, review the device log and look for the message:
>Pendo SDK was successfully integrated and connected to the Pendo server. You can start adding guides to your application and view analytics on Pendo’s web site.

#### Test using the Pendo

Log into your Pendo subscription. Under **Subscription Settings**, make sure that your app has an **Integrated** label.
*Old version*: If you are a Pendo user: Under your subscription, verify that the number of app versions for your app shows 1 or increased from it's previous number.

### Advanced
The Pendo Mobile framework allows the addition of guides that show on application start, such as an App Walkthrough guide. In order to properly show guides on app start, you may want to show the app's first screen only after the initialization of the Pendo Mobile framework has completed. To register for successful completion of the Pendo Mobile framework initialization add the following code before the initSDK call:

#### Objective-C

```objc
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSuccessfullyInitSDK) name:kIIODidSuccessfullyInitializeSDKNotification object:nil];
```

Then implement the method:
```objc
- (void)didSuccessfullyInitSDK {
  // your post initialization code here
}
```
In the same way you can register for failed initialization by registering for `kIIOErrorInitializeSDKNotification`.

#### Swift
```swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSuccessfullyInitSDK", name: kIIODidSuccessfullyInitializeSDKNotification, object: nil)
```

Then implement the method:
```swift
func didSuccessfullyInitSDK() {
  // your post initialization code here
}
```
In the same way you can register for failed initialization by registering for `kIIOErrorInitializeSDKNotification`.

## Known Limitations

* Pendo Mobile supports iOS 9.0 or later.
* Your app must be able to connect to Pendo's servers.
* Pendo Mobile framework uses [Certificate Pinning](https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning) to enforce extra security measures when communicating with Pendo's servers and thus any application that performs SSL inspection will fail to integrate the framework.
* For the pairing process make sure your organization has enabled the web sockets protocol.

## Troubleshooting

Please visit the Mobile section of our [help center](https://help.pendo.io).
