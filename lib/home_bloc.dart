// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeBloc {
  var latCtrl = TextEditingController(text: '');
  var lngCtrl = TextEditingController(text: '');
  var nameCtrl = TextEditingController(text: '');
  var loadingCtrl = StreamController<bool>.broadcast();

  getLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      loadingCtrl.sink.add(true);
      try {
        Position _position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        latCtrl.text = _position.latitude.toString();
        lngCtrl.text = _position.longitude.toString();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }

      loadingCtrl.sink.add(false);
    }
  }

  bool isValid(BuildContext context) {
    if (nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please Enter Name')));
      return false;
    }
    if (latCtrl.text.isEmpty && lngCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please Get Location')));
      return false;
    }
    return true;
  }

  showDetails(BuildContext context) {
    if (isValid(context)) {
      showDialog(
          context: context,
          builder: (context) => Dialog(
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'User Details',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(nameCtrl.text))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Latitude: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(latCtrl.text))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Longitude: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(lngCtrl.text))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
    }
  }
}
