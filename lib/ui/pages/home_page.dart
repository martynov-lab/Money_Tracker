import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/ui/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  final MyAppUser user;

  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final Widget _myInvoices = MyInvoices();
  final Widget _myTransactions = MyTransactions();
  final Widget _myAnalytics = MyAnalytics();
  final Widget _myBudget = MyBudget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Tracker'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DrawerHeader(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.user.photo.toString()),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text('Аккаунт'),
                        leading: Icon(Icons.person),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return ProfilePage(user: widget.user);
                            }),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Настройки'),
                        leading: Icon(Icons.settings),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ListTile(
                      title: Text('Выйти'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          AuthenticationLoggedOut(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        selectedItemColor: Color.fromRGBO(144, 83, 235, 1),
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Счета",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: "Операции",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: "Аналитика",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: "Бюджет",
          ),
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return this._myInvoices;
    } else if (this.selectedIndex == 1) {
      return this._myTransactions;
    } else if (this.selectedIndex == 2) {
      return this._myAnalytics;
    } else {
      return this._myBudget;
    }
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}

class MyInvoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Счета"));
  }
}

class MyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Транзакции"));
  }
}

class MyAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Аналитика"));
  }
}

class MyBudget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Бюджет"));
  }
}
