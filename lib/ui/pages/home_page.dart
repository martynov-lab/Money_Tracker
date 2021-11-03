import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:money_tracker/data/models/user.dart';
import 'package:money_tracker/ui/pages/my_analytics.dart';
//import 'package:money_tracker/ui/pages/my_budget.dart';
import 'package:money_tracker/ui/pages/my_settings.dart';
import 'package:money_tracker/ui/pages/my_transactions.dart';

class HomePage extends StatefulWidget {
  final MyAppUser user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    categoryBloc.add(CategoryLoad());
    return Scaffold(
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
          // const BottomNavigationBarItem(
          //   icon: Icon(Icons.account_balance_wallet_outlined),
          //   label: 'Бюджет',
          // ),
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
      return MyTransactions();
    } else if (selectedIndex == 1) {
      return MyAnalytics();
    }
    // else if (selectedIndex == 2) {
    //   return MyBudget();
    // }
    else {
      return MySettings();
    }
  }

  void onTapHandler(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
