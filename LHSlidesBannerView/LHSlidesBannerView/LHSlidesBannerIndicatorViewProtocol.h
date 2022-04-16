//
//  LHSlidesBannerIndicatorViewProtocol.h
//  LHSlidesBannerView
//
//  Created by 张令浩 on 2022/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHSlidesBannerIndicatorViewProtocol <NSObject>
@required
- (CGSize)sizeOfIndicatorView;
@optional
- (void)configIndicatorViewInitialIndexOf:(NSUInteger)index totalCount:(NSUInteger)totalCount;
- (void)changeIndicatorViewCurrentIndexTo:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
