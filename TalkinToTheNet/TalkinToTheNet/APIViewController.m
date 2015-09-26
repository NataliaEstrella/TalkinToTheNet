//
//  APIViewController.m
//  TalkinToTheNet
//
//  Created by Natalia Estrella on 9/24/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "APIViewController.h"
#import "APImanager.h"
#import "APIResults.h"
#import "APIDetailViewController.h"



@interface APIViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *searchResults;
@end

@implementation APIViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self. searchTextField.delegate = self;
}
-(void)makeFoursquareResquest:(NSString *)searchTerm
               callbacKBlock:(void(^)())block{
    
    //search term (from parameter)
    
    //url(media=music, term=searchTerm)
    NSString *urlString= [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=FHAENKZF2HR2UU4JZ23CSSYGXABP3SGMNIKU5QMK4GEP1OXU&client_secret=Q43OVAQPHPZW1PKBYB05YKURVRIOKZUFMEN3ND3UEH5CJAKI&v=20130815&ll=40.7,-74&query=%@", searchTerm];
    
    //encoded URL
    NSString *encodingString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSLog(@"%@", encodingString);
    
    //make the request
    //do somehting with the data
    
    NSURL *url = [NSURL URLWithString:encodingString];
    [APImanager GETRequestWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (data !=nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:0 error:nil];
            NSLog(@"%@", json);
            
//            NSArray *results = [json objectForKey:@"results"];
            
            
            
            self.searchResults = [[NSMutableArray alloc] init];
            
            for (NSDictionary *venue in json[@"response"][@"venues"]) {
                
                NSString *name = venue[@"name"];
                NSArray *address = venue[@"location"][@"formattedAddress"];
                
                
                APIResults *searchObject = [[APIResults alloc] init];
                
                
                searchObject.name = name;
                searchObject.address = address;
                
                [self.searchResults addObject:searchObject];
                
            }
            block ();
        }
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    APIResults *currentResult = self.searchResults[indexPath.row];
    cell.textLabel.text = currentResult.name;
    cell.detailTextLabel.text = currentResult.address.firstObject;
    
    
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [self performSegueWithIdentifier:@"DetailSegue" sender:self.searchResults[indexPath.row]];
}

#pragma mark - text field delegate

//user tapped return
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //dimiss the keyboard and lose focus
    [self.view endEditing:YES];
    
    
    //make an API request
    [self makeFoursquareResquest:textField.text callbacKBlock:^{
        [self.tableView reloadData];
    }];
    
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    APIDetailViewController *detailVC = [segue destinationViewController];
    
    detailVC.result = sender;
    
    

}


@end
