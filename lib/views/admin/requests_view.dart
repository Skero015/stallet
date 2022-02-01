
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/images.dart';
import 'package:stallet/config/size_config.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/reusables/admin_bottom_nav.dart';
import 'package:stallet/views/admin/request_details_view.dart';

class AdminRequestsView extends StatefulWidget {
  const AdminRequestsView({Key? key}) : super(key: key);

  @override
  _AdminRequestsViewState createState() => _AdminRequestsViewState();
}

class _AdminRequestsViewState extends State<AdminRequestsView> {

  final GlobalKey<ScaffoldState> _scaffoldKeyRequests = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyHome');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late RequestNotifier requestNotifier;

  final TextEditingController _controller = new TextEditingController();
  //late List<dynamic> _list;
  late bool _isSearching;
  String _searchText = "";
  List searchResult = [];

  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode = FocusNode();

    requestNotifier = Provider.of<RequestNotifier>(context, listen: false);

  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKeyRequests,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Flexible(
                      child: searchResult.length != 0 || _controller.text.isNotEmpty
                          ? new ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchResult[index];
                          return new ListTile(
                            title: transaction(listData.toString(), index),
                          );
                        },
                      )
                          : new ListView.builder(
                        shrinkWrap: true,
                        itemCount: requestNotifier.requestList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String? listData = requestNotifier.requestList[index].type;
                          return new ListTile(
                            title: transaction(listData.toString(), index),
                          );
                        },
                      )
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AdminBottomNavigation(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBarTitle = new Text(
    "Payment Requests",
    style: AppTheme.boldText,
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.black87,
  );

  PreferredSize buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(
              icon: icon,
              onPressed: () {
                setState(() {
                  if (this.icon.icon == Icons.search) {
                    this.icon = new Icon(
                      Icons.close,
                      color: Colors.black87,
                    );
                    this.appBarTitle = new TextField(
                      controller: _controller,
                      style: new TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: new InputDecoration(
                          prefixIcon: new Icon(Icons.search, color: Colors.black87),
                          hintText: "Search...",
                          hintStyle: new TextStyle(color: Colors.black87)),
                      onChanged: searchOperation,
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                });
              },
            ),
          ]),
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.black87,
      );
      this.appBarTitle = new Text(
        "Payment Requests",
        style: AppTheme.boldText,
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < requestNotifier.requestList.length; i++) {
        String? data = requestNotifier.requestList[i].type;
        if (data!.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }

  Widget transaction(String requestType, int index) {
    return GestureDetector(
      onTap: () {
        requestNotifier.currentRequest = requestNotifier.requestList[index];

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RequestDetailsView()));

      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              height: 7.5 * SizeConfig.heightMultiplier,
              width: 15 * SizeConfig.widthMultiplier,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15,),
              decoration: BoxDecoration(
                color: requestType.toLowerCase().contains('allowance') ? Color(0xFF38AAFD) : requestType.toLowerCase().contains('book') ? Color(0xFFD255F1) : Color(0xFFFCC459),
                borderRadius: BorderRadius.all(Radius.circular(15),),
              ),
              child: Image.asset(requestType.toLowerCase().contains('allowance') ? Images.walletImage : requestType.toLowerCase().contains('book') ? Images.booksImage : Images.rentImage, height: 5.5 * SizeConfig.imageSizeMultiplier, width: 5.5 * SizeConfig.imageSizeMultiplier, fit: BoxFit.fill,),
            ),
            SizedBox(width: 5 * SizeConfig.widthMultiplier,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(requestType, style: AppTheme.regularTextBold, overflow: TextOverflow.visible),
                SizedBox(width: 32 * SizeConfig.widthMultiplier,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
