#import <Cocoa/Cocoa.h>

@class HTTPServer;


@interface SimpleWebSocketServerAppDelegate : NSObject <NSApplicationDelegate>

@property (strong)	HTTPServer *httpServer;
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet WebView *webView;

@end
