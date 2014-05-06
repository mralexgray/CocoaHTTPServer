
#import <Foundation/Foundation.h>

//typedef struct Action  { Write, Evaluate, Receive};

@interface SomeClient : NSObject

@property (readonly) NSMutableDictionary * info;
- (void) kill;
- (void) eval:(NSString*)msg;

@end

@interface TheAntiServer : NSObject

+ (instancetype) listenOn:(int)port;

@property            NSString * name;
@property (readonly) NSString * address;
@property (readonly)  NSArray * clients;

- (void(^)(SomeClient *x)) hello;
- (void(^)(SomeClient *x)) bye;

//- (void(^)(SomeClient *x, NSString*says) message;

@end

//#define GLOBALEVAL @""
#define HTML @"_\
_\
<!DOCTYPE html><html><head><title>%%WEBSOCKET_URL%%</title>     __\
<script src='http://links.mrgray.com/jq'></script>              __\
<script>                                                       __\
                                                               __\
 $(function() {                                                __\
   if ('WebSocket' in window) {                                __\
     var ws = new WebSocket('%%WEBSOCKET_URL%%')              __\
     ws.onopen = function() {                                  __\
       ws.send('HELLO')__\
    } __\
    ws.onmessage = function(evt) {__\
       console.log(['Remote Running', evt.data])	// eval the remote data (super sketch)__\
       eval(evt.data) __\
     }   // on_MSG    __\
   }     // if_WS     __\
   $('#send').click( function() { ws.send($('#text').val()); })    __\
__\
 });     // docReady__\
</script>__\
</head>__\
<body bgcolor='red'>__\
 <input type='text' id='text'>__\
 <button id='send'>Send</button>__\
</body>__\
</html>"

//#define HTML @"<!DOCTYPE html><html><head><title>%%WEBSOCKET_URL%%</title><script>"
//
//"function WebSocketTest()"
//{ \n__\
//	if (\"WebSocket\" in window) \n__\
//	{ \n__\
//		alert(\"WebSocket supported here!  :)\\r\\n\\r\\nBrowser: \" + navigator.appName + \" \" + navigator.appVersion + \"\\r\\n\\r\\n(based on Google sample code)\"); \n__\
//	} \n__\
//	else \n__\
//	{ \n__\
//		// Browser doesn't support WebSocket \n__\
//		alert(\"WebSocket NOT supported here!  :(\\r\\n\\r\\nBrowser: \" + navigator.appName + \" \" + navigator.appVersion + \"\\r\\n\\r\\n(based on Google sample code)\"); \n__\
//	} \n__\
//} \n__\
//function WebSocketTest2() \n__\
//{ \n__\
//	if (\"WebSocket\" in window) \n__\
//	{ \n__\
//		var ws = new WebSocket(\"%%WEBSOCKET_URL%%\"); \n__\
//		ws.onopen = function() \n__\
//		{ \n__\
//			// Web Socket is connected \n__\
//			alert(\"websocket is open\"); \n__\
//			 __\
//			// You can send data now \n__\
//			ws.send(\"Hey man, you got the time?\"); \n__\
//		}; \n__\
//		ws.onmessage = function(evt) { alert(\"received: \" + evt.data); }; \n__\
//		ws.onclose = function() { alert(\"websocket is closed\"); }; \n__\
//	} \n__\
//	else \n__\
//	{ \n__\
//		alert(\"Browser doesn't support WebSocket!\"); \n__\
//	} \n__\
//} \n__\
//</script> \n__\
//</head> \n__\
//<body bgcolor=\"#FFFFFF\"> \n__\
//<a href=\"javascript:WebSocketTest()\">Does my browser support WebSockets?</a><br/> \n__\
//<br/> \n__\
//<a href=\"javascript:WebSocketTest2()\">Open WebSocket and tell me what time it is.</a> \n__\
//</body> \n__\
//</html>__\
// __\
//"
//
