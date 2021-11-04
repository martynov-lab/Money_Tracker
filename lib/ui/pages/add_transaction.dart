import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:money_tracker/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_tracker/utils/hex_color.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key, required this.typeTransaction}) : super(key: key);
  final String typeTransaction;
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController _expenditureController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  GlobalKey<FormState> _formKeyTransaction = GlobalKey<FormState>();

  bool _changeRepeat = false;
  bool _isPickedDate = false;
  DateTime nowDate = DateTime.now();
  DateFormat formatterDate = DateFormat('yyyy-MM-dd'); //dd.MM.yyyy
  late String formattedDate = formatterDate.format(nowDate);

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final TransactionBloc transactionBloc =
        BlocProvider.of<TransactionBloc>(context);

    return BlocBuilder<CategoryBloc, CategoryState>(
        builder: (BuildContext context, CategoryState state) {
      if (state is CategoryEmptyState) {
        return Center(
          child: Text(
            'У Вас пока не добавленны категории!',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      if (state is CategoryLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is CategoryLoadedState) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple[300],
            elevation: 4,
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _formKeyTransaction.currentState!.save();

                  // transaction!.amount = _expenditureController.text;
                  // transaction!.comment = _commentController.text;
                  // transaction!.typeTransaction = widget.typeTransaction;
                  // transaction!.currentDate = formattedDate;
                  /* 
                  -------------------
                   */
                  // transaction!.category!.name =
                  //     state.category[selectedIndex].name;
                  // transaction!.category!.color =
                  //     state.category[selectedIndex].color;
                  // transaction!.category!.icon =
                  //     state.category[selectedIndex].icon;

                  transactionBloc.add(TransactionAdd(
                    currentDate: formattedDate,
                    amount: _expenditureController.text,
                    categoryId: state.category[selectedIndex].id!,
                    categoryName: state.category[selectedIndex].name!,
                    categoryColor: state.category[selectedIndex].color!,
                    categoryIcon: state.category[selectedIndex].icon!,
                    comment: _commentController.text,
                    typeTransaction: widget.typeTransaction,
                  ));
                  _formKeyTransaction.currentState!.reset();
                  transactionBloc.add(TransactionLoad());
                  Navigator.of(context).pop();
                },
                child: Text('Сохранить',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKeyTransaction,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: true,
                      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _expenditureController,
                      decoration: InputDecoration(
                        focusColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        hintText: 'О',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        suffixText: 'Р',
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.close),
                        //   color: Colors.grey,
                        //   onPressed: () {
                        //     _expenditureController.clear();
                        //   },
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    child: Container(
                      child: ListView.builder(
                        itemCount: state.category.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                // устанавливаем индекс выделенного элемента
                                selectedIndex = index;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                selectedIndex == index
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 2,
                                              color: HexColor(state
                                                  .category[index].color!)),
                                          color: HexColor(
                                              state.category[index].color!), //
                                        ),
                                        child: Icon(
                                          IconData(state.category[index].icon!,
                                              fontFamily: 'MaterialIcons'),
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              width: 2,
                                              color: HexColor(state
                                                  .category[index].color!)),
                                          //color: HexColor(item.color!), //
                                        ),
                                        child: Icon(
                                          IconData(state.category[index].icon!,
                                              fontFamily: 'MaterialIcons'),
                                          size: 35,
                                          color: HexColor(
                                              state.category[index].color!),
                                        ),
                                      ),
                                Container(
                                    child: Text(
                                  '${state.category[index].name}',
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.date_range,
                                color: Colors.grey,
                              ),
                            ),
                            _isPickedDate
                                ? Text(
                                    formattedDate,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Text(
                                    'Сегодня',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
                      //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      //keyboardType: TextInputType.number,
                      controller: _commentController,
                      decoration: InputDecoration(
                        focusColor: Colors.grey,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        prefixIcon: Icon(Icons.comment),
                        hintText: 'Комментарии',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.grey,
                          onPressed: () {
                            _expenditureController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                  //SwitchListTile
                  Divider(color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SwitchListTile(
                      value: _changeRepeat,
                      onChanged: (bool val) {
                        setState(() {
                          _changeRepeat = val;
                        });
                      },
                      activeColor: Colors.grey[500],
                      title: Text('Повторять операцию'),
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        if (_changeRepeat) _reapeatWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Center();
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    //print('nowDate: $nowDate');
    if (picked != nowDate) {
      nowDate = picked!;
      formattedDate = formatterDate.format(picked);
      //print('formattedDate: $formattedDate');
      setState(() {
        _isPickedDate = true;
      });
    }
  }
}

Widget _reapeatWidget() {
  return Column(
    children: <Widget>[
      Text('Периодичность повторения'),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            onPressed: () {},
            // style: ButtonStyle(
            //   foregroundColor:
            //       MaterialStateProperty.all<Color>(Colors.deepPurple),
            // ),
            child: Text('День',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Неделя',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Месяц',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Год',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.normal)),
          ),
        ],
      ),
    ],
  );
}
