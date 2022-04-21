//
//  LHSlidesBannerItemView.m
//  LHSlidesBannerView
//
//  Created by LH on 2022/3/18.
//

#import "LHSlidesBannerItemView.h"

#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>

@interface LHSlidesBannerItemView ()
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, assign) UIViewContentMode imageContentMode; /**< 图片缩放样式 */
@end

@implementation LHSlidesBannerItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageContentMode = UIViewContentModeScaleAspectFill; /**< 默认按比例拉伸，多出部分被裁调 */
        _itemImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_itemImageView setClipsToBounds:YES];
        [self addSubview:_itemImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.itemImageView.frame = self.bounds;
}

/// 使用网络图片更新Item内容
/// @param imgUrl 网络图片URL
/// @param contentMode 拉伸方式
- (void)updateWithItemUrl:(NSURL *)imgUrl placeHodlerImage:(UIImage *)placeHodlerImg contentMode:(UIViewContentMode)contentMode {
    self.imageContentMode = contentMode;
    self.itemImageView.contentMode = contentMode;
    [self.itemImageView yy_setImageWithURL:imgUrl placeholder:placeHodlerImg];
    
    [self setNeedsLayout];
}

/// 使用本地图片更新Item内容
/// @param imageName 本地图片名称
/// @param contentMode 拉伸方式
/// @param bundle 资源所在bundle nil为默认主Bundle
- (void)updateWithLocalImageName:(NSString *)imageName bundle:(NSBundle * __nullable)bundle contentModel:(UIViewContentMode)contentMode {
    self.imageContentMode = contentMode;
    self.itemImageView.contentMode = contentMode;
    // 使用imageNamed会缓存图片 适合频繁使用且不是很大的图片
    self.itemImageView.image = [UIImage imageNamed:imageName inBundle:bundle ? bundle : [NSBundle mainBundle] compatibleWithTraitCollection:nil];
    
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.itemImageView.contentMode = _imageContentMode;
    self.itemImageView.image = nil;
    [self.itemImageView yy_cancelCurrentImageRequest];
}
@end
