#import "BASQuestion.h"

@interface BASQuestion ()

// Private interface goes here.

@end

@implementation BASQuestion

+ (instancetype)fetchRandomQuestionIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
    
    NSError *error = nil;
    NSUInteger questionCount = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    if (nil != error) {
        NSLog(@"Error while fetching random question: %@", error);
    }
    
    if (questionCount == 0) {
        return nil;
    }
    
    NSUInteger offset = arc4random_uniform((unsigned int)questionCount);
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setFetchLimit:1];
    
    NSError *fetchError = nil;
    NSArray *questions = [managedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    if (nil != fetchError) {
        NSLog(@"Error while fetching random question: %@", error);
    }
    
    return questions[0];
}

@end
