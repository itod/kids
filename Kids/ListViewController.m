//
//  ListViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "ListViewController.h"
#import "CanvasViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)dealloc {
    self.scenes = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Scenes", nil);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Scenes" ofType:@"plist"];
    id plist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSAssert([plist count], nil);
    
    NSArray *scenes = plist[@"scenes"];
    NSAssert([scenes count], nil);
    
    self.scenes = scenes;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [_scenes count];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    id scene = _scenes[path.row];
    NSAssert(scene, nil);
    
    NSString *name = scene[@"name"];
    NSAssert([name length], nil);
    
    cell.textLabel.text = name;
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    NSAssert(path.row >= 0 && path.row < [_scenes count], nil);
    
    id scene = _scenes[path.row];
    
    CanvasViewController *cvc = [[[CanvasViewController alloc] initWithScene:scene] autorelease];
    [self.navigationController pushViewController:cvc animated:YES];
    
    return path;
}

@end
