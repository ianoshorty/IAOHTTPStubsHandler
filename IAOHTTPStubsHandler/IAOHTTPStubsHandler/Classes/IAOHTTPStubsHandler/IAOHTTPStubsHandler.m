/******************************* IAOHTTPStubsHandler LICENCE ******************************/

/***********************************************************************************
 *
 * Copyright (c) 2012 Ian Outterside
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ***********************************************************************************
 *
 * Any comments or suggestions are welcome. Referencing this project in your work is
 * very much appreciated.
 *
 * I hereby accept NO liability or responsibility if using this code causes any
 * problems for you. Always check and test before you import other frameworks /
 * libraries and files into your projects!
 *
 * Ian Outterside
 *
 ***********************************************************************************/

//
//  IAOHTTPStubsHandler.m
//  IAOHTTPStubsHandler
//
//  Created by Ian Outterside on 25/08/2012.
//
//

#import "IAOHTTPStubsHandler.h"
#import "OHHTTPStubs.h"
#import <MobileCoreServices/UTType.h>

@implementation IAOHTTPStubsHandler

#pragma mark Utility

// Wraps around OHHTTPStubsDownload constants to convert provided strings in mappings.json to correct speeds
+ (double)responseSpeedForString:(NSString *)string {
    
    if ([string isEqualToString:@"OHHTTPStubsDownloadSpeedGPRS"]) {
        return OHHTTPStubsDownloadSpeedGPRS;
    }
    else if ([string isEqualToString:@"OHHTTPStubsDownloadSpeedEDGE"]) {
        return OHHTTPStubsDownloadSpeedEDGE;
    }
    else if ([string isEqualToString:@"OHHTTPStubsDownloadSpeed3G"]) {
        return OHHTTPStubsDownloadSpeed3G;
    }
    else if ([string isEqualToString:@"OHHTTPStubsDownloadSpeed3GPlus"]) {
        return OHHTTPStubsDownloadSpeed3GPlus;
    }
    else {
        return OHHTTPStubsDownloadSpeedWifi;
    }
}

#pragma mark 

+ (void)activateStubsResponses {
    
    NSDictionary* stubs = nil;
    
    NSString *stubsFolder = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Stubs"];
    
    BOOL isDirectory = NO;
    
    // Check the master stubs folder is present
    if (![[NSFileManager defaultManager] fileExistsAtPath:stubsFolder isDirectory:&isDirectory] || !isDirectory) {
        NSLog(@"Stubs folder does not exist in project. Please add it and continue. See README.md for more.");
        
        return;
    }
    
    NSString *mappingsFile = [stubsFolder stringByAppendingPathComponent:@"mappings.json"];
    
    isDirectory = YES;
    
    // Check a mappings file exists and contains valid mappings json
    if (![[NSFileManager defaultManager] fileExistsAtPath:mappingsFile isDirectory:&isDirectory] || isDirectory) {
        NSLog(@"Mappings file does not exist in stubs folder. Please add it and continue. See README.md for more.");
        
        return;
    }
    else {
        NSData *data = [NSData dataWithContentsOfFile:mappingsFile];
        
        if (!data) {
            NSLog(@"Mappings file did not contain any data. Please make sure it contains a valid JSON object of key:value mappings.");
            
            return;
        }
        else {
            NSError *error = nil;
            id JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error) {
                NSLog(@"JSON Parsing of mappings file failed.");
                NSLog(@"%@", [error localizedDescription]);
                
                return;
            }
            else {
                if (![JSON isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"JSON Parsing of mappings file failed.");
                    NSLog(@"Top level element was not a JSON object. Please make sure it contains a valid JSON object of key:value mappings.");
                    
                    return;
                }
                else {
                    
                    // Store the dictionary of mappings in stubs
                    stubs = JSON;
                }
            }
        }
    }
    
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse*(NSURLRequest *request, BOOL onlyCheck)
     {
         if (onlyCheck) {
             
             //TODO: Fix - at present this throws a warning
             NSString *returnString = ([stubs valueForKey:request.URL.absoluteString] ? @"OHHTTPStubsResponseUseStub" : nil);
             
             /* Uncomment to be told when stubs are not in use
             if (!returnString) {
                 NSLog(@"DID NOT USE Stub For: %@", request.URL.absoluteString);
             }
              */
             
             return returnString;
         }
         
         NSString *path = [[stubs valueForKey:request.URL.absoluteString] valueForKey:@"file"]; // contains the file path
         NSString *pathExt = [path pathExtension];
         NSString *fileName = [path stringByDeletingPathExtension];
         NSString *file = [[NSBundle mainBundle] pathForResource:fileName ofType:pathExt inDirectory:@"Stubs"];
         
         if (!file) {
             NSLog(@"FILE DOES NOT EXIST for specified request URL: %@", request.URL.absoluteString);
         }
         
         NSData *fileContents = [NSData dataWithContentsOfFile:file];
        
         NSString *mimeType = [[stubs valueForKey:request.URL.absoluteString] valueForKey:@"content_type"];
        
         // Attempt autodetection of content-type
         if (!mimeType) {
             
             CFStringRef pathExtension = (__bridge_retained CFStringRef)pathExt;
             CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
             CFRelease(pathExtension);
             mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
             if (type != NULL) {
                 CFRelease(type);
             }
         }
         
         // Default JSON content-type
         NSDictionary *contentType = nil;
         
         if (!mimeType) {
             contentType = @{@"Content-Type" : @"text/json"};
         }
         else {
             contentType = @{@"Content-Type" : mimeType};
         }
         
         // Default 200 response code
         NSInteger responseCode = 200;
         
         if ([[stubs valueForKey:request.URL.absoluteString] valueForKey:@"response_code"]) {
             responseCode = [[[stubs valueForKey:request.URL.absoluteString] valueForKey:@"response_code"] integerValue];
         }
         
         // Default Wifi response time
         double responseTime = OHHTTPStubsDownloadSpeedWifi;
         
         if ([[stubs valueForKey:request.URL.absoluteString] valueForKey:@"response_speed"]) {
             NSString *responseSpeed = [[stubs valueForKey:request.URL.absoluteString] valueForKey:@"response_speed"];
             
             responseTime = [self responseSpeedForString:responseSpeed];
         }
         
         return [OHHTTPStubsResponse responseWithData:fileContents statusCode:responseCode responseTime:responseTime headers:contentType];
     }];
}

@end
