# PTModel

[![CI Status](http://img.shields.io/travis/Oscar Swanros/PTModel.svg?style=flat)](https://travis-ci.org/Oscar Swanros/PTModel)
[![Version](https://img.shields.io/cocoapods/v/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)
[![License](https://img.shields.io/cocoapods/l/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)
[![Platform](https://img.shields.io/cocoapods/p/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)

`PTModel` is a simple objet store for persisting data on iOS applications. 

**Please note:** this is in no way an attempt to replace `CoreData`. Its way far from that. If you're looking for an alternative for `CoreData`, you may want to take a look at [`FCModel`](htp://github.com/marcoarment/FCModel).


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

---

To use `PTModel`, you just need to subclass it:

```objc
// Record.h
#import <PTModel/PTModel.h>

@interface Record : PTModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *band;
@end


// Record.m
#import "Record.h"

@implementation Record
@end
```

Then, you can create instances of `Record` and save them:

```objc
Record *newRecord = [Record new];

newRecord.title = @"Divine Discontent";
newRecord.band = @"Sixpence None The Richer";

[newRecord save]; // Save this record to the object store.
```

In this version, you can retrieve an object by *querying* for it:

```objc
NSPredicate *pred = [NSPredicate predicateWithFormat:@"title = %@", @"Days Are Gone"];
Record *myFavoriteRecord = (Record *)[[Record instancesFilteredWithPredicate:pred] firstObject];
```


## Installation

`PTModel` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PTModel"
```

## Author

Oscar Swanros @ Pacific3, [hola@pacific3.net](mailto:hola@pacific3.net)

## License

`PTModel` is available under the MIT license. See the LICENSE file for more info.
