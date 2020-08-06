import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class CustomWidgetPage extends StatefulWidget {
  @override
  _CustomWidgetPageState createState() => _CustomWidgetPageState();
}

class _CustomWidgetPageState extends State<CustomWidgetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _CustomWidget(
        children: <Widget>[

        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _CustomWidget extends MultiChildRenderObjectWidget{

  _CustomWidget({
    Key key,
    @required List<Widget> children,
}):super(key:key, children:children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _CustomWidgetRenderBox();
  }

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _CustomWidgetRenderBox extends RenderBox with
    ContainerRenderObjectMixin<RenderBox, _CustomWidgetParentData>,
    RenderBoxContainerDefaultsMixin<RenderBox, _CustomWidgetParentData>{

  @override
  void performLayout() {

  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  void setupParentData(RenderObject child) {
    if(child.parentData is! _CustomWidgetParentData){
      child.parentData = _CustomWidgetParentData();
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class _CustomWidgetParentData extends ContainerBoxParentData<RenderBox>{

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////