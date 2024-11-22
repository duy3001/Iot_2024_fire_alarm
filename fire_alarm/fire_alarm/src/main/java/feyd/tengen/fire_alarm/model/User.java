package feyd.tengen.fire_alarm.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
public class User {

    private int id;

    private String name, username, password;

}
