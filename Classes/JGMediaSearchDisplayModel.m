//
//  RecordingsSearchDisplayModel.m
//  iTalk
//
//  Created by Jamin Guy on 7/14/10.
//  Copyright 2010 Griffin Technology. All rights reserved.
//

#import "JGMediaSearchDisplayModel.h"

#import <MediaPlayer/MediaPlayer.h>

@interface JGMediaSearchDisplayModel ()

@property (nonatomic, retain) NSArray *searchArray;

@end

@implementation JGMediaSearchDisplayModel

@synthesize searchArray;
@synthesize delegate;

#pragma mark -
#pragma mark search delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
	self.searchArray = [NSMutableArray array];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	self.searchArray = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	//[self.searchArray removeAllObjects];
	
    MPMediaQuery *mediaSearchQuery = [[[MPMediaQuery alloc] init] autorelease];
    MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:searchString forProperty:MPMediaPlaylistPropertyName comparisonType:MPMediaPredicateComparisonContains];
    [mediaSearchQuery addFilterPredicate:predicate];
    
    predicate = [MPMediaPropertyPredicate predicateWithValue:searchString forProperty:MPMediaPlaylistPropertyName comparisonType:MPMediaPredicateComparisonContains];
    [mediaSearchQuery addFilterPredicate:predicate];
    
	self.searchArray = [mediaSearchQuery collections];
			
	return YES;
}

#pragma mark Table Delegate and Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.searchArray.count ?: 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	UITableViewCell *cell;
	static NSString *SearchResultsTableViewCellIdentifier = @"SearchResultsTableViewCell";
	cell = [tableView dequeueReusableCellWithIdentifier:SearchResultsTableViewCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchResultsTableViewCellIdentifier] autorelease];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if([self.delegate respondsToSelector:@selector(didSelectSearchRecording:)]) {
//		[self.delegate didSelectSearchRecording:[self.searchArray objectAtIndex:indexPath.row]];
//	}
}

@end
