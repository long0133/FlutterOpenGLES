#import "OpenglTexturePlugin.h"
#import "OpenGLRender.h"
#import "SampleRenderWorker.h"

@interface OpenglTexturePlugin()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, OpenGLRender *> *renders;
@property (nonatomic, strong) NSObject<FlutterTextureRegistry> *textures;
@property (nonatomic, strong) SampleRenderWorker *worker;
@end

@implementation OpenglTexturePlugin

- (instancetype)initWithTextures:(NSObject<FlutterTextureRegistry> *)textures {
    self = [super init];
    if (self) {
        _renders = [[NSMutableDictionary alloc] init];
        _textures = textures;
    }
    return self;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"opengl_texture"
                                     binaryMessenger:[registrar messenger]];
    OpenglTexturePlugin* instance = [[OpenglTexturePlugin alloc] initWithTextures:[registrar textures]];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"newTexture" isEqualToString:call.method]) {
        CGFloat width = [call.arguments[@"width"] floatValue];
        CGFloat height = [call.arguments[@"height"] floatValue];
        
        int64_t __block textureId;
        id<FlutterTextureRegistry> __weak registry = self.textures;
        _worker = [[SampleRenderWorker alloc] init];
        
        OpenGLRender *render = [[OpenGLRender alloc] initWithSize:CGSizeMake(width, height)
                                                           worker:_worker
                                                       onNewFrame:^{
                                                           [registry textureFrameAvailable:textureId];
                                                       }];
        
        textureId = [self.textures registerTexture:render];
        self.renders[@(textureId)] = render;
        result(@(textureId));
    } else if ([@"dispose" isEqualToString:call.method]) {
        NSNumber *textureId = call.arguments[@"textureId"];
        OpenGLRender *render = self.renders[textureId];
        [render dispose];
        [self.renders removeObjectForKey:textureId];
        result(nil);
    } else if([@"dragUpdate" isEqualToString:call.method]){
        
        CGFloat dx = [call.arguments[@"x"] floatValue];
        CGFloat dy = [call.arguments[@"y"] floatValue];
        [_worker updateDragPoint:CGPointMake(dx, dy)];
        
    }else{
        result(FlutterMethodNotImplemented);
    }
}

@end
