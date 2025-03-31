import 'package:flutter/material.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/ui/widgets/animate_search.dart';

class DetailTripPage extends StatefulWidget {
  const DetailTripPage({super.key});

  @override
  State<DetailTripPage> createState() => _DetailTripPageState();
}

class _DetailTripPageState extends State<DetailTripPage> {
  PreferenciasUsuario prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(prefs.lugarInicio, style: TextStyle(fontSize: 20)),
            Text(prefs.lugarFin, style: TextStyle(fontSize: 20)),
            Text(prefs.ltLnInicio, style: TextStyle(fontSize: 20)),
            Text(prefs.ltLnFin, style: TextStyle(fontSize: 20)),
            Text('S/${prefs.oferta}', style: TextStyle(fontSize: 20)),
            Text(prefs.categoryTrip, style: TextStyle(fontSize: 20)),
            Text(prefs.paymentMethod, style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 200 ,
              child: InfiniteBubbleAnimation())
          ],
        ),
      )),
    );
  }
}
