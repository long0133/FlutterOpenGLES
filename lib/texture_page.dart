import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TexturePage extends StatefulWidget {
  @override
  _TexturePageState createState() => _TexturePageState();
}

class _TexturePageState extends State<TexturePage> {

  MethodChannel _channel = MethodChannel('opengl_texture');

  bool hasLoadTexture = false;
  int mainTexture = -1;

  @override
  void initState() {
    super.initState();
    newTexture();
  }

  void newTexture() async {
    mainTexture = await _channel.invokeMethod('newTexture',{
      'width': 300,
      'height': 300,
    });
    print('dart id: $mainTexture');
    setState(() {
      hasLoadTexture = true;
    });
  }

  Widget getTextureBody(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 300,
        height: 300,
        child: Texture(textureId: mainTexture,),
      ),
      onPanUpdate: (state){
        _channel.invokeMethod('dragUpdate',{
          'x':state.localPosition.dx,
          'y':state.localPosition.dy
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body = hasLoadTexture ? getTextureBody(context) : Text('loading...');

    return Scaffold(
      appBar: AppBar(
        title: Text('外接纹理'),
      ),
      body: Center(child: body,),
    );
  }
}
