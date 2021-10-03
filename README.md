# Caffeine


Alright so just a heads up, this does no parsing of the frameworks in `dyld_shared_cache`, nor does it parse any MachO files, and I don't actually plan on having this project do that. I think that it's at an EOL before it has even released because I want to make a tool that does that and more separately. I hope all of you understand. 

With that out of the way, lets get into usage.

*If someone wants to PR to fix this broken thing, that would make my day.* 


# Lib Usage
### Prerequisites
You need to make sure that you are on swift >= 5.5 as this uses a newer version of SPM

To dump the interface of an obj-c class, just pop the class into the `ClassInfo` struct like this:
```swift
let classNameString: UnsafePointer<CChar> = NSString("SomeObject").UTF8String
let ourClass: AnyClass? = objc_getClass(classNameString)
guard ourClass != nil else {
    // Throw whatever error here beccause the class needs to be loaded into memory
}
let classInfo: ClassInfo = ClassInfo(withClass: ourClass!)
```

Then pop the info of the class into an `InterfaceWrapper` like so:
```swift
let wrapper: InterfaceWrapper(withInfo: classInfo)
```

You can now use the header and print it out by calling `wrapper.stringRepresentation`

...

Oh yeah, I forgot to mention that there are preferences too. They are under `DumpOptions.shared`.
Feel free to explore!


# Command Line Usage

### Example output:
A bit sliced because this represented that it can handle pretty much anything in memory
```
(base) ➜  ~ decaf brew -m --private Admin
...

@interface Group : DSRecord {

    NSNumber *mGUIDNumber; // offset: 40
    NSMutableArray *mUsers; // offset: 48
    NSMutableArray *mUserGUIDs; // offset: 56
    NSMutableArray *mNestedGUIDs; // offset: 64
    BOOL mGUIDChecked; // offset: 72
    BOOL mHasGUID; // offset: 73
    NSString *mUUIDString; // offset: 80
    NSString *mRealNameString; // offset: 88

}


+ (id) findGroupByName:(id)arg1;
+ (long long) nextFreeGroupID;
+ (id) createGroupWithName:(id)arg1 realName:(id)arg2 gid:(long long)arg3 inNode:(id)arg4;
+ (id) findGroupByID:(long long)arg1;
+ (id) adminGroup;
+ (id) findGroupByName:(id)arg1 node:(id)arg2;
+ (long long) nextFreeGroupIDInRange:(_NSRange)arg1;
+ (id) allLocalGroups;
+ (id) createGroupWithName:(id)arg1 gid:(long long)arg2 inNode:(id)arg3;
+ (id) findGroupByGUID:(CFUUID *)arg1;
+ (id) wcCreateGroupWithName:(id)arg1 realName:(id)arg2;
- (void) dealloc;
- (long long) gid;
- (void) refresh;
- (BOOL) addMember:(id)arg1;
- 
...
```


### Prerequisites
The command `decaf` requires that xcode + command line tools are installed to `/Applications/Xcode.app`

There are two subcommands included:
```
  list                    List available frameworks.
  brew                    Dump a frameworks classes.
```

*Note: Each flag has a short version too*
#

### `brew`

```
USAGE: decaf brew [--macos] [--ios] [--tvos] [--watchos] [--private] [--info] [<framework-name>]
```
You use the `dump` command to dump a framework from a path you have already seen using the `list` command.

### `list`

```
USAGE: decaf list [--macos] [--ios] [--tvos] [--watchos] [--private] [--all] [--custom <custom>] [--limit <limit>]
```

You can use the `list` command to see the frameworks available to dump (Doesn't check if they are broken or not)
It will also print out the version and bundle ID of the framework.
#
### Flags
##### Un-implemented Flags:
###### dump only:
- View more info about a certain Framework: `--info`

###### Shared Flags:
- List MacOS Frameworks: `-m, --macos`
- List iOS Frameworks: `-i, --ios`
- List tvOS Frameworks: `-t, --tvos`
- List WatchOS Frameworks: `-w, --watchos`
- Look inside of the `PrivateFrameworks` directory: `-p, --private`

###### List only:
- Limit the output of the list: `--limit <limit> (default: 50)`
- List all frameworks: `-a, --all`
- Use a custom framework path: `--custom <custom path>`

#
Copyright © https://github.com/c0dine, all rights reserved
