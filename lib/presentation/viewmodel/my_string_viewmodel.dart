import 'package:flutter/material.dart';
import '../../domain/usecase/local/get_my_string_from_shared_prefs_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_shared_prefs_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_backend_server_use_case.dart';
import '../../domain/entity/my_string_entity.dart';

class MyStringViewModel with ChangeNotifier {
  final GetMyStringFromSharedPrefsUseCase getLocalUseCase;
  final StoreMyStringToSharedPrefsUseCase storeLocalUseCase;
  final GetMyStringFromBackendServerUseCase getRemoteUseCase;

  bool isLoading = false;
  bool isLoadingData = true; // ✅ Added flag for UI synchronization

  MyStringViewModel({
    required this.getLocalUseCase,
    required this.storeLocalUseCase,
    required this.getRemoteUseCase,
  }) {
    loadInitialValue(); // ✅ Load stored value on ViewModel initialization
  }

  String _myString = '';
  TextEditingController textController = TextEditingController();

  String get myString => _myString;

  Future<void> loadInitialValue() async {
    MyStringEntity storedEntity = await getLocalUseCase.execute();
    _myString = storedEntity.value;
    textController.text = _myString;
    isLoadingData = false; // ✅ Ensure this is updated correctly
    notifyListeners(); // ✅ Trigger UI update
  }

  Future<void> updateFromUser() async {
    _myString = textController.text;
    await storeLocalUseCase.execute(_myString); // ✅ Store the value correctly
    notifyListeners();
  }

  Future<void> updateFromServer() async {
    MyStringEntity serverEntity = await getRemoteUseCase.execute();
    _myString = serverEntity.value;
    textController.text = _myString;
    await storeLocalUseCase.execute(_myString);
    notifyListeners();
  }
}
