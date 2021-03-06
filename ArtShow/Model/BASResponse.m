#import "BASResponse.h"

@interface BASResponse ()

// Private interface goes here.

@end

@implementation BASResponse

+ (instancetype)fetchRandomResponseIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    
    NSError *error = nil;
    NSUInteger responseCount = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (nil != error) {
        NSLog(@"Error while fetching random question: %@", error);
    }
    
    if (responseCount == 0) {
        return nil;
    }
    
    NSUInteger offset = arc4random_uniform((unsigned int)responseCount);
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:1];
    
    NSError *fetchError = nil;
    NSArray *responses = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (nil != fetchError) {
        NSLog(@"Error while fetching random question: %@", error);
    }
    
    return responses[0];
}

@end
