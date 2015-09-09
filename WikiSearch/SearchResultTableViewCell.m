//
//  SearchResultTableViewCell.m
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@interface SearchResultTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *searchResultTitle;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation SearchResultTableViewCell


- (void)setupCellData:(SearchResultViewModel *)viewModel {
    self.searchResultTitle.text = viewModel.title;
    self.date.text = viewModel.timestamp;
}

@end
