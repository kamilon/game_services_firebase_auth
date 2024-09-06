import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:game_services_firebase_auth/firebase_auth_extension.dart';
import 'package:game_services_firebase_auth/firebase_user_extension.dart';
import 'package:game_services_firebase_auth/game_services_firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _streamSubscription;
  User? _user;

  @override
  void initState() {
    super.initState();
    GameServicesFirebaseAuth().enableDebugLogging(true);
    _listenAuthState();
  }

  void _listenAuthState() {
    _streamSubscription = FirebaseAuth.instance.idTokenChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Auth test'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user == null) ...[
              TextButton(
                onPressed: () => FirebaseAuth.instance.signInAnonymously(),
                child: Text('Sign in Anonymously'),
              ),
              TextButton(
                onPressed: () =>
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: 'test@test.fr', password: 'salut123'),
                child: Text('Sign in random mail'),
              ),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signInWithGamesServices(),
                child: Text('Sign in with OS Game service'),
              ),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_user != null) ...[
                  if (!_user!.isLinkedWithGamesServices()) ...[
                    TextButton(
                      onPressed: () => _user!.linkWithGamesServices(),
                      child: Text('Link credentials with OS Game service'),
                    ),
                    TextButton(
                      onPressed: () => _user!.linkWithGamesServices(forceSignInIfCredentialAlreadyUsed: true),
                      child: Text('Link credentials with OS Game service (Forced)'),
                    ),
                  ],
                  Text('Name: ${_user?.displayName}'),
                  Text('Email: ${_user?.email}'),
                  Text('UID: ${_user?.uid}'),
                  Text('Providers: ${_user?.providerData.map((e) => e.providerId)}'),
                  Text('Is linked with GameServices: ${_user!.isLinkedWithGamesServices()}'),
                  TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text('Logout'),
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel();
  }
}
