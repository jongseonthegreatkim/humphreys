import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF4F3EE), // for BouncingScrollPhysics()
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.menu, color: Colors.black)
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        color: Color(0xFFF4F3EE),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Title(titleList: ['Camp', 'Routes', 'Zoom']),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Title extends StatefulWidget {
  const Title({super.key, required this.titleList});

  final List<String> titleList;

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {

  double _top = 10;
  double _bottom = 10;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true, // column 안쪽이니까.
      scrollDirection: Axis.vertical,
      itemCount: widget.titleList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(_top),
              bottom: Radius.circular(_bottom),
            ),
          ),
          height: 40,
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.titleList[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 1,
              color: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}


class Choose extends StatefulWidget {
  const Choose({super.key, required this.title, required this.chooseList});

  final String title;
  final List<String> chooseList;

  @override
  State<Choose> createState() => _ChooseState();
}

class _ChooseState extends State<Choose> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 2.5/1,
            ),
            itemCount: widget.chooseList.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: Center(
                  child: Text(
                    '${widget.chooseList[index]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}