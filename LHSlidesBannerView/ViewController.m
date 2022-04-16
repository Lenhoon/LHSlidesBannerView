//
//  ViewController.m
//  LHSlidesBannerView
//
//  Created by 张令浩 on 2022/4/16.
//

#import "ViewController.h"

#import "LHSlidesBannerView.h"

@interface ViewController () <LHSlidesBannerViewDelegate, LHSlidesBannerViewDataSource>
@property (weak, nonatomic) IBOutlet LHSlidesBannerView *statciSlidesBannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // configs UI
    [self setupStaticSlidesBannerView];
}

- (void)setupStaticSlidesBannerView {
    //
    self.statciSlidesBannerView.delegate = self;
    self.statciSlidesBannerView.dataSource = self;
    
    [self.statciSlidesBannerView reloadData];
}

#pragma mark - LHSlidesBannerViewDataSource
-(NSArray* _Nonnull)cycleRollViewRollingItems {
    return @[@"lhslidesbannerview_cover1",
             @"lhslidesbannerview_cover2"];
}

- (BOOL)supportInfiniteLoop {
    return YES;
}
@end
