import 'package:flutter/material.dart';

dynamic textButtonResolve(
  Set<MaterialState> states, {
  required var primary,
  required var secondary,
}) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.dragged,
    MaterialState.focused,
    MaterialState.hovered,
    MaterialState.pressed,
  };
  if (states.any(interactiveStates.contains)) {
    return secondary;
  }
  return primary;
}
