import 'package:platfom_commons_machine_test/features/users/domain/entity/user.dart';

class UserModel {
  final String storageId;
  final int? serverId;
  final String fullName;
  final String email;
  final String avatar;
  final String? job;
  final String? createdAt;
  final bool isLocalCreated;
  final bool isSynced;

  const UserModel({
    required this.storageId,
    this.serverId,
    required this.fullName,
    required this.email,
    required this.avatar,
    this.job,
    this.createdAt,
    this.isLocalCreated = false,
    this.isSynced = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int? ?? int.tryParse(json['id']?.toString() ?? '');
    return UserModel(
      storageId: 'remote_${id ?? 0}',
      serverId: id,
      fullName:
          '${json['first_name'] as String? ?? ''} ${json['last_name'] as String? ?? ''}'
              .trim(),
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  factory UserModel.fromCreateJson(
    Map<String, dynamic> json, {
    required String storageId,
    required bool isSynced,
  }) {
    return UserModel(
      storageId: storageId,
      serverId: int.tryParse(json['id']?.toString() ?? ''),
      fullName: json['name'] as String? ?? '',
      email: '',
      avatar: '',
      job: json['job'] as String?,
      createdAt: json['createdAt'] as String?,
      isLocalCreated: true,
      isSynced: isSynced,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      storageId: map['storageId'] as String? ?? '',
      serverId: map['serverId'] as int?,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      avatar: map['avatar'] as String? ?? '',
      job: map['job'] as String?,
      createdAt: map['createdAt'] as String?,
      isLocalCreated: map['isLocalCreated'] as bool? ?? false,
      isSynced: map['isSynced'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storageId': storageId,
      'serverId': serverId,
      'fullName': fullName,
      'email': email,
      'avatar': avatar,
      'job': job,
      'createdAt': createdAt,
      'isLocalCreated': isLocalCreated,
      'isSynced': isSynced,
    };
  }

  User toEntity() {
    return User(
      storageId: storageId,
      serverId: serverId,
      fullName: fullName,
      email: email,
      avatar: avatar,
      job: job,
      createdAt: createdAt,
      isLocalCreated: isLocalCreated,
      isSynced: isSynced,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      storageId: user.storageId,
      serverId: user.serverId,
      fullName: user.fullName,
      email: user.email,
      avatar: user.avatar,
      job: user.job,
      createdAt: user.createdAt,
      isLocalCreated: user.isLocalCreated,
      isSynced: user.isSynced,
    );
  }
}
