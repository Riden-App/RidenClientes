import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';

import '/utils/button.dart' as btn;

class GpsAccessPage extends StatelessWidget {
  const GpsAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
          return !state.isGpsEnabled ? _EnableGpsMessage() : _AccessButton();
        }),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Es necesario el acceso a GPS'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: btn.button(
            label: 'Solicitar Acceso',
            onPressed: () {
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
            },
            type: 'black',
          ),
        ),
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage();

  @override
  Widget build(BuildContext context) {
    return Text('Debe de habilitar el GPS');
  }
}
