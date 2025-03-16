import 'package:flutter/material.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/local/get_my_string_from_shared_prefs_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/local/store_my_string_to_shared_prefs_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/remote/get_my_string_from_backend_server_use_case.dart';

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
  });

  String _myString = '';
  TextEditingController textController = TextEditingController();

  String get myString => _myString;

  Future<void> loadInitialValue() async {
    MyStringEntity storedEntity = await getLocalUseCase.execute();
    _myString = storedEntity.value;
    isLoadingData = false; // ✅ Ensure this is updated correctly
    notifyListeners(); // ✅ This will trigger a UI update
  }

  Future<void> updateFromUser() async {
    _myString = textController.text;
    await getLocalUseCase.execute();
    notifyListeners();
  }

  Future<void> updateFromServer() async {
    _myString = (await getRemoteUseCase.execute()) as String;
    textController.text = _myString;
    await storeLocalUseCase.execute(_myString);
    notifyListeners();
  }
}
