class DatePickerOptions {
  const DatePickerOptions({
    this.itemExtent = 45.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.isLoop = true,
  });

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// The loop iterates on an explicit list of values
  final bool isLoop;
}
