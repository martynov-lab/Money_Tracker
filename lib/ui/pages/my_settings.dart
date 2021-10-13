import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_event.dart';
import 'package:money_tracker/bloc/authentication_bloc/authentication_state.dart';
import 'package:money_tracker/ui/pages/my_category.dart';

class MySettings extends StatelessWidget {
  //final MyAppUser user = MyAppUser();

  @override
  Widget build(BuildContext context) {
    final loggedOutBloc = BlocProvider.of<AuthenticationBloc>(context);
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationSuccess) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple[300],
              elevation: 4,
              title: Text(
                '${state.firebaseUser.name}',
                style: TextStyle(fontSize: 20.0),
              ),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () {
                    loggedOutBloc.add(AuthenticationLoggedOut());
                  },
                  icon: Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(state.firebaseUser.photo.toString()),
                      ),
                    ),
                    Divider(),
                    // Text('Вы вошли через: ${state.firebaseUser.email}'),
                    RichText(
                      textDirection: TextDirection.ltr,
                      text: TextSpan(
                        text: 'Ваш email:',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' ${state.firebaseUser.email}',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return MyCategory();
                          }),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
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
            ),
          );
        }
        return Center();
      },
    );
  }
}
