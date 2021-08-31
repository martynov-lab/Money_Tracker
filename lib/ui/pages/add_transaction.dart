import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/bloc/transaction_bloc/transaction_bloc.dart';
import 'package:money_tracker/data/models/transaction.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key, required this.typeTransaction}) : super(key: key);
  final String typeTransaction;
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController _expenditureController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MyTransaction transaction = MyTransaction();

  bool _changeRepeat = false;
  bool _isPickedDate = false;
  DateTime nowDate = DateTime.now();
  DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  late String formattedDate = formatterDate.format(nowDate);

  @override
  Widget build(BuildContext context) {
    final TransactionBloc userBloc = BlocProvider.of<TransactionBloc>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              transaction.amount = _expenditureController.text;
              transaction.comment = _commentController.text;
              transaction.typeTransaction = widget.typeTransaction;
              transaction.currentDate = formattedDate;
              userBloc.add(TransactionAdd(transaction));
              _formKey.currentState!.reset();
              Navigator.of(context).pop();
            },
            child: Text('Сохранить',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    hintText: "О",
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // scrollDirection: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                      radius: 30,
                      child: Icon(Icons.wallet_giftcard),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                      radius: 30,
                      child: Icon(Icons.car_repair),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                      radius: 30,
                      child: Icon(Icons.east),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                      radius: 30,
                      child: Icon(Icons.phone_android),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.grey[900],
                      radius: 30,
                      child: Icon(Icons.local_dining),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
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
                    hintText: "Комментарии",
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

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    print('nowDate: $nowDate');
    if (picked != nowDate) {
      nowDate = picked!;
      formattedDate = formatterDate.format(picked);
      print('formattedDate: $formattedDate');
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
