import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/themes/colors.dart';
import 'package:ride_usuario/ui/widgets/menu.dart';

class MethodPaymentPage extends StatefulWidget {
  const MethodPaymentPage({super.key});

  @override
  State<MethodPaymentPage> createState() => _MethodPaymentPageState();
}

class _MethodPaymentPageState extends State<MethodPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showMenuBottonSheet(context);
                    },
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.black03,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                          child: Icon(
                        Icons.menu,
                        color: AppColors.blue,
                      )),
                    ),
                  )
                ],
              ),
              Text(
                'Medios de pago adicionales',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 29),
              Row(
                children: [
                  Text(
                    'Tarjetas débito/crédito',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black60,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ListTile(
                trailing: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: SvgPicture.asset('assets/img/arrow_right.svg'),
                  ),
                ),
                title: Text(
                  'Débito 4213',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Color(0xFF1D52B9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/img/visa.svg'),
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: AppColors.black10,
              ),
              ListTile(
                trailing: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: SvgPicture.asset('assets/img/arrow_right.svg'),
                  ),
                ),
                title: Text(
                  'Nueva tarjeta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: SvgPicture.asset('assets/img/card.svg'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
