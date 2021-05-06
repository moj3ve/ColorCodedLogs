@interface UIView (ColorCodedLogs)
	-(UIViewController*)_viewControllerForAncestor;
@end

@interface CHRecentCall : NSObject
	@property unsigned int callStatus;
@end

@interface NUIContainerStackView
	-(NSArray<UIView *> *)arrangedSubviews;
@end

@interface MPRecentsTableViewCell
	@property (nonatomic,retain) NUIContainerStackView * titleStackView;
	@property (nonatomic,retain) NUIContainerStackView * subtitleStackView;
@end

@interface MPRecentsTableViewController : UIViewController
	-(CHRecentCall *)recentCallAtTableViewIndex:(NSInteger)index;
@end


%hook MPRecentsTableViewController

	-(id)tableView:(id)arg1 cellForRowAtIndexPath:(NSIndexPath *)arg2
	{
		MPRecentsTableViewCell *orig = %orig;

		CHRecentCall *callInfo = [self recentCallAtTableViewIndex:arg2.row];

		UIColor *cellColor = nil;

		//incoming call : 1
		//answered elsewhere (another device) : 4
		if (callInfo.callStatus == 1 || callInfo.callStatus == 4)
			cellColor = [UIColor systemBlueColor];
		//outgoing call : 2
		//outgoing but cancelled : 16
		else if (callInfo.callStatus == 2 || callInfo.callStatus == 16)
			cellColor = [UIColor systemGreenColor];


	 if (cellColor)
	 {
		 for(UIView *view in orig.titleStackView.arrangedSubviews)
 		{
 			if ([view isKindOfClass:[UILabel class]])
 				[(UILabel*)view setTextColor:cellColor];
 		}

		if (MSHookIvar<UIImageView*>(orig,"_callTypeIconView"))
 			[MSHookIvar<UIImageView*>(orig,"_callTypeIconView") setTintColor:cellColor];
 		//[MSHookIvar<UIImageView*>(orig,"_verifiedBadgeView") setTintColor:cellColor];
	 }

		return orig;
	}

%end
