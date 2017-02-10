
#import "DCEventDetailHeaderCell.h"
#import "DCLevel.h"
#import "DCTrack.h"
#import "DCTimeRange+DC.h"
#import "NSDate+DC.h"
#import "DCEvent+DC.h"
#import "UIImage+Extension.h"
#import "DCConstants.h"

@implementation DCEventDetailHeaderCell

- (void) awakeFromNib {
  [super awakeFromNib];
  [self setCustomFonts];
  [self layoutIfNeeded];
}

- (void)initData:(DCEvent*)event {
  // this code makes labels in Cell resizable relating to screen size. Cell
  // height with layoutSubviews will work properly
  CGFloat preferredWidth = [UIScreen mainScreen].bounds.size.width - 30;
  self.titleLabel.preferredMaxLayoutWidth = preferredWidth;
  self.dateAndPlaceLabel.preferredMaxLayoutWidth = preferredWidth;

  self.titleLabel.text = event.name;

  NSString* date =
      event.date
          ? [DCDateHelper convertDate:event.date toApplicationFormat:@"EEE"]
          : @"";
  NSString *timeFormat = ([NSDate is24hourFormat])? @"HH:mm" : @"h:mm aaa";

  NSString* startTime = [DCDateHelper convertDate:event.startDate
                              toApplicationFormat:timeFormat];
  NSString* endTime =
      [DCDateHelper convertDate:event.endDate toApplicationFormat:timeFormat];
  date = [NSString stringWithFormat:@"%@, %@ - %@", date,
                                    startTime, endTime];

  self.eventDetailContainerView.backgroundColor =
      [DCAppConfiguration eventDetailHeaderColour];
  NSString* place = event.place ? event.place : @"";

  if (date.length && place.length)
    self.dateAndPlaceLabel.text =
        [NSString stringWithFormat:@"%@ in %@", date, place];
  else
    self.dateAndPlaceLabel.text =
        [NSString stringWithFormat:@"%@%@", date, place];

  DCTrack* track = [event.tracks anyObject];
  DCLevel* level = event.level;

  BOOL shouldHideTrackAndLevelView =
      (track.trackId.integerValue == 0 && level.levelId.integerValue == 0);

  if (!shouldHideTrackAndLevelView) {
    self.trackLabel.text = [(DCTrack*)[event.tracks anyObject] name];
    self.experienceLabel.text =
    event.level.name ? [NSString stringWithFormat:@"Experience level: %@",
                                                      event.level.name]
                         : nil;

    UIImage* icon = nil;
    switch (event.level.levelId.integerValue) {
      case 1:
        icon = [UIImage imageNamedFromBundle:@"ic_experience_beginner"];
        break;
      case 2:
        icon = [UIImage imageNamedFromBundle:@"ic_experience_intermediate"];
        break;
      case 3:
        icon = [UIImage imageNamedFromBundle:@"ic_experience_advanced"];
        break;
      default:
        break;
    }
    self.experienceIcon.image = icon;
  } else {
    self.trackAndLevelViewHeight.priority = 900;
    self.TrackAndLevelView.hidden = YES;
  }
  
  
  self.experienceLabel.text =
  event.level.levelId !=0 ? [NSString stringWithFormat:@"Experience level: %@",
                      event.level.name] : nil;
  self.experienceLabel.hidden = level.levelId.integerValue == 0;
  self.experienceIcon.hidden = level.levelId.integerValue == 0;
}

- (void)setCustomFonts {
    
  NSDictionary *fonts = [[DCConstants appFonts] objectForKey:kFontEventDetailsScreen];
  self.titleLabel.font = [fonts objectForKey:kFontTitle];
  self.dateAndPlaceLabel.font = [fonts objectForKey:kFontDescription];
  self.trackLabel.font = [fonts objectForKey:kFontDescription];
  self.experienceLabel.font = [fonts objectForKey:kFontDescription];
  
}

@end
