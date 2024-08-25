import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

abstract class IMyNavigatorHandler {
  void push(Page page);
  void pushPages(List<Page> pages);
  void pop({int times = 1});
  void removePage(Page page, {bool notifyRootWidget = false});
  void removePageByName(String name, {bool notifyRootWidget = false});
  void popUntilTrue(bool Function(Page page) predicate);
  bool hasPage(String name);
  Stream<List<Page>> get stream;
}

class MyNavigatorHandler extends IMyNavigatorHandler {
  List<Page> _state = [];
  final Map<String, Page> pages;
  final BehaviorSubject<List<Page>> _controller = BehaviorSubject();

  MyNavigatorHandler({
    required Page initialPage,
    required this.pages,
  }) {
    _state = [initialPage];
    _controller.add(_state);
  }
  @override
  void push(Page page) {
    _state = List.from([..._state, page]);
    _controller.add(_state);
  }

  @override
  void pushPages(List<Page> pages) {
    _state = List.from([..._state, ...pages]);
    _controller.add(_state);
  }

  @override
  void pop({int times = 1}) {
    _state.removeRange(_state.length - times, _state.length);
    _state = List.from(_state);
    _controller.add(_state);
  }

  @override
  void popUntilTrue(bool Function(Page page) predicate) {
    while (!predicate(_state.last)) {
      _state.removeLast();
    }
    _state = List.from(_state);
    _controller.add(_state);
  }

  @override
  Stream<List<Page>> get stream => _controller.stream;

  @override
  void removePage(Page page, {bool notifyRootWidget = false}) {
    if (_state.contains(page)) {
      _state.remove(page);
      if (notifyRootWidget) {
        _state = List.from(_state);
        _controller.add(_state);
      }
    }
  }

  @override
  void removePageByName(String name, {bool notifyRootWidget = false}) {
    var pageToRemove = _state.firstWhere((element) => element.name == name);
    _state.remove(pageToRemove);
    if (notifyRootWidget) {
      _state = List.from(_state);
      _controller.add(_state);
    }
  }

  @override
  bool hasPage(String name) => _state.any((element) => element.name == name);
}

class MyNavigator extends StatelessWidget {
  MyNavigator({
    required this.initialPage,
    required this.pages,
    super.key,
  }) : _navigatorHandler =
            MyNavigatorHandler(initialPage: initialPage, pages: pages);

  final IMyNavigatorHandler _navigatorHandler;
  final Page initialPage;
  final Map<String, Page> pages;

  @override
  Widget build(BuildContext context) {
    MyNavigatorContext._navigatorHandler = _navigatorHandler;
    return Provider<IMyNavigatorHandler>.value(
      value: _navigatorHandler,
      builder: (_, __) => StreamBuilder<List<Page>>(
        stream: _navigatorHandler.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<Page<dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Navigator(
              pages: snapshot.data!,
              onDidRemovePage: _navigatorHandler.removePage,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

extension MyNavigatorContext on BuildContext {
  static late IMyNavigatorHandler _navigatorHandler;

  void push(Page page) => _navigatorHandler.push(page);
  void pushPages(List<Page> pages) => _navigatorHandler.pushPages(pages);
  void pop({int times = 1}) => _navigatorHandler.pop(times: times);
  void removePage(Page page, {bool notifyRootWidget = false}) =>
      _navigatorHandler.removePage(page, notifyRootWidget: notifyRootWidget);
  void removePageByName(String name, {bool notifyRootWidget = false}) =>
      _navigatorHandler.removePageByName(
        name,
        notifyRootWidget: notifyRootWidget,
      );
  void popUntilTrue(bool Function(Page page) predicate) =>
      _navigatorHandler.popUntilTrue(predicate);
  bool hasPage(String name) => _navigatorHandler.hasPage(name);
  Stream<List<Page>> get stream => _navigatorHandler.stream;
}
