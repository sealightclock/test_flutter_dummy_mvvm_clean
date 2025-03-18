import 'package:flutter/material.dart';
import '../../domain/usecase/local/get_my_string_from_shared_prefs_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_shared_prefs_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_backend_server_use_case.dart';
import '../../domain/entity/my_string_entity.dart';

class MyStringViewModel with ChangeNotifier {
  // A ViewModel should deal with only Use Cases, not their Repositories.
  final GetMyStringFromSharedPrefsUseCase getLocalUseCase;
  final StoreMyStringToSharedPrefsUseCase storeLocalUseCase;
  final GetMyStringFromBackendServerUseCase getRemoteUseCase;

  // This is the single data to be handled by the ViewModel.
  // In MVVM Clean, we need to encapsulate data.
  // So we need both "_myString" and "myString".
  String _myString = 'Default Value from ViewModel'; // Kept for debugging
  String get myString => _myString;

  // Flags for UI synchronization:
  bool isLoadingDataFromRemoteServer = false;

  // This is not really part of the ViewModel data, but is needed to control the TextField of the View (MyStringHomeScreen):
  TextEditingController textController = TextEditingController();

  // Constructor:
  MyStringViewModel({
    required this.getLocalUseCase,
    required this.storeLocalUseCase,
    required this.getRemoteUseCase,
  }) {
    // Can this be moved outside of the constructor?:
    loadInitialValue();
  }

  Future<void> updateFromUser() async {
    // This will trigger a widget rebuild due to a mechanism ...
    _myString = textController.text;
    // Update local storage:
    await storeLocalUseCase.execute(_myString);
    // Recommended: notify other listeners:
    notifyListeners();
  }

  Future<void> updateFromServer() async {
    isLoadingDataFromRemoteServer = true;
    notifyListeners(); // This is needed so that the View can display the circular progress indicator.
    MyStringEntity newValue = await getRemoteUseCase.execute();
    _myString = newValue.value;
    await storeLocalUseCase.execute(_myString);
    isLoadingDataFromRemoteServer = false;
    notifyListeners();
  }

  Future<void> loadInitialValue() async {
    MyStringEntity storedEntity = await getLocalUseCase.execute();
    _myString = storedEntity.value;
    notifyListeners();
  }
}
