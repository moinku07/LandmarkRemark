//
//  CucumberishLoader.m
//  LandmarkRemarkAcceptanceTests
//
//  Created by Moin Uddin on 24/7/20.
//  Copyright © 2020 Moin Uddin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LandmarkRemarkAcceptanceTests-Swift.h"

__attribute__((constructor))
void CucumberishInit()
{
    [CucumberishInitializer setupCucumberish];
}
