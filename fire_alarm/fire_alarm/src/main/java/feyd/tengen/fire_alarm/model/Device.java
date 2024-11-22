package feyd.tengen.fire_alarm.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class Device {

    private int id;
    private String location, name;
    private int user_id;

}
