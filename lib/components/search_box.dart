import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchBox({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.red.withOpacity(0.32),
          ),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            icon: SvgPicture.asset("assets/icons/search.svg"),
            hintText: "Search Here",
            hintStyle: TextStyle(color: Colors.red),
          ),
        )
        // TextField(
        //   onChanged: onChanged,
        //   decoration: InputDecoration(
        //     border: InputBorder.none,
        //     icon: SvgPicture.asset("assets/icons/search.svg"),
        //     hintText: "Search Here",
        //     hintStyle: TextStyle(color: ksecondaryColor1),
        //   ),
        // ),
        );
  }
}
