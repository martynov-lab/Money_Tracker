import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_tracker/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_tracker/ui/pages/add_transaction.dart';
import 'package:money_tracker/ui/pages/update_transaction.dart';
import 'package:money_tracker/utils/hex_color.dart';

class MyTransactions extends StatefulWidget {
  @override
  State<MyTransactions> createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
  late final ScrollController _hideButtonController;
  bool _isVisible = true;
  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          //print('Скролл вверх');
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            //print('Скрол вниз');
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
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
        return Center(child: CircularProgressIndicator());
      }
      if (state is TransactionLoadedState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[300],
            title: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${state.sum} руб',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                Text('Баланс',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300)),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: ListView.builder(
            controller: _hideButtonController,
            itemCount: state.loadedGroupTrasactionData.length,
            itemBuilder: (BuildContext context, int index) {
              var dateListTransaction =
                  state.loadedGroupTrasactionData.keys.toList();
              var listTransaction =
                  state.loadedGroupTrasactionData.values.toList();

              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[100],
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
                    child: Text(
                      '${dateListTransaction[index]}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  ...listTransaction[index].map(
                    (transaction) => Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            color: Colors.white,
                            child: ListTile(
                              //ИКОНКА
                              leading: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 2,
                                    color: HexColor(
                                        transaction.categoryColor.toString()),
                                  ),
                                ),
                                child: Icon(
                                  IconData(
                                      int.parse(
                                          transaction.categoryIcon.toString()),
                                      fontFamily: 'MaterialIcons'),
                                  size: 35,
                                  color: HexColor(
                                      transaction.categoryColor.toString()),
                                ),
                              ),

                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //КАТЕГОРИЯ
                                  Text(
                                    '${transaction.categoryName}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  //КОММЕНТАРИИ
                                  Text(
                                    '${transaction.comment}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              //СУММА
                              trailing:
                                  transaction.typeTransaction == 'expenditure'
                                      ? Text(
                                          '- ${transaction.amount} руб',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.red),
                                        )
                                      : Text(
                                          '+ ${transaction.amount} руб',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return UpdateTransaction(
                                  id: transaction.id!,
                                  currentDate: transaction.currentDate!,
                                  amount: transaction.amount!,
                                  category: state.category,
                                  categoryId: transaction.categoryId!,
                                  comment: transaction.comment!,
                                  typeTransaction: transaction.typeTransaction!,
                                );
                              }),
                            );
                          },
                        ),
                        Divider(
                          color: Colors.grey[100],
                          height: 0.0,
                          thickness: 3.0,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            //childCount: state.loadedGroupTrasactionData.length,
          ),
          floatingActionButton: _isVisible
              ? SpeedDial(
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
                            return AddTransaction(
                                typeTransaction: 'expenditure');
                          }),
                        );
                        print('Расход');
                      },
                    ),
                  ],
                )
              : null,
        );

        //,
        //);
      }
      return Center();
    });
  }
}
