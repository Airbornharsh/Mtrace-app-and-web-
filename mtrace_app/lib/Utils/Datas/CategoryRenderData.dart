import 'package:flutter/material.dart';

class CategoryElement {
  final String name;
  final String id;
  final String imgSrc;
  final Color colorCode;

  CategoryElement(
      {required this.name,
      required this.id,
      required this.imgSrc,
      required this.colorCode});
}

class CategoryRenderData {
  static final List<CategoryElement> data = [
    CategoryElement(
        name: "Food",
        id: "food",
        imgSrc: "lib/assets/Images/Category/food.png",
        colorCode: const Color.fromARGB(255, 255, 89, 100)),
    CategoryElement(
        name: "Travel",
        id: "travel",
        imgSrc: "lib/assets/Images/Category/travel.png",
        colorCode: const Color.fromARGB(255, 56, 97, 141)),
    CategoryElement(
        name: "Drink",
        id: "drink",
        imgSrc: "lib/assets/Images/Category/drink.png",
        colorCode: const Color.fromARGB(255, 54, 168, 255)),
    CategoryElement(
        name: "Bill",
        id: "bill",
        imgSrc: "lib/assets/Images/Category/bill.png",
        colorCode: const Color.fromARGB(255, 199, 27, 36)),
    CategoryElement(
        name: "Study",
        id: "study",
        imgSrc: "lib/assets/Images/Category/study.png",
        colorCode: const Color.fromARGB(255, 59, 192, 39)),
    CategoryElement(
        name: "Cloth",
        id: "cloth",
        imgSrc: "lib/assets/Images/Category/cloth.png",
        colorCode: const Color.fromARGB(255, 39, 187, 152)),
  ];

  static CategoryElement getCategory(String id) {
    return data.firstWhere((e) => e.id == id);
  }
}
