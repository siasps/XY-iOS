//
//  UIDevice+KIAdditions.m
//  HuaxiajiaboApp
//
//  Created by HuamoMac on 15/4/20.
//  Copyright (c) 2015年 HuaMo. All rights reserved.
//

#import "UIDevice+KIAdditions.h"
#import <sys/sysctl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
#include <sys/types.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>


static NSString *memoryUUID = nil;


@implementation UIDevice (KIAdditions)

+ (NSString *) deviceType
{
    NSString *deviceType = [[NSUserDefaults standardUserDefaults] stringForKey:@"devicetype"];
    if(nil != deviceType && [deviceType length]>0)
        return deviceType;
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    deviceType = [NSString stringWithUTF8String:machine];
    free(machine);
    /*
     if ([platform isEqualToString:@"iPhone1,1"])    deviceType = @"iPhone 1G";
     else if ([platform isEqualToString:@"iPhone1,2"])    deviceType = @"iPhone 3G";
     else if ([platform isEqualToString:@"iPhone2,1"])    deviceType = @"iPhone 3GS";
     else if ([platform isEqualToString:@"iPhone3,1"])    deviceType = @"iPhone 4";
     else if ([platform isEqualToString:@"iPhone3,3"])    deviceType = @"iPhone 4 Verizon";
     else if ([platform isEqualToString:@"iPhone4,1"])    deviceType = @"iPhone 4S";
     else if ([platform isEqualToString:@"iPhone5,2"])    deviceType = @"iPhone 5";
     
     else if ([platform isEqualToString:@"iPod1,1"])      deviceType = @"iPod Touch 1G";
     else if ([platform isEqualToString:@"iPod2,1"])      deviceType = @"iPod Touch 2G";
     else if ([platform isEqualToString:@"iPod3,1"])      deviceType = @"iPod Touch 3G";
     else if ([platform isEqualToString:@"iPod4,1"])      deviceType = @"iPod Touch 4G";
     
     else if ([platform isEqualToString:@"iPad1,1"])      deviceType = @"iPad";
     else if ([platform isEqualToString:@"iPad2,1"])      deviceType = @"iPad 2 (WiFi)";
     else if ([platform isEqualToString:@"iPad2,2"])      deviceType = @"iPad 2 (GSM)";
     else if ([platform isEqualToString:@"iPad2,3"])      deviceType = @"iPad 2 (CDMA)";
     
     else if ([platform isEqualToString:@"i386"])         deviceType = @"Simulator";
     
     
     if (nil == deviceType)  deviceType = platform;
     if (nil == deviceType)  deviceType = @"";
     if (nil != deviceType) */
    [[NSUserDefaults standardUserDefaults] setValue:deviceType forKey:@"devicetype"];
    
    return deviceType;
}

+ (NSString *)getNetType{
    NSString *netType = @"G";
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == ReachableViaWiFi) {
        netType = @"WIFI";
    }else {
        NSString *version = [[UIDevice currentDevice] systemVersion];
        CGFloat versionNum = [version floatValue];
        if (versionNum>4.0) {
            CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
            CTCarrier *carrier = [netinfo subscriberCellularProvider];
            NSString *netName;
            netName = [carrier carrierName];
            if ([netName isEqualToString:@"中国联通"]) {
                netType = @"CU";
            }else if([netName isEqualToString:@"中国移动"]){
                netType = @"CM";
            }else if([netName isEqualToString:@"中国电信"]){
                netType = @"CT";
            }else {
                netType = @"G";
            }
        }
    }
    
    return netType;
}


char*  getMacAddress(char* macAddress, char* ifName) {
    
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    const struct sockaddr_dl * dlAddr;
    const unsigned char* base;
    int i;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0) {
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == 0x6) && strcmp(ifName,  cursor->ifa_name)==0 ) {
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                strcpy(macAddress, "");
                for (i = 0; i < dlAddr->sdl_alen; i++) {
                    if (i != 0) {
                        strcat(macAddress, ":");
                    }
                    char partialAddr[3];
                    sprintf(partialAddr, "%02X", base[i]);
                    strcat(macAddress, partialAddr);
                    
                }
            }
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    return macAddress;
}

+(NSString *)getMacAddress
{
    char* macAddressString= (char*)malloc(18);
    NSString* macAddress= [[NSString alloc] initWithCString:getMacAddress(macAddressString,"en0")
                                                   encoding:NSMacOSRomanStringEncoding];
    free(macAddressString);
    return macAddress;
}

//#pragma mark Public Methods
//- (NSString *) uniqueDeviceIdentifier{
//    @synchronized(self){
//        if (memoryUUID == nil || [memoryUUID isEqualToString: @""]) {
//            NSString *defaultUUID = [[NSUserDefaults standardUserDefaults] stringForKey: HM_UUID_KEY];
//            if (defaultUUID == nil || [defaultUUID isEqualToString:@""]) {
//                float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
//                UIPasteboard *board;
//                //ios 7.0 用系统剪贴板
//                if (systemVersion > 6.99) {
//                    board = [UIPasteboard generalPasteboard];
//                }
//                else {
//                    board = [UIPasteboard pasteboardWithName:HM_UUID_KEY create: YES];
//                }
//                
//                NSString *pasteboardUUID = [[NSString alloc] initWithData: [board dataForPasteboardType: HM_UUID_KEY] encoding:NSUTF8StringEncoding];
//                if (pasteboardUUID == nil || [pasteboardUUID isEqualToString:@""]) {
//                    NSString *keyChainUUID = [SFHFKeychainUtils getPasswordForUsername:HM_UUID_KEY andServiceName:HM_SERVER_NAME error:nil];
//                    NIF_TRACE(@"+++++++++++++++++++++deviceid:%@",keyChainUUID);
//                    if (keyChainUUID == nil || [keyChainUUID isEqualToString:@""]){
//                        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
//                        //keyChainUUID = [NSString stringWithFormat:@"HJB-%@",(NSString *)CFUUIDCreateString (kCFAllocatorDefault,uuidRef)];
//                        keyChainUUID = [NSString stringWithFormat:@"HJB-%@",(NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef))];
//                        [SFHFKeychainUtils storeUsername:HM_UUID_KEY andPassword:keyChainUUID forServiceName:HM_SERVER_NAME updateExisting:YES error:nil];
//                        //    [SFHFKeychainUtils deleteItemForUsername:DDCOUPON_UUID_KEY andServiceName:DDCOUPON_SERVER_NAME error:nil];//remove uuid from keychain
//                    }
//                    [board setData: [keyChainUUID dataUsingEncoding: NSUTF8StringEncoding] forPasteboardType: HM_UUID_KEY];
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:keyChainUUID forKey:HM_UUID_KEY];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                    
//                    memoryUUID = [[NSString alloc]initWithString:keyChainUUID];
//                    return keyChainUUID;
//                }
//                
//                [[NSUserDefaults standardUserDefaults] setObject:pasteboardUUID forKey:HM_UUID_KEY];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                memoryUUID = pasteboardUUID;
//                return pasteboardUUID;
//            }
//            memoryUUID = defaultUUID ;
//            return defaultUUID;
//        }
//        return memoryUUID;
//    }
//}

@end
