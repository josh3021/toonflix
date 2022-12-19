import 'package:flutter/material.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebtoonEpisodeWidget extends StatelessWidget {
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const WebtoonEpisodeWidget({
    Key? key,
    required this.episode,
    required this.webtoonId,
  }) : super(key: key);

  onButtonTap() async {
    await launchUrlString(
        'https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: const Color(0xFF19CE60),
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(3.5, 3.5),
                blurRadius: 5.5,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                episode.title,
                style: const TextStyle(
                  color: Color(0xFF19CE60),
                  fontSize: 16,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF19CE60),
              )
            ],
          ),
        ),
      ),
    );
  }
}
