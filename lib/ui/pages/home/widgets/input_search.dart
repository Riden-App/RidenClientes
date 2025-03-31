import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ride_usuario/enums/enums.dart';
import 'package:ride_usuario/themes/themes.dart';

class InputFormSearch extends StatefulWidget {
  const InputFormSearch(
      {super.key, required this.type, required this.controller});
  final TypeMarket type;
  final TextEditingController controller;

  @override
  _InputFormSearchState createState() => _InputFormSearchState();
}

class _InputFormSearchState extends State<InputFormSearch> {
  final FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasFocus ? AppColors.black : AppColors.black10,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          widget.type == TypeMarket.waypoints
              ? Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,

                      ),
                    ),
                  ),
                )
              : CircleAvatar(
                  backgroundColor: widget.type == TypeMarket.origin
                      ? AppColors.blue15
                      : AppColors.green15,
                  child: SvgPicture.asset(
                    widget.type == TypeMarket.origin
                        ? 'assets/img/arrow_warm_up.svg'
                        : 'assets/img/arrow_cool_down.svg',
                    colorFilter: ColorFilter.mode(
                        widget.type == TypeMarket.origin
                            ? AppColors.blue
                            : AppColors.green,
                        BlendMode.srcIn),
                    width: 24,
                    height: 24,
                  )),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.type == TypeMarket.origin ? 'Desde' : 'Hacia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black60,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Ingrese dirección',
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: AppColors.black),
              onPressed: () {
                widget.controller.clear();
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
