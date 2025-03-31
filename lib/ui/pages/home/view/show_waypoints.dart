import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/blocs/blocs.dart';
import 'package:ride_usuario/themes/themes.dart';
import 'package:ride_usuario/ui/widgets/widgets.dart';

void showWaypointsBottomSheet(BuildContext context, String destinationName) {
  final mapBloc = BlocProvider.of<MapBloc>(context);
  final searchBloc = BlocProvider.of<SearchBloc>(context);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Row(
                children: [
                  Opacity(
                    opacity: 0,
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: Color(0xffF5F5F7),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Destinos',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CircleAvatar(
                    maxRadius: 25,
                    backgroundColor: Color(0xffF5F5F7),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.blue,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 39),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: BlocProvider.value(
                    value: mapBloc,
                    child: BlocProvider.value(
                        value: searchBloc,
                        child:
                            ListWaypoints(destinationName: destinationName))),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() {
  });
}
