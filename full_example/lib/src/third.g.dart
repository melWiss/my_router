// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'third.dart';

// **************************************************************************
// EazyRouteGenerator
// **************************************************************************

class ThirdScaffoldRoute extends EazyRoute {
  ThirdScaffoldRoute();

  factory ThirdScaffoldRoute.fromQueryParam(Map<String, String>? params) {
    return ThirdScaffoldRoute();
  }

  @override
  Page get page => MaterialPage(
        key: const ValueKey('third'),
        name: 'third',
        arguments: queryParameters,
        child: ThirdScaffold(),
      );

  @override
  Map<String, String> get queryParameters => {};
}
