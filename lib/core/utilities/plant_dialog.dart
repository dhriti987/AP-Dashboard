import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/features/units_edit/bloc/units_edit_bloc.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class PlantDialog extends StatelessWidget {
  const PlantDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController plantNameController = TextEditingController();

    SettingsBloc settingsBloc = sl.get<SettingsBloc>();

    final _formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Column(
        children: [],
      ),
      content: SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0x880b74b0),
                    Color(0x8875479c),
                    Color(0x88bd3861),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Plant name',
                        controller: plantNameController,
                        color: Color(0xFF7E57C2),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            settingsBloc.add(
                                AddPlantEvent(name: plantNameController.text));
                            Navigator.of(context).pop();
                          }
                        }, //dialog
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 88, 19, 105),
                          padding: const EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: <Widget>[],
      backgroundColor: Colors.transparent,
    );
  }
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  required Color color,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          offset: Offset(2, 2),
          blurRadius: 4,
        ),
        BoxShadow(
          color: Colors.white,
          offset: Offset(-2, -2),
          blurRadius: 4,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        onChanged: (String value) {},
        validator: (value) {
          return value!.isEmpty ? 'Please enter $label' : null;
        },
      ),
    ),
  );
}
