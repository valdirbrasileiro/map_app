import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../commons/utils/navigation_utils.dart';
import '../../data/data.dart';
import '../presentation.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with DependencyMixin, WidgetsBindingObserver {
  bool? islocationChecked = false;
  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() async {
      WidgetsBinding.instance.addObserver(this);
      checkLocationStatus();
      await getLocationProcess();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getLocationProcess();
    }
  }

  Future<void> checkLocationStatus() async {
    final locationPermissionStatus =
        await dependencies.locationStore.canAccessLocation();
    setState(() {
      islocationChecked = locationPermissionStatus;
    });
  }

  Future<void> getLocationProcess() async {
    try {
      final locationPermissionStatus =
          await dependencies.locationStore.canAccessLocation();

      if (!locationPermissionStatus) {
        final isConnected =
            await dependencies.connectionStore.checkConnectivity();
        if (isConnected) {
          final ip = await dependencies.connectionStore.getIp();
          if (ip.isNotEmpty) {
            await dependencies.locationStore.getLocationFromApi(ip);
          } else {
            navigateToNamed('/generic_error',
                arguments: dependencies.connectionStore.error.value);
          }
        }
      } else {
        await dependencies.locationStore.getCoordinates();
      }
      setState(() {
        islocationChecked = locationPermissionStatus;
      });
    } on NotFoundException catch (e) {
      navigateToNamed('/generic_error', arguments: e.toString());
    } on NotFoundConnection catch (e) {
      navigateToNamed('/generic_error', arguments: e.toString());
    } catch (e) {
      navigateToNamed('/generic_error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            dependencies.locationStore.currentPosition.value != null
                ? FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        mapController.move(
                            dependencies.locationStore.currentPosition.value!,
                            15); 
                      });
                    },
                    child: const Icon(Icons.center_focus_strong),
                  )
                : const SizedBox.shrink(),
        appBar: AppBar(
            shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(75),
                    bottomRight: Radius.circular(75))),
            automaticallyImplyLeading: false,
            actions: [
              const Text('Location'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Toggle(
                  isSelected: islocationChecked ?? false,
                  toggleFunction: (toggleChecked) {
                    dependencies.locationStore
                        .requestPermission(toggleChecked: toggleChecked);
                  },
                ),
              )
            ]),
        extendBodyBehindAppBar: true,
        body: AnimatedBuilder(
          animation:
              Listenable.merge([dependencies.locationStore.currentPosition]),
          builder: (context, child) {
            return dependencies.locationStore.currentPosition.value == null
                ? Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: lottie.Lottie.asset(
                          "assets/loading.json",
                          repeat: true,
                          animate: true,
                          reverse: false,
                        )),
                  )
                : Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter:
                              dependencies.locationStore.currentPosition.value!,
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              tileProvider: CachedNetworkTileProvider()),
                          MarkerLayer(
                            markers: [
                              Marker(
                                  point: dependencies
                                      .locationStore.currentPosition.value!,
                                  width: 40,
                                  height: 40,
                                  child: const PointMarker(
                                    radius: 50.0,
                                    gradientColors: [
                                      Colors.lightBlueAccent,
                                      Colors.lightBlue,
                                      Colors.blue,
                                      Colors.lightBlue,
                                      Colors.lightBlueAccent,
                                    ],
                                    borderWidth: 1.0,
                                    borderColor: Colors.blueAccent,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
          },
        ));
  }
}

class CachedNetworkTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return CachedNetworkImageProvider(getTileUrl(coordinates, options));
  }
}
