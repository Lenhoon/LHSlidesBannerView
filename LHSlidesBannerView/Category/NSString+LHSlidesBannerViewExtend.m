//
//  NSString+LHSlidesBannerViewExtend.m
//  LHSlidesBannerView
//
//  Created by LH on 2022/4/16.
//

#import "NSString+LHSlidesBannerViewExtend.h"

@implementation NSString (LHSlidesBannerViewExtend)
- (CGSize)lh_sizeWithContainer:(CGSize)size textFont:(UIFont *)font maxNumberOfLines:(NSInteger)lines {
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = self;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = lines;
    label.font = font;
    
    CGSize realSize = [label sizeThatFits:size];
    return CGSizeMake(ceilf(realSize.width), ceilf(realSize.height));
}
@end
