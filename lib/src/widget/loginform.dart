import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tainopersonnel/src/model/state.dart';
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
  bool isLoading = false;

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

    void Function()? loginFunction;

    loginFunction = () async {
      setState(() {
        isLoading = true;
      });
      try {
        operation.login(
            _usernameController.text, _passwordController.text, state);
      } catch (e) {
        if (!mounted) return;

        await showDialog(
            context: context,
            builder: (context) => DialogBox(message: e.toString()));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    };

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
                  labelText: "username",
                  icon: Icons.person,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: _passwordController,
                  labelText: "password",
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
                  child: ElevatedButton(
                    onPressed: canPress ? loginFunction : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(200, 33, 150, 243),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
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
