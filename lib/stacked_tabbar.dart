import 'dart:ui' show ImageFilter;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kTabBarHeight = 50.0;

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);
const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;

class CustomTabBar extends StatelessWidget implements CupertinoTabBar {
  const CustomTabBar({
    Key? key,
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor = _kDefaultTabBarInactiveColor,
    this.iconSize = 30.0,
    this.height = _kTabBarHeight,
    this.border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // 0.0 means one physical pixel
      ),
    ),
  })  : assert(
          items.length >= 2,
          "Tabs need at least 2 items to conform to Apple's HIG",
        ),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(height >= 0.0),
        super(key: key);
  @override
  final List<BottomNavigationBarItem> items;
  @override
  final ValueChanged<int>? onTap;
  @override
  final int currentIndex;
  @override
  final Color? backgroundColor;
  @override
  final Color? activeColor;
  @override
  final Color inactiveColor;
  @override
  final double iconSize;
  @override
  final double height;
  @override
  final Border? border;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  bool opaque(BuildContext context) {
    final Color backgroundColor =
        this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;
    return CupertinoDynamicColor.resolve(backgroundColor, context).alpha ==
        0xFF;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));

    final Color backgroundColor = CupertinoDynamicColor.resolve(
      this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      context,
    );

    BorderSide resolveBorderSide(BorderSide side) {
      return side == BorderSide.none
          ? side
          : side.copyWith(
              color: CupertinoDynamicColor.resolve(side.color, context));
    }

    // Return the border as is when it's a subclass.
    final Border? resolvedBorder =
        border == null || border.runtimeType != Border
            ? border
            : Border(
                top: resolveBorderSide(border!.top),
                left: resolveBorderSide(border!.left),
                bottom: resolveBorderSide(border!.bottom),
                right: resolveBorderSide(border!.right),
              );

    final Color inactive =
        CupertinoDynamicColor.resolve(inactiveColor, context);
    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        border: resolvedBorder,
        color: backgroundColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black),
          color: Colors.transparent,
        ),
        margin: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
        height: height,
        child: Stack(
          children: [
            IconTheme.merge(
              data: IconThemeData(color: inactive, size: iconSize),
              child: DefaultTextStyle(
                // Default with the inactive state.
                style: CupertinoTheme.of(context)
                    .textTheme
                    .tabLabelTextStyle
                    .copyWith(color: inactive),
                child: Semantics(
                  explicitChildNodes: true,
                  child: Row(
                    // Align bottom since we want the labels to be aligned.
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _buildTabItems(context),
                  ),
                ),
              ),
            ),
            // AnimatedPositioned(
            //   duration: const Duration(milliseconds: 300),
            //   bottom: 0,
            //   left: currentIndex * MediaQuery
            //       .of(context)
            //       .size
            //       .width / 2,
            //   child: AnimatedContainer(
            //     duration: const Duration(milliseconds: 300),
            //     width: MediaQuery
            //         .of(context)
            //         .size
            //         .width / 2,
            //     height: 30,
            //     color: Colors.blue,
            //   ),
            // )
          ],
        ),
      ),
    );

    if (!opaque(context)) {
      // For non-opaque backgrounds, apply a blur effect.
      ///ToDo. BLUR
      result = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
          child: result,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildTabItems(BuildContext context) {
    final List<Widget> result = <Widget>[];
    final CupertinoLocalizations localizations =
        CupertinoLocalizations.of(context);

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          context,
          Expanded(
            child: Semantics(
              selected: active,
              hint: localizations.tabSemanticsLabel(
                tabIndex: index + 1,
                tabCount: items.length,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null
                    ? null
                    : () {
                        onTap!(index);
                      },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildSingleTabItem(items[index], active),
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildSingleTabItem(BottomNavigationBarItem item, bool active) {
    return <Widget>[
      Expanded(
        child: Center(child: active ? item.activeIcon : item.icon),
      ),

      ///ToDO CUSTOM
      if (item.label != null)
        Text(
          item.label!,
          style: const TextStyle(fontSize: 16),
        ),
    ];
  }

  /// Change the active tab item's icon and title colors to active.
  Widget _wrapActiveItem(BuildContext context, Widget item,
      {required bool active}) {
    if (!active) return item;

    final Color activeColor = CupertinoDynamicColor.resolve(
      this.activeColor ?? CupertinoTheme.of(context).primaryColor,
      context,
    );
    return IconTheme.merge(
      data: IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: activeColor),
        child: item,
      ),
    );
  }

  /// Create a clone of the current [CustomTabBar] but with provided
  /// parameters overridden.
  @override
  CustomTabBar copyWith({
    Key? key,
    List<BottomNavigationBarItem>? items,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    double? height,
    Border? border,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomTabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      height: height ?? this.height,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
    );
  }
}
