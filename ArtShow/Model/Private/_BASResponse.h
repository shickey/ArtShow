// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BASResponse.h instead.

@import CoreData;

extern const struct BASResponseAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *responseText;
} BASResponseAttributes;

extern const struct BASResponseRelationships {
	__unsafe_unretained NSString *question;
} BASResponseRelationships;

@class BASQuestion;

@interface BASResponseID : NSManagedObjectID {}
@end

@interface _BASResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BASResponseID* objectID;

@property (nonatomic, strong) NSData* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* responseText;

//- (BOOL)validateResponseText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BASQuestion *question;

//- (BOOL)validateQuestion:(id*)value_ error:(NSError**)error_;

@end

@interface _BASResponse (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;

- (NSString*)primitiveResponseText;
- (void)setPrimitiveResponseText:(NSString*)value;

- (BASQuestion*)primitiveQuestion;
- (void)setPrimitiveQuestion:(BASQuestion*)value;

@end
