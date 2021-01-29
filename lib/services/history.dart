import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class History {
  final List historyList;

  History(this.historyList);

  static updateHistory() async {
    List list;
    StreamingSharedPreferences streamingSharedPreferences =
        await StreamingSharedPreferences.instance;
    list = streamingSharedPreferences
        .getStringList('history', defaultValue: []).getValue();
    history = History(list);
  }

  static retrieveHistory() {
    print('history is ${history.historyList.toString()}');
    return history.historyList;
  }
}

History history;
