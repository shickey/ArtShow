#import "_BASResponse.h"

@interface BASResponse : _BASResponse {}

+ (instancetype)fetchRandomResponseIntoManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
