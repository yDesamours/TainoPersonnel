import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tainopersonnel/src/intl/intl.dart';

import 'package:tainopersonnel/src/model/state.dart';
import 'package:tainopersonnel/src/widget/actionbutton.dart';
import 'package:tainopersonnel/src/widget/dialogbox.dart';
import 'package:tainopersonnel/src/widget/inputfield.dart';
import 'package:tainopersonnel/src/operation/operation.dart' as operation;

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool canPress = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _listener() {
    if (_usernameController.text == "" || _passwordController.text == "") {
      setState(() {
        canPress = false;
      });
      return;
    }
    setState(() {
      canPress = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(_listener);
    _passwordController.addListener(_listener);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_listener);
    _passwordController.removeListener(_listener);
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();
    ConnectivityState connection = context.watch<ConnectivityState>();
    Language langue = context.watch<AppLanguage>().language;

    Future<void> loginFunction() async {
      try {
        await operation.login(
            _usernameController.text, _passwordController.text, state);
      } catch (e) {
        if (!mounted) return;

        await showDialog(
            context: context,
            builder: (context) => DialogBox(message: e.toString()));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: const Color.fromARGB(128, 128, 128, 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                InputField(
                  controller: _usernameController,
                  labelText: langue.username,
                  icon: Icons.person,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: _passwordController,
                  labelText: langue.password,
                  icon: Icons.key,
                  obscureText: true,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    canPress: canPress && connection.isOnline,
                    loginFunction: loginFunction,
                    icon: const Text(
                      'Connect',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
