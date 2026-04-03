import 'package:flutter/foundation.dart';
import '../models/work_model.dart';
import '../repositories/profile_repository.dart';

class PreviousWorksViewModel extends ChangeNotifier {
  final ProfileRepository _repo;

  List<WorkModel> works = [];
  bool isLoading = true;
  String? errorMessage;

  PreviousWorksViewModel(this._repo) {
    fetchWorks();
  }

  Future<void> fetchWorks() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      works = await _repo.getPreviousWorks();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
