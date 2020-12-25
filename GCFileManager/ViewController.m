//
//  ViewController.m
//  GCFileManager
//
//  Created by Geeks_Chen on 2020/12/25.
//  Copyright © 2020 zezf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //创建文件夹
    if ([self creatFileFolderWithDirName:@"test"]) {
        //获取文件夹路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self getDocumentPath],@"test"];
        //保存图片
        BOOL res = [self saveImage:[UIImage imageNamed:@"banner_1"] withFilePath:filePath withFileName:@"3.jpg"];
        if (res) {
            //读取图片路径
            NSString *filePath2 = [NSString stringWithFormat:@"%@/%@",filePath,@"3.jpg"];
            //计算文件大小
            CGFloat size = [self calculateSizeOfPath:filePath2];
            NSLog(@"%lf",size);
        }else{
            NSLog(@"图片保存失败");
        }
    }
    
}

#pragma mark -- 获取沙盒路径
-(NSString*)getDocumentPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDirectory);
    return documentsDirectory;
}

#pragma mark -- 创建文件夹
- (BOOL)creatFileFolderWithDirName:(NSString *)dirName {

    NSString *documentsPath =[self getDocumentPath];
    NSString * testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    return [[NSFileManager defaultManager] createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
}

#pragma mark -- 保存图片
- (BOOL)saveImage:(UIImage *)image withFilePath:(NSString *)filePath withFileName:(NSString *)fileName{
    
    NSData *data = UIImageJPEGRepresentation(image ,0.5);
    NSString *filePath2 = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
    
    return [[NSFileManager defaultManager] createFileAtPath:filePath2 contents:data attributes:nil];
}

#pragma mark -- 读取图片
- (void)readImageWithFilePath:(NSString *)filePath {
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 500)];
    imgView.image = image;
    [self.view addSubview:imgView];
}

#pragma mark -- 移动文件
- (BOOL)moveImageFromFileName:(NSString *)fromFileName toFileName:(NSString *)toFileName {

    return [[NSFileManager defaultManager] moveItemAtPath:fromFileName toPath:toFileName error:nil];
}

#pragma mark -- 删除文件
- (BOOL )removeImageWithFilePath:(NSString *)filePath{
    
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}


#pragma mark -- 获取文件或者文件夹大小(单位：kb)
- (CGFloat )calculateSizeOfPath:(NSString *)path {
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    unsigned long long fileSize = 0;
    // directory
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
        while (enumerator.nextObject) {
           // 下面注释掉的代码作用：不递归遍历子文件夹
           // if ([enumerator.fileAttributes.fileType isEqualToString:NSFileTypeDirectory]) {
           //      [enumerator skipDescendants];
           // }
            fileSize += enumerator.fileAttributes.fileSize;
        }
    } else {
        // file
        fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    }
    return fileSize/1000.;
}

#pragma mark -- 获取文件数量
- (NSInteger )calculateCountOfPath:(NSString *)path {

    BOOL isDir = YES;
    NSInteger count = 0;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    };
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
        count = enumerator.allObjects.count;
    } else {
        count = 1;
    }
    return count;
}

@end
