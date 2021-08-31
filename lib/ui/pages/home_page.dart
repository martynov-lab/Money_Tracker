import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_state.dart';
import 'package:money_tracker/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/ui/pages/add_transaction.dart';

class HomePage extends StatefulWidget {
  final MyAppUser user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final Widget _myTransactions = MyTransactions();
  final Widget _myAnalytics = MyAnalytics();
  final Widget _myBudget = MyBudget();
  final Widget _mySettings = MySettings();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Money Tracker'),
      //   centerTitle: true,
      // ),
      // drawer: Drawer(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.max,
      //     children: <Widget>[
      //       DrawerHeader(
      //         child: CircleAvatar(
      //           radius: 50,
      //           backgroundImage: NetworkImage(widget.user.photo.toString()),
      //         ),
      //       ),
      //       Expanded(
      //         child: Column(
      //           mainAxisSize: MainAxisSize.max,
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: <Widget>[
      //                 ListTile(
      //                   title: const Text('Аккаунт'),
      //                   leading: const Icon(Icons.person),
      //                   onTap: () {
      //                     Navigator.of(context).push(
      //                       MaterialPageRoute(builder: (context) {
      //                         return ProfilePage(user: widget.user);
      //                       }),
      //                     );
      //                   },
      //                 ),
      //                 const ListTile(
      //                   title: Text('Настройки'),
      //                   leading: Icon(Icons.settings),
      //                 ),
      //               ],
      //             ),
      //             Container(
      //               margin: const EdgeInsets.only(bottom: 20),
      //               child: ListTile(
      //                 title: const Text('Выйти'),
      //                 leading: const Icon(Icons.exit_to_app),
      //                 onTap: () {
      //                   BlocProvider.of<AuthenticationBloc>(context).add(
      //                     AuthenticationLoggedOut(),
      //                   );
      //                 },
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromRGBO(144, 83, 235, 1),
        iconSize: 30,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Операции',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Аналитика',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Бюджет',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Еще',
          ),
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody() {
    if (selectedIndex == 0) {
      return _myTransactions;
    } else if (selectedIndex == 1) {
      return _myAnalytics;
    } else if (selectedIndex == 2) {
      return _myBudget;
    } else {
      return _mySettings;
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class MyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final transactionBloc = BlocProvider.of<TransactionBloc>(context);
    // transactionBloc.add(TransactionLoad());
    return Scaffold(
      body: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
        if (state is TransactionEmptyState) {
          return Center(
            child: Text(
              'У Вас пока нет расходов!',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        if (state is TransactionLoadingState) {
          //return Center(child: Text('${state}'));
          return Center(child: CircularProgressIndicator());
        }
        if (state is TransactionLoadedState) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 100,
                pinned: true,
                floating: true,
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Баланс = ${state.sum} руб',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  // centerTitle: false,
                ),
                backgroundColor: Colors.deepPurple[300],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      // decoration: BoxDecoration(
                      //     border: Border(
                      //   bottom: BorderSide(color: Colors.grey, width: 0.2),
                      // )),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 30,
                            color: Colors.grey[700],
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${state.loadedTrasaction[index].comment}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              '${state.loadedTrasaction[index].currentDate}',
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        trailing: state
                                    .loadedTrasaction[index].typeTransaction ==
                                'expenditure'
                            ? Text(
                                '- ${state.loadedTrasaction[index].amount} руб',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              )
                            : Text(
                                '+ ${state.loadedTrasaction[index].amount} руб',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.green),
                              ),
                      ),
                    );
                  },
                  childCount: state.loadedTrasaction.length,
                ),
              ),
              //,
            ],
          );
        }
        return Center();
      }),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        buttonSize: 60.0,
        backgroundColor: Colors.deepPurple[400],
        elevation: 8.0,
        visible: true,
        spacing: 10,
        // renderOverlay: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          // SpeedDialChild(
          //   //speed dial child
          //   child: Icon(Icons.swap_horiz),
          //   backgroundColor: Colors.deepPurple[400],
          //   foregroundColor: Colors.white,
          //   label: 'Перевод',
          //   labelStyle: TextStyle(fontSize: 18.0),
          //   onTap: () {
          //     print('Перевод');
          //   },
          // ),
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.add),
            backgroundColor: Colors.deepPurple[400],
            foregroundColor: Colors.white,
            label: 'Доход',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddTransaction(typeTransaction: 'income');
                }),
              );
              print('Доход');
            },
          ),
          SpeedDialChild(
            //speed dial child
            child: Icon(Icons.remove),
            backgroundColor: Colors.deepPurple[400],
            foregroundColor: Colors.white,
            label: 'Расход',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              //Navigator.of(context).pushNamed('/expenditure');
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddTransaction(typeTransaction: 'expenditure');
                }),
              );
              print('Расход');
            },
          ),
        ],
      ),
    );
  }
}

class MyAnalytics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Аналитика'));
  }
}

class MyBudget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Бюджет'));
  }
}

class MySettings extends StatelessWidget {
  //final MyAppUser user = MyAppUser();

  @override
  Widget build(BuildContext context) {
    final loggedOutBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple[300],
              elevation: 4,
              title: Text(
                '${state.firebaseUser.name}',
                style: TextStyle(fontSize: 20.0),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    loggedOutBloc.add(AuthenticationLoggedOut());
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(state.firebaseUser.photo.toString()),
                      ),
                    ),
                    Divider(),
                    // Text('Вы вошли через: ${state.firebaseUser.email}'),
                    RichText(
                      textDirection: TextDirection.ltr,
                      text: TextSpan(
                        text: "Ваш email:",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: " ${state.firebaseUser.email}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.local_offer_outlined,
                              size: 30,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Text('Категории',
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.sms_outlined,
                              size: 30,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Text('Задать вопросы',
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone_android_outlined,
                              size: 30,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20),
                              child: Text('О приложении',
                                  style: TextStyle(fontSize: 20.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Center();
      },
    );
  }
}
