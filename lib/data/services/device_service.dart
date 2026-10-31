import 'package:flutter/services.dart';

/// Obtiene un identificador estable del dispositivo desde el código nativo
/// (ANDROID_ID en Android, identifierForVendor en iOS).
class DeviceService {
  static const _channel = MethodChannel('asistly/device');

  String? _cached;

  Future<String> getDeviceId() async {
    if (_cached != null) return _cached!;
    final id = await _channel.invokeMethod<String>('getDeviceId');
    if (id == null || id.isEmpty) {
      throw PlatformException(code: 'NO_DEVICE_ID', message: 'No se pudo identificar el dispositivo');
    }
    return _cached = id;
  }
}
