import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const MaterialClassicHeader(),
      footerBuilder: () => const ClassicFooter(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'pull_to_refresh demo',
        localizationsDelegates: const [
          RefreshLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('ja'),
          Locale('uk'),
          Locale('it'),
          Locale('ru'),
          Locale('fr'),
          Locale('es'),
          Locale('nl'),
          Locale('sv'),
          Locale('pt'),
          Locale('ko'),
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DemoPage(),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final RefreshController _controller = RefreshController();
  final List<int> _items = List<int>.generate(20, (index) => index);

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _items
        ..clear()
        ..addAll(List<int>.generate(20, (index) => index));
    });
    _controller.refreshCompleted(resetFooterState: true);
  }

  Future<void> _onLoading() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      final start = _items.length;
      _items.addAll(List<int>.generate(10, (index) => start + index));
    });
    _controller.loadComplete();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('pull_to_refresh demo')),
      body: SmartRefresher(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) => ListTile(
            leading: CircleAvatar(child: Text('${_items[index]}')),
            title: Text('Item ${_items[index]}'),
            subtitle: const Text('Pull down to refresh, pull up to load more'),
          ),
        ),
      ),
    );
  }
}
