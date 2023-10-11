import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tainopersonnel/src/class/state.dart';
import 'package:tainopersonnel/src/widget/dialogbox.dart';
import 'package:tainopersonnel/src/widget/inputfield.dart';
import 'package:tainopersonnel/src/class/api.dart';

// ignore: must_be_immutable
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool canPress = false;

  _LoginFormState() {
    void listener() {
      if (usernameController.text == "" || passwordController.text == "") {
        setState(() {
          canPress = false;
        });
        return;
      }
      setState(() {
        canPress = true;
      });
    }

    usernameController.addListener(listener);
    passwordController.addListener(listener);
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppState>();

    void Function()? loginFunction;

    loginFunction = () async {
      try {
        var (user, tenant) =
            await API.login(usernameController.text, passwordController.text);

        state.setUser(user);
        state.setTenant(tenant);
      } catch (e) {
        if (!mounted) return;

        await showDialog(
            context: context,
            builder: (context) => DialogBox(message: e.toString()));
      }
    };

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        padding: const EdgeInsets.all(40),
        color: const Color.fromARGB(128, 128, 128, 128),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                InputField(
                  usernameController: usernameController,
                  labelText: "username",
                  icon: Icons.person,
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  usernameController: passwordController,
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
                    child: const Text(
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
