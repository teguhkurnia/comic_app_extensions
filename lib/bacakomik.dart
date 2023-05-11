/// Support for doing something awesome.
///
/// More dartdocs go here.
library bacakomik;

import 'package:comic_app_core/comic_app_core.dart';
import 'package:html/dom.dart';
import 'package:dio/src/response.dart';
import 'package:comic_app_core/src/models/chapter_detail.dart';

class BacaKomik extends OnlineSource {
  BacaKomik()
      : super(
          baseUrl: "https://bacakomik.co",
          latestUpdateComicSelector: ".animepost",
          latestUpdateNextPageSelector: "a.next",
        );

  @override
  Comic latestUpdateFromElement(Element element) {
    return Comic(
        element.getElementsByTagName("h4")[0].text,
        element.getElementsByTagName("img")[0].attributes['src'] ?? "",
        element.getElementsByTagName("a")[0].attributes["href"] ?? "");
  }

  @override
  Future<Response> latestUpdateRequest(int page) {
    return httpClient.get(
        "$baseUrl/daftar-manga/page/$page/?status=&type=&format=&order=update&title=");
  }

  @override
  comicDetailFromDocument(Document document) {
    CommicDetail detail = CommicDetail(
      document.querySelector("h1.entry-title")?.text ?? "",
      document.querySelector(".thumb > img")?.attributes['src'] ?? "",
      "",
      document.querySelector(".shortcsc.sht2")?.text ?? "",
    );

    return detail;
  }

  @override
  List<Genre> getGenres() => [
        Genre("4-Koma", "4-koma"),
        Genre("4-Koma. Comedy", "4-koma-comedy"),
        Genre("Action", "action"),
        Genre("Action. Adventure", "action-adventure"),
        Genre("Adult", "adult"),
        Genre("Adventure", "adventure"),
        Genre("Comedy", "comedy"),
        Genre("Cooking", "cooking"),
        Genre("Demons", "demons"),
        Genre("Doujinshi", "doujinshi"),
        Genre("Drama", "drama"),
        Genre("Ecchi", "ecchi"),
        Genre("Echi", "echi"),
        Genre("Fantasy", "fantasy"),
        Genre("Game", "game"),
        Genre("Gender Bender", "gender-bender"),
        Genre("Gore", "gore"),
        Genre("Harem", "harem"),
        Genre("Historical", "historical"),
        Genre("Horror", "horror"),
        Genre("Isekai", "isekai"),
        Genre("Josei", "josei"),
        Genre("Magic", "magic"),
        Genre("Manga", "manga"),
        Genre("Manhua", "manhua"),
        Genre("Manhwa", "manhwa"),
        Genre("Martial Arts", "martial-arts"),
        Genre("Mature", "mature"),
        Genre("Mecha", "mecha"),
        Genre("Medical", "medical"),
        Genre("Military", "military"),
        Genre("Music", "music"),
        Genre("Mystery", "mystery"),
        Genre("One Shot", "one-shot"),
        Genre("Oneshot", "oneshot"),
        Genre("Parody", "parody"),
        Genre("Police", "police"),
        Genre("Psychological", "psychological"),
        Genre("Romance", "romance"),
        Genre("Samurai", "samurai"),
        Genre("School", "school"),
        Genre("School Life", "school-life"),
        Genre("Sci-fi", "sci-fi"),
        Genre("Seinen", "seinen"),
        Genre("Shoujo", "shoujo"),
        Genre("Shoujo Ai", "shoujo-ai"),
        Genre("Shounen", "shounen"),
        Genre("Shounen Ai", "shounen-ai"),
        Genre("Slice of Life", "slice-of-life"),
        Genre("Smut", "smut"),
        Genre("Sports", "sports"),
        Genre("Super Power", "super-power"),
        Genre("Supernatural", "supernatural"),
        Genre("Thriller", "thriller"),
        Genre("Tragedy", "tragedy"),
        Genre("Vampire", "vampire"),
        Genre("Webtoon", "webtoon"),
        Genre("Webtoons", "webtoons"),
        Genre("Yuri", "yuri"),
      ];

  @override
  List<Chapter> chapterFromDocument(Document document) {
    List<Element> elements =
        document.querySelectorAll("#chapter_list > ul > li");

    return elements
        .map(
          (e) => Chapter(
            title: e.querySelector(".lchx > a")?.text ?? "",
            date: e.querySelector(".dt > a")?.text ?? "",
            url: e.getElementsByTagName("a")[0].attributes['href'] ?? "",
          ),
        )
        .toList();
  }

  @override
  List<Genre> genresFromDocument(Document document) {
    String replaceString = "https://bacakomik.co/genres/";

    List<Element> elements = document.querySelectorAll('.genre-info > a');

    List<Genre> genres = elements
        .map((e) => Genre(e.text,
            e.attributes['href']?.replaceFirst(replaceString, "") ?? ""))
        .toList();

    return genres;
  }

  @override
  ChapterDetail chapterDetailFromDocument(Document document) {
    List<Element> imageElements = document.querySelectorAll("#chimg-auh > img");
    List<ChapterImage> images = imageElements.map((e) {
      String? altUrl = e.attributes["onerror"]
          ?.replaceAll("this.onerror=null;this.src='", "")
          .replaceFirst("';", "");
      return ChapterImage(url: e.attributes["src"] ?? "", altUrl: altUrl);
    }).toList();

    String? prevUrl =
        document.querySelector(".nextprev > a[rel=prev]")?.attributes['href'];
    String? nextUrl =
        document.querySelector(".nextprev > a[rel=next]")?.attributes['href'];

    return ChapterDetail(images: images, nextUrl: nextUrl, prevUrl: prevUrl);
  }
}
