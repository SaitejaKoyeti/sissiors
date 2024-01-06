import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> completedAppointments;

  const HistoryScreen({Key? key, required this.completedAppointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Appointments:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: completedAppointments.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> appointment = completedAppointments[index];
                  DateTime date = (appointment['selectedDate'] as Timestamp).toDate();
                  List<dynamic> selectedServicesAppointment = appointment['selectedServices'] ?? [];
                  List<String> selectedServices = selectedServicesAppointment
                      .map((service) => '${service['name']}-${service['price']}')
                      .toList();
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Name: ${appointment['name']}'),
                          Text('Phone Number: ${appointment['phoneNumber']}'),
                          Text('Booking Slot: ${appointment['selectedTimeSlots']}'),
                          Text('Selected Services: ${selectedServices.join(', ')}'),
                          Text('Total Amount: ${appointment['totalAmount']}'),
                          Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                        ],
                      ),
                      // Display services here
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedServicesAppointment.map((service) {
                          return Text(
                            'Service: ${service['name']}, Price: ${service['price']}',
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (completedAppointments.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  // Navigate to HistoryScreen with completed appointments
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(completedAppointments: [],),
                    ),
                  );
                },
                child: Text("View Completed Appointments"),
              ),
          ],
        ),
      ),
    );
  }
}
