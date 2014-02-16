//
//  iChoseTermoViewController.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 17/10/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface iChoseTermoViewController : UIViewController
<CLLocationManagerDelegate>
{
    UIBarButtonItem         *btVoltar;
    UIImageView             *ivFundoJanela;
}

@property (strong, nonatomic) IBOutlet  UIBarButtonItem     *btVoltar;
@property (strong, nonatomic) IBOutlet  UIImageView         *ivFundoJanela;

@property (nonatomic, retain)           CLLocationManager   *locationManager;

- (IBAction)btVoltar:(id)sender;

@end
