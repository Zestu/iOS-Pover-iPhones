# iOS-Pover-iPhones
View like a popover controller and can be presented on iPhones. Currently in developing stage.  Written on Objective-C. 

#### Usage:

*Initialization:*

```objective-c
ZGPopoverView *popover = [[ZGPopoverView alloc] init];
popover.contentView = contentView;
```
*Call:*
    
```objective-c
[self.popover presentArrowPointsTo:pointAt fromView:parentView];
```

##### Screenshot:
![alt text][logo]
[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png
