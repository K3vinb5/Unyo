import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unyo/core/di/locator.dart';
import 'package:unyo/core/notification/reload/reload_type.dart';

class ReloadNotifier {
  final BehaviorSubject<ReloadType> _reloadSubject;
  final _logger = sl<Logger>();

  ReloadNotifier() : _reloadSubject = BehaviorSubject.seeded(ReloadType.empty);

  // Public stream for Cubits to Subscribe
  Stream<ReloadType> get reloadStream => _reloadSubject.stream;

  void emitReload(ReloadType newReloadType) {
    _logger.d("Reload notifier updated with: $newReloadType");
    _reloadSubject.add(newReloadType);
    Future.delayed(Duration.zero, () {
      _reloadSubject.add(ReloadType.empty);
    });
  }

  ReloadType get latestReloadNotification => _reloadSubject.value;

  void dispose() => _reloadSubject.close();
}