import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_usuario/services/services.dart';
import 'package:ride_usuario/themes/themes.dart';

import '/utils/button.dart' as btn;

void showDetailTripBottomSheet(BuildContext context) {
  PreferenciasUsuario prefs = PreferenciasUsuario();

  final TextEditingController detailController = TextEditingController();
  detailController.text = prefs.detailTrip;

  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();

  // List<Contact> allContacts = [];

  // Future<bool> requestContactPermission() async {
  //   final status = await Permission.contacts.status;
  //   if (status.isGranted) {
  //     return true;
  //   } else if (status.isDenied || status.isRestricted) {
  //     final result = await Permission.contacts.request();
  //     return result.isGranted;
  //   }
  //   return false;
  // }

  // Future<void> _fetchContacts(Function setModalState) async {
  //   final hasPermission = await requestContactPermission();
  //   if (!hasPermission) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('No se concedió permiso para acceder a los contactos'),
  //       ),
  //     );
  //     return;
  //   }
  //   try {
  //     final contacts = await ContactsService.getContacts();
  //     setModalState(() {
  //       allContacts = contacts
  //           .where((contact) =>
  //               contact.phones != null && contact.phones!.isNotEmpty)
  //           .toList();
  //     });
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error al obtener contactos: $e'),
  //       ),
  //     );
  //   }
  // }

  // void _showContactPicker(TextEditingController controller) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setModalState) {
  //           _fetchContacts(setModalState);
  //           return Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   width: 60,
  //                   height: 6,
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey[300],
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 Expanded(
  //                   child: allContacts.isEmpty
  //                       ? Center(child: Text('No se encontraron contactos'))
  //                       : Scrollbar(
  //                           thumbVisibility: true,
  //                           child: ListView.builder(
  //                             itemCount: allContacts.length,
  //                             itemBuilder: (context, index) {
  //                               final contact = allContacts[index];
  //                               return ListTile(
  //                                 leading: CircleAvatar(
  //                                   backgroundColor: Colors.blue,
  //                                   child: Text(
  //                                     contact.initials(),
  //                                     style: TextStyle(color: Colors.white),
  //                                   ),
  //                                 ),
  //                                 title:
  //                                     Text(contact.displayName ?? 'Sin nombre'),
  //                                 subtitle:
  //                                     Text(contact.phones!.first.value ?? ''),
  //                                 onTap: () {
  //                                   controller.text =
  //                                       contact.phones!.first.value ?? '';
  //                                   Navigator.pop(context);
  //                                 },
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    builder: (context) {
      return SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
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
                        Expanded(
                            child: Text(
                          prefs.tripType == 'passenger'
                              ? 'Detalles de viaje'
                              : 'Detalles de envío',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        )),
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
                    prefs.tripType == 'passenger'
                        ? SizedBox()
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: AppColors.black10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/img/phone.svg',
                                      ),
                                      SizedBox(
                                          width:
                                              15), // Espacio entre el ícono y el contenido
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nro del remitente',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black60,
                                              ),
                                            ),
                                            TextField(
                                              controller: senderController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Teléfono del receptor',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // GestureDetector(
                              //   onTap: () =>
                              //       _showContactPicker(senderController),
                              //   child: CircleAvatar(
                              //     maxRadius: 25,
                              //     backgroundColor: Color(0xffF5F5F7),
                              //     child: Image.asset('assets/img/contacts.png'),
                              //   ),
                              // ),

                              CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Color(0xffF5F5F7),
                                child: Image.asset('assets/img/contacts.png'),
                              ),
                            ],
                          ),
                    prefs.tripType == 'passenger'
                        ? SizedBox()
                        : SizedBox(
                            height: 10,
                          ),
                    prefs.tripType == 'passenger'
                        ? SizedBox()
                        : Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                    border: Border.all(
                                      color: AppColors.black10,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/img/phone.svg',
                                      ),
                                      SizedBox(
                                          width:
                                              15), // Espacio entre el ícono y el contenido
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nro del receptor',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.black60,
                                              ),
                                            ),
                                            TextField(
                                              controller: receiverController,
                                              keyboardType: TextInputType.phone,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Teléfono del receptor',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // GestureDetector(
                              //   onTap: () =>
                              //       _showContactPicker(receiverController),
                              //   child: CircleAvatar(
                              //     maxRadius: 25,
                              //     backgroundColor: Color(0xffF5F5F7),
                              //     child: Image.asset('assets/img/contacts.png'),
                              //   ),
                              // ),
                              CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Color(0xffF5F5F7),
                                child: Image.asset('assets/img/contacts.png'),
                              ),
                            ],
                          ),
                    SizedBox(height: 27),
                    prefs.tripType == 'delivery'
                        ? Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Detalles del paquete',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(height: 24),
                    SizedBox(height: 15),
                    TextField(
                      controller: detailController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Deja un comentario para el conductor',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black60,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: AppColors.black10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 27),
                    btn.button(
                        label: 'Confirmar',
                        onPressed: () {
                          prefs.detailTrip = detailController.text.trim();

                          prefs.contactEmisor = senderController.text.trim();
                          prefs.contacReceptor = receiverController.text.trim();
                          Navigator.pop(context);
                        },
                        type: 'black'),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).whenComplete(() {
    prefs.detailTrip = detailController.text.trim();
  });
}
