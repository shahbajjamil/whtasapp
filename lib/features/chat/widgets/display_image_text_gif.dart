import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/common/emuns/message_enum.dart';

class DisplayImageTextGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayImageTextGIF(
      {Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : CachedNetworkImage(imageUrl: message);
  }
}
