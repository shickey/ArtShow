// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BASQuestion.m instead.

#import "_BASQuestion.h"

const struct BASQuestionAttributes BASQuestionAttributes = {
	.questionText = @"questionText",
};

const struct BASQuestionRelationships BASQuestionRelationships = {
	.responses = @"responses",
};

@implementation BASQuestionID
@end

@implementation _BASQuestion

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BASQuestion" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BASQuestion";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BASQuestion" inManagedObjectContext:moc_];
}

- (BASQuestionID*)objectID {
	return (BASQuestionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic questionText;

@dynamic responses;

- (NSMutableSet*)responsesSet {
	[self willAccessValueForKey:@"responses"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"responses"];

	[self didAccessValueForKey:@"responses"];
	return result;
}

@end

