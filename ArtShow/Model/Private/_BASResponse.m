// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BASResponse.m instead.

#import "_BASResponse.h"

const struct BASResponseAttributes BASResponseAttributes = {
	.image = @"image",
	.responseText = @"responseText",
};

const struct BASResponseRelationships BASResponseRelationships = {
	.question = @"question",
};

@implementation BASResponseID
@end

@implementation _BASResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BASResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BASResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BASResponse" inManagedObjectContext:moc_];
}

- (BASResponseID*)objectID {
	return (BASResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic image;

@dynamic responseText;

@dynamic question;

@end

