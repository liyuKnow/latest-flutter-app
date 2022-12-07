import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSnackBar extends StatelessWidget {
  const CustomSnackBar(
      {super.key,
      required this.title,
      required this.message,
      required this.cardColor,
      required this.bubbleColor});

  final String title;
  final String message;
  final Color cardColor;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        message,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20)),
            child: SvgPicture.asset(
              "assets/icons/bubbles.svg",
              height: 48,
              width: 40,
              color: bubbleColor,
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                "assets/icons/fail.svg",
                height: 40,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  "assets/icons/close.svg",
                  height: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
