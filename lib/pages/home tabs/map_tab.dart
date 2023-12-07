import 'package:crowd_front_end/data_provider/power_share_data_provider.dart';
import 'package:crowd_front_end/models/power_share_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapTab extends ConsumerStatefulWidget {
  const MapTab({super.key});

  @override
  ConsumerState<MapTab> createState() => _MapTab();
}

class _MapTab extends ConsumerState<MapTab> with OSMMixinObserver {
  late MapController mapcontroller;
  //23.02756018230479, 72.58131973941731
  //23.02726396414328, 72.5851928489523

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapcontroller = MapController(
      initPosition:
          GeoPoint(latitude: 23.02756018230479, longitude: 8.4737324),
    );

    mapcontroller.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _data = ref.watch(powerShareStationDataProvider);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          OSMFlutter(
            controller: mapcontroller,
            osmOption: OSMOption(
                
                enableRotationByGesture: true,
                zoomOption: const ZoomOption(
                  initZoom: 8,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                staticPoints: [],
                roadConfiguration: const RoadOption(
                  roadColor: Colors.blueAccent,
                ),
                markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 56,
                    ),
                  ),
                ),
                showDefaultInfoWindow: false,
                userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
            ),
            onMapIsReady: (isReady) {
              if (isReady) {
                print("map is ready");
                mapcontroller.currentLocation();
                mapcontroller.enableTracking();
              }
            },
            onLocationChanged: (myLocation) {
              print("user location :$myLocation");
            },
            onGeoPointClicked: (myLocation) {
              print("GeoPointClicked location :$myLocation");
            },
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.15,
            maxChildSize: 0.8,

            builder: (context, controller) => ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
              color: Colors.white70,
              child: Scaffold(
                body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                      children: [    
                        _data.when(
                          data: (_data){
                            List<PowerShareStationModel> powerShareStationList = _data.map((e) => e).toList();
                            return
                        Expanded(child: ListView.builder(
                          controller: controller,
                          itemCount: powerShareStationList.length,
                          itemBuilder: (_,index){
                            addMarker(powerShareStationList[index]);
                            return Card(
                              color: Colors.deepPurple,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(powerShareStationList[index].model, style: const TextStyle(
                                  color: Colors.white
                                ),),
                                subtitle: Text("${powerShareStationList?[index].lat} - ${powerShareStationList[index].lat}", style: const TextStyle(
                                  color: Colors.white
                                ),),
                                trailing: Text(powerShareStationList[index].created.toString(), style: const TextStyle(
                                  color: Colors.white
                                ),),
                              ),
                            );
                          },
                        ));      },
      error: (err, s)=> Text(err.toString()),
      loading: () => const Center(child: CircularProgressIndicator(),))
                          
                      ],
                    ),
                        
              ),
            ),
            ) 
          ))
        ],
      ),
    );
  }

    void addMarker(PowerShareStationModel station) async {
    await mapcontroller.setMarkerOfStaticPoint(
      id: station.model,
      markerIcon: MarkerIcon(
        iconWidget: Image.asset(
          "assets/img/pickup_pin.png",
          width: 80,
          height: 80,
        ),
      ),
    );

    await mapcontroller.setStaticPosition(
        [GeoPoint(latitude: station.lat, longitude: station.lon)],
        station.model);
  }
  
  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      // await mapcontroller.currentLocation();
      // await mapcontroller.enableTracking();
    }
  }
}
