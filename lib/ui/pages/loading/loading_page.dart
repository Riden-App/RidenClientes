import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/ui/pages/pages.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GpsBloc, GpsState>(builder: (context, state) {
        return state.isAllGranted ? const HomePage() : const GpsAccessPage();
      }),
    );
  }
}
