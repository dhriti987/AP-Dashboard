import 'package:flutter/material.dart';
import 'package:streaming_data_dashboard/features/settings/bloc/settings_bloc.dart';
import 'package:streaming_data_dashboard/models/user_model.dart';

class UserDialog extends StatefulWidget {
  const UserDialog(
      {super.key,
      this.isEditUserDialog = false,
      this.user,
      required this.settingsBloc});

  final bool isEditUserDialog;
  final UserModel? user;
  final SettingsBloc settingsBloc;

  @override
  State<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  @override
  Widget build(BuildContext context) {
    TextEditingController employeeIdController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.employeeId : "");
    TextEditingController firstNameController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.firstName : "");
    TextEditingController lastNameController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.lastName : "");
    TextEditingController userNameController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.username : "");
    TextEditingController passwordController = TextEditingController();
    TextEditingController emailController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.email : "");
    TextEditingController contactNoController = TextEditingController(
        text: widget.isEditUserDialog ? widget.user!.contact : "");

    final formKey = GlobalKey<FormState>();
    var isAdmin = false;

    return AlertDialog(
      title: const Column(
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
                        label: 'Employee ID',
                        controller: employeeIdController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'First name',
                        controller: firstNameController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Last name',
                        controller: lastNameController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Username',
                        controller: userNameController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Email',
                        controller: emailController,
                        color: const Color(0xFF7E57C2),
                      ),
                      (!widget.isEditUserDialog)
                          ? _buildTextField(
                              label: 'Password',
                              controller: passwordController,
                              color: const Color(0xFF7E57C2),
                            )
                          : const SizedBox(
                              height: 1,
                            ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: 'Contact No',
                        controller: contactNoController,
                        color: const Color(0xFF7E57C2),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CheckboxFormField(
                        initialValue: (widget.isEditUserDialog)
                            ? widget.user!.isAdmin
                            : false,
                        title: const Text("Give Admin level access"),
                        onSaved: (newValue) {
                          isAdmin = newValue ?? false;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (widget.isEditUserDialog) {
                              widget.settingsBloc.add(EditUserEvent(
                                  user: UserModel(
                                      id: widget.user!.id,
                                      employeeId: employeeIdController.text,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      username: userNameController.text,
                                      email: emailController.text,
                                      contact: contactNoController.text,
                                      isAdmin: isAdmin)));
                              Navigator.of(context).pop();
                            } else {
                              widget.settingsBloc.add(AddUserEvent(
                                  employeeId: employeeIdController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  password: passwordController.text,
                                  username: userNameController.text,
                                  email: emailController.text,
                                  contactNo: contactNoController.text,
                                  isAdmin: isAdmin));
                              Navigator.of(context).pop();
                            }
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

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      required Color color}) {
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
}

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {super.key, Widget? title,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText ?? "",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}
