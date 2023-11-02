import 'package:flutter/material.dart';
import 'Date_Button.dart';


class InfiniteScrollButton extends StatefulWidget {
  @override
  _InfiniteScrollButtonState createState() => _InfiniteScrollButtonState();
}

class _InfiniteScrollButtonState extends State<InfiniteScrollButton> {
  ScrollController _scrollController = ScrollController();
  bool isScrolling = false;
  int leftIndex = currentItemIndex;
  int rightIndex = currentItemIndex;

  // 초기 화면: 중앙 감지(수정 필요)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        currentIndex * 70.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }


  //좌우 아이템 추가(수정 필요)
/*
  void _loadMoreItems() {
    leftIndex -= 15;
    rightIndex += 15;

    // 왼쪽 끝으로 스크롤할 때
    if (leftIndex <= 0) {
      for (int i = leftIndex; i > leftIndex-15; i--) {
        if (i <= 0) {
          items.insert(0, dateList[i].subtract(Duration(days: -1)));
        }
      }
      leftIndex -= 30;
    }

    // 오른쪽 끝으로 스크롤할 때
    if (rightIndex >= items.length) {
      for (int i = items.length - 1; i > rightIndex+15; i++) {
        items.add(dateList[i].add(Duration(days: 1)));
      }
      rightIndex +=30;
    }
  }
 */



  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification notification) {
        double scrollPosition = _scrollController.position.pixels;
        double centerPosition = _scrollController.position.maxScrollExtent / 2;
        double detectionRange = 70;

        if (scrollPosition > centerPosition - detectionRange && scrollPosition < centerPosition + detectionRange) {
          setState(() {
            //_loadMoreItems();
          });
        }
        return false;
      },
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) {
            if (index == items.length - 1 || index == 0) {
              return Padding(
                padding: EdgeInsets.all(27.0),
                child: isScrolling ? SizedBox() : CircularProgressIndicator(),
              );
            }
            return Container(
              width: 70.0,
              height: 50.0,
              margin: EdgeInsets.all(5.0),
              child: GenerateButton(),
            );
          },
        ),
      ),
    );
  }
}
