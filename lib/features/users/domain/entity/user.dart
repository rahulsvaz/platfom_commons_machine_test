class User {
  final String storageId;
  final int? serverId;
  final String fullName;
  final String email;
  final String avatar;
  final String? job;
  final String? createdAt;
  final bool isLocalCreated;
  final bool isSynced;

  const User({
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

  User copyWith({
    String? storageId,
    int? serverId,
    String? fullName,
    String? email,
    String? avatar,
    String? job,
    String? createdAt,
    bool? isLocalCreated,
    bool? isSynced,
  }) {
    return User(
      storageId: storageId ?? this.storageId,
      serverId: serverId ?? this.serverId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      job: job ?? this.job,
      createdAt: createdAt ?? this.createdAt,
      isLocalCreated: isLocalCreated ?? this.isLocalCreated,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
