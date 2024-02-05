import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Community"),),

        ],
    );
  }
}
class Data {
  final String name;
  final String address;
  final int isFrom;

  const Data({
    required this.name,
    required this.address,
    required this.isFrom,
  });
}

const List<Data> dummyData = [
  Data(
    name: "The Big Brunch",
    address: "Drop of Arun school",
    isFrom: 1,
  ),
  Data(
    name: "Blind School",
    address: "Avenue Colony, Flat No.404",
    isFrom: 0,
  ),
];
