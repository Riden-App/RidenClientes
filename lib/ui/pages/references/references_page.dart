import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_usuario/models/response/all_referred_detail_response.dart';
import 'package:ride_usuario/models/response/referred_user_referred.dart';
import 'package:ride_usuario/services/referred_service.dart';
import 'package:ride_usuario/services/shared_preferences_service.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/pages/references/views/ganancias_referred_page.dart';
import 'package:ride_usuario/ui/pages/references/views/refereces_list_page.dart';
import 'package:ride_usuario/ui/pages/references/views/references_pending_page.dart';
import 'package:share_plus/share_plus.dart';

import '/utils/button.dart' as btn;

class ReferencesPage extends StatefulWidget {
  const ReferencesPage({super.key});

  @override
  State<ReferencesPage> createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State<ReferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.black,
                        Color(0xff001A80),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 0.81],
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Mis referidos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/img/references.png',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  )),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
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
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.black04,
                          ),
                          child: TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            dividerColor: Colors.transparent,
                            unselectedLabelColor: AppColors.black,
                            labelColor: Colors.white,
                            tabs: [
                              Tab(text: 'Refiere'),
                              Tab(text: 'Referidos'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            RefiereTab(
                              scrollController: scrollController,
                            ),
                            ReferidoTab(
                              scrollController: scrollController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RefiereTab extends StatelessWidget {
  const RefiereTab({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario prefs = PreferenciasUsuario();

    void compartirTextoConEnlace() {
      final codigo = prefs.referralCode;

      final String mensaje = '''
Hola, instala esta app desde el siguiente enlace:
https://www.ejemplo.com/descargar

Cuando te registres, usa este código: $codigo
  ''';

      Share.share(mensaje);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              '¡Ganancias por cada viaje!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'En Rider It hemos creado un nuevo sistema de referidos, con el cual ganarás un pequeño porcentaje del costo total de cada viaje que tu referido realice.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Lo mejor es que esta ganancia es permanente, es decir, una vez hecha la referencia, seguirás generando este porcentaje todo el tiempo que tu referido use nuestro servicio.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 35),
            Text(
              'Se aplican términos y condiciones',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(height: 35),
            btn.button(
              label: 'Compartir enlace',
              onPressed: compartirTextoConEnlace,
              type: 'black',
            ),
            SizedBox(height: 10),
            btn.button(
              label: 'Invita a tus contactos',
              onPressed: () {
                Navigator.pushNamed(context, '/terms');
              },
              type: 'gray',
            ),
          ],
        ),
      ),
    );
  }
}

class ReferidoTab extends StatefulWidget {
  const ReferidoTab({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<ReferidoTab> createState() => _ReferidoTabState();
}

class _ReferidoTabState extends State<ReferidoTab> {
  ReferredService referredService = ReferredService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  List<DataReferred> referidos = [];
  String countIdUserWithoutTripCompleted = '';
  String countIdUserWithTripCompleted = '';
  String totalAmount = '';
  List userWithoutTripCompleted = [];
  bool isLoading = false;

  Future<void> getReferreds() async {
    setState(() {
      isLoading = true;
    });

    final idUser = prefs.idUser;
    try {
      final result = await referredService.getAllReferreds(idUser);
      if (result.isSuccess) {
        setState(() {
          countIdUserWithoutTripCompleted =
              result.data!.data.countIdUserWithoutTripCompleted.toString();
          countIdUserWithTripCompleted =
              result.data!.data.countIdUserWithTripCompleted.toString();
          totalAmount = result.data!.data.totalAmount.totalAmount.toString();
          userWithoutTripCompleted = result.data!.data.userWithoutTripCompleted;
          isLoading = false;
        });
      } else {
        print('Error getReferreds: ${result.error}');
      }
    } catch (e) {
      print('Error getReferreds: ${e}');
    }
  }

  Future<void> getReferredCommision() async {
    final idUser = prefs.idUser;
    final result = await referredService.getReferralCommisionGroup(idUser);
    if (result.isSuccess) {
      setState(() {
        referidos = result.data!.data;
      });
    } else {
      print('Error getReferreds: ${result.error}');
    }
  }

  @override
  void initState() {
    super.initState();
    getReferreds();
    getReferredCommision();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("d 'de' MMM", 'es');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GananciasReferidosPage(
                                    balance: totalAmount,
                                  )));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.black03,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ganancias',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20,
                              )
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('S/$totalAmount ',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blue,
                                        )),
                                    Text(
                                      'Ganados',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black60,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(countIdUserWithTripCompleted,
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.black,
                                        )),
                                    Text(
                                      'Referidos',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black60,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          btn.button(
                              label: 'Retirar dinero',
                              onPressed: () {},
                              type: 'black')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReferencesPendingPage(
                                    users: userWithoutTripCompleted,
                                  )));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.black03,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Inactivos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 20,
                                )
                              ],
                            ),
                            SizedBox(height: 30),
                            Text(
                              countIdUserWithoutTripCompleted,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                            ),
                            Text(
                              'Amigos aún evaluando tu solicitud',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black60,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        )),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Últimas referencias',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReferencesListAllPage(
                                        users: referidos,
                                      )));
                        },
                        child: Text(
                          'Ver todos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: referidos.length,
                    itemBuilder: (context, index) {
                      final referido = referidos[index];
                      final formatterDate = formatDate(referido.referredDate);

                      return ListTile(
                        title: Text(
                          '${referido.referred.firstName} ${referido.referred.lastName}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Referido desdes $formatterDate.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black60,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: AppColors.black10,
                        thickness: 1,
                      );
                    },
                  )
                ],
              ),
            ),
    );
  }
}
