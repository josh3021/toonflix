import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/webtoon_episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final WebtoonModel webtoon;

  const DetailScreen({
    super.key,
    required this.webtoon,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static const _likedWebtoonsKey = 'likedWebtoons';
  late Future<WebtoonDetailModel> webtoonDetail;
  late Future<List<WebtoonEpisodeModel>> webtoonEpisodes;
  late SharedPreferences preferences;
  bool _isLiked = false;

  Future initPreferences() async {
    preferences = await SharedPreferences.getInstance();
    final likedWebtoons = preferences.getStringList(_likedWebtoonsKey);
    if (likedWebtoons == null) {
      return await preferences.setStringList(_likedWebtoonsKey, []);
    }
    if (likedWebtoons.contains(widget.webtoon.id)) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  onHeartTap() async {
    final likedWebtoons = preferences.getStringList(_likedWebtoonsKey);
    if (likedWebtoons != null) {
      _isLiked
          ? likedWebtoons.remove(widget.webtoon.id)
          : likedWebtoons.add(widget.webtoon.id);
      await preferences.setStringList(_likedWebtoonsKey, likedWebtoons);
      setState(() {
        _isLiked = !_isLiked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    webtoonDetail = ApiService.getWebtoonById(widget.webtoon.id);
    webtoonEpisodes = ApiService.getLatestEpisodesById(widget.webtoon.id);
    initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF19CE60),
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_outline),
          ),
        ],
        title: Text(
          widget.webtoon.title,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.webtoon.id,
                  child: Container(
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          offset: const Offset(10, 10),
                          color: Colors.black87.withOpacity(0.3),
                        ),
                      ],
                    ),
                    child: Image.network(widget.webtoon.thumb),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              future: webtoonDetail,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        spacing: 5,
                        children: [
                          Text(snapshot.data!.genre),
                          const Text('/'),
                          Text(snapshot.data!.age),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  );
                }
                return const Text('...');
              },
            ),
            FutureBuilder(
              future: webtoonEpisodes,
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (var episode in snapshot.data!)
                        WebtoonEpisodeWidget(
                            episode: episode, webtoonId: widget.webtoon.id)
                    ],
                  );
                }
                return Container();
              }),
            ),
          ]),
        ),
      ),
    );
  }
}
