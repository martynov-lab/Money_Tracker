import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:money_tracker/bloc/transaction_bloc/transaction_bloc.dart';

class UpdateTransaction extends StatefulWidget {
  final String id;
  final String currentDate;
  final String amount;
  final List category;
  final String categoryId;
  final String comment;
  final String typeTransaction;

  UpdateTransaction({
    Key? key,
    required this.id,
    required this.typeTransaction,
    required this.amount,
    required this.category,
    required this.categoryId,
    required this.comment,
    required this.currentDate,
  }) : super(key: key);

  @override
  _UpdateTransactionState createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {
  final TextEditingController _expenditureController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKeyTransaction = GlobalKey<FormState>();

  bool _changeRepeat = false;
  bool _isPickedDate = false;
  DateTime nowDate = DateTime.now();
  DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  late String formattedDate = formatterDate.format(nowDate);
  late int selectedIndex;
  late String selectedTypeTransaction;

  @override
  void initState() {
    super.initState();
    _expenditureController.text = widget.amount;
    _commentController.text = widget.comment;
    formattedDate = widget.currentDate;
    selectedTypeTransaction = widget.typeTransaction;

    for (var i = 0; i < widget.category.length; i++) {
      if (widget.category[i].id == widget.categoryId) {
        selectedIndex = i;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionBloc = BlocProvider.of<TransactionBloc>(context);

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
              IconButton(
                  onPressed: () {
                    transactionBloc.add(TransactionDelete(id: widget.id));
                    Navigator.of(context).pop();
                    transactionBloc.add(TransactionLoad());
                  },
                  icon: Icon(Icons.delete)),
              TextButton(
                onPressed: () {
                  _formKeyTransaction.currentState!.save();
                  transactionBloc.add(TransactionUpdate(
                    id: widget.id,
                    currentDate: formattedDate,
                    amount: _expenditureController.text,
                    categoryId: state.category[selectedIndex].id!,
                    categoryName: state.category[selectedIndex].name!,
                    categoryColor: state.category[selectedIndex].color!,
                    categoryIcon: state.category[selectedIndex].icon!,
                    comment: _commentController.text,
                    typeTransaction: selectedTypeTransaction,
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
                  //*   ЗНАЧЕНИЕ ТРАНЗАКЦИИ
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
                      ),
                    ),
                  ),
                  //* ИКОНКА
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
                                print(
                                    'selectedIndex после нажатия---$selectedIndex');
                              });
                            },
                            child: selectedIndex == index
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.grey,
                                          ),
                                          color: Colors.grey, //
                                        ),
                                        child: Icon(
                                          IconData(state.category[index].icon!,
                                              fontFamily: 'MaterialIcons'),
                                          size: 35,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${state.category[index].name}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                            width: 2,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        child: Icon(
                                          IconData(state.category[index].icon!,
                                              fontFamily: 'MaterialIcons'),
                                          size: 35,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          '${state.category[index].name}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                  //* ТИП ТРАНЗАКЦИИ
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        //* доход
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTypeTransaction = 'income';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 20),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                color: selectedTypeTransaction == 'income'
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              child: Text(
                                'Доход',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedTypeTransaction == 'income'
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        //* расход
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTypeTransaction = 'expenditure';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 20),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
                                color: selectedTypeTransaction == 'expenditure'
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                              child: Text(
                                'Расход',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      selectedTypeTransaction == 'expenditure'
                                          ? Colors.white
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //* ДАТА
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
                                    formattedDate,
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
                  //* КОММЕНТАРИЙ
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autofocus: false,
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
                            _commentController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey),
                  //* ПОВТОРЕНИЕ ОПЕРАЦИИ
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

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != nowDate) {
      nowDate = picked!;
      formattedDate = formatterDate.format(picked);
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
