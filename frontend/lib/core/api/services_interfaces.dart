import '../../models/user/user.dart';
import '../../models/anxiety_event/anxiety_event.dart';
import '../../models/physiological_data/physiological_data.dart';
import '../../models/session/session.dart';
import '../../models/dispositivo/dispositivo.dart';
import '../../models/notification/notification_model.dart';
import 'api_response.dart';

/// Interfaz para el servicio de usuarios
/// Aplicando el principio de inversión de dependencias (DIP)
abstract class IUserService {
  /// Autenticación
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<Map<String, dynamic>>> logout();

  Future<ApiResponse<User>> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String tipoUsuario,
  });

  /// Gestión de usuarios
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? tipoUsuario,
    bool? activo,
  });

  Future<ApiResponse<User>> getUserById(int id);
  Future<ApiResponse<User>> getCurrentUser();
  Future<ApiResponse<User>> updateUser(int id, Map<String, dynamic> data);
  Future<ApiResponse<void>> deleteUser(int id);

  /// Perfil
  Future<ApiResponse<User>> updateProfile(Map<String, dynamic> data);
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

/// Interfaz para el servicio de datos fisiológicos
abstract class IPhysiologicalDataService {
  /// Obtener datos fisiológicos
  Future<PaginatedResponse<PhysiologicalData>> getPhysiologicalData({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    int? sesionId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ApiResponse<PhysiologicalData>> getPhysiologicalDataById(int id);
  
  /// Crear datos fisiológicos (desde dispositivo IoT)
  Future<ApiResponse<PhysiologicalData>> createPhysiologicalData({
    required int sesionId,
    required int usuarioId,
    required int pulseraId,
    required DateTime timestamp,
    required int bpm,
    required int spo2,
    required double temperatura,
    required int calidadSenal,
  });

  /// Estadísticas y agregaciones
  Future<ApiResponse<Map<String, dynamic>>> getStatistics({
    required int usuarioId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ApiResponse<List<Map<String, dynamic>>>> getTimeSeriesData({
    required int usuarioId,
    required DateTime startDate,
    required DateTime endDate,
    String interval = 'hour', // hour, day, week
  });
}

/// Interfaz para el servicio de eventos de ansiedad
abstract class IAnxietyEventService {
  /// Gestión de eventos de ansiedad
  Future<PaginatedResponse<AnxietyEvent>> getAnxietyEventsByUserId({
    required int usuarioId,
    int page = 1,
    int pageSize = 20,
    int? sesionId,
    AnxietyLevel? nivelAnsiedad,
    DateTime? startDate,
    DateTime? endDate,
    bool? resuelto,
  });

  Future<ApiResponse<AnxietyEvent>> getAnxietyEventById(int id);
  
  Future<ApiResponse<AnxietyEvent>> createAnxietyEvent({
    required int usuarioId,
    required int sesionId,
    required DateTime timestamp,
    required AnxietyLevel nivelAnsiedad,
    required int bpmMomento,
    required int spo2Momento,
    required double temperaturaMomento,
    required int duracionMinutos,
    required Map<String, dynamic> factoresDetectados,
    required String accionTomada,
    String? notasUsuario,
  });

  Future<ApiResponse<AnxietyEvent>> updateAnxietyEvent(
    int id,
    Map<String, dynamic> data,
  );

  Future<ApiResponse<void>> deleteAnxietyEvent(int id);

  /// Marcar como resuelto
  Future<ApiResponse<AnxietyEvent>> markAsResolved(
    int id, {
    String? notasUsuario,
  });
}

/// Interfaz para el servicio de sesiones
abstract class ISessionService {

  Future<PaginatedResponse<Session>> getSessionsByUserId({
    required int usuarioId,
    int page = 1,
    int pageSize = 20,
    bool? activa,
    DateTime? startDate,
    DateTime? endDate,
  });
  /// Gestión de sesiones de monitoreo
  Future<PaginatedResponse<Session>> getSessions({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    bool? activa,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<ApiResponse<Session>> getSessionById(int id);
  
  Future<ApiResponse<Session>> createSession({
    required int usuarioId,
    required int pulseraId,
    String? notas,
  });

  Future<ApiResponse<Session>> updateSession(
    int id,
    Map<String, dynamic> data,
  );

  Future<ApiResponse<Session>> endSession(int id);
  Future<ApiResponse<void>> deleteSession(int id);

  /// Sesión activa
  Future<ApiResponse<Session?>> getActiveSession(int usuarioId);
}

/// Interfaz para el servicio de dispositivos
abstract class IDeviceService {
  /// Gestión de dispositivos (pulseras)
  Future<PaginatedResponse<Dispositivo>> getDevices({
    int page = 1,
    int pageSize = 20,
    String? search,
    bool? activo,
    int? usuarioAsignado,
  });

  Future<ApiResponse<Dispositivo>> getDeviceById(int id);
  
  Future<ApiResponse<Dispositivo>> createDevice({
    required String numeroSerie,
    required String modelo,
    String? ubicacion,
  });

  Future<ApiResponse<Dispositivo>> updateDevice(
    int id,
    Map<String, dynamic> data,
  );

  Future<ApiResponse<void>> deleteDevice(int id);

  /// Asignación de dispositivos
  Future<ApiResponse<Dispositivo>> assignDevice({
    required int deviceId,
    required int usuarioId,
  });

  Future<ApiResponse<Dispositivo>> unassignDevice(int deviceId);

  /// Estado del dispositivo
  Future<ApiResponse<Map<String, dynamic>>> getDeviceStatus(int id);
}

/// Interfaz para el servicio de notificaciones
abstract class INotificationService {
  /// Gestión de notificaciones
  Future<PaginatedResponse<NotificationModel>> getNotifications({
    int page = 1,
    int pageSize = 20,
    int? usuarioId,
    bool? leida,
    String? tipo,
  });

  Future<ApiResponse<NotificationModel>> getNotificationById(int id);
  
  Future<ApiResponse<NotificationModel>> createNotification({
    required int usuarioId,
    required String titulo,
    required String mensaje,
    required String tipo,
    Map<String, dynamic>? metadatos,
  });

  Future<ApiResponse<NotificationModel>> markAsRead(int id);
  Future<ApiResponse<void>> markAllAsRead(int usuarioId);
  Future<ApiResponse<void>> deleteNotification(int id);
}
