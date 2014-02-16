//
//  iChoseMenuTVC.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 04/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iChoseMenuTVC : UITableViewController
<UINavigationControllerDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet  UITableView     *tableView;
@property (nonatomic, strong)           NSArray         *menuItens;
@property (strong, nonatomic) IBOutlet  UITableViewCell *cellsMenu;

@end
