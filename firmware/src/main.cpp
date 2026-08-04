#include <Arduino.h>
#include <ArduinoJson.h>
#include <WebSocketsServer.h>
#include <WiFi.h>
#define DEMO_MODE 1
constexpr char SSID[]="CombineMonitor", PASSWORD[]="combine7500";
constexpr uint8_t COUNT=8, BUZZER=26;
constexpr uint8_t PINS[COUNT]={13,14,27,25,33,32,35,34};
const char* NAMES[COUNT]={"threshingDrum","strawWalkers","fan","chopper","cleanGrainElevator","returnsElevator","cleaningShoe","unloadingAuger"};
float ppr[COUNT]={1,1,1,1,1,1,1,1},rpm[COUNT]={}; volatile uint32_t pulses[COUNT]={};
portMUX_TYPE mux=portMUX_INITIALIZER_UNLOCKED; WebSocketsServer socket(81); uint32_t sampled=0,lastClient=0;
void IRAM_ATTR i0(){pulses[0]++;} void IRAM_ATTR i1(){pulses[1]++;} void IRAM_ATTR i2(){pulses[2]++;} void IRAM_ATTR i3(){pulses[3]++;}
void IRAM_ATTR i4(){pulses[4]++;} void IRAM_ATTR i5(){pulses[5]++;} void IRAM_ATTR i6(){pulses[6]++;} void IRAM_ATTR i7(){pulses[7]++;}
void(*handlers[COUNT])()={i0,i1,i2,i3,i4,i5,i6,i7};
void event(uint8_t,WStype_t type,uint8_t*,size_t){if(type==WStype_CONNECTED||type==WStype_TEXT||type==WStype_PONG)lastClient=millis();}
void sample(uint32_t elapsed){uint32_t copy[COUNT];portENTER_CRITICAL(&mux);for(uint8_t i=0;i<COUNT;i++){copy[i]=pulses[i];pulses[i]=0;}portEXIT_CRITICAL(&mux);for(uint8_t i=0;i<COUNT;i++)rpm[i]=copy[i]*60000.0f/(elapsed*ppr[i]);
#if DEMO_MODE
const float demo[COUNT]={865,215,780,2950,425,370,285,0};for(uint8_t i=0;i<COUNT;i++)rpm[i]=demo[i]+(i<7?12.0f*sin(millis()/1700.0f+i):0);
#endif
}
void broadcast(){JsonDocument doc;doc["protocol"]=1;doc["deviceId"]="CM-001";doc["uptimeMs"]=millis();JsonObject inputs=doc["inputs"].to<JsonObject>();for(uint8_t i=0;i<7;i++)inputs[NAMES[i]]=round(rpm[i]);inputs[NAMES[7]]=DEMO_MODE?((millis()/12000)%2==1):digitalRead(PINS[7])==LOW;String json;serializeJson(doc,json);socket.broadcastTXT(json);}
void setup(){Serial.begin(115200);pinMode(BUZZER,OUTPUT);digitalWrite(BUZZER,LOW);for(uint8_t i=0;i<COUNT;i++){pinMode(PINS[i],INPUT_PULLUP);attachInterrupt(digitalPinToInterrupt(PINS[i]),handlers[i],FALLING);}WiFi.mode(WIFI_AP);WiFi.softAP(SSID,PASSWORD);socket.begin();socket.onEvent(event);sampled=millis();}
void loop(){socket.loop();const uint32_t now=millis();if(now-sampled>=1000){const uint32_t elapsed=now-sampled;sampled=now;sample(elapsed);broadcast();}if(lastClient&&now-lastClient>10000){digitalWrite(BUZZER,LOW);lastClient=0;}delay(1);}
