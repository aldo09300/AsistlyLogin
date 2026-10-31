enum UserRole {
  student('student', 'Estudiante'),
  teacher('teacher', 'Docente');

  const UserRole(this.value, this.label);

  /// Valor guardado en Firestore.
  final String value;

  /// Texto que se muestra en la UI.
  final String label;

  static UserRole fromValue(String? value) =>
      UserRole.values.firstWhere((r) => r.value == value, orElse: () => UserRole.student);
}
