//
//  FMDatabase+Mapping.h
//  eim
//
//  Created by Justin Yip on 3/19/14.
//  Copyright (c) 2014 Forever Open-source Software Inc. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (Mapping)

- (BOOL)createTable:(NSString*)aTable columns:(NSDictionary*)arguments;

- (BOOL)createTable:(NSString*)aTable columns:(NSDictionary*)arguments PrimaryKey:(NSArray*)pkeys;

- (BOOL)createTableIfNotExists:(NSString*)aTable columns:(NSDictionary*)arguments;

- (BOOL)executeInsertInTable:(NSString *)aTable withParameterDictionary:(NSDictionary *)arguments;

- (BOOL)executeInsertOrReplaceInTable:(NSString *)aTable withParameterDictionary:(NSDictionary *)arguments;

- (FMResultSet*)executeQueryInTable:(NSString*)aTable columns:(NSArray*)columns where:(NSString*)where parameters:(NSDictionary *)arguments;

@end

@interface FMResultSet (Mapping)

- (NSArray*)mapToArrayOfClass:(Class)cls;

- (NSArray*)mapToArrayOfClass:(Class)cls propertyMapping:(NSDictionary*)columnToPropertyMap;

- (id)mapToObjectOfClass:(Class)cls;

- (id)mapToObjectOfClass:(Class)cls propertyMapping:(NSDictionary*)columnToPropertyMap;

@end
