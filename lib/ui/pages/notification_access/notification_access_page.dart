import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_usuario/ui/pages/home/home_page.dart';
import 'package:ride_usuario/ui/pages/notification_access/blocs/notification/notification_bloc.dart';

import '/utils/button.dart' as btn;

class NotificationAccessPage extends StatelessWidget {
  const NotificationAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
          return state.isAllNotificationGranted
              ? const HomePage()
              : const _EnableNotificationMessage();
        }),
      ),
    );
  }
}

class _EnableNotificationMessage extends StatelessWidget {
  const _EnableNotificationMessage();

  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Debe de habilitar las notificaciones'),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: btn.button(
            label: 'Habilitar Notificaciones',
            onPressed: () {
              final notificationBloc =
                  BlocProvider.of<NotificationBloc>(context);
              notificationBloc.askNotificationAccess();
            },
            type: 'black',
          ),
        ),
      ],
    );
  }
}
