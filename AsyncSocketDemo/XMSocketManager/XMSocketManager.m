//
//  Singleton.h
//  socket_tutorial
//
//  Created by 王续敏 on 16-3-12.
//  Copyright (c) 2016年 王续敏. All rights reserved.


#import "XMSocketManager.h"

#import "Appdelegate.h"

@interface XMSocketManager()<AsyncSocketDelegate>

@end

@implementation XMSocketManager
{
    NSMutableData *tempData;
    AppDelegate *appdelegate;
}

+(XMSocketManager *) sharedInstance
{
    
    static XMSocketManager *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstace = [[XMSocketManager alloc] init];
    });
    
    return sharedInstace;
}


// socket连接
-(void)socketConnectHost{
    
     @try {
        self.isAcceptData = NO;//初始化默认为NO
        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *error = nil;
        [self.socket connectToHost:self.socketHost onPort:self.socketPort withTimeout:3 error:&error];
         if (error) {
             NSLog(@"连接超时%@",error);
         }
    } @catch (NSException *exception) {
        
        NSLog(@"====%@",exception);
        
    } @finally {
        
    }

}
/**
 *  连接错误的代理方法
 *
 *  @param sock socket
 *  @param err  错误原因
 */
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"=====%@",err);
}
// 连接成功回调
#pragma mark  - 连接成功回调
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket连接成功");
    [sock readDataWithTimeout:-1 tag:1];
    self.connectState = YES;
    [self.connectTimer setFireDate:[NSDate distantPast]];//开启定时器
    if (self.delegate && [self.delegate respondsToSelector:@selector(socketConnectState:)]) {
        [self.delegate socketConnectState:YES];
    }
}

/**
 *  心跳
 *
 *  @param mobileID 手机ID
 *  @param watchID  当前的手表ID
 */
-(void)startConnectToSocketWithMobileID:(UInt64)mobileID WatchID:(UInt64)watchID
{
    _mobileID = mobileID;
    _watchID = watchID;
    
    if (!_connectTimer) {
        self.connectTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    }
}

/**
 *  发送心跳包
 */
-(void)longConnectToSocket
{
    // 根据服务器要求发送固定格式的数据，假设为指令@"longConnect"，但是一般不会是这么简单的指令
    Watch * watch;
    Mobile * moblie;
    if (appdelegate.protocols.mobile.id && appdelegate.protocols.watch.id) {
        watch = [[[Watch builder] setId:appdelegate.protocols.watch.id] build];
        moblie = [[[Mobile builder] setId:appdelegate.protocols.mobile.id] build];
    }else{
        watch = [[[Watch builder] setId:_watchID] build];
        moblie = [[[Mobile builder] setId:_mobileID] build];
    }
    Protocols * proto = [[[[Protocols builder] setWatch:watch] setMobile:moblie] build];
    [self writeDataToServerWith:proto];
    
}

/**
 *  字节序
 *
 *  @param protcos proto
 *
 *  @return data
 */
- (NSMutableData *)byteOrderWithProtobuf:(Protocols *)protcos{
    
    NSData *data = [protcos data];
    NSUInteger length = [data length];
    Byte result[4];
    result[0] = (Byte) ((length >> 24)&0xff);
    result[1] = (Byte) ((length >> 16)&0xff);
    result[2] = (Byte) ((length >> 8)&0xff);
    result[3] = (Byte) (length&0xff);
    NSMutableData * orderData = [NSMutableData dataWithBytes:result length:4];
    [orderData appendData:data];
    return orderData;
}

/**
 *  发送数据包
 *
 *  @param protcos protocol
 */
- (void)writeDataToServerWith:(Protocols *)protcos
{
    @try {
        [self.socket writeData:[self byteOrderWithProtobuf:protcos] withTimeout:-1 tag:1];  // 发送数据
        [self.socket readDataWithTimeout:-1 tag:1];  // 接收数据
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    } @finally {
    }
}
/**
 *  手动断开连接
 */
-(void)cutOffSocket{
    
    [self.socket setDelegate:nil];
    
    self.socket.userData = SocketOfflineByUser;
    
    [self.connectTimer setFireDate:[NSDate distantFuture]];//关闭定时器
    
    [self.socket disconnect];
    self.socket = nil;
}

/**
 *  断开连接的回调
 *
 *  @param sock socket
 */
-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"sorry the connect is failure %ld",sock.userData);

    if ([self.socket isConnected]==NO) {
        self.connectState = NO;
        [self cutOffSocket];
    }
    
    [self socketConnectHost];

    if (self.delegate && [self.delegate respondsToSelector:@selector(socketConnectState:)]) {
        [self.delegate socketConnectState:NO];
    }
    
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag: 1];
    NSLog(@"thread(%@),onSocket:%p didWriteDataWithTag:%ld",[[NSThread currentThread] name],
          sock,tag);
}


/**
 收到数据回调

 @param sock socket
 @param data data
 @param tag  tag
 */
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    @try {
        self.isAcceptData = YES;//接收到服务器返回的数据
        [self analysisDataWith:data];
    } @catch (NSException *exception) {
        
        NSLog(@"读取数据失败");
        @try {
            [self cutOffSocket];
            [self socketConnectHost];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } @finally {
        
       
        
    }
    
    
}
/**
 *接收的数据在这里解析
 */
- (void)analysisDataWith:(NSData *)data{
    
    NSInteger n = 1;//循环次数
    NSData *data2;
    NSData *data1;
    NSLog(@"tempData初始大小===%lu====",(unsigned long)tempData.length);
    if (tempData.length > 0) {
        [tempData appendData:data];
        data = [NSData dataWithData:tempData];
    }
    for (int i = 0; i < n; i++) {
        if (data.length > 4) {
            data2 = [data subdataWithRange:NSMakeRange(0, 4)];
            Byte *bytes = (Byte *)[data2 bytes];
            int num = (bytes[0]<<24) + (bytes[1]<<16) + (bytes[2]<<8) + bytes[3];
            if (data.length >=(num + 4)) {
                data1 = [data subdataWithRange:NSMakeRange(4, num)];
                Protocols * proto = [Protocols parseFromData:data1];
                if (self.delegate && [self.delegate respondsToSelector:@selector(sendDataToViewcontroller:)]) {
                    [self.delegate sendDataToViewcontroller:proto];
                }
                data = [data subdataWithRange:NSMakeRange(num + 4, data.length - num - 4 )];
                n++;
            }else{
                n = 0;
                tempData = [NSMutableData dataWithData:data];
            }
        }else{
            tempData = [NSMutableData dataWithData:data];
        }
    }
    
    NSLog(@"tempData剩余大小%lu",(unsigned long)tempData.length);
    
}



@end
