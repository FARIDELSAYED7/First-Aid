class MedicalInfo {
  final String name;
  final int age;
  final String bloodType;
  final double weight;
  final double height;
  final List<String> allergies;
  final List<String> medications;
  final List<String> conditions;
  final String emergencyContact;
  final String emergencyPhone;

  MedicalInfo({
    required this.name,
    required this.age,
    required this.bloodType,
    required this.weight,
    required this.height,
    required this.allergies,
    required this.medications,
    required this.conditions,
    required this.emergencyContact,
    required this.emergencyPhone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'age': age,
        'bloodType': bloodType,
        'weight': weight,
        'height': height,
        'allergies': allergies,
        'medications': medications,
        'conditions': conditions,
        'emergencyContact': emergencyContact,
        'emergencyPhone': emergencyPhone,
      };

  factory MedicalInfo.fromJson(Map<String, dynamic> json) => MedicalInfo(
        name: json['name'] as String,
        age: json['age'] as int,
        bloodType: json['bloodType'] as String,
        weight: json['weight'] as double,
        height: json['height'] as double,
        allergies: List<String>.from(json['allergies']),
        medications: List<String>.from(json['medications']),
        conditions: List<String>.from(json['conditions']),
        emergencyContact: json['emergencyContact'] as String,
        emergencyPhone: json['emergencyPhone'] as String,
      );
}
