import 'package:flutter/material.dart';
import 'package:unyo/util/utils.dart';
import 'package:unyo/widgets/widgets.dart';

class LocalExtensionsScreen extends StatefulWidget {
  const LocalExtensionsScreen({super.key});

  @override
  State<LocalExtensionsScreen> createState() => _LocalExtensionsScreenState();
}

class _LocalExtensionsScreenState extends State<LocalExtensionsScreen> {
  Widget consoleWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            processManager.outputHistory.join("\n"),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(255, 34, 33, 34),
      child: Column(
        children: [
          StyledScreenMenuWidget(
            onBackPress: null,
            onMenuPress: buttonsLayout,
            onRefreshPress: () {},
          ),
          consoleWidget(),
        ],
      ),
    );
  }
}
