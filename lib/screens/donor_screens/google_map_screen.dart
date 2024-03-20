import 'dart:async';

import 'package:feed_me/utils/app_config.dart';
import 'package:feed_me/utils/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../utils/constants.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key, }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destinationLocation = LatLng(37.33429383, -122.06600055);

  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
      });
    });

    print("current location : $currentLocation");

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((event) {
      currentLocation = event;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 13.5,
            target: LatLng(event.latitude!, event.longitude!),
          ),
        ),
      );

      setState(() {});
    });
  }

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    print("Google Api Key : ${AppConfig.googleApiKey}");
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConfig.googleApiKey, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((element) {
        polylineCoordinates.add(
          LatLng(element.latitude, element.longitude),
        );
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
            height: 50.h,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
              color: gWhiteColor,
              border: Border.all(color: gBlackColor, width: 1),
            ),
            child:currentLocation == null
                ?  const Center(child: CircularProgressIndicator())
                :  GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("track"),
                  points: polylineCoordinates,
                  color: policyColor,
                  width: 6,
                ),
              },
              markers: {
                Marker(
                  markerId: const MarkerId("ourCurrentLocation"),
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                const Marker(
                  markerId: MarkerId("Staring point location "),
                  position: sourceLocation,
                ),
                const Marker(
                  markerId: MarkerId("End point location "),
                  position: destinationLocation,
                ),
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
          );
  }
}
