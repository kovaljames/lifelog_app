import 'package:flutter/material.dart';

class TDAvatar extends StatelessWidget {
  final String path;
  final double width;

  const TDAvatar({Key? key, required this.path, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width),
        image: DecorationImage(
          image: NetworkImage(path),
        ),
        color: Colors.black.withOpacity(0.2),
        // border: Border.all(
        //   width: 5,
        //   color: Colors.white.withOpacity(0.5),
        // ),
      ),
    );
  }
}
