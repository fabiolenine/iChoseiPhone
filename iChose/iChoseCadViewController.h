//
//  iChoseCadViewController.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 09/10/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface iChoseCadViewController : UIViewController
<UIActionSheetDelegate, UIScrollViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLSessionDelegate, CLLocationManagerDelegate>
{
    UIScrollView            *scrollView;
    UIView                  *contentView;
    UIBarButtonItem         *btVoltar;
    UIButton                *btSalvar;
    UISwitch                *swLi;
    NSDate                  *birthDate;
    UIActionSheet           *dateSheet;
    UITextField             *activeField;
    
    // Campos:
    UITextField             *tfNome;
    UITextField             *tfSobreNome;
    UISegmentedControl      *pscGenero;
    UITextField             *tfCPF;
    UITextField             *tfDataNascimento;
    UITextField             *tfCelular;
    UITextField             *tfCEP;
    UITextField             *tfEmail;
    UITextField             *tfSenha;
    UITextField             *tfConfirmarSenha;
    
    //Variaveis.
    NSString                *objectIDS;
    // Para Acessar a galeria ou tirar fotos.
    UIImagePickerController *imagePicker;
}

@property (nonatomic,strong)    IBOutlet UIScrollView           *scrollView;
@property (nonatomic,retain)    IBOutlet UITextField            *activeField;
@property (nonatomic,strong)    NSManagedObjectContext          *managedObjectContext;
@property (strong,nonatomic)    IBOutlet UIView                 *contentView;
@property (nonatomic)           IBOutlet UIBarButtonItem        *btVoltar;
@property (strong, nonatomic)   IBOutlet UIButton               *btSalvar;
@property (nonatomic,retain)    NSDate                          *birthDate;
@property (strong, nonatomic)   NSString                        *objectIDS;

// Para Acessar a galeria ou tirar fotos.
@property (strong, nonatomic)   IBOutlet UIImageView            *imageView;
@property (strong, nonatomic)   IBOutlet UIButton               *btEditar;

// Campos:
@property (strong, nonatomic)   IBOutlet UITextField            *tfNome;
@property (strong, nonatomic)   IBOutlet UITextField            *tfSobreNome;
@property (strong, nonatomic)   IBOutlet UISegmentedControl     *pscGenero;
@property (strong, nonatomic)   IBOutlet UITextField            *tfCPF;
@property (retain, nonatomic)   IBOutlet UITextField            *tfDataNascimento;
@property (strong, nonatomic)   IBOutlet UITextField            *tfCelular;
@property (strong, nonatomic)   IBOutlet UITextField            *tfCEP;
@property (strong, nonatomic)   IBOutlet UITextField            *tfEmail;
@property (strong, nonatomic)   IBOutlet UITextField            *tfSenha;
@property (strong, nonatomic)   IBOutlet UITextField            *tfConfirmarSenha;
@property (strong, nonatomic)   IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain)   CLLocationManager               *locationManager;


- (IBAction)btVoltar:(id)sender;
- (IBAction)btEditar:(id)sender;
- (IBAction)swLi:(id)sender;
- (IBAction)btSalvar:(id)sender;

-(void)setBirth;

@end
