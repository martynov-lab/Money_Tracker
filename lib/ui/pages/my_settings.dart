import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_state.dart';
import 'package:money_tracker/ui/pages/my_category.dart';
import 'package:image_picker/image_picker.dart';

class MySettings extends StatefulWidget {
  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  //bool isSaveAvatar = false;

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple[300],
              elevation: 0,
              // title: Text(
              //   '${state.firebaseUser.name}',
              //   style: TextStyle(fontSize: 20.0),
              // ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    authenticationBloc.add(AuthenticationLoggedOut());
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //*Фото
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (state.firebaseUser.photo) != null
                                  ? _image == null
                                      ? CircleAvatar(
                                          radius: 50.0,
                                          backgroundImage: NetworkImage(
                                              state.firebaseUser.photo!),
                                        )
                                      : CircleAvatar(
                                          radius: 50.0,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: Image.file(
                                              _image!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                  : _image == null
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            '${state.firebaseUser.name!.substring(0, 1).toUpperCase()}',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 32,
                                            ),
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 50.0,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: Image.file(
                                              _image!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: -25,
                          child: Column(
                            children: [
                              _image != null
                                  ? TextButton(
                                      onPressed: () {
                                        authenticationBloc.add(
                                            AuthenticationUpdate(
                                                imageUrl: _image!));

                                        setState(() {
                                          _image = null;
                                        });
                                        authenticationBloc
                                            .add(AuthenticationLoggedIn());
                                      },
                                      child: Text('Сохранить',
                                          style:
                                              TextStyle(color: Colors.white)))
                                  : Container(),
                              FloatingActionButton(
                                onPressed: getImage,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  //Icons.add_photo_alternate_outlined,
                                  Icons.add_a_photo_outlined,
                                  color: Colors.grey,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    //*Аккаунт
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text('Аккаунт',
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: RichText(
                              textDirection: TextDirection.ltr,
                              text: TextSpan(
                                text: 'Email:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' ${state.firebaseUser.email}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                            height: 0.0,
                            thickness: 1.0,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                              textDirection: TextDirection.ltr,
                              text: TextSpan(
                                text: 'Имя:',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' ${state.firebaseUser.name}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      height: 0.0,
                      thickness: 5.0,
                    ),
                    //*Настройки
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Настройки',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return MyCategory();
                                }),
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
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
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
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
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
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
