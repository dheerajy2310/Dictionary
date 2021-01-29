import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Bookmark {
  final List bookmarks;
  Bookmark(this.bookmarks);
  static updateList() async {
    List list;
    StreamingSharedPreferences streamingSharedPreferences =
        await StreamingSharedPreferences.instance;
    list = streamingSharedPreferences
        .getStringList('bookmarks', defaultValue: []).getValue();
    print('list is ${list.toString()}');
    bookmarkList = Bookmark(list);
  }

  static retrieveList() {
    return bookmarkList.bookmarks;
  }
}

Bookmark bookmarkList;
