import '../api/api_client.dart';
import '../api/api_client_factory.dart';
import '../api/services_interfaces.dart';
import '../../api/services/user_service.dart';
import '../../api/services/physiological_data_service.dart';
import '../../api/services/anxiety_event_service.dart';
import '../../api/services/session_service.dart';
import '../../api/services/device_service.dart';
import '../../api/services/notification_service.dart';

/// Service Locator para gestionar las dependencias de la aplicación
/// Aplica el principio de Inversión de Dependencias (DIP)
/// Facilita las pruebas unitarias y el mantenimiento del código
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final ApiClient _apiClient;
  late final ApiClientFactory _apiClientFactory;
  late final IUserService _userService;
  late final IPhysiologicalDataService _physiologicalDataService;
  late final IAnxietyEventService _anxietyEventService;
  late final ISessionService _sessionService;
  late final IDeviceService _deviceService;
  late final INotificationService _notificationService;

  bool _initialized = false;

  /// Inicializa todas las dependencias de la aplicación
  void initialize() {
    if (_initialized) return;

    // Inicializar cliente API y la factory
    _apiClient = ApiClient();
    _apiClientFactory = ApiClientFactory();

    // Inicializar servicios con inyección de dependencias
    _userService = UserService(null);
    _physiologicalDataService = PhysiologicalDataService(null);
    _anxietyEventService = AnxietyEventService(null);
    _sessionService = SessionService(null);
    _deviceService = DeviceService(null);
    _notificationService = NotificationService(null);

    _initialized = true;
  }

  /// Obtiene el cliente API
  ApiClient get apiClient {
    _ensureInitialized();
    return _apiClient;
  }
  
  /// Obtiene la factory de clientes API
  ApiClientFactory get apiClientFactory {
    _ensureInitialized();
    return _apiClientFactory;
  }

  /// Obtiene el servicio de usuarios
  IUserService get userService {
    _ensureInitialized();
    return _userService;
  }

  /// Obtiene el servicio de datos fisiológicos
  IPhysiologicalDataService get physiologicalDataService {
    _ensureInitialized();
    return _physiologicalDataService;
  }

  /// Obtiene el servicio de eventos de ansiedad
  IAnxietyEventService get anxietyEventService {
    _ensureInitialized();
    return _anxietyEventService;
  }

  /// Obtiene el servicio de sesiones
  ISessionService get sessionService {
    _ensureInitialized();
    return _sessionService;
  }

  /// Obtiene el servicio de dispositivos
  IDeviceService get deviceService {
    _ensureInitialized();
    return _deviceService;
  }

  /// Obtiene el servicio de notificaciones
  INotificationService get notificationService {
    _ensureInitialized();
    return _notificationService;
  }

  /// Actualiza el token de autenticación en todos los servicios
  void updateAuthToken(String token) {
    _ensureInitialized();
    _apiClientFactory.updateAuthToken(token);
  }

  /// Remueve el token de autenticación
  void removeAuthToken() {
    _ensureInitialized();
    _apiClientFactory.removeAuthToken();
  }

  /// Verifica que el ServiceLocator esté inicializado
  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'ServiceLocator no ha sido inicializado. '
        'Llama a ServiceLocator().initialize() antes de usar los servicios.',
      );
    }
  }

  /// Resetea el ServiceLocator (útil para pruebas)
  void reset() {
    _initialized = false;
  }
}
