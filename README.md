# PTModel

[![CI Status](http://img.shields.io/travis/Oscar Swanros/PTModel.svg?style=flat)](https://travis-ci.org/Oscar Swanros/PTModel)
[![Version](https://img.shields.io/cocoapods/v/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)
[![License](https://img.shields.io/cocoapods/l/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)
[![Platform](https://img.shields.io/cocoapods/p/PTModel.svg?style=flat)](http://cocoapods.org/pods/PTModel)

`PTModel` is a simple object store for persisting data on iOS applications.


---
# When to use `PTModel`

**Please note:** this is in no way an attempt to replace `CoreData`. Its way far from that. If you're looking for an alternative for `CoreData`, you may want to take a look at [`FCModel`](htp://github.com/marcoarment/FCModel).

`PTModel` serves well when you only need to persist a set of data, without worrying too much about performance.

1. Save some user configuration
2. Persist data between app launches
3. Some kind of cache, maybe?

`PTModel` is not designed to be a full-featured object graph. If what you need is save multiple entities, related to each other, what you want is to use `CoreData`.

---
# Usage

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

## Saving objects

```objc
Record *newRecord = [Record new]; // Create a new object
newRecord.title = @"Divine Discontent";
newRecord.band = @"Sixpence None The Richer";

[newRecord save]; // Save your object to the store
```

<br>
## Retrieving objects

In this version of `PTModel` you can retrieve objects by *querying* for them:

```objc
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", @"Divine Discontent"];
Record *retrievedRecord = [[Record instancesFilteredWithPredicate:predicate] firstObject];
```

Each instance of your subclass also has a `guid` property that is set right before the object is first saved. This is a unique ID, and you can use it to retrieve a specific object, too:

```objc
Record *favouriteRecord = [Record new];
favouriteRecord.title = @"Strangeland";
favouriteRecord.band = @"Keane";

[favouriteRecord save]; // Here, the guid property is set on favouriteRecord

NSString *recordId = favouriteRecord.guid;
Record *recordToShare = [Record instanceWithId:recordId];
```

<br>
## Updating an object

If you have an instance of your subclass of `PTModel`, you can simply modify one of its properties and call `save` on it to persist the changes.

```objc
// Using favouriteRecord from above...
favouriteRecord.title = @"Night Train";

[favouriteRecord save];
```

<br>
## Deleting an object

You can call `remove` on your `PTModel` subclass instance to delete it from the store.

```objc
[favouriteRecord remove];
```

If you want to empty your whole store, you can call `removeAllInstances` on your subclass:

```objc
[Record removeAllInstances];
```
<br>

---
# Installation

`PTModel` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PTModel"
```
<br>

---
# Author

Oscar Swanros @ Pacific3, [hola@pacific3.net](mailto:hola@pacific3.net)
<br>

---
## License

`PTModel` is available under the MIT license. See the LICENSE file for more info.
