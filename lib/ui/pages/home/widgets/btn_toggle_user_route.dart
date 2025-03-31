import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';

class BtnToggleUserRoute extends StatelessWidget {
  const BtnToggleUserRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return CircleAvatar(
        maxRadius: 25,
        child: IconButton(
          icon: Icon(
            Icons.more_horiz_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            mapBloc.add(OnToggleUserRouteEvent());
          },
        ));
  }
}
