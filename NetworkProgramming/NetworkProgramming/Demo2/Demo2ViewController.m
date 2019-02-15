//
//  Demo2ViewController.m
//  NetworkProgramming
//
//  Created by 帅斌 on 2019/2/15.
//  Copyright © 2019年 dongming. All rights reserved.
//

#import "Demo2ViewController.h"
#import <AFNetworking.h>

#define kcBaseUrl   @"http://192.168.31.19:8080/"
#define kcGetUrl    [NSString stringWithFormat:@"%@getMethod?",kcBaseUrl]
#define kcPostUrl   [NSString stringWithFormat:@"%@postMethod/",kcBaseUrl]
#define kcUploadUrl [NSString stringWithFormat:@"%@uploadfile/",kcBaseUrl]
@interface Demo2ViewController ()

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self upload];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self afUpload];
}


- (void)getMethod{
    //如果字符串里面含有中文要进行转码
    NSString *urlStr = [NSString stringWithFormat:@"%@username=酷C",kcGetUrl];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *str = [urlStr stringByRemovingPercentEncoding];
    NSLog(@"%@",str);
    //1、确定URL
    NSURL *url = [NSURL URLWithString:urlStr];
    //2、确定请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求方式
    request.HTTPMethod = @"GET";
    //如果字符串里面含有中文要进行转码
    //    //请求体
    //    NSString *param = [NSString stringWithFormat:@"username=%@",@"Cooci"];
    //    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    //3、发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
}

- (void)postMethod{
    
    //1、确定URL
    NSURL *url = [NSURL URLWithString:kcPostUrl];
    //2、确定请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求方式
    request.HTTPMethod = @"POST";
    //请求体
    NSString *param = [NSString stringWithFormat:@"username=%@",@"Cooci"];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    //3、发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
}


- (void)upload{
    //1、确定URL
    NSURL *url = [NSURL URLWithString:kcUploadUrl];
    //2、确定请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //请求方式
    request.HTTPMethod = @"POST";
    //请求体
    [self dealwithData:request];
    //3、发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}


- (void)afUpload{
    
    NSArray * _imageArr = @[@"1"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/plain",@"multipart/form-data",@"application/json"]];
    [manager POST:kcUploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i=0; i<_imageArr.count; i++) {
            
            //压缩取名字
            //            UIImage * image =[UIImage  imageNamed:_imageArr[i]];
            //            NSDate *date = [NSDate date];
            //            NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
            //            [formormat setDateFormat:@"HHmmss"];
            //            NSString *dateString = [formormat stringFromDate:date];
            //
            //            NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
            //            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            //            double scaleNum = (double)300*1024/imageData.length;
            //            NSLog(@"图片压缩率：%f",scaleNum);
            //            if(scaleNum <1){
            //                imageData = UIImageJPEGRepresentation(image, scaleNum);
            //            }else{
            //                imageData = UIImageJPEGRepresentation(image, 0.1);
            //            }
            
            UIImage *image = [UIImage imageNamed:@"01.png"];
            NSData *imageData = UIImagePNGRepresentation(image);
            [formData  appendPartWithFileData:imageData name:@"fileName" fileName:@"01.png" mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"`````````%@",responseObject);
        NSDictionary *datas = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"请求成功%@",datas);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"NSError === %@",error);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealwithData:(NSMutableURLRequest *)request{
    /******************************************************************/
    //                          设置请求头
    [request setValue:@"multipart/form-data; boundary=----KCBoundary" forHTTPHeaderField:@"Content-Type"];
    
    /******************************************************************/
    //                          设置请求体
    // 设置请求体
    // 给请求体加入固定格式数据  这里也是使用的也是可变的，因为多嘛
    NSMutableData *data = [NSMutableData data];
    /******************************************************************/
    //                       开始标记
    [data appendData:[@"------KCBoundary" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"fileName\"; filename=\"01.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Type: image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                      上传文件参数
    //图片数据  并且转换为Data
    UIImage *image = [UIImage imageNamed:@"01.png"];
    NSData *imagedata = UIImagePNGRepresentation(image);
    [data appendData:imagedata];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                       非文件参数
    [data appendData:[@"------KCBoundary" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"Content-Disposition: form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"001" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    //                      添加结束标记
    // KCBoundary
    [data appendData:[@"------KCBoundary--" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************************************************************/
    
    request.HTTPBody = data;
}


@end
