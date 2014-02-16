//
//  iChoseCadViewController.m
//  iChose
//
//  Created by Fabio Lenine Vilela da Silva on 09/10/13.
//  Copyright (c) 2013 Fabio Lenine Vilela da Silva. All rights reserved.
//

#import "iChoseCadViewController.h"
#import "iChosemainAppDelegate.h"
#import "Usuario.h"
#import "ClienteMovel.h"
#import "validadorES.h"

#define cadastrarURL [NSURL URLWithString:@"http://ec2-54-245-29-152.us-west-2.compute.amazonaws.com:8080/api/v01/usuariomobile/cadastrar"]

CLLocationDegrees   latitude;
CLLocationDegrees   longitude;

int     _foto = 0;

@interface iChoseCadViewController ()

@end


@implementation iChoseCadViewController
@synthesize     scrollView,
                contentView,
                btVoltar,
                imageView,
                btEditar,
                btSalvar,
                managedObjectContext,
                tfCelular,
                tfCEP,
                tfConfirmarSenha,
                tfCPF,
                tfDataNascimento,
                tfEmail,
                tfNome,
                tfSenha,
                tfSobreNome,
                pscGenero,
                birthDate,
                activeField,
                objectIDS = _objectIDS,
                locationManager;


- (NSString *)objectIDS
{
    if (!_objectIDS)
        _objectIDS = [[NSString alloc] init];
    return _objectIDS;
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
    
    //Customização da ScrollView.
    
    if ([[UIScreen mainScreen ] bounds].size.height >= 568.0f)
    {
        [scrollView setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height)];
    }
    else
    {
        [scrollView setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height+100.0)];
    }
    
	// Do any additional setup after loading the view.
    
    //self.layerPosition = self.topLayer.frame.origin.x;
    
    //Navigation Bar Personalizado.
    [self customizeAppearance];
    
    //Área de habilitação do botão da camera.
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    BOOL cameraDisponivel = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (! cameraDisponivel) {
        btEditar.enabled = false;
    }

    //Desabilitar botão
    btSalvar.enabled = false;

}

-(void) viewWillAppear: (BOOL) animated
{
    tfCelular.delegate          = self;
    tfCEP.delegate              = self;
    tfConfirmarSenha.delegate   = self;
    tfEmail.delegate            = self;
    tfNome.delegate             = self;
    tfSenha.delegate            = self;
    tfSobreNome.delegate        = self;
    tfDataNascimento.delegate   = self;
    tfCPF.delegate              = self;
    activeField.delegate        = self;
}


- (IBAction)btVoltar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btEditar:(id)sender
{
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"Origem da Foto?"
                                                        delegate:self
                                               cancelButtonTitle:@"Galeria"
                                          destructiveButtonTitle:@"Câmera"
                                               otherButtonTitles: nil];
    aSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [aSheet showInView:self.view];
}

- (IBAction)swLi:(id)sender
{
    if ([sender isOn])
    {
        btSalvar.enabled = YES;
    }
    else
    {
        btSalvar.enabled = false;
    }
}

- (IBAction)btSalvar:(id)sender
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dataAtual = [NSDate date];
    NSDateComponents *limiteIdade = [[NSDateComponents alloc] init];
    [limiteIdade setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:limiteIdade toDate:dataAtual options:0];
    
    NSDateFormatter *dateFormatterBR = [[NSDateFormatter alloc] init];
    [dateFormatterBR setDateFormat:@"dd/MM/yyyy"];
    NSDate *dataTF  = [dateFormatterBR dateFromString:tfDataNascimento.text];
    

    if ([validaCPF(tfCPF.text) isEqual:@"No"] || tfCPF.text.length < 14)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"O CPF não é válido!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [tfCPF becomeFirstResponder];
    }
    else if (![tfSenha.text isEqual:tfConfirmarSenha.text])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"As senhas digitadas não são iguais!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        tfSenha.text            = nil;
        tfConfirmarSenha.text   = nil;
        
        [tfSenha becomeFirstResponder];
    }
    else if (tfSenha.text.length < 4 || tfConfirmarSenha.text.length < 4)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Mínimo de 4 digitos para senha!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        tfSenha.text            = nil;
        tfConfirmarSenha.text   = nil;
        
        [tfSenha becomeFirstResponder];
    }
    else if ([validaEmail(tfEmail.text) isEqual:@"No"])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Email incomum!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        tfEmail.text = nil;
        
        [tfEmail becomeFirstResponder];
    }
    else if (tfNome.text.length < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Nome incomum!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [tfNome becomeFirstResponder];
    }
    else if (tfSobreNome.text.length < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Sobrenome incomum!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [tfSobreNome becomeFirstResponder];
    }
    else if (tfCelular.text.length < 12)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Número do celular incompleto!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [tfCelular becomeFirstResponder];
    }
    else if (tfCEP.text.length < 10)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"CEP incompleto!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [tfCEP becomeFirstResponder];
    }
    else if ([maxDate compare:dataTF] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Data informada é inferior a 18 anos!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Informe novamente"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    else
    {
        // Início da inserção no serviço web;
        
        //NSString *imageString = [self encodeToBase64String:(self.imageView.image)];
        
        NSDictionary *cadastrarD = @{   @"nomecompleto":   @{   @"nomeprincipal":  tfNome.text,
                                                                @"sobrenome":      tfSobreNome.text
                                },
             @"genero":         [NSNumber numberWithInt:([self.pscGenero selectedSegmentIndex])],
             @"cpf":            tfCPF.text,
             @"datanascimento": tfDataNascimento.text,
             @"celular":        tfCelular.text,
             @"cep":            tfCEP.text,
             @"email":          tfEmail.text,
             @"senha":          [self computeSHA256DigestForString:tfSenha.text],
             @"foto":           [self encodeToBase64String:imageView.image]
                                };
        
        NSError* errorJSON;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:cadastrarD
                                                           options:kNilOptions
                                                             error:&errorJSON];
        
        if (errorJSON) {
            NSLog(@"Erro no Parser do JSON: %@", errorJSON);
        }
        else
        {
            [self postCadastrar:jsonData];
        }
        
        // Comentar essa faixa e todos os NSLog quando entrar em produção;
        NSString *json = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
        NSLog(@"Json construido: %@", json);

    }
}


- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

/*
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}
*/

- (void)salvarCadastroDB
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    // Salvar e comitar.
    
    iChosemainAppDelegate *appDelegate = (iChosemainAppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError * error;
    
    if (context == nil)
    {
        NSLog(@"Lascou aqui: %@, %@", error, [error userInfo]);
    }
    
    Usuario *usuario =          [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Usuario"
                                 inManagedObjectContext:context];
    
    usuario.deSenhaUsuario  = [self computeSHA256DigestForString:tfSenha.text];
    usuario.deUsuario       = tfEmail.text;
    usuario.dtTimeStamp     = [NSDate date];
    usuario.idObject        = objectIDS;
    
    ClienteMovel *clienteMovel = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"ClienteMovel"
                                  inManagedObjectContext:context];
    
    clienteMovel.deNome         = tfNome.text;
    clienteMovel.dtTimeStamp    = [NSDate date];
    clienteMovel.deSobreNome    = tfSobreNome.text;
    clienteMovel.flGenero       = [NSNumber numberWithInt:([self.pscGenero selectedSegmentIndex])];
    clienteMovel.dtNascimento   = [dateFormatter dateFromString:tfDataNascimento.text];
    clienteMovel.deCelular      = tfCelular.text;
    clienteMovel.deEmail        = tfEmail.text;
    clienteMovel.deCEP          = tfCEP.text;
    clienteMovel.deCPF          = tfCPF.text;
    clienteMovel.bdFoto         = [NSData dataWithData:UIImagePNGRepresentation(self.imageView.image)];
    //clienteMovel.latitude       = [NSNumber numberWithDouble:latitude];
    //clienteMovel.longitude      = [NSNumber numberWithDouble:longitude];
    clienteMovel.rsusuario = usuario;
    usuario.rscliente = clienteMovel;
    
    if (![context save:&error])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    error.localizedDescription
                              message:          error.localizedRecoverySuggestion
                              delegate:         nil //or self
                              cancelButtonTitle:@"Tente novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        NSLog ( @ "Ops, não foi possível salvar: %@" , [ error localizedDescription ] ) ;
    }
    else
    {
        [self performSegueWithIdentifier:@"sValidadorCadastro" sender:self];
    }
    
    
    NSLog(@"Hash da senha %@",[self computeSHA256DigestForString:tfSenha.text]);
}

- (void)postCadastrar: (NSData*)jsonData
{
    
    [self.spinner startAnimating];
    
    NSURLSessionConfiguration *configObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: configObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = cadastrarURL;
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    
    [urlRequest setHTTPBody:jsonData];
    
    configObject.allowsCellularAccess = YES;
    [configObject setHTTPAdditionalHeaders:@{@"Accept":             @"application/json",
                                             @"Accept-Language":    @"br"}];
    
    configObject.timeoutIntervalForRequest      = 30.0;
    configObject.timeoutIntervalForResource     = 60.0;
    configObject.HTTPMaximumConnectionsPerHost  = 1;
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                    {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                               objectIDS = text;
                                                           
                                                               if (_foto == 0)
                                                               {
                                                                   imageView.image = [UIImage imageNamed:@"avatar_null_menos90.png"];
                                                               }
                                                               
                                                               [self salvarCadastroDB];
                                                               
                                                               if (_foto == 0)
                                                               {
                                                                   imageView.image = [UIImage imageNamed:@"avatar_null.png"];
                                                               }
                                                               
                                                           }
                                                           else
                                                           {
                                                               UIAlertView *alert = [[UIAlertView alloc]
                                                                                     initWithTitle:    error.localizedDescription
                                                                                     message:          error.localizedRecoverySuggestion
                                                                                     delegate:         nil //or self
                                                                                     cancelButtonTitle:@"Tente novamente"
                                                                                     otherButtonTitles:nil];
                                                               
                                                               [alert show];
                                                           }
                                                    }];
    [dataTask resume];
    
    [self.spinner stopAnimating];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            imagePicker.sourceType      = UIImagePickerControllerSourceTypeCamera;
            if (imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
            {
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            break;
        default:
            imagePicker.sourceType      = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    
    imagePicker.allowsEditing = YES;

    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //Cria a imagem com o resultado (foto da camera ou da galeria).
    UIImage* imageA = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    imageView.image = imageA;
    imageView.layer.cornerRadius    = roundf(imageView.frame.size.width/2.0);
    imageView.layer.masksToBounds   = YES;
    
    //Salvar no album de fotos.
    //UIImageWriteToSavedPhotosAlbum(imageA, nil, nil, nil);
    
    //Retorna a visão anterior.
    _foto = 1;
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)customizeAppearance
{
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,44)] ;
    [image setImage:[UIImage imageNamed:@"iChoseLabel"]];
    [self.navigationController.navigationBar.topItem setTitleView:image];
    
    //self.navigationItem.titleView = image;
   // [[UINavigationBar appearance] setBackgroundImage:leatherBackground forBarMetrics:UIBarMetricsDefault];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBirth {

    dateSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    [dateSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0,44,0,0);
    UIDatePicker *birthDayPicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
    [birthDayPicker setDatePickerMode:UIDatePickerModeDate];
    
    [dateSheet addSubview:birthDayPicker];
    
    UIToolbar *controlToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,dateSheet.bounds.size.width, 44)];
    [controlToolBar setBarStyle:UIBarStyleDefault];
    [controlToolBar sizeToFit];
    
    UIBarButtonItem *spacer         = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *setButton      = [[UIBarButtonItem alloc] initWithTitle:@"Ok" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDateSet)];
    
    [controlToolBar setItems:[NSArray arrayWithObjects:spacer, setButton, nil] animated:YES];
    
    [dateSheet addSubview:controlToolBar];
    
    [dateSheet showInView:self.contentView];
    
    [dateSheet setBounds:CGRectMake(0, 0, 320, 485)];
    
    // Limita a faixa acima de 18 anos.
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dataAtual = [NSDate date];
    NSDateComponents *limiteIdade = [[NSDateComponents alloc] init];
    [limiteIdade setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:limiteIdade toDate:dataAtual options:0];
    [birthDayPicker setMaximumDate:dataAtual];
    [birthDayPicker setDate:maxDate];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == tfDataNascimento) {
        [tfCelular becomeFirstResponder];
        [self setBirth];
        return NO;
    }
    return YES;
}

-(void)dismissDateSet
{
    NSArray *listOfViews = [dateSheet subviews];
    
    for (UIView *subView in listOfViews)
    {
        if ([subView isKindOfClass:[UIDatePicker class]])
        {
            self.birthDate = [(UIDatePicker *)subView date];
        }
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *dataAtual = [NSDate date];
    NSDateComponents *limiteIdade = [[NSDateComponents alloc] init];
    [limiteIdade setYear:-18];
    NSDate *maxDate = [calendar dateByAddingComponents:limiteIdade toDate:dataAtual options:0];

    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];
    
    if ([maxDate compare:birthDate] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Data inconsistente."
                              message:          @"Data informada é inferior a 18 anos!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Retorne e informe novamente"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    tfDataNascimento.text = [dateFormatter stringFromDate:self.birthDate];
    
    [dateSheet dismissWithClickedButtonIndex:0 animated:YES];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *filter = @"";
    
    if (textField == tfCPF)
    {
        filter = @"###.###.###-##";
    }
    else if (textField == tfCelular)
    {
        filter = @"(##)#####-####";
    }
    else if (textField == tfCEP)
    {
        filter = @"##.###-###";
    }
    else return YES;
    
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if(range.length == 1 && // Only do for single deletes
       string.length < range.length &&
       [[textField.text substringWithRange:range] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]].location == NSNotFound)
    {
        // Something was deleted.  Delete past the previous number
        NSInteger location = changedString.length-1;
        if(location > 0)
        {
            for(; location > 0; location--)
            {
                if(isdigit([changedString characterAtIndex:location]))
                {
                    break;
                }
            }
            changedString = [changedString substringToIndex:location];
        }
    }
    
    textField.text = filteredPhoneStringFromStringWithFilter(changedString, filter);
    
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfNome)
    {
        [tfSobreNome becomeFirstResponder];
        return YES;
    }
    else if (textField == tfSobreNome)
    {
        [tfCPF becomeFirstResponder];
        return YES;
    }
    else if (textField == tfCPF)
    {
        if ([validaCPF(tfCPF.text) isEqual:@"Yes"]) {
            [tfDataNascimento becomeFirstResponder];
            return YES;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                 initWithTitle:     @"Informação inconsistente."
                                 message:           @"O CPF não é válido!"
                                 delegate:          nil //or self
                                 cancelButtonTitle:@"Digitar Novamente"
                                 otherButtonTitles:nil];
            
            [alert show];
        }
    }
//    else if (textField == tfDataNascimento)
//    {
//        [tfCelular becomeFirstResponder];
//        return YES;
//    }
    else if (textField == tfCelular)
    {
        [tfCEP becomeFirstResponder];
        return YES;
    }
    else if (textField == tfCEP)
    {
        [tfEmail becomeFirstResponder];
        return YES;
    }
    else if (textField == tfEmail && tfEmail.text != nil)
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
        }
        else
        {
            [tfSenha becomeFirstResponder];
            return YES;
        }
    }
    else if (textField == tfSenha)
    {
        if (tfSenha.text.length > 3) {
            tfConfirmarSenha.enabled = YES;
            [tfConfirmarSenha becomeFirstResponder];
            return YES;
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Mínimo de 4 digitos para Senha!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    else if (textField == tfConfirmarSenha)
    {
        if ([tfSenha.text isEqual:tfConfirmarSenha.text])
        {
            [tfConfirmarSenha resignFirstResponder];
        }
        else
        {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"As senhas digitadas não são iguais!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        
        tfSenha.text                = nil;
        tfConfirmarSenha.text       = nil;
        tfConfirmarSenha.enabled    = NO;
        
        [tfSenha becomeFirstResponder];
        }
    }
    return NO;
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

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    float intSalto = 10.0;
    if ([[UIScreen mainScreen ] bounds].size.height < 568.0f)
    {
        intSalto = 15.0;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
    [self registerForKeyboardNotifications];
    
    if (textField == tfConfirmarSenha && tfSenha.text.length < 4)
    {
        tfConfirmarSenha.enabled = NO;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:    @"Informação inconsistente."
                              message:          @"Mínimo de 4 digitos para Senha!"
                              delegate:         nil //or self
                              cancelButtonTitle:@"Digitar Novamente"
                              otherButtonTitles:nil];
        
        [alert show];
        [tfSenha becomeFirstResponder];
    }
    else tfConfirmarSenha.enabled = YES;
 
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    [self registerForKeyboardNotifications];
    
    if (textField == tfEmail && tfEmail.text != nil)
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

            tfEmail.text = nil;
        }
    }
}

#pragma mark TAP Geture
- (IBAction)tap:(UITapGestureRecognizer *)sender
{
    [tfCelular          resignFirstResponder];
    [tfCEP              resignFirstResponder];
    [tfConfirmarSenha   resignFirstResponder];
    [tfEmail            resignFirstResponder];
    [tfNome             resignFirstResponder];
    [tfSenha            resignFirstResponder];
    [tfSobreNome        resignFirstResponder];
    [tfDataNascimento   resignFirstResponder];
    [tfCPF              resignFirstResponder];
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

#pragma mark Segue
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"sValidadorCadastro"])
    {
        return NO;
    }
    return YES;
}

@end
