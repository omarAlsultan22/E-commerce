import '../layouts/home_layout.dart';
import 'package:flutter/material.dart';
import '../../../data/models/home_model.dart';


class ListHomeBuilder extends StatelessWidget {
  final List<HomeDataModel> homeData;

  const ListHomeBuilder({
    required this.homeData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) => HomeLayout(homeData: homeData),
      ),
    );
  }
}