import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Güzellik Merkezi Randevu',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.light(
          primary: Colors.pink,
          onPrimary: Colors.white,
          secondary: Colors.purpleAccent,
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.pink[50]!,
          onBackground: Colors.black,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 18),
          bodySmall: TextStyle(color: Colors.pinkAccent, fontSize: 16),
        ),
      ),
      home: AppointmentPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? selectedDay;
  TimeOfDay? selectedTime;
  String? selectedService;
  String? selectedSkinCareOption;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final List<String> services = ['Saç Kesimi', 'Cilt Bakımı', 'Masaj', 'Manikür/Pedikür'];
  final List<String> daysOfWeek = ['Pazar', 'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi'];

  final List<String> skinCareOptions = ['Medikal Cilt Bakımı', 'Hydrafacial Cilt Bakımı'];

  // Saat seçme
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _goToNextPage(BuildContext context) {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || selectedDay == null || selectedTime == null || selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm bilgileri girin!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeautyExpertSelectionPage(
          selectedDay: selectedDay!,
          selectedTime: selectedTime!,
          selectedService: selectedService!,
          selectedSkinCareOption: selectedSkinCareOption,
          name: nameController.text,
          phone: phoneController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.female, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Güzellik Merkezi Randevu Sistemi',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10),
            Icon(Icons.palette, size: 30, color: Colors.white),
          ],
        ),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Adınız',
                labelStyle: TextStyle(color: Colors.pink),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Telefon Numaranız',
                labelStyle: TextStyle(color: Colors.pink),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedService,
              hint: Text('Hizmet Seçin', style: TextStyle(color: Colors.pink)),
              items: services.map((service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                  // Eğer cilt bakımı seçildiyse alt seçenekleri göster
                  if (selectedService == 'Cilt Bakımı') {
                    selectedSkinCareOption = null;
                  }
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedService == 'Cilt Bakımı')
              DropdownButton<String>(
                value: selectedSkinCareOption,
                hint: Text('Cilt Bakımı Seçin', style: TextStyle(color: Colors.pink)),
                items: skinCareOptions.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSkinCareOption = value;
                  });
                },
              ),
            SizedBox(height: 20),
            Text('Bir gün seçin:', style: TextStyle(fontSize: 18, color: Colors.pink)),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: daysOfWeek.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(daysOfWeek[index], style: TextStyle(color: Colors.pink)),
                    onTap: () {
                      setState(() {
                        selectedDay = daysOfWeek[index];
                      });
                    },
                    tileColor: selectedDay == daysOfWeek[index] ? Colors.pink[100] : Colors.transparent,
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                selectedTime == null
                    ? 'Bir saat seçin'
                    : 'Seçilen Saat: ${selectedTime!.format(context)}',
                style: TextStyle(fontSize: 18, color: Colors.pink),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _goToNextPage(context),
              child: Text('Güzellik Uzmanı Seç', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}

class BeautyExpertSelectionPage extends StatefulWidget {
  final String selectedDay;
  final TimeOfDay selectedTime;
  final String selectedService;
  final String? selectedSkinCareOption;
  final String name;
  final String phone;

  BeautyExpertSelectionPage({
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedService,
    this.selectedSkinCareOption,
    required this.name,
    required this.phone,
  });

  @override
  _BeautyExpertSelectionPageState createState() => _BeautyExpertSelectionPageState();
}

class _BeautyExpertSelectionPageState extends State<BeautyExpertSelectionPage> {
  String? selectedExpert;

  final List<String> experts = [
    'Ayşe Yılmaz', 'Fatma Demir', 'Emine Kara'
  ];

  void _bookAppointment() {
    if (selectedExpert == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir güzellik uzmanı seçin!')),
      );
      return;
    }

    // Randevu onayı
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Randevu Onayı', style: TextStyle(color: Colors.pink)),
          content: Text(
            'Ad: ${widget.name}\nTelefon: ${widget.phone}\nHizmet: ${widget.selectedService}\nGün: ${widget.selectedDay}\nSaat: ${widget.selectedTime.format(context)}\nUzman: $selectedExpert\n${widget.selectedService == 'Cilt Bakımı' && widget.selectedSkinCareOption != null ? 'Cilt Bakımı Seçeneği: ${widget.selectedSkinCareOption}' : ''}',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tamam', style: TextStyle(color: Colors.pink)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Güzellik Uzmanı Seçimi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Bir güzellik uzmanı seçin:', style: TextStyle(fontSize: 18, color: Colors.pink)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: experts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(experts[index], style: TextStyle(color: Colors.pink)),
                    onTap: () {
                      setState(() {
                        selectedExpert = experts[index];
                      });
                    },
                    tileColor: selectedExpert == experts[index] ? Colors.pink[100] : Colors.transparent,
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _bookAppointment,
              child: Text('Randevuyu Tamamla', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            ),
          ],
        ),
      ),
    );
  }
}
