#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LibLockscreen.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>


@interface CenterConsole : UIImageView{
NSMutableDictionary *notifications;
int notificationIndex;
UILabel *notificationNumber;
UILabel *notificationTitle;
UILabel *notificationMessage;
}


@end

@implementation CenterConsole

-(id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if(self){
    notifications = [[NSMutableDictionary alloc] init];
    notificationIndex = 0;
 NSTimer *aTimer = [NSTimer timerWithTimeInterval:20 target:self selector:@selector(cycleNotifications:) userInfo:nil repeats:YES];

    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:aTimer forMode: NSDefaultRunLoopMode];  
   
}

  return self;
}

-(void)cycleNotifications:(NSTimer*)timer{
if(!notificationNumber){
  notificationNumber = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 150, 20)];
  notificationNumber.textAlignment = UITextAlignmentCenter;
  notificationNumber.font = [UIFont fontWithName:@"Thonburi" size:18];
  notificationNumber.textColor = [UIColor whiteColor];
  notificationNumber.backgroundColor = [UIColor clearColor];
  //notificationNumber.shadowColor = [UIColor blackColor];
  //timeLabel.shadowOffset = CGSizeMake(0,1);
  
  [self addSubview:notificationNumber];
  [notificationNumber release];

  notificationTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 150, 20)];
  notificationTitle.textAlignment = UITextAlignmentCenter;
  notificationTitle.font = [UIFont fontWithName:@"Thonburi" size:20];
  notificationTitle.textColor = [UIColor whiteColor];
  notificationTitle.backgroundColor = [UIColor clearColor];
  //notificationNumber.shadowColor = [UIColor blackColor];
  //timeLabel.shadowOffset = CGSizeMake(0,1);
  
  [self addSubview:notificationTitle];
  [notificationTitle release];

  notificationMessage = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 150, 20)];
  notificationMessage.textAlignment = UITextAlignmentCenter;
  notificationMessage.font = [UIFont fontWithName:@"Thonburi" size:14];
  notificationMessage.textColor = [UIColor whiteColor];
  notificationMessage.backgroundColor = [UIColor clearColor];
  //notificationNumber.shadowColor = [UIColor blackColor];
  //timeLabel.shadowOffset = CGSizeMake(0,1);
  notificationMessage.numberOfLines = 2;
  notificationMessage.lineBreakMode = UILineBreakModeWordWrap;
  [self addSubview:notificationMessage];
  [notificationMessage release];

  notificationIndex = notificationIndex + 1; //So it will go to a different one next time?
}

NSLog(@"Running through things.");
int maxNotifications = [[notifications allKeys] count] - 1;
if(notificationIndex >= maxNotifications){
  NSLog(@"Internal count");
if([[notifications allKeys] count] <= 0){
  return;
}
else{
  notificationIndex = 0;
}
}
NSLog(@"Getting the section");
NSMutableDictionary * notificationSection = [notifications objectForKey:[[notifications allKeys] objectAtIndex:notificationIndex]];
NSLog(@"Getting the notification");
NSMutableDictionary * notification = [[notificationSection objectForKey:@"notifications"] objectAtIndex:0];

NSLog(@"Getting the count of notifications");
notificationNumber.text = [NSString stringWithFormat:@"%i, %@", [[notificationSection objectForKey:@"notifications"] count], [notification objectForKey:@"appName"]];
notificationTitle.text = [NSString stringWithFormat:@"%@", [notification objectForKey:@"title"]];
notificationMessage.text = [NSString stringWithFormat:@"%@", [notification objectForKey:@"message"]];

notificationIndex = notificationIndex + 1;

if(timer){
[timer isValid];
}
}

//Quite ugly... it works though.
-(void)addNotification:(NSMutableDictionary *)notification{
  //Already in the "database"?
if([notifications objectForKey:[notification objectForKey:@"bundleID"]]){
NSMutableDictionary *section = [notifications objectForKey:[notification objectForKey:@"bundleID"]];
NSMutableArray *sectionNotifications = [section objectForKey:@"notifications"];
[sectionNotifications addObject:notification];
}
else{
  NSMutableDictionary *section = [[NSMutableDictionary alloc] init];
  NSMutableArray *sectionNotifications = [[NSMutableArray alloc] init];
  [sectionNotifications addObject:notification];
  [section setObject:sectionNotifications forKey:@"notifications"];
  [notifications setObject:section forKey:[notification objectForKey:@"bundleID"]];
  [section release];
  [sectionNotifications release];
}
[self cycleNotifications:nil];
}
@end

@interface Example1LibLockscreen : UIView <LibLockscreen> {
  UILabel *timeLabel;
  UILabel *dateLabel;
  CenterConsole *console;
  UIImageView *consoleShadow;
}
LibLSController *controller;
-(void)showAlert:(NSString*)alertText;
-(float)liblsVersion;
-(void)showMediaControls:(BOOL)show;
-(void)updateClock;
-(void)receivedNotification:(NSMutableDictionary *)notification;
@end


@implementation Example1LibLockscreen
-(UIView *)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
   NSBundle *lsBundle = [NSBundle bundleForClass:[self class]];
    controller = [objc_getClass("SBAwayController") sharedLibLSController];
		self.backgroundColor = [UIColor colorWithPatternImage:[controller backgroundImage]];
 


  timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,320,100)];
  timeLabel.textAlignment = UITextAlignmentCenter;
  timeLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:64];
  timeLabel.textColor = [UIColor whiteColor];
  timeLabel.backgroundColor = [UIColor clearColor];
  timeLabel.shadowColor = [UIColor blackColor];
  timeLabel.shadowOffset = CGSizeMake(0,1);
  [self updateClock];
  [self addSubview:timeLabel];
  [timeLabel release];

  //Center console things... Maybe...
  consoleShadow = [[UIImageView alloc] initWithFrame:CGRectMake(30, 180, 275, 275)];
  consoleShadow.image = [UIImage imageWithContentsOfFile:[lsBundle pathForResource:@"ShadowBlack@2x" ofType:@"png"]];
  [self addSubview:consoleShadow];
  [consoleShadow release];

  console = [[CenterConsole alloc] initWithFrame:CGRectMake(40, 190, 250, 250)];
  console.image = [UIImage imageWithContentsOfFile:[lsBundle pathForResource:@"CenterConsole@2x" ofType:@"png"]];
  [self addSubview:console];
  [console release];

UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
[button addTarget:self 
           action:@selector(unlock)
 forControlEvents:UIControlEventTouchDown];
[button setTitle:nil forState:UIControlStateNormal];
button.frame = console.frame;
[self addSubview:button];

	}
	return self;
}


-(void)unlock{
  [controller unlock];
}

-(float)liblsVersion{
  return 0.1;
}

-(void)updateClock{
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSDate *date = [NSDate date];
  
  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
  [dateFormatter setDateFormat:@"hh:mm"];

  NSString *timeString = [dateFormatter stringFromDate:date];
  
  timeLabel.text = [NSString stringWithFormat:@"%@", timeString];

[pool drain];
}

-(void)showMediaControls:(BOOL)show{
  if(show){
              UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"LibLockscreen Info"
                                       message: @"Show media controls method was called"
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            [alert release];
          }
          else{
             UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"LibLockscreen Info"
                                       message: @"Hide media controls method was called"
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            [alert release];
          }
}

-(void)receivedNotification:(NSMutableDictionary *)notification{
 [console addNotification:notification];
}


@end

// vim:ft=objc
