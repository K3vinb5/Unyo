import 'package:flutter/material.dart';
import 'package:flutter_nime/api/anilist_api.dart';

class AnimeButton extends StatefulWidget {
  const AnimeButton({super.key, required this.text, required this.onTap});

  final String text;
  final void Function() onTap;

  @override
  State<AnimeButton> createState() => _AnimeButtonState();
}

class _AnimeButtonState extends State<AnimeButton> {
  String? bannerImageUrl;

  @override
  void initState() {
    super.initState();
    getBanner();
  }

  void getBanner() async {
    String? newUrl;
    while (newUrl == null){
      newUrl = await getRandomAnimeBanner();
    }
    setState(() {
      bannerImageUrl = newUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return bannerImageUrl != null
        ? InkWell(
      onTap: widget.onTap,
      child: Container(
        //TODO check percentages
        alignment: Alignment.center,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.12,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.1,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.transparent, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            opacity: 0.35,
            image: NetworkImage(
              bannerImageUrl!,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    )
        : const SizedBox();
  }
}
