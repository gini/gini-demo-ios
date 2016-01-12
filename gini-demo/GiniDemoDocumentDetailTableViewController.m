//
//  GSDocumentTableViewController.m
//  GiniScan
//
//  Created by Peter Pult on 08.07.15.
//  Copyright (c) 2015 Gini GmbH. All rights reserved.
//

#import "GiniDemoDocumentDetailTableViewController.h"
#import <Gini-iOS-SDK/GiniSDK.h>

@interface GiniDemoDocumentDetailTableViewController () {
    NSArray *sortedKeys;
}
@end

@implementation GiniDemoDocumentDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_extractions) {
        sortedKeys = [[_extractions allKeys] sortedArrayUsingSelector: @selector(compare:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK: Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _extractions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"documentDetailCell" forIndexPath:indexPath];
    NSString *key = sortedKeys[indexPath.row];
    cell.textLabel.text = _extractions[key];
    cell.detailTextLabel.text = key;
    return cell;
}

@end
