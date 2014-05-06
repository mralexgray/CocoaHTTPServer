
#import "SimpleWebSocketServerAppDelegate.h"
//#import "HTTPServer.h"
#import "httpserver/TheAntiServer.h"


@implementation SimpleWebSocketServerAppDelegate
{
TheAntiServer *upgrader;
}

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  upgrader = TheAntiServer.new;

}

@end
