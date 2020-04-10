//
//  TOInsetGroupedTableView.m
//  TOInsetGroupedTableView
//
//  Created by Tim Oliver on 2020/04/08.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import "TOInsetGroupedTableView.h"

#define DEBUG_TOINSETGROUPEDTABLEVIEW 1

/**
 The KVO key we'll be using to detect when the table view
 manipulates the shape of any of the subviews
*/
static NSString * const kTOInsetGroupedTableViewFrameKey = @"frame";

/**
 By default, scroll view indicators are added to the table view
 with this initial size */
static CGSize const kTOInsetGroupedTableViewScrollIndicatorSize = (CGSize){2.5f, 2.5f};

/** The corner radius of the top and bottom cells.
 This is hard-coded with the same value as in iOS 13.
 */
static CGFloat const kTOInsetGroupedTableViewCornerRadius = 10.0f;

@interface TOInsetGroupedTableView ()

/**
 A set to store a reference to each view that we attached
 a KVO observer to.
 */
@property (nonatomic, strong) NSMutableSet *observedViews;

@end

@implementation TOInsetGroupedTableView

#pragma mark - View Life-cycle -

- (instancetype)init
{
    // Set a non-zero default frame value
    CGRect frame = (CGRect){0,0,320,480};
    
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
    // On iOS 13, cancel out to simply using the official grouped inset style
    if (@available(iOS 13.0, *)) {
        return [super initWithFrame:frame style:UITableViewStyleInsetGrouped];
    }
#endif
    
    // On iOS 12 and below, force the grouped style, and perform common setup
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
    // On iOS 13 and above, cancel out as we can simply use the official
    // grouped inset style.
    if (@available(iOS 13.0, *)) {
        return [super initWithFrame:frame style:UITableViewStyleInsetGrouped];
    }
#endif
    
    // On iOS 12 and below, make sure we explicitly force the grouped style
    if (self = [super initWithFrame:frame style:UITableViewStyleGrouped]) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder]) {
        // If the user left the style as "Plain" in IB, since we can't
        // override it here, throw an exception.
        // (Thankfully on iOS 12, IB will gracefully default it back to "Grouped")
        if (self.style < UITableViewStyleGrouped) {
            NSString *reason = @"TOInsetGroupedTableView: Make sure the table view style "
                                    "is set to \"Inset Grouped\" in Interface Builder";
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    
        // On iOS 12 or lower, perform the common set-up
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
        if (@available(iOS 13.0, *)) { return self; }
#endif
        
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    // Create the set to hold our observed views
    self.observedViews = [NSMutableSet set];
    
    // Explicitly disable any magic insetting, as we'll
    // be manually calculating the insetting ourselves
    self.insetsLayoutMarginsFromSafeArea = NO;
}

- (void)dealloc
{
    [self removeAllObservers];
}

#pragma mark - Table View Behaviour Overrides -

- (void)reloadData
{
    // Since all views will be removed and re-added,
    // potentially in different orders,
    // stop observing all views at this time.
    [self removeAllObservers];
    [super reloadData];
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
    if (@available(iOS 13.0, *)) { return; }
#endif

//    // Check if the view is a scroll indicator
//    BOOL isScrollIndicator = NO;
//    if (@available(iOS 13.0, *)) {
//        // In iOS 13, the scroll indicator gained its own class name
//        NSString *classString = NSStringFromClass(subview.class);
//        isScrollIndicator = [classString rangeOfString:@"ScrollIndicator"].location != NSNotFound;
//    }
//    else {
//        // In iOS 12 and below, it is a simple image view with a static size
//        isScrollIndicator = CGSizeEqualToSize(subview.frame.size, kTOInsetGroupedTableViewScrollIndicatorSize);
//        isScrollIndicator = isScrollIndicator && [subview isKindOfClass:[UIImageView class]];
//    }
    
//    // Skip if the view is one of the scroll indicators
//    if (isScrollIndicator) { return; }

    // If it's not a section header/footer view, or a table cell, ignore it
    if (![subview isKindOfClass:[UITableViewHeaderFooterView class]] &&
        ![subview isKindOfClass:[UITableViewCell class]])
     {
        return;
    }

    // Register this view for observation
    [self addObserverIfNeeded:subview];
}

#pragma mark - Observer Life-cycle -

- (void)addObserverIfNeeded:(UIView *)view
{
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
    if (@available(iOS 13.0, *)) { return; }
#endif
    
    // If the view had already been registered, exit out,
    // otherwise a system exception will be thrown
    if ([self.observedViews containsObject:view]) {
        return;
    }
    
    // Register the view and add it to our set
    [view addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [self.observedViews addObject:view];
}

- (void)removeAllObservers
{
#ifndef DEBUG_TOINSETGROUPEDTABLEVIEW
    if (@available(iOS 13.0, *)) { return; }
#endif
    
    // Loop through each object in the set, and de-register them
    for (UIView *view in self.observedViews) {
        [view removeObserver:self
                  forKeyPath:kTOInsetGroupedTableViewFrameKey
                     context:nil];
    }
    
    // Clean out all of the views from the set
    [self.observedViews removeAllObjects];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    // Double check this is notification is for an observer we set
    if ([object isKindOfClass:[UIView class]] == NO) { return; }
    if ([keyPath isEqualToString:kTOInsetGroupedTableViewFrameKey] == NO) { return; }
    
    // Perform the inset layout on this view
    [self performInsetLayoutForView:object];
}

#pragma mark - Behaviour Overrides -

- (void)performInsetLayoutForView:(UIView *)view
{
    CGRect frame = view.frame;
    UIEdgeInsets margins = self.layoutMargins;
    UIEdgeInsets safeAreaInsets = self.safeAreaInsets;
    
    // Calculate the left margin.
    // If the margin on its own isn't larger than the safe area inset,
    // combine the two.
    CGFloat leftInset = margins.left;
    if (leftInset - safeAreaInsets.left < 0.0f - FLT_EPSILON) {
        leftInset += safeAreaInsets.left;
    }
    
    // Calculate the right margin with the same logic.
    CGFloat rightInset = margins.right;
    if (rightInset - safeAreaInsets.right < 0.0f - FLT_EPSILON) {
        rightInset += safeAreaInsets.right;
    }
    
    // Calculate offset and width off the insets
    frame.origin.x = leftInset;
    frame.size.width = CGRectGetWidth(self.frame) - (leftInset + rightInset);
    
    // Apply the new value to the underlying CALayer
    // to avoid triggering the KVO observer into an infinite loop
    view.layer.frame = frame;
    
    // If the view is a table view cell, apply the rounded corners as needed
    if ([view isKindOfClass:[UITableViewCell class]]) {
        [self applyRoundedCornersToTableViewCell:(UITableViewCell *)view];
    }
}

- (void)applyRoundedCornersToTableViewCell:(UITableViewCell *)cell
{
    // Set flags for checking both top and bottom
    BOOL topRounded = NO;
    BOOL bottomRounded = NO;
    
    // Since the separators may not have been updated for their
    // new position/sizing yet, force a layout before we do a check
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // The maximum height a separator might be
    CGFloat separatorHeight = 1.0f;
    
    // Loop through each subview
    for (UIView *subview in cell.subviews) {
        CGRect frame = subview.frame;
        
        // Separators will always be less than 1 point high
        if (frame.size.height > separatorHeight) { continue; }
        
        // If the X origin isn't 0, it's a separator we want to keep.
        // Since it may have been a border separator we hid before, un-hide it.
        if (frame.origin.x > FLT_EPSILON) {
            subview.hidden = NO;
            continue;
        }
        
        // Check if it's a top or bottom separator
        if (frame.origin.y < FLT_EPSILON) {
            topRounded = YES;
        }
        else {
            bottomRounded = YES;
        }
        
        // Hide this view to get a clean looking border
        subview.hidden = YES;
    }
    
    BOOL needsRounding = (topRounded || bottomRounded);
    
    // Configure the view to be clipped as needed
    cell.layer.masksToBounds = needsRounding;
    
    // Set the corner radius as needed
    cell.layer.cornerRadius = needsRounding ? kTOInsetGroupedTableViewCornerRadius : 0.0f;
    
    // Set which corners need to be rounded depending on top or bottom
    NSUInteger cornerRoundingFlags = 0;
    if (topRounded) {
        cornerRoundingFlags |= (kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner);
    }
    if (bottomRounded) {
        cornerRoundingFlags |= (kCALayerMinXMaxYCorner|kCALayerMaxXMaxYCorner);
    }
    cell.layer.maskedCorners = cornerRoundingFlags;
}

@end
