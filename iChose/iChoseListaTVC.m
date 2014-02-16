//
//  iChoseListaTVC.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 04/02/14.
//  Copyright (c) 2014 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "iChoseListaTVC.h"
#import "SWRevealViewController.h"


CLLocationDegrees   latitude;
CLLocationDegrees   longitude;

@interface iChoseListaTVC ()

@end

BOOL _sbControl;

@implementation iChoseListaTVC
@synthesize     tableView,
                btMenu,
                locationManager,
                mySearchBar;



/*
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Navigation Bar Personalizado.
    [self customizeAppearance];
    
    // Set the side bar button action. When it's tapped, itáll show uo the sidebar.
    btMenu.target = self.revealViewController;
    btMenu.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // SearchBar
    mySearchBar.delegate = self;
    mySearchBar.hidden = TRUE;
    _sbControl = TRUE;
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Baladas";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


#pragma mark GPS
#pragma mark CLLocationManagerDelegate
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Inicia o LocationManager para monitorar as coordenadas GPS;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100.00;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Começa a monitorar o GPS;
    [self.locationManager startUpdatingLocation];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Desliga o monitoramento do GPS;
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    CLLocationAccuracy accurary = [lastLocation horizontalAccuracy];
    
    if (accurary <= 100) {
        
        latitude = locationManager.location.coordinate.latitude;
        longitude = locationManager.location.coordinate.longitude;
        
        [manager stopUpdatingLocation];
    }
    
}


#pragma mark SearchBar
- (IBAction)btSearch:(id)sender
{
    if (_sbControl) {
        self.tableView.tableHeaderView = mySearchBar;
        mySearchBar.hidden = FALSE;
        _sbControl = FALSE;
        self.tableView.scrollEnabled = FALSE;
        [mySearchBar becomeFirstResponder];
    }
    else
    {
        self.tableView.tableHeaderView = nil;
        [mySearchBar resignFirstResponder ];
        mySearchBar.hidden = TRUE;
        _sbControl = TRUE;
        mySearchBar.text = @"";
        self.tableView.scrollEnabled = TRUE;
    }
    
    [self.tableView scrollRectToVisible:[[self.tableView tableHeaderView] bounds] animated:NO];
}


#pragma mark Metodos do Navigation Controller
-(void)customizeAppearance
{
    UIImageView *leatherBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iChoseFull.png"]];
    
    self.navigationItem.titleView = leatherBackground;
}

@end
