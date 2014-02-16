//
//  iChoseListaTVC.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 04/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface iChoseListaTVC : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, CLLocationManagerDelegate, UISearchBarDelegate>
{
    UIBarButtonItem         *btMenu;
    UISearchBar             *mySearchBar;
}

@property (strong, nonatomic)   IBOutlet    UITableView         *tableView;
@property (nonatomic,retain)                CLLocationManager   *locationManager;
@property (nonatomic)           IBOutlet    UIBarButtonItem     *btMenu;
@property (strong, nonatomic)   IBOutlet    UISearchBar         *mySearchBar;

- (IBAction)btSearch:(id)sender;


@end
