//
//  DataBaseUtil.m
//  GWG_Project
//
//  Created by Wcg on 16/5/9.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import "DataBaseUtil.h"
static DataBaseUtil *dataBase = nil;

@interface DataBaseUtil ()

@property(nonatomic,strong)FMDatabase *db;

@end


@implementation DataBaseUtil
+(DataBaseUtil *)shareDataBase{
    if (dataBase == nil) {
        dataBase = [[DataBaseUtil alloc]init];
    }
    return dataBase;
}
-(id)init{
    self = [super init];
    if (self) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"GWG.sqlite"];
        _db = [FMDatabase databaseWithPath:filePath];
    }
    return self;
}
#pragma -mark 建表
-(BOOL)creatReadingTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists reading (id integer primary key autoincrement, title text , thumbnail text, share text)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)createTechnologyTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists technology (id integer primary key autoincrement, title text, pic_url text, aid text)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)createDataDetailModelTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists radio (id integer primary key autoincrement, title text, cover_url text, sound_url text)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)createMovieModelTable{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"create table if not exists movie (id integer primary key autoincrement, title text, link text)"];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}

#pragma -mark 添加数据
-(BOOL)insertObjectOfReading:(Reading *)reading{
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into reading (title, thumbnail, share) values ('%@','%@','%@')",reading.title,reading.thumbnail,reading.share];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
    
}
-(BOOL)insertObjectOfTech:(Technology *)technology{
    if ([_db open]) {
        NSInteger st = technology.aid;
        NSString * str = [NSString stringWithFormat:@"%ld",st];
        NSString * sql = [NSString stringWithFormat:@"insert into technology (title, pic_url, aid) values ('%@','%@','%@')",technology.title,technology.pic_url,str];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)insertObjectOfRadio:(DataDetailModel *)radio{
    return nil;
}
-(BOOL)insertObjectOfMovie:(MovieModel *)radio{	
    return nil;
}
#pragma  -mark 查询数据
-(NSArray *)selectReadingTable{
    NSMutableArray *array = [NSMutableArray array];
    if ([_db open]) {
        NSString *sql = [NSString stringWithFormat:@"select * from reading"];
        FMResultSet *set = [_db executeQuery:sql];
        while ([set next]) {
            NSString *title = [set stringForColumn:@"title"];
            NSString *thumbnail = [set stringForColumn:@"thumbnail"];
            NSString *share = [set stringForColumn:@"share"];
            
            Reading * read = [[Reading alloc]init];
            read.title = title;
            read.thumbnail = thumbnail;
            read.share = share;
            [array addObject:read];
            
        }
        [_db close];
        return array;
    }
    return array;

}
-(NSArray *)selectTechnologyTable{
        NSMutableArray *array = [NSMutableArray array];
        if ([_db open]) {
            NSString *sql = [NSString stringWithFormat:@"select * from technology"];
            FMResultSet *set = [_db executeQuery:sql];
            while ([set next]) {
                NSString *title = [set stringForColumn:@"title"];
                NSString *pic_url = [set stringForColumn:@"pic_url"];
                NSString * aid = [set stringForColumn:@"aid"];
               Technology * tec = [[Technology alloc]init];
                tec.title = title;
                tec.pic_url = pic_url;
                tec.aid = [aid integerValue];
                [array addObject:tec];
    
            }
            [_db close];
            return array;
        }
        return array;
}
-(NSArray *)selectRadioTable{
return nil;}
-(NSArray *)selectMovieTable{
return nil;}


#pragma  -mark 删除数据
-(BOOL)deleteDataWithTableName:(NSString *)tableName{
    if ([_db open]) {
        NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM '%@'",tableName];
        BOOL result = [_db executeUpdate:sqlstr];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)deleteReadingWithName:(NSString *)title{
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from reading where title = '%@'",title];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}
-(BOOL)deleteTeconologyWithName:(NSString *)title
{
    if ([_db open]) {
        NSString * sql = [NSString stringWithFormat:@"delete from technology where title = '%@'",title];
        BOOL result = [_db executeUpdate:sql];
        [_db close];
        return result;
    }
    return NO;
}

@end
