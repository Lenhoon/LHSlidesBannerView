//
//  LHSlidesBannerItemView.h
//  LHSlidesBannerView
//
//  Created by 张令浩 on 2022/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHSlidesBannerItemView : UICollectionViewCell

/// 使用数据更新Item
/// 使用网络图片更新Item内容
/// @param imgUrl 网络图片URL
/// @param contentMode 拉伸方式
- (void)updateWithItemUrl:(NSURL *)imgUrl placeHodlerImage:(UIImage *)placeHodlerImg contentMode:(UIViewContentMode)contentMode;

/// 使用本地图片更新Item内容
/// @param imageName 本地图片名称
/// @param contentMode 拉伸方式
/// @param bundle 资源所在bundle nil为默认主Bundle
- (void)updateWithLocalImageName:(NSString *)imageName bundle:(NSBundle * __nullable)bundle contentModel:(UIViewContentMode)contentMode;
@end

NS_ASSUME_NONNULL_END
