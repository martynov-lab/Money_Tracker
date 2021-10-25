import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_tracker/bloc/category_bloc/category_bloc.dart';
import 'package:money_tracker/utils/hex_color.dart';

class UpdateCategory extends StatefulWidget {
  final String id;
  final String name;
  final String color;
  final int icon;
  UpdateCategory(
      {Key? key,
      required this.id,
      required this.name,
      required this.color,
      required this.icon})
      : super(key: key);
  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final TextEditingController _categoryController = TextEditingController();
  final GlobalKey<FormState> _formKeyCategory = GlobalKey<FormState>();
  String _categoryColor = 'ff9e9e9e';
  int _categoryIcon = 61828;
  int selectedIndexColor = 0;
  int selectedIndexIcon = -1;

  late String categoryColorSelected;
  late int categoryIconSelected;

  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.name;
    categoryIconSelected = widget.icon;
    categoryColorSelected = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 4,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                categoryBloc.add(CategoryDelete(id: widget.id));
                Navigator.of(context).pop();
                categoryBloc.add(CategoryLoad());
              },
              icon: Icon(Icons.delete)),
          TextButton(
            onPressed: () {
              _formKeyCategory.currentState!.save();
              categoryBloc.add(CategoryUpdate(
                id: widget.id,
                name: _categoryController.text,
                color: _categoryColor,
                icon: _categoryIcon,
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
                                  selectedIndexIcon == -1
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                width: 2,
                                                color: HexColor(
                                                    categoryColorSelected)),
                                          ),
                                          child: Icon(
                                            IconData(categoryIconSelected,
                                                fontFamily: 'MaterialIcons'),
                                            size: 35,
                                            color:
                                                HexColor(categoryColorSelected),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                width: 2,
                                                color: state.listColors[
                                                    selectedIndexColor]),
                                          ),
                                          child: Icon(
                                            state.listIcons[selectedIndexIcon],
                                            size: 35,
                                            color: state
                                                .listColors[selectedIndexColor],
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
                        ),
                      ),
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
