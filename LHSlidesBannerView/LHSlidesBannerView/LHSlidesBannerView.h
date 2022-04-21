//
//  LHSlidesBannerView.h
//  LHSlidesBannerView
//
//  Created by 张令浩 on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "LHSlidesBannerIndicatorViewProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@class LHSlidesBannerView;

typedef NS_ENUM(NSUInteger, LHSlidesBannerViewIndicatorPosition) {
    LHSlidesBannerViewIndicatorPositionTopCenter =  1 << 0, /**< 顶部居中0000 0001 */
    LHSlidesBannerViewIndicatorPositionBottomCenter = 1 << 1, /**< 底部居中0000 0010 */
    LHSlidesBannerViewIndicatorPositionLeftCenter = 1 << 2, /**< 居左居中0000 0100 */
    LHSlidesBannerViewIndicatorPositionRightCenter = 1 << 3, /**< 居右居中0000 1000 */
    LHSlidesBannerViewIndicatorPositionTopLeft = LHSlidesBannerViewIndicatorPositionTopCenter | LHSlidesBannerViewIndicatorPositionLeftCenter, /**< 左上 0101 */
    LHSlidesBannerViewIndicatorPositionTopRight = LHSlidesBannerViewIndicatorPositionTopCenter | LHSlidesBannerViewIndicatorPositionRightCenter, /**< 右上 1001 */
    LHSlidesBannerViewIndicatorPositionBottomLeft = LHSlidesBannerViewIndicatorPositionBottomCenter | LHSlidesBannerViewIndicatorPositionLeftCenter, /**< 左下 0011 */
    LHSlidesBannerViewIndicatorPositionBottomRight = LHSlidesBannerViewIndicatorPositionBottomCenter | LHSlidesBannerViewIndicatorPositionRightCenter, /**< 右下 1010 */
};

@protocol LHSlidesBannerViewDataSource <NSObject>
@required
- (NSArray* _Nonnull)itemsInSlidesBannerView:(UIView *)slidesBannerView; /**< 轮播图片Urls */
@optional
/// 使用本地图片的资源Bundle, 默认为NSMainBundle
- (NSBundle *)resourcesBundle;
@end


@protocol LHSlidesBannerViewDelegate <NSObject>

@optional
/// 默认不支持无限循环轮播 YES:支持 NO:不支持
- (BOOL)supportInfiniteLoopInSlidesBannerView:(UIView *)slidesBannerView;
/// 默认支持自动滚动
- (BOOL)supportAutoScrollInSlidesBannerView:(UIView *)slidesBannerView;
// 默认为2秒
- (CGFloat)autoScrollTimeIntervalInSlidesBannerView:(UIView *)slidesBannerView;

/// 默认是按比例拉伸(UIViewContentModeScaleAspectFill),多余部分截掉
- (UIViewContentMode)itemImageContentModeInSlidesBannerView:(UIView *)slidesBannerView;

//MARK:滑动事件相关
/// 点击事件回调
- (void)slidesBannerView:(LHSlidesBannerView *)slidesBannerView didClickedItemAtIndex:(NSUInteger)index;
/// 滑动事件回调
- (void)slidesBannerView:(LHSlidesBannerView *)slidesBannerView didScrolledToIndex:(NSUInteger)index;

//MARK:PageCountIndicator相关
/// 是否展示指示器 默认展示
- (BOOL)showIndicatorView;
/// 指示器 默认实现为0/1样式
- (UIView<LHSlidesBannerIndicatorViewProtocol> *)indicatorViewInCycleRollView;
/// 指示器位置 默认:LHSlidesBannerViewIndicatorPositionBottomRight 右下
- (LHSlidesBannerViewIndicatorPosition)indicatorViewPostion;
/// 指示器EdgeInsets 只会根据LHSlidesBannerViewIndicatorPosition取相应位置上的值 默认(CGFLOAT_MAX, CGFLOAT_MAX, 23.f, 14.f)
- (UIEdgeInsets)indicatorViewEdgeInsetsInCycleRollView;
@end

@interface LHSlidesBannerView : UIView
@property (nonatomic, weak) id<LHSlidesBannerViewDataSource> dataSource;
@property (nonatomic, weak) id<LHSlidesBannerViewDelegate> delegate;
// 重新加载
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
