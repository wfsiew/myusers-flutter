String vRequired(String s, String field) {
  if (s.isEmpty) {
    return '$field is required';
  }

  return null;
}