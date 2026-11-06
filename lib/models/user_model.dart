class UserModel {
  final int id;
  final String nim;
  final String name;
  final String email;
  final String prodi;
  final String status;

  UserModel({
    required this.id,
    required this.nim,
    required this.name,
    required this.email,
    required this.prodi,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      nim: json['nim']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      prodi: json['prodi']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Aktif',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nim': nim,
        'name': name,
        'email': email,
        'prodi': prodi,
        'status': status,
      };

  String get inisial {
    if (name.trim().isEmpty) return 'M';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String get namaPanggilan {
    if (name.trim().isEmpty) return 'Mahasiswa';
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.first;
  }
}
