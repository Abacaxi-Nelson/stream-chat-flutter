import 'dart:io';

import 'package:example/stream_version.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'choose_user_page.dart';
import 'main.dart';
import 'notifications_service.dart';

class AdvancedOptionsPage extends StatefulWidget {
  @override
  _AdvancedOptionsPageState createState() => _AdvancedOptionsPageState();
}

class _AdvancedOptionsPageState extends State<AdvancedOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _apiKeyController = TextEditingController();
  String _apiKeyError;

  final TextEditingController _userIdController = TextEditingController();
  String _userIdError;

  final TextEditingController _userTokenController = TextEditingController();
  String _userTokenError;

  final TextEditingController _usernameController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.white,
        elevation: 1,
        centerTitle: true,
        brightness: Theme.of(context).brightness,
        title: Text(
          'Advanced Options',
          style: StreamChatTheme.of(context)
              .textTheme
              .headlineBold
              .copyWith(color: StreamChatTheme.of(context).colorTheme.black),
        ),
        leading: IconButton(
          icon: StreamSvgIcon.left(
            color: StreamChatTheme.of(context).colorTheme.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _apiKeyController,
                    onChanged: (_) {
                      if (_apiKeyError != null) {
                        setState(() {
                          _apiKeyError = null;
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _apiKeyError = 'Please enter the Chat API Key';
                        });
                        return _apiKeyError;
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 14,
                      color: StreamChatTheme.of(context).colorTheme.black,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 0),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _apiKeyError != null
                            ? StreamChatTheme.of(context).colorTheme.accentRed
                            : StreamChatTheme.of(context)
                                .colorTheme
                                .black
                                .withOpacity(.5),
                      ),
                      border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      fillColor:
                          StreamChatTheme.of(context).colorTheme.whiteSmoke,
                      filled: true,
                      labelText:
                          'Chat API Key ${_apiKeyError != null ? ':$_apiKeyError' : ''}',
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _userIdController,
                      onChanged: (_) {
                        if (_userIdError != null) {
                          setState(() {
                            _userIdError = null;
                          });
                        }
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _userIdError = 'Please enter the User ID';
                          });
                          return _userIdError;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: StreamChatTheme.of(context).colorTheme.black,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _userIdError != null
                              ? StreamChatTheme.of(context).colorTheme.accentRed
                              : StreamChatTheme.of(context)
                                  .colorTheme
                                  .black
                                  .withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            StreamChatTheme.of(context).colorTheme.whiteSmoke,
                        filled: true,
                        labelText:
                            'User ID ${_userIdError != null ? ':$_userIdError' : ''}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      onChanged: (_) {
                        if (_userTokenError != null) {
                          setState(() {
                            _userTokenError = null;
                          });
                        }
                      },
                      controller: _userTokenController,
                      validator: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _userTokenError = 'Please enter the user token';
                          });
                          return _userTokenError;
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: StreamChatTheme.of(context).colorTheme.black,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 0),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _userTokenError != null
                              ? StreamChatTheme.of(context).colorTheme.accentRed
                              : StreamChatTheme.of(context)
                                  .colorTheme
                                  .black
                                  .withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            StreamChatTheme.of(context).colorTheme.whiteSmoke,
                        filled: true,
                        labelText:
                            'User Token ${_userTokenError != null ? ':$_userTokenError' : ''}',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: StreamChatTheme.of(context)
                              .colorTheme
                              .black
                              .withOpacity(.5),
                        ),
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            StreamChatTheme.of(context).colorTheme.whiteSmoke,
                        filled: true,
                        labelText: 'Username (optional)',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        color:
                            StreamChatTheme.of(context).colorTheme.accentBlue,
                        minWidth: double.infinity,
                        height: 48,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: StreamChatTheme.of(context).colorTheme.white,
                            fontSize: 16,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        onPressed: () async {
                          if (loading) {
                            return;
                          }
                          if (_formKey.currentState.validate()) {
                            final apiKey = _apiKeyController.text;
                            final userId = _userIdController.text;
                            final userToken = _userTokenController.text;
                            final username = _usernameController.text;

                            loading = true;
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: StreamChatTheme.of(context)
                                        .colorTheme
                                        .white,
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                            );

                            final client = Client(
                              apiKey,
                              logLevel: Level.INFO,
                              showLocalNotification:
                                  (!kIsWeb && Platform.isAndroid)
                                      ? showLocalNotification
                                      : null,
                              persistenceEnabled: true,
                            );

                            try {
                              await client.setUser(
                                User(id: userId, extraData: {
                                  'name': username,
                                }),
                                userToken,
                              );

                              if (!kIsWeb) {
                                initNotifications(client);
                              }

                              final secureStorage = FlutterSecureStorage();
                              secureStorage.write(
                                key: kStreamApiKey,
                                value: apiKey,
                              );
                              secureStorage.write(
                                key: kStreamUserId,
                                value: userId,
                              );
                              secureStorage.write(
                                key: kStreamToken,
                                value: userToken,
                              );
                            } catch (e) {
                              var errorText = 'Error connecting, retry';
                              if (e is Map) {
                                errorText = e['message'] ?? errorText;
                              }
                              Navigator.pop(context);
                              setState(() {
                                _apiKeyError = errorText;
                              });
                              loading = false;
                              await client.disconnect();
                              return;
                            }

                            if (!kIsWeb) {
                              initNotifications(client);
                            }

                            Navigator.pop(context);
                            Navigator.pop(context);
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MaterialApp(
                                    theme: ThemeData.light(),
                                    darkTheme: ThemeData.dark(),
                                    themeMode: ThemeMode.system,
                                    builder: (context, widget) {
                                      return StreamChat(
                                        child: widget,
                                        client: client,
                                      );
                                    },
                                    home: ChannelListPage(),
                                  );
                                },
                              ),
                            );
                            loading = false;
                          }
                        },
                      ),
                    ),
                  ),
                  StreamVersion(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}