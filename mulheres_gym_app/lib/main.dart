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

class WorkoutSuggestionPage extends StatelessWidget {
  final DateTime periodStartDate;
  final int periodLength;

  WorkoutSuggestionPage({required this.periodStartDate, required this.periodLength});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int daysSinceStart = today.difference(periodStartDate).inDays;

    String suggestion = _getWorkoutSuggestion(daysSinceStart, periodLength);
    String cycleDay = (daysSinceStart >= 0) ? 'Dia do Ciclo: ${daysSinceStart % 28}' : 'Ciclo não definido.';
    String phase = _getPhase(daysSinceStart, periodLength);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sugestões de Treino'),
        backgroundColor: Color(0xFFD81B60),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8), // Reduzindo o padding
            decoration: BoxDecoration(
              color: Color(0xFFD81B60),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      cycleDay,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      phase,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                suggestion,
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getWorkoutSuggestion(int daysSinceStart, int periodLength) {
    if (daysSinceStart < 0) return "Período não definido ainda.";
    int phase = (daysSinceStart % 28); // Ciclo típico de 28 dias

    if (phase < periodLength) {
      return "Atividades leves (yoga, caminhada).";
    } else if (phase < 14) {
      return "Treinos de força com carga aumentada.";
    } else if (phase < 16) {
      return "Máxima intensidade (HIIT, treinos explosivos).";
    } else {
      return "Atividades moderadas e recuperação.";
    }
  }

  String _getPhase(int daysSinceStart, int periodLength) {
    if (daysSinceStart < 0) return "Ciclo não definido.";
    int phaseDay = daysSinceStart % 28;

    if (phaseDay < periodLength) {
      return "Fase Menstrual";
    } else if (phaseDay < 14) {
      return "Fase Folicular";
    } else if (phaseDay < 16) {
      return "Fase Ovulatória";
    } else {
      return "Fase Lútea";
    }
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
  bool _showCycleInfo = false;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  color: Color(0xFFD81B60),
                  onPressed: () {
                    setState(() {
                      _showCycleInfo = !_showCycleInfo;
                    });
                  },
                ),
                SizedBox(width: 8),
                if (_showCycleInfo && _periodSet)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFD81B60),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ciclo Menstrual: Início em ${_periodStartDate.day}/${_periodStartDate.month}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'Duração: $_periodLength dias',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _showSetPeriodDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD81B60),
                    ),
                    child: Center(
                      child: Text(
                        'Definir Período Menstrual',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WorkoutSuggestionPage(
                          periodStartDate: _periodStartDate,
                          periodLength: _periodLength,
                        )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD81B60),
                    ),
                    child: Center(
                      child: Text(
                        'Ver Sugestões de Treino',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TableCalendar(
              focusedDay: _selectedDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                });
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
        int length = _periodLength;  // Usar o valor atual de _periodLength como padrão

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
                    length = int.parse(value);  // Atualiza o valor de length com a entrada do usuário
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
                // Lógica de registro aqui
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
