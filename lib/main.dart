import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter_dummy_mvvm_clean/data/local/my_string_shared_prefs_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean/data/remote/my_string_backend_server_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/local/get_my_string_from_shared_prefs_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/local/store_my_string_to_shared_prefs_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean/domain/usecase/remote/get_my_string_from_backend_server_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean/presentation/view/my_string_home_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean/presentation/viewmodel/my_string_viewmodel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Fix: Added key parameter

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyStringViewModel>(
          create: (_) => MyStringViewModel(
            GetMyStringFromSharedPrefsUseCase(MyStringSharedPrefsRepository()),
            StoreMyStringToSharedPrefsUseCase(MyStringSharedPrefsRepository()),
            GetMyStringFromBackendServerUseCase(MyStringBackendServerRepository()),
          ),
        ),
        ],
      child: MaterialApp(
        title: 'Test Flutter Dummy MVVM Clean',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyStringHomeScreen(),
      ),
    );
  }
}
