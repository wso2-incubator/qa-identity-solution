import com.nimbusds.jwt.ReadOnlyJWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import net.minidev.json.JSONObject;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wso2.test.Student;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import javax.servlet.http.HttpServletResponse;

@RestController
@EnableAutoConfiguration
@RequestMapping("/backend")
public class MyService {

    public static void main(String[] args) throws Exception {
        SpringApplication.run(MyService.class, args);
    }

    @RequestMapping("/echo")
    Boolean home(@RequestHeader(value = "X-JWT-Assertion") String jwtHeader, HttpServletResponse response)
            throws ParseException {
        if (jwtHeader != null) {
            SignedJWT signedJWT = SignedJWT.parse(jwtHeader);
            ReadOnlyJWTClaimsSet readOnlyJWTClaimsSet = signedJWT.getJWTClaimsSet();
            if (readOnlyJWTClaimsSet != null) {
                // Do something with claims
                return true;
            }
        }
        response.setHeader(HttpHeaders.WWW_AUTHENTICATE, "JWT");
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        return false;
    }


    @GetMapping(path = "/students", produces= MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity sayHello()
    {
        Student[] students = new Student[3];
        students[0] = new Student("Amal", 27);
        students[1] = new Student("Kamal", 22);
        students[2] = new Student("Chamal", 25);
//        HttpHeaders headers = new HttpHeaders();
//        return new ResponseEntity<Student[]>(students, headers, HttpStatus.OK);

        return new ResponseEntity<Student[]>(students, HttpStatus.OK);
    }

}

