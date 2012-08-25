//
//  TestViewController.m
//  IAOHTTPStubsHandler
//
//  Created by Ian Outterside on 25/08/2012.
//
//

#import "TestViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFImageRequestOperation.h"

@interface TestViewController ()

@end

@implementation TestViewController
@synthesize stubbedResponseLabel;
@synthesize liveResponseLabel;
@synthesize stubbedImageResponseImageView;

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
    // Do any additional setup after loading the view from its nib.
    
    // Stubbed response
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLRequest *stubbedURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.facebook.com/19292868552"]];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:stubbedURL success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!JSON) {
                    self.stubbedResponseLabel.text = @"Error - See Console.";
                }
                else {
                    self.stubbedResponseLabel.text = [JSON description];
                }
            });
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            NSLog(@"Stubbed response failed");
            NSLog(@"%@", [error localizedDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stubbedResponseLabel.text = @"Error - See Console.";
            });
        }];
        
        [operation start];
    });
    
    // Stubbed image response
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLRequest *stubbedURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://photos-e.ak.fbcdn.net/hphotos-ak-ash4/5041_98423808305_6704612_s.jpg"]];
        
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:stubbedURL imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!image) {
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error - See Console" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                else {
                    self.stubbedImageResponseImageView.image = image;
                }
            });
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
            NSLog(@"Stubbed image response failed");
            NSLog(@"%@", [error localizedDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Alert
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Error - See Console" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            });
        }];
        
        [operation start];
    });
    
    // Live response
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSURLRequest *stubbedURL = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://graph.facebook.com/195466193802264"]];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:stubbedURL success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!JSON) {
                    self.liveResponseLabel.text = @"Error - See Console.";
                }
                else {
                    self.liveResponseLabel.text = [JSON description];
                }
            });
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
            NSLog(@"Live response failed");
            NSLog(@"%@", [error localizedDescription]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.liveResponseLabel.text = @"Error - See Console.";
            });
        }];
        
        [operation start];
    });
}

- (void)viewDidUnload
{
    [self setStubbedResponseLabel:nil];
    [self setLiveResponseLabel:nil];
    [self setStubbedImageResponseImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
