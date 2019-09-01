import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yellow Messenger',
      home: MyHomePage(),
    );
  }
}

enum MessageFormats { Text, Image, Link, Suggestions }

class Message {
  String message;
  String time;
  bool delivered;
  bool isMe;
  MessageFormats format;

  Message(this.message, this.time, this.delivered, this.isMe,
      [this.format = MessageFormats.Text]);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isComposingMessage = false;
  List<Widget> bubbles = [];
  List<Message> msgs = [
    Message("Hey there.", "11:00", true, true),
    Message("Hi. How may I help?", "11:01", true, false),
    Message("Can you tell me about Yellow Messenger?", "11:01", true, true),
    Message("Sure thing.", "11:02", true, false, MessageFormats.Suggestions),
    Message("images/mission.jpg", "11:02", true, false, MessageFormats.Image),
    Message(
        "Yellow Messenger is a leading omnichannel conversational AI tool that helps more than 100 top brands to offer personalised customer service at scale and drive growth.",
        "11:02",
        true,
        false),
    Message("Thanks.", "11:03", false, true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryDarkColor,
          elevation: 0.0,
          title: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            child: Image.asset("images/Logo_footer.png"),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            )
          ],
        ),
        body: Container(
          color: PrimaryColor,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  child: _chatBubbles(),
                ),
              ),
              Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).cardColor),
                child: _messageEditor(),
              ),
              // Container(width: 0.0, height: 0.0),
            ],
          ),
        ));
  }

  Widget _chatBubbles() {

    //Creating chat bubbles
    setState(() {
      if(bubbles.length<1)
      for (Message msg in msgs){
        bubbles.add(Bubble(msg));
     }
    });
    
    return ListView(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: bubbles
            ,
          ),
        ]);
  }

  Container _messageEditor() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.attach_file,
                  color: Colors.blueAccent,
                ),
                onPressed: null),
          ),
          new Flexible(
            child: new TextField(
              controller: _textEditingController,
              onChanged: (String messageText) {
                setState(() {
                  _isComposingMessage = messageText.length > 0;
                });
              },
              onSubmitted: null,
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: _getDefaultSendButton(),
          ),
        ],
      ),
    );
  }

  RaisedButton _getDefaultSendButton() {
    return RaisedButton(
      disabledColor: YellowColor,
      disabledElevation: 0,
      color: YellowColor,
      shape: CircleBorder(),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.send,
          color: _isComposingMessage ? TextColorLight : Colors.white54,
          size: 30.0,
        ),
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    print(_textEditingController.text);
    DateTime now = DateTime.now();
    setState(() {
       bubbles.add(Bubble(Message(_textEditingController.text, DateFormat('kk:mm').format(now), true, true)));
    });
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });
  }
}

class Bubble extends StatelessWidget {
  Bubble(this.msg);

  final Message msg;
  Widget _messageBody() {
    Widget childElement;
    switch (msg.format) {
      case MessageFormats.Text:
        childElement = Text(msg.message);
        break;
      case MessageFormats.Link:
        childElement = Text(msg.message);
        break; //todo
      case MessageFormats.Suggestions:
        childElement = Column(
          children: <Widget>[
            OutlineButton(
                child: new Text("Suggestion 1"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
            OutlineButton(
                child: new Text("Suggestion 2"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
            OutlineButton(
                child: new Text("Suggestion 3"),
                onPressed: () {},
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0))),
          ],
        );
        break; //todo
      case MessageFormats.Image:
        childElement = Image.asset(
          msg.message,
          height: 300,
        );
        break;
      default:
        childElement = Container();
    }
    return childElement;
  }

  @override
  Widget build(BuildContext context) {
    print(msg.format);
    final bg = msg.isMe ? Colors.yellowAccent.shade100 : Colors.white;
    final align = msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final icon = msg.delivered ? Icons.done_all : Icons.done;
    final radius = msg.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          );

    final messageBody = _messageBody();

    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: messageBody,
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(msg.time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
