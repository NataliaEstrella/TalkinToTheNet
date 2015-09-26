//
//  APIDetailViewController.m
//  TalkinToTheNet
//
//  Created by Natalia Estrella on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "APIDetailViewController.h"
#import "APImanager.h"

@interface APIDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailAdressLabel;

@end

@implementation APIDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailNameLabel.text = self.result.name;
    self.detailAdressLabel.text = [self.result.address componentsJoinedByString:@"\n"];

    
    
    
    
    
    
    //url(media=music, term=searchTerm)
    NSString *urlString= [NSString stringWithFormat:@"https://api.giphy.com/v1/gifs/search?q=%@&api_key=dc6zaTOxFJmzC", self.result.name];
    
    //encoded URL
    NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    //make the request
    //do somehting with the data
    
    NSURL *url = [NSURL URLWithString:encodingString];
    [APImanager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!data) return;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:0 error:nil];
        
        NSString *imageURLString = [json[@"data"] firstObject][@"images"][@"original_still"][@"url"];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
        
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData: imageData];
        self.detailImageView.image = image;
    }];
    
    
    
    
    

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
