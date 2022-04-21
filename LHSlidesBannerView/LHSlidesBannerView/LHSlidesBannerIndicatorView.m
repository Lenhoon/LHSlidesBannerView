//
//  LHSlidesBannerIndicatorView.m
//  LHSlidesBannerView
//
//  Created by LH on 2022/3/21.
//

#import "LHSlidesBannerIndicatorView.h"

#import "NSString+LHSlidesBannerViewExtend.h"

@interface LHSlidesBannerIndicatorView ()
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) NSUInteger totalCount;
@property (nonatomic, strong) UILabel *countIndicatorLable;

@end

@implementation LHSlidesBannerIndicatorView
- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentIndex = 0;
        _totalCount = 0;
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self lableWidth] + 6.f*2, 20.f);
    self.countIndicatorLable.frame = CGRectMake(6.f, 2.f, [self lableWidth], 16.f);
}

- (void)setupUI {
    self.countIndicatorLable = [[UILabel alloc] init];
    self.countIndicatorLable.textColor = [UIColor whiteColor];
    self.countIndicatorLable.font = [UIFont systemFontOfSize:12.f];
    self.countIndicatorLable.textAlignment = NSTextAlignmentCenter;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.f;
    [self addSubview:self.countIndicatorLable];
}

- (CGFloat)lableWidth {
    NSString *text = [NSString stringWithFormat:@"%lu/%lu", _currentIndex, _totalCount];
    CGFloat textWidth = ceil([text lh_sizeWithContainer:CGSizeMake(CGFLOAT_MAX, 16.f) textFont:[UIFont systemFontOfSize:12.f] maxNumberOfLines:1].width);
    return textWidth;
}

#pragma mark - LHSlidesBannerIndicatorViewProtocol
- (CGSize)sizeOfIndicatorView {
    return CGSizeMake([self lableWidth] + 6.f*2, 20.f);
}

- (void)configIndicatorViewInitialIndexOf:(NSUInteger)index totalCount:(NSUInteger)totalCount {
    _currentIndex = index;
    _totalCount = totalCount;
    self.countIndicatorLable.text = [NSString stringWithFormat:@"%lu/%lu", _currentIndex, _totalCount];
    [self layoutIfNeeded]; // 立即刷新
    
}

- (void)changeIndicatorViewCurrentIndexTo:(NSUInteger)index {
    self.currentIndex = index;
    self.countIndicatorLable.text = [NSString stringWithFormat:@"%lu/%lu", index, _totalCount];
    [self layoutIfNeeded]; // 立即刷新
}

@end
