import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop_with_cubit/blocs/authentication_bloc/cubit_product.dart';
import 'package:online_shop_with_cubit/ui/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CubitProduct();
      },
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
