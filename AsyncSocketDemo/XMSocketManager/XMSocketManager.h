//
//  Singleton.h
//  socket_tutorial
//
//  Created by 王续敏 on 16-3-12.
//  Copyright (c) 2016年 王续敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import <UIKit/UIKit.h>
#import "SmartWatch.pb.h"
enum{
    SocketOfflineByServer,
    SocketOfflineByUser,
};

@protocol ProtocolsDelegate <NSObject>

/**
 *  发送数据到控制器,单例方法，runloop时，只能有一处在使用这个方法，然后处理全局的数据
 *
 *  @param protocols 数据包
 */
- (void)sendDataToViewcontroller:(Protocols *)protocols;

@optional
/**
 *  socket的连接状态
 *
 *  @param connectState yes 连接 / no  未连接
 */
- (void)socketConnectState:(BOOL)connectState;


@end

@interface XMSocketManager : NSObject

{
   @public UInt64 _mobileID;
   @public UInt64 _watchID;
    NSString *UUID;
}
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) AsyncSocket    *socket;       // socket
@property (nonatomic, copy  ) NSString       *socketHost;   // socket的Host
@property (nonatomic, assign) UInt16         socketPort;    // socket的prot
@property (nonatomic, retain) NSTimer        *connectTimer; // 计时器
@property (nonatomic, retain) NSData * sourceData;
@property (nonatomic, assign) BOOL connectState;//socket连接状态
@property (nonatomic, assign) BOOL isAcceptData;//是否接受到服务器回调的信息


+ (XMSocketManager *)sharedInstance;

/**
 *socket连接
 */
- (void)socketConnectHost;

/**
 *断开socket连接
 */
- (void)cutOffSocket;

/**
 *@author 王续敏, 16-03-22 09:52:40
 *@param protcols  protocol
 *传入参数 完成发送数据
 */
- (void)writeDataToServerWith:(Protocols *)protcols;

/**
 *@author 王续敏, 16-03-22 09:52:40
 *@param protcos  protocol
 *字节序
 */
- (NSMutableData *)byteOrderWithProtobuf:(Protocols *)protcos;
/**
 *  开始心跳
 *
 *  @param mobileID 手机ID
 *  @param watchID  当前手表的ID
 */
-(void)startConnectToSocketWithMobileID:(UInt64)mobileID WatchID:(UInt64)watchID;


@end
