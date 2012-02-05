#import "DDData.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (DDData)

static char encodingTable[64] = {
'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

static int8_t kDecodingTable[256];

- (NSData *)md5Digest
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)sha1Digest
{
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
    
	CC_SHA1([self bytes], (CC_LONG)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)hexStringValue
{
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([self length] * 2)];
	
    const unsigned char *dataBuffer = [self bytes];
    NSUInteger i;
    
    for (i = 0; i < [self length]; ++i)
	{
        [stringBuffer appendFormat:@"%02x", (unsigned long)dataBuffer[i]];
	}
    
    return [[stringBuffer copy] autorelease];
}

- (NSString *)base64Encoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES )
	{
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining )
		{
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

- (NSData *)base64Decoded
{
	const char *string = [self bytes];
	NSUInteger inputLength = [self length];
	NSUInteger outputLength = inputLength * 3 / 4;
    NSMutableData* data = [NSMutableData dataWithLength:outputLength];
    uint8_t* output = data.mutableBytes;
    
    NSUInteger inputPoint = 0;
    NSUInteger outputPoint = 0;
    while (inputPoint < inputLength) {
        uint8_t i0 = string[inputPoint++];
        uint8_t i1 = string[inputPoint++];
        uint8_t i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
        uint8_t i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
        
        if (kDecodingTable[i0] < 0 || kDecodingTable[i1] < 0 
			|| kDecodingTable[i2] < 0 || kDecodingTable[i3] < 0)
            return nil;
		
        output[outputPoint++] = (kDecodingTable[i0] << 2) | (kDecodingTable[i1] >> 4);
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((kDecodingTable[i1] & 0xf) << 4) | (kDecodingTable[i2] >> 2);
        }
        if (outputPoint < outputLength) {
            output[outputPoint++] = ((kDecodingTable[i2] & 0x3) << 6) | kDecodingTable[i3];
        }
    }
    
    return data;
	
}

@end
