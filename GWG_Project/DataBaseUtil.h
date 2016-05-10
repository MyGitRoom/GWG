//
//  DataBaseUtil.h
//  GWG_Project
//
//  Created by Wcg on 16/5/9.
//  Copyright © 2016年 关振发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "Reading.h"
#import "Technology.h"
#import "DataDetailModel.h"
#import "MovieModel.h"
@interface DataBaseUtil : NSObject
+(DataBaseUtil *)shareDataBase;
-(BOOL)creatReadingTable;
-(BOOL)createTechnologyTable;
-(BOOL)createDataDetailModelTable;
-(BOOL)createMovieModelTable;
-(BOOL)insertObjectOfReading:(Reading *)reading;
-(BOOL)insertObjectOfTech:(Technology *)technology;
-(BOOL)insertObjectOfRadio:(DataDetailModel *)radio;
-(BOOL)insertObjectOfMovie:(MovieModel *)radio;
-(NSArray *)selectReadingTable;
-(NSArray *)selectTechnologyTable;
-(NSArray *)selectRadioTable;
-(NSArray *)selectMovieTable;
-(BOOL)deleteDataWithTableName:(NSString *)tableName;
-(BOOL)deleteReadingWithName:(NSString *)title;
-(BOOL)deleteTeconologyWithName:(NSString *)title;





@end
