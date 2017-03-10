void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  Serial.print('0');
  Serial.println(analogRead(0));
  Serial.print('1');
  Serial.println(analogRead(1));

  delay(10);
}
