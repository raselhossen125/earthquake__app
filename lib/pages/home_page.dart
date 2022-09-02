// ignore_for_file: use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  List<double> mtValue = [4, 5, 6, 7, 8, 9, 10];

  @override
  void didChangeDependencies() {
    if (isInit) {
      provider = Provider.of<EarthquakeProvider>(context);
      isInit = false;
    }
    super.didChangeDependencies();
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

  void goValueButton() {
    if (startDate == null) {
      showMsg(context, 'Please chose start date');
      return;
    }
    if (endDate == null) {
      showMsg(context, 'Please chose end date');
      return;
    }
    if (mt == null) {
      showMsg(context, 'Please chose mt value');
      return;
    }
    EasyLoading.show(
      status: 'Please Wait'
    );
    provider.setNewValue(st: startDate!, et: endDate!, mt: mt!);
    provider.getEarthquakeData();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<EarthquakeProvider>(
        builder: (context, value, child) => Column(
          children: [
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showStartDatePickerDialog(context);
                      },
                      child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  color: Colors.grey,
                                )
                              ]),
                          child: Center(
                            child: Text(
                              startDate == null ? "Start Date" : startDate!,
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showEndDatePickerDialog(context);
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: Colors.grey,
                              )
                            ]),
                        child: Center(
                          child: Text(
                            endDate == null ? 'End Date' : endDate!,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: Colors.grey,
                              )
                            ]),
                        child: DropdownButton(
                          hint: FittedBox(
                              child: Text(
                            'No Value ',
                            style: TextStyle(fontSize: 14),
                          )),
                          value: mt,
                          underline: Text(""),
                          dropdownColor: Colors.white,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 18),
                          items: mtValue.map((v) {
                            return DropdownMenuItem(
                              value: v,
                              child: Text(
                                v.toString(),
                                style: TextStyle(color: Colors.black),
                              ),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: goValueButton,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                spreadRadius: 1,
                                color: Colors.grey,
                              )
                            ]),
                        child: Center(
                          child: Text(
                            'Go',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            provider.earthquakeModel != null
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                          itemCount: provider.earthquakeModel!.features!.length,
                          itemBuilder: (context, index) {
                            final data =
                                provider.earthquakeModel!.features![index];
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  height: 60,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 0, bottom: 0, right: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 1,
                                                  color: Colors.grey,
                                                )
                                              ]),
                                          child: Text(
                                              data.properties!.mag.toString()),
                                        ),
                                        SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Wrap(
                                              children: [
                                                Text(
                                                  data.properties!.place == null
                                                      ? 'No Place'
                                                      : data.properties!.place!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  softWrap: false,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(getFormattedDateTime(
                                                data.properties!.time!,
                                                'yyyy-MM-dd   hh mm a')),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            );
                          }),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 330),
                      Center(
                        child: Text('No data found'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
