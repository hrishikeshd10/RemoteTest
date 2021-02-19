import 'package:flutter/material.dart';
import 'package:my_neighbourhood_online/screens/app_drawer.dart';

class BusinessListPage extends StatefulWidget {
  @override
  _BusinessListPage createState() => _BusinessListPage();
}

class _BusinessListPage extends State<BusinessListPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _menuShown = false;
  String _value;
  List<ListItem> _dropdownItems = [
    ListItem(1, "Bandra, Mumbai"),
    ListItem(2, "Versova, Mumbai"),
    ListItem(3, "Borivali, Mumbai"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  @override
  void initState() {
    // TODO: implement initState
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _selectedItem = _dropdownItems[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Animation opacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    if (_menuShown)
      animationController.forward();
    else
      return Scaffold(
        drawer: AppDrawer(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0), //// here the desired height
            child: Container(
              color: Color(0xff202427),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                                size: 15,
                              )),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              height: 40,
                              child: Row(
                                children: [
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: TextEditingController(),
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Business Locations",
                                          hintStyle:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Icon(
                                      Icons.search,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: 100,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/Silver oak.png',
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10, top: 10),
                            child: Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                        ),
                        Positioned.fill(
                          top: 150,
                          child: Container(
                            color: Colors.white.withOpacity(0.75),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 12),
                                        Text(
                                          "SILVER OAK",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Expanded(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.place,
                                                color: Colors.black,
                                                size: 15,
                                              ),
                                              Text(
                                                "MAHALAXMI",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "12.6 Km",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset('assets/images/360_icon.png',
                                      scale: 1.8),
                                  SizedBox(width: 10),
                                  Image.asset('assets/images/gallery_icon.png',
                                      scale: 1.8),
                                  SizedBox(width: 10),
                                  Image.asset('assets/images/whatsapp_icon.png',
                                      scale: 1.8),
                                  SizedBox(width: 10),
                                  Image.asset('assets/images/call_icon.png',
                                      scale: 1.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      );
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}
