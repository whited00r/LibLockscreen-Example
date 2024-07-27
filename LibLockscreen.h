//Something something to add here.
@protocol LibLockscreen
-(UIView *)initWithFrame:(CGRect)frame;
-(float)liblsVersion; //In case there are updates to liblockscreen, I can provide legacy support for your plugin if I know the version.
@optional

//-----Passcode related stuff
-(void)passcodeFailed;
-(void)passcodeAccepted;
-(void)showPasscodeScreen:(BOOL)show; //Will be true for showing, will be false for hiding. 

//-----Clock methods
-(void)updateClock; //Called when the time changes. (I think)

//----Media information is good right?
-(void)showMediaControls:(BOOL)show;
-(void)setArtist:(NSString *)artist;
-(void)setAlbum:(NSString *)album;

//-----Call related things
-(void)receivingCall;
-(void)makeEmergencyCall:(BOOL)call;
-(void)receivedNotification:(NSMutableDictionary *)notification;
@end


@class SBAwayController;

@interface LibLSController : NSObject
+(LibLSController *)sharedLibLSController; //Shared instance is everything. It's a tweak, I'm allowed to do that.
-(void)unlock;  //Hard to guess what this does, right?
-(void)showPasscodeScreen:(BOOL)show; //So you can call it off if you only wanted to show some animation or whatever. Could be useful down the road.
-(UIImage *)backgroundImage;
@end