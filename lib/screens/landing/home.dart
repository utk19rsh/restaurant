import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:utk19rsh/components/functions/functions.dart';
import 'package:utk19rsh/components/miscellaneous/textButton.dart';
import 'package:utk19rsh/components/modal/menu.dart';
import 'package:utk19rsh/constant.dart';
import 'package:utk19rsh/screens/landing/cartProvider.dart';
import 'package:utk19rsh/screens/landing/components.dart';
import 'package:utk19rsh/screens/order/submitOrder.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double height, width;
  double collpasedHeight = kToolbarHeight + 55, infinity = double.infinity;
  TextEditingController searchController = TextEditingController();
  List<MenuCategory> menuCategories = [];
  List<String> appBarSliderMenu = ["All Categories"];
  late final List<MenuCategory> menuCategoriesAll;
  Map<String, int> cart = {};
  int cartAmount = 0;
  late String selectedCuisine;
  ScrollController scrollController = ScrollController();

  Color backgroundColor = Colors.grey[100]!;
  @override
  void initState() {
    inception();
    super.initState();
  }

  inception() async {
    selectedCuisine = appBarSliderMenu.first;
    if (mounted) {
      Provider.of<CartProvider>(context, listen: false).inception();
    }
    String menuJson = await DefaultAssetBundle.of(context)
        .loadString("assets/menu/menu.json");
    Map<String, dynamic> menu = jsonDecode(menuJson);
    for (int i = 0; i < menu.length; i++) {
      String name = menu.keys.elementAt(i);
      appBarSliderMenu.add(name);
      menuCategories.add(MenuCategory.fromJson(menu, name: name));
    }
    menuCategoriesAll = menuCategories;
    // menuCategories.shuffle();
    setState(() {});
  }

  updateMenu(String category) {
    if (category == appBarSliderMenu.first) {
      menuCategories = menuCategoriesAll;
    } else {
      List<MenuCategory> temp = [
        menuCategoriesAll
            .firstWhere((menuCategory) => menuCategory.name == category)
      ];
      menuCategories = temp;
    }
    selectedCuisine = category;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              controller: scrollController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: backgroundColor,
                  collapsedHeight: collpasedHeight,
                  centerTitle: true,
                  elevation: 10,
                  expandedHeight: 260,
                  floating: false,
                  forceElevated: true,
                  foregroundColor: theme,
                  pinned: true,
                  snap: false,
                  stretch: true,
                  scrolledUnderElevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: trans,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  title: title(),
                  flexibleSpace: flexibleSpace(context),
                  bottom: bottom(),
                ),
                SliverToBoxAdapter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: menuCategories.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 90),
                    itemBuilder: (context, index) => MenuCategoryTile(
                      cuisine: menuCategories[index].name,
                      items: menuCategories[index].items,
                    ),
                  ),
                ),
              ],
            ),
            payNow(),
          ],
        ),
      ),
    );
  }

  Consumer<CartProvider> payNow() {
    return Consumer<CartProvider>(
      builder: (context, value, _) => Card(
        elevation: 40,
        margin: const EdgeInsets.only(top: 5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.bounceOut,
          height: value.cartAmount > 0 ? 90 : 0,
          color: backgroundColor,
          width: width,
          child: !(value.cartAmount > 0)
              ? Container()
              : Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 15 + MediaQuery.of(context).viewInsets.bottom,
                    vertical: 12.5,
                  ),
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.5),
                    color: theme.withOpacity(1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${value.cart.length} ITEM",
                            style: const TextStyle(
                              color: white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 7.5),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: indentCost(
                                    value.cartAmount,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: "  plus taxes"),
                              ],
                            ),
                          )
                        ],
                      ),
                      TextButton(
                        style: const ButtonStyle(
                          overlayColor: MaterialStatePropertyAll(trans),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ChangeNotifierProvider(
                              create: (context) => value,
                              child: const SubmitOrder(),
                            ),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "PAY NOW",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: white,
                              ),
                            ),
                            SizedBox(width: 2.5),
                            Icon(
                              MdiIcons.menuRight,
                              color: white,
                              size: 28,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  PreferredSize bottom() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: SizedBox(
        height: 50,
        width: width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: appBarSliderMenu.length,
          itemBuilder: (context, index) {
            String name = appBarSliderMenu[index];
            // menuCategories[menuCategories.length - index - 1].name;
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(right: 5),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      updateMenu(name);
                      scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: const MaterialStatePropertyAll(trans),
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) => textButtonResolve(
                          states,
                          primary: selectedCuisine == name ? theme : black,
                          secondary: theme,
                        ),
                      ),
                    ),
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.75,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (index != appBarSliderMenu.length - 1)
                    const Icon(MdiIcons.circleSmall, size: 18),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  FlexibleSpaceBar flexibleSpace(BuildContext context) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.pin,
      background: Container(
        margin: EdgeInsets.fromLTRB(
          15,
          kToolbarHeight + MediaQuery.of(context).viewPadding.top + 10,
          15,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Aligning the "H" and "F" because they appear to starting from different points.
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Transform.translate(
                offset: const Offset(-0.5, 0),
                child: const Text(
                  "Hi Utkarsh",
                  style: TextStyle(
                    color: theme,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                "Find Your Food",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 15),
            CustomTextField(
              searchController,
              hintText: "Search food",
              prefixConstraints: const BoxConstraints(minWidth: 60),
              prefixIcon: const Icon(MdiIcons.magnify, color: theme),
              suffixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7.5,
                ),
                decoration: BoxDecoration(
                  color: theme,
                  borderRadius: BorderRadius.circular(7.5),
                ),
                child: const Icon(MdiIcons.tuneVerticalVariant, color: white),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Row title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(MdiIcons.menu, color: theme),
        // const ColorIcons(MdiIcons.menu),
        Row(
          children: const [
            Icon(MdiIcons.mapMarker, color: theme),
            SizedBox(width: 5),
            Text(
              "Gurgaon, HR",
              style: TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Icon(MdiIcons.account, color: theme),
      ],
    );
  }
}
