import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop_with_cubit/blocs/authentication_bloc/cubit_state.dart';
import 'package:online_shop_with_cubit/data/models/product.dart';

class CubitProduct extends Cubit<ProductState> {
  CubitProduct() : super(InitialState());
  List<Product> products = [];

  Future<void> getProduct() async {
    try {
      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      products.add(
        Product(
          id: "1",
          title: "lamp",
          image: "https://pngimg.com/uploads/lamp/lamp_PNG108705.png",
          isFavorite: false,
        ),
      );
      emit(LoadedState(products));
    } catch (e) {
      print("xatolik chiqdi..!");
      emit(ErrorState("Mahsulotlarni ololmadim!"));
    }
  }

  Future<void> addProduct(
      String id, String title, String image, bool isFavorite) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).product;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 2));

      products.add(
        Product(id: id, title: title, image: image, isFavorite: isFavorite),
      );
      emit(LoadedState(products));
    } catch (e) {
      print("Mahsulotlarni qo'shishda xatolik!");
      emit(ErrorState("Mahsulotlarni qo'shishda xatolik!"));
    }
  }

  Future<void> updateProduct(
    String id,
    String title,
    String image,
    bool isFavorite,
  ) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).product;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      for (var i = 0; i < products.length; i++) {
        if (products[i].id == id) {
          products[i] = Product(
            id: id,
            title: title,
            image: image,
            isFavorite: isFavorite,
          );
          break;
        }
      }
      emit(LoadedState(products));
    } catch (e) {
      print("Mahsulotlarni tahrirlashda xatolik!");
      emit(ErrorState("Mahsulotlarni tahrirlashda xatolik!"));
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      if (state is LoadedState) {
        products = (state as LoadedState).product;
      }

      emit(LoadingState());
      await Future.delayed(const Duration(seconds: 1));

      products.removeWhere((product) => product.id == id);
      emit(LoadedState(products));
    } catch (e) {
      print("Mahsulotlarni o'chirishda xatolik!");
      emit(ErrorState("Mahsulotlarni o'chirishda xatolik!"));
    }
  }
}
