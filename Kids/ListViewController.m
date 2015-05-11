//
//  ListViewController.m
//  Kids
//
//  Created by Todd Ditchendorf on 5/10/15.
//  Copyright (c) 2015 Todd Ditchendorf. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (void)dealloc {
    self.scenes = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

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


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [_scenes count];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])] autorelease];
    }
    
    id scene = _scenes[path.row];
    NSAssert(scene, nil);
    
    NSString *name = scene[@"name"];
    NSAssert([name length], nil);
    
    cell.textLabel.text = name;
    return cell;
}

@end
