#import "_BASQuestion.h"

@interface BASQuestion : _BASQuestion {}

+ (instancetype)fetchRandomQuestionIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
