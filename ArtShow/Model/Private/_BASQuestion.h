// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BASQuestion.h instead.

@import CoreData;

extern const struct BASQuestionAttributes {
	__unsafe_unretained NSString *questionText;
} BASQuestionAttributes;

extern const struct BASQuestionRelationships {
	__unsafe_unretained NSString *responses;
} BASQuestionRelationships;

@class BASResponse;

@interface BASQuestionID : NSManagedObjectID {}
@end

@interface _BASQuestion : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BASQuestionID* objectID;

@property (nonatomic, strong) NSString* questionText;

//- (BOOL)validateQuestionText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *responses;

- (NSMutableSet*)responsesSet;

@end

@interface _BASQuestion (ResponsesCoreDataGeneratedAccessors)
- (void)addResponses:(NSSet*)value_;
- (void)removeResponses:(NSSet*)value_;
- (void)addResponsesObject:(BASResponse*)value_;
- (void)removeResponsesObject:(BASResponse*)value_;

@end

@interface _BASQuestion (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveQuestionText;
- (void)setPrimitiveQuestionText:(NSString*)value;

- (NSMutableSet*)primitiveResponses;
- (void)setPrimitiveResponses:(NSMutableSet*)value;

@end
