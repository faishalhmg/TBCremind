class UserClass {
  int? id;
  String? nama;
  String? username;
  String? email;
  String? nik;
  String? alamat;
  int? usia;
  int? no_hp;
  String? goldar;
  String? bb;
  String? kaderTB;
  String? pmo;
  String? pet_kesehatan;
  String? jk;

  UserClass();

  UserClass.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nama = json['nama'],
        username = json['username'],
        email = json['email'],
        nik = json['nik'],
        alamat = json['alamat'],
        usia = json['usia'],
        no_hp = json['no_hp'],
        goldar = json['goldar'],
        bb = json['bb'],
        kaderTB = json['kaderTB'],
        pmo = json['pmo'],
        pet_kesehatan = json['pet_kesehatan'],
        jk = json['jk'];

  Map<String, dynamic> toJson() => {
        'name': nama,
        'id': id,
        'nama': nama,
        'username': username,
        'email': email,
        'nik': nik,
        'alamat': alamat,
        'usia': usia,
        'no_hp': no_hp,
        'goldar': goldar,
        'bb': bb,
        'kaderTB': kaderTB,
        'pmo': pmo,
        'pet_kesehatan': pet_kesehatan,
        'jk': jk
      };
}
