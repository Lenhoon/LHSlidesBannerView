//
//  LHSlidesBannerView.m
//  LHSlidesBannerView
//
//  Created by LH on 2022/3/18.
//

#import "LHSlidesBannerView.h"

#import <objc/message.h>

#import "LHSlidesBannerItemView.h"

#import "LHSlidesBannerIndicatorView.h"

static const NSInteger kLHSlidesBannerViewMaximumCoefficient = 1000;
static NSString * const kLHSlidesBannerViewItemReuseIdentifier = @"LHSlidesBannerItemViewIdentifier";

@interface LHSlidesBannerView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView; /**< 使用CollectionView方式实现 */

@property (nonatomic, assign) NSInteger dataSourceCount; /**< 原始数据源数量 */
@property (nonatomic, assign) NSInteger itemsCount; /**< 实际CollectionView 数量 */
@property (nonatomic, assign) NSUInteger currentIndex; /**< 当前实际Index */
@property (nonatomic, strong, nullable) UIView<LHSlidesBannerIndicatorViewProtocol> *indicatorView; /**< 指示器 */

@end

@implementation LHSlidesBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    self.collectionView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * _itemsCount, CGRectGetHeight(self.bounds));
    [self layoutIndicatorView];
    
    if (_collectionView.contentOffset.x - CGRectGetWidth(self.bounds)*_currentIndex != 0) {
        [self.collectionView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * self.currentIndex, 0) animated:NO];
    }
    
}

- (void)setupUI {
    [self configCollectionViewDataSource];
    [self setupCollectionView];
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(showIndicatorView)]
        && (![self.delegate showIndicatorView])) {
        // 不展示 指示条
        self.indicatorView = nil;
        return;
    }
    
    // 默认展示
    [self setupIndicatorView];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}


- (void)configDataSource {
    [self configCollectionViewDataSource];
    if (_indicatorView) {
        [self.indicatorView configIndicatorViewInitialIndexOf:0 totalCount:_dataSourceCount];
    }
}

#pragma mark - 设置CollectionView
- (void)setupCollectionView {
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self cycleRollViewCollectionViewFlowLayout]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:LHSlidesBannerItemView.class forCellWithReuseIdentifier:kLHSlidesBannerViewItemReuseIdentifier];
    
    [self addSubview:self.collectionView];
}



/// 配置CollectionView数据源
- (void)configCollectionViewDataSource {
    self.dataSourceCount = [[self.dataSource itemsInSlidesBannerView: self] count];
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(supportInfiniteLoopInSlidesBannerView:)]
        && [self.delegate supportInfiniteLoopInSlidesBannerView: self]) {
        // 支持无限轮播
        self.itemsCount = self.dataSourceCount * kLHSlidesBannerViewMaximumCoefficient;
        self.currentIndex = self.dataSourceCount * (kLHSlidesBannerViewMaximumCoefficient/2);
        
        return;
    }
    
    self.currentIndex = 0;
    self.itemsCount = self.dataSourceCount;
}

- (UICollectionViewFlowLayout *)cycleRollViewCollectionViewFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return layout;
}

#pragma mark - 设置指示器
- (void)setupIndicatorView {
    
    if (_indicatorView == nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(indicatorViewInCycleRollView)]) {
            self.indicatorView = [self.delegate indicatorViewInCycleRollView];
        } else {
            self.indicatorView = [[LHSlidesBannerIndicatorView alloc] init];
        }
        [self addSubview:self.indicatorView];
    }
}

- (void)layoutIndicatorView {
    LHSlidesBannerViewIndicatorPosition indicatorPostion = LHSlidesBannerViewIndicatorPositionBottomRight;
    UIEdgeInsets indicatorViewEdgeInsets = UIEdgeInsetsMake(CGFLOAT_MAX, CGFLOAT_MAX, 23.f, 14.f);
    CGSize indicatorSize = [self.indicatorView sizeOfIndicatorView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indicatorViewPostion)]) {
        indicatorPostion = [self.delegate indicatorViewPostion];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(indicatorViewEdgeInsetsInCycleRollView)]) {
        indicatorViewEdgeInsets = [self.delegate indicatorViewEdgeInsetsInCycleRollView];
    }
    
    CGFloat indicatorX, indicatorY;
    // 水平方向
    if (indicatorPostion & LHSlidesBannerViewIndicatorPositionLeftCenter) {
        // 水平居左
        indicatorX = indicatorViewEdgeInsets.left;
    } else if (indicatorPostion & LHSlidesBannerViewIndicatorPositionRightCenter) {
        // 水平居右
        indicatorX = CGRectGetWidth(self.bounds) - indicatorViewEdgeInsets.right - indicatorSize.width;
    } else {
        // 水平居中
        indicatorX = CGRectGetMaxX(self.bounds) - ceil(indicatorSize.width/2.0f);
    }
    // 垂直方向
    if (indicatorPostion & LHSlidesBannerViewIndicatorPositionTopCenter) {
        // 垂直居上
        indicatorY = indicatorViewEdgeInsets.top;
    } else if (indicatorPostion & LHSlidesBannerViewIndicatorPositionBottomCenter) {
        // 垂直居下
        indicatorY = CGRectGetHeight(self.frame) - indicatorViewEdgeInsets.bottom - indicatorSize.height;
    } else {
        // 垂直居中
        indicatorY = CGRectGetMidY(self.frame) - ceil(indicatorSize.height/2.0f);
    }
    
    self.indicatorView.frame = CGRectMake(indicatorX, indicatorY, indicatorSize.width, indicatorSize.height);
}


#pragma mark - Action
- (void)reloadData {
    
    // 配置数据源
    [self configDataSource];
    
    
    NSUInteger index = _currentIndex % self.dataSourceCount;
    [self scrollToItemIndexOf:index];
    
    [self.collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(supportAutoScrollInSlidesBannerView:)]) {
        if (![self.delegate supportAutoScrollInSlidesBannerView: self]) {
            // 不支持自动滚动 - return
            return;
        }
    }
}

/// 滚动到第index个Item
/// @param index 实际Index
- (void)scrollToItemIndexOf:(NSUInteger)index {
    NSUInteger currentIndex = index % self.dataSourceCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidesBannerView:didScrolledToIndex:)]) {
        [self.delegate slidesBannerView:self didScrolledToIndex:currentIndex];
    }
    [self.indicatorView changeIndicatorViewCurrentIndexTo:currentIndex+1];
    [self layoutIndicatorView];
}

- (void)clickItemIndexOf:(NSUInteger)index {
    NSUInteger currentIdex = index % self.dataSourceCount;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slidesBannerView:didClickedItemAtIndex:)]) {
        [self.delegate slidesBannerView:self didClickedItemAtIndex:(NSUInteger)currentIdex];
        [self scrollToItemIndexOf:currentIdex];
    }
}

#pragma mark - Action
- (void)scrollToNextPape {
    NSUInteger nextIndex =  self.collectionView.contentOffset.x / CGRectGetWidth(self.bounds) + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemsCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LHSlidesBannerItemView *collectionViewItem = nil;
    NSUInteger currentIdex = indexPath.row % self.dataSourceCount;
    if (currentIdex < self.dataSourceCount) {
        collectionViewItem = [collectionView dequeueReusableCellWithReuseIdentifier:kLHSlidesBannerViewItemReuseIdentifier forIndexPath:indexPath];
    }
    if (collectionViewItem == nil) {
        collectionViewItem = [[LHSlidesBannerItemView alloc] init];
    }
    
    return collectionViewItem;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger currentIdex = indexPath.row % self.dataSourceCount;
    if (currentIdex < self.dataSourceCount) {
        NSUInteger currentIdex = indexPath.row % self.dataSourceCount;
        id data = [[self.dataSource itemsInSlidesBannerView: self] objectAtIndex:currentIdex];
        LHSlidesBannerItemView *collectionViewItem = (LHSlidesBannerItemView *)cell;
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemImageContentModeInSlidesBannerView:)]) {
            [self updateItem:collectionViewItem itemData:data placeHodlerImage:nil contentMode:[self.delegate itemImageContentModeInSlidesBannerView: self]];
        } else {
            // 默认:UIViewContentModeScaleAspectFill
            [self updateItem:collectionViewItem itemData:data placeHodlerImage:nil contentMode:UIViewContentModeScaleAspectFill];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self clickItemIndexOf:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX < 0 || offsetX > CGRectGetWidth([UIScreen mainScreen].bounds) * (_itemsCount - 1)) {
            // 左滑 && 右滑边界判断
            return;
        }
        
        // 计算滑动的距离
        CGFloat scrolledRatio = offsetX / CGRectGetWidth([UIScreen mainScreen].bounds); // 滑动比例
        NSUInteger scrolledPageCount = floorf(scrolledRatio); // 当前以滑过的Page数
        CGFloat currentPageScrollRadio = scrolledRatio - scrolledPageCount; // 当前页面滑过的比例
        
        // 目标页
        NSInteger targetPageIndex;
        
        // 判断 当前指示页面  是否滑动到下一页
        if (currentPageScrollRadio > 0.5) {
            targetPageIndex = scrolledPageCount + 1;
        } else {
            targetPageIndex = scrolledPageCount;
        }
        if (self.currentIndex != targetPageIndex) {
            self.currentIndex = targetPageIndex;
           
            [self scrollToItemIndexOf:_currentIndex];
        }
        if (currentPageScrollRadio == 0) {
            self.currentIndex = scrolledPageCount;
            [self scrollToItemIndexOf:_currentIndex];
        }
    }
}

#pragma mark - Private
- (void)updateItem:(LHSlidesBannerItemView *)itemView itemData:(id __nonnull)data placeHodlerImage:(UIImage * __nullable)placeHolder contentMode:(UIViewContentMode)contentMode {
    
    if ([data isKindOfClass:NSString.class]) {
        // 本地图片
        NSString *imageName = (NSString *)data;
        NSBundle *bundle;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(resourcesBundle)]) {
            bundle = [self.dataSource resourcesBundle];
        }
        [itemView updateWithLocalImageName:imageName bundle:bundle contentModel:contentMode];
    } else if ([data isKindOfClass:UIImage.class]) {
        // 服务器图片
        NSURL *imageUrl = (NSURL *)data;
        [itemView updateWithItemUrl:imageUrl placeHodlerImage:placeHolder contentMode:contentMode];
    } else {
        NSAssert(NO, @"LHSlidesBannerView数据源必须是NSURL或NSString类型");
    }
}

@end
