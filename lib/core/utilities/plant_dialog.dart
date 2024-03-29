import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';

class PlantDialog extends StatelessWidget {
  const PlantDialog({super.key, required this.settingsBloc});

  final SettingsBloc settingsBloc;

  @override
  Widget build(BuildContext context) {
    TextEditingController plantNameController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return AlertDialog(
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
                gradient: const LinearGradient(
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
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildTextField(
                        label: 'Plant name',
                        controller: plantNameController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            settingsBloc.add(
                                AddPlantEvent(name: plantNameController.text));
                            Navigator.of(context).pop();
                          }
                        }, //dialog
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 88, 19, 105),
                          padding: const EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
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
      actions: const <Widget>[],
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
          offset: const Offset(2, 2),
          blurRadius: 4,
        ),
        const BoxShadow(
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
        style: const TextStyle(
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
