import 'package:assignment_clinic_finder/CasesFiles/UpdateCovid.dart';
import 'package:assignment_clinic_finder/ClinicFiles/AddClinicPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class UpdateClinic extends StatelessWidget{
  const UpdateClinic({Key? key}) : super (key: key);
  
  static const String _title = 'Update Clinic details';
  
  @override
  Widget build(BuildContext context){
    final cInfoArg = ModalRoute.of(context)!.settings.arguments as Clinic;
    
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          leading: GestureDetector(
            onTap:(){ Navigator.pushNamed(context, '/ViewClinic');},
            child: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: MyClinicForm(cInfo: cInfoArg),
      ),
    );
  }
}

updateClinic(String cenName, String vacAdd, String vacLad,
    String vacLong, String vacName, String amtLeft, String noPhone) async{
  final response = await http.post(
    Uri.parse('http://192.168.1.105:8080/clinicUpdate.php'),
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
  if (response.statusCode == 200){
    print("Returned Message: "+response.body.toString());
  }
  else{
    throw Exception('Unexpected Error Occurred!');
  }
}

class MyClinicForm extends StatefulWidget{
  final Clinic cInfo;
  
  const MyClinicForm({Key? key, required this.cInfo}) : super(key: key);
  
  @override
  _MyClinicFormState createState()=> _MyClinicFormState();
}

class _MyClinicFormState extends State<MyClinicForm>{
  
  final _formKey = GlobalKey<FormState>();
  final cenNameController = TextEditingController();
  final vacAddController = TextEditingController();
  final vacLadController = TextEditingController();
  final vacLongController = TextEditingController();
  final vacNameController = TextEditingController();
  final amtLeftController = TextEditingController();
  final noPhoneController = TextEditingController();
  
  @override
  void iniState(){
    super.initState();
    cenNameController.text = widget.cInfo.getString();
    vacNameController.text = widget.cInfo.getAddress();
    vacLadController.text = widget.cInfo.getLadtitude();
    vacLongController.text = widget.cInfo.getLongitude();
    vacNameController.text = widget.cInfo.getVaccineName();
    noPhoneController.text = widget.cInfo.getPhone();
  }

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
    return Form(
      key: _formKey,
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
          Container(
            padding: const EdgeInsets.only(left: 150.0, top: 40.0),
            child: ElevatedButton(
              child: const Text("Update"),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    updateClinic(cenNameController.text, vacAddController.text,
                        vacLadController.text, vacLongController.text,
                        vacNameController.text, amtLeftController.text,
                        noPhoneController.text);
                  });
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Vaccination Center Updated!')));
                  }
                },
            )
          ),
        ],
      ),
    );
  }
}

