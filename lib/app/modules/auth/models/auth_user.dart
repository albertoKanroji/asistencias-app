class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.name,
    this.lastName,
    this.secondLastName,
    this.email,
    this.photo,
    this.area,
    this.position,
    this.roles = const [],
    this.blocks = const [],
  });

  final int id;
  final String username;
  final String name;
  final String? lastName;
  final String? secondLastName;
  final String? email;
  final String? photo;
  final String? area;
  final String? position;
  final List<AuthRole> roles;
  final List<AuthBlock> blocks;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      lastName: json['last_name']?.toString(),
      secondLastName: json['second_last_name']?.toString(),
      email: json['email']?.toString(),
      photo: json['photo']?.toString(),
      area: json['area']?.toString(),
      position: json['position']?.toString(),
      roles: (json['roles'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AuthRole.fromJson)
          .toList(),
      blocks: (json['blocks'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AuthBlock.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'last_name': lastName,
      'second_last_name': secondLastName,
      'email': email,
      'photo': photo,
      'area': area,
      'position': position,
      'roles': roles.map((role) => role.toJson()).toList(),
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}

class AuthRole {
  const AuthRole({required this.id, required this.name});

  final int id;
  final String name;

  factory AuthRole.fromJson(Map<String, dynamic> json) {
    return AuthRole(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AuthBlock {
  const AuthBlock({
    required this.id,
    required this.name,
    this.modules = const [],
  });

  final int id;
  final String name;
  final List<AuthModule> modules;

  factory AuthBlock.fromJson(Map<String, dynamic> json) {
    return AuthBlock(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      modules: (json['modules'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(AuthModule.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'modules': modules.map((module) => module.toJson()).toList(),
    };
  }
}

class AuthModule {
  const AuthModule({
    required this.id,
    required this.name,
    required this.path,
  });

  final int id;
  final String name;
  final String path;

  factory AuthModule.fromJson(Map<String, dynamic> json) {
    return AuthModule(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'path': path,
    };
  }
}
