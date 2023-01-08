import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:utk19rsh/components/functions/functions.dart';
import 'package:utk19rsh/components/miscellaneous/textButton.dart';
import 'package:utk19rsh/components/modal/menu.dart';
import 'package:utk19rsh/constant.dart';
import 'package:utk19rsh/screens/landing/cartProvider.dart';

// class ColorIcons extends StatelessWidget {
//   final IconData icon;
//   final Color? color;
//   final EdgeInsets? padding;
//   const ColorIcons(
//     this.icon, {
//     Key? key,
//     this.color,
//     this.padding,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: padding ?? const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: color ?? theme,
//         borderRadius: BorderRadius.circular(7.5),
//       ),
//       child: Icon(
//         icon,
//         color: white,
//       ),
//     );
//   }
// }

class CustomTextField extends StatelessWidget {
  final BoxConstraints prefixConstraints;
  final Widget prefixIcon, suffixIcon;
  final String hintText;
  const CustomTextField(
    this.searchController, {
    Key? key,
    required this.prefixConstraints,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorHeight: 18,
      controller: searchController,
      decoration: InputDecoration(
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(),
        fillColor: theme.withOpacity(0.05),
        filled: true,
        prefixIconConstraints: prefixConstraints,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: TextStyle(
          color: grey.withOpacity(0.5),
          fontSize: 18,
        ),
      ),
    );
  }

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: trans,
        width: double.minPositive,
      ),
    );
  }
}

RoundedRectangleBorder buttonBorder(double radius, Color color) {
  return RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(radius),
    ),
    side: BorderSide(
      color: color,
      width: 1,
    ),
  );
}

class MenuCategoryTile extends StatefulWidget {
  const MenuCategoryTile({
    Key? key,
    required this.cuisine,
    required this.items,
  }) : super(key: key);

  final String cuisine;
  final List<MenuCategoryItem> items;

  @override
  State<MenuCategoryTile> createState() => _MenuCategoryTileState();
}

class _MenuCategoryTileState extends State<MenuCategoryTile> {
  bool hideTile = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 17.5,
        vertical: 15,
      ),
      margin: const EdgeInsets.only(bottom: 15),
      color: white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => hideTile = !hideTile),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.cuisine,
                  style: const TextStyle(
                    fontSize: 24,
                    color: theme,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(MdiIcons.menuDown, size: 30),
              ],
            ),
          ),
          if (!hideTile)
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              padding: const EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                List<MenuCategoryItem> items = widget.items;
                String name = "${widget.cuisine} ${index + 1}";
                // String name = items[index].name;
                int price = widget.items[index].price;
                bool inStock = widget.items[index].inStock;
                return MenuCategoryTileBody(
                  name: name,
                  price: price,
                  inStock: inStock,
                );
              },
            ),
        ],
      ),
    );
  }
}

class MenuCategoryTileBody extends StatefulWidget {
  const MenuCategoryTileBody({
    Key? key,
    required this.name,
    required this.price,
    this.inStock = true,
    this.submittingOrder = false,
  }) : super(key: key);

  final String name;
  final int price;
  final bool submittingOrder, inStock;

  @override
  State<MenuCategoryTileBody> createState() => _MenuCategoryTileBodyState();
}

class _MenuCategoryTileBodyState extends State<MenuCategoryTileBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, value, _) {
      Map<String, int> quantities = value.quantity;
      late int quantity;
      if (quantities.containsKey(widget.name)) {
        quantity = quantities[widget.name]!;
      } else {
        quantity = 0;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: widget.submittingOrder
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (widget.submittingOrder)
                        const Icon(
                          MdiIcons.circleSmall,
                          color: theme,
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          if (!widget.submittingOrder &&
                              value.bestSellers.contains(widget.name))
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 7.5,
                              ),
                              decoration: BoxDecoration(
                                color: deepOrange,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Bestseller",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12,
                                  letterSpacing: 0.25,
                                ),
                              ),
                            ),
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.5),
                            child: Text(
                              "₹ ${widget.price}",
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (!widget.inStock)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "* Currently unavailable",
                                style: TextStyle(
                                  color: red.shade400,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 0.5,
                                  fontSize: 12,
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (quantity == 0 && widget.inStock) {
                          setState(() => quantity++);
                          Provider.of<CartProvider>(context, listen: false)
                              .addItem(widget.name, widget.price);
                        }
                      },
                      clipBehavior: Clip.antiAlias,
                      style: ButtonStyle(
                        overlayColor: const MaterialStatePropertyAll(trans),
                        fixedSize:
                            const MaterialStatePropertyAll(Size(125, 40)),
                        backgroundColor: MaterialStatePropertyAll(
                          !widget.inStock
                              ? grey.shade100
                              : quantity == 0
                                  ? theme.withOpacity(0.1)
                                  : theme,
                        ),
                        foregroundColor: MaterialStatePropertyAll(
                          !widget.inStock
                              ? grey.shade400
                              : quantity == 0
                                  ? theme
                                  : white,
                        ),
                        shape: MaterialStateProperty.resolveWith(
                          (states) => textButtonResolve(
                            states,
                            primary:
                                buttonBorder(10, quantity == 0 ? trans : theme),
                            secondary:
                                buttonBorder(25, quantity == 0 ? theme : theme),
                          ),
                        ),
                        padding: MaterialStatePropertyAll(
                          EdgeInsets.symmetric(
                            horizontal: quantity > 0 ? 0 : 20,
                          ),
                        ),
                      ),
                      child: quantity == 0
                          ? const Text(
                              "ADD",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.75,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
                                        white,
                                      ),
                                      overlayColor:
                                          MaterialStatePropertyAll(trans),
                                    ),
                                    // behavior: HitTestBehavior.opaque,
                                    onPressed: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        ).decreaseQuantity(
                                            widget.name, widget.price);
                                      } else {
                                        setState(() => quantity = 0);
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        ).removeItem(widget.name, widget.price);
                                      }
                                    },
                                    child: const Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        MdiIcons.minus,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      "$quantity",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    style: const ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
                                        white,
                                      ),
                                      overlayColor:
                                          MaterialStatePropertyAll(trans),
                                    ),
                                    // behavior: HitTestBehavior.opaque,
                                    onPressed: () {
                                      setState(() => quantity++);
                                      Provider.of<CartProvider>(
                                        context,
                                        listen: false,
                                      ).increaseQuantity(
                                          widget.name, widget.price);
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Icon(
                                        MdiIcons.plus,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (widget.submittingOrder)
                      Padding(
                        padding: const EdgeInsets.only(right: 5, top: 5),
                        child: Text(
                          indentCost(quantity * widget.price),
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
          if (!widget.submittingOrder) const Divider(),
        ],
      );
    });
  }
}
