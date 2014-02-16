//
//  iChosemainViewController.h
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 29/08/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

@interface iChosemainViewController : UIViewController 
<UIActionSheetDelegate, UIScrollViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLSessionDelegate, NSFetchedResultsControllerDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate>
{
    UIScrollView            *scrollView;
    UIView                  *contentView;
    UITextField             *tfEmail;
    UITextField             *tfSenha;
    UITextField             *activeField;
    UIButton                *btEntrar;
    UIButton                *btEsqueceuSenha;
    UIButton                *btCadastrar;
    UILabel                 *lEmail;
    UILabel                 *lSenha;
    
    // Para controle de posição.
    UIImageView             *iviChose;
    UIImageView             *ivAvatarConteudo;
    UIImageView             *ivAvatarBorda;
    UIImageView             *ivFundoAmparo;
    
    //Variaveis.
    NSMutableArray          *emailMA;
    NSMutableArray          *senhaMA;
    NSMutableArray          *fotoMA;
}

@property (nonatomic,retain)    IBOutlet UITextField                *tfEmail;
@property (nonatomic,retain)    IBOutlet UITextField                *tfSenha;
@property (nonatomic,retain)    IBOutlet UITextField                *activeField;
@property (nonatomic,strong)    IBOutlet UIScrollView               *scrollView;
@property (nonatomic)           IBOutlet UIButton                   *btEntrar;
@property (nonatomic)           IBOutlet UIButton                   *btEsqueceuSenha;
@property (nonatomic)           IBOutlet UIButton                   *btCadastrar;
@property (nonatomic, strong)   NSManagedObjectContext*             managedObjectContext;
@property (strong, nonatomic)   IBOutlet UIView                     *contentView;
@property (strong, nonatomic)   IBOutlet UIActivityIndicatorView    *spinner;
@property (nonatomic, retain)   CLLocationManager                   *locationManager;

// Para controle de posição.
@property (strong, nonatomic)   IBOutlet UIImageView                *iviChose;
@property (strong, nonatomic)   IBOutlet UIImageView                *ivAvatarConteudo;
@property (strong, nonatomic)   IBOutlet UIImageView                *ivFundoAmparo;
@property (strong, nonatomic)   IBOutlet UILabel                    *lEmail;
@property (strong, nonatomic)   IBOutlet UILabel                    *lSenha;
@property (strong, nonatomic)   IBOutlet UIImageView                *ivAvatarBorda;

// Array para manipulação das contas de login dos usuários.
@property (strong, nonatomic)   NSMutableArray                      *emailMA;
@property (strong, nonatomic)   NSMutableArray                      *senhaMA;
@property (strong, nonatomic)   NSMutableArray                      *fotoMA;

-(IBAction)esqueceuSenha:(id)sender;
-(IBAction)entrar:(id)sender;

@end
