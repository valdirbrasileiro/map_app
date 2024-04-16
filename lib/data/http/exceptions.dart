class NotFoundException implements Exception {
  final String messege;
  NotFoundException(this.messege);
}

class NotFoundConnection implements Exception {
  final String message;
  NotFoundConnection(this.message);
}
