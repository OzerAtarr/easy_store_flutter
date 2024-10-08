import 'package:flutter/material.dart';

class HomepageCategoryWidget extends StatefulWidget {
   const HomepageCategoryWidget({
     super.key,
     required this.title,
     required this.imageUrl
   });

   final String title;
   final String imageUrl;

  @override
  State<HomepageCategoryWidget> createState() => _HomepageCategoryWidgetState();
}

class _HomepageCategoryWidgetState extends State<HomepageCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          if(widget.imageUrl.isNotEmpty) Image.network(
            widget.imageUrl,
            width: 50,
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(widget.title),
        ],
      ),
    );
  }
}
