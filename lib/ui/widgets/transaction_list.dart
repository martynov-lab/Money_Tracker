import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 30,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) => Container(
        child: ListTile(
          leading: Icon(
            Icons.account_balance_wallet,
            size: 30,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Категория $index'),
              Text(
                'Счет $index',
                style: TextStyle(
                    color: Colors.grey[500], fontWeight: FontWeight.w300),
              ),
            ],
          ),
          trailing: Text('-1 483,53 руб'),
        ),
      ),
    );
  }
}
