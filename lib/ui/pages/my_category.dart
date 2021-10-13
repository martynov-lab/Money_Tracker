import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:money_tracker/ui/pages/add_category.dart';
import 'package:money_tracker/ui/pages/update_category.dart';
import 'package:money_tracker/utils/hex_color.dart';

class MyCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final categoryBloc = BlocProvider.of<CategoryBloc>(context);
    // categoryBloc.add(CategoryLoad());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 4,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return AddCategory();
                }),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
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
          return Container(
            child: ListView(
              children: [
                ...state.category.map(
                  (item) => GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ListTile(
                        title: Text(item.name.toString()),
                        leading: Icon(
                          IconData(item.icon!, fontFamily: 'MaterialIcons'),
                          size: 35,
                          color: HexColor(item.color!),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return UpdateCategory(
                            id: item.id!,
                            name: item.name!,
                            color: item.color!,
                            icon: item.icon!,
                          );
                        }),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
        return Center();
      }),
    );
  }
}
