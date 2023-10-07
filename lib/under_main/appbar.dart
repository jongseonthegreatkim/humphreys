import 'package:flutter/material.dart';
import 'package:humphreys/under_appbar/menu.dart';
import 'package:humphreys/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // firestore에서 data를 CRUD하기 위함.

// firestore에서 data를 가져오기 위한 함수.
Future<List<String>> getData() async {
  // 이 tempList는 return해서 snapshot에 넣어주기만을 위한 리스트.
  // 그 이후로는 사용되지 않으며, 사용될 수도 없음.
  List<String> tempList = [];

  // collection에 접근
  QuerySnapshot<Map<String, dynamic>> querySnapshot
  = await FirebaseFirestore.instance.collection('blue').get();

  // collection의 document마다, name이라는 field에 접근해,
  // 그 value을 tempList에 넣는다.
  querySnapshot.docs.forEach((doc) {
    tempList.add(doc['name']);
  });

  return tempList;
}


class Appbar extends StatefulWidget {
  const Appbar({super.key});

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  final TextEditingController _filter = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  String _searchText = '';
  late List<List<String>> masterList = [route, blueStation, blackStation, greenStation, orangeStation, purpleStation];
  List<String> route = ['blue', 'black', 'green', 'orange', 'purple'];
  List<String> blueStation = [];
  List<String> blackStation = [];
  List<String> greenStation = [];
  List<String> orangeStation = [];
  List<String> purpleStation = [];

  // _filter가 상태 변화를 감지하여(=addListener), _searchText를 업데이트 시켜주는 것.
  _AppbarState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  // 검색 결과 리스트를 보여주는 위젯
  Widget buildList(BuildContext context, List<String> dataList) {
    // 보여줄 것들로 구성된 리스트 생성.
    List<String> showList = [];

    // masterList 안의 List마다 모든 요소를 체크하여, _searchText가 존재하는 지 체크
    for(int index=0; index<dataList.length; index++) {
      // 정확한 비교를 위해 두 String 다 lowercase로 변환.
      if (dataList[index].toLowerCase().contains(_searchText.toLowerCase())) {
        // 화면에 표시할 때는 lowercase로 변환하지 않은 원래의 데이터로 표시.
        showList.add(dataList[index]);
      }
    }

    // _searchText가 빈칸이 아닐 때와 빈칸일때를 구분해서 정리.
    if (_searchText != '')
      return Column(
        children: [
          for (int index = 0; index < showList.length; index++) ...[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(35, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(
                    showList[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            index < showList.length-1 ? Container(
              margin: EdgeInsets.fromLTRB(35, 0, 15, 0),
              height: 0.5,
              color: Colors.grey,
            ) : Container(),
          ],
          SizedBox(height: 5),
        ],
      );
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // menu.dart 페이지 일부만 나오게 하는 기술
    PageRouteBuilder _pageRouteBuilder(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(-1.0, 0.0); // 왼쪽에서 나오게 설정.
          Offset end = Offset(-0.5, 0.0); // 현재는 반만 나오게 설정.
          Curve curve = Curves.easeInOut;

          Animatable<Offset> tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          Animation<Offset> offsetAnimation = animation.drive(tween);

          return Stack(
            children: [
              Main(),
              SlideTransition(position: offsetAnimation, child: child)
            ],
          );
        },
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6), // 컨셉 색상
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context, _pageRouteBuilder(Menu()));
                },
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Container(
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    controller: _filter,
                    focusNode: myFocusNode,
                    textAlignVertical: TextAlignVertical.center, // 모든 텍스트를 가운데 정렬.
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      hintText: 'Search Bus Stop or Bus Route', // 얘는 myFocusNode.hasFocus와 _filterText에 영향을 안 받아야 하는데..
                      hintStyle: TextStyle(
                        color: Color(0xFF727272), // 컨셉 색상
                        fontSize: 18,
                      ),
                      suffixIcon: myFocusNode.hasFocus ? IconButton(
                        icon: Icon(
                          Icons.cancel,
                          size: 20,
                          color: Color(0xFF3F3F3F), // 컨셉 색상
                        ),
                        onPressed: () {
                          setState(() {
                            _filter.clear();
                            _searchText = '';
                          });
                        },
                      ) : Container(),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<List<String>>(
            future: getData(),
            builder: (context, snapshot) {
              if(snapshot.data == null) {
                return Container();
              } else {
                // dataList라는 리스트를 정의한 뒤, snapshot.data!, 즉, getData의 return 값인 tempList를 넣어준다.
                List<String> dataList = snapshot.data!;
                // 그리고 그 dataList를 buildList에 전달한다.
                return buildList(context, dataList);
              }
            },
          ),
        ],
      ),
    );
  }
}
