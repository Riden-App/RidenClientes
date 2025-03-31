import 'package:flutter/material.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/themes/colors.dart';

class SwitchTypeTrip extends StatefulWidget {
  const SwitchTypeTrip({
    super.key,
    required this.isViajeActive,
    required this.onChanged,
  });

  final bool isViajeActive;
  final ValueChanged<bool> onChanged;

  @override
  State<SwitchTypeTrip> createState() => _SwitchTypeTripState();
}

class _SwitchTypeTripState extends State<SwitchTypeTrip> {
  late bool isViajeActive;
  PreferenciasUsuario prefs = PreferenciasUsuario();
  @override
  void initState() {
    super.initState();
    isViajeActive = widget.isViajeActive;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 41.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.black03,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              alignment:
                  isViajeActive ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 41,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isViajeActive = true;
                      });
                      prefs.tripType = 'passenger';
                      widget.onChanged(true);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Viaje',
                            style: TextStyle(
                                color:
                                    isViajeActive ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            child: Center(
                              child: Image.asset(
                                'assets/img/tripTypePassenger.png',
                                color:
                                    isViajeActive ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isViajeActive = false;
                      });
                      prefs.tripType = 'delivery';
                      widget.onChanged(false);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Envíos',
                            style: TextStyle(
                                color: !isViajeActive
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          SizedBox(
                            width: 20,
                            child: Center(
                              child: Image.asset(
                                'assets/img/tripTypeDelivery.png',
                                color: !isViajeActive
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
