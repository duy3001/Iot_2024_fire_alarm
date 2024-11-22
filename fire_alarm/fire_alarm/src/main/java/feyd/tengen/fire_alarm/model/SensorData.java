package feyd.tengen.fire_alarm.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class SensorData {

    private int id;
    private String time;
    private String temp, humid;
    private int device_id;

}
