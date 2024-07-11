import 'package:online_shop_with_cubit/data/models/product.dart';

sealed class ProductState {}

final class InitialState extends ProductState {}

final class LoadingState extends ProductState {}

final class LoadedState extends ProductState {
  List<Product> product = [];

  LoadedState(this.product);
}

final class ErrorState extends ProductState {
  String message;

  ErrorState(this.message);
}
