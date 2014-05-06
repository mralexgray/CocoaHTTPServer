


#import <Foundation/Foundation.h>
#import "WebSocket.h"
#import "HTTPServer.h"
#import "HTTPMessage.h"
#import "HTTPConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPDynamicFileResponse.h"
#import "GCDAsyncSocket.h"
#import "HTTPLogging.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "TheAntiServer.h"


static const int ddLogLevel = LOG_LEVEL_VERBOSE; // Log levels: off, error, warn, info, verbose
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;

//void loadDummy(){ return; }

// Log levels: off, error, warn, info, verbose
// Other flags: trace


@interface MyWebSocket : WebSocket @end

@interface MyHTTPConnection : HTTPConnection @end

@implementation TheAntiServer
{
  HTTPServer *httpServer;
  MyHTTPConnection *connection;
}

- (id) init
{

  if (!(self = super.init)) return nil;
	// Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Create server using our custom MyHTTPServer class
	httpServer = [[HTTPServer alloc] init];
	
	// Tell server to use our custom MyHTTPConnection class.
	[httpServer setConnectionClass:[MyHTTPConnection class]];
	
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
	// [httpServer setPort:12345];
	
	// Serve files from our embedded Web folder
//	NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
//	DDLogInfo(@"Setting document root: %@", webPath);

//	[httpServer setDocumentRoot:webPath];

	// Start the server (and check for problems)
	
	NSError *error;
	if(![httpServer start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
  return self;
}
@end

@implementation MyHTTPConnection
{
    NSMutableArray *socks;
//	MyWebSocket *ws;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	HTTPLogTrace();

//	if ([path isEqualToString:@"/WebSocketTest2.js"])
//	{
		// The socket.js file contains a URL template that needs to be completed:
		// 
		// ws = new WebSocket("%%WEBSOCKET_URL%%");
		// 
		// We need to replace "%%WEBSOCKET_URL%%" with whatever URL the server is running on.
		// We can accomplish this easily with the HTTPDynamicFileResponse class,
		// which takes a dictionary of replacement key-value pairs,
		// and performs replacements on the fly as it uploads the file.
		

		
		NSString *wsHost = [request headerField:@"Host"];

//		return [[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:path]
//		                                            forConnection:self
//		                                                separator:@"%%"
//                                        replacementDictionary:@{@"WEBSOCKET_URL":
//    [NSString stringWithFormat:wsHost ? @"ws://localhost:%@/service" : @"ws://%@/service",
//                               wsHost ?  @(asyncSocket.localPort) : wsHost]}];
//  }

	return [HTTPDataResponse.alloc initWithData:[[[HTML

stringByReplacingOccurrencesOfString:@"%%WEBSOCKET_URL%%" withString:
    [NSString stringWithFormat:wsHost ? @"ws://localhost:%@/eval" : @"ws://%@/eval",
                               wsHost ?  @(asyncSocket.localPort) : wsHost]]
stringByReplacingOccurrencesOfString:@"__" withString:@"\n\n"]

  dataUsingEncoding:NSUTF8StringEncoding]];
  // httpResponseForMethod:method URI:path];
}

- (WebSocket *)webSocketForURI:(NSString *)path
{
//	HTTPLogTrace2(@"%@[%p]: webSocketForURI: %@", THIS_FILE, self, path);

	if([path isEqualToString:@"/eval"])
	{
//		HTTPLogInfo(@"MyHTTPConnection: Creating MyWebSocket...");

		id x = [[MyWebSocket alloc] initWithRequest:request socket:asyncSocket];
    if (x) [socks = socks ?: NSMutableArray.new addObject:x];
    return x;
	}
	
	return [super webSocketForURI:path];
}

@end

//#import "MyWebSocket.h"
//#import "HTTPLogging.h"

// Log levels: off, error, warn, info, verbose
// Other flags : trace
//static const int httpLogLevel = HTTP_LOG_LEVEL_WARN | HTTP_LOG_FLAG_TRACE;


@implementation MyWebSocket

- (void)didOpen
{
//	HTTPLogTrace();

	[super didOpen];
	
	[self sendMessage:@"Welcome to my WebSocket"];
  NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)didReceiveMessage:(NSString *)msg
{
//	HTTPLogTrace2(@"%@[%p]: didReceiveMessage: %@", THIS_FILE, self, msg);

	[self sendMessage:@"$('body').css('background-color','blue')"];
//   [NSString stringWithFormat:@"%@", [NSDate date]]];
  NSLog(@"%@  = %@", NSStringFromSelector(_cmd), msg);
  [super didReceiveMessage:msg];
}

- (void)didClose
{
//	HTTPLogTrace();

	[super didClose];
}

@end
