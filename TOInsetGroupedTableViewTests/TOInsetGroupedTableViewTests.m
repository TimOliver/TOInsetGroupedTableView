//
//  TOInsetGroupedTableViewTests.m
//  TOInsetGroupedTableViewTests
//
//  Created by Tim Oliver on 2020/04/11.
//  Copyright © 2020 Tim Oliver. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TOInsetGroupedTableView.h"

@interface TOInsetGroupedTableViewTests : XCTestCase

@property (nonatomic, strong) TOInsetGroupedTableView *tableView;

@end

@implementation TOInsetGroupedTableViewTests

- (void)setUp
{
    UIView *hostView = [[UIView alloc] initWithFrame:(CGRect){0,0,320,480}];
    self.tableView = [[TOInsetGroupedTableView alloc] initWithFrame:hostView.bounds];
    [hostView addSubview:self.tableView];
}

- (void)tearDown
{
    
}

- (void)testTableViewCreation
{
    // Test that the class builds and can be instantiated without issue
    XCTAssertNotNil(self.tableView);
    
    // Test the style has been set correctly
    if (@available(iOS 13.0, *)) {
        XCTAssertTrue(self.tableView.style == UITableViewStyleInsetGrouped);
    }
    else {
        XCTAssertTrue(self.tableView.style == UITableViewStyleGrouped);
    }
}


@end
