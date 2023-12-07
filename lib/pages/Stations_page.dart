import 'package:crowd_front_end/data_provider/power_share_data_provider.dart';
import 'package:crowd_front_end/models/power_share_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StationsTab extends ConsumerWidget {
  const StationsTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final _data = ref.watch(powerShareStationDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('test'),
      ),
      body: _data.when(
        data: (_data){
          List<PowerShareStationModel> powerShareStationList = _data.map((e) => e).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
            children: [
              Expanded(child: ListView.builder(
                itemCount: powerShareStationList.length,
                itemBuilder: (_,index){
                  return Card(
                    color: Colors.deepPurple,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(powerShareStationList[index].model, style: const TextStyle(
                        color: Colors.white
                      ),),
                      subtitle: Text("${powerShareStationList[index].lat} - ${powerShareStationList[index].lat}", style: const TextStyle(
                        color: Colors.white
                      ),),
                      trailing: Text(powerShareStationList[index].created.toString(), style: const TextStyle(
                        color: Colors.white
                      ),),
                    ),
                  );
                },
              ))
            ],
          ),
        );
          
        },
        error: (err, s)=> Text(err.toString()),
        loading: () => const Center(child: CircularProgressIndicator(),)),
    );
    
  }

}