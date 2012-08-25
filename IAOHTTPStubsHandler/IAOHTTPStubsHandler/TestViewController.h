//
//  TestViewController.h
//  IAOHTTPStubsHandler
//
//  Created by Ian Outterside on 25/08/2012.
//
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *stubbedResponseLabel;
@property (strong, nonatomic) IBOutlet UILabel *liveResponseLabel;
@property (strong, nonatomic) IBOutlet UIImageView *stubbedImageResponseImageView;

@end
