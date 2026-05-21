import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/domain/entities/extension/extension.dart';

class ExtensionNotifier {
  final BehaviorSubject<Extension> _extensionSubject;
  final _logger = sl<Logger>();

  ExtensionNotifier() : _extensionSubject = BehaviorSubject.seeded(ExtensionModel.empty());

  // Public stream for Cubits to subscribe
  Stream<Extension> get extensionStream => _extensionSubject.stream;

  void updateSelectedExtension(Extension extension) {
    _logger.d("Extension notifier updated with: $extension");
    _extensionSubject.add(extension);
  }

  Extension get currentExtension => _extensionSubject.value;

  void dispose() => _extensionSubject.close();
}