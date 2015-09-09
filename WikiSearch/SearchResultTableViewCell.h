//
//  SearchResultTableViewCell.h
//  WikiSearch
//
//  Created by Trivedi, Astha on 07/09/15.
//  Copyright (c) 2015 Astha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewModel.h"

@interface SearchResultTableViewCell : UITableViewCell

- (void)setupCellData:(SearchResultViewModel *)viewModel;

@end
