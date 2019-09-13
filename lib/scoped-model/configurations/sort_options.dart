import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin SortOptions on Model {
  SharedPreferences prefs;
  bool bindCompleted;
  bool sortPriority;

  Future<Null> setSortOptions() async {
    prefs = await SharedPreferences.getInstance();

    bindCompleted = prefs.getBool('bindCompleted') ?? false;
    sortPriority = prefs.getBool('sortPriority') ?? false;
    
    return null;
  }

  toogleShow() {
    bindCompleted = !bindCompleted;
    notifyListeners();
    prefs.setBool('bindCompleted', bindCompleted);
  }

  toogleSort() {
    sortPriority = !sortPriority;
    notifyListeners();
    prefs.setBool('sortPriority', sortPriority);
  }
}
