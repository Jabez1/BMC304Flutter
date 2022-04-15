import 'dart:async';
import 'dart:convert';
import '/../main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Clinic.dart';



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

  static const String _title = 'Add New Center Info';
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: cenNameController,
              decoration: const InputDecoration(
                hintText: 'Enter center name here',
                labelText: 'center name',
              ),
            ),
            TextField(
              controller: vacAddController,
              decoration: const InputDecoration(
                hintText: 'Enter address here',
                labelText: 'address',
              ),
            ),
            TextField(
              controller: vacLadController,
              decoration: const InputDecoration(
                hintText: 'Enter latitude here',
                labelText: 'latitude',
              ),
            ),
            TextField(
              controller: vacLongController,
              decoration: const InputDecoration(
                hintText: 'Enter longitude here',
                labelText: 'longitude',
              ),
            ),
            TextField(
              controller: vacNameController,
              decoration: const InputDecoration(
                hintText: 'Enter vaccine name here',
                labelText: 'vaccine name',
              ),
            ),
            TextField(
              controller: amtLeftController,
              decoration: const InputDecoration(
                hintText: 'Enter amount left here',
                labelText: 'amount available',
              ),
            ),
            TextField(
              controller: noPhoneController,
              decoration: const InputDecoration(
                hintText: 'Enter phone number here',
                labelText: 'phone number',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed:(){
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
                content: Text("Vaccination Center Added Successfully. . ."),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
      ),
    );
  }
}