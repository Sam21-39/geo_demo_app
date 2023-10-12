import 'package:flutter/material.dart';
import 'package:geo_demo_app/home_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeBloc? _homeBloc;
  @override
  void initState() {
    super.initState();

    _homeBloc = HomeBloc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            _ui(),
            _loading(),
          ],
        ),
      ),
    );
  }

  _loading() {
    return StreamBuilder<bool>(
        stream: _homeBloc!.loadingCtrl.stream,
        initialData: false,
        builder: (context, load) {
          if (load.data as bool) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
          return Container();
        });
  }

  _ui() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _homeBloc!.nameCtrl,
            decoration: const InputDecoration(
              hintText: 'Enter Name',
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  controller: _homeBloc!.latCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Latitude',
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  readOnly: true,
                  controller: _homeBloc!.lngCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Longitude',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          ElevatedButton(
            onPressed: () {
              _homeBloc!.getLocation(context);
            },
            child: const Text('Get Location'),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              _homeBloc!.showDetails(context);
            },
            child: const Text('Get UserInfo'),
          ),
        ],
      ),
    );
  }
}
