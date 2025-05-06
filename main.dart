
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(GameRechargeApp());
}

class GameRechargeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'شحن ألعاب مصر',
      theme: ThemeData(fontFamily: 'Arial', primarySwatch: Colors.green),
      home: RechargeForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RechargeForm extends StatefulWidget {
  @override
  _RechargeFormState createState() => _RechargeFormState();
}

class _RechargeFormState extends State<RechargeForm> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGame = 'PUBG';
  String _playerId = '';
  String _amount = '';
  String _paymentMethod = 'فودافون كاش';

  List<String> games = ['PUBG', 'Free Fire'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
        'https://docs.google.com/forms/d/e/1FAIpQLSf...YOUR_FORM_ID.../formResponse?'
        'entry.1234567890=$_selectedGame&'
        'entry.0987654321=$_playerId&'
        'entry.1122334455=$_amount&'
        'entry.5566778899=$_paymentMethod',
      );
      await launchUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال الطلب بنجاح')),
      );
    }
  }

  void _contactWhatsApp() async {
    final whatsapp = 'https://wa.me/201234567890';
    if (await canLaunchUrl(Uri.parse(whatsapp))) {
      await launchUrl(Uri.parse(whatsapp));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('شحن ألعاب مصر')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedGame,
                  items: games.map((game) {
                    return DropdownMenuItem(
                      value: game,
                      child: Text(game),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedGame = value!),
                  decoration: InputDecoration(labelText: 'اختر اللعبة'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'معرف الحساب (ID)'),
                  onChanged: (value) => _playerId = value,
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال معرف الحساب' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'كمية الشحن'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _amount = value,
                  validator: (value) =>
                      value!.isEmpty ? 'يرجى إدخال الكمية' : null,
                ),
                TextFormField(
                  initialValue: _paymentMethod,
                  decoration: InputDecoration(labelText: 'طريقة الدفع'),
                  onChanged: (value) => _paymentMethod = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('إرسال الطلب'),
                ),
                TextButton(
                  onPressed: _contactWhatsApp,
                  child: Text('تواصل معنا على واتساب'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
