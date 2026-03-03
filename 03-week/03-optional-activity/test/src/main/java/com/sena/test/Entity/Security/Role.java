package com.sena.test.Entity.Security;

    import jakarta.persistence.Column;
    import jakarta.persistence.Entity;
    import jakarta.persistence.GeneratedValue;
    import jakarta.persistence.GenerationType;
    import jakarta.persistence.Id;
    import jakarta.persistence.OneToMany;
    import lombok.AllArgsConstructor;

    import lombok.Getter;
    import lombok.NoArgsConstructor;
    import lombok.Setter;
    import lombok.ToString;

    import java.util.List;

    @Entity
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @ToString

public class Role {
    @Id
    @GeneratedValue(strategy =GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length  = 60)
    private String name;

    @OneToMany(mappedBy = "role")
    private List<UserRole> userRoles;
}
