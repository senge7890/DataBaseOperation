//
//  ViewController.m
//  DataBaseOperation
//
//  Created by 键盘上的舞者 on 4/7/16.
//  Copyright © 2016 键盘上的舞者. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Student.h"
#import "FMDB.h"
#import "Person.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (nonatomic, strong) AppDelegate *delegate;

@property (weak, nonatomic) IBOutlet UITextField *updateName;
@property (weak, nonatomic) IBOutlet UITextField *updateWeight;

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - CoreData
- (IBAction)CoreDataBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100:
            //创建数据库
            [_delegate context];
            break;
        case 101:
            //增加一行数据
            [self CoreDataInsert];
            break;
        case 102:
            //修改
            [self CoreDataUpdate];
            break;
        case 103:
            //删除
            [self CoreDataDelete];
            break;
        case 104:
            [self CoreDataQuery];
            break;
        default:
            break;
    }
}

- (void)CoreDataInsert {
    NSString *name = self.nameTextField.text;
    NSString *weight = self.weightTextField.text;
    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_delegate.context];
    stu.name = name;
    stu.weight = weight;
    NSError *error = nil;
    if (![_delegate.context save:&error]) {
        NSLog(@"插入数据错误:%@", error);
    }else {
        NSLog(@"插入一条数据成功.name:%@    weight:%@", name, weight);
    }
}

- (void)CoreDataUpdate {
    NSString *name = self.updateName.text;
    NSString *weight = self.updateWeight.text;
    //先查询后Save
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *array = [_delegate.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
        stu.weight = weight;
    }
    //保存
    NSError *error = nil;
    if ([_delegate.context save:&error]) {
        NSLog(@"修改成功!");
    }
}

- (void)CoreDataDelete {
    //先查询是否存在
    NSString *name = self.updateName.text;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSArray *array = [_delegate.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
        [_delegate.context deleteObject:stu];
    }
    NSError *error = nil;
    if ([_delegate.context save:&error]) {
        NSLog(@"删除成功!");
    }
}

- (void)CoreDataQuery {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    NSArray *array = [_delegate.context executeFetchRequest:request error:nil];
    for (Student *stu in array) {
        NSLog(@"name:%@  ------  weight:%@", stu.name, stu.weight);
    }
}

#pragma mark - FMDB

- (IBAction)FMDBBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 200:
            //创建数据库
            [self FMDBCreate];
            break;
        case 201:
            //插
            [self FMDBInsert];
            break;
        case 202:
            //更新
            [self FMDBUpdate];
            break;
        case 203:
            //删除
            [self FMDBDelete];
            break;
        case 204:
            //查询
            [self FMDBQuery];
            break;
        default:
            break;
    }
}

- (void)FMDBCreate {
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [directory stringByAppendingPathComponent:@"Person.sqlite"];
    //注意：dataWithPath中的路径参数一般会选择保存到沙箱中的Documents目录中；如果这个参数设置为nil则数据库会在内存中创建；如果设置为@””则会在沙箱中的临时目录创建,应用程序关闭则文件删除。
    self.db = [FMDatabase databaseWithPath:path];
    if ([self.db open]) {
        NSLog(@"连接数据库成功!");
    }else {
        NSLog(@"连接数据库失败!");
    }
    //创建一个表
    NSString *sql = @"CREATE TABLE Number(name TEXT, weight TEXT)";
    if ([self.db executeUpdate:sql]) {
        NSLog(@"表创建成功!");
    }
    
    [self.db close];
}

- (void)FMDBInsert {
    NSString *name = self.nameTextField.text;
    NSString *weight = self.weightTextField.text;
    //打开数据库
    if ([self.db open]) {
        if ([self.db executeUpdate:@"INSERT INTO Number VALUES(?, ?)", name, weight]) {
            NSLog(@"插入成功!");
        }
    }
    [self.db close];
}

- (void)FMDBUpdate {
    NSString *name = self.updateName.text;
    NSString *weight = self.updateWeight.text;
    if ([self.db open]) {
        if ([self.db executeUpdate:@"UPDATE Number SET weight = ? WHERE name = ?", weight, name]) {
            NSLog(@"修改成功!");
        }
    }
    [self.db close];
    
}

- (void)FMDBDelete {
    NSString *name = self.updateName.text;
    if ([self.db open]) {
        if ([self.db executeUpdate:@"DELETE FROM Number WHERE name = ?", name]) {
            NSLog(@"删除成功!");
        }
    }
    [self.db close];
}

- (void)FMDBQuery {
    if ([self.db open]) {
        FMResultSet *result = [self.db executeQuery:@"SELECT * FROM Number"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            NSString *weight = [result stringForColumn:@"weight"];
            NSLog(@"name:%@  ------   weight:%@", name, weight);
        }
    }
}

#pragma mark - 使用归档来进行数据存储
#pragma mark 归档
- (IBAction)ArchiverStore {
    Person *person = [[Person alloc] init];
    person.name = self.nameTextField.text;
    person.weight = self.weightTextField.text;
    //归档
    //路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"归档路径:%@",doc);
    NSString *path = [doc stringByAppendingPathComponent:@"person.arc"];
    
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    NSLog(@"归档成功!");
}

#pragma mark 解档
- (IBAction)ArchiverQuery {
    //解档
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingPathComponent:@"person.arc"];
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"解档完成!");
    NSLog(@"name:%@  -----   weight:%@", person.name, person.weight);
}

#pragma mark - NSUserDefault存储
- (IBAction)NSUserDefaultStore {
    NSString *name = self.nameTextField.text;
    NSString *weight = self.weightTextField.text;
    NSUserDefaults *person = [NSUserDefaults standardUserDefaults];
    [person setObject:name forKey:@"name"];
    [person setObject:weight forKey:@"weight"];
    NSLog(@"存储成功!");
}

- (IBAction)NSUserDefaultQuery {
    NSUserDefaults *person = [NSUserDefaults standardUserDefaults];
    NSString *name = [person objectForKey:@"name"];
    NSString *weight = [person objectForKey:@"weight"];
    NSLog(@"name:%@ ------ weight:%@", name, weight);
    NSLog(@"读取完毕!");
}



@end
