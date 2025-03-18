import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/local/my_string_shared_prefs_repository.dart';
import '../../data/remote/my_string_backend_server_repository.dart';
import '../../domain/usecase/local/get_my_string_from_shared_prefs_use_case.dart';
import '../../domain/usecase/local/store_my_string_to_shared_prefs_use_case.dart';
import '../../domain/usecase/remote/get_my_string_from_backend_server_use_case.dart';
import '../viewmodel/my_string_viewmodel.dart';

class MyStringHomeScreen extends StatelessWidget {
  const MyStringHomeScreen({super.key}); // Fix: Added key parameter to avoid
  // a warning about a named 'key' parameter

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyStringViewModel(
        getLocalUseCase: GetMyStringFromSharedPrefsUseCase(repository: MyStringSharedPrefsRepository()),
        storeLocalUseCase: StoreMyStringToSharedPrefsUseCase(repository: MyStringSharedPrefsRepository()),
        getRemoteUseCase: GetMyStringFromBackendServerUseCase(repository: MyStringBackendServerRepository()),
      ),
      child: Consumer<MyStringViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(title: const Text('Test Flutter Dummy MVVM Clean')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: viewModel.textController,
                    decoration: const InputDecoration(labelText: 'Enter a string'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: viewModel.updateFromUser,
                    child: const Text('Update from User'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: viewModel.updateFromServer,
                    child: viewModel.isLoadingDataFromRemoteServer
                        ? const CircularProgressIndicator()
                        : const Text('Update from Server'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Current Value: ${viewModel.myString}', style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
