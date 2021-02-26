import 'package:flutter/material.dart';
import 'dart:developer' as developer;

List<Widget> uniqueGlobalVariableForHitory = [];
Map globalListData = {};

class MorningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/morning.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: MorningHomePage(),
    );
  }
}

class MorningHomePage extends StatefulWidget {
  MorningHomePage();
  @override
  MorningHomePageState createState() => MorningHomePageState();
  static MorningHomePageState of(BuildContext context) =>
      context.findAncestorStateOfType<MorningHomePageState>();
}

class MorningHomePageState extends State<MorningHomePage> {
  int nItems = uniqueGlobalVariableForHitory.length;
  List<Widget> _listItems = [];

  void toRemove(int index) {
    _listItems[index] = Container(
      height: 0,
    );

    setState(() => _listItems = [..._listItems]);
  }

  void addListItem() {
    CreateListItem2 nextEntry = CreateListItem2(nItems, toRemove);

    setState(
      () {
        _listItems = [..._listItems, nextEntry];
        nItems = nItems + 1;
      },
    );
  }

  @override
  void initState() {
    _listItems = uniqueGlobalVariableForHitory;
    super.initState();
  }

  void _reset() {
    globalListData = {};
    nItems = 0;
    uniqueGlobalVariableForHitory = [];
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MorningPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: GestureDetector(
            onTap: addListItem,
            child: Icon(Icons.add),
          ),
        ),
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: _reset,
              child: Icon(Icons.refresh),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: GestureDetector(
              child: Icon(Icons.star),
              onTap: () {
                uniqueGlobalVariableForHitory = _listItems;
                developer.log("saved _listItems");
                developer.log("$uniqueGlobalVariableForHitory");
                Navigator.pop(context);
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: PageTitle(),
          ),
          Container(
            height: 500,
            padding: EdgeInsets.only(
              top: 15,
              left: 10,
            ),
            child: ListView(
              children: _listItems,
            ),
          ),
        ], //Children
      ),
    );
  }
}

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Text(
          "Morning Routine",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 40,
        ),
      ),
    );
  }
}

class CreateListItem2 extends StatefulWidget {
  final recordKey;
  final Function removeAt;

  CreateListItem2(this.recordKey, this.removeAt);

  @override
  CreateListItem2State createState() => CreateListItem2State();
}

class CreateListItem2State extends State<CreateListItem2> {
  @override
  void initState() {
    routineText = globalListData[widget.recordKey] ?? "Enter Text Here.";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _setText();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.centerLeft,
            child: CheckBox(),
          ),
          Expanded(
            child: GestureDetector(
              child: _editTitleTextField(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 3),
            child: GestureDetector(
              onTap: () {
                developer.log("${widget.recordKey}");
                widget.removeAt(widget.recordKey);
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isEditingText = false;

  String routineText = "enter text here";
  TextEditingController _editingController;

  void _setText() {
    if (routineText.contains("${widget.recordKey}")) {
    } else {
      routineText = "${widget.recordKey + 1}.   $routineText ";
    }
  }

  TextStyle _theme() {
    return TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(
              () {
                globalListData[widget.recordKey] = newValue;
                routineText = newValue;
                _isEditingText = false;
              },
            );
          },
          autofocus: true,
          controller: _editingController,
          style: _theme(),
        ),
      );
    return InkWell(
      onTap: () {
        setState(
          () {
            _isEditingText = true;
          },
        );
      },
      child: Text(
        routineText,
        style: _theme(),
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _checked = false;
  _checkBox() {
    setState(() {
      _checked = !_checked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _checkBox,
      child: Icon(
        _checked ? Icons.check_box : Icons.check_box_outline_blank_sharp,
        color: Colors.white,
      ),
    );
  }
}
