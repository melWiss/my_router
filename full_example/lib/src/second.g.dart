// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'second.dart';

// **************************************************************************
// EazyRouteGenerator
// **************************************************************************

class SecondScaffoldRoute extends EazyRoute {
  SecondScaffoldRoute();

  factory SecondScaffoldRoute.fromQueryParam(Map<String, String>? params) {
    return SecondScaffoldRoute();
  }

  @override
  Page get page => MaterialPage(
        key: const ValueKey('second'),
        name: 'second',
        arguments: queryParameters,
        child: SecondScaffold(),
      );

  @override
  Map<String, String> get queryParameters => {};
}
