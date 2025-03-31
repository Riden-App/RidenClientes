import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return CircleAvatar(
      maxRadius: 25,
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return IconButton(
            icon: Icon(
              state.isFollowingUser
                  ? Icons.directions_run_rounded
                  : Icons.hail_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              mapBloc.add(OnStartFollowingUserEvent());
            },
          );
        },
      ),
    );
  }
}
