final class TimeoutConstants {
  const TimeoutConstants._();

  static const int connect = 10;
  static const int send = 30;
  static const int receive = 30;
  static int toMilliseconds(int seconds) => seconds * 1000;
}
