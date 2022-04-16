import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InsertCovid extends StatelessWidget {
  const InsertCovid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.insertCase),
          leading: GestureDetector(
            onTap: () { Navigator.pop(context);},
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        body: const MyCustomForm(),
    );
  }
}

createCovidCase(String date, String count) async{
  final response = await http.post(
      Uri.parse('http://' + urIp + '/BMC304php/covidCaseInsert.php'),
      body:{
        'covidDate' : date,
        'covidCount' : count
      }
  );
  if (response.statusCode == 200){
    print("Returned Message: "+response.body.toString());
  }
  else{
    throw Exception('Unexpected Error Occurred!');
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
  final dateController = TextEditingController();
  final countController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: dateController,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              hintText: 'Enter the Date',
              labelText: AppLocalizations.of(context)!.date,
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2018),
                  lastDate: DateTime(2101));
              if (pickedDate != null){
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                setState(() {
                  dateController.text = formattedDate;
                  print(formattedDate);
                });}
              else{
                print("Date not selected");
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a date';
              }
              return null;
            },
          ),
          TextFormField(
            controller: countController,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter the number of Covid Cases',
              labelText: AppLocalizations.of(context)!.newCovidCount,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter valid number';
              }
              return null;
            },
          ),
          Container(
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.submit),
                onPressed: () {
                  // It returns true if the form is valid, otherwise returns false
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      createCovidCase(dateController.text, countController.text);
                    });
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Case has been Added!')));
                  }
                },
              )),
        ],
      ),
    );
  }
}