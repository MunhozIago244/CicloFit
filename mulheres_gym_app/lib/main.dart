import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFFCE4EC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CicloFIT',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD81B60),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD81B60)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD81B60)),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool isLogged = await _login(
                    emailController.text, passwordController.text);
                if (isLogged) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Login inválido')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD81B60),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Entrar',
                style: TextStyle(
                  color: Color(0xFFEDE7F6),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Não tem uma conta? Registre-se',
                style: TextStyle(color: Color(0xFFD81B60)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _login(String user, String password) async {
    return user == '1' && password == '1';
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _periodStartDate = DateTime.now();
  int _periodLength = 5;
  bool _periodSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário Menstrual'),
        backgroundColor: Color(0xFFD81B60),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _showSetPeriodDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD81B60),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text('Definir Período Menstrual'),
              
            ),
            SizedBox(height: 20),
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFFD81B60),
                  shape: BoxShape.rectangle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(),
                weekendDecoration: BoxDecoration(),
                holidayDecoration: BoxDecoration(),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
              },
              eventLoader: (day) {
                return _getPeriodDays(_periodStartDate, _periodLength).contains(day) ? [day] : [];
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSetPeriodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime startDate = DateTime.now();
        int length = 5;

        return AlertDialog(
          title: Text('Defina seu período menstrual'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Dia de Início (dd)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    int day = int.parse(value);
                    startDate = DateTime(DateTime.now().year, DateTime.now().month, day);
                  }
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Duração (dias)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    length = int.parse(value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _periodStartDate = startDate;
                  _periodLength = length;
                  _periodSet = true;
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  List<DateTime> _getPeriodDays(DateTime start, int length) {
    return List<DateTime>.generate(length, (index) {
      return start.add(Duration(days: index));
    });
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFFCE4EC),
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Color(0xFFD81B60),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Registro',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD81B60),
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nome',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD81B60)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD81B60)),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD81B60)),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD81B60),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Registrar',
                style: TextStyle(
                  color: Color(0xFFEDE7F6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
