//
//  HotUpdataManage.m
//  hotUpdataDemo
//
//  Created by joker on 2017/9/7.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HotUpdataManage.h"
#import "MXHZIPArchive.h"
#import "DiffPatch.h"


#define HOT_MAIN_DOC_PATH [NSString stringWithFormat:@"%@/HOTSDK/main",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]]
#define HOT_JS_PATH [NSString stringWithFormat:@"%@/HOTSDK/main/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0],@"main.jsbundle"]

@implementation HotUpdataManage

+ (HotUpdataManage*)getInstance{
  static HotUpdataManage *manager;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[HotUpdataManage alloc] init];
  });
  return manager;
}

#pragma mark 获取bridge
- (NSURL*)getBridge{
  NSFileManager *fileManager =[NSFileManager defaultManager];
  if (![fileManager fileExistsAtPath:HOT_JS_PATH]) {
    NSString* zipPatch = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"zip"];
    NSLog(@"zipPatch ---> %@",zipPatch);
    if([fileManager fileExistsAtPath:zipPatch]){
      BOOL isReload = [self unzipBundleAndReload:zipPatch];
      //复制jsbundle文件和assest文件到到对应目录
      if (isReload) {
        return [NSURL URLWithString:HOT_JS_PATH];
      }
    }
  }
  return [NSURL URLWithString:HOT_JS_PATH];
}

#pragma mark 检查更新
- (void)checkUpdate:(NSString*)urlStr{
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:nil
                                                       error:nil];
    if (data){
      NSDictionary *resultInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
      if ([resultInfo[@"isUpdate"] boolValue]) {
        [self downLoadFile:[resultInfo objectForKey:@"updataUrl"]];
      }
    }
}

#pragma mark 下载
- (void)downLoadFile:(NSString *)urlString{
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
  [request setHTTPMethod: @"GET"];
  NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
  if (data){
    NSLog(@"diff下载成功");
    NSString *pacthPath = [self getFilePath:@"diff.patch"];
    if ([data writeToFile:pacthPath atomically:YES]) {
      [self patchBundle:pacthPath];
    }else{
      NSLog(@"diff保存失败.");
    }
  }
  else {
    NSLog(@"diff下载失败");
  }
}

- (void)patchBundle:(NSString*)pacthPath{
  NSString* zipPatch = [[NSBundle mainBundle] pathForResource:@"bundle" ofType:@"zip"];
  NSString* tmpZipPath = [NSString stringWithFormat:@"%@/tmp.zip",HOT_MAIN_DOC_PATH];
  //  创建最新jsbundel文件
  BOOL writeBundel =   [DiffPatch beginPatch:pacthPath origin:zipPatch toDestination:tmpZipPath];
  if (!writeBundel) {
    NSLog(@"bundel写入失败");
    return;
  }
  if ([self unzipBundleAndReload:tmpZipPath]) {
    [self reloadNow];
  }
  NSLog(@"更新成功");
}

#pragma mark 解压
-(BOOL)unzipBundleAndReload:(NSString*)zipPath{
  //获取zipPath
  NSError *error;
  NSString *reload_zipPath = zipPath;
  NSString *desPath = HOT_MAIN_DOC_PATH;
  BOOL pathExist = [[NSFileManager defaultManager] fileExistsAtPath:desPath];
  if(!pathExist){
    [[NSFileManager defaultManager] createDirectoryAtPath:desPath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  //  NSLog(@"start unzip zip Path:%@",reload_zipPath);
  [MXHZIPArchive unzipFileAtPath:reload_zipPath toDestination:desPath overwrite:YES password:nil error:&error];
  if(!error){
    NSLog(@"解压成功,路径:%@",desPath);
    return true;
  }else{
    NSLog(@"解压失败,路径:%@，错误原因:%@",desPath,[error description]);
    return false;
  }
}

#pragma mark 重新加载
-(void)reloadNow{
  [self.bridge reload];
  NSLog(@"Bridge reload");
}

- (NSString*)getFilePath:(NSString*)fileName{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory =[paths objectAtIndex:0];
  NSString *filePath =[documentsDirectory stringByAppendingPathComponent:fileName];
  return filePath;
}

@end
