import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';

class AddCategory extends StatefulWidget {
  AddCategory({Key? key}) : super(key: key);
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController _categoryController = TextEditingController();
  GlobalKey<FormState> _formKeyCategory = GlobalKey<FormState>();
  //MyTransaction? transaction = MyTransaction();
  //Category? category = Category();
  String _categoryColor = 'ff9e9e9e';
  int _categoryIcon = 61828;

  int selectedIndexColor = 0;
  int selectedIndexIcon = -1;
  @override
  Widget build(BuildContext context) {
    final CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 4,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _formKeyCategory.currentState!.save();
              categoryBloc.add(CategoryAdd(
                categoryName: _categoryController.text,
                categoryColor: _categoryColor,
                categoryIcon: _categoryIcon,
              ));
              _formKeyCategory.currentState!.reset();
              categoryBloc.add(CategoryLoad());
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
      body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (BuildContext context, CategoryState state) {
        // if (state is CategoryEmptyState) {
        //   return Center();
        // }
        if (state is CategoryLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CategoryLoadedState) {
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKeyCategory,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          autofocus: true,
                          controller: _categoryController,
                          decoration: InputDecoration(
                            focusColor: Colors.grey,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            hintText: 'Название категории',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
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
                          child: GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Иконка',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                            width: 2,
                                            color: state.listColors[
                                                selectedIndexColor]),
                                      ),
                                      child: selectedIndexIcon == -1
                                          ? Icon(
                                              Icons.local_offer_outlined,
                                              size: 35,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              state
                                                  .listIcons[selectedIndexIcon],
                                              size: 35,
                                              color: state.listColors[
                                                  selectedIndexColor],
                                            ),
                                    ),
                                  ]),
                            ),
                            onTap: () {
                              showMaterialModalBottomSheet(
                                expand: false,
                                enableDrag: true,
                                isDismissible: true,
                                duration: const Duration(milliseconds: 500),
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) => bottomSheet(
                                    state.listColors, state.listIcons),
                              );
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center();
      }),
    );
  }

  Widget bottomSheet(List<MaterialColor> colors, List<IconData> icons) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(10),
      //     topRight: Radius.circular(10),
      //   ),
      // ),
      height: MediaQuery.of(context).size.height / 1.6,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5),
            child: Text(
              'Выберете иконку',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700]),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: colors.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 20
                      : 10,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (1 / 1),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // устанавливаем индекс выделенного элемента
                        selectedIndexColor = index;
                        _categoryColor =
                            colors[selectedIndexColor].value.toRadixString(16);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: index == selectedIndexColor ? 2 : 1,
                          color: index == selectedIndexColor
                              ? Colors.black
                              : Colors.black54,
                        ),
                        color: colors[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 10
                      : 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: (1 / 1),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // устанавливаем индекс выделенного элемента
                        selectedIndexIcon = index;
                        _categoryIcon = icons[selectedIndexIcon].codePoint;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: index == selectedIndexIcon ? 2 : 1,
                          //color: index == selectedIndexIcon ? Colors.grey : Colors.black54,
                        ),
                      ),
                      child: Icon(
                        icons[index],
                        size: 35,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
