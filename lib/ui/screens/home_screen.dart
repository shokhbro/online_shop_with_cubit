import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:online_shop_with_cubit/blocs/authentication_bloc/cubit_product.dart';
import 'package:online_shop_with_cubit/blocs/authentication_bloc/cubit_state.dart';
import 'package:online_shop_with_cubit/data/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final productController = CubitProduct();
  final titleController = TextEditingController();
  final imageController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  void addProduct() async {
    return showDialog(
      context: context,
      builder: ((contex) {
        return Form(
          key: _fromKey,
          child: AlertDialog(
            title: const Text("Add Products"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: "name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input product name";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: "image url",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input product image";
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  if (_fromKey.currentState!.validate()) {
                    context.read<CubitProduct>().addProduct(
                          UniqueKey().toString(),
                          titleController.text,
                          imageController.text,
                          false,
                        );
                    setState(() {});
                    Navigator.pop(context);
                    titleController.clear();
                    imageController.clear();
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      }),
    );
  }

  void editProduct(Product product) async {
    titleController.text = product.title;
    imageController.text = product.image;
    return showDialog(
      context: context,
      builder: ((contex) {
        return Form(
          key: _fromKey,
          child: AlertDialog(
            title: const Text("Edit Products"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: "name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input product name";
                    }
                    return null;
                  },
                ),
                const Gap(10),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    hintText: "image url",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please input product image";
                    }
                    return null;
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  if (_fromKey.currentState!.validate()) {
                    context.read<CubitProduct>().updateProduct(
                          product.id,
                          titleController.text,
                          imageController.text,
                          product.isFavorite,
                        );
                    setState(() {});
                    Navigator.pop(context);
                    titleController.clear();
                    imageController.clear();
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        );
      }),
    );
  }

  void deleteProduct(String id) {
    context.read<CubitProduct>().deleteProduct(id);
    setState(() {});
  }

  void editOrDeleteDialog(String id, Product product) async {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    editProduct(product);
                  },
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: const Text("Edit"),
                ),
                const Gap(10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteProduct(id);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text("Delete"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          "Online Shop",
          style: TextStyle(
            fontFamily: 'Extrag',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<CubitProduct, ProductState>(
        builder: (context, state) {
          if (state is InitialState) {
            return const Center(
              child: Text("Mahsulotlar hali mavjud emas!"),
            );
          }

          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ErrorState) {
            return Center(
              child: Text(state.message),
            );
          }
          final products = (state as LoadedState).product;
          return GridView.builder(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 10,
              bottom: 10,
            ),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 10,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              final product = products[index];
              return GestureDetector(
                onLongPress: () {
                  editOrDeleteDialog(product.id, product);
                },
                child: Card(
                  elevation: 6,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(product.image),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: 300,
                          height: 225,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 30,
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontFamily: "Extrag",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
