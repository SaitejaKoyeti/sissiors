import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sissiors/homescreen/service_list.dart';

import '../Stylistdata/smain.dart';




class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
  void navigateToListScreen(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListScreen()));
  }
}
class _ListScreenState extends State<ListScreen> {
  List<Services> selectedServices = [];
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: TextTheme()),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
              ),
              child:Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 10, 10, 0),
                      ),
                      Image.asset(
                        'assets/Scissors-image-remove.png',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  Row(
                      children: [
                        Padding(padding: EdgeInsets.symmetric(horizontal: 17.0)),
                        Text(
                          "Scissor's",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Services",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      itemCount: ServicesList.length,
                      itemBuilder: (context, index) {
                        Services service = ServicesList[index];
                        return Column(
                          children: [
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          service.images,
                                          height: 55,
                                          width: 85,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.name,
                                              style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              service.price,
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      service.description,
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      ),
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      _toggleService(service);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: selectedServices.contains(service)
                                          ? Colors.brown[400]
                                          : Colors.brown[800],
                                    ),
                                    child: Text(
                                      selectedServices.contains(service) ? 'Remove' : 'Add',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ) ;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  void _toggleService(Services service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
        totalAmount -=
            double.tryParse(service.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
                0.0;
      } else {
        selectedServices.add(service);
        totalAmount +=
            double.tryParse(service.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
                0.0;
      }
    });
    _showSelectedServices(context);
  }
  void _showSelectedServices(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.brown.withOpacity(0.5),
                        Colors.brown.withOpacity(0.7),
                        Colors.brown.withOpacity(0.9),
                        Colors.brown.withOpacity(0.7),
                        Colors.brown.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selected Services',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        endIndent: 15,
                        indent: 15,
                        color: Colors.white,
                      ),
                      for (Services service in selectedServices) ...[
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.name,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: .5,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 1),
                            Text(
                              service.price,
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: .5,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 16),
                      Text(
                        'Total Amount : Rs. $totalAmount/-',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            letterSpacing: .5,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Conditionally render RawMaterialButton
                      if (totalAmount > 0)
                        RawMaterialButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp1(
                              selectedServices:selectedServices,
                              totalAmount:totalAmount,
                            )));
                          },
                          fillColor: Colors.brown[900],
                          constraints: BoxConstraints(maxHeight: 100),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Book',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: .6,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}