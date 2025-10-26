//
//  NotificationService.m
//  AppServiceDemo
//
//  Created by Buck on 2025/10/13.
//

#import "NotificationService.h"
#import "MTNotificationExtensionService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [NotificationService]", self.bestAttemptContent.title];

    NSString * attachmentPath = self.bestAttemptContent.userInfo[@"my-attachment"];

    //if exist
    if (attachmentPath) {
        //download
        NSURL *fileURL = [NSURL URLWithString:attachmentPath];
        [self downloadAndSave:fileURL handler:^(NSString *localPath) {
            if (localPath) {
                UNNotificationAttachment * attachment = [UNNotificationAttachment attachmentWithIdentifier:@"myAttachment" URL:[NSURL fileURLWithPath:localPath] options:nil error:nil];
                self.bestAttemptContent.attachments = @[attachment];
            }
            [self apnsDeliverWith:request];
        }];
    }else{
        [self apnsDeliverWith:request];
    }
}

- (void)downloadAndSave:(NSURL *)fileURL handler:(void (^)(NSString *))handler {

    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:fileURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *localPath = nil;
        if (!error) {
            NSString * localURL = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(),fileURL.lastPathComponent];
            if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:localURL error:nil]) {
                localPath = localURL;
            }
        }
        handler(localPath);
    }];
    [task resume];

}

- (void)apnsDeliverWith:(UNNotificationRequest *)request {

    //please invoke this func on release version
    //[MTPushNotificationExtensionService setLogOff];

    //service extension sdk
    //upload to calculate delivery rate
    [MTNotificationExtensionService mtpushSetAppkey:@"1cd183036b7b27dc2f241676"];
    [MTNotificationExtensionService mtpushReceiveNotificationRequest:request with:^ {
        NSLog(@"apns upload success");
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
