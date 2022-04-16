//
//  NSString+LHSlidesBannerViewExtend.h
//  LHSlidesBannerView
//
//  Created by 张令浩 on 2022/4/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LHSlidesBannerViewExtend)
/// 获取字符串的宽高, UILabel计算
/// @param size 大小
/// @param font 字体
/// @param lines 行数
- (CGSize)lh_sizeWithContainer:(CGSize)size textFont:(UIFont *)font maxNumberOfLines:(NSInteger)lines;
@end

NS_ASSUME_NONNULL_END
