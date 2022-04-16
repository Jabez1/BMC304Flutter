import 'dart:async';
import '/../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Clinic.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



void main() => runApp(AddClinic());


createClinic(String cenName, String vacAdd, String vacLad,
    String vacLong, String vacName, String amtLeft, String noPhone) async{

  final response = await http.post(
    Uri.parse('http://'+ urIp + '/BMC304php/clinicInsert.php'),
    body:{
      'centerName':cenName,
      'vacAddress':vacAdd,
      'vacLatitude':vacLad,
      'vacLongitude':vacLong,
      'vaccineName': vacName,
      'amountLeft': amtLeft,
      'numPhone':noPhone
    }
  );

}

class AddClinic extends StatelessWidget {
  const AddClinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('AppLocalizations.of(context)!.AddNewCenterInfo'),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back
            ),
          ),
        ),
        body: const ClinicForm(),
      ),
    );
  }
}

class ClinicForm extends StatefulWidget{
  const ClinicForm({Key? key}) : super(key: key);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<ClinicForm>{

  Future<Clinic>? _futureClinic;
  final _formKey = GlobalKey<FormState>();
  final cenNameController = TextEditingController();
  final vacAddController = TextEditingController();
  final vacLadController = TextEditingController();
  final vacLongController = TextEditingController();
  final vacNameController = TextEditingController();
  final amtLeftController = TextEditingController();
  final noPhoneController = TextEditingController();

  @override
  void dispose(){
    cenNameController.dispose();
    vacAddController.dispose();
    vacLadController.dispose();
    vacLongController.dispose();
    vacNameController.dispose();
    amtLeftController.dispose();
    noPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _formKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: cenNameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterCenter,
                labelText: AppLocalizations.of(context)!.centerName,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: vacAddController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterAddress,
                labelText: AppLocalizations.of(context)!.address,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: vacLadController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterLatitude,
                labelText: AppLocalizations.of(context)!.latitude,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: vacLongController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterLongitude,
                labelText: AppLocalizations.of(context)!.longitude,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: vacNameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterVaccine,
                labelText: AppLocalizations.of(context)!.vaccineName,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: amtLeftController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterAmount,
                labelText: AppLocalizations.of(context)!.amountLeft,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
            TextFormField(
              controller: noPhoneController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterPhone,
                labelText: AppLocalizations.of(context)!.phone,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return AppLocalizations.of(context)!.requireValid;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed:(){
          if(_formKey.currentState!.validate()){
            setState(() {
              createClinic(cenNameController.text, vacAddController.text,
                  vacLadController.text, vacLongController.text,
                  vacNameController.text, amtLeftController.text,
                  noPhoneController.text);
            });
            showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: Text('AppLocalizations.of(context)!.centerSucsess'),
                );
              },
            );
          }
        },
      ),
    );
  }
}