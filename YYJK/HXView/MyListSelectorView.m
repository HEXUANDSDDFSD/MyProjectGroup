//
//  MyListSelectorView.m
//  tysx
//
//  Created by zwc on 14-6-25.
//  Copyright (c) 2014年 huangjia. All rights reserved.
//

#import "MyListSelectorView.h"
#import "MyDragListView.h"

@interface MyListSelectorView()<UITableViewDataSource, UITableViewDelegate, MyDragListViewDelegate>

@end

@implementation MyListSelectorView {
    MyDragListView *dragListView;
    UITableView *tableView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (dragListView == nil) {
        dragListView = [[MyDragListView alloc] initWithFrame:CGRectMake(0, 0, 100, self.bounds.size.height)];
        dragListView.backgroundColor = [UIColor whiteColor];
        dragListView.selectedColor = [UIColor blackColor];
        dragListView.titleColor = [UIColor darkGrayColor];
        dragListView.delegate = self;
        dragListView.titles = self.sectionTitles;
        [self addSubview:dragListView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(dragListView.frame.origin.x + dragListView.bounds.size.width, 0, self.bounds.size.width - 110, self.bounds.size.height) style:UITableViewStylePlain];
        [self addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(rowNumberOfSection:)]) {
    number = [self.dataSource rowNumberOfSection:dragListView.currentIndex];
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([self.dataSource respondsToSelector:@selector(rowTitleWithRow:section:)]) {
        cell.textLabel.text = [self.dataSource rowTitleWithRow:(int)indexPath.row section:dragListView.currentIndex];
        
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentRow = (int)indexPath.row;
    self.currentSection = dragListView.currentIndex;
    if ([self.delegate respondsToSelector:@selector(listSelectorViewDidSelect:)]) {
        [self.delegate listSelectorViewDidSelect:self];
    }
}

- (void)dragListViewDidSeleted:(MyDragListView *)view {
    [tableView reloadData];
}


@end
