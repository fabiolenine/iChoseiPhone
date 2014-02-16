//
//  iChosemainViewController.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 29/08/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "iChosemainViewController.h"
#import "iChosemainAppDelegate.h"
#import "Usuario.h"
#import "ClienteMovel.h"
#import "validadorES.h"
#import "crudCD.h"

#define esqueceuURL         [NSURL URLWithString:@"http://ec2-54-245-29-152.us-west-2.compute.amazonaws.com:8080/api/v01/usuariomobile/esqueceu"]
#define recuperarUsuario    @"http://ec2-54-245-29-152.us-west-2.compute.amazonaws.com:8080/api/v01/usuariomobile/recuperarusuario/%@"

CLLocationDegrees   latitude;
CLLocationDegrees   longitude;

int                 _lado;
int                 _currentIndex;
CGFloat             _currentPanXAmount;
CGFloat             _panThreshold;


@interface iChosemainViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation iChosemainViewController
@synthesize tfEmail             ,
            tfSenha             ,
            scrollView          ,
            activeField         ,
            btEntrar            ,
            btEsqueceuSenha     ,
            btCadastrar         ,
            managedObjectContext,
            contentView         ,
            iviChose            ,
            ivAvatarBorda       ,
            ivAvatarConteudo    ,
            ivFundoAmparo       ,
            lEmail              ,
            lSenha              ,
            locationManager     ,
            emailMA = _emailMA  ,
            senhaMA = _senhaMA  ,
            fotoMA = _fotoMA    ;


- (NSMutableArray *)emailMA
{
    if (!_emailMA)
        _emailMA = [[NSMutableArray alloc] init];
    return _emailMA;
}

- (NSMutableArray *)fotoMA
{
    if (!_fotoMA)
        _fotoMA = [[NSMutableArray alloc] init];
    return _fotoMA;
}

- (NSMutableArray *)senhaMA
{
    if (!_senhaMA)
        _senhaMA = [[NSMutableArray alloc] init];
    return _senhaMA;
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    float intSalto = 10.0;
    if ([[UIScreen mainScreen ] bounds].size.height < 568.0f)
    {
        intSalto = 100.0;
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height+intSalto, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) )
    {
        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

// Additional methods for tracking the active text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [self registerForKeyboardNotifications];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    
    if ([validaEmail(tfEmail.text) isEqual:@"No"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Email incomum!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        tfSenha.enabled         = false;
        btEsqueceuSenha.enabled = false;
    }
    else
    {
        tfSenha.enabled         = true;
        btEsqueceuSenha.enabled = true;
    }
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfEmail)
    {
        if ([validaEmail(tfEmail.text) isEqual:@"No"])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:    @"Informação inconsistente."
                                  message:          @"Email incomum!"
                                  delegate:         nil //or self
                                  cancelButtonTitle:@"Digitar Novamente"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            tfSenha.enabled         = false;
            btEsqueceuSenha.enabled = false;
        }
        else
        {
            tfSenha.enabled         = true;
            btEsqueceuSenha.enabled = true;
            
            [tfSenha becomeFirstResponder];
            return YES;
        }
    }
    else if (textField == tfSenha && tfSenha.text.length > 3)
    {
        // Chamar a validação dos dados.
        NSLog(@"Validar os dados %@, %@",_senhaMA[_currentIndex],[self computeSHA256DigestForString:tfSenha.text]);
        if ([_senhaMA[_currentIndex] isEqualToString:[self computeSHA256DigestForString:tfSenha.text]] && [_emailMA[_currentIndex] isEqualToString:tfEmail.text]) {
            [self performSegueWithIdentifier:@"sValidado" sender:self];
        }
        else
        {
            [self getrecuperarUsuario:tfEmail.text identificacao:[self computeSHA256DigestForString:tfSenha.text]];
        }
        
        [tfSenha resignFirstResponder];
        btEntrar.enabled        = true;
        return YES;
    }
    return NO;
}
     
-(IBAction)esqueceuSenha:(id)sender
{
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Enviar e-mail para renovar a senha?"
                                                        delegate:self
                                               cancelButtonTitle:@"Não"
                                          destructiveButtonTitle:@"Sim"
                                               otherButtonTitles: nil];
    aSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [aSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self postEsqueceuSenha ];
            break;
        default:
            break;
    }
}

-(void) postEsqueceuSenha {
    
    [self.spinner startAnimating];

    NSString *lon = [[NSString alloc] initWithFormat:@"%f", longitude];
    NSString *lat = [[NSString alloc] initWithFormat:@"%f", latitude];
    
    NSDictionary *esqueceuD = @{
                                @"email":   tfEmail.text,
                                @"loc":     @{  @"lon": lon,
                                                @"lat": lat}
                                };
    
    NSError* errorJSON;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:esqueceuD
                                                       options:kNilOptions
                                                         error:&errorJSON];
    
    if (errorJSON) {
        NSLog(@"Erro no Parser do JSON: %@", errorJSON);
    }
    else
    {
        NSLog(@"JSon: %@",jsonData);
        NSLog(@"Longitude: %f", longitude);
        NSLog(@"Latitude: %f", latitude);
        
        NSURLSessionConfiguration *esqueceuConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: esqueceuConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
        NSURL * url = esqueceuURL;
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        
        [urlRequest setHTTPBody:jsonData];
    
        esqueceuConfigObject.allowsCellularAccess = YES;
        [esqueceuConfigObject setHTTPAdditionalHeaders:@{@"Accept": @"application/json",
                                                         @"Accept-Language": @"br"}];
    
        esqueceuConfigObject.timeoutIntervalForRequest      = 30.0;
        esqueceuConfigObject.timeoutIntervalForResource     = 60.0;
        esqueceuConfigObject.HTTPMaximumConnectionsPerHost  = 1;
    
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                           }
                                                           
                                                       }];
        [dataTask resume];
    }
    [self.spinner stopAnimating];
}


-(IBAction)entrar:(id)sender{
    if (tfSenha.text.length > 3)
    {
        // Chamar a validação dos dados.
        NSLog(@"Validar os dados %@, %@",_senhaMA[_currentIndex],[self computeSHA256DigestForString:tfSenha.text]);
        
        if ([_senhaMA[_currentIndex] isEqualToString:[self computeSHA256DigestForString:tfSenha.text]] && [_emailMA[_currentIndex] isEqualToString:tfEmail.text])
        {
            [self performSegueWithIdentifier:@"sValidado" sender:self];
        }
        else
        {
            [self getrecuperarUsuario:tfEmail.text identificacao:[self computeSHA256DigestForString:tfSenha.text]];
        }
        
        NSLog(@"disparar aqui a verificação de senha e usuário na memoria ou cloud, com as seguintes coordenadas: %f e %f", latitude, longitude);
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.spinner stopAnimating];
    
	// Do any additional setup after loading the view.

    if ([[UIScreen mainScreen ] bounds].size.height >= 568.0f)
    {
        NSLog(@"Hey, this is an iPhone 5! Well, maybe. . .What year is it?");
        lEmail.frame            = CGRectMake(33, 240, 47, 27);
        lSenha.frame            = CGRectMake(33, 303, 47, 27);
        iviChose.frame          = CGRectMake(40, 50, 240, 68);
        ivAvatarConteudo.frame  = CGRectMake(111, 139, 98, 100);
        ivAvatarBorda.frame     = CGRectMake(110, 139, 100, 100);
        ivFundoAmparo.frame     = CGRectMake(13, 188, 294, 341);
        tfEmail.frame           = CGRectMake(26, 262, 268, 35);
        tfSenha.frame           = CGRectMake(26, 325, 268, 35);
        btEsqueceuSenha.frame   = CGRectMake(187, 375, 107, 25);
        btEntrar.frame          = CGRectMake(26, 416, 268, 40);
        btCadastrar.frame       = CGRectMake(26, 472, 268, 40);
    }
    else
    {
        NSLog(@"Bummer, this is not an iPhone 5. . .");
        lEmail.frame            = CGRectMake(33, 181, 47, 27);
        lSenha.frame            = CGRectMake(33, 246, 47, 27);
        iviChose.frame          = CGRectMake(40, 18, 240, 68);
        ivAvatarConteudo.frame  = CGRectMake(116, 100, 88, 90);
        ivAvatarBorda.frame     = CGRectMake(115, 100, 90, 90);
        ivFundoAmparo.frame     = CGRectMake(13, 135, 294, 315);
        tfEmail.frame           = CGRectMake(26, 203, 268, 35);
        tfSenha.frame           = CGRectMake(26, 266, 268, 35);
        btEsqueceuSenha.frame   = CGRectMake(187, 309, 107, 25);
        btEntrar.frame          = CGRectMake(26, 342, 268, 40);
        btCadastrar.frame       = CGRectMake(26, 396, 268, 40);
    }

    scrollView.contentSize = self.contentView.frame.size;
    
    btEntrar.enabled            = false;
    
    [self carregarArrays];
    [self visaoArrays:_emailMA.count-1];
    _panThreshold = 5.0;
    
    if (self.tfEmail.text.length != 0){
        tfSenha.enabled         = true;
        btEsqueceuSenha.enabled = true;
    } else {
        tfSenha.enabled         = false;
        btEsqueceuSenha.enabled = false;
    }
}

-(void)carregarArrays
{
    // CoreData.
    
    iChosemainAppDelegate *appDelegate = (iChosemainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError * error;
    
    if (context == nil)
    {
        NSLog(@"Lascou aqui: %@, %@", error, [error userInfo]);
    }
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Usuario"
                                   inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for ( Usuario *info in fetchedObjects )
    {
        NSLog ( @ "EMAIL: %@" , info.deUsuario);
        NSLog ( @ "Senha: %@" , info.deSenhaUsuario);
        NSLog ( @ "ObjectID: %@" , info.idObject);
        ClienteMovel * details = info.rscliente;
        NSLog ( @ "Nome: %@" , details.deNome);
        //NSLog ( @ "Latitude: %@", details.latitude);
        //NSLog ( @ "Longitude: %@", details.longitude);
        
        [self.emailMA addObject:info.deUsuario];
        [self.senhaMA addObject:info.deSenhaUsuario];
        
        if (details.bdFoto)
        {
            [self.fotoMA  addObject:[UIImage imageWithData:details.bdFoto]];
        }
        
    }
    
    if(fetchedObjects != nil)
    {
        NSLog(@"fetchedObjects vazio");
    }

}

-(void)visaoArrays:(int)posicao
{
    NSInteger seq = posicao;
    
    NSLog(@"Quantidade de emails: %d",_emailMA.count);
    if (_emailMA.count != 0)
    {
        NSLog(@ "Valor = %@",_fotoMA);
        NSLog(@ "Valor = %@",_fotoMA[0]);
        NSLog(@"%lu",(unsigned long)seq);
        NSLog(@ "Valor = %lu",(unsigned long)_fotoMA.count);
     
        tfEmail.text = _emailMA[seq];
        _currentIndex = seq;
    
        if (_fotoMA[seq] != nil)
        {
        
            ivAvatarConteudo.image = _fotoMA[seq];
        
            ivAvatarConteudo.layer.cornerRadius    = roundf(ivAvatarConteudo.frame.size.width/2.0);
            ivAvatarConteudo.transform = CGAffineTransformMakeRotation(M_PI_2);
            ivAvatarConteudo.layer.masksToBounds   = YES;
            
        }
    }

 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear: (BOOL) animated
{
    tfEmail.delegate            = self;
    tfSenha.delegate            = self;
}

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

#pragma mark GPS
#pragma mark CLLocationManagerDelegate
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


#pragma mark Gestures
#pragma mark Tap Gesture
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [tfEmail resignFirstResponder];
    [tfSenha resignFirstResponder];
    if (tfSenha.text.length > 3) {
        btEntrar.enabled = TRUE;
    }
}


#pragma mark Pan Gesture
- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    //NSUInteger total = fotoA.count;
    
    CGPoint translation = [sender translationInView:self.view];
    
    _currentPanXAmount += translation.x;
    
    NSLog(@"%@ translation", NSStringFromCGPoint(translation));

    if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (_currentPanXAmount < _panThreshold)
        {
            NSLog(@"01");
            _lado = 1; // para direita;
            
        }
        else if(_currentPanXAmount > _panThreshold)
        {
            NSLog(@"02");
            _lado = 2; // para esquerda;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if(_lado == 1 )
        {
            _currentIndex=(_currentIndex<=0)?_emailMA.count-1:_currentIndex-1;
             NSLog(@"1");
            [self visaoArrays:_currentIndex];
        }
        else if (_lado == 2)
        {
            _currentIndex=(_currentIndex>=_emailMA.count-1)?0:_currentIndex+1;
             NSLog(@"2");
            [self visaoArrays:_currentIndex];
        }

        NSLog(@"valor do lado: %d",_currentIndex);
        NSLog(@"Fim");
        
        _currentPanXAmount = 0.0;
        
    }
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"sValidado"]) {
                NSLog(@"Adicionar aqui a passage dos dados do usuário logado para a proxima tela.");
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"sValidado"])
    {
        return NO;
    }
    return YES;
}

#pragma mark Criptografia
-(NSString*)computeSHA256DigestForString:(NSString*)input
{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, data.length, digest);
    
    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

#pragma mark Cloud - Gets and Posts.
- (void)getrecuperarUsuario: (NSString*) emailGET identificacao: (NSString*) senhaGET
{
    
    [self.spinner startAnimating];
    
    NSURLSessionConfiguration *configObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: configObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSString *params = [NSString stringWithFormat:@"?email=%@&senha=%@",emailGET, senhaGET ];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:recuperarUsuario,params]];

    NSLog(@"URL: %@", url);
    
    configObject.timeoutIntervalForRequest      = 30.0;
    configObject.timeoutIntervalForResource     = 60.0;
    configObject.HTTPMaximumConnectionsPerHost  = 1;
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithURL:url
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                          
                                          //NSLog(@"Response:%@ %@\n", response, error);
                                          
                                          if(error == nil && httpResp.statusCode == 200)
                                          {
                                              NSError *errorJson;
                                              NSDictionary *jsonRecuperarUsuario = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                                              
                                              if (error == nil) {
                                                  
                                                  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                  [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                                  NSDate *dateFromString = [[NSDate alloc] init];
                                                  dateFromString = [dateFormatter dateFromString:[jsonRecuperarUsuario objectForKey:@"datanascimento"]];
                                                  
                                                  NSData *data = [[NSData alloc]initWithBase64EncodedString:[NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"foto"]] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                                                  
                                                  NSString *retorno = salvarCadastroUsuarioDB(senhaGET,
                                                                                              emailGET,
                                                                                              [NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"_id"]],
                                                                                              [NSString stringWithFormat:@"%@",[[jsonRecuperarUsuario objectForKey:@"nomecompleto"] objectForKey:@"nomeprincipal"]],
                                                                                              [NSString stringWithFormat:@"%@",[[jsonRecuperarUsuario objectForKey:@"nomecompleto"] objectForKey:@"sobrenome"]],
                                                                                              [NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"genero"]],
                                                                                              dateFromString,
                                                                                              [NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"celular"]],
                                                                                              emailGET,
                                                                                              [NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"cep"]],
                                                                                              [NSString stringWithFormat:@"%@",[jsonRecuperarUsuario objectForKey:@"cpf"]],
                                                                                              data);
                                                  
                                                  if ([retorno isEqualToString:@"Yes"]) {
                                                      [self performSegueWithIdentifier:@"sValidado" sender:self];
                                                  }
                                                  else
                                                  {
                                                      UIAlertView *alert = [[UIAlertView alloc]
                                                                            initWithTitle:    @"Não foi possível salvar."
                                                                            message:          @"Verifique se há espaço disponível"
                                                                            delegate:         nil //or self
                                                                            cancelButtonTitle:@"Tente Novamente"
                                                                            otherButtonTitles:nil];
                                                      
                                                      [alert show];
                                                  }
                                                  
                                              }
                                          }
                                          else
                                          {
                                              UIAlertView *alert = [[UIAlertView alloc]
                                                                    initWithTitle:    @"Informação inconsistente."
                                                                    message:          @"Senha invalida!"
                                                                    delegate:         nil //or self
                                                                    cancelButtonTitle:@"Digitar Novamente"
                                                                    otherButtonTitles:nil];
                                              
                                              [alert show];
                                              tfSenha.text = @"";
                                          }
                                      }];
    [dataTask resume];
    
    [self.spinner stopAnimating];
    
}

/*
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
*/

@end
