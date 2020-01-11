import 'package:flutter/material.dart';
import 'package:food_dev/Models/staffs.dart';
import 'package:food_dev/Widgets/app_drawer.dart';
import 'package:food_dev/Widgets/managed_staff_item.dart';
import 'package:provider/provider.dart';

class ManageStaffView extends StatefulWidget {
  const ManageStaffView({Key key}) : super(key: key);

  @override
  _ManageStaffViewState createState() => _ManageStaffViewState();
}

class _ManageStaffViewState extends State<ManageStaffView> {

  var _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
       _isLoading = true; 
      });
        Provider.of<Staffs>(context, listen: false).fetchStaff().then((_) {
        setState(() {
         _isLoading = false; 
        });
      });
    });
    super.initState();
  }

Future<void> _refreshItems(BuildContext context) {
    return Provider.of<Staffs>(context).fetchStaff();
  }

  @override
  Widget build(BuildContext context) {
    final staff = Provider.of<Staffs>(context);
    return Scaffold(
      drawer: CustomAppDrawer(),
      appBar: AppBar(
        title: Text('Manage Staff'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person_add), onPressed: () {
            Navigator.of(context).pushNamed('/editStaff');
          },)
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshItems(context),
                  child: Padding(
            padding: const EdgeInsets.all(8),
            child: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
              itemCount: staff.users.length,
              itemBuilder: (_, index) => Column(
                children: <Widget>[
                  ManagedStaffItem(user: staff.users[index],),
                  Divider()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}