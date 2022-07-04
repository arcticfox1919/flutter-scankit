//
//  ScanViewController.m
//  flutter_hms_scankit
//
//  Created by mac on 2022/6/29.
//

#import "ScanViewController.h"
#import "SGQRCode.h"
#import <AVFoundation/AVFoundation.h>
@interface ScanViewController ()
{
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) BOOL isSelectedFlashlightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) AVCaptureDevice *device;
@end

@implementation ScanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /// 二维码开启方法
    [scanCode startRunningWithBefore:nil completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView stopScanning];
    [scanCode stopRunning];
}

- (void)dealloc {
    NSLog(@"WCQRCodeVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    scanCode = [SGScanCode scanCode];
    [self setupQRCodeScan];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [self.view addSubview:self.flashlightBtn];
    [self.view addSubview:self.scanView];
    [self setupNavigationBar];
}

- (void)setupQRCodeScan {

    [scanCode scanWithController:self resultBlock:^(SGScanCode *scanCode, NSString *result) {
        if (result) {
            [scanCode stopRunning];
            [self removeScanningView];
            self.successResult(result);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}

- (SGScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView stopScanning];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}
- (void)flashlightBtn_action:(UIButton *)button {
    if (button.selected == NO) {
        [button setImage:[self resourceBundleOfImageName:@"lightoff"] forState:UIControlStateNormal];
        if ([self.device hasTorch]) {
        [self.device lockForConfiguration:nil];
         // 开启手电筒
        [self.device setTorchMode:AVCaptureTorchModeOn];
         // 解除独占访问硬件设备
        [self.device unlockForConfiguration];
        button.selected = YES;
        }
    } else {
        [button setImage:[self resourceBundleOfImageName:@"lighton"] forState:UIControlStateNormal];
        button.selected = NO;
        [self.device lockForConfiguration:nil];
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device unlockForConfiguration];
    }
}

- (void)setupNavigationBar {
    
    UIButton * albumButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-60,40,40,40)];
    [self.view addSubview:albumButton];
    [albumButton setImage:[self resourceBundleOfImageName:@"album"] forState:UIControlStateNormal];
    [albumButton addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * backButton = [[UIButton alloc]initWithFrame:CGRectMake(20,40,30,30)];
    [self.view addSubview:backButton];
    [backButton setImage:[self resourceBundleOfImageName:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *flashlightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:flashlightBtn];
    CGFloat flashlightBtnW = 120;
    CGFloat flashlightBtnH = 40;
    CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
    CGFloat flashlightBtnY = 40+self.view.bounds.size.height*2/3;
     flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
    [flashlightBtn setImage:[self resourceBundleOfImageName:@"lighton"] forState:UIControlStateNormal];
    flashlightBtn.selected = NO;
    [  flashlightBtn addTarget:self action:@selector(flashlightBtn_action:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)backButton
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;
    [scanCode readWithResultBlock:^(SGScanCode *scanCode, NSString *result) {
       
        if (result == nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"QR code is not recognized yet, please try again" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"点击了确认按钮");
                    }];
                   
                    //3.将动作按钮 添加到控制器中
                    [alert addAction:conform];
                   //4.显示弹框
                [self presentViewController:alert animated:YES completion:nil];
            });
          } else {
              self.successResult(result);
              [self dismissViewControllerAnimated:YES completion:nil];
     }
        
    }];
    
    if (scanCode.albumAuthorization == YES) {
        [self.scanView stopScanning];
    }
    [scanCode albumDidCancelBlock:^(SGScanCode *scanCode) {
        [weakSelf.scanView startScanning];
    }];
}

- (UIImage *)resourceBundleOfImageName:(NSString *)imageName {
    NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"flutter_hms_scankit" ofType:@"bundle"]];
    if (@available(iOS 13.0, *)) {
        UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle withConfiguration:nil];
        return image;
     } else {
        UIImage *image = [UIImage imageNamed:imageName inBundle:resourceBundle compatibleWithTraitCollection:nil];
        return  image;
        // Fallback on earlier versions
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
