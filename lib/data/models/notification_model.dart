class NotificationModel {
  final int id;
  final String? typeNotification;
  final String? canal;
  final String? sujet;
  final String? message;
  final String statut;
  final String? dateEnvoi;
  final String? dateLecture;
  final String? createdAt;

  NotificationModel({
    required this.id,
    this.typeNotification,
    this.canal,
    this.sujet,
    this.message,
    required this.statut,
    this.dateEnvoi,
    this.dateLecture,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      typeNotification: json['type_notification'],
      canal: json['canal'],
      sujet: json['sujet'],
      message: json['message'],
      statut: json['statut'] ?? '',
      dateEnvoi: json['date_envoi'],
      dateLecture: json['date_lecture'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_notification': typeNotification,
      'canal': canal,
      'sujet': sujet,
      'message': message,
      'statut': statut,
      'date_envoi': dateEnvoi,
      'date_lecture': dateLecture,
      'created_at': createdAt,
    };
  }

  bool get isLue => dateLecture != null;
  bool get isNonLue => dateLecture == null;

  bool get isEcheance => typeNotification == 'echeance';
  bool get isRetard => typeNotification == 'retard';
  bool get isPaiement => typeNotification == 'paiement';
  bool get isMaintenance => typeNotification == 'maintenance';
}