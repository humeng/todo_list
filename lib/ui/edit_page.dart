import 'package:flutter/material.dart';
import 'package:todo_list/constant/multi_color.dart';
import 'package:todo_list/constant/event_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_list/db/entry/todo_entry.dart';
import 'package:todo_list/util/date_format_util.dart';
import 'package:todo_list/util/toast_util.dart';

class EditPage extends StatefulWidget {
  final Todo todo; //可选命名参数不能为私有的
  final EventType _eventType;

  EditPage(this._eventType, {this.todo, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _EditPageState();
  }
}

class _EditPageState extends State<EditPage> {
  EventType _eventType;
  Todo _todo;
  TextEditingController _textEditingController;

  bool _warningTimeIsVisible;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: _eventType.color,
        title: new Text(
          _eventType.event + (_todo.id != null ? "-编辑" : "-新增"),
          style: new TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
        ),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.check),
              onPressed: () {
                if (_checkParameters()) {
                  Navigator.pop(context, _todo);
                }
              }),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
              child: new TextField(
                controller: _textEditingController,
                decoration: new InputDecoration(border: InputBorder.none),
                onChanged: _onTextChanged,
              ),
              decoration: new BoxDecoration(
                  color: Multicolor.GRAY_246,
                  borderRadius: BorderRadius.all(new Radius.circular(10.0))),
            ),
          ),
          new Container(
            height: 45.0,
            child: new Stack(
              children: <Widget>[
                new Align(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    "设置闹钟",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontSize: 16.0, fontStyle: FontStyle.normal),
                  ),
                ),
                new Align(
                  alignment: Alignment.centerRight,
                  child: new CupertinoSwitch(
                    activeColor: Colors.red,
                    value: _todo.isWarning,
                    onChanged: _onWarningChanged,
                  ),
                )
              ],
            ),
            decoration: new BoxDecoration(
                border: new Border(
                    bottom: new BorderSide(
                        color: Multicolor.GRAY_246, width: 2.0))),
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
          ),
          new Offstage(
            offstage: !_warningTimeIsVisible,
            child: new GestureDetector(
              excludeFromSemantics: false,
              onTap: _selectTime,
              child: new Container(
                height: 45.0,
                child: new Stack(
                  children: <Widget>[
                    new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "提醒时间",
                        style: new TextStyle(
                            fontSize: 16.0, fontStyle: FontStyle.normal),
                      ),
                    ),
                    new Align(
                      alignment: Alignment.centerRight,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Text(
                            _todo.warningTime.isNotEmpty
                                ? _todo.warningTime
                                : "请选择",
                            style: new TextStyle(
                                fontSize: 16.0, fontStyle: FontStyle.normal),
                          ),
                          new Image.asset(
                            "images/more.png",
                            height: 15.0,
                            width: 10.0,
                            excludeFromSemantics: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///初始化数据
  void initData() {
    _eventType = widget._eventType;
    if (widget.todo == null) {
      _todo = new Todo();
      _todo.type = _eventType.type;
    } else {
      _todo = widget.todo;
    }
    _textEditingController = new TextEditingController(
      text: _todo.content,
    );
    _warningTimeIsVisible = _todo.isWarning;
  }

  ///当输入内容改变的时候
  void _onTextChanged(String value) {
    if (value.isNotEmpty) {
      _todo.content = value;
    }
  }

  ///提醒改变的时候
  void _onWarningChanged(bool value) {
    setState(() {
      _todo.isWarning = value;
      _warningTimeIsVisible = value;
    });
  }

  //选择时间
  void _selectTime() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(new DateTime.now().year),
        lastDate: new DateTime(new DateTime.now().year + 5));
    if (dateTime != null) {
      TimeOfDay timeOfDay = await showTimePicker(
          context: context, initialTime: new TimeOfDay.now());
      if (timeOfDay != null) {
        setState(() {
          _todo.warningTime = DateUtil.format(dateTime, timeOfDay);
        });
      }
    }
  }

  ///检查参数
  bool _checkParameters() {
    if (_todo.content.isEmpty) {
      ToastUtil.showCenterShort("请输入提醒内容");
      return false;
    } else {
      if (_todo.isWarning) {
        if (_todo.warningTime.isEmpty) {
          ToastUtil.showCenterShort("请选择提醒时间");
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
  }
}
