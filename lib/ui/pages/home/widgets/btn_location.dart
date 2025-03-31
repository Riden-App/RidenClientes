import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';

class BtnLocation extends StatelessWidget {
  const BtnLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return CircleAvatar(
      maxRadius: 25,
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(
              Icons.my_location_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              final userLocation = state.lastKnowLocation;
              if (userLocation == null) return;

              mapBloc.moveCamera(userLocation);
            },
          );
        },
      ),
    );
  }
}
