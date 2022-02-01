
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:stallet/config/styleguide.dart';
import 'package:stallet/model/Request.dart';
import 'package:stallet/model/SubWallet.dart';
import 'package:stallet/model/Wallet.dart';
import 'package:stallet/notifiers/request_notifier.dart';
import 'package:stallet/notifiers/students_notifier.dart';
import 'package:stallet/notifiers/subWallet_notifier.dart';
import 'package:stallet/notifiers/wallet_notifiers.dart';
import 'package:stallet/reusables/admin_bottom_nav.dart';
import 'package:stallet/views/admin/student_details_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  final GlobalKey<ScaffoldState> _scaffoldKeySearch = new GlobalKey<ScaffoldState>(debugLabel: '_scaffoldKeyHome');

  final GlobalKey _safeArea = GlobalKey();

  late FocusNode myFocusNode;

  late StudentNotifier studentNotifier;

  late RequestNotifier requestNotifier;

  late WalletNotifier walletNotifier;

  late SubwalletNotifier subwalletNotifier;

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

    studentNotifier = Provider.of<StudentNotifier>(context, listen: false);

    requestNotifier = Provider.of<RequestNotifier>(context, listen: false);

    walletNotifier = Provider.of<WalletNotifier>(context, listen: false);

    subwalletNotifier = Provider.of<SubwalletNotifier>(context, listen: false);

    getPaymentRequests(requestNotifier);



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
      key: _scaffoldKeySearch,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: ProgressHUD(
        child: SafeArea(
          key: _safeArea,
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new ListTile(
                                onTap: () async {

                                  final progress = ProgressHUD.of(_safeArea.currentContext!);
                                  progress!.show();

                                  studentNotifier.currentStudent = studentNotifier.studentList[index];

                                  await getWallet(studentNotifier.studentList[index].uid, walletNotifier).whenComplete(() async {

                                    await getInnerWallets(studentNotifier.studentList[index].uid, subwalletNotifier).whenComplete(() {
                                      progress.dismiss();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentDetailsView()));
                                    });
                                  });

                                },
                                tileColor: Colors.black87,
                                shape: Border.all(color: Colors.grey),
                                leading: Icon(Icons.person, color: Colors.blue,),
                                title: new Text(listData.toString(), style: AppTheme.regularTextWhite,),
                              ),
                            );
                          },
                        )
                            : new ListView.builder(
                          shrinkWrap: true,
                          itemCount: studentNotifier.studentList.length,
                          itemBuilder: (BuildContext context, int index) {
                            String? listData = studentNotifier.studentList[index].studentNumber;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new ListTile(
                                onTap: () async {

                                  final progress = ProgressHUD.of(_safeArea.currentContext!);
                                  progress!.show();

                                  studentNotifier.currentStudent = studentNotifier.studentList[index];

                                  await getWallet(studentNotifier.studentList[index].uid, walletNotifier).whenComplete(() async {

                                    await getInnerWallets(studentNotifier.studentList[index].uid, subwalletNotifier).whenComplete(() {
                                      progress.dismiss();
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StudentDetailsView()));
                                    });
                                  });

                                },
                                tileColor: Colors.black87,
                                shape: Border.all(color: Colors.grey),
                                leading: Icon(Icons.person, color: Colors.blue,),
                                title: new Text(listData.toString(), style: AppTheme.regularTextWhite,),
                              ),
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
      ),
    );
  }

  Widget appBarTitle = new Text(
    "Search Student",
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
        "Search Sample",
        style: new TextStyle(color: Colors.black87),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < studentNotifier.studentList.length; i++) {
        String? data = studentNotifier.studentList[i].studentNumber;
        if (data!.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(data);
        }
      }
    }
  }
}
