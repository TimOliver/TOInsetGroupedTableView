# TOInsetGroupedTableView

<p align="center">
<img src="https://raw.githubusercontent.com/TimOliver/TOInsetGroupedTableView/master/screenshot.jpg" width ="700" />
</p>

[![CI](https://github.com/TimOliver/TOInsetGroupedTableView/workflows/CI/badge.svg)](https://github.com/TimOliver/TOInsetGroupedTableView/actions?query=workflow%3ACI)
[![Version](https://img.shields.io/cocoapods/v/TOInsetGroupedTableView.svg?style=flat)](http://cocoadocs.org/docsets/TOInsetGroupedTableView)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/TimOliver/TOInsetGroupedTableView/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/TORoundedButton.svg?style=flat)](http://cocoadocs.org/docsets/TOInsetGroupedTableView)
[![PayPal](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M4RKULAVKV7K8)
[![Twitch](https://img.shields.io/badge/twitch-timXD-6441a5.svg)](http://twitch.tv/timXD)

`TOInsetGroupedTableView` is a subclass of `UITableView` that back-ports the new "inset grouped" visual style introduced in iOS 13 to older versions of iOS. 

On iOS 13 and above, it defers back to using the system implementation, meaning absolutely no extra configuration code is required.

This library is fantastic for developers adopting the new rounded corners style of table views in their apps, but are still supporting iOS 11 or iOS 12.

## Features
* Brings the modern rounded corners look to table views in previous versions of iOS.
* All override behaviour is contained in the table view. No modifications of the cell views themselves is required.
* Defers back to the system implementation on iOS 13 and higher.
* As the code is only ever executed below iOS 13, there is no chance of future iOS releases breaking the build.

## Requirements
* Xcode 11.0 or higher.
* iOS 11.0 or higher.

## Installation

### Manual Installation

1. [Download](https://github.com/TimOliver/TOInsetGroupedTableView/archive/master.zip) the latest version of the `TOInsetGroupedTableView` repository.
2. Inside the repository, copy the `TOInsetGroupedTableView` folder to your own Xcode project.
3. Optionally, in Swift, make sure to add the header file to your Swift bridging header.

### CocoaPods

In your app's Podfile, add:

```ruby
pod 'TOInsetGroupedTableView'
```

## Usage

Integrating `TOInsetGroupedTableView` is extremely simple as it introduces no new APIs or changes any external inputs. All that is needed is to replace `UITableView()` instantiations with `TOInsetGroupedTableView()`.

### Swift

In Swift, the class is renamed to `InsetGroupedTableView`. In order to integrate it, simply replace any instances of

```swift
self.tableView = UITableView(frame: .zero, style: .insetGrouped)
```

with

```swift
self.tableView = InsetGroupedTableView(frame: .zero)
``` 
 
 No other changes are needed.
 
### Objective-C
 
 Just like in Swift, all that is required is to rename any instantiations of `UITableView` with `TOInsetGroupedTableView`.
 
 For example, simply replace any instances of:
 
 ```objc
 self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
```

with

```objc
self.tableView = [[TOInsetGroupedTableView alloc] initWithFrame:CGRectZero];
```

## Credits

`TOInsetGroupedTableView` was created by [Tim Oliver](http://twitter.com/TimOliverAU).


## How is this library different to [`TORoundedTableView`](https://github.com/TimOliver/TORoundedTableView)?

`TORoundedTableView` is a library with a similar goal: replicating the rounded corner table view style that has been present in Settings.app since iOS 7.

`TORoundedTableView` was originally released in late 2016 with the explicit goal of supporting iOS versions 8.0 and above.

Due to the APIs available on iOS at the time, as well as the relative graphics performance of the hardware of that era, `TORoundedTableView` required far more modification of `UITableView` and its components to achieve the effect, and maintain high FPS.

Most notably, in order to have the rounded caps on the cells, it was also necessary to create subclasses of `UITableViewCell` as well, which increased the complexity of the implementation, and meant it couldn't really be simply 'dropped in' to existing implementations.

By focusing on just the most recent iOS versions, where OpenGL has been completely removed, and there are now more Core Animation APIs, `TOInsetGroupedTableView` is able to achieve the same effect as `TORoundedTableView` but without needing to subclass any of the cells.

Additionally, by observing how `.insetGrouped` behaves in iOS 13, it was also possible to configure `TOInsetGroupedTableView` to work alongside it, allowing for the same code to default back to the iOS 13 implementation when possible.

# License

`TOInsetGroupedTableView` is available under the MIT license. Please see the [LICENSE](LICENSE) file for more information.
