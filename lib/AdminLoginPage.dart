import 'package:flutter/material.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  static const String _title = 'Login as an Admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          leading: GestureDetector(
            onTap: () {Navigator.pop(context);},
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final pwController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: idController,
            decoration: const InputDecoration(
                icon: const Icon(Icons.person),
              hintText: 'Enter your username',
              labelText: 'Username',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          TextFormField(
            controller: pwController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.vpn_key_sharp),
              hintText: 'Enter your Password',
              labelText: 'Password',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/adminHomePage');
                  }
                },
              )),
        ],
      ),
    );
  }
}