//
//  IndiaPlugin.m
//  Pods
//
//  Created by Vamshi Vadnala on 19/12/24.
//

#import <Foundation/Foundation.h>
#import "IndiaPlugin.h"
#import <india_sdk/india_sdk-Swift.h>


@implementation IndiaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [IndiaSdkPlugin registerWithRegistrar:registrar];
}
@end

