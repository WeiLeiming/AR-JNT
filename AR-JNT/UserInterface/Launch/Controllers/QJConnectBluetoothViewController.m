//
//  QJConnectBluetoothViewController.m
//  AR-JNT
//
//  Created by willwei on 2017/5/26.
//  Copyright © 2017年 qj-vr. All rights reserved.
//

#import "QJConnectBluetoothViewController.h"
#import "QJConnectBluetoothView.h"
#import "QJNetworkingRequest.h"
#import "QJAddressModel.h"

#import <CoreBluetooth/CoreBluetooth.h>

#define kPeripheralLocalName                    @"AR-JNT"               // 外围设备名称
#define kServiceUUID                            @"FFF4"                 // 服务的UUID
#define kHandshakeCharacteristicUUID            @"FFF3"                 // 握手协议的特征UUID
#define kDataCharacteristicUUID                 @"FFF5"                 // 数据传输的特征UUID

@interface QJConnectBluetoothViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, QJConnectBluetoothViewDelegate> {
    Byte _hexD;
}

@property (nonatomic, strong) QJConnectBluetoothView *bluetoothView;

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral *peripheral;

@property (nonatomic, strong) CBCharacteristic *dataCharacteristic;     // 外设特征，扣动扳机回传数据
@property (nonatomic, strong) QJAddressModel *addressModel;             // 地址模型，用于数据库存储
@property (nonatomic, copy) NSString *macAddress;                       // mac地址

@property (nonatomic, strong) NSData *pressData;                        // 扳机扣下回传的数据
@property (nonatomic, strong) NSData *releaseData;                      // 扳机松开回传的数据

@end

@implementation QJConnectBluetoothViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [kAppDelegate hideUnityWindow];
    [self startFlashSequenceAnimation];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (NSData *)pressData {
    if (!_pressData) {
        Byte bytes[16] = {0x8f, 0xe9, 0xd7, 0xe1, 0x83, 0x07, 0x8a, 0xb8, 0x74, 0xbc, 0xca, 0xd3, 0x30, 0xb0, 0x14, 0x9a};
        _pressData = [NSData dataWithBytes:bytes length:16];
    }
    return _pressData;
}

- (NSData *)releaseData {
    if (!_releaseData) {
        Byte bytes[16] = {0x27, 0xb8, 0xcc, 0x3d, 0x6a, 0x4b, 0x0b, 0xc4, 0x04, 0x98, 0xf0, 0xb6, 0xe5, 0x6a, 0x49, 0xeb};
        _releaseData = [NSData dataWithBytes:bytes length:16];
    }
    return _releaseData;
}

- (QJAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[QJAddressModel alloc] init];
    }
    return _addressModel;
}

- (QJConnectBluetoothView *)bluetoothView {
    if (!_bluetoothView) {
        _bluetoothView = [[QJConnectBluetoothView alloc] init];
        _bluetoothView.delegate = self;
        [self.view addSubview:_bluetoothView];
        [_bluetoothView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _bluetoothView;
}

#pragma mark - Flash Animation
- (void)startFlashSequenceAnimation {
    [self.bluetoothView qj_startFlashSequenceAnimation];
}

#pragma mark - HUD
- (void)showInfoWithStatus:(NSString *)status {
    [self showInfoWithStatus:status dismissWithDelay:kProgressHUDShowDuration];
}

- (void)showInfoWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showImage:nil status:status];
    [SVProgressHUD dismissWithDelay:delay];
}

#pragma mark - Network
- (void)uploadMacAddress:(NSString *)address {
    // http://ip:port/macup/upload/{mac}
    NSString *mainPath = [kMainServerUrl stringByAppendingString:@"/macup/upload/"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", mainPath, address];
    [QJNetworkingRequest GET:urlStr parameters:nil needCache:NO success:^(id operation, id responseObject) {
        NSLog(@"responseObject: %@", responseObject);
        [self.addressModel saveOrUpdate];
    } failure:^(id operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - QJConnectBluetoothViewDelegate
- (void)connectBluetoothView:(QJConnectBluetoothView *)view languageBtnClicked:(UIButton *)sender {
    NSLog(@"change language button click");
    [QJLanguageManagerShare changeNowLanguage];
    [self.bluetoothView removeFromSuperview];
    self.bluetoothView = nil;
    [self startFlashSequenceAnimation];
}

#pragma mark - CBCentralManagerDelegate
/**
 中心管理者初始化，触发此代理方法，判断手机蓝牙状态
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"手机蓝牙状态 --->>> CBManagerStateUnknown");
            break;
        case CBManagerStateResetting:
            NSLog(@"手机蓝牙状态 --->>> CBManagerStateResetting");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"手机蓝牙状态 --->>> CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"手机蓝牙状态 --->>> CBManagerStateUnauthorized");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"手机蓝牙状态 --->>> CBManagerStatePoweredOff");
            [self showInfoWithStatus:QJLocalizedStringFromTable(@"蓝牙已关闭", @"Localizable")];
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"手机蓝牙状态 --->>> CBCentralManagerStatePoweredOn");
            [self showInfoWithStatus:QJLocalizedStringFromTable(@"蓝牙已打开", @"Localizable")];
            [central scanForPeripheralsWithServices:nil options:nil]; // 搜索蓝牙设备
            break;
        default:
            break;
    }
}

/**
 发现外设
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    if ([peripheral.name hasPrefix:kPeripheralLocalName]) {
        NSLog(@"已发现设备 --->>> peripheral: %@, RSSI: %@, advertisementData: %@", peripheral, RSSI, advertisementData);
        [self showInfoWithStatus:QJLocalizedStringFromTable(@"已发现设备", @"Localizable")];
        NSData *manufacturerData = advertisementData[@"kCBAdvDataManufacturerData"];
        self.macAddress = [self convertMacAddressString:manufacturerData];
        NSLog(@"Mac地址 --->>> Address: %@", self.macAddress);
        if ([self.macAddress isEqualToString:@"B6:0B:BA:13:D1:4E"]) {
            self.macAddress = nil;
            return;
        }
        self.peripheral = peripheral;
        [central stopScan]; // 停止搜索
        [central connectPeripheral:peripheral options:nil]; // 连接设备
    }
}

/**
 连接成功
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"连接成功 --->>> peripheral: %@", peripheral);
    [self showInfoWithStatus:QJLocalizedStringFromTable(@"连接成功", @"Localizable")];
    peripheral.delegate = self; // 设置外设的代理
    [peripheral readRSSI];
    [peripheral discoverServices:nil]; // 开始外设服务,传nil代表不过滤
}

/**
 连接失败
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"连接失败 --->>> peripheral: %@", peripheral);
    [self showInfoWithStatus:QJLocalizedStringFromTable(@"连接失败", @"Localizable")];
}

/**
 丢失连接
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"丢失连接 --->>> peripheral: %@", peripheral);
    [self showInfoWithStatus:QJLocalizedStringFromTable(@"丢失连接", @"Localizable") dismissWithDelay:2.0];
    [kAppDelegate hideUnityWindow];
}

#pragma mark - CBPeripheralDelegate
/**
 信号强度。调用readRSSI后触发
 */
- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    int rssi = abs([RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    #pragma unused (ci)
    NSLog(@"已读取信号强度值 --->>> %@, 距离: %.1fm", peripheral, pow(10, ci));
}

/**
 已发现服务后调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    CBService *interestingService;
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service --->>> %@", service);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
            interestingService = service;
        }
    }
    
    // 没搜索到服务，断开连接重新搜索并返回
    if (!interestingService) {
        // 断开连接后重新搜索
        [self.centralManager cancelPeripheralConnection:peripheral];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        return;
    }
    
    // 发现FFF4服务中的特征
    [peripheral discoverCharacteristics:nil forService:interestingService];
}

/**
 已发现Characteristic后调用
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"服务 --->>> service: %@", service);
    CBCharacteristic *interestingCharacteristic;
    BOOL isDataCharacteristicExist = NO;
    BOOL isHandshakeCharacteristicExist = NO;
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"Discovered characteristic --->>> %@", characteristic);
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kDataCharacteristicUUID]]) {
            // 扳机
            isDataCharacteristicExist = YES;
            self.dataCharacteristic = characteristic;
        } else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kHandshakeCharacteristicUUID]]) {
            // 握手
            isHandshakeCharacteristicExist = YES;
            interestingCharacteristic = characteristic;
        }
    }
    
    // 两个特征只要有一个不存在，就断开连接重新搜索并返回
    if (!(isDataCharacteristicExist && isHandshakeCharacteristicExist)) {
        // 断开连接后重新搜索
        [self.centralManager cancelPeripheralConnection:peripheral];
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
        return;
    }
    
    // 往握手特征写数据并监听
    if (interestingCharacteristic.properties == (CBCharacteristicPropertyWrite | CBCharacteristicPropertyNotify)) {
        NSData *randomData = [self generateRandomHexData];
        [peripheral writeValue:randomData forCharacteristic:interestingCharacteristic type:CBCharacteristicWriteWithResponse];
        [peripheral setNotifyValue:YES forCharacteristic:interestingCharacteristic];
    }
}

/**
 更新Characteristic的Value
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"更新Characteristic的Value --->>> %@", characteristic);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kDataCharacteristicUUID]] && characteristic.value) {
        if ([characteristic.value isEqualToData:self.pressData]) {
            NSLog(@"扳机扣下");
            UnitySendMessage("Player(Clone)", "AndroidMessgae", "gunon");
        } else if ([characteristic.value isEqualToData:self.releaseData]) {
            NSLog(@"扳机松开");
            UnitySendMessage("Player(Clone)", "AndroidMessgae", "gunoff");
        }
    }
}

/**
 更新Characteristic的NotificationState
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"更新Characteristic的NotificationState --->>> %@", characteristic);
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
        return;
    }
    
    if (characteristic.isNotifying && [characteristic.UUID isEqual:[CBUUID UUIDWithString:kHandshakeCharacteristicUUID]] && characteristic.value) {
        Byte backHexD;
        [characteristic.value getBytes:&backHexD range:NSMakeRange(13, 1)];
        if (_hexD == backHexD) {
            NSLog(@"握手一致，开始监听数据特征值");
            if ((self.dataCharacteristic.properties & CBCharacteristicPropertyNotify) == CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:YES forCharacteristic:self.dataCharacteristic];
            }
        } else {
            // 断开连接后重新搜索
            [self.centralManager cancelPeripheralConnection:peripheral];
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            return;
        }
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    } else if (characteristic.isNotifying && [characteristic.UUID isEqual:[CBUUID UUIDWithString:kDataCharacteristicUUID]]) {
        NSArray *addressArray = [QJAddressModel findFormatSqlConditions:@"where %@=%@",sqlKey(@"address"),sqlValue(self.macAddress)];
        NSLog(@"addressArray = %@", addressArray);
        if (addressArray.count == 0) {
            self.addressModel.address = self.macAddress;
            [self uploadMacAddress:self.macAddress];
        }

        [peripheral readValueForCharacteristic:characteristic];
        
        // 进入U3D界面
        [kAppDelegate showUnityWindow];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"已发送数据成功 --->>> %@, error = %@", characteristic, error);
}

#pragma mark - Private method
- (NSData *)generateRandomHexData {
    Byte byte[16];
    Byte hexA = 0, hexB = 0, hexC = 0;
    for (int i = 0; i < 16; i ++) {
        Byte randomInt = arc4random() % 256;
        byte[i] = randomInt;
        switch (i) {
            case 2:
                hexA = randomInt;
                break;
            case 4:
                hexB = randomInt;
                break;
            case 9:
                hexC = randomInt;
                break;
            default:
                break;
        }
    }
    NSData *randomData = [NSData dataWithBytes:byte length:16];
    
//    [randomData getBytes:&hexA range:NSMakeRange(2, 1)];
//    [randomData getBytes:&hexB range:NSMakeRange(4, 1)];
//    [randomData getBytes:&hexC range:NSMakeRange(9, 1)];
    
    _hexD = (hexA | hexB) ^ hexC;
    NSLog(@"RandomData = %@, hexA = %x, hexB = %x, hexC = %x, hexD = %x", randomData, hexA, hexB, hexC, _hexD);
    return randomData;
}

#pragma mark - Util
- (NSString *)convertMacAddressString:(NSData *)valueData {
    NSString *valueString = [NSString stringWithFormat:@"%@", valueData];
    NSMutableString *macAddressString = [[NSMutableString alloc] init];
    
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(23, 2)] uppercaseString]];
    [macAddressString appendString:@":"];
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(25, 2)] uppercaseString]];
    [macAddressString appendString:@":"];
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(28, 2)] uppercaseString]];
    [macAddressString appendString:@":"];
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(30, 2)] uppercaseString]];
    [macAddressString appendString:@":"];
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(32, 2)] uppercaseString]];
    [macAddressString appendString:@":"];
    [macAddressString appendString:[[valueString substringWithRange:NSMakeRange(34, 2)] uppercaseString]];
    
    return macAddressString.copy;
}

@end
