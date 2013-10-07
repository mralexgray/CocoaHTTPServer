#import "MyWebSocket.h"
//#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags : trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;


@implementation MyWebSocket

- (void)didOpen
{
	HTTPLogTrace();
	
	[super didOpen];
	
	[self sendMessage:@"Welcome to my WebSocket"];
}

- (void)didReceiveMessage:(NSString *)msg
{
	HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
	
	[self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
}

- (void)didClose
{
	HTTPLogTrace();
	
	[super didClose];
}

@end


//#import "MyWebSocket.h"
////#import "HTTPLogging.h"
//
//// Log levels: off, error, warn, info, verbose
//// Other flags : trace
//static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;
//
//@implementation MyWebSocket
//@synthesize timer;
//- (id)initWithRequest:(HTTPMessage *)req socket:(GCDAsyncSocket *)sock
//{
//		NSLog(@"%@", NSStringFromSelector(_cmd));
//		if (!(self = [super initWithRequest:req socket:sock]))  return nil;
//		timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                              target:self 
//                                            selector:@selector(timerFired)
//                                            userInfo:nil 
//                                             repeats:YES];
//		[timer fire];
//    return self;
//}
//- (void)timerFired {  NSLog(@"%@", NSStringFromSelector(_cmd));	[self sendMessage:@"VAGEEN!"]; }
//
//- (void)didOpen	{	NSLog(@"%@", timer); HTTPLogTrace();	[super didOpen];	[self sendMessage:@"Welcome to my WebSocket"]; }
//
//- (void)didReceiveMessage:(NSString *)msg
//{
//	HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);
//	[self sendMessage:[NSString stringWithFormat:@"%@", [NSDate date]]];
//}
//
//- (void)didClose {	HTTPLogTrace();	[super didClose]; }
//
//@end
