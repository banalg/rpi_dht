library rpi_dht;

import 'dart:io';
import 'dart:math' as math;
import 'package:rpi_gpio/rpi_gpio.dart' as rpi;

class RPI_DHT {
  num temp = 0;
  num hum = 0;
  int pin;

  RPI_DHT(this.pin);

  updateValues() {
    if (!rpi.isRaspberryPi) {
      print('Not a Raspberry Pi, generate random data');
      math.Random r = new math.Random();
      temp = r.nextDouble() * 30;
      hum = r.nextInt(10) * 100;
    } else {
      return Process.run('sudo', [
        'python',
        '/home/pi/horloge/vendor/rpi_dht/src/dht.py',
        '22',
        pin.toString()
      ]).then((ProcessResult pr) {
        if (pr.exitCode == 0) {
          temp = num.parse(pr.stdout.toString().split(':').elementAt(0));
          hum = num.parse(pr.stdout.toString().split(':').elementAt(1));
        } else {
          throw new StateError('error reading DHT sensor\n${pr.stderr}');
        }
      });
    }
  }
}