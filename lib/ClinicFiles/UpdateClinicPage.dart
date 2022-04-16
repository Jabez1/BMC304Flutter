import 'package:assignment_clinic_finder/ClinicFiles/Clinic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'Clinic.dart';
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//void main() => runApp(UpdateClinic());

class UpdateClinic extends StatelessWidget{
  const UpdateClinic({Key? key}) : super (key: key);

  
  @override
  Widget build(BuildContext context){
    final cInfoArg = ModalRoute.of(context)!.settings.arguments as Clinic;
    
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.updateCenter),
          leading: GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, '/viewClinic');
            },
            child: Icon(Icons.arrow_back
            ),
          ),
        ),
        body: MyClinicForm(cInfo: cInfoArg),
    );
  }
}

updateClinic(String cenId, String cenName, String vacAdd, String vacLad,
    String vacLong, String vacName, String amtLeft, String noPhone) async{
  final response = await http.post(
    Uri.parse('http://'+ urIp +'/BMC304php/clinicUpdate.php'),
    body:{
      'centerId': cenId,
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
  void initState(){
    super.initState();
    cenNameController.text = widget.cInfo.getString();
    vacAddController.text = widget.cInfo.getAddress();
    vacLadController.text = widget.cInfo.getLatitude();
    vacLongController.text = widget.cInfo.getLongitude();
    vacNameController.text = widget.cInfo.getVaccineName();
    amtLeftController.text = widget.cInfo.getAmountLeft();
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
    return  Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
              maxLines: 3,
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              ],
              keyboardType: TextInputType.number,
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              ],
              keyboardType: TextInputType.number,
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              keyboardType: TextInputType.number,
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
            Container(
              padding: const EdgeInsets.only(left: 5.0, top: 40.0),
              child: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.update),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      updateClinic(
                          widget.cInfo.getId(),
                          cenNameController.text,
                          vacAddController.text,
                          vacLadController.text,
                          vacLongController.text,
                          vacNameController.text,
                          amtLeftController.text,
                          noPhoneController.text);
                    });
                    Scaffold.of(context)
                      .showSnackBar(SnackBar(content:
                    Text(AppLocalizations.of(context)!.centerUpSuccess)));
                    }
                  },
              )
            ),
          ],
        ),
      ),
    );
  }
}

