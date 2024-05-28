import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/userServices.dart';
import 'package:mobile/theme_data.dart';
import 'package:mobile/utils/navigation.dart';
import 'package:mobile/utils/secureStorage.dart';
import 'package:mobile/utils/tradToken.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final UserServices _userServices = UserServices();

  String _email = "";
  String _password = "";

  void _onEmailInputChange(String value) {
    setState(() {
      _email = value;
    });
  }

  void _onPasswordInputChange(String value) {
    setState(() {
      _password = value;
    });
  }

  void _onSubmit(BuildContext context) async {
    final userCredentials = UserCredentials(_email, _password);
    final Response response = await _userServices.auth(userCredentials);
    print('test');

    if (response.data['token'] == null) {
      return;
    }

    await SecureStorage.addStorageItem('token', response.data['token']);
    await verifyAndDecodeJwt(response.data['token']);

    redirectToPath(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: _onEmailInputChange,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          TextFormField(
            onChanged: _onPasswordInputChange,
            obscureText: true,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            ),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              labelStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () => _onSubmit(context),
            style: TextButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white, // Couleur de fond du bouton
              padding: const EdgeInsets.all(
                8.0,
              ), // Padding autour du texte du bouton
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12.0), // Border radius du bouton
              ),
            ),
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }
}
