import 'package:flutter/material.dart';

class GantiPasswordScreen extends StatefulWidget {
  const GantiPasswordScreen({Key? key}) : super(key: key);

  @override
  _GantiPasswordScreenState createState() => _GantiPasswordScreenState();
}

class _GantiPasswordScreenState extends State<GantiPasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true; // Added variable to track password match

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 69, 112, 1),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ganti Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                errorText: !_passwordsMatch
                    ? 'Passwords do not match' // Display error message in red
                    : null,
              ),
              onChanged: (value) {
                // Check password match when Confirm New Password is changed
                setState(() {
                  _passwordsMatch = _newPasswordController.text == value;
                });
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Add logic to change the password here
                _changePassword();
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(43, 69, 112, 1),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    // Implement password change logic here
    // You can access the entered passwords using:
    // _currentPasswordController.text
    // _newPasswordController.text
    // _confirmPasswordController.text
    // Validate the passwords and perform the necessary actions
  }
}

void main() {
  runApp(MaterialApp(
    home: GantiPasswordScreen(),
  ));
}
