import 'package:flutter/material.dart';
import 'morningView.dart';
import 'dart:developer' as developer;

class NightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/night.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: NightHomePage(),
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class NightHomePage extends StatefulWidget {
  @override
  NightHomePageState createState() => NightHomePageState();
  static NightHomePageState of(BuildContext context) =>
      context.findAncestorStateOfType<NightHomePageState>();
}

class NightHomePageState extends State<NightHomePage> {
  int nItems = 0;
  List<Widget> _listItems = <Widget>[];

  void toRemove(int index) {
    _listItems[index] = Container(
      height: 0,
    );
    setState(() => _listItems = [..._listItems]);
  }

  void addListItem() {
    CreateListItem nextEntry = CreateListItem(nItems, toRemove);

    setState(
      () {
        _listItems = [..._listItems, nextEntry];
        nItems = nItems + 1;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _reset() {
      nItems = 0;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration.zero,
          pageBuilder: (_, __, ___) => NightPage(),
        ),
      );
    }

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
              child: Icon(Icons.wb_sunny),
              onTap: () {
                Navigator.push(context, SlideRightRoute(page: MorningPage()));
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

class CreateListItem extends StatefulWidget {
  final recordKey;
  final Function removeAt;

  CreateListItem(this.recordKey, this.removeAt);

  @override
  CreateListItemState createState() => CreateListItemState();
}

class CreateListItemState extends State<CreateListItem> {
  @override
  void initState() {
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

  String routineText = "Enter Text here.";
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

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Text(
          "Night Routine",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 10,
        ),
      ),
    );
  }
}
