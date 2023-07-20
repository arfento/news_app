import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static final apiKey = dotenv.env['APIKEY'];
}
