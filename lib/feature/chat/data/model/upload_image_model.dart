class UploadImageModel {
  final File1? file1;

  UploadImageModel({
    this.file1,
  });

  UploadImageModel copyWith({
    File1? file1,
  }) {
    return UploadImageModel(
      file1: file1 ?? this.file1,
    );
  }

  UploadImageModel.fromJson(Map<String, dynamic> json)
      : file1 = (json['file'] as Map<String, dynamic>?) != null
            ? File1.fromJson(json['file'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'file': file1?.toJson()};
}

class File1 {
  final String? name;
  final String? mimeType;
  final String? sizeBytes;
  final String? createTime;
  final String? updateTime;
  final String? expirationTime;
  final String? sha256Hash;
  final String? uri;
  final String? state;

  File1({
    this.name,
    this.mimeType,
    this.sizeBytes,
    this.createTime,
    this.updateTime,
    this.expirationTime,
    this.sha256Hash,
    this.uri,
    this.state,
  });

  File1 copyWith({
    String? name,
    String? mimeType,
    String? sizeBytes,
    String? createTime,
    String? updateTime,
    String? expirationTime,
    String? sha256Hash,
    String? uri,
    String? state,
  }) {
    return File1(
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      expirationTime: expirationTime ?? this.expirationTime,
      sha256Hash: sha256Hash ?? this.sha256Hash,
      uri: uri ?? this.uri,
      state: state ?? this.state,
    );
  }

  File1.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        mimeType = json['mimeType'] as String?,
        sizeBytes = json['sizeBytes'] as String?,
        createTime = json['createTime'] as String?,
        updateTime = json['updateTime'] as String?,
        expirationTime = json['expirationTime'] as String?,
        sha256Hash = json['sha256Hash'] as String?,
        uri = json['uri'] as String?,
        state = json['state'] as String?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'createTime': createTime,
        'updateTime': updateTime,
        'expirationTime': expirationTime,
        'sha256Hash': sha256Hash,
        'uri': uri,
        'state': state
      };
}
