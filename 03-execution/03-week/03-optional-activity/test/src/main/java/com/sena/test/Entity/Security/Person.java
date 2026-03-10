package com.sena.test.Entity.Security;
   

    import jakarta.persistence.Column;
    import jakarta.persistence.Entity;
    import jakarta.persistence.GeneratedValue;
    import jakarta.persistence.GenerationType;
    import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import lombok.AllArgsConstructor;
    import lombok.Getter;
    import lombok.NoArgsConstructor;
    import lombok.Setter;
    import lombok.ToString;

    @Entity
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @ToString(exclude = "user")

public class Person {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 60)//no acepta valores nulos
    private String firstName;

    @Column(nullable = false, length = 60)
    private String lastName;

    @Column(unique = true, length = 100)//acepta valores inucos
    private String email;

    @Column(nullable = false, unique = true, length = 20)//no puede ser nulo,pero es unico
    private String identity;

    @OneToOne(mappedBy = "person")
    private User user;

}
