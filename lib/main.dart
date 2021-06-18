import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<Polyline> polyline = {};
  LatLng _initialcameraposition = LatLng(35.6892, 51.3890);
  GoogleMapController _controller;
  List<LatLng> routeCoords = [];
  List<Marker> routeMarkers = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    getSomePoints();
  }

  getSomePoints() async {
    routeMarkers.add(
      Marker(
        markerId: MarkerId('1'),
        visible: true,
        draggable: false,
        position: LatLng(35.692123, 51.374693),
        infoWindow: InfoWindow(title: 'Origin'),
      ),
    );
    routeMarkers.add(
      Marker(
        markerId: MarkerId('1'),
        visible: true,
        draggable: false,
        position: LatLng(35.700714, 51.389991),
        infoWindow: InfoWindow(title: 'Destination'),
      ),
    );
    var permissionStatus = await LocationPermissions().checkPermissionStatus();
    if (permissionStatus != PermissionStatus.granted) {
      await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.location);
    }
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyC8mGOuPNi6dsJtLF2H_eT0QMuOWw5oCCo',
      PointLatLng(35.692123, 51.374693),
      PointLatLng(35.700714, 51.389991),
    );

    routeCoords = result.points
        .map(
          (e) => LatLng(
            e.latitude,
            e.longitude,
          ),
        )
        .toList();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void setPolyLine() {
    setState(() {
      polyline.add(Polyline(
        polylineId: PolylineId('1'),
        visible: true,
        points: routeCoords,
        width: 4,
        color: Colors.blue,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialcameraposition,
          zoom: 12,
        ),
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        polylines: polyline,
        markers: Set.from(routeMarkers),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: setPolyLine,
        child: Icon(Icons.directions),
      ),
    );
  }
}
