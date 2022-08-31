
// ignore_for_file: use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/earthquake_provider.dart';
import '../utils/helperFunction.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late EarthquakeProvider provider;
  bool isInit = true;
  String? startDate;
  String? endDate;
  double? mt;
  List<double> mtValue = [
    4,5,6,7,8,9,10
  ];

  @override
  void didChangeDependencies() {
    if (isInit) {
      provider = Provider.of<EarthquakeProvider>(context);
      // _getData();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  void _getData() {
    try {
      provider.setNewValue(st: '2022-08-29', et: '2022-08-30', mt: 5);
      provider.getEarthquakeData();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> showStartDatePickerDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        startDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> showEndDatePickerDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        endDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earthquake List'),
      ),
      body: Consumer<EarthquakeProvider>(
        builder: (context, value, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showStartDatePickerDialog(context);
                      },
                      child: Container(
                        height: 60,
                        color: Colors.black,
                        child: Center(child: Text(
                          startDate == null ?  "No Chossen" : startDate!,
                          style: TextStyle(color: Colors.white),
                        ),)
                      ),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showEndDatePickerDialog(context);
                      },
                      child: Container(
                        height: 60,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            endDate == null ? 'no chosen' : endDate!,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () {

                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        color: Colors.red,
                        child: DropdownButton(
                          value: mt,
                          underline: Text(""),
                          dropdownColor: Colors.white,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                              fontSize: 18),
                          items: mtValue.map((v) {
                            return DropdownMenuItem(
                              value: v,
                              child: Text(v.toString(), style: TextStyle(color: Colors.black),),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              mt = newValue as double?;
                            });
                          },
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        provider.setNewValue(st: startDate!, et: endDate!, mt: mt!);
                        provider.getEarthquakeData();
                      },
                      child: Container(
                        height: 60,
                        color: Colors.black,
                        child: Center(child: Text('Go', style: TextStyle(color: Colors.white),),),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            provider.earthquakeModel != null
                ? Expanded(
                    child: ListView.builder(
                        itemCount: provider.earthquakeModel!.features!.length,
                        itemBuilder: (context, index) {
                          final data =
                              provider.earthquakeModel!.features![index];
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(data.properties!.place == null ? 'No Place' : data.properties!.place!),
                              subtitle: Text(getFormattedDateTime(
                                  data.properties!.time!,
                                  'yyyy-MM-dd hh mm a')),
                              trailing: Text(data.properties!.mag.toString()),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text('No Data Found'),
                  ),
          ],
        ),
      ),
    );
  }
}
