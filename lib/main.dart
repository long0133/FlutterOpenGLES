
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:texture_image/custom_widget_page.dart';
import 'package:texture_image/custom_widget_page_fake.dart';
import 'package:texture_image/plateform_view_page.dart';
import 'package:texture_image/texture_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            child: Center(child: Text('自定义控件-伪', style: TextStyle(fontSize: 30),),),
            onTap: (){
              Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return CustomFakeWidgetPage();
              }));
            },
          ),

          Divider(height: 2,thickness: 2,),

          GestureDetector(
            child: Center(child: Text('自定义控件', style: TextStyle(fontSize: 30),),),
            onTap: (){
              Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return CustomWidgetPage();
              }));
            },
          ),

          Divider(height: 2,thickness: 2,),

          GestureDetector(
            child: Center(child: Text('PlatformView', style: TextStyle(fontSize: 30),),),
            onTap: (){
              Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return PlatFormViewPage();
              }));
            },
          ),

          Divider(height: 2,thickness: 2,),

          GestureDetector(
            child: Center(child: Text('外接纹理', style: TextStyle(fontSize: 30),),),
            onTap: (){
              Navigator.push(context, PageRouteBuilder(pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation){
                return TexturePage();
              }));
            },
          ),
          Divider(height: 2,thickness: 2,),
        ],
      ),
    );
  }

}
