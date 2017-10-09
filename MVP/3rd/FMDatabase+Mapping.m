//
//  FMDatabase+Mapping.m
//  eim
//
//  Created by Justin Yip on 3/19/14.
//  Copyright (c) 2014 Forever Open-source Software Inc. All rights reserved.
//

#import "FMDatabase+Mapping.h"
#import "FMDatabaseAdditions.h"
#import "RXCollection.h"

@implementation FMDatabase (Mapping)

- (BOOL)createTable:(NSString*)aTable columns:(NSDictionary*)arguments
{
    NSArray *keys = [arguments allKeys];
    NSString *columnsDescription = [[keys rx_mapWithBlock:^id(id key) {
        return [NSString stringWithFormat:@"'%@' %@", key, arguments[key]];
    }] componentsJoinedByString:@", "];
    
    NSString *SQL = [NSString stringWithFormat:@"CREATE TABLE '%@' (%@)", aTable, columnsDescription];
    
    return [self executeUpdate:SQL];
}

- (BOOL)createTable:(NSString*)aTable columns:(NSDictionary*)arguments PrimaryKey:(NSArray*)pkeys
{
    NSArray *keys = [arguments allKeys];
    NSString *columnsDescription = [[keys rx_mapWithBlock:^id(id key) {
        return [NSString stringWithFormat:@"'%@' %@", key, arguments[key]];
    }] componentsJoinedByString:@", "];

    NSString *pkey = [[pkeys rx_mapWithBlock:^id(id key) {
        return [NSString stringWithFormat:@"'%@'", key];
    }] componentsJoinedByString:@", "];
    
    NSString *SQL = [NSString stringWithFormat:@"CREATE TABLE '%@' (%@ ,PRIMARY KEY (%@)) ", aTable, columnsDescription,pkey];
    return [self executeUpdate:SQL];
}

- (BOOL)createTableIfNotExists:(NSString*)aTable columns:(NSDictionary*)arguments
{
    if ([self tableExists:aTable]) return YES;
    
    return [self createTable:aTable columns:arguments];
}

- (BOOL)executeInsertInTable:(NSString *)aTable withParameterDictionary:(NSDictionary *)arguments
{
    NSArray *keys = [arguments allKeys];
    NSString *columns = [[keys rx_mapWithBlock:^id(id each) {
        return [NSString stringWithFormat:@"'%@'", each];
    }] componentsJoinedByString:@", "];
    
    NSString *params = [[keys rx_mapWithBlock:^id(id each) {
        return [NSString stringWithFormat:@":%@", each];
    }] componentsJoinedByString:@", "];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO '%@' (%@) VALUES (%@)", aTable, columns, params];
    return [self executeUpdate:sql withParameterDictionary:arguments];
}

- (BOOL)executeInsertOrReplaceInTable:(NSString *)aTable withParameterDictionary:(NSDictionary *)arguments
{
    NSArray *keys = [arguments allKeys];
    NSString *columns = [[keys rx_mapWithBlock:^id(id each) {
        return [NSString stringWithFormat:@"'%@'", each];
    }] componentsJoinedByString:@", "];
    
    NSString *params = [[keys rx_mapWithBlock:^id(id each) {
        return [NSString stringWithFormat:@":%@", each];
    }] componentsJoinedByString:@", "];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO '%@' (%@) VALUES (%@)", aTable, columns, params];
    return [self executeUpdate:sql withParameterDictionary:arguments];
}

- (FMResultSet*)executeQueryInTable:(NSString*)aTable columns:(NSArray*)columns where:(NSString*)where parameters:(NSDictionary *)arguments
{
    NSString *SQL = [NSString stringWithFormat:@"SELECT %@ FROM '%@' %@", columns ? [columns componentsJoinedByString:@", "] : @"*", aTable, where ? where : @""];
    return [self executeQuery:SQL withParameterDictionary:arguments];
}

@end

@implementation FMResultSet (Mapping)

- (NSArray*)mapToArrayOfClass:(Class)cls
{
    return [self mapToArrayOfClass:cls propertyMapping:nil];
}

- (NSArray*)mapToArrayOfClass:(Class)cls propertyMapping:(NSDictionary*)propertyMapping
{
    if (propertyMapping == nil) propertyMapping = @{};
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    while ([self next]) {
        
        id object = [[cls alloc] init];
        [result addObject:object];
        
        NSDictionary *columnNameToIndexMap = [self columnNameToIndexMap];
        
        __weak typeof(self) weak_self = self ;
        __weak typeof(propertyMapping) weak_propertyMapping = propertyMapping ;
        __weak typeof(object) weak_object = object ;

        [columnNameToIndexMap enumerateKeysAndObjectsUsingBlock:^(NSString *columnName, NSNumber *index, BOOL *stop) {
            //没有映射，则使用列明作为属性
            __strong typeof(self) self = weak_self ;
            __strong typeof(propertyMapping) propertyMapping = weak_propertyMapping ;
            __strong typeof(object) object = weak_object ;
            
            NSString *mappedPropertyName = propertyMapping[columnName] ? propertyMapping[columnName] : columnName;
            if ([object respondsToSelector:NSSelectorFromString(mappedPropertyName)] && ![@"description" isEqualToString:mappedPropertyName]) {
                id value = self[columnName];
                if (![value isEqual:[NSNull null]]) {
                    [object setValue:value forKey:mappedPropertyName];
                }
            }
        }];
    }
    return result;
}

- (id)mapToObjectOfClass:(Class)cls
{
    return [self mapToObjectOfClass:cls propertyMapping:nil];
}

- (id)mapToObjectOfClass:(Class)cls propertyMapping:(NSDictionary*)propertyMapping
{
    NSArray *result = [self mapToArrayOfClass:cls propertyMapping:propertyMapping];
    NSAssert([result count] <= 1, @"result is not unique, size: %@", @([result count]));
    return [result count] == 1 ? result[0] : nil;
}

@end
